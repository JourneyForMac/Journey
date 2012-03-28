platform :osx

dependency 'ASIHTTPRequest', '~> 1.8.1'
dependency 'ConciseKit',     '~> 0.1.1'
dependency 'SSKeychain',     '~> 0.1.2'
dependency 'SBJson',         '~> 3.0.4'

target :test, :exclusive => true do
  dependency 'Specta',       '~> 0.1.4'
  dependency 'Expecta',      '~> 0.1.3'
  dependency 'OCMock',       '~> 1.77.1'
  dependency 'OCHamcrest',   '~> 1.6'
end

post_install do |installer|
  installer.project.targets.each do |target|
    target.buildConfigurations.each do |config|
      config.buildSettings['ARCHS'] = '$(ARCHS_STANDARD_32_64_BIT)'
      config.buildSettings['MACOSX_DEPLOYMENT_TARGET'] = '10.6'
      config.buildSettings['GCC_ENABLE_OBJC_GC'] = 'supported'
    end
  end
end
