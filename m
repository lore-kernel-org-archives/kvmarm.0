Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FDDC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:48:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D82649EE1;
	Thu, 10 Mar 2022 23:48:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aXBWCTVAsv7j; Thu, 10 Mar 2022 23:48:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4A9A49EBB;
	Thu, 10 Mar 2022 23:48:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E969649EAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KbAD9ivyxjAh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:50 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 286A349EFD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:47 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 64-20020a621743000000b004f778ce34eeso1972137pfx.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=U4vObHr07JOA9r35Oli1yvQZsMPbxDR2eZHL3vHOgIc=;
 b=nrWVcz4xkbY4HLXt4miecw5Dd7wLv/8Qw3R+jAAFN9fhmzj+Km0AqV2L7X/z/fTo4T
 fL7e+zIuPCBBSuik+Y7SuRFNxJX8kJONi/D+iLHDUdfxxWsmDVi52r5r/Vym9Py4ZnJb
 DUCrq+Sdrh98urXQ+qN9CRfIcyQkvloyBr6QCXiGRFJqN4UZQr4afAx+MJeWbodDBWE0
 9Otebs4TqewY0HE8AACw4s05zVtk6BylH/FuCffghUfJynHdzDYur70qlhqiFHCAnl1A
 JjqvLUoI5yAiAsPtMAdXC0XcXOqKyZqOzkDoHrUYhTOWkN+45sZZLPY4e7c5pXI+D3De
 VnTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U4vObHr07JOA9r35Oli1yvQZsMPbxDR2eZHL3vHOgIc=;
 b=jL6Zym58ByexMXRIb828pXBiX2P2oB2kdaMCaLZfSDeJVy40bv3pdV0JDJBKIC9N0B
 qhAttzC0gLJWPTuMr5KjBiCGzIpqwt481n2UbgbUlVbXkqj4aq4Pqp05WG5zgNGtswiW
 kAoSG6MpfdBBRVFFOtABkG8o7B0Eck/FBDZY0WhNASIFd6+asy02lvvZjtnsxheGFI25
 DAM1kfWNC4AdRDp1PVwmikvepm6WqLjD+5DiCzhPc8wd/9ITQnNu2AIP1E4TsMzClzjJ
 WnLuioe4ARuKVWGMcZ0q4fVIhKFBbHLe8bL9nwQUtRwt15cXbJz93bmOAnRq4yoXpvsZ
 qSkw==
X-Gm-Message-State: AOAM5307/KVlbGi9hvzaVex9QO/yOfgodgL2iWfVCHWDTQaY4Gmcsimp
 EanQ+aInRFUyy82awMpe6iUW6VqYhDg=
X-Google-Smtp-Source: ABdhPJz02TnbQPY0kPnlOASS0GWIbEagDC4DxiLpCYD0ZfEPttap+gCUxytayfCPG35mVswRACXJk9ILkN8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:8e82:b0:151:6f68:7088 with SMTP id
 bg2-20020a1709028e8200b001516f687088mr8972609plb.11.1646974126310; Thu, 10
 Mar 2022 20:48:46 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:55 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 09/25] KVM: arm64: Make ID_AA64DFR0_EL1/ID_DFR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64DFR0_EL1 and ID_DFR0_EL1
to make them writable by userspace.

Return an error if userspace tries to set PMUVER/PerfMon field
of ID_AA64DFR0_EL1/ID_DFR0_EL1 to a value that conflicts with the
PMU configuration.

When a value of ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON on the
host is 0xf, which means IMPLEMENTATION DEFINED PMU supported, KVM
erroneously expose the value for the guest as it is even though KVM
doesn't support it for the guest. In that case, since KVM should
expose 0x0 (PMU is not implemented), change the initial value of
ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON for the guest to 0x0.
If userspace requests KVM to set them to 0xf, which shouldn't be
allowed as KVM doesn't support IMPLEMENTATION DEFINED PMU for the
guest, ignore the request (set the fields to 0x0 instead) so that
a live migration from the older kernel works fine.

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error
if userspace tries to set CTX_CMPS field to such value.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   2 +-
 arch/arm64/kvm/sys_regs.c           | 143 +++++++++++++++++++++++-----
 2 files changed, 122 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a9edf1ca7dcb..375c9cd0123c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad23361d3a3b..46d95626f4d5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -572,6 +572,66 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool id_reg_has_pmu(u64 val, u64 shift, unsigned int min)
+{
+	unsigned int pmu = cpuid_feature_extract_unsigned_field(val, shift);
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
+static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int brps, ctx_cmps;
+	bool vcpu_pmu, dfr0_pmu;
+
+	brps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_BRPS_SHIFT);
+	ctx_cmps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	/*
+	 * Number of context-aware breakpoints can be no more than number of
+	 * supported breakpoints.
+	 */
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
+	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	dfr0_pmu = id_reg_has_pmu(val, ID_AA64DFR0_PMUVER_SHIFT, ID_AA64DFR0_PMUVER_8_0);
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				const struct id_reg_desc *id_reg, u64 val)
+{
+	bool vcpu_pmu, dfr0_pmu;
+	unsigned int perfmon;
+
+	perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
+	if (perfmon == 1 || perfmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
+
+	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -615,6 +675,32 @@ static void init_id_aa64isar1_el1_desc(struct id_reg_desc *id_reg)
 		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
 }
 
+static void init_id_aa64dfr0_el1_desc(struct id_reg_desc *id_reg)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	limit = cpuid_feature_cap_perfmon_field(limit, ID_AA64DFR0_PMUVER_SHIFT,
+						ID_AA64DFR0_PMUVER_8_4);
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
+static void init_id_dfr0_el1_desc(struct id_reg_desc *id_reg)
+{
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val =
+		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 				     const struct id_reg_desc *idr)
 {
@@ -633,6 +719,18 @@ static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : PTRAUTH_MASK;
 }
 
+static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_desc *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
+}
+
+static u64 vcpu_mask_id_dfr0_el1(const struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1562,28 +1660,9 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 	const struct id_reg_desc *id_reg = get_id_reg_desc(id);
 
 	if (id_reg)
-		return __read_id_reg(vcpu, id_reg);
-
-	val = read_kvm_id_reg(vcpu->kvm, id);
-	switch (id) {
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
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
+		val = __read_id_reg(vcpu, id_reg);
+	else
+		val = read_kvm_id_reg(vcpu->kvm, id);
 
 	return val;
 }
@@ -3381,15 +3460,35 @@ static struct id_reg_desc id_aa64mmfr0_el1_desc = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_desc id_aa64dfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64DFR0_EL1),
+	.init = init_id_aa64dfr0_el1_desc,
+	.validate = validate_id_aa64dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+};
+
+static struct id_reg_desc id_dfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_DFR0_EL1),
+	.init = init_id_dfr0_el1_desc,
+	.validate = validate_id_dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_dfr0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
 /* A table for ID registers's information. */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	/* CRm=1 */
+	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 
+	/* CRm=5 */
+	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
