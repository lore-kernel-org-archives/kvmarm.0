Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C153C47088
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 09:19:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E31874B256;
	Fri,  2 Dec 2022 04:19:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bLD+HcGiA70V; Fri,  2 Dec 2022 04:19:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371D040C88;
	Fri,  2 Dec 2022 04:19:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6431A43399
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 04:19:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vei-VfzPP1Gl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 04:19:44 -0500 (EST)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB5AB40C88
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 04:19:44 -0500 (EST)
Received: by mail-pl1-f169.google.com with SMTP id p24so4131017plw.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 01:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=t5dutFU/unBRoBttuUB/M6fMP+Yt2NpTWIJuMYFm8fU=;
 b=yFXhxEX5toalHPauuWYtCa7BdnorZqc24D1//LZCzjceETJtpLT8CQutud7DJLnJ7H
 PladqCcjR/4xovXkmhaUAIjnZgVWtnhcKnXTxfSvdWpFit0AdA3u3N4XRBJtrlZpxHwf
 AnXf0wtgrijwHFN7+wlmuUWSdqNxnExo1fMDKZedaGoKaMfOPcCfsbu5PWa4+xNrUfhw
 +W6h0AYMWvA+A7JRCOtlBvov0PMdMCJPIzTq9mt/EbZoJkj9C1kZ2BoVnOltwOOaKFM4
 cO4qVoXBziyQuIxJgjkCdrYKoBZJrpoIl0v8eipf+SMa+WoltFw1VFzbp+j5vqExqjR8
 mhrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=t5dutFU/unBRoBttuUB/M6fMP+Yt2NpTWIJuMYFm8fU=;
 b=gXVQePfI5XKt39860efsBaCGf9Tp/GnUUg1iMWf8tw4VCb5MKBetyOxbwgublJrFvW
 0+3zgudfC0gwOu6e3/6fCKK4al1YC3unCJwLuW4U5IxZJDwSOeYsX62u3PmgE6xcMFHC
 Bys4xL1rtbTeEFP5Eh+cjZYVRk9inVpFRnvLIspExDY+okDjB5H0dwcz/njeSsZMiL1n
 KfkhiyNEh3OwkAgTAiO66wi4xVq4X4nWkLaI5Oodw878dufS3+kaExnVlzNJIZtL4pZ/
 VmGTZCXu+kqF2w/Rja2hxyh4L116GplxcsB6uVKYK4qqlzpBepF4IthIPLQrNKumygcS
 ycqQ==
X-Gm-Message-State: ANoB5plNojPC1v4tFgbgqgs5wlg0eeOa8hoq2tJMZsSr/Z4d6x8FD3Fd
 92fHIPAL8yuBQvq/QpvzcXbCIw==
X-Google-Smtp-Source: AA0mqf4SGMDXTH8QBpljz4O1upV9TZVrHwCKnJDpZWqO3jSNBJeCszABeyAXU2aCtJziNxV9tm3+7g==
X-Received: by 2002:a17:90a:1a11:b0:213:f398:ed51 with SMTP id
 17-20020a17090a1a1100b00213f398ed51mr74040091pjk.216.1669972783449; 
 Fri, 02 Dec 2022 01:19:43 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 v129-20020a622f87000000b005761c4754e7sm2847375pfv.144.2022.12.02.01.19.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Dec 2022 01:19:42 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH] KVM: arm64: Always mask CCSIDR associativity bits
Date: Fri,  2 Dec 2022 18:18:56 +0900
Message-Id: <20221202091856.104868-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

M2 MacBook Air has mismatched CCSIDR associativity bits among physical
CPUs, which makes the bits a KVM vCPU sees inconsistent when migrating
among them.

While it is possible to detect CCSIDR associativity bit mismatches and
mask them with that condition, it requires mismatch detection and
increases complexity. Instead, always mask the CCSIDR associativity bits
to keep the code simple.

