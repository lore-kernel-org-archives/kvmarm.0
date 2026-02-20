Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270832045AD
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771588625; cv=none; b=eobFwchB34eW45SUbvWfRJ66eFnHWC4fJLGhaMT/z388ANKOTC9MFYD+IRZ1csef698dofV1Gg3Ntau6xClHSYjoExcHmun2/SCtcp/+VKVPiNXH2lxAms5+dyYqRUXaOqQk9FP1tCeHxB4zG871O5w5b+LHxXReNhyQRauZrEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771588625; c=relaxed/simple;
	bh=LznsEf5nGtAtKYbhk+cxdbpZw1ShTWQcE+HR8zkXmEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=c8irYta/LTr/zuKe1fjeteD8C6NLawZynkXGmELdcdBprDpyWY3OImsv0refEJKHoOCC4SvMinr79sa+B3nq0VnuWsG5AM5tiTNCChhrFXBLg9HIjDjedOg+9J6e0e/387wY5tnhs+26cjp6zFa47dQFkA+sxB5CFJPKudZi8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RdoXMv2l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RdoXMv2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771588623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f9Iq3P1+3CvjmPUgtUDKxrjal3kc2Xn/2NZQuVratlc=;
	b=RdoXMv2lx2UKpeD9KEf4yCnQuAg0SQwGcL619k7avbfClf27PhPofQO/S7Eox+PQLgHeba
	2l3yAQPjcbTEOLHbgW76XEPVCTT/8MRer/CvjWNrVHjj2e5mwrj7WPv0FdJTE+hnalZ6jt
	as5XSvOWyK423GCwzt3b5I+KJRT86hc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-GMz1q10EOzyLNZYHl9o0Tw-1; Fri, 20 Feb 2026 06:57:01 -0500
X-MC-Unique: GMz1q10EOzyLNZYHl9o0Tw-1
X-Mimecast-MFC-AGG-ID: GMz1q10EOzyLNZYHl9o0Tw_1771588620
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so24654545e9.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 03:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771588620; x=1772193420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9Iq3P1+3CvjmPUgtUDKxrjal3kc2Xn/2NZQuVratlc=;
        b=l6iUy7Wdgv5RkaFVbWkzQbaVuYp6qt+WqJlIbdV+nhVxWLGEHDTI9dU+jWcgm7gkhr
         RRmZhflzflraphQz9zXT0nNj4IzBAaIHqF7z+Qg5oiCxyTZteWy0JrqJTUcwgSCrttqP
         Wq+VEHAK6XXftT2ZEfvIKUboVp4TMJu4iFXN9ivnJYxmvcdCgx3c4K7WlfUCelRWVbQR
         BqJKdY0/CX/tbqnLsVhgkw6vxg30eniXopvc0OTQ+KuMJoWbZLkldKAEeiDFCMQrrDdF
         6/CkbPOt0FIqX0pI7ai2qwYZlu9sAyM47HIERBNl8JwlGKEAqtlOZzmb6AIoV/YhtEfB
         QrbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ43MRyMuGz93aN9w/IcyPU8pD6sBuNVKRzKi6EkjZYbl8RT5UxVqFEZarIHer0HcHm0m5ALs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeDWzlAKRwQd1t0hfipoyJCsEBmn6QRUMtT85EuVUNSPQnD0j5
	KtRRBsstESLn8jNZYkziKo2aKQtwmeorCR4Nee4IbS9zChBQ++G8SkO1rXh0psxD+VjX3NXt8JR
	EZ+zFlsBtgYUwtjodWPbZTsX2WvW1D9/azVYiz8EhwZpjIJVqSdKksLzvvw==
X-Gm-Gg: AZuq6aJu8W0Zrv04AOI8kUdB8a19uhfnOJhkEJUH4vNPQ8zwQAUllOwnNpanuQPAmd5
	tkZoZtbVOY+OeqWGu+urNpAj+bGiv2rzVQqvc6MoizR0eSRR8LR2dlmhC2LE9cx/qCKoXa52mMQ
	vXyWDJXUCQmqiAfS0zXvrBronPf9kZB8UROwM+IhauRYT5Lu351Rp8Yx2OW9XwZnJlploO5C7cR
	30txShzAQMBF1gPzQkKUBL70Eg+5+nvzwUAfCSyXN07uBsc5yA693QxRv7o1fImRIk5oZwySBp/
	sSOj/6G0VzBfkNVYOr9KzHwi/1C6Zo7lRO0E+BECKidDJqLKVDIv049Peh7TdyfiD1X1iKI98uO
	0t2kGLGGUCYDRx70/o7vmWQsSUvrZ0BHBPB4nGlZbU+Azp6NhSW2jAupT02Qzn4W+sCr7m/nfFN
	hVMWRJZvGb
X-Received: by 2002:a05:600c:4fd5:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-483989ca4e4mr142430055e9.0.1771588620352;
        Fri, 20 Feb 2026 03:57:00 -0800 (PST)
X-Received: by 2002:a05:600c:4fd5:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-483989ca4e4mr142429585e9.0.1771588619823;
        Fri, 20 Feb 2026 03:56:59 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316c2aasm66102295e9.0.2026.02.20.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:56:59 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: peter.maydell@linaro.org,
	qemu-devel@nongnu.org
Cc: eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	qemu-arm@nongnu.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v6 0/1] arm: add kvm-psci-version vcpu property
Date: Fri, 20 Feb 2026 12:56:55 +0100
Message-ID: <20260220115656.4831-1-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ntFZfHSZWlaQPtF9FhYWmsrPo4yJF_LmLgB8w2k4HOo_1771588620
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

Changes since V5 [5]:
* incorporated feedback from Peter
* dropped patch that is already upstream
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
[5] https://lore.kernel.org/kvmarm/20260211153032.19327-1-sebott@redhat.com/

Sebastian Ott (1):
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst | 11 ++++++++
 target/arm/cpu.c                 |  8 +++++-
 target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

-- 
2.52.0

