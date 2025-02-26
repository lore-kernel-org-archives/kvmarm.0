Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C842571B6
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606541; cv=none; b=Klkh0aRsGKsjpaV77Yej5Jk3pcNBs6+i7I7QoNfmt4tpuvr/BN8kirzuDpGXZiBB3TiDBIg0szAhG/M9wrgnYNA5UrE3HA/TCOaLaccEvGjskojS8yrBlCnSTWBAU2sAjTb+kidgW1TIgqIPdLMFLR0/DPPX8hnkegFolsOxmuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606541; c=relaxed/simple;
	bh=Jn/WvMX/Yq1lt2R6na6j/1FxGL5KuA+L1lqiLVHmSu8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IAYI95qIyFv2lBv9m1sndAfFr98F92JCMGRplsdBr2CQ7O4XF2DEjtbjghU62nOJfFP/h/S87PlYRqIo1BIX4rt7cO2FG88Ozw0K7t3kDd3QkZkVtKalayJKHLW9uQPRwdy/Yz8+fN48yHzxoWlqYwkuoCbq+cONuO4O8cX7ra4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vqW4QnQS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vqW4QnQS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-438e4e9a53fso1711705e9.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606538; x=1741211338; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N3L7AviT9xfQLqg1ssfgAz/hdS2zhgqxmqkg15ECEOI=;
        b=vqW4QnQSt0YeoJkXzSTd1+oIyp2VhLKcEsU6nCm2zy+V4jZlIVn3+DNIkQUVH4DLuv
         JwO8PIbbhIe/wZGKss6KZAcm1k0CGECqpEJsTdmh8qRF+WvRV2kFIydhhMxXRioRrQY3
         vON+BBhmc4i3MrY9tcy2aO/MNiTqehj61La9h+mnXhaNbWxWGQYFE76dlLdQEw0nYeCW
         WYPjKdookfAkaeHburbJulX/BWPQqVPMIEu/vAMUGV1WwaasM7t9v0SX2mGczUNNEuzc
         27LgA1u3rRW3UbFXFYdCwAxDjuXiJaWeBUK5xIizLQvC1ZtpTuXOMkMTtJfpdePuWjWf
         ggEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606538; x=1741211338;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3L7AviT9xfQLqg1ssfgAz/hdS2zhgqxmqkg15ECEOI=;
        b=ETUk0wWeAFiu1L2txT0cJdIpIOMHnzeNL56d6Vj0DmTvr3qx/ONptALe+/YeEI65P4
         3HIeyAU/ZMB5kKkwZwcd1a/R+4Wu9HDfyP76vJd0UmpQjbdTQoKIo1IgZsw5rq8oRHhq
         8tGu+ePGKBgACT4F3jegPvpVtazY4SIhcmFvSGD2iHIpCpBnvmzBbNV78TWr84dWHIEZ
         veGOioj2wPS4kQoezs3UyFUwV6Rzu4NKCnHggG/uzkzD8ohW1kMUCgKDIyyfQKlCGOta
         fj2wPgS19wDbZ59hQx2pDlEtk7VSb3CjrHmih1OO4ue2caoqNd9ZQK1fAi1IcK2VDe07
         xwhQ==
X-Gm-Message-State: AOJu0YyJRPMiRWEXog98OCGwgeExAg5OrLGOp5yFba6kZtgBG014O3PJ
	Bz/S2O0MxENb4ekCWJxDuEuPRwco0Sg/z5LT05rolEyokCX0PilcofTfHptBTCUDfmJ/z9g6l7Q
	OouhhzaAGi7J9KXJR8luTY7Ffyw==
X-Google-Smtp-Source: AGHT+IEA6UUUAJ9uECoMio1DestFhpWyyz+Ts8rNvs4mLLNlC2cQcJ944oVmRih7EryswtDmHignbakfjjpmw8U0FII=
X-Received: from wmgg7.prod.google.com ([2002:a05:600d:7:b0:439:67c6:5642])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5489:b0:439:86fb:7326 with SMTP id 5b1f17b1804b1-439aebb5558mr165297465e9.22.1740606537893;
 Wed, 26 Feb 2025 13:48:57 -0800 (PST)
Date: Wed, 26 Feb 2025 21:48:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250226214853.3267057-1-sebastianene@google.com>
Subject: [PATCH 0/3] KVM: arm64: Separate the hyp FF-A buffers init from the host
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hello,

This moves the initialization of the hypervisor FF-A buffers
away from the host FF-A map calling path. If the hypervisor
cannot map the buffers with Trustzone, it rejects any FF-A call
when it runs under protected mode. 
Other than that it moves the definitions of the ffa_to_linux_err
map from the arm_ffa driver to the ffa header so that the hyp code
can make use of it.

Thanks,

Sebastian Ene (3):
  KVM: arm64: Use the static initializer for the vesion lock
  KVM: arm64: Map the hypervisor FF-A buffers on ffa init
  KVM: arm64: Release the ownership of the hyp rx buffer to Trustzone

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 56 +++++++++++++------------------
 drivers/firmware/arm_ffa/driver.c | 24 -------------
 include/linux/arm_ffa.h           | 24 +++++++++++++
 3 files changed, 47 insertions(+), 57 deletions(-)

-- 
2.48.1.658.g4767266eb4-goog

