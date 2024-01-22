Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842E41201
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954741; cv=none; b=FTBCuT2cNdbOGQJHYUO0UJcIhbCvRRxlg2W6bdTgF0vxl4Fjlsa3xWnvlQPUSYkTQ0jqQWPErKTltlkxD3gUIqDIfDAKQsIRPYD77w8DZaxedXyKBr/eqdQd4bnUW1cyH4WJ9VQyPaJHDZwRSeiDPkLlf3q/8ja7AQlTbNrLnMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954741; c=relaxed/simple;
	bh=yfQw27uypy6nWxjVmIO46NVDSU89PA7qGvu4ElBGR3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UD1CuKjNLQcQmkmnneJslMt6FnRKKJaR9PVPJkNPCz60e0oyaA/q2QIQXeuiGQ1NYeK4h1nTKYGBFgtuOTy9hzGsbQ9BlFgc33T6/sbFmGmh0uaFL8QkWLpLrCBIeEjcNMwoO6528KhEByEoU2EVsPRPMWgO5v++tiRdMW0WqKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joBmCNw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joBmCNw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAC3C43141;
	Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954740;
	bh=yfQw27uypy6nWxjVmIO46NVDSU89PA7qGvu4ElBGR3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joBmCNw8rj6XIibhL9UQdKsbfID5vTCQUbajq6qZyfXz1zJsOzGAMt6Z878Lg8CLF
	 U/DeWJMlecmz7aBPW6crkIBTIRGuNvxohdwNsuVsBGa2IwSikrfd4eI490OK3zsgZq
	 1HoeCfSQV6kVeft4sMGKYanAqZEx64JytnQVqR7gqKgLGiv8MyW274PtCah2j7y07N
	 MC4pX8jraFHK9SoA0oMZYnm0L43xpHN35lSxIlXy730p5laAObfINN8sMkQDLTJunL
	 dTyaPJORxLjaRWJ2MWoOsacaBDYX0Z7t9YwfY6WXSuqhyBquHbWf1VO0yBfxc2i1Eo
	 2IvzvfOJKMbMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l1-00DjkQ-18;
	Mon, 22 Jan 2024 20:18:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 18/25] KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
Date: Mon, 22 Jan 2024 20:18:45 +0000
Message-Id: <20240122201852.262057-19-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to correctly honor our FGU bits, they must be converted
into a set of FGT bits. They get merged as part of the existing
FGT setting.

Similarly, the UNDEF injection phase takes place when handling
the trap.

This results in a bit of rework in the FGT macros in order to
help with the code generation, as burying per-CPU accesses in
macros results in a lot of expansion, not to mention the vcpu->kvm
access on nvhe (kern_hyp_va() is not optimisation-friendly).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c         | 11 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 81 +++++++++++++++++++------
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 539b3913628d..f64d1809fe79 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2011,6 +2011,17 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	if (!tc.val)
 		goto local;
 
+	/*
+	 * If a sysreg can be trapped using a FGT, first check whether we
+	 * trap for the purpose of forbidding the feature. In that case,
+	 * inject an UNDEF.
+	 */
+	if (tc.fgt != __NO_FGT_GROUP__ &&
+	    (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
+		kvm_inject_undefined(vcpu);
+		return true;
+	}
+
 	/*
 	 * If we're not nesting, immediately return to the caller, with the
 	 * sysreg index, should we have it.
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a038320cdb08..a09149fd91ed 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -79,14 +79,48 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		clr |= ~hfg & __ ## reg ## _nMASK; 			\
 	} while(0)
 
-#define update_fgt_traps_cs(vcpu, reg, clr, set)			\
+#define reg_to_fgt_group_id(reg)					\
+	({								\
+		enum fgt_group_id id;					\
+		switch(reg) {						\
+		case HFGRTR_EL2:					\
+		case HFGWTR_EL2:					\
+			id = HFGxTR_GROUP;				\
+			break;						\
+		case HFGITR_EL2:					\
+			id = HFGITR_GROUP;				\
+			break;						\
+		case HDFGRTR_EL2:					\
+		case HDFGWTR_EL2:					\
+			id = HDFGRTR_GROUP;				\
+			break;						\
+		case HAFGRTR_EL2:					\
+			id = HAFGRTR_GROUP;				\
+			break;						\
+		default:						\
+			BUILD_BUG_ON(1);				\
+		}							\
+									\
+		id;							\
+	})
+
+#define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
+	do {								\
+		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
+		set |= hfg & __ ## reg ## _MASK;			\
+		clr |= hfg & __ ## reg ## _nMASK; 			\
+	} while(0)
+
+#define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
 	do {								\
-		struct kvm_cpu_context *hctxt =				\
-			&this_cpu_ptr(&kvm_host_data)->host_ctxt;	\
 		u64 c = 0, s = 0;					\
 									\
 		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
-		compute_clr_set(vcpu, reg, c, s);			\
+		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))		\
+			compute_clr_set(vcpu, reg, c, s);		\
+									\
+		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
+									\
 		s |= set;						\
 		c |= clr;						\
 		if (c || s) {						\
@@ -97,8 +131,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		}							\
 	} while(0)
 
-#define update_fgt_traps(vcpu, reg)		\
-	update_fgt_traps_cs(vcpu, reg, 0, 0)
+#define update_fgt_traps(hctxt, vcpu, kvm, reg)		\
+	update_fgt_traps_cs(hctxt, vcpu, kvm, reg, 0, 0)
 
 /*
  * Validate the fine grain trap masks.
@@ -122,6 +156,7 @@ static inline bool cpu_has_amu(void)
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
 	u64 r_val, w_val;
 
@@ -157,6 +192,9 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
 	}
 
+	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
+	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
+
 	/* The default to trap everything not handled or supported in KVM. */
 	tmp = HFGxTR_EL2_nAMAIR2_EL1 | HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nS2POR_EL1 |
 	      HFGxTR_EL2_nPOR_EL1 | HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nACCDATA_EL1;
@@ -172,20 +210,26 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
 	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
 
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
-		return;
-
-	update_fgt_traps(vcpu, HFGITR_EL2);
-	update_fgt_traps(vcpu, HDFGRTR_EL2);
-	update_fgt_traps(vcpu, HDFGWTR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
 
 	if (cpu_has_amu())
-		update_fgt_traps(vcpu, HAFGRTR_EL2);
+		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
 }
 
+#define __deactivate_fgt(htcxt, vcpu, kvm, reg)				\
+	do {								\
+		if ((vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) ||	\
+		    kvm->arch.fgu[reg_to_fgt_group_id(reg)])		\
+			write_sysreg_s(ctxt_sys_reg(hctxt, reg),	\
+				       SYS_ ## reg);			\
+	} while(0)
+
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
@@ -193,15 +237,12 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
 
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
-		return;
-
-	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
-	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
-	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
 
 	if (cpu_has_amu())
-		write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2), SYS_HAFGRTR_EL2);
+		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
-- 
2.39.2

