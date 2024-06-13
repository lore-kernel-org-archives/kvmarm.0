Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606F1E49B
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284854; cv=none; b=NwzcllBjXUCLjFjJtU/5RwoAWFC37AUNlO+GGdgMq1JIQVNZXA1T1hDJoaGrGS21mUF+Iw+OTwMCnZuffr0FDpjmJywT3fXF0McfmwVpqHOQiIkPaTXfCRuQ6U/+Xr1yGMGbVTxkw4b8FnQRJKduDZCa86yOpNkxjbDgz+1ANfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284854; c=relaxed/simple;
	bh=VcBbGGJep2ekDxbDczjcUBXrzrySClZ2EvXx5e9Xf/o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DCncMNqBUjUuAeM3ImRePWdqNhZAnZtFtimXO2Hmwkpi2qrikabGBQhisZ2gUHXEwlu07l8wE6OadiE+OvetTWfUmMM4ayD7Y43VsZ74TGITrRfhy4jye4qApY/GEcz2LNMFiRF46zGFYKJrvY5ZOFTsJsgqezS8rgP1LwPw8IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iyxb4znr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iyxb4znr"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627f43bec13so16962787b3.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718284852; x=1718889652; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=djDLCCB5OOx1VLqb+6JoETNcLYcEqA80QwW7FOqmwqw=;
        b=Iyxb4znrnPByZZkzm4llkXVqT+MVKhxMNicdTOYerlou45f+N60hm4GXEO0ZO+IaTa
         CTdodPumkeD2G3cSsbt5eJNpsaImwhyle0H/iyp/gbAHyzAzx7Ab3mcHRfOj6Lyv7TPA
         Z1TMTqyr5MC5/WelL4T6/mAjP5zF8CMzMevn8ccXJxghQEHxhc95Hq6cE/QDOhZ8Jp0a
         LR9TudrV4rX3T6mlZk5wpcxi7nK0gTvgSkUUMr5c/tI/iqdbDZeTEENirJ0MXjhrdTPM
         Zzce+PwwCYhkB0R9b+5HGDOYSMqtI4yx9P7CjYVlHfkrRZRqRK6NB7kZ07SOtP3KEvzz
         0gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284852; x=1718889652;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=djDLCCB5OOx1VLqb+6JoETNcLYcEqA80QwW7FOqmwqw=;
        b=piGUv5gH8DlNjLrzf5dcnU2hz3NVLIsdiE4XvIxW+iqr/Ye3Ch3bNgnL4HR1yntA1O
         /8Vu8gYEEK2ijyFRCczwj1oflKZkx0VPn1Kx6wDNXZ55md0/1qAgDEPfIC0TjmHEV8Nq
         nm//XHwYtBu0TqAj19Hqtk6ONTzYK29Okvr4uGbkpq3hCRUJBjDElBSyNxO1UkaOzhS2
         G/RsqVLhYihRUx1P1rXdyQ6S6YmXKLn0og+PV0zKHOkaIXne6KSKI9HcPhuoQqdcniB8
         MrvHolaX1cuLoyVpuS8TrOg0l4eaLkBltdAnEll7kLb5G5wq7+r6k5FwOa0II9dpyxVK
         UOQQ==
X-Gm-Message-State: AOJu0YzFM9If/JIdUtAcJhVA8KiGDFHn2gPtLMXrVKfPNmhACJum1tgI
	aWq0H1+qPnFTPCZC0+0fuM+byfllACaVDk0cGTE3TgICAMUAeuFKnpsV3nYVsnuUnMcIQ0F3UnL
	W8o6UVDtecOJCI/Ld7Sb8w/CAYg==
X-Google-Smtp-Source: AGHT+IFhIfr1FObnJYpja+B/zdb5Gn8y7cv54mQ+gaACvWPNtu2WXPb1DewkVyJUN9Ld/Vx8SGXfTP7sVxw4QmbJ3nc=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b01:b0:dfd:b66c:9565 with
 SMTP id 3f1490d57ef6-dfe66461ae1mr1390128276.6.1718284852106; Thu, 13 Jun
 2024 06:20:52 -0700 (PDT)
Date: Thu, 13 Jun 2024 13:20:31 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240613132035.1070360-1-sebastianene@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: pKVM host proxy FF-A fixes
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,


This series contains some small fixes for the host pKVM proxy code. I included
some of the patches that I already sent on the list as part of this series
to make it easier to keep track of them.

I verified the functionality with OPTEE as a TEE-OS.

Changelog:

v2 -> v3:

* small fixes on the commit messages
* applied the Review-by tags from Sudeep. Thank you Sudeep !
 
v1 -> v2:

* applied the feedback received from Will on the FFA_VERSION patch:
  The spec requires that no other calls to be issued prior to the FFA
  version negotiation and the current change reflects this. After the
  version negotiation phase is complete with Trustzone we will just
  return the hypervisor version.

* corrected some mistakes on the FFA_PARTITION_INFO_GET patch:
  - don't trim the number of bytes copied from the hypervisor buffer
  - introduce FFA_1_0_PARTITON_INFO_SZ definition
  - simplify the logic when the input flag is specified 

* collected the Ack from Will and embbeded it in the commit - Thanks Will ! 


v2:
https://lore.kernel.org/all/20240515172258.1680881-1-sebastianene@google.com/

v1:

* previously posted FFA_PARTITION_INFO_GET patch here:
https://lore.kernel.org/kvmarm/20240411133249.2134696-1-sebastianene@google.com/
 -> minor changes from the previous version, look for the current
    ffa_version in the host_buffer structure

* previously posted "Fix the identification range for the FF-A smcs" here:
https://lore.kernel.org/kvmarm/20240322124303.309423-1-sebastianene@google.com/

Thank you,
Sebastian

Sebastian Ene (4):
  KVM: arm64: Trap FFA_VERSION host call in pKVM
  KVM: arm64: Add support for FFA_PARTITION_INFO_GET
  KVM: arm64: Update the identification range for the FF-A smcs
  KVM: arm64: Use FF-A 1.1 with pKVM

 arch/arm64/kvm/hyp/include/nvhe/ffa.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 180 +++++++++++++++++++++-----
 include/linux/arm_ffa.h               |   3 +
 3 files changed, 152 insertions(+), 33 deletions(-)

-- 
2.45.2.505.gda0bf45e8d-goog

