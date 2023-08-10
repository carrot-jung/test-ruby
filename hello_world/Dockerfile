FROM public.ecr.aws/lambda/ruby:2.7

COPY Gemfile ./

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
RUN bundle install

COPY templates ./templates

COPY *.rb ./

CMD ["app.lambda_handler"]
