Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA89C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B596549F20;
	Thu, 10 Mar 2022 23:49:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Cbi5VJFrWVm; Thu, 10 Mar 2022 23:49:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4842A49F27;
	Thu, 10 Mar 2022 23:49:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA9C49F01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QDpblijDF2ps for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:49:07 -0500 (EST)
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com
 [209.85.167.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C753041174
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:06 -0500 (EST)
Received: by mail-oi1-f201.google.com with SMTP id
 q24-20020a056808201800b002d793543f32so5271449oiw.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BOtqtDPmFVbXSVQplJqqHWzAUqxe06WK8Hgp5xswEjo=;
 b=hjhU16IsuclGFWjBCSbzTVlbAwlKDoX+LoOaMMapNL8w6ClETZtePMebhWY3wK5qIK
 RZEHvgJmeqic7DauveyRHrogrFXjjQ85aC3eM8tEEZDRQgwFFdu1DoR7i7O5ksFs8Txt
 svGWTqmO2+IXkKE0AZ43wyFmymaBBq/gDGxMFfrjh4/l3akP8lAMWo204hbl6MV1Zg/k
 qKMoVz0evWLjjaVKZeDfsnMMG9pfgq7OYNe+xMFlARUmlTiBUCwPaIpoYMUuftn6NsV/
 Baw2+PpEMVAYvXavy87vEyU6/Fx6J3KYqq0/epl8LhXllOnBkt2+UKcqAlmAixhzde6Z
 pHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BOtqtDPmFVbXSVQplJqqHWzAUqxe06WK8Hgp5xswEjo=;
 b=ljYQY5l4qnaHEfetoKtemi6VfZ7NkhBdeBtdqF9CtRw2YZVMP7p+zWUJrkndOADzzE
 m/40mLtz7tpi6PqOpyiiD77+kbOSqZ0JmhyDY/fABVW4pNKu2UBOIn59t7J7dVCLRn45
 B5HzG8eGqBz1zAw3gJ2Eb4LogR+xik58PCrckgBvrIoQE6U4bYNTNvOMChcs9NfuUlKV
 ppcBGs1MQ05hyan+Xrjx9wKxuiMbctPYfMjsUfUIS0y0881Za3QVq3NYAzcF91Jcufy/
 XddKxsTcD3whzRj579L0N0MqSqKHrg72m5MiIRW9ibOhWYZMgsuUFTg+zLJNynXpyTZT
 Y4nQ==
X-Gm-Message-State: AOAM530nzXYtpdhMJjm1bWTNO3x7R62qsYc7BOgddwX6sEDtkTgFFZ/7
 UsTr3PSIQzMXfSpjkjGoAlQi4YRlvO8=
X-Google-Smtp-Source: ABdhPJwxlwQXx8fxZeLKU4n6nbDbzjRmOlYI/0f1fj5lPlt6ZBH1yo0WCK5jePLAp870++wELV/pob1U/z4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6870:c588:b0:da:3d88:de58 with SMTP id
 ba8-20020a056870c58800b000da3d88de58mr10499144oab.32.1646974145880; Thu, 10
 Mar 2022 20:49:05 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:07 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 21/25] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
indicated in ID_AA64DFR0_EL1, to program configuration registers
to trap guest's using those features when they are not exposed to
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 924ffedf4b05..677815030d44 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -350,6 +350,30 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
 }
 
+static void feature_trace_trap_activate(struct kvm_vcpu *vcpu)
+{
+	if (has_vhe())
+		feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPACR_EL1_TTA, 0);
+	else
+		feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TTA, 0);
+}
+
+static void feature_pmuv3_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPM, 0);
+}
+
+static void feature_pms_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPMS,
+			      MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
+}
+
+static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -376,6 +400,39 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.trap_activate = feature_mte_trap_activate,
 };
 
+/* For ID_AA64DFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_trace = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACEVER_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_trace_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMUVER_8_0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_pmuv3_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_pms = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMSVER_8_2,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_pms_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_tracefilt = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_tracefilt_trap_activate,
+};
+
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3733,6 +3790,13 @@ static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.init = init_id_aa64dfr0_el1_desc,
 	.validate = validate_id_aa64dfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_trace,
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_dfr0_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
