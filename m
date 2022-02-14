Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C75C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2F349EB3;
	Mon, 14 Feb 2022 02:01:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FW4rVKm5qemU; Mon, 14 Feb 2022 02:01:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D087A49E2B;
	Mon, 14 Feb 2022 02:01:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BEF49E20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1NQkoB-s6jyW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:34 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F48F40307
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:34 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 v14-20020a170902e8ce00b0014b48e8e498so5785144plg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mSRpxjHIlhptG36+PMQyXPeJOkFuTYwuZZGycm/GLdk=;
 b=rGVTfGKggvN6iR3mSSwoY2Pa7BNpyND9IY5sOWPcyJ/zZjbgwSGeQ0OZrFLTDuG+mJ
 kE5zYcxxih3QRjNxJsvfG7W4VI8AqCKQlLY9mpc3hiIpsRTLicdumsBcWspVug9vYJ0f
 VKdVrDoTQVOvJHv1LmX7z5YMegjua8kumBweR+NwZUMc39Q3fF9KWG/i57ZQUwVi/jC7
 f5g1tDavr1EPJRBQTe9UbqyoLjf1S+0dkRy886epazldjYK2xwXWgIC3v7x22IhWiE34
 hTKpwk9jvsiVnHBT+FR99JOSKm3Iz5cW3fdWEN4dpy1aj3e41aSpUPuc8Jaf5zRPhaCE
 +QUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mSRpxjHIlhptG36+PMQyXPeJOkFuTYwuZZGycm/GLdk=;
 b=MEzr/7FLniOTdkHYX/OET5AHNKH5ltIpMcayTorEocwaz+QMNDsVG0Mymc/MYo5YjQ
 4+lx6p/+vaciWdQPBKSp4Ewc3Im8olDZs1+w+m1sATtp6dpcurVKb1zANWXL/ETF+ddG
 Sb81QUNsrWzUZefKz+IcLjm1GPmzrACN6/RtAsejL5dF0YQe9oDr7tMqhnJB/FpzHg9D
 HMPJHQG1tBHVQ+slTXDErEtGSfsTd1O9iuBAuTK+H3DznWsMlXYNzL3ohSRFkMRGsfM6
 yd/2ZA8ZvZT4ozhuW7z1C/FKdhNERPxzy+TQeRhfs6HhOMpmh6ptpI3KrFxZwt/u50WL
 p3SA==
X-Gm-Message-State: AOAM530t6ZGtB4av2H23G5rXrbp3O9vU8bAt7wW0xMhLXWXwuVldkWQv
 e086tN04ImbGbRORPA/+qKtWxzVwYGk=
X-Google-Smtp-Source: ABdhPJx5Hnva0pItL3HUoljdoKfaWez4J61dUM7Uj7HSG9xqpxbCfqSDFLir+dEeNS3ayFvvMXIi9kkilZQ=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:404a:: with SMTP id
 n10mr13009659pla.132.1644822093198; Sun, 13 Feb 2022 23:01:33 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:42 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-24-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 23/27] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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
index a3d22f7f642b..d91be297559d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -349,6 +349,30 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -375,6 +399,39 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
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
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -941,6 +998,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.init = init_id_aa64dfr0_el1_info,
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
 
 static struct id_reg_info id_dfr0_el1_info = {
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
