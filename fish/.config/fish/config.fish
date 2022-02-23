if status is-interactive
    # Commands to run in interactive sessions can go here
end

set PATH ~/.local/bin $PATH
set PATH ~/.fzf/bin/ $PATH


function deploy_lambda --description 'deploy lambdas' --argument-names lambda_name lambda_env
    docker build -t lambdas .;
    docker run -ti -v ~/.aws:/root/.aws -v ~/.ssh:/root/.ssh --env LAMBDA_NAME=$lambda_name --env ENV=$lambda_env lambdas deploy.sh;
end
