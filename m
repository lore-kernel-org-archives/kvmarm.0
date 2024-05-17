Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E484F887
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951906; cv=none; b=m1Bu8oJgESH3xVorCYZXblPnq0fdXRqJkjGu/lu5BJUjghsea/iGdel/kNFFTD7nov4d6nj4zcihGscGNU7DKUQAiCTccwEebRRhnshxLIsIlRUYgvuSpt/ItwT+k0QTiCS7ZFqmn4+L4oZLJwfXCtdxhRVgHIiWec+6hf9diWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951906; c=relaxed/simple;
	bh=pAv/j+sXdR1HNlBwRupJ7jOFRVOvLsxbHUilHPTw2Pw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LMaSaAH7cZiMR+Qr4EzqipwNX0ZpW8lc9X23ihjZMBg9MLWqAp2YDKVGuogle6hYkU14CE2XcQxqcyHUWERkyxSqjF5TfIjOV65sXogxgSidXcJc5Z/2NyLXZh3UXn1P2ox1Ey+Pz5PvIoowGclHnqFpG+YzdbQicbHnth8kIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3z/HsQz+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3z/HsQz+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be530d024so162584587b3.2
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951904; x=1716556704; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EyndmrY+kykskyH37vAoPH6S+/WfAXQJJz5aqIGyAn8=;
        b=3z/HsQz+wwD7I2rRJHU9WADj3jMBDbgWU/ZBbAyLKyDyfo4qRZ0qZX1DPxQ6IqAlRc
         wg7iJqreeJ5aeSPhRj2FDfCtKQphI1S0CG/GwVxDoZe1vLJNCS7Bx5osFUR55twNlfum
         /I4BXG1WFJXb9hLWbbgerhShFg0NDxIhoF7PyaRd/X97p4vSoKaTqfwex9i8xZS666XZ
         R8uwagKtkmbGg0Udw753zjsxexmLkTATPrv2aTw+XsH9QUn9S78DIq/6AR5N6olQB5NO
         UUBZhVo4MPUkqwaeAP7pHYjqQKmxwEiRKAPAk7DAnXbqinRtDvHrA272TTlm8LE0zjJo
         BCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951904; x=1716556704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EyndmrY+kykskyH37vAoPH6S+/WfAXQJJz5aqIGyAn8=;
        b=K8PXig4mifFwigVNepWMBQlJII/a5VMlrbcTrpiI8vaBAwkE7kOy8YqXvC0mfB0733
         8meYlSgIcPVBvOYarAJ5CSTsXM2fchfb3ccZx0bPrVyKjkGPn5D/o0KXeunjVkaTihLB
         2cpR30+VU7OOraQ9oGdE9gnHHb+UUQvvl1jypH+41QsywnIGVG6yMfPaPaeqNBZUjuhy
         16PzMXG+LAlh5XPHAvxfbqIQkFRSkUKAYfrf8OvgYzip+BdwVIIWcjrRMfmQy/NuZSlj
         sVy7JdEuttQEx+KsIQKO792QVzMFx/CzjJkmr32qO4C4rw1c71LWd7WlnJOeJ02kusNO
         AOJQ==
X-Gm-Message-State: AOJu0YwZ4I3KztMvfOy450fFQAVAWLoi97zGLoYz50IEUYB2JZFoegw0
	tOvVS2poVh1EMCpDsT8moWkJcczK7ZYMDsX/Yb4Exu5DE4hfGkivHw+3t4dv3gayenVjanCu2Gn
	dS6nFEuIkMPNefzCn7EBIImfmrcN1w3LjAGM8KxpFZidwGzjFuYcw3ooRADg6C2WxnvW4s3U7rk
	yo6TfezPRiPaFZefoYMBrVass5q/Q=
X-Google-Smtp-Source: AGHT+IEm8tlKnEAg0DLPwscOUvLJVUvPUwKX1dSDxbJCUnPDGFEGHUpfCvo+7UcR0i9xLzE/sD17LINAsw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:6d53:0:b0:622:befc:2e97 with SMTP id
 00721157ae682-622befc2ee6mr41880237b3.4.1715951903959; Fri, 17 May 2024
 06:18:23 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:10 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-4-tabba@google.com>
Subject: [PATCH v1 3/7] KVM: arm64: Specialize handling of host fpsimd state
 on trap
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In subsequent patches, n/vhe will diverge on saving the host
fpsimd/sve state when taking a guest fpsimd/sve trap. Add a
specialized helper to handle it.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 5 +++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 890388c17c3e..d15272445db2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -321,6 +321,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 }
 
 static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu);
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
 
 /*
  * We trap the first access to the FP/SIMD to save the host context and
@@ -358,7 +359,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/* Write out the host state if it's in the registers */
 	if (host_owns_fp_regs())
-		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
 	if (sve_guest)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2b5af10cdf1d..935f3db245e9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -203,6 +203,11 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 740360065d7d..6a6d69c3c58a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -273,6 +273,11 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

