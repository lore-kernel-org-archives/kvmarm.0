Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86931FF5E9
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793332; cv=none; b=iZBhTdKRRgDzTPpi0EqQnVmFlOfLV87Jo4ZfumIAAzDgfot6tGZWIWQeddKkkGqaDiA22LS69E7iZ/qduFLUuc35tgI1ljItEmmx2YXQ5tlPS++yw/sD9ysbXEdgEAqCBvJiuYVgYWjD41aXzRgMO12bVeIWSdaxzIN1Www27RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793332; c=relaxed/simple;
	bh=DYi/S4wKxddcSBEcF25QXuvF3+JUtF49xjkfDr6aLGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X9VXdejOl+rPvVcYPFhUhSl2m5cs7Dr6VLg7AJd/uN+J+e6UplxeVYAlphLHQ/kFmQz3OaUavIWht3MF+2X5pFruwLj0FnhD/9LKxu/gkpqBcdzXoCVWo1cbbmjH+VjUk78h4uA1s1rxnqyO5UveBeGvxUvWC8fSpgSBIzUp5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixglotLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixglotLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454BBC4CED6;
	Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793332;
	bh=DYi/S4wKxddcSBEcF25QXuvF3+JUtF49xjkfDr6aLGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixglotLRVnKfNFhuy95q1Jd8noTkLLZmXPUvYIANCkHyMtKWJoo+Jk9uWn4iMYzfW
	 NeA5XxZhi4DpjYLFgdcop3z/b2cLnO7ixXQZtFv5eOOrBym+AqcUBoaI32L7ZrvHFA
	 KwAyJac4EWfH5v7m0wE9CFtt+YJDxllm7DpxdI/ReQddp2oyAUfxCnrokOi7dcep37
	 zCEnsf27hCv1TZ0tW54/okjiIrnadUxv3WIvnvwEq7K0tvmxYiSEogkD9O//hHGvEy
	 56hA78gJBKc6YDra93YGwFd8I2GR2pBy8Tt41urrlcZdTyz+uWsRGokVrsCemf/aJG
	 lOfhRf3/JmTlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXPHe-00BjrF-3b;
	Mon, 13 Jan 2025 18:35:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 1/4] KVM: arm64: Add assignment-specific sysreg accessor
Date: Mon, 13 Jan 2025 18:35:21 +0000
Message-Id: <20250113183524.1378778-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250113183524.1378778-1-maz@kernel.org>
References: <20250113183524.1378778-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Assigning a value to a system register doesn't do what it is
supposed to be doing if that register is one that has RESx bits.

The main problem is that we use __vcpu_sys_reg(), which can be used
both as a lvalue and rvalue. When used as a lvalue, the bit masking
occurs *before* the new value is assigned, meaning that we (1) do
pointless work on the old cvalue, and (2) potentially assign an
invalid value as we fail to apply the masks to it.

Fix this by providing a new __vcpu_assign_sys_reg() that does
what it says on the tin, and sanitises the *new* value instead of
the old one. This comes with a significant amount of churn.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          | 11 ++++++
 arch/arm64/kvm/arch_timer.c                | 16 ++++----
 arch/arm64/kvm/fpsimd.c                    |  2 +-
 arch/arm64/kvm/hyp/exception.c             |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 44 +++++++++++-----------
 arch/arm64/kvm/pmu-emul.c                  | 10 ++---
 arch/arm64/kvm/sys_regs.c                  | 32 ++++++++--------
 arch/arm64/kvm/sys_regs.h                  |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++---
 13 files changed, 81 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8e02f7af96008..1525b16d1df3e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1066,6 +1066,17 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
 u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
+
+#define __vcpu_assign_sys_reg(v, r, val)				\
+	do {								\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
+		u64 __v = (val);					\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
+			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
+									\
+		ctxt_sys_reg(ctxt, (r)) = __v;				\
+	} while (0)
+
 #define __vcpu_sys_reg(v,r)						\
 	(*({								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d3d243366536c..f404690a3ab4f 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -108,16 +108,16 @@ static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = ctl;
+		__vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, ctl);
 		break;
 	case TIMER_PTIMER:
-		__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = ctl;
+		__vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, ctl);
 		break;
 	case TIMER_HVTIMER:
-		__vcpu_sys_reg(vcpu, CNTHV_CTL_EL2) = ctl;
+		__vcpu_assign_sys_reg(vcpu, CNTHV_CTL_EL2, ctl);
 		break;
 	case TIMER_HPTIMER:
-		__vcpu_sys_reg(vcpu, CNTHP_CTL_EL2) = ctl;
+		__vcpu_assign_sys_reg(vcpu, CNTHP_CTL_EL2, ctl);
 		break;
 	default:
 		WARN_ON(1);
@@ -130,16 +130,16 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = cval;
+		__vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, cval);
 		break;
 	case TIMER_PTIMER:
