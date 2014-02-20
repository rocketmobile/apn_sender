module APN
  module Connection

    def connection_pool(app_options={})
      @pools ||= {}
      @pools[app_options[:cert_path]] ||= ConnectionPool.new(size: (pool_size || 1), timeout: (pool_timeout || 5)) do
        APN::Client.new(host: host,
                        port: port,
                        certificate: app_options[:app_cert_path] || certificate,
                        password: app_options[:app_password] || password)
      end
    end

    def with_connection(app_options={}, &block)
      connection_pool(app_options).with(&block)
    end

    # pool config
    attr_accessor :pool_size, :pool_timeout

    attr_accessor :host, :port, :root, :full_certificate_path, :password

    def certificate
      @apn_cert ||= File.read(certificate_path)
    end

    def certificate_path
      full_certificate_path || File.join(root, certificate_name)
    end

    def certificate_name
      @cert_name || "apn_production.pem"
    end

    def certificate_name=(name)
      @cert_name = name
    end
  end
end
