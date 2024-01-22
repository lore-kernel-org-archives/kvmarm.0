Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D954840BFC
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954739; cv=none; b=nn8EpQ2xMcXCK5dJTOT4vDha1O7l9yrmjR0Ofitqpg2IFZIjgkeST/5dcoz43YKwv1CX1km5gaqAKlr7C3GQTnxyXwVQDcUYszibzBVxGKkPZhD3q8cy8SA4tOS7hiAlD+60mNDkHKE0t7KbAVMyhTi2xtH9xHDqx+LbAvwbRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954739; c=relaxed/simple;
	bh=OCmWdAHVB80p4sJHxBp0qI9adYX2SQKEBKMffyfLNj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C7f8Q6bRVTx61Wl6w9PguhPmHnBeaW3OFEaGDNPlQFTF56rRHtGXcN4bu2YjE/kVn8AnpZRk36zN5kVsfYxSUILJC0HwcIZhH6AAyEbfc9NI3iHywwC8hU9DRiIxZSnWD1b65taDDdoI6n64YXiLyvxP1M7y7f73L08CF/7Hxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOpvDSL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOpvDSL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAD0C43399;
	Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954739;
	bh=OCmWdAHVB80p4sJHxBp0qI9adYX2SQKEBKMffyfLNj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOpvDSL7g2l9n7pcFisVXNaeZuo38OXIzyYPUh7Pty77Hik/bH7eoYqCub4sS7uR4
	 8+htohp3GM6mF8zHDTPvd/0LXsGUORI/kkdKNu+GLp111NvqUa0typ4vlAgMVN4mMo
	 t1SiecRNNnvd57+rH+1xfjf3JZTxJo2g68gKIXXpR4ATORK5/hFDfrYJFUdnEoZoxH
	 HkRfgbMW6cxTj6/BJcsSOQ5yhsE4+lQwZqgmDFGD1S+tkJdB6op/Qnhe6oRL0tW6rC
	 hRd2PVigZHojCnGYY7o6yvIqKT+lRH64c6VwwDWUHfUVr3rk3WkHsnYLYf4aLIfvzS
	 oP67osXLkbNvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kz-00DjkQ-SA;
	Mon, 22 Jan 2024 20:18:57 +0000
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
Subject: [PATCH 12/25] KVM: arm64: nv: Move system instructions to their own sys_reg_desc array
Date: Mon, 22 Jan 2024 20:18:39 +0000
Message-Id: <20240122201852.262057-13-maz@kernel.org>
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

As NV results in a bunch of system instructions being trapped, it makes
sense to pull the system instructions into their own little array, where
they will eventually be joined by AT, TLBI and a bunch of other CMOs.

Based on an initial patch by Jintack Lim.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 041b11825578..501de653beb5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2197,16 +2197,6 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
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
@@ -2738,6 +2728,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3431,6 +3433,24 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
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
@@ -3478,7 +3498,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys_reg -- handles a system instruction or mrs/msr instruction
+ *			 trap on a guest execution
  * @vcpu: The VCPU pointer
  */
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
@@ -3495,12 +3516,19 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	if (!emulate_sys_reg(vcpu, &params))
+	/* System register? */
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
@@ -3954,6 +3982,7 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
 	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
+	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
 		return -EINVAL;
-- 
2.39.2

