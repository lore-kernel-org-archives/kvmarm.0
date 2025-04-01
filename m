Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E6D20E01B
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527175; cv=none; b=mLoK1Kl+hjZMLsN0F769X9nS3YoJ/BeY72JJbxXzcSBhgaqnU5iIap6vDMWDCdIhgYFZkO5FE4fzdRnzvTm5o+gknbJyXIIlQyV2lIjf7Wce7ARrXYkNVC5yrSLih4cre1RPHLzc78yL0/UjFkbvs0O0VRoBtOeiZ84VFVut8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527175; c=relaxed/simple;
	bh=/ojOGjSENscu9Pb3+EYr5PYhSwGXxXZJjaejcHeP+sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9PjM+lNQRv+XlXO0HJbYVR2SMlhySl51AI25wGYytHnhzdUVNhi2j3T1ir/ubQfVeEM0W8Tvt/hiWYj+OV9cY5MIw0108LRHSKIZzETmq1IzSMIPwU/KkYtMRsYOdAXBnh6PbsynoxKyy+/eZOVzBljB5ATxiLDsUvAVsI4zIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNRpYFW2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNRpYFW2"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2279915e06eso119834225ad.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527173; x=1744131973; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDtkvMqdi74R/fuGRWaxI6Vx86s77IjYzoT0QepjNQ0=;
        b=UNRpYFW2oyJaN4fXIW8aekCQhSKX2IH2YCTCIJYh0WKPA5icEuv30zLvN8s7G/ZpqA
         6eFPuQKJ/twFGPfevKKv9cvw4/d9VQez6L8f8IjZeXqdZJjodKhrUBpBzC3qKmgOEF77
         KGRHuO0QAAL/loi5oQzUlPa4mSyjcjPUgKOmZDVWi0SBuodXjl4zIEG5d0145D8NJqIH
         uzYXgsQMwJvx45BQAOYBKWkK29M7qJtw0R3VEZGvGf+uW6fIEmma9Sngf87sfyyM0BXs
         FS4fnjXaQxqsGMm/OleFTn2Nt9D7UReho9sCIR90OM4iK9WQ47CiK7hJOu7VNH8x/mPJ
         4g9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527173; x=1744131973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDtkvMqdi74R/fuGRWaxI6Vx86s77IjYzoT0QepjNQ0=;
        b=t6+mRuCuxaIwB5nZYqk3KvSherXllY3HAhTQQPAGwmPXLDuBBdZGoYASp5XqucjKJy
         26/X4T3WpGAi5v45FrC70DeP1vgZifKqcRjB7a5FQUogwuFdbOnFzc3L71iQWuG+6VnG
         YGyk4lXioGcV+tOI0wN1zQ7CGN2e4WJ+zwTrqjLfmJJfynDIyC3UvRuD5oFlCPb7+0o/
         GuFZ7/LYl2plSxpbou9i6S4fi+C0lrf4HTKPobLJHAy1igldzxi2cqAl1iSOzK4rzjIZ
         Y2/zbqhC973bePMFO5544Nu7VCGljShFmhTiEj24KVx3IHp5dq2MTSVYfjoDvUqo20Tw
         /c1w==
X-Gm-Message-State: AOJu0YzMK3OH1AVOZUVmMORZiNXNDh4Kg7yoOuc1qDHrmtWmK8MEtxos
	QTWRH/an7wy1Mjz5M6fP8p/uIRcsXGI65SjeOjI54H6WjAjVYYTPmqgDjQ==
X-Gm-Gg: ASbGncubtAr+vrpTCUguSRvQGydPbetEn4DC12QyRIbhadTH9muM//yjxnfNT0LNWox
	9Jlkk02N/3r0zT3CYSADVMwHY2iikhG/6Fte0bKleCPx4eQmwul7HonPX2tmZ0FmqZA7MvW/KuX
	YuObcBN0r3kwKtHEe2B/awgtipWyw4u3BOf+n656B3b6VHfbDaXA3iVRGng5Vrv5wcv2NTgW3iR
	oZsWvEALCfc12g82AqLDmR9jxhONxks8Dk9S+uULOZzMYPh1i4jLjrnVQXzR3LULiU/9SXyyc+s
	9pLu6pSs6oa/U7TfCd4Yy9UEGtJDh8jvF1XH65zI
X-Google-Smtp-Source: AGHT+IGVQaPozKtnYFtEaxGdcDkcmfSHjENYsZlMxOjS55uxLWGM2YiQ/vVbzslmIBGst/k5j79maA==
X-Received: by 2002:a05:6a00:3a13:b0:736:491b:536d with SMTP id d2e1a72fcca58-7398046fe65mr22142417b3a.20.1743527173462;
        Tue, 01 Apr 2025 10:06:13 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:13 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 4/7] KVM: arm64: Forward guest CPU state to TEE mediator on SMC trap
Date: Tue,  1 Apr 2025 22:35:24 +0530
Message-ID: <20250401170527.344092-5-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When guest makes an SMC, the call is denied by the hypervisor
and not handled (ignored). In the presence of the TEE Mediator
module, the SMC from guest is forwarded with it's vCPU register
state through tee_mediator_forward_request().

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 arch/arm64/kvm/hypercalls.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 569941eeb3fe..cb34bb87188c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/tee_mediator.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -90,7 +91,10 @@ static bool kvm_smccc_default_allowed(u32 func_id)
 		 */
 		if (func_id >= KVM_PSCI_FN(0) && func_id <= KVM_PSCI_FN(3))
 			return true;
-
+#ifdef CONFIG_TEE_MEDIATOR
+		if (ARM_SMCCC_IS_OWNER_TRUSTED_APP(func_id) || ARM_SMCCC_IS_OWNER_TRUSTED_OS(func_id))
+			return true;
+#endif
 		return false;
 	}
 }
@@ -284,7 +288,14 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		WARN_RATELIMIT(1, "Unhandled SMCCC filter action: %d\n", action);
 		goto out;
 	}
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (ARM_SMCCC_IS_OWNER_TRUSTED_APP(func_id) || ARM_SMCCC_IS_OWNER_TRUSTED_OS(func_id)) {
+		if (tee_mediator_is_active()) {
+			tee_mediator_forward_request(vcpu);
+			return 1;
+		}
+	}
+#endif
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val[0] = ARM_SMCCC_VERSION_1_1;
-- 
2.43.0

