Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0171DDA22
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323182; cv=none; b=WBgqhguZECqnZDOQQDgCGc9FnaaRcTlRhkGlRl+X0l8bM/a6wpXjfe5v8KDPqXV2bxusKb/DkNKZ6tHcU87uTHM2x6O9YOoDzoSg8r2s5xnn/3w0uySjXpLMWsIeZUQHPTtqae2TX/ttCiWRwESilzO1jPQd0RqDgYuFVEHjPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323182; c=relaxed/simple;
	bh=kkYEbaUkWBM3G8WRmy9lylhrc1nQeR9GYbU5xadt+t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tvava40FIIhMWxTLKleU2NOqamQBp6ms3nc1bA5MD3G7H6uTxb6DBNIFC38/tvR2eTt/r8j0QAogkbNNmYz9KmlN71ZkZPdojUTTKTHQqOA7hRFTjHQskd6YepumC0HkCH1FzQOh4Wyhq0OpaNXhsyhTsgjnppLB6MHZVu6LCOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uqx9Stp5; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uqx9Stp5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IVnkX3Q1HQ+24EPPtNEYJgfMu9+r4GXCPsgoSc4WsOI=;
	b=Uqx9Stp5Sbv5r1aagfRTnz2YOuWPrs2k1aIGMsC1g+v2dZQfAD/eR9gsc45OcDgGRFY6ha
	bRaEB86b30dsMr1bO3GvxneLlFYncNGIBvT1BECBS2Wn7ndHXHvkIYEBrJqdZiyMtH2YqD
	mXWERG5sdqY39u9LCEo5qkhN9SwtI9A=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 01/17] KVM: arm64: Extend masking facility to arbitrary registers
Date: Mon,  7 Oct 2024 17:45:43 +0000
Message-ID: <20241007174559.1830205-2-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

We currently only use the masking (RES0/RES1) facility for VNCR
registers, as they are memory-based and thus easy to sanitise.

But we could apply the same thing to other registers if we:

- split the sanitisation from __VNCR_START__
- apply the sanitisation when reading from a HW register

This involves a new "marker" in the vcpu_sysreg enum, which
defines the point at which the sanitisation applies (the VNCR
registers being of course after this marker).

Whle we are at it, rename kvm_vcpu_sanitise_vncr_reg() to
kvm_vcpu_apply_reg_masks(), which is vaguely more explicit,
and harden set_sysreg_masks() against setting masks for
random registers...

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++------
 arch/arm64/kvm/nested.c           | 12 ++++++++----
 arch/arm64/kvm/sys_regs.c         |  3 +++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 329619c6fa96..7764ca71ac6e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,7 +367,7 @@ struct kvm_arch {
 
 	u64 ctr_el0;
 
-	/* Masks for VNCR-baked sysregs */
+	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
 	/*
@@ -401,6 +401,9 @@ struct kvm_vcpu_fault_info {
 	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
 	__after_##r = __MAX__(__before_##r - 1, r)
 
+#define MARKER(m)				\
+	m, __after_##m = m - 1
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
@@ -487,7 +490,11 @@ enum vcpu_sysreg {
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
 
-	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
+	/* Anything from this can be RES0/RES1 sanitised */
+	MARKER(__SANITISED_REG_START__),
+
+	/* Any VNCR-capable reg goes after this point */
+	MARKER(__VNCR_START__),
 
 	VNCR(SCTLR_EL1),/* System Control Register */
 	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
@@ -547,7 +554,7 @@ struct kvm_sysreg_masks {
 	struct {
 		u64	res0;
 		u64	res1;
-	} mask[NR_SYS_REGS - __VNCR_START__];
+	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
 struct kvm_cpu_context {
@@ -995,13 +1002,13 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
+u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 #define __vcpu_sys_reg(v,r)						\
 	(*({								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
 		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
-		if (vcpu_has_nv((v)) && (r) >= __VNCR_START__)		\
-			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
+			*__r = kvm_vcpu_apply_reg_masks((v), (r), *__r);\
 		__r;							\
 	}))
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f9e30dd34c7a..b20b3bfb9cae 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -908,15 +908,15 @@ static void limit_nv_id_regs(struct kvm *kvm)
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
 }
 
-u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
+u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
+			     enum vcpu_sysreg sr, u64 v)
 {
-	u64 v = ctxt_sys_reg(&vcpu->arch.ctxt, sr);
 	struct kvm_sysreg_masks *masks;
 
 	masks = vcpu->kvm->arch.sysreg_masks;
 
 	if (masks) {
-		sr -= __VNCR_START__;
+		sr -= __SANITISED_REG_START__;
 
 		v &= ~masks->mask[sr].res0;
 		v |= masks->mask[sr].res1;
@@ -927,7 +927,11 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
 
 static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
 {
-	int i = sr - __VNCR_START__;
+	int i = sr - __SANITISED_REG_START__;
+
+	BUILD_BUG_ON(!__builtin_constant_p(sr));
+	BUILD_BUG_ON(sr < __SANITISED_REG_START__);
+	BUILD_BUG_ON(sr >= NR_SYS_REGS);
 
 	kvm->arch.sysreg_masks->mask[i].res0 = res0;
 	kvm->arch.sysreg_masks->mask[i].res1 = res1;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f953..30fe940cd5bd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -165,6 +165,9 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 		/* Get the current version of the EL1 counterpart. */
 		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
+		if (reg >= __SANITISED_REG_START__)
+			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
+
 		return val;
 	}
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog

