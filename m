Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECD9C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5284B49EE7;
	Thu, 10 Mar 2022 23:49:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2KSEQCLBt1ZU; Thu, 10 Mar 2022 23:49:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E47149EEA;
	Thu, 10 Mar 2022 23:49:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB74649EE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ERK+kp4LjkrN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:49:07 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0408949F11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:05 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 c12-20020a170902848c00b0015025f53e9cso3933201plo.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xLUCA41gdz7FCF8bUZA9Zti+AcGuAvR0DZ5YiMSov0E=;
 b=Vc1EayLhrOzYdEvO5XuG7Sgh7TZEmWxNUoLCYTfidCSdg7vSpbf5BcKDmMUiZl0R4L
 CcNTXxUh+KYp/iwYE1FVJOkNwuRBUIRgJJ06rfIze0sumJqVgeVADx0lWC6ZegwQwGV7
 rZd7qnPTxFexvkYJpVgyrh7VoKI38Vw+/6Bm4wxZxwbL3oSfWGHOr/oXFkcox9o4aOZR
 qoWOPG2Lg6D7YwkNu6abWchaG/BHS0j5K51sVIMGZUvWrCud0I3x3dG9lgbSG7VoE/Pf
 sFKHEuec5XVRta/06pVQrd8by8u3oAeYEkNBzh0/2/duFKN4qLtp8pYOEcYBHEztNXJm
 FwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xLUCA41gdz7FCF8bUZA9Zti+AcGuAvR0DZ5YiMSov0E=;
 b=413qDgeq0lFoJA33rGDAM9IoTn7oc1jmEFHDkA1pucCIBUpemtnm9mXqMCeB8Mlr8v
 /H96H0M32oKFctfFFxnrx6sDrWHKgzeFafheBLMf5oJU+gMitbUaFliNqebzN30lqlBK
 QfGP7rbN6ZMM52AbzRyc47CcMYSqkCvyKKFM1a9PIZoE2STzXtjwS3zDpFbWBIQN1mig
 QfgMVOCMdImWa5up1PRZUq+wm3gpm40VwZzMy7qVLqiVl1KZnpi3Bgzj9M5hpSL4c1Ic
 wOYpoizTsCxvBIkR0nAErHVYYfY2rqrlRBScVb/g5wgu/MIGD/dxGdrMVeZ5xY+88v8/
 sc/A==
X-Gm-Message-State: AOAM532eYe7qOWDT2iECGqlJ7d9dZobXSPBZyzFpCCYPJo+9IgP/1eTd
 7yi/TBzLP1cogEXrXm0tmxKqiDB2IG4=
X-Google-Smtp-Source: ABdhPJwyRNt8QZSL25MhBfqeOrj7itaUKc+bzv73Qi9m6d1fIbeodfC9ndqspbZ/YEChD2vpQA5YzFqEYxw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b92:b0:4f6:dfe0:9abb with SMTP id
 g18-20020a056a000b9200b004f6dfe09abbmr8235033pfj.68.1646974144149; Thu, 10
 Mar 2022 20:49:04 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:06 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-21-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 20/25] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3f3f2800ff8b..924ffedf4b05 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -345,6 +345,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
 }
 
+static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -362,6 +367,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.trap_activate = feature_amu_trap_activate,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_mte_trap_activate,
+};
+
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3682,6 +3696,10 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.init = init_id_aa64pfr1_el1_desc,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64isar0_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
