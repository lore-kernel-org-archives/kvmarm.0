Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD113C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843EB410BB;
	Tue, 19 Apr 2022 02:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4trDAVjQzC75; Tue, 19 Apr 2022 02:57:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D76DA4B20F;
	Tue, 19 Apr 2022 02:57:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFAC49F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OEYgAaSmUPFf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:24 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 927604B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:22 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 oj16-20020a17090b4d9000b001c7552b7546so1166410pjb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4TCi+sJLW2uaem/+k27V6Nf+rQ0PhWYVioo5Q6rkdZk=;
 b=Hp9HgO/5PopUEK+kzy6sJa4PypL+kqEMbC0oXyjEuGS+tzp+ZuEBJ5KSrhSO+ILmk6
 y3AOpc1wZCpj2wIc6+I+hBwQ3UH842aJJThkW8WOBRZKQFE/jmRiW7GBjnOgjPi0I/Ja
 AlRFrV3q/j3YxsH9BMEAwDaIr+amb8gc2m4D1tyjC5WJMoZXm451ThezOj25kGVusGj8
 Ae2esA2cfwtvUAbyGmHBoQZ+mflUw46F4D9BrYFkYw9TPctz5VQJDQXghVxFQhXKEmcT
 vYiIHlopdqiMQCAx/nKa/mhAkBI+zDzW7XuUWrAOvDuoE3jerlVF3x+P9zxP8OTvDRxi
 cLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4TCi+sJLW2uaem/+k27V6Nf+rQ0PhWYVioo5Q6rkdZk=;
 b=v5BAx4qRYkz3KWW3MUicSsFQp1taYyFITxph7YINqZAiIzp3Qt9T/zVq1iBvyIwhaL
 7BsPCbQaDP5TaWcSae5A1cZMgYIBswzv9MXAz4/nyvSdTtPsXcxcPNwGq7qKfsrbqCdx
 NEnCK9QxXC14FYiO7HKrz/CCs3y9qggrOQXbboTBV4zJ+gND7RPCfbdI2LQqdqZfB6vB
 nDORW3WTeGVceteDcSma7DI7Jh4u/sUl/VI6mBtBQOludAK6X81JnYUTHCJd1pRvh53s
 kBglEV59pwIZOcPE1zsy1J/6fbi7nwuL1oXoFe+oA0xC9hutgmrFI0tSNONRrhuHI+KG
 1ETQ==
X-Gm-Message-State: AOAM532kDvbhEJIYG0QvaEPTayX2twXkRPnqKPC+uwQJ8yf3wpMzhsCD
 qouOOlduDUTbD6fzlP2zOogin2eFgtY=
X-Google-Smtp-Source: ABdhPJzSEZPodaqcIqvMD82N8W0cud+ZqgBHTt/0eiSMy13p/um5GCarQPZcMAPbrjM8K4rm6xCKlIue0Vo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:2283:b0:158:e7f4:7056 with SMTP id
 b3-20020a170903228300b00158e7f47056mr14258890plh.24.1650351441718; Mon, 18
 Apr 2022 23:57:21 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:16 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 10/38] KVM: arm64: Make ID_AA64ISAR2_EL1 writable
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

This patch adds id_reg_desc for ID_AA64ISAR2_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 65 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd4dcc1e4982..ba2e6dac7774 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -289,6 +289,16 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+#define ISAR2_PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) | \
+				 ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3))
+
+#define aa64isar2_has_apa3(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_APA3_SHIFT) >= \
+	 ID_AA64ISAR2_APA3_ARCHITECTED)
+#define aa64isar2_has_gpa3(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
+	 ID_AA64ISAR2_GPA3_ARCHITECTED)
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -507,6 +517,31 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar2_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	bool has_gpa3, has_apa3, lim_has_gpa3, lim_has_apa3;
+	u64 lim = id_reg->vcpu_limit_val;
+
+	has_gpa3 = aa64isar2_has_gpa3(val);
+	has_apa3 = aa64isar2_has_apa3(val);
+	lim_has_gpa3 = aa64isar2_has_gpa3(lim);
+	lim_has_apa3 = aa64isar2_has_apa3(lim);
+
+	/*
+	 * Check if there is a conflict in the requested value for
+	 * ID_AA64ISAR2_EL1 with PTRAUTH configuration.
+	 * See comments in validate_id_aa64isar1_el1() for more detail.
+	 */
+	if (lim_has_gpa3 && (vcpu_has_ptrauth(vcpu) ^ has_gpa3))
+		return -EPERM;
+
+	if (lim_has_apa3 && (vcpu_has_ptrauth(vcpu) ^ has_apa3))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -550,6 +585,13 @@ static void init_id_aa64isar1_el1_desc(struct id_reg_desc *id_reg)
 		id_reg->vcpu_limit_val &= ~ISAR1_TRAUTH_MASK;
 }
 
+static void init_id_aa64isar2_el1_desc(struct id_reg_desc *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~ISAR2_PTRAUTH_MASK;
+}
+
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
 {
@@ -568,6 +610,13 @@ static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : ISAR1_TRAUTH_MASK;
 }
 
+static u64 vcpu_mask_id_aa64isar2_el1(const struct kvm_vcpu *vcpu,
+					  const struct id_reg_desc *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ? 0 : ISAR2_PTRAUTH_MASK;
+}
+
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1544,11 +1593,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64ISAR2_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
@@ -3359,6 +3403,16 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64isar2_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR2_EL1),
+	.init = init_id_aa64isar2_el1_desc,
+	.validate = validate_id_aa64isar2_el1,
+	.vcpu_mask = vcpu_mask_id_aa64isar2_el1,
+	.ftr_bits = {
+		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR2_APA3_SHIFT, 0),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3371,6 +3425,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
+	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
