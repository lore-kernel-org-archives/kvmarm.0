Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4162F268C6F
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934524; cv=none; b=lsLcegVv8HHtoq/g5nTcNNbqV0JUCyoo4s73T18+mzky5PMJMaRoBhl7VopShVqFUWxF6YKQWqA/oq25ymtBpfykFPwexEYsgkHGGuE+EARZlyrlWjmMRAuZzS0NR9JFa7fypijTUWtPT6q4EgNa57WC/Z6faSEorGfmzXpU1R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934524; c=relaxed/simple;
	bh=BxjW1lj8ivu9+7Imc3lWmvxvsoetXRBZaLRUGB3pWcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=duk4frjADwZEXBUa1kgeNHO2QG4nABRJyRu8pVKMiR9cRSK5mbE0VblW1oIedYlWrWaVpfdMHBLgyd3yuRk5GPSiPutPWXUYgsIcTj45ki7BCtzm8otCugpjqy/LhJ8o6Vwv80Lj/HLFRAiRRrVMZ6fUCGAp5krZQqmJrF2ptlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jo1rTE87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jo1rTE87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B366C4CEEF;
	Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748934523;
	bh=BxjW1lj8ivu9+7Imc3lWmvxvsoetXRBZaLRUGB3pWcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo1rTE87uzxdzblzwrlx7fJda1qBAz0d1jjICpi69F1kUTdP3QlLP8DbFnmHiSDPH
	 z9bUCAo7GA0vH+VaBb3hmKsRun1GkKwWHFrXlU/SqU6An6/j7OXLuzQNKnf6JLt2To
	 JMq9YboVq2QMobUVGet910j+Of5iQsEcQZOYGf6bm9A97bwq9YWydjdCd999IUC9fg
	 0l3JYMuHCyp0ewDR0E2wR/W9+qX3lhRZ64zvJ5oUecXiI6pWj2JUZurmJCfJBr6eoC
	 5ok1XC6dLsSkY4mLxaUPBIQeGlCv8CCJcoanD6e5HFDsPyp0FQHV7tg6h6f3SzJ43g
	 6Lg0MinY0bR3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uMLlJ-002isr-CF;
	Tue, 03 Jun 2025 08:08:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/4] KVM: arm64: Add assignment-specific sysreg accessor
Date: Tue,  3 Jun 2025 08:08:21 +0100
Message-Id: <20250603070824.1192795-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
References: <20250603070824.1192795-1-maz@kernel.org>
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
 arch/arm64/kvm/hyp/exception.c             |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 44 +++++++++++-----------
 arch/arm64/kvm/pmu-emul.c                  | 14 +++----
 arch/arm64/kvm/sys_regs.c                  | 38 ++++++++++---------
 arch/arm64/kvm/sys_regs.h                  |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++---
 12 files changed, 86 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d941abc6b5eef..3b84ad91116b4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1107,6 +1107,17 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
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
index 5133dcbfe9f76..5a67a6d4d95b7 100644
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
index eef310cdbdbd5..aa5b561b92182 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -45,7 +45,7 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
+	__vcpu_assign_sys_reg(vcpu, FPEXC32_EL2, read_sysreg(fpexc32_el2));
 }
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
@@ -457,7 +457,7 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	 */
 	if (vcpu_has_sve(vcpu)) {
 		zcr_el1 = read_sysreg_el1(SYS_ZCR);
-		__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)) = zcr_el1;
+		__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
 
 		/*
 		 * The guest's state is always saved using the guest's max VL.
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index b9cff893bbe0b..4d0dbea4c56f7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -307,11 +307,11 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
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
index 8e8848de4d470..e9198e56e784b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -26,7 +26,7 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 {
-	__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
 	/*
 	 * On saving/restoring guest sve state, always use the maximum VL for
 	 * the guest. The layout of the data when saving the sve state depends
@@ -79,7 +79,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 
 	has_fpmr = kvm_has_fpmr(kern_hyp_va(vcpu->kvm));
 	if (has_fpmr)
-		__vcpu_sys_reg(vcpu, FPMR) = read_sysreg_s(SYS_FPMR);
+		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c9b330dc20669..09df2b42bc1b7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -223,9 +223,9 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
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
index 3814b0b2c937f..34c7bf7fe9def 100644
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
index 25c29107f13fd..4f0ae8073f788 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -178,7 +178,7 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
 		val |= lower_32_bits(val);
 	}
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+	__vcpu_assign_sys_reg(vcpu, reg, val);
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(pmc);
@@ -204,7 +204,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
 	kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
-	__vcpu_sys_reg(vcpu, counter_index_to_reg(select_idx)) = val;
+	__vcpu_assign_sys_reg(vcpu, counter_index_to_reg(select_idx), val);
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
@@ -239,7 +239,7 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 
 	reg = counter_index_to_reg(pmc->idx);
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+	__vcpu_assign_sys_reg(vcpu, reg, val);
 
 	kvm_pmu_release_perf_event(pmc);
 }
@@ -503,7 +503,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
 		if (!kvm_pmc_is_64bit(pmc))
 			reg = lower_32_bits(reg);
-		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
+		__vcpu_assign_sys_reg(vcpu, counter_index_to_reg(i), reg);
 
 		/* No overflow? move on */
 		if (kvm_pmc_has_64bit_overflow(pmc) ? reg : lower_32_bits(reg))
