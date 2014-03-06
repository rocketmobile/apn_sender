module APN
  module Connection

    def connection_pool(app_options)
      @pools ||= {}
      @pools[app_options[:app_cert_path]] ||= ConnectionPool.new(size: (pool_size || 1), timeout: (pool_timeout || 5)) do
        certificate = File.read(app_options[:app_cert_path])
        APN::Client.new(host: app_options[:host],
                        port: app_options[:port],
                        certificate: certificate,
                        password: app_options[:app_password])
      end
    end

    def with_connection(app_options, &block)
      connection_pool(app_options).with(&block)
    end

    # pool config
    attr_accessor :pool_size, :pool_timeout
  end
end
