Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A73FC1B
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 17:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6B6C4339B;
	Mon, 15 May 2023 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684172909;
	bh=633L6P+bRDVQUgUq0eMcxFBGic1A5RLICoxkVksR8CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6vIS4YSWZGhIsme9D2WzsIQgG0V/FgEXoA75DtOJZPnPvug8zG7wV47EecnMAAdV
	 gizpGZC10rM60e6I/EwAbhPVkOqD2ybJSxEwYWrx8OwUwqNnwyqZ9fFHDXO5fo3Gxj
	 08cDZYXqWn3dYFukvfM412yhnXEnSAQ70f5nZH+eQ+vS9SG1EW9WdNm+c2fsDgJR9z
	 Sqz9q2M+/XlqN0ybPMdYl9+WxqHMqhD1DZePFUQQd96q1FCxRkzxP8RE56nBimcl8m
	 2bTq/B2uWY1cBHksMPsB3ggn3CLXlJPjw/tvRarxz/z1GiI79jm7CTPKOpB9JNsW3Z
	 gR9897YifbasA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pyc2m-00FJAF-Ma;
	Mon, 15 May 2023 18:31:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 35/59] KVM: arm64: nv: Add handling of EL2-specific timer registers
Date: Mon, 15 May 2023 18:30:39 +0100
Message-Id: <20230515173103.1017669-36-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the required handling for EL2 and EL02 registers, as
well as EL1 registers used in the E2H context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |   7 +++
 arch/arm64/kvm/sys_regs.c       | 102 +++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9f4a3bf6f182..3508ba196b55 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -428,6 +428,7 @@
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 #define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTVCT_EL0			sys_reg(3, 3, 14, 0, 2)
 #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
 
@@ -543,6 +544,12 @@
 
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+#define SYS_CNTHP_TVAL_EL2		sys_reg(3, 4, 14, 2, 0)
+#define SYS_CNTHP_CTL_EL2		sys_reg(3, 4, 14, 2, 1)
+#define SYS_CNTHP_CVAL_EL2		sys_reg(3, 4, 14, 2, 2)
+#define SYS_CNTHV_TVAL_EL2		sys_reg(3, 4, 14, 3, 0)
+#define SYS_CNTHV_CTL_EL2		sys_reg(3, 4, 14, 3, 1)
+#define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
 
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0ed928dfe345..6be7a2615f01 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1313,26 +1313,111 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg) {
 	case SYS_CNTP_TVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
 	case SYS_AARCH32_CNTP_TVAL:
+	case SYS_CNTP_TVAL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_TVAL;
 		break;
+
+	case SYS_CNTV_TVAL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
+	case SYS_CNTHP_TVAL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
+	case SYS_CNTHV_TVAL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
 	case SYS_CNTP_CTL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
 	case SYS_AARCH32_CNTP_CTL:
+	case SYS_CNTP_CTL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CTL;
 		break;
+
+	case SYS_CNTV_CTL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
+	case SYS_CNTHP_CTL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
+	case SYS_CNTHV_CTL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
 	case SYS_CNTP_CVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
 	case SYS_AARCH32_CNTP_CVAL:
+	case SYS_CNTP_CVAL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CVAL;
 		break;
+
+	case SYS_CNTV_CVAL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTHP_CVAL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTHV_CVAL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTVOFF_EL2:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_VOFF;
+		break;
+
 	case SYS_CNTPCT_EL0:
 	case SYS_CNTPCTSS_EL0:
+		if (is_hyp_ctxt(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CNT;
+		break;
+
 	case SYS_AARCH32_CNTPCT:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CNT;
 		break;
+
 	default:
 		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
 		kvm_inject_undefined(vcpu);
@@ -2396,8 +2481,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
-	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
+	EL2_REG(CNTVOFF_EL2, access_arch_timer, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
+
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0),
 
 	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
 	EL12_REG(CPACR, access_rw, reset_val, 0),
@@ -2416,6 +2508,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL12_REG(CONTEXTIDR, access_vm_reg, reset_val, 0),
 	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
 
+	{ SYS_DESC(SYS_CNTP_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CVAL_EL02), access_arch_timer },
+
+	{ SYS_DESC(SYS_CNTV_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CVAL_EL02), access_arch_timer },
+
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
-- 
2.34.1

