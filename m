Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A815C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:08:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A334B220;
	Mon, 29 Nov 2021 15:08:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h1pGUpUQn5PJ; Mon, 29 Nov 2021 15:07:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB1644B256;
	Mon, 29 Nov 2021 15:07:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27FD4B1E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDl1hyLtY3yg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:51 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88B794B23B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:50 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B2F30B81630;
 Mon, 29 Nov 2021 20:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1F3C53FAD;
 Mon, 29 Nov 2021 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216468;
 bh=UU8kyF9hlHMIZSfl8J6xiEEU78BrTsnLzvIg32swVzY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=no7E06Jq5bDJD19btz4Yqa2+jGaAmcgUlA130HqtVivtDMns+VSxjFokHJzu47D+B
 hi3Ls5x9HSebNT3vwd3PihXwlT2RGP7ZZR6vJRCzr30vXDe9ulcKQclCTfw4LZ2pE6
 M73Y8e89SUUfBkxnoMwJd9adgKidRWJwguNfl0zqj33l5iLrRYUp4Lo4bTHROZClGx
 bEx90oDP6pXXGQelf2J9VsfJDMdFEKQbrYE3Ffnxk/jHg1CBJBccuIcJ0RatM/JDup
 twmIK7TjX46gU+xGz54OxPzlE+61vjDQ19vU1uDuHhL/KOCHRoqAE2u+dzxtF+SiPE
 cqOVpFmGqTpSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmr7-008gvR-Q7; Mon, 29 Nov 2021 20:02:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 49/69] KVM: arm64: nv: Add handling of EL2-specific timer
 registers
Date: Mon, 29 Nov 2021 20:01:30 +0000
Message-Id: <20211129200150.351436-50-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

Add the required handling for EL2 and EL02 registers, as
well as EL1 registers used in the E2H context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  6 +++
 arch/arm64/kvm/sys_regs.c       | 87 +++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 199333b02ece..71e6a0410e7c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -625,6 +625,12 @@
 
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
index e6c9a01670c9..4415b03aa278 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1311,20 +1311,92 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg) {
 	case SYS_CNTP_TVAL_EL0:
+		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
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
+		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
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
+		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
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
 	case SYS_CNTVOFF_EL2:
 		tmr = TIMER_VTIMER;
 		treg = TIMER_REG_VOFF;
@@ -2230,6 +2302,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTVOFF_EL2), access_arch_timer },
 	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
 
+	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
+	{ SYS_DESC(SYS_CNTHP_CTL_EL2), access_arch_timer },
+	{ SYS_DESC(SYS_CNTHP_CVAL_EL2), access_arch_timer },
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer },
+	{ SYS_DESC(SYS_CNTHV_CTL_EL2), access_arch_timer },
+	{ SYS_DESC(SYS_CNTHV_CVAL_EL2), access_arch_timer },
+
 	{ SYS_DESC(SYS_SCTLR_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_CPACR_EL12), access_rw, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_TTBR0_EL12), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -2247,6 +2326,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL12), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_rw, reset_val, CNTKCTL_EL1, 0 },
 
+	{ SYS_DESC(SYS_CNTP_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CVAL_EL02), access_arch_timer },
+
+	{ SYS_DESC(SYS_CNTV_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CVAL_EL02), access_arch_timer },
+
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
 };
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