@@ -602,7 +602,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
+	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, (val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P)));
 
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
@@ -779,7 +779,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	u64 reg;
 
 	reg = counter_index_to_evtreg(pmc->idx);
-	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
+	__vcpu_assign_sys_reg(vcpu, reg, (data & kvm_pmu_evtyper_mask(vcpu->kvm)));
 
 	kvm_pmu_create_perf_event(pmc);
 }
@@ -1038,7 +1038,7 @@ static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
 			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
 			val &= ~MDCR_EL2_HPMN;
 			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
-			__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
+			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
 		}
 	}
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 707c651aff031..93d0ca7ed9365 100644
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
@@ -1076,7 +1076,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 {
 	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
-	__vcpu_sys_reg(vcpu, r->reg) = val & mask;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	return 0;
@@ -1185,8 +1185,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!vcpu_mode_priv(vcpu))
 			return undef_access(vcpu, p, r);
 
-		__vcpu_sys_reg(vcpu, PMUSERENR_EL0) =
-			       p->regval & ARMV8_PMU_USERENR_MASK;
+		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0,
+				      (p->regval & ARMV8_PMU_USERENR_MASK));
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
 			    & ARMV8_PMU_USERENR_MASK;
@@ -1237,7 +1237,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 
-	__vcpu_sys_reg(vcpu, r->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	return 0;
@@ -2207,7 +2207,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (kvm_has_mte(vcpu->kvm))
 		clidr |= 2ULL << CLIDR_TTYPE_SHIFT(loc);
 
-	__vcpu_sys_reg(vcpu, r->reg) = clidr;
+	__vcpu_assign_sys_reg(vcpu, r->reg, clidr);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -2221,7 +2221,7 @@ static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
 		return -EINVAL;
 
-	__vcpu_sys_reg(vcpu, rd->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
 
 	return 0;
 }
@@ -2398,7 +2398,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, SP_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
 
@@ -2422,7 +2422,7 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
 
@@ -2434,7 +2434,7 @@ static bool access_cntkctl_el12(struct kvm_vcpu *vcpu,
 				const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, CNTKCTL_EL1) = p->regval;
+		__vcpu_assign_sys_reg(vcpu, CNTKCTL_EL1, p->regval);
 	else
 		p->regval = __vcpu_sys_reg(vcpu, CNTKCTL_EL1);
 
@@ -2448,7 +2448,9 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
 		val |= HCR_E2H;
 
-	return __vcpu_sys_reg(vcpu, r->reg) = val;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static unsigned int __el2_visibility(const struct kvm_vcpu *vcpu,
@@ -2619,7 +2621,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 		u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
 	}
 
-	__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
+	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
 
 	/*
 	 * Request a reload of the PMU to enable/disable the counters
@@ -2748,7 +2750,7 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	__vcpu_sys_reg(vcpu, r->reg) = vcpu->kvm->arch.nr_pmu_counters;
+	__vcpu_assign_sys_reg(vcpu, r->reg, vcpu->kvm->arch.nr_pmu_counters);
 	return vcpu->kvm->arch.nr_pmu_counters;
 }
 
@@ -5006,7 +5008,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (r->set_user) {
 		ret = (r->set_user)(vcpu, r, val);
 	} else {
-		__vcpu_sys_reg(vcpu, r->reg) = val;
+		__vcpu_assign_sys_reg(vcpu, r->reg, val);
 		ret = 0;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc6338d387663..ef97d9fc67cc5 100644
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
index 4f6954c306747..d22a8ad7bcc51 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -356,12 +356,12 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
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
@@ -370,7 +370,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 		val &= ~ICH_LR_STATE;
 		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
 
-		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
 		s_cpu_if->vgic_lr[i] = 0;
 	}
 
-- 
2.39.2

