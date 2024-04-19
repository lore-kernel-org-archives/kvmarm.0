Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4DF47F6C
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513590; cv=none; b=DTu7QYnC2RPovkvlbM4LVASje/+oymcxebqFtSLf/d7Ho8XQLaW6vecwqIp73VOkorLxIKA61RYynZTznQky2nCo48zGUwRnIKHz+RuG+tYwviDGcXThX+dME6ebOhAjSY4NIwyprZfQwb7rwB50DLWqdgchWn5H+zoQwQn9rIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513590; c=relaxed/simple;
	bh=Dd1LNwy9pwRnnX0jkyDj7F3suG2nM3tlrS0jD6ZvufY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBmH6QQQN9Jh79reYal0D1XBQiqAAZDGVrXN9L3e0Uvi+k6g2z8AiB1XuAD9V17Bhl5mmYbLkZqd82XUBK7RXIrwxYYZPC0k8MEJXbiA0QeG8+AxvGjOfejxFWzfcU6fueE6hm5Dcj5UlD08orS0E/KJ3xB3WWA8CngWGl2ZAqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rLA1sf9T; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rLA1sf9T"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ab00d8a2eso32618907b3.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513588; x=1714118388; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0z5AWgfriCkyDPhI6iidH841EpkLLrOcMdlZW3FsiQI=;
        b=rLA1sf9T01gnEyU7Jj6s10Cnf+7LpvLbz5/K8Ncd/pqC2SlieIQhFwo60u+31ZzQ3Z
         vs7nHoajHDiubWe4Pslc2pvvn1f2elOmiociHiiFsznJNv2S4TDajDo8fKnl9uGDUiHX
         uEAKLmmbRPUt4D7vp+PzeXQIxOlGGP+k35/X8UD7l/JqDmvfbcgVlYnkmRnCh2e6B/9w
         L+E25pGUnCJecFFJvx4pAH3zgD36sIBOyv0VMj3dq0nWPKHhA5IfS3uwdfoBeuDjE2z1
         5vaY34vHV65p4WyXmEuQmuZc+229vtQoz4Mgua3DboayFDQ6cB2KFjm2C7fXsFKRNwuo
         IG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513588; x=1714118388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0z5AWgfriCkyDPhI6iidH841EpkLLrOcMdlZW3FsiQI=;
        b=U1abRiwEbdUUCxR5AVHBGDq8PBs/oMRcoFshgpBr/jGlLODDOJTd3IRo80a3f2HgQe
         UjUaQL3imwHF3JR0HArwTOfHjN+4nf8w5JAn1XBLQ43dhtfu2ggJZNxK53TQ9N9qxzl3
         sRfEYlyXbaC2295NHtQfSG1nutzKLn+DRCkXpkzpl/dSe/Nb7z3lU9jilkL99Y2Ic3Ah
         qDxxEJQGBC9jW8yJJXU3Rq7I17XA5te8e2P7fx+FsbLpPreknRPxP+HKTWDun0tU3IQH
         4kbTiFeKDhwVV/f2P8EaGLmsmcLpU9wSjwR6VhQ8SSmSIJomWzyy4xRNd3CVxxPfUmRk
         WkKQ==
X-Gm-Message-State: AOJu0YzO4tAkcVVomIEGEYDlIsSX/tC31yHUIuNQlFs/w9S0k+Adrwff
	MCy2J7xG3cVb416feoCwY1kUD1yZ9a0amTKjGuaNysKlNJt+667zjkDf0kSt88bTwQbdm0DlRUJ
	a5xt4ZmybqzpggTCDcOMxpyswV7VGbkGX0BiRA/8gcJTp2JyB9wCeWzZ3fO4zuoqJUuXrxHoa4w
	WLX7CKLE6PE8ZTXqIEqXEAEDVTVU0=
X-Google-Smtp-Source: AGHT+IGUxeEGfAsoAd7s+lQEJg9M25v22ALw2mIVeLvbRK2hk3bYMb9fDCZ6JuEsyM6cPAnnSDjyh7y8Ow==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:102d:b0:dc6:c94e:fb85 with SMTP id
 x13-20020a056902102d00b00dc6c94efb85mr91260ybt.2.1713513587758; Fri, 19 Apr
 2024 00:59:47 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:12 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-3-tabba@google.com>
Subject: [PATCH v3 02/31] KVM: arm64: Move guest_owns_fp_regs() to increase
 its scope
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

guest_owns_fp_regs() will be used to check fpsimd state ownership
across kvm/arm64. Therefore, move it to kvm_host.h to widen its
scope.

Moreover, the host state is not per-vcpu anymore, the vcpu
parameter isn't used, so remove it as well.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 6 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2b63fdfad5b2..2889e1d8a8c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1207,6 +1207,12 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+/* Check whether the FP regs are owned by the guest */
+static inline bool guest_owns_fp_regs(void)
+{
+	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
+}
+
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 2629420d0659..38961b6b1a18 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -39,12 +39,6 @@ struct kvm_exception_table_entry {
 extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
-/* Check whether the FP regs are owned by the guest */
-static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
-{
-	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 1f82d531a494..1b22654a3180 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -53,7 +53,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			val |= CPTR_EL2_TSM;
 	}
 
-	if (!guest_owns_fp_regs(vcpu)) {
+	if (!guest_owns_fp_regs()) {
 		if (has_hvhe())
 			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b92f9fe2d50e..7286db75b8d6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -75,7 +75,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (guest_owns_fp_regs(vcpu)) {
+	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	} else {
-- 
2.44.0.769.g3c40516874-goog

