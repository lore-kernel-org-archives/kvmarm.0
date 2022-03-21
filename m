Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C70C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 05:08:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716C74B0A0;
	Mon, 21 Mar 2022 01:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sd6Za+8sqUWp; Mon, 21 Mar 2022 01:08:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E24349ECB;
	Mon, 21 Mar 2022 01:08:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F66340C23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 01:08:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HwcSVibjjo5s for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 01:08:39 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9A4A40C10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 01:08:38 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 x123-20020a626381000000b004f6fc50208eso9237775pfb.11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Mar 2022 22:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LxG2PTi2xwn24mKlBgiN0pZ6uoHcICcLtzYM1y02gXo=;
 b=bZbz61KCU9jW+w/5YoXfJEXJZ/m0SNBjFyhfX3IbMdemYcFH3VdmzYTNYtY1MURus/
 ddfsxUqKECi3N6+bxZGSlIZIbFRKHeV2mAFElrrTxPTWe5lnBuymovO2ry2O7d5PpFrg
 TS5QLcxpiGT9zFxSmAOGbwfbF45gQU6r8EgLNKN4krUvaOW8iganHg7i3wIc/Y2EvblV
 61JSDoTTPccZaPHysd9Y/z57z9eKCxF/gX4jrgxuU8jGyIbtbLghItcqXj3Jc5Mn6UoV
 crnAssfFH6OLLf+Glq34tPzjZmGQgKPEkY7KZcDBOaDaHeGWBs/s3HnYp+1QV/xY8dkS
 GH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LxG2PTi2xwn24mKlBgiN0pZ6uoHcICcLtzYM1y02gXo=;
 b=2PRM7j61dyBnk4fg6DycaQge8iw7l4yiHDRwRMoCdCpzwmCPZrJOMQehEkCd29/AsF
 7g5i2sC41KnNMyqgb+BFfL+zLSOeIlWV7eJ5JfLyBaYTS1Tl49HqYfCpH+bmjH4hjHUk
 bWII2ioMk00CyGiF1/e4YtS/HhqXZzlHZXOLhaYJ3Nx7Wb808WuKBWDmZhrxVJyFhJho
 ifhHDQVYCkiV+52WV6IP2a8W3v2Z9pVqh0NesqHcYeAIbldUywlDmP8qTlzIoOh0hez4
 Tn+/fFqrfs0L+anm8x0oVMeU1OviDg2RzUYo8fXK8V6q2YU/3Xb57hKUzZQOhGvpis8H
 3Ghg==
X-Gm-Message-State: AOAM532Hn5sPVjPmTqH3UvT5J2tioqQBggTrh9OTGBB1OFpOW+TDPiaB
 48nj0BuWCYWq7uJ2+5FSTC6gig4de08=
X-Google-Smtp-Source: ABdhPJzYJOQqj21E39f3tJVWTtqG7Ne9x+ipGfWCxPaeEUCXf0Ww/p0RNHF5QyFicNBr9zXiOSHlHnkKoVI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:4890:b0:1bf:654e:e1a0 with SMTP id
 b16-20020a17090a489000b001bf654ee1a0mr34733727pjh.113.1647839317951; Sun, 20
 Mar 2022 22:08:37 -0700 (PDT)
Date: Sun, 20 Mar 2022 22:08:03 -0700
In-Reply-To: <20220321050804.2701035-1-reijiw@google.com>
Message-Id: <20220321050804.2701035-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220321050804.2701035-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v5 1/2] KVM: arm64: mixed-width check should be skipped for
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
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
