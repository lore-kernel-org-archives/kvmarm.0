Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BDCC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD884A524;
	Wed,  5 Jan 2022 23:29:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9BhsQbjEVWsD; Wed,  5 Jan 2022 23:29:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368544A369;
	Wed,  5 Jan 2022 23:29:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D08C4B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R8k4x0yrNa1H for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:29:08 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84C3B49F19
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:05 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 d15-20020a17090ac24f00b001b2321b99ecso915395pjx.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vAzKz8VnLED7JizGSuKkWSji/qrCKwtnpVmiTZ6Ul2s=;
 b=nlnwOfQvStw+Mz8pAhxQWNUgrkdZWCwkurIHjLg+9XvBQSKPI0ruIWzx9i3TlRvImH
 m6z6XWk7Oh0v1de3XruoETBbXK2Jc3oSutRuWqGbdy9A4BeE651nGnvdyAagvVASxvO6
 bwJwHrStu95hSl4DhAwVrYf4rivTcyqqYZCcJ70NIos6rkqUoc6F2JVckr2yevgznADu
 /akLiPtHj2GBhRPH0L3NMvDlX/hZy32zpaNXQDoIxNetZ+8VdkP6inbJiDiSauuxQbR8
 VxnyQKrOvCIjh2jISoEhtb7eo5V9ybjPYiJqGYvP5bfcdnMteLYCXlQraB66IgSzQu+2
 rZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vAzKz8VnLED7JizGSuKkWSji/qrCKwtnpVmiTZ6Ul2s=;
 b=xO57q0DP+H7KkTJ0KZBiA4OjDNPnYmDfW4Tx4IN+fI1wJ2MTGknDenUPcDpUDiY0Qy
 I8rp0B2XOY5mLzaEwlZ70ycAVk7gyRNf1ODgJ3JsSJbXd1hLtQXO1WezQYy1taK2XpaM
 bAMt7MLUPyMviZu9fs56X861Vs4L6Fjyn2VN6TI/FE7jukCJ8+cgSi60Nj97iqpxPL3X
 MjC03CKZmYmrHJKaYvecUzGyW89g/1H5jp15pDFGEqf2bukpEjhLyRbfm4Gy1cacpX7h
 kTz5NTZ25zTbvmDeRNXkjyzEkA1lPtWkjU62ciHpiCPzjSY/bCPEEw3gICBu5SyoHGJq
 rNHA==
X-Gm-Message-State: AOAM530AumTUqxkDqzSGQo+p/9Il01K+QgDpHns722m/XB7IjPcAUalN
 DYXofA0JbeclxgZ88rNeJMF55Qx4gVo=
X-Google-Smtp-Source: ABdhPJzD5NQdlHGXFcJ/ANmXYaRnVSoPiNlfdJcywqQUu+s82OazALe8sdMAz6vdAAJzU2LN2c+4+RPgFw4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:b687:b0:149:90e2:8687 with SMTP id
 c7-20020a170902b68700b0014990e28687mr39915203pls.131.1641443344718; Wed, 05
 Jan 2022 20:29:04 -0800 (PST)
Date: Wed,  5 Jan 2022 20:27:04 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 22/26] KVM: arm64: Trap disabled features of
 ID_AA64DFR0_EL1
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
 arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 72e745c5a9c2..229671ec3abd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -349,6 +349,22 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
 }
 
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
@@ -375,6 +391,31 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.trap_activate = feature_mte_trap_activate,
 };
 
+/* For ID_AA64DFR0_EL1 */
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
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -898,6 +939,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.init = init_id_aa64dfr0_el1_info,
 	.validate = validate_id_aa64dfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_dfr0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
