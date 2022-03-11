Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E1DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:48:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3928549EE3;
	Thu, 10 Mar 2022 23:48:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2rI39dr3ni6T; Thu, 10 Mar 2022 23:48:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB87149EE1;
	Thu, 10 Mar 2022 23:48:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DD543479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f9xKDMEJA5hP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60A6A49EC1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:50 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 m9-20020a17090ade0900b001bedf2d1d4cso7193525pjv.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sBS0GPRrbiWgeVNZb+9UNH7PQVRywzH/+pUDODbMZ1g=;
 b=ENpayKBmfeMK+Uq+f7lTV/mKRuXOdPZr6mTDUvWd+uAPU+KZk0izLdEguLYuIuauLM
 N0WLJyDNbdzroBnPwDIbJSsVmV7p0FNDRujmdbz0kuz2j8Dk1Ch6rAe7jApHzRPecewZ
 /zkDyEZZMllmc3VuiLdVg1ge5BCnpZC7ODpi91HC2Msz23yqldvH9XYpnI9FqGVxDgEP
 jA/4LCoyfsavGVedZcFh6hWz/NUuYfyxNKy4kSxRbKmbIiT4FiLhwmH812Y2QdatN014
 JBPE8d0E4jZg3dAHRfEFOMda+Ip5JeEI4wmWALk7bTkpcQNd8bP6K8cNuXyhmXAyYuOw
 2BcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sBS0GPRrbiWgeVNZb+9UNH7PQVRywzH/+pUDODbMZ1g=;
 b=gS2PKuC2FCjq5pmDjVqY0W6G2buBImGwpYrk5+H80AZZhbIHMoqLPX3M1MxGawC8O3
 4vZgYK5t75EiYFshB2/i1FS5cTUTdyZvazIy5DqK0ZGWl5WQi/AUaUthfxOX1Y0YschY
 j6Ir6uQNyA/cK1qyLjj+vfJBi+3Zg+V24XEW9g9miacUUKoMb2HtkP9GVbf1JN3G9Ex6
 5T/ApvwAftyd4qfVD2BssotdGKwDhW24cOgli6zGk9WTx6BwzH6QYYROj90tFfxQiHLf
 iEFmRMdk6WWnK4Bga6AAVA+pSM6fdlRtdm98X6NyxbboXOS1qF8Td4jOPy15lVtHEhuW
 /4oA==
X-Gm-Message-State: AOAM533EF7+/X4uklXOi4Z2g++xxeRJZOgvplSTNZWig3Qm7nIbN72/G
 y6grUwbWX8+HqCuxTpPW8cPDDEFBDIU=
X-Google-Smtp-Source: ABdhPJwvo+MlpuYLsqLclXrIHZ70iMCXv6C4gJL27oO/w0gInxEG7NIHVVmbw30zKgrbMrTj7EgvpKtQd4E=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:350b:b0:1bf:c563:f0c7 with SMTP id
 ls11-20020a17090b350b00b001bfc563f0c7mr8762325pjb.157.1646974129584; Thu, 10
 Mar 2022 20:48:49 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:57 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
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

Add hidden or reserved ID registers, and remaining ID registers,
which don't require special handling, to id_reg_desc_table.
Add 'flags' field to id_reg_desc, which is used to indicates hiddden
or reserved registers. Since now id_reg_desc_init() is called even
for hidden/reserved registers, change it to not do anything for them.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 89 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 45d22b9e0d40..fe2a4de2b8f3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -284,6 +284,10 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/* id_reg_desc flags field values */
+#define ID_DESC_REG_UNALLOC	(1UL << 0)
+#define ID_DESC_REG_HIDDEN	(1UL << 1)
+
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
 
