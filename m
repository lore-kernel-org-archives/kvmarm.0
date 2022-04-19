Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65CCC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDDD4B1FC;
	Tue, 19 Apr 2022 02:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lfn-kozpIJOJ; Tue, 19 Apr 2022 02:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A274B20B;
	Tue, 19 Apr 2022 02:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1A74B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id COPsHoQ+yJQz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:19 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EDA549F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:18 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 gj9-20020a17090b108900b001d2bde77de1so1042233pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=a16GM35sjxxlQKcTXUheYgNf0O4Bz0BcVFGp05uoS+A=;
 b=hmBUOWaE1NnSP7Cp16j43pFlkvvZ9H4KmuU1Ra0gR7gHPnKNVuuN/naQee0HGOq3wQ
 fhToaMAKA8werNfqWNDm4scTHg+CXLxsNd0bPmtIZ98ylO0egYYaGed8n9RV3b6YVnU8
 TA1nq43ZdqjtTkTT14ylfDZnTljfxNpKCsQr0Jyp5JLqiRNk7vu05YSVXfl8heWvEEcD
 kyG8xu2676waxirA3V03XO3j1Y8yrruZKhgqfd9LDVUI0Jg2Py76OhPlrZymt9GC87n0
 0yLCnkD4UUjAaRUW2fH/FO9u9C3Qozv9NXoUc/5gwc8WpGf//tZLbjmUWuDttbWDIge0
 75/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=a16GM35sjxxlQKcTXUheYgNf0O4Bz0BcVFGp05uoS+A=;
 b=BJ39UjhG4kUh+Be0y3f/KM5VyOG2qhqdsJBcWrpENOVCUa2nTqeuCdYfCF3wUhHhBb
 xESB/mJMjyWl+tgcYphRyvj99PSNQ1/0K0HIyJWkq+V9DsDYcKSO8QlU3a53xLD72fu7
 DOy0SHJ9QZKGXPvXLsLEzUgyLFZFIfdpx9Zjah4R4w/GQs0+u1I3nT1ifbw8yHtxeEZo
 It/e6QwDSiM3Dc4IDi1Gd1lMR+RKqS7pz7/6797OtuADWKzFyybk0wML8xswkqU6/Lu5
 CMssqg3IY2SG+ET1mgX86UzmocoYNE/Ercl2EsRIiHqVB3bMP09ObjT0rnPTe202OOrE
 25ow==
X-Gm-Message-State: AOAM530OM6qOJLDpF9EHCcZ66syS12T9xKNYWpZwo5sf7z03P2Dy2/f7
 kNkSRN1/F1BAE3h6JMXXiGJMOXut7oo=
X-Google-Smtp-Source: ABdhPJwSDKGRLdk5m+uU0CnsYnVPDSIqAFVbJcSmiEhdttrrb/Xm7zdvkXFnaC/AVP85cyC6XCAbFW3dIa0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:808:b0:50a:870d:6c8c with SMTP id
 m8-20020a056a00080800b0050a870d6c8cmr5634521pfk.76.1650351437207; Mon, 18 Apr
 2022 23:57:17 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:13 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-8-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 07/38] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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

This patch adds id_reg_desc for ID_AA64PFR1_EL1 to make it writable
by userspace.

Return an error if userspace tries to set MTE field of the register
to a value that conflicts with KVM_CAP_ARM_MTE configuration for
the guest.
Skip fractional feature fields validation at present and they will
be handled by the following patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 42 +++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3adb402fab86..b33b7ce87fb2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -837,6 +837,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67a0604fe6f1..c3537cd4fe58 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -410,6 +410,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_desc *id_reg, u64 val)
+{
+	bool kvm_mte = kvm_has_mte(vcpu->kvm);
+	unsigned int mte;
+
+	mte = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR1_MTE_SHIFT);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT. */
+	if (kvm_mte ^ (mte > 0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -441,12 +456,24 @@ static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_desc(struct id_reg_desc *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
 
+static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_desc *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1423,10 +1450,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
@@ -3223,6 +3246,16 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	}
 };
 
+static struct id_reg_desc id_aa64pfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64PFR1_EL1),
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+	.init = init_id_aa64pfr1_el1_desc,
+	.validate = validate_id_aa64pfr1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3230,6 +3263,7 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
+	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
