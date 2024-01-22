Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08940C17
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954740; cv=none; b=JZw0EKVO4q+nNYJoK1wiPa4zR6tvnefdI+v+pvCSSssOPJXEYbdprCmvD7lTLAQEN+UftuBuWGOcm57dAmDnA7ks4hRU+S9IJ/gP51QNTpkR4eYZesjIXOXFiPnf/X/0Zp3+CybBKEIF1bv5IA/YQ8GVPztMd/psF6T4SEnm+Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954740; c=relaxed/simple;
	bh=36NqEmOWOXJ2oj/3DhGOnM/BUgZpY4GwL+lDh2xe5AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNdLkwF09r6Mw1tgUvL+f31/lpXq4wxw/4xGaOUR2Qlw3xiORiPylT7l65RCud1StAquRcvHkNXMF/OrlqODOWGFgxhXTGkD2i722jF5qa0r0OO7W8VmWc3hB9tgCi49D6nsm7nll3x5Tf65CinlKdL2Aw5xJgyaxp6t5M9I8zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3CIi1BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3CIi1BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C257C43394;
	Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954740;
	bh=36NqEmOWOXJ2oj/3DhGOnM/BUgZpY4GwL+lDh2xe5AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3CIi1BZzEMEfNpQBd7ezmFpVXeyBioEQxRbCVqitMwQa+CKHF0HrjSJiHLZb7vhr
	 zIhyk0KdwlEPtpMAxTVRxHOdOEKDI3vniwthhTNTkOqd3Ch9CUHstIrGvuQwL33jFC
	 cFVDC0VU7WEaPdLO5xzE9xOENoMA4HsOXXWBVmDwbSzhEDA4BSjvfk4HwUKRuOD5Z/
	 8ibZFCHDcfrMF4kDgqVmTP2Jk4HgHgt9upzi6FjKNkCsHG5EeWmlalmxcl/yYHtsDs
	 Jc7RNGKqWvG2puFG0en6FmVOPDXtpMKgCzCm/IxBD3cDclvmjlalxaL5gTRqvKHnW1
	 PhDl/AxteVI9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l0-00DjkQ-ES;
	Mon, 22 Jan 2024 20:18:58 +0000
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
Subject: [PATCH 15/25] KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
Date: Mon, 22 Jan 2024 20:18:42 +0000
Message-Id: <20240122201852.262057-16-maz@kernel.org>
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

Since we always start sysreg/sysinsn handling by searching the
xarray, use it as the source of the index in the correct sys_reg_desc
array.

This allows some cleanup, such as moving the handling of unknown
sysregs in a single location.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/emulate-nested.c     | 36 +++++++++++-----
 arch/arm64/kvm/sys_regs.c           | 64 +++++++++--------------------
 3 files changed, 46 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4882905357f4..68465f87d308 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,7 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
-extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
+extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_idx);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 342d43b66fda..54ab4d240fc6 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2001,7 +2001,7 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
 }
 
-bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
+bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_index)
 {
 	union trap_config tc;
 	enum trap_behaviour b;
@@ -2009,9 +2009,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	u32 sysreg;
 	u64 esr, val;
 
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
-		return false;
-
 	esr = kvm_vcpu_get_esr(vcpu);
 	sysreg = esr_sys64_to_sysreg(esr);
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
@@ -2022,13 +2019,16 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	 * A value of 0 for the whole entry means that we know nothing
 	 * for this sysreg, and that it cannot be re-injected into the
 	 * nested hypervisor. In this situation, let's cut it short.
-	 *
-	 * Note that ultimately, we could also make use of the xarray
-	 * to store the index of the sysreg in the local descriptor
-	 * array, avoiding another search... Hint, hint...
 	 */
 	if (!tc.val)
-		return false;
+		goto local;
+
+	/*
+	 * If we're not nesting, immediately return to the caller, with the
+	 * sysreg index, should we have it.
+	 */
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		goto local;
 
 	switch ((enum fgt_group_id)tc.fgt) {
 	case __NO_FGT_GROUP__:
@@ -2070,7 +2070,7 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	case __NR_FGT_GROUP_IDS__:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
-		return false;
+		goto local;
 	}
 
 	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu->kvm, is_read,
@@ -2083,6 +2083,22 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
 		goto inject;
 
+local:
+	if (!tc.msr) {
+		struct sys_reg_params params;
+
+		params = esr_sys64_to_params(esr);
+
+		// IMPDEF range. See ARM DDI 0487E.a, section D12.3.2
+		if (!(params.Op0 == 3 && (params.CRn & 0b1011) == 0b1011))
+			print_sys_reg_msg(&params,
+					  "Unsupported guest access at: %lx\n",
+					  *vcpu_pc(vcpu));
+		kvm_inject_undefined(vcpu);
+		return true;
+	}
+
+	*sr_index = tc.msr - 1;
 	return false;
 
 inject:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 65319193e443..794d1f8c9bfe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3397,12 +3397,6 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 	return kvm_handle_cp_32(vcpu, &params, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
-static bool is_imp_def_sys_reg(struct sys_reg_params *params)
-{
-	// See ARM DDI 0487E.a, section D12.3.2
-	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
-}
-
 /**
  * emulate_sys_reg - Emulate a guest access to an AArch64 system register
  * @vcpu: The VCPU pointer
@@ -3411,44 +3405,22 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
  * Return: true if the system register access was successful, false otherwise.
  */
 static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
-			   struct sys_reg_params *params)
+			    struct sys_reg_params *params)
 {
 	const struct sys_reg_desc *r;
 
 	r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
 		return true;
 	}
 
-	if (is_imp_def_sys_reg(params)) {
-		kvm_inject_undefined(vcpu);
-	} else {
-		print_sys_reg_msg(params,
-				  "Unsupported guest sys_reg access at: %lx [%08lx]\n",
-				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
-		kvm_inject_undefined(vcpu);
-	}
-	return false;
-}
-
-static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
-{
-	const struct sys_reg_desc *r;
-
-	/* Search from the system instruction table. */
-	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
+	print_sys_reg_msg(params,
+			  "Unsupported guest sys_reg access at: %lx [%08lx]\n",
+			  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
+	kvm_inject_undefined(vcpu);
 
-	if (likely(r)) {
-		perform_access(vcpu, p, r);
-	} else {
-		kvm_err("Unsupported guest sys instruction at: %lx\n",
-			*vcpu_pc(vcpu));
-		print_sys_reg_instr(p);
-		kvm_inject_undefined(vcpu);
-	}
-	return 1;
+	return false;
 }
 
 static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
@@ -3504,31 +3476,33 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
  */
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 {
+	const struct sys_reg_desc *desc = NULL;
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	int sr_idx;
 
 	trace_kvm_handle_sys_reg(esr);
 
-	if (__check_nv_sr_forward(vcpu))
+	if (__check_nv_sr_forward(vcpu, &sr_idx))
 		return 1;
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	/* System register? */
-	if (params.Op0 == 2 || params.Op0 == 3) {
-		if (!emulate_sys_reg(vcpu, &params))
-			return 1;
+	if (params.Op0 == 2 || params.Op0 == 3)
+		desc = &sys_reg_descs[sr_idx];
+	else
+		desc = &sys_insn_descs[sr_idx];
 
-		if (!params.is_write)
-			vcpu_set_reg(vcpu, Rt, params.regval);
+	perform_access(vcpu, &params, desc);
 
-		return 1;
-	}
+	/* Read from system register? */
+	if (!params.is_write &&
+	    (params.Op0 == 2 || params.Op0 == 3))
+		vcpu_set_reg(vcpu, Rt, params.regval);
 
-	/* Hints, PSTATE (Op0 == 0) and System instructions (Op0 == 1) */
-	return emulate_sys_instr(vcpu, &params);
+	return 1;
 }
 
 /******************************************************************************
-- 
2.39.2

