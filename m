Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9815CC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54EA249EF2;
	Tue, 19 Apr 2022 02:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9kkY3tiZdCNm; Tue, 19 Apr 2022 02:57:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB4C4B252;
	Tue, 19 Apr 2022 02:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 145274B24A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tcA0bXlV9r23 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:50 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6DFC4B218
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:50 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 f6-20020a170902ab8600b0015895212d23so9244292plr.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xydmrQbn6xBF8/ePfVL7th+l3rERvkG3uvSek2g29PM=;
 b=B3aAhbDXLtzCKoc11fDKloW896IaGDdEbmBBz/bkUK5ainOaSynxr95k4hqmcFDIOm
 XSX5BxR7DJS4pmGIm1pdkb9wUUT09tkOPCwpv3fW8NiTBWCkhm65qgJiC3a4BPQ+Ri0M
 +TPtopVHEVTAWl0UHuYBlZ/vjq4jdcvyIhVhZ1m6yXzS391nw+F+oBa+8z+Dwc0qjuBQ
 x0v2ScmIGPiHC/L7Gsw0wddnIzIPzFOMEvq+10S1VQ5N8DeDpwYRbaXHRXSTMQh8JkAm
 ye6N97rv5CM+hd43K7Hqn3bZZrNwsgFp+CA/u0fL/WatKT3gaILa4hshuBhr+8b4j7iL
 ZW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xydmrQbn6xBF8/ePfVL7th+l3rERvkG3uvSek2g29PM=;
 b=3+U8R94+7dAKadXasNw+dmfbpvVYh8PncyUATVk4a713XBOmUcdWnEEmEJ8K7nSMsX
 YcmBL/xAekF5he505LWIpFuHlb0FOV7h8heUjw1R/sX4oYoE9+peJ0e2KbaDFtUNMr9u
 gm5FMO3TISJop/UjeHT0gZeMmd6Or24/5CgdW0koBrP8E0SVpN/YtZ1W+DLrr+MpKm+L
 ElZzM3gkZh3xBymxAlITeboQlBZUy+ki+Yf1g3lBm9/yOMV4lol266aMI99ExXfZ7iZQ
 sLxdOwUpzaJmBdtndt0JXe5/+wVXQs0pvLUAXvi8s5UTiGcHWL1yTKck4yVRoxG9WQDv
 3Oeg==
X-Gm-Message-State: AOAM531jjhV9w0kyPew5x0dSCCNh2zZIp5Pn0QXGFSHcinxvW3oe7XoU
 m/JA6F+29+pHZn52YvrDcmHwG2eN2us=
X-Google-Smtp-Source: ABdhPJymWpo78icljcdDrBVhbQitXud9ofh1LnhHGu4eZMLV5WZFlPKgYwB0b6QD2F2Vs2FOm+A56WLFg34=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr22322996pjv.23.1650351469934; Mon, 18
 Apr 2022 23:57:49 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:33 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-28-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 27/38] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Add feature_config_ctrl for RAS and AMU, which are indicated in
ID_AA64PFR0_EL1, to program configuration registers to trap
guest's using those features when they are not exposed to the guest.

Introduce trap_ras_regs() to change a behavior of guest's access to
the registers, which is currently raz/wi, depending on the feature's
availability for the guest (and inject undefined instruction
exception when guest's RAS register access are trapped and RAS is
not exposed to the guest).  In order to keep the current visibility
of the RAS registers from userspace (always visible), a visibility
function for RAS registers is not added.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 92 +++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7fe44dec11fd..fecd54a58d34 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -320,6 +320,63 @@ struct feature_config_ctrl {
 	void	(*trap_activate)(struct kvm_vcpu *vcpu);
 };
 
+enum vcpu_config_reg {
+	VCPU_HCR_EL2 = 1,
+	VCPU_MDCR_EL2,
+	VCPU_CPTR_EL2,
+};
+
+static void feature_trap_activate(struct kvm_vcpu *vcpu,
+				  enum vcpu_config_reg cfg_reg,
+				  u64 cfg_set, u64 cfg_clear)
+{
+	u64 *reg_ptr, reg_val;
+
+	switch (cfg_reg) {
+	case VCPU_HCR_EL2:
+		reg_ptr = &vcpu->arch.hcr_el2;
+		break;
+	case VCPU_MDCR_EL2:
+		reg_ptr = &vcpu->arch.mdcr_el2;
+		break;
+	case VCPU_CPTR_EL2:
+		reg_ptr = &vcpu->arch.cptr_el2;
+		break;
+	}
+
+	/* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
+	reg_val = (*reg_ptr & ~cfg_clear);
+	reg_val |= cfg_set;
+	*reg_ptr = reg_val;
+}
+
+static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);
+}
+
+static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
+}
+
+/* For ID_AA64PFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ras = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_RAS_SHIFT,
+	.ftr_min = ID_AA64PFR0_RAS_V1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_ras_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_amu = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_AMU_SHIFT,
+	.ftr_min = ID_AA64PFR0_AMU,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_amu_trap_activate,
+};
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -954,6 +1011,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
 	return feature_avail(ctrl, val);
 }
 
+static bool trap_ras_regs(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_ras)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return trap_raz_wi(vcpu, p, r);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2786,14 +2855,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
 
-	{ SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERRIDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERRSELR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXFR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXADDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_ras_regs },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
@@ -4230,7 +4299,12 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	.ftr_bits = {
 		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, ID_AA64PFR0_FP_NI),
 		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, ID_AA64PFR0_ASIMD_NI),
-	}
+	},
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64pfr1_el1_desc = {
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
