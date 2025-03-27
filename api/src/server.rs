use tonic::{Request, Response, Status};
use math::{generate_integral, check_answer};

tonic::include_proto!("mathoclock");

pub mod mathoclock_server {
    tonic::include_proto!("mathoclock");
}

pub struct MathoclockService;

impl MathoclockService {
    pub fn new() -> Self {
        MathoclockService
    }
}

#[tonic::async_trait]
impl mathoclock_server::Mathoclock for MathoclockService {
    async fn get_integral_problem(
        &self,
        request: Request<IntegralRequest>,
    ) -> Result<Response<IntegralProblem>, Status> {
        let difficulty = request.into_inner().difficulty();
        let problem = match difficulty {
            mathoclock_server::integral_request::Difficulty::Easy => generate_integral(0),
            mathoclock_server::integral_request::Difficulty::Medium => generate_integral(1),
            mathoclock_server::integral_request::Difficulty::Hard => generate_integral(2),
            mathoclock_server::integral_request::Difficulty::MitBee => generate_integral(3),
        };
        Ok(Response::new(IntegralProblem { problem }))
    }

    async fn submit_answer(
        &self,
        request: Request<AnswerSubmission>,
    ) -> Result<Response<AnswerResponse>, Status> {
        let submission = request.into_inner();
        let correct = check_answer(&submission.problem, &submission.answer);
        let message = if correct { "Correct!" } else { "Try again" }.to_string();
        Ok(Response::new(AnswerResponse { correct, message }))
    }
}

