Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25C3C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1C54B1A3;
	Tue, 19 Apr 2022 02:57:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LKYw7fwaT3Jx; Tue, 19 Apr 2022 02:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4454B24B;
	Tue, 19 Apr 2022 02:57:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FCB249EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HnIVgbhwLHcl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:56 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C7DE4B1E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:52 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 f16-20020a17090a121000b001cbc1895abeso1039998pja.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=11aokqGJX88zjYco/n0ZubDfebB61Zyyzannu13jVUU=;
 b=KGkjLi1nc3eXEFUtTXU9CrYnMm5oE1zb1JyJJ5B7usLojN2sR4jMVUo4tdKam79pra
 OVVDdODyp0s3nG2ZJo8xAbdCAAdfINz0DvmkTYgcDoJPyjrFRzEMbWEhr3S17VgMcZzD
 nM3JFqyi9usgPOH9nh6yHH3K9EhDv+VHrkC9rBBlvfOu2MszL4Hs+DDC22Em2O6ZKNxl
 5AeVCwzg50biwYCMn8UmZJ1+S+oPSbmtdfJ4IcoWZFIIysV0uXT2l+BZurMipMNhaudj
 6H2envE5Qpe3dAMXTa3BuELSOXXVwTJH4rpI5ANhGr44gOvC13Npdua3r4pKU8cmUmQJ
 8T2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=11aokqGJX88zjYco/n0ZubDfebB61Zyyzannu13jVUU=;
 b=6elL4XGtLo5Vz3QjtDJDcb+AMVW3vtwatIOrll03fRNoQHysXY1o7kqHi0FsDY3ID/
 two2j7HtYLWxxAEJktrip+KsIZJ3gXwpg2Ml/oJq8Um3Qq7m4P0KtdDnQwATM3/9cE6P
 gy78Su4XDPFoO4tEsMJzRoGsP6oVseP/oXXkLosrYSMGM/mqMLb7PV4BRa/A0l6TwhgA
 VYElTSnkNC+Iyzm/c8J6VRsmJhqAg/FKpejD9LZJrPDI7zVTIqvgKC8pdUrQTzEcRw5W
 4ftYUh6SBg2p/IojzqCzX1d5+BPwqdin99PkT/UMrRLPl9IYIjDlcI9BiboFc11DNZnM
 N7Qw==
X-Gm-Message-State: AOAM530Kc5X/osF7raJuzzZCwF/uyx8iCMQKYDQPfc7ioDmtlsJ5jXZx
 PYhG7RTPC5HEW6g+lbf8NQ7/R9q1qp8=
X-Google-Smtp-Source: ABdhPJxTNMo4W/KfFAQ3BdCNc/v2d2neST1XZcUkDoxRPAerssfdLoDu8lxxEk0L7o4yB7dQku5s92k37v0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:c792:b0:158:ba0c:cf6d with SMTP id
 w18-20020a170902c79200b00158ba0ccf6dmr14555949pla.131.1650351471625; Mon, 18
 Apr 2022 23:57:51 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:34 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-29-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 28/38] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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
index fecd54a58d34..10f366957ce9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -360,6 +360,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -377,6 +382,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -4312,6 +4326,10 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
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
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
