Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58808C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:52:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA5EA61BF5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:52:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA5EA61BF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 569F34B0EC;
	Wed, 17 Nov 2021 01:52:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dxylChtsqMCc; Wed, 17 Nov 2021 01:52:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD0F4B0BD;
	Wed, 17 Nov 2021 01:52:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54AD94A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:52:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AbWVTVK1elfK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:52:40 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13DA349F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:52:40 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 e12-20020aa7980c000000b0049fa3fc29d0so1116846pfl.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+QM3vxnIY5ebG82kJmilfb/kEzJ5uds/3O+I1dlEIvk=;
 b=EZYIu6hRvSKsmk4QDlfw/1oaSm7K9pAmp16YJZndakKVaHT40P+1YH2Wv5+ZEWzivU
 odVdvfxwvHkVN+HLLWpxNd0JzQLFifHDo3lBDzaDkHv43dflu4A1cM0Z519KV5TLebja
 TnI8bUB1lY8FzCQ8HQnlZCSLZiz4X4ADVMAOe3Gh63zazWMB6iDzKS9XZ9vTRR2cM1TP
 /6gxGnlIlBAzu4aWWzTdq3sQVNdw8XctrPDaonPM2BGrQB9oQRXJBKNTrWph9ChuLV6S
 RUphRiV46Nwnp+2QL38ooleyWaT89WpMaMQunAP/6V6DNBix32380PwpUVuhDfG7+oYG
 MNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+QM3vxnIY5ebG82kJmilfb/kEzJ5uds/3O+I1dlEIvk=;
 b=Ixebp1ArcaCjeMmxYWoJ3iOnJYDD2yEsEsEe7ypdkHsZJF+0VL/GydTmh471irCl1F
 uGwViVrttrhF6YOuLQbF6xVsWLFwVrGSEDzU8bY3ZPV+xEsopM7DDMJSQFreBDnGX1Wd
 Uk4Prku66zpm08amZJhGtbP5SLLFR1KdIGRgRBsZIUlS6XLQgrUusNgSxZOukZq00sXU
 Z3PSFR3QiQo66PSmI6as+e45plNKOKiXR/wfUaDJmGe3hs7BmO1jJpjUXTE4FT4daOHN
 o5JZUkaXPQGX6/YBoLNmDZ2sOcHzPxWxxyj9D6hkUh0Z1TmckS6dAILZoPz2uHBvsoy1
 q0kg==
X-Gm-Message-State: AOAM532KDFRuj1WHXq8mOkohpNqGO6N4r64NSQRKpHaVCTYQNBuCjYRy
 1FGXuXklBF8Yx8PqqkIZgfta33xp+hM=
X-Google-Smtp-Source: ABdhPJxotgq01k/w6uRxD8N6KAp8kDUMHpCn7kEiA8krb4HdDzKMIROjffEwMWJnsJlwqjvRMerWHPCmEb0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:7b8e:0:b0:49f:a0ba:67ff with SMTP id
 w136-20020a627b8e000000b0049fa0ba67ffmr5007355pfc.64.1637131959115; Tue, 16
 Nov 2021 22:52:39 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:37 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-8-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 07/29] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR1_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 79 +++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fdd707462fa8..5812e39602fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -358,6 +358,24 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
 	return 0;
 }
 
+#define PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
+
+#define aa64isar1_has_apa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT) >= \
+	 ID_AA64ISAR1_APA_ARCHITECTED)
+#define aa64isar1_has_api(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT) >= \
+	 ID_AA64ISAR1_API_IMP_DEF)
+#define aa64isar1_has_gpa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT) >= \
+	 ID_AA64ISAR1_GPA_ARCHITECTED)
+#define aa64isar1_has_gpi(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
+	 ID_AA64ISAR1_GPI_IMP_DEF)
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 
@@ -471,6 +489,36 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	bool has_gpi, has_gpa, has_api, has_apa;
+	bool generic, address;
+
+	has_gpi = aa64isar1_has_gpi(val);
+	has_gpa = aa64isar1_has_gpa(val);
+	has_api = aa64isar1_has_api(val);
+	has_apa = aa64isar1_has_apa(val);
+	if ((has_gpi && has_gpa) || (has_api && has_apa))
+		return -EINVAL;
+
+	generic = has_gpi || has_gpa;
+	address = has_api || has_apa;
+	/*
+	 * Since the current KVM guest implementation works by enabling
+	 * both address/generic pointer authentication features,
+	 * return an error if they conflict.
+	 */
+	if (generic ^ address)
+		return -EPERM;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_ptrauth(vcpu) ^ (generic && address))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -508,6 +556,12 @@ static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
 		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 }
 
+static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -530,6 +584,13 @@ static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
 }
 
+static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				      const struct id_reg_info *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ?
+	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -554,6 +615,16 @@ static struct id_reg_info id_aa64isar0_el1_info = {
 	.validate = validate_id_aa64isar0_el1,
 };
 
+static struct id_reg_info id_aa64isar1_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR1_EL1,
+	.ftr_check_types =
+		U_FCT(ID_AA64ISAR1_API_SHIFT, FCT_EXACT_OR_ZERO_SAFE) |
+		U_FCT(ID_AA64ISAR1_APA_SHIFT, FCT_EXACT_OR_ZERO_SAFE),
+	.init = init_id_aa64isar1_el1_info,
+	.validate = validate_id_aa64isar1_el1,
+	.get_reset_val = get_reset_id_aa64isar1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -566,6 +637,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1414,13 +1486,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
