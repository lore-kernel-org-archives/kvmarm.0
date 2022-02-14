Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605BFC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1713549DED;
	Mon, 14 Feb 2022 02:01:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sO4Qgq4Gq6g4; Mon, 14 Feb 2022 02:01:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE4849ED2;
	Mon, 14 Feb 2022 02:01:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED0D49ECA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q6wKmYwz4c30 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:27 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E2F149E1B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:27 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 g21-20020a056a0023d500b004cc3a6556c5so11096261pfc.22
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1nsgNzH+YpfR3/KlbrupFdkkNs/4tvboqaVeY8OSkcA=;
 b=Uzrf4k8tdsN8iZk1o4Z1sprsLA1ZDIULzNZcfKvd8PPrrmESS5rysT77OyuSEML4DF
 U+5KaNW1vZk4LEbccSoj8bsf7DakaW2MOusPTwkA6AnYJdltLtH9e+Ur/jj6FnKaSXKh
 w8Ygcb7Ge32vFXcMJxmtWjb0wlLab22kQyymXpYmZOE/GBiqqvZeBwz9HPTFVkQSXKZ9
 2BpaE2lLws1UG9FMApBj1HgD73tjL9mrvvH8rtVIVeW4+InQUIx9yB+ESPmrBJgfSkor
 v698uTnpwEjjkaP3DqhEzGLB6oSx2h5oSNbJTFcf2ZsjxZ8MuLPpPlszv4nC4g9HCC5A
 iByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1nsgNzH+YpfR3/KlbrupFdkkNs/4tvboqaVeY8OSkcA=;
 b=j/vN6prTxJOwE+Zp9W+kpdhTWJNkEIgcthpnSrVRK7PohuKbD/BItPk36tBB1w+TZu
 NRw0HJ8Zt1vVuI/uaOrYd7NKfiZbCjB9M+60C2Iw4L3ryscwDqspBB/3/H3FEWCuv2gU
 MYbeC7kT3taGlfEqE8OG3IEXKFEsxNyMmRwCP9y2/PGnoRn9x+2BmhKCVQXHWTN/+R2b
 K8oOTDrNGg/kV1lBimddNRc7G7OtNjY/ZLAtU1K7uy4cadvaWeIFOv3cYoKLLi2C30/d
 HRFxi9OW+2n58b5bOl6n9iPo2vLAYknF7WDGbos1UMK4jE2gdTNKDmFTZ6i8/J0liiCS
 9K4w==
X-Gm-Message-State: AOAM53057ON3JYoYCSKYQLXIw1/0QNwrmoIpXaxWvL4YNd5nd6nS/PLu
 LyrtfhbTQYrU+GJdp9Zbj1N+prBz5Q8=
X-Google-Smtp-Source: ABdhPJwSnhJG8X92VE6HuDLs//NrS5KMmVjqlsnEZdsMnybSnY0KcHl4l/b6B2QmMc6sHthhI0qqWsxaD2k=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:224d:: with SMTP id
 hk13mr751201pjb.183.1644822086476; Sun, 13 Feb 2022 23:01:26 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:41 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 22/27] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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
index 72b7cfaef41e..a3d22f7f642b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -344,6 +344,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -361,6 +366,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -885,6 +899,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