-		__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = cval;
+		__vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, cval);
 		break;
 	case TIMER_HVTIMER:
-		__vcpu_sys_reg(vcpu, CNTHV_CVAL_EL2) = cval;
+		__vcpu_assign_sys_reg(vcpu, CNTHV_CVAL_EL2, cval);
 		break;
 	case TIMER_HPTIMER:
-		__vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2) = cval;
+		__vcpu_assign_sys_reg(vcpu, CNTHP_CVAL_EL2, cval);
 		break;
 	default:
 		WARN_ON(1);
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 4d3d1a2eb1570..76bde6f489fbc 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -185,7 +185,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			 * If the vCPU is in the hyp context then ZCR_EL1 is
 			 * loaded with its vEL2 counterpart.
 			 */
-			__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)) = zcr;
+			__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr);
 
 			/*
 			 * Restore the VL that was saved when bound to the CPU,
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 424a5107cddb5..6a2a899a344e6 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -37,7 +37,7 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	if (unlikely(vcpu_has_nv(vcpu)))
 		vcpu_write_sys_reg(vcpu, val, reg);
 	else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
-		__vcpu_sys_reg(vcpu, reg) = val;
+		__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
@@ -51,7 +51,7 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	} else if (has_vhe()) {
 		write_sysreg_el1(val, SYS_SPSR);
 	} else {
-		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
+		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, val);
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f838a45665f26..3836c3bc82ef1 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -45,7 +45,7 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
+	__vcpu_assign_sys_reg(vcpu, FPEXC32_EL2, read_sysreg(fpexc32_el2));
 }
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 70cc922a6dc49..503273a3c3340 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -312,11 +312,11 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
 	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
 
-	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
-	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
+	__vcpu_assign_sys_reg(vcpu, DACR32_EL2, read_sysreg(dacr32_el2));
+	__vcpu_assign_sys_reg(vcpu, IFSR32_EL2, read_sysreg(ifsr32_el2));
 
 	if (has_vhe() || kvm_debug_regs_in_use(vcpu))
-		__vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
+		__vcpu_assign_sys_reg(vcpu, DBGVCR32_EL2, read_sysreg(dbgvcr32_el2));
 }
 
 static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5c134520e1805..ae71c567b57a5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -25,7 +25,7 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 {
-	__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
 	/*
 	 * On saving/restoring guest sve state, always use the maximum VL for
 	 * the guest. The layout of the data when saving the sve state depends
@@ -78,7 +78,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 
 	has_fpmr = kvm_has_fpmr(kern_hyp_va(vcpu->kvm));
 	if (has_fpmr)
-		__vcpu_sys_reg(vcpu, FPMR) = read_sysreg_s(SYS_FPMR);
+		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9ba7208df9324..c49efc8cb16de 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -213,9 +213,9 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		 */
 		val = read_sysreg_el0(SYS_CNTP_CVAL);
 		if (map.direct_ptimer == vcpu_ptimer(vcpu))
-			__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = val;
+			__vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, val);
 		if (map.direct_ptimer == vcpu_hptimer(vcpu))
