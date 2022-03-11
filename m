Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFE9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:48:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B51149E57;
	Thu, 10 Mar 2022 23:48:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id brf85RTPb+qJ; Thu, 10 Mar 2022 23:48:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26C9649EED;
	Thu, 10 Mar 2022 23:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0DC49EC1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nozCshFKRlyZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:41 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82CD349EAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:40 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 y27-20020aa7943b000000b004f6decccdb5so4550260pfo.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uBoyKzZk3Qtv9aZ00wbOXF/ba3q4Fu49o+9bq2Th1Ww=;
 b=WaOEzQ3J63TTZvIp5H/lnZK5BcWK/0Md7Gxah9ozJWTjDdZZC9UvfdGXYgP9LilqU+
 sGSsV8EwJD/Ug/h0cTRJGvN5EVdPxOfsDaM8dgkcFQgh7GUeQPrPuRXPfGZnswqjU9m1
 o1aNriRRHMPgy57Zbt1IjI9BeXj+A7Zks11gx9CDeya7BSM1y2OljGQgFMP+jYUajo4z
 jfHlLPscsINpYKG94NQSEfftScLI6kNjHMPt5RzTcza0jhZaoHOSstIAnzTEcGfIm5C8
 fxw014HKohpMkivmaWj3BFqjDArfo3Ei2h4NN+Bh31LZo7Wkkjgj2wZ0rKcuzVoHHhw8
 JO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uBoyKzZk3Qtv9aZ00wbOXF/ba3q4Fu49o+9bq2Th1Ww=;
 b=52QDDfJ7tdfNsQWnef0sycgCjsIaN3GQ9TPBLYT/P3BM0JLw//4VWniTu26cc8P52j
 wnmiEclNY59/dc9Xt5OP/xYSGGyPegnQnz/iXEAK60zV0Lj/PrH0NiMVu2b2OmOnG09F
 apxSViIv8y5Bw4rabxImno5fnAbC3p6+cGf25piwbr2y5gngD4yy2Fb+dZpeyQU+ARup
 YGjDw6XkH4UqHjy/SbTHY0sAJYnE7g2TiNW1ABKwXnoD8ghhWc10lljABbJeBxODjtme
 JTuLbqfGjS4tI1w428iT2wFlj//BZKjvdfGqVpZmwIcsGbjdwrv0qnFQlHudRUXkqapJ
 jzjw==
X-Gm-Message-State: AOAM533otFBKVBUc2TNNeQ/PsUxes22GvwtzP5oZ+PCExuBuqQ6SBAD9
 zsKu9GIctMd9/l5LrVKNqnp8h9UBhFo=
X-Google-Smtp-Source: ABdhPJyOxSYFndroMYYb/thCoU6B1JaiKrgug4u+QvotKZqS7wBgDmUI8tVODpRPXtY1pGqD5AxfCVCODJs=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:e811:b0:151:f486:a32f with SMTP id
 u17-20020a170902e81100b00151f486a32fmr8570545plg.141.1646974119624; Thu, 10
 Mar 2022 20:48:39 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:51 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 05/25] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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
index 84edc87f0005..249f1fdc1f59 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -816,6 +816,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e9fa90afb82..4294dbfd8fd4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -405,12 +420,24 @@ static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
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
@@ -1344,10 +1371,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
@@ -3134,6 +3157,16 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
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
 
@@ -3141,6 +3174,7 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
+	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