@@ -297,6 +301,9 @@ struct id_reg_desc {
 	/* Fields that are not validated by arm64_check_features_kvm. */
 	u64	ignore_mask;
 
+	/* Miscellaneous flags */
+	u64	flags;
+
 	/* An optional initialization function of the id_reg_desc */
 	void (*init)(struct id_reg_desc *id_reg);
 
@@ -333,8 +340,13 @@ struct id_reg_desc {
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
-	u64 val = read_sanitised_ftr_reg(id);
+	u64 val;
+
+	if (id_reg->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+		/* Nothing to do for a hidden/unalloc ID register */
+		return;
 
+	val = read_sanitised_ftr_reg(id);
 	id_reg->vcpu_limit_val = val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
@@ -3509,30 +3521,103 @@ static struct id_reg_desc mvfr1_el1_desc = {
 	.validate = validate_mvfr1_el1,
 };
 
+#define ID_DESC_DEFAULT(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_SANITISED(name),			\
+	}
+
+#define ID_DESC_HIDDEN(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_HIDDEN(name),			\
+		.flags = ID_DESC_REG_HIDDEN,			\
+	}
+
+#define ID_DESC_UNALLOC(crm, op2)				\
+	[crm << 3 | op2] = &(struct id_reg_desc) {		\
+		.reg_desc = ID_UNALLOCATED(crm, op2),		\
+		.flags = ID_DESC_REG_UNALLOC,			\
+	}
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
-/* A table for ID registers's information. */
+/*
+ * A table for ID registers's information.
+ * All entries in the table except ID_DESC_HIDDEN and ID_DESC_UNALLOC
+ * must have corresponding entries in arm64_ftr_regs[] in
+ * arch/arm64/kernel/cpufeature.c because read_sanitised_ftr_reg() is
+ * called for each of the ID registers.
+ */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
+	ID_DESC_DEFAULT(ID_PFR0_EL1),
+	ID_DESC_DEFAULT(ID_PFR1_EL1),
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC_HIDDEN(ID_AFR0_EL1),
+	ID_DESC_DEFAULT(ID_MMFR0_EL1),
+	ID_DESC_DEFAULT(ID_MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR2_EL1),
+	ID_DESC_DEFAULT(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	ID_DESC_DEFAULT(ID_ISAR0_EL1),
+	ID_DESC_DEFAULT(ID_ISAR1_EL1),
+	ID_DESC_DEFAULT(ID_ISAR2_EL1),
+	ID_DESC_DEFAULT(ID_ISAR3_EL1),
+	ID_DESC_DEFAULT(ID_ISAR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR5_EL1),
+	ID_DESC_DEFAULT(ID_MMFR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR6_EL1),
 
 	/* CRm=3 */
+	ID_DESC_DEFAULT(MVFR0_EL1),
 	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+	ID_DESC_DEFAULT(MVFR2_EL1),
+	ID_DESC_UNALLOC(3, 3),
+	ID_DESC_DEFAULT(ID_PFR2_EL1),
+	ID_DESC_HIDDEN(ID_DFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR5_EL1),
+	ID_DESC_UNALLOC(3, 7),
 
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+	ID_DESC_UNALLOC(4, 2),
+	ID_DESC_UNALLOC(4, 3),
+	ID_DESC_DEFAULT(ID_AA64ZFR0_EL1),
+	ID_DESC_UNALLOC(4, 5),
+	ID_DESC_UNALLOC(4, 6),
+	ID_DESC_UNALLOC(4, 7),
 
 	/* CRm=5 */
 	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64DFR1_EL1),
+	ID_DESC_UNALLOC(5, 2),
+	ID_DESC_UNALLOC(5, 3),
+	ID_DESC_HIDDEN(ID_AA64AFR0_EL1),
+	ID_DESC_HIDDEN(ID_AA64AFR1_EL1),
+	ID_DESC_UNALLOC(5, 6),
+	ID_DESC_UNALLOC(5, 7),
 
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64ISAR2_EL1),
+	ID_DESC_UNALLOC(6, 3),
+	ID_DESC_UNALLOC(6, 4),
+	ID_DESC_UNALLOC(6, 5),
+	ID_DESC_UNALLOC(6, 6),
+	ID_DESC_UNALLOC(6, 7),
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
+	ID_DESC_UNALLOC(7, 3),
+	ID_DESC_UNALLOC(7, 4),
+	ID_DESC_UNALLOC(7, 5),
+	ID_DESC_UNALLOC(7, 6),
+	ID_DESC_UNALLOC(7, 7),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