-			__vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2) = val;
+			__vcpu_assign_sys_reg(vcpu, CNTHP_CVAL_EL2, val);
 
 		offset = read_sysreg_s(SYS_CNTPOFF_EL2);
 
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 90b018e06f2cb..a60639abc4a47 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -18,17 +18,17 @@
 static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 {
 	/* These registers are common with EL1 */
-	__vcpu_sys_reg(vcpu, PAR_EL1)	= read_sysreg(par_el1);
-	__vcpu_sys_reg(vcpu, TPIDR_EL1)	= read_sysreg(tpidr_el1);
-
-	__vcpu_sys_reg(vcpu, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
-	__vcpu_sys_reg(vcpu, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
-	__vcpu_sys_reg(vcpu, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
-	__vcpu_sys_reg(vcpu, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
-	__vcpu_sys_reg(vcpu, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
-	__vcpu_sys_reg(vcpu, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
-	__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
-	__vcpu_sys_reg(vcpu, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
+	__vcpu_assign_sys_reg(vcpu, PAR_EL1,	 read_sysreg(par_el1));
+	__vcpu_assign_sys_reg(vcpu, TPIDR_EL1,	 read_sysreg(tpidr_el1));
+
+	__vcpu_assign_sys_reg(vcpu, ESR_EL2,	 read_sysreg_el1(SYS_ESR));
+	__vcpu_assign_sys_reg(vcpu, AFSR0_EL2,	 read_sysreg_el1(SYS_AFSR0));
+	__vcpu_assign_sys_reg(vcpu, AFSR1_EL2,	 read_sysreg_el1(SYS_AFSR1));
+	__vcpu_assign_sys_reg(vcpu, FAR_EL2,	 read_sysreg_el1(SYS_FAR));
+	__vcpu_assign_sys_reg(vcpu, MAIR_EL2,	 read_sysreg_el1(SYS_MAIR));
+	__vcpu_assign_sys_reg(vcpu, VBAR_EL2,	 read_sysreg_el1(SYS_VBAR));
+	__vcpu_assign_sys_reg(vcpu, CONTEXTIDR_EL2, read_sysreg_el1(SYS_CONTEXTIDR));
+	__vcpu_assign_sys_reg(vcpu, AMAIR_EL2,	 read_sysreg_el1(SYS_AMAIR));
 
 	/*
 	 * In VHE mode those registers are compatible between EL1 and EL2,
@@ -46,21 +46,21 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		 * are always trapped, ensuring that the in-memory
 		 * copy is always up-to-date. A small blessing...
 		 */
-		__vcpu_sys_reg(vcpu, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
-		__vcpu_sys_reg(vcpu, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
-		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
-		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
+		__vcpu_assign_sys_reg(vcpu, SCTLR_EL2,	 read_sysreg_el1(SYS_SCTLR));
+		__vcpu_assign_sys_reg(vcpu, TTBR0_EL2,	 read_sysreg_el1(SYS_TTBR0));
+		__vcpu_assign_sys_reg(vcpu, TTBR1_EL2,	 read_sysreg_el1(SYS_TTBR1));
+		__vcpu_assign_sys_reg(vcpu, TCR_EL2,	 read_sysreg_el1(SYS_TCR));
 
 		if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
-			__vcpu_sys_reg(vcpu, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
+			__vcpu_assign_sys_reg(vcpu, TCR2_EL2, read_sysreg_el1(SYS_TCR2));
 
 			if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
-				__vcpu_sys_reg(vcpu, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
-				__vcpu_sys_reg(vcpu, PIR_EL2) = read_sysreg_el1(SYS_PIR);
+				__vcpu_assign_sys_reg(vcpu, PIRE0_EL2, read_sysreg_el1(SYS_PIRE0));
+				__vcpu_assign_sys_reg(vcpu, PIR_EL2, read_sysreg_el1(SYS_PIR));
 			}
 
 			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
-				__vcpu_sys_reg(vcpu, POR_EL2) = read_sysreg_el1(SYS_POR);
+				__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
 		}
 
 		/*
@@ -74,9 +74,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) |= val;
 	}
 
-	__vcpu_sys_reg(vcpu, SP_EL2)	= read_sysreg(sp_el1);
-	__vcpu_sys_reg(vcpu, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
-	__vcpu_sys_reg(vcpu, SPSR_EL2)	= read_sysreg_el1(SYS_SPSR);
+	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
+	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
+	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac8..94340dee5ae11 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -177,7 +177,7 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
 		val |= lower_32_bits(val);
 	}
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+	__vcpu_assign_sys_reg(vcpu, reg, val);
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(pmc);
@@ -228,7 +228,7 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 
 	reg = counter_index_to_reg(pmc->idx);
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+	__vcpu_assign_sys_reg(vcpu, reg, val);
 
 	kvm_pmu_release_perf_event(pmc);
 }
@@ -509,7 +509,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
 		if (!kvm_pmc_is_64bit(pmc))
 			reg = lower_32_bits(reg);
-		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
+		__vcpu_assign_sys_reg(vcpu, counter_index_to_reg(i), reg);
 
 		/* No overflow? move on */
 		if (kvm_pmc_has_64bit_overflow(pmc) ? reg : lower_32_bits(reg))
@@ -611,7 +611,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
+	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, (val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P)));
 
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
@@ -770,7 +770,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 		return;
 
 	reg = counter_index_to_evtreg(pmc->idx);
-	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
+	__vcpu_assign_sys_reg(vcpu, reg, (data & kvm_pmu_evtyper_mask(vcpu->kvm)));
 
 	kvm_pmu_create_perf_event(pmc);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 47aacacfdf33c..dfbbad2e95c04 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -228,7 +228,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 * to reverse-translate virtual EL2 system registers for a
 		 * non-VHE guest hypervisor.
 		 */
-		__vcpu_sys_reg(vcpu, reg) = val;
+		__vcpu_assign_sys_reg(vcpu, reg, val);
 
 		switch (reg) {
 		case CNTHCTL_EL2:
@@ -263,7 +263,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		return;
 
 memory_write:
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
@@ -605,7 +605,7 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if ((val ^ rd->val) & ~OSLSR_EL1_OSLK)
 		return -EINVAL;
 
-	__vcpu_sys_reg(vcpu, rd->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
 	return 0;
 }
 
@@ -835,7 +835,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 * The value of PMCR.N field is included when the
 	 * vCPU register is read via kvm_vcpu_read_pmcr().
 	 */
-	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
+	__vcpu_assign_sys_reg(vcpu, r->reg, pmcr);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -907,7 +907,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, p->regval);
 	else
 		/* return PMSELR.SEL field */
 		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
@@ -1184,8 +1184,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!vcpu_mode_priv(vcpu))
 			return undef_access(vcpu, p, r);
 
-		__vcpu_sys_reg(vcpu, PMUSERENR_EL0) =
-			       p->regval & ARMV8_PMU_USERENR_MASK;
+		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0,
+				      (p->regval & ARMV8_PMU_USERENR_MASK));
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
 			    & ARMV8_PMU_USERENR_MASK;
@@ -1235,7 +1235,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 
-	__vcpu_sys_reg(vcpu, r->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
 	return 0;
 }
 
@@ -2155,7 +2155,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (kvm_has_mte(vcpu->kvm))
 		clidr |= 2ULL << CLIDR_TTYPE_SHIFT(loc);
 
-	__vcpu_sys_reg(vcpu, r->reg) = clidr;
+	__vcpu_assign_sys_reg(vcpu, r->reg, clidr);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -2169,7 +2169,7 @@ static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
 		return -EINVAL;
 
-	__vcpu_sys_reg(vcpu, rd->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
 
 	return 0;
 }
@@ -2354,7 +2354,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, SP_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
 
@@ -2378,7 +2378,7 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
 
@@ -2390,7 +2390,7 @@ static bool access_cntkctl_el12(struct kvm_vcpu *vcpu,
 				const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, CNTKCTL_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, CNTKCTL_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, CNTKCTL_EL1);
 
@@ -2404,7 +2404,9 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
 		val |= HCR_E2H;
 
-	return __vcpu_sys_reg(vcpu, r->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static unsigned int __el2_visibility(const struct kvm_vcpu *vcpu,
@@ -4892,7 +4894,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (r->set_user) {
 		ret = (r->set_user)(vcpu, r, val);
 	} else {
-		__vcpu_sys_reg(vcpu, r->reg) = val;
+		__vcpu_assign_sys_reg(vcpu, r->reg, val);
 		ret = 0;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 1d94ed6efad2c..41bce6f70c689 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -137,7 +137,7 @@ static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
-	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
+	__vcpu_assign_sys_reg(vcpu, r->reg, 0x1de7ec7edbadc0deULL);
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
@@ -145,7 +145,7 @@ static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
-	__vcpu_sys_reg(vcpu, r->reg) = r->val;
+	__vcpu_assign_sys_reg(vcpu, r->reg, r->val);
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index c6048014aed7b..df261a699e1d5 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -370,12 +370,12 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
 	val &= ~ICH_HCR_EL2_EOIcount_MASK;
 	val |= (s_cpu_if->vgic_hcr & ICH_HCR_EL2_EOIcount_MASK);
-	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = val;
-	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
+	__vcpu_assign_sys_reg(vcpu, ICH_HCR_EL2, val);
+	__vcpu_assign_sys_reg(vcpu, ICH_VMCR_EL2, s_cpu_if->vgic_vmcr);
 
 	for (i = 0; i < 4; i++) {
-		__vcpu_sys_reg(vcpu, ICH_AP0RN(i)) = s_cpu_if->vgic_ap0r[i];
-		__vcpu_sys_reg(vcpu, ICH_AP1RN(i)) = s_cpu_if->vgic_ap1r[i];
+		__vcpu_assign_sys_reg(vcpu, ICH_AP0RN(i), s_cpu_if->vgic_ap0r[i]);
+		__vcpu_assign_sys_reg(vcpu, ICH_AP1RN(i), s_cpu_if->vgic_ap1r[i]);
 	}
 
 	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
@@ -384,7 +384,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 		val &= ~ICH_LR_STATE;
 		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
 
-		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
 		s_cpu_if->vgic_lr[i] = 0;
 	}
 
-- 
2.39.2

