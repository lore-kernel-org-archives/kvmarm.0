Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063BFC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 03:21:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7908F412AF;
	Mon, 28 Mar 2022 23:21:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UfNYcp7Vtj3w; Mon, 28 Mar 2022 23:21:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2772C4B1A2;
	Mon, 28 Mar 2022 23:21:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E264120D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 23:21:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XzcOPcuzYsKo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 23:21:07 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A74440D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 23:21:07 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 gk23-20020a17090b119700b001c65a1baa01so8352308pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 20:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LmStsPZHwym48s0jdcVtSE1tYT0ApQdrS0D37AGFyKs=;
 b=fEasP1jMds0SprfAzrb6nU+tQ1xM/FQ9csAdEfGCOCN52KVy7P1IdJmecVUkWrxlY6
 ae9tKpwqxxEwi6ZZ6VOKCs45FzPPoy4qcauOCUU0/cQ/JOp+Vjydj2DYAFPMsMXwb/S3
 FFbsM6bMh9bbLgcJVLvBFb2tyTvzewi7HhXUk0xDJCQmRkADDhgCLLAksx5yyuCXOE5+
 6GxLbyKyU8ulLL6zayZ769648cDK0cQzMhQAp8yukTVs29tXBs0LjOYXugoCOaW9UX47
 N9sqxliF4yKXIiSdWrbi7GClPxebI7h+RYiHCnv0i0OQItlwKz+ED4h2qTUVF06Kz74b
 FTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LmStsPZHwym48s0jdcVtSE1tYT0ApQdrS0D37AGFyKs=;
 b=NSo5v5WSJDuZuzc1UeCFY8Vid/cppB7Y5pp+YJciaxxgbAo8taNSmDaXJHhMVYJ8/U
 oNSWVrR0tNbW3vnDIXp3YaSyTBUfv7ljq3w3ncWgDqfAtr6ZiTKN2oWgWaMFz9VZ6B2V
 FUBP8SY5G6cN84ovm7hBF89FisnQlr/RkTS3FG4PrpjvelSIxGiq5sLk+8Ysn5KfZSry
 n4Jcg/P5hO9DOxCOe5e5XEzm4Q//ZzaiTUReNZnfDBMsLbZNxy7ptnf3nJwPDKjaHEH9
 d/pela7C5apcFtNsXJUZXVdH2WmtfRRmMgWZ2qrRBUQbQoB7t6KNXWz33DuAlYrBXaB6
 ai6w==
X-Gm-Message-State: AOAM530CGpFyx8iMpIRB9663aqDYq0JRknhimIFce6/5MBjVWoJkQisk
 Mpb5BPnE7ZVHLOFyhnNmg7WkvruWXwo=
X-Google-Smtp-Source: ABdhPJzbFFZl49TTWscmlE01uLye5VCnvj3jOie2HZt20RAmPW3WeAPBiEL14vNtP9wsaPZ4qw/o9ZsSdMs=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:edc4:b0:151:5fbb:5f44 with SMTP id
 q4-20020a170902edc400b001515fbb5f44mr29013494plk.34.1648524066244; Mon, 28
 Mar 2022 20:21:06 -0700 (PDT)
Date: Mon, 28 Mar 2022 20:19:23 -0700
In-Reply-To: <20220329031924.619453-1-reijiw@google.com>
Message-Id: <20220329031924.619453-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220329031924.619453-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v6 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
the guest needs to be configured with all 32bit or 64bit vCPUs, and
a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
EL1_32BIT bit is valid (already set up). Values in those bits are set at
the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
configuration for the vCPU.

Check vcpu's register width against those new bits at the vcpu's
KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 27 ++++++++----
 arch/arm64/include/asm/kvm_host.h    | 10 +++++
 arch/arm64/kvm/reset.c               | 65 ++++++++++++++++++----------
 3 files changed, 72 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..7496deab025a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+#if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
 }
+#else
+static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
+			       &kvm->arch.flags));
+
+	return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
+}
+#endif
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
@@ -72,15 +84,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TVM;
 	}
 
-	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
+	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
+	else
+		/*
+		 * TID3: trap feature register accesses that we virtualise.
+		 * For now this is conditional, since no AArch32 feature regs
+		 * are currently virtualised.
+		 */
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e96087885fe..f7781c5e0c6a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -127,6 +127,16 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
 	/* At least one vCPU has ran in the VM */
 #define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
+	/*
+	 * The following two bits are used to indicate the guest's EL1
+	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
+	 * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
+	 * Otherwise, the guest's EL1 register width has not yet been
+	 * determined yet.
+	 */
+#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
+#define KVM_ARCH_FLAG_EL1_32BIT				4
+
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..bc8b3909640f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -181,27 +181,46 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+/**
+ * kvm_set_vm_width() - set a register width for the guest
+ * @kvm: Pointer to the KVM struct
+ * @is32bit: Whether the register width of the guest is 32-bit or not (64-bit)
+ *
+ * Set KVM_ARCH_FLAG_EL1_32BIT bit in kvm->arch.flags based on @is32bit
+ * and also set KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED bit in the flags.
+ * When REG_WIDTH_CONFIGURED bit is already set in the flags, @is32bit
+ * must be consistent with the value of FLAG_EL1_32BIT bit in the flags.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int kvm_set_vm_width(struct kvm *kvm, bool is32bit)
 {
-	struct kvm_vcpu *tmp;
-	bool is32bit;
-	unsigned long i;
+	lockdep_assert_held(&kvm->lock);
+
+	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
+		/*
+		 * The guest's register width is already configured.
+		 * Make sure that @is32bit is consistent with it.
+		 */
+		if (is32bit == test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags))
+			return 0;
+		else
+			return -EINVAL;
+	}
 
-	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
-		return false;
+		return -EINVAL;
 
 	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(vcpu->kvm) && is32bit)
-		return false;
+	if (kvm_has_mte(kvm) && is32bit)
+		return -EINVAL;
 
-	/* Check that the vcpus are either all 32bit or all 64bit */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
-			return false;
-	}
+	if (is32bit)
+		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
 
-	return true;
+	set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
+
+	return 0;
 }
 
 /**
@@ -230,10 +249,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	u32 pstate;
 
 	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	ret = kvm_set_vm_width(vcpu->kvm,
+			       vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT));
+	if (!ret) {
+		reset_state = vcpu->arch.reset_state;
+		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	}
 	mutex_unlock(&vcpu->kvm->lock);
 
+	if (ret)
+		return ret;
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -260,14 +286,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (!vcpu_allowed_register_width(vcpu)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	switch (vcpu->arch.target) {
 	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		if (vcpu_el1_is_32bit(vcpu)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
