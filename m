Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4EB3EBF3D
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823858; cv=none; b=YfK50rkI/Sn64pklYwCOgQVNlb9W4Jg8rk2la0x2/4kc2vLJLfjSbPvqbXsGsi/kgUzHy2Em7FrDIg1Q5tR/DHSmq6XtADLN5dIn5M7T49nopNs5287wx4YYMlu0URFcCfEJFrwSrxrKzoIRFex1DdJYNA0IfP/ASDpKoiTCOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823858; c=relaxed/simple;
	bh=bAROrVJ8MKepFtr2O0oRZmslbw+3MGUWWagMBNa6Q2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=fXUsWxB0HDCgsFZI+nkkFRnc/P/0mSH0ePQkdeH0XLTZKNl4h3yya1cwcn9AjqNCH4RZzfwktPr1DNmKZdiiUohPMY/N3+pNV8c4b5+Un1gH6TXH7XlnpDNTmW7yFbC6KQMQssSYoDtB+WUMyDFsmRMlRyucHHrNTh4oiQH2mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8MqLP+b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8MqLP+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x2E0s+P8sKjuC6cwmuu4hJ5r1IkHeeGVxzBUO13i7RU=;
	b=S8MqLP+bzkE9PUYmtcNZoebTfoDc7HCyv8eoC4VelLcrzNRuGw8LWYkVifWymMs4YY4t+7
	DPTEmEfhDHjLPUdWgRbq6oxr2NAe9YrG7d+SNB0az73kDc9Tm7yGRimbyW84HmRXVePdrm
	rq8IjdcVnGbnXMkqjargFbOSGtcgSlo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-fArFwG2LPzG7FjsuVac9Yw-1; Wed, 11 Feb 2026 10:30:55 -0500
X-MC-Unique: fArFwG2LPzG7FjsuVac9Yw-1
X-Mimecast-MFC-AGG-ID: fArFwG2LPzG7FjsuVac9Yw_1770823854
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435db8ebc98so1891958f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 07:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823854; x=1771428654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2E0s+P8sKjuC6cwmuu4hJ5r1IkHeeGVxzBUO13i7RU=;
        b=SN22VR1Q6L27HpTLtIPtlq9rU+SmC1a/WKeJqBQ3zXTyw/HoRkO9/ITjnQEt1S4Ie2
         CAdkX16EmLpfM3LX6MVBiVS0s5gG9OMn5HLceHiOg0/p8NqNYNuxSgQiUYoh8Zqdlgvv
         jIewbpswDN//9OpZLScCiNvN0+lQDq2Ny1NreDFed5qFFz+uYjIPIllNW615uRcDiSSf
         rBg79yWQv6clBF7NNqB5QbRiyajGhZLF8jgwbdJ2tj0BLq6MAugLScgsgWSL1ZVepH98
         b/rex/F/HeiW2Rsdidea8dVOZV4Xw62SyRZHYZ1t6+e3OhWAJ0CV9Wby5cecpQago9L8
         usRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1sjx8p5xwJlqGnV3hoZblgRczOEzx1jtxmG7PKawPCXf5o5mHNY3rRvzHuVoIAvK+9o6mdG0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpPxAgcMV51x+rTD1m6gLGBt1s/Su/xkpGcSpjhlmr7nhaOM/b
	lKlDpKt6Dva2FNCQVSwUJPS2SeUGDtA7PjB4DyTQMR6YZ+6r48UF2oaAllOUXJqD0y7p71QGJAP
	jN7YeMiAW+WWR8A1vCTwsg0Kc1QirRiq8lmiUBKybecWpgrmbgGM3i2Fymg==
X-Gm-Gg: AZuq6aKWxHz4bn3lGnRoBgdS4p2ix7TCTcObOWNibLGoOdk+7Bb4wqrkkex1eCzkFzq
	BTayZvO7jDOVSWWhMTxp/nCF7w1qiC620J0am/doqjO5Ns6tH4SMd3WGVDgawA53aGVgkIUaZ/K
	674ChJYQNBYiwJAv0adqSvHwNZQYdHjD9H1JN63QsRZdKIq1wBdHKKyCiLDU+h0WxH3MJLYTjY8
	XkmEnl/HF7gfhEknBPMQ+qLCIxvJOAfY35hgYf3pLD2ogbctJmboRYmh4lrvT4X8OCcK7AKckNM
	VlCuFIxRoFkrk1XGaXHCWCuJbShphsYeKN0nZlo5vSY/oN1v6up1hurXjUojFoxqbg99RzMK+wD
	jTisuvSWnLTv7t8PP/YD/xRM1PfhUIYJLLH0yTgmzL60VJNYZb/yj7SeQHX/orTpzETrhC12ALt
	+KX5+jWtXS
X-Received: by 2002:a05:6000:420c:b0:437:a49:137d with SMTP id ffacd0b85a97d-4370a49155bmr20114264f8f.21.1770823853627;
        Wed, 11 Feb 2026 07:30:53 -0800 (PST)
X-Received: by 2002:a05:6000:420c:b0:437:a49:137d with SMTP id ffacd0b85a97d-4370a49155bmr20114220f8f.21.1770823853091;
        Wed, 11 Feb 2026 07:30:53 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:30:52 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v5 0/2] arm: add kvm-psci-version vcpu property
Date: Wed, 11 Feb 2026 16:30:30 +0100
Message-ID: <20260211153032.19327-1-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jgg4wuDARCVEaZqWsvTJHYLPqXlPKCb4B4it-QpWxr8_1770823854
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V4 [4]:
* incorporated feedback from Peter
* added R-B, T-B
Changes since V3 [3]:
* changed variable name as requested by Eric
* added R-B
Changes since V2 [2]:
* fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
* removed the assertion in kvm_get_psci_version() so that this also works
  with a future kernel/psci version
* added R-B
Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
[2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
[3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/
[4] https://lore.kernel.org/kvmarm/20251202160853.22560-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst | 11 ++++++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 65 +++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 1 deletion(-)

-- 
2.52.0