Also, allow the userspace to overwrite the bits with arbitrary values so
that it can restore a vCPU state saved with an older kernel.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h     |   3 +-
 arch/arm64/include/asm/kvm_emulate.h |   4 -
 arch/arm64/include/asm/kvm_host.h    |   4 +
 arch/arm64/include/asm/sysreg.h      |   3 +
 arch/arm64/kvm/sys_regs.c            | 146 ++++++++++++++-------------
 5 files changed, 87 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8aa8492dafc0..f69cd96a65ab 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -81,11 +81,12 @@
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  * TID3:	Trap EL1 reads of group 3 ID registers
+ * TID2:	Trap CCSIDR_EL1
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 )
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID2)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9bdba47f7e14..30c4598d643b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -88,10 +88,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
-	    vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID2;
-
 	if (kvm_has_mte(vcpu->kvm))
 		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 45e2136322ba..cc051cd56179 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,6 +53,9 @@
 
 #define KVM_HAVE_MMU_RWLOCK
 
+/* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
+#define CSSELR_MAX 14
+
 /*
  * Mode of operation configurable with kvm-arm.mode early param.
  * See Documentation/admin-guide/kernel-parameters.txt for more information.
@@ -266,6 +269,7 @@ struct kvm_cpu_context {
 	struct user_fpsimd_state fp_regs;
 
 	u64 sys_regs[NR_SYS_REGS];
+	u32 ccsidr[CSSELR_MAX + 1];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..0c5f3675b4c2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -941,6 +941,9 @@
 #define HFGxTR_EL2_nSMPRI_EL1_SHIFT	54
 #define HFGxTR_EL2_nSMPRI_EL1_MASK	BIT_MASK(HFGxTR_EL2_nSMPRI_EL1_SHIFT)
 
+/* CCSIDR_EL1 bit definitions */
+#define CCSIDR_EL1_ASSOCIATIVITY_BITS	GENMASK(27, 3)
+
 #define ARM64_FEATURE_FIELD_BITS	4
 
 /* Create a mask for the feature bits of the specified feature. */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4a7c5abcbca..3518d021d3a0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -84,24 +84,6 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
-/* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
-#define CSSELR_MAX 14
-
-/* Which cache CCSIDR represents depends on CSSELR value. */
-static u32 get_ccsidr(u32 csselr)
-{
-	u32 ccsidr;
-
-	/* Make sure noone else changes CSSELR during this! */
-	local_irq_disable();
-	write_sysreg(csselr, csselr_el1);
-	isb();
-	ccsidr = read_sysreg(ccsidr_el1);
-	local_irq_enable();
-
-	return ccsidr;
-}
-
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -1300,25 +1282,76 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return write_to_read_only(vcpu, p, r);
 
 	csselr = vcpu_read_sys_reg(vcpu, CSSELR_EL1);
-	p->regval = get_ccsidr(csselr);
+	p->regval = vcpu->arch.ctxt.ccsidr[csselr];
 
-	/*
-	 * Guests should not be doing cache operations by set/way at all, and
-	 * for this reason, we trap them and attempt to infer the intent, so
-	 * that we can flush the entire guest's address space at the appropriate
-	 * time.
-	 * To prevent this trapping from causing performance problems, let's
-	 * expose the geometry of all data and unified caches (which are
-	 * guaranteed to be PIPT and thus non-aliasing) as 1 set and 1 way.
-	 * [If guests should attempt to infer aliasing properties from the
-	 * geometry (which is not permitted by the architecture), they would
-	 * only do so for virtually indexed caches.]
-	 */
-	if (!(csselr & 1)) // data or unified cache
-		p->regval &= ~GENMASK(27, 3);
 	return true;
 }
 
