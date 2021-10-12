Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C26FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0167561074
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0167561074
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9ACD4B0A0;
	Tue, 12 Oct 2021 00:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9hYv9uKmEP-l; Tue, 12 Oct 2021 00:36:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1964B0E2;
	Tue, 12 Oct 2021 00:36:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58BD44B0D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fFiMGJKisIkE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:35 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FAD24B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:35 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 a16-20020a63d410000000b00268ebc7f4faso8029868pgh.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KkXFZ5Fme7Kzy6UMAllI6J6cKTiNLiuGaTgPl7tFhoc=;
 b=gNWTCyHt0F+Tgvg9IjH1MQsh4TR7Z/ZVpwe1d0n6s1PxESO4F3WckfgA0IFJR+4tn1
 BrtW2efC0MMgaI4/C1g8YwITxHGdB4kUZ8wLio9087ilyqc9MkdkTM5VcR8GGZVdnnTi
 C4dix4cTMWXtL1S55G+HZOYWpktnCDcr0foHyFoJu3MczBgMQQVGsAhhUogHjuB6MlUM
 1GuIC4m5jLesSIHV4l7obvirl8Dh/035/DnD5RnDlOgtzH4urkuhgGTc1/+if+XBxq4g
 KjJDD0rV93rZv/LytfXCBIvF3/Ei+xCOLf7Mii0kfNbDKXYS8fASBPTK9gv1TluP05hb
 0nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KkXFZ5Fme7Kzy6UMAllI6J6cKTiNLiuGaTgPl7tFhoc=;
 b=Jy+mc24NhhFKE64+rwbW3TQS9RU6gFa+gFZS6V711RzbNqkdE0VVG0qAYHOqr06N6B
 1ETlB8kb1Wrpfgc84ronqBRGdV8Vv9rbQpKnAPhOl6QC9gCPzsZua7iwqfd3+XAvdUoa
 QYkmeuDAKDUCaRA7X5rksjRg0wxZvXyuFPYFTmhR4BsHZBZJvJjsjjTrcwp1ykp9o+Cp
 ndzCibckQBZJm6nH6il2eUXK6kmNx+W/ZmVmgfHMNyyqeX5FQyZKgdE01bC0Iho+PSI5
 hpyATTVT94RdmI8YPvvaDCSdp9uGQcrnHRqjCmp6zNeKrbZxloTO7ELTHG8TWb61F1Du
 H3rg==
X-Gm-Message-State: AOAM533U76OFmjvzcy3LHZzWngpNe4n5tGFFG9r6+S42L3HLqbEdnx1O
 XEegMuUrEew5NLrl5V0kzlKe5QxJFto=
X-Google-Smtp-Source: ABdhPJyzBf51TEcN/HoLmrN431l4sJxIHytNAgq2tIPPD+LnRTXbAwEq84O2Hau4z9V+wwNwWLecscNAgN0=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296118pjn.0.1634013393949; Mon, 11 Oct 2021 21:36:33 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:20 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-11-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 10/25] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PMUVER field of the
register to a value that conflicts with the PMU configuration.

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error
if userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 108 ++++++++++++++++++++++++++++++++++----
 1 file changed, 97 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7819a07ee248..61e61f4bb81c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -402,6 +402,46 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static bool id_reg_has_pmu(u64 val, u64 shift, u64 min)
+{
+	u64 pmu = ((val >> shift) & 0xf);
+
+	/*
+	 * Treat IMPLEMENTATION DEFINED functionality as unimplemented for
+	 * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon.
+	 */
+	if (pmu == 0xf)
+		pmu = 0;
+
+	return (pmu >= min);
+}
+
+static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int brps, ctx_cmps;
+	bool vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	bool dfr0_pmu = id_reg_has_pmu(val, ID_AA64DFR0_PMUVER_SHIFT,
+				       ID_AA64DFR0_PMUVER_8_0);
+
+	brps = cpuid_feature_extract_unsigned_field(val,
+						ID_AA64DFR0_BRPS_SHIFT);
+	ctx_cmps = cpuid_feature_extract_unsigned_field(val,
+						ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	/*
+	 * Number of context-aware breakpoints can be no more than number of
+	 * supported breakpoints.
+	 */
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -445,6 +485,47 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
 				 (id_reg->sys_val & ~PTRAUTH_MASK);
 }
 
+/*
+ * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon == 0xf indicates
+ * IMPLEMENTATION DEFINED form of performance monitors supported,
+ * PMUv3 not supported (NOTE: 0x0 indicates PMU is not supported).
+ * This function is to cap a value of those two fields with the
+ * given 'cap_val' treating 0xf in the fields as 0.
+ */
+static u64 id_reg_cap_pmu(u64 val, u64 shift, u64 cap_val)
+{
+	u64 mask = 0xf;
+	u64 pmu;
+
+	pmu = (val >> shift) & mask;
+	pmu = (pmu == 0xf) ? 0 : pmu;
+	pmu = min(pmu, cap_val);
+
+	val &= ~(0xfULL << shift);
+	val |= (pmu & 0xf) << shift;
+	return val;
+}
+
+static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit;
+
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	limit = id_reg->sys_val;
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	limit = id_reg_cap_pmu(limit, ID_AA64DFR0_PMUVER_SHIFT,
+			       ID_AA64DFR0_PMUVER_8_4);
+	/* Limit debug to ARMv8.0 */
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
+	limit |= (FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6));
+
+	/* Hide SPE from guests */
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
+
+	id_reg->vcpu_limit_val = limit;
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     struct id_reg_info *idr)
 {
@@ -468,6 +549,14 @@ static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
 }
 
+static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				     struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -497,6 +586,13 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.get_reset_val = get_reset_id_aa64isar1_el1,
 };
 
+static struct id_reg_info id_aa64dfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64DFR0_EL1,
+	.init = init_id_aa64dfr0_el1_info,
+	.validate = validate_id_aa64dfr0_el1,
+	.get_reset_val = get_reset_id_aa64dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -508,6 +604,7 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
@@ -1346,17 +1443,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_AA64DFR0_PMUVER_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
-		/* Hide SPE from guests */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
-		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
