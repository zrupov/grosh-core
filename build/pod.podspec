Pod::Spec.new do |spec|
  spec.name         = 'Grosh'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/groshproject/grosh-core'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS grosh Client'
  spec.source       = { :git => 'https://github.com/groshproject/grosh-core.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/Grosh.framework'

	spec.prepare_command = <<-CMD
    curl https://groshstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/Grosh.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
