Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F974175A1
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129289; cv=none; b=ZxtZpZ6HTkeYDDpPLW8RSAhzIyGBYo4Ue5qxAd87eyowBanfMP+qMM56rpcilWYc/C6HalwxIGJEOznm8wJm/iwdwk4Pb6eEgBCT0pm8VRiYetsxMaF3g9lIb1TpBfbDibyWMS8QReSsVc3J8wfTo0HEXRlGNoellZhQYeQu+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129289; c=relaxed/simple;
	bh=3XBYcxkKqKXvrbISIii+0zdSRbE4agXBct/ZOEhvdSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JVP5vHhfPuYRYi9+gLqE1IC7PPh6amJMEdSn/p3q+ORvKYodVpM0LoZmb6qD9DiJ7mGag99YRrUGim76Yy6rjDX1J8i8YaNtI/QDQYZBxP02584N2cBWtoo2T0kDRBxGPe0S++sSRIWmKRNGajohemgKO3VIzEldRW0gqNBoz7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NelsuAJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NelsuAJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D670C43330;
	Mon,  5 Feb 2024 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129289;
	bh=3XBYcxkKqKXvrbISIii+0zdSRbE4agXBct/ZOEhvdSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NelsuAJEXo2WBeYv1LgHEjBwk1vRNZq3exS3sG5uQAAGbzk+FtFLGYSL1vy++r0kd
	 ybVOu1ZkgEhXb3XjIPCasM+dGRntmgQkP8UmXjwnByXy0Zb7NcqAqc8FQw905mL6BF
	 xlA+As3NjF+jDg2SnGIA5J6DQ6pdWnjHcGD8Ii5STUiaOLC11uxf4tuHB5p3qpd1Hl
	 92oJWrlYEJNyJ0ulEjd57wspd/H4dTChMiFGEXhrv8ZUz1wncQQPpa3rWwCsy6cpop
	 FdbgVPv3IANMr2tapQ9qW3f8bqh7wObCZogVAg79NF6klY89hAEZINg9gbamWcx6IR
	 iAXXKU8RYCmWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJL-000Nc3-77;
	Mon, 05 Feb 2024 10:34:47 +0000
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
Subject: [PATCH v3 12/26] KVM: arm64: nv: Move system instructions to their own sys_reg_desc array
Date: Mon,  5 Feb 2024 10:34:17 +0000
Message-Id: <20240205103431.1104133-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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

As NV results in a bunch of system instructions being trapped, it makes
sense to pull the system instructions into their own little array, where
they will eventually be joined by AT, TLBI and a bunch of other CMOs.

Based on an initial patch by Jintack Lim.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3c31f8cb9eef..70043bd78cd4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2196,16 +2196,6 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
  * guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
-	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
-
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
 	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
@@ -2737,6 +2727,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static struct sys_reg_desc sys_insn_descs[] = {
+	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+};
+
 static const struct sys_reg_desc *first_idreg;
 
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
@@ -3429,6 +3431,24 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	const struct sys_reg_desc *r;
+
+	/* Search from the system instruction table. */
+	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
+
+	if (likely(r)) {
+		perform_access(vcpu, p, r);
+	} else {
+		kvm_err("Unsupported guest sys instruction at: %lx\n",
+			*vcpu_pc(vcpu));
+		print_sys_reg_instr(p);
+		kvm_inject_undefined(vcpu);
+	}
+	return 1;
+}
+
 static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
@@ -3476,7 +3496,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys_reg -- handles a system instruction or mrs/msr instruction
+ *			 trap on a guest execution
  * @vcpu: The VCPU pointer
  */
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
@@ -3493,12 +3514,19 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	if (!emulate_sys_reg(vcpu, &params))
+	/* System registers have Op0=={2,3}, as per DDI487 J.a C5.1.2 */
+	if (params.Op0 == 2 || params.Op0 == 3) {
+		if (!emulate_sys_reg(vcpu, &params))
+			return 1;
+
+		if (!params.is_write)
+			vcpu_set_reg(vcpu, Rt, params.regval);
+
 		return 1;
+	}
 
-	if (!params.is_write)
-		vcpu_set_reg(vcpu, Rt, params.regval);
-	return 1;
+	/* Hints, PSTATE (Op0 == 0) and System instructions (Op0 == 1) */
+	return emulate_sys_instr(vcpu, &params);
 }
 
 /******************************************************************************
@@ -3952,6 +3980,7 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
 	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
+	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
 		return -EINVAL;
-- 
2.39.2