+static bool is_valid_cache(u32 val)
+{
+	u32 level, ctype;
+
+	if (val >= CSSELR_MAX)
+		return false;
+
+	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
+	level = (val >> 1);
+	ctype = (cache_levels >> (level * 3)) & 7;
+
+	switch (ctype) {
+	case 0: /* No cache */
+		return false;
+	case 1: /* Instruction cache only */
+		return (val & 1);
+	case 2: /* Data cache only */
+	case 4: /* Unified cache */
+		return !(val & 1);
+	case 3: /* Separate instruction and data caches */
+		return true;
+	default: /* Reserved: we can't know instruction or data. */
+		return false;
+	}
+}
+
+static void reset_ccsidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 ccsidr;
+	int i;
+
+	/* Make sure noone else changes CSSELR during this! */
+	local_irq_disable();
+
+	for (i = 0; i < CSSELR_MAX; i++) {
+		if (!is_valid_cache(i))
+			continue;
+
+		/* Which cache CCSIDR represents depends on CSSELR value. */
+		write_sysreg(i, csselr_el1);
+		isb();
+		ccsidr = read_sysreg(ccsidr_el1);
+
+		/*
+		 * Guests should not be doing cache operations by set/way at
+		 * all, and for this reason, we trap them and attempt to infer
+		 * the intent, so that we can flush the entire guest's address
+		 * space at the appropriate time.
+		 * To prevent this trapping from causing performance problems,
+		 * let's expose the geometry of all data and unified caches
+		 * (which are guaranteed to be PIPT and thus non-aliasing) as
+		 * 1 set and 1 way.
+		 * [If guests should attempt to infer aliasing properties from
+		 * the geometry (which is not permitted by the architecture),
+		 * they would only do so for virtually indexed caches.]
+		 *
+		 * This also make sure vCPU see the consistent geometry even if
+		 * it migrates among phyiscal CPUs with different geometries.
+		 */
+		vcpu->arch.ctxt.ccsidr[i] = ccsidr & ~CCSIDR_EL1_ASSOCIATIVITY_BITS;
+	}
+
+	local_irq_enable();
+}
+
 static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
 {
@@ -1603,7 +1636,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
 
-	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
+	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr, reset_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
@@ -2660,33 +2693,7 @@ static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
 	return 0;
 }
 
-static bool is_valid_cache(u32 val)
-{
-	u32 level, ctype;
-
-	if (val >= CSSELR_MAX)
-		return false;
-
-	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
-	level = (val >> 1);
-	ctype = (cache_levels >> (level * 3)) & 7;
-
-	switch (ctype) {
-	case 0: /* No cache */
-		return false;
-	case 1: /* Instruction cache only */
-		return (val & 1);
-	case 2: /* Data cache only */
-	case 4: /* Unified cache */
-		return !(val & 1);
-	case 3: /* Separate instruction and data caches */
-		return true;
-	default: /* Reserved: we can't know instruction or data. */
-		return false;
-	}
-}
-
-static int demux_c15_get(u64 id, void __user *uaddr)
+static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
 	u32 val;
 	u32 __user *uval = uaddr;
@@ -2705,15 +2712,15 @@ static int demux_c15_get(u64 id, void __user *uaddr)
 		if (!is_valid_cache(val))
 			return -ENOENT;
 
-		return put_user(get_ccsidr(val), uval);
+		return put_user(vcpu->arch.ctxt.ccsidr[val], uval);
 	default:
 		return -ENOENT;
 	}
 }
 
-static int demux_c15_set(u64 id, void __user *uaddr)
+static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
-	u32 val, newval;
+	u32 val, newval, mask;
 	u32 __user *uval = uaddr;
 
 	/* Fail if we have unknown bits set. */
@@ -2733,9 +2740,12 @@ static int demux_c15_set(u64 id, void __user *uaddr)
 		if (get_user(newval, uval))
 			return -EFAULT;
 
-		/* This is also invariant: you can't change it. */
-		if (newval != get_ccsidr(val))
+		/* The bits other than the associativity bits are invariant. */
+		mask = CCSIDR_EL1_ASSOCIATIVITY_BITS;
+		if ((vcpu->arch.ctxt.ccsidr[val] ^ newval) & ~mask)
 			return -EINVAL;
+
+		vcpu->arch.ctxt.ccsidr[val] = newval;
 		return 0;
 	default:
 		return -ENOENT;
@@ -2773,7 +2783,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
-		return demux_c15_get(reg->id, uaddr);
+		return demux_c15_get(vcpu, reg->id, uaddr);
 
 	err = get_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
@@ -2817,7 +2827,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
-		return demux_c15_set(reg->id, uaddr);
+		return demux_c15_set(vcpu, reg->id, uaddr);
 
 	err = set_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
