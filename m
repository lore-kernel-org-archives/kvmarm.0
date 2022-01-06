Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF34C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84EFC49F2D;
	Wed,  5 Jan 2022 23:28:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z19pwZ1D4nZ7; Wed,  5 Jan 2022 23:28:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7326C49F17;
	Wed,  5 Jan 2022 23:28:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91E6F49F20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CiB4x2CRcWbO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:47 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9E0F49EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:46 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 z18-20020a170903019200b00149b6eb5d3eso563302plg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eB8Pj9AqonhEmOmSpbPScjp/kpYk2Zdc2dOwYJa8nWA=;
 b=ek0Cxe37hJ/H4d8AflHcrISQS2gHNESWNJYsTa/l93aTbvvip1kTsnu0VrbprEmRhS
 YLG0EVfD8vbbeTsTu5hvZBNifvGcXnob7Tttj4PolhXuYupxD07gcoT9RODrdR/zzQAt
 19CSjPcBaaXAQzmbkEXsGtfIaZCL1YsLGYvSue4re406F/R6HuDPxzgFwHMIKKi2JMMl
 OOYt+btQzeMrmJ0joqKwYsXaMQjTjLzb9VcZ72JA1+W3sY1MR3363wzPqwtq/1NnyDKF
 jSQ3gFw1C8ubud9gYeC8ZCFYdVGHWQ4WKskXx6Kfyvtiu03lTiOeBgpN5vxpenVswnQ/
 lmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eB8Pj9AqonhEmOmSpbPScjp/kpYk2Zdc2dOwYJa8nWA=;
 b=MHbVg8OafUIwewzQK9yTWw5Xparpo3R5Pu2R4MUWLboD7o50uyZdhrkS0KpDDRIQWI
 R1HMmEwkMo+KLNhufyVcVyYyRJYT1qjr4Yt5BfNyW+KNQo1hYkehLwf6n1vPl9D8WNM8
 FqGMGDlXNA9vq/C64d0z4SRsK5mfehBCuWMFLnW8MfzysZWutO3s+lLljAj9y8c24Fja
 3OaIEydRICVX6XgX4O02Anl6NxHAfL4i22fVH5tcjOa3wVLexWo44SXfzGHi3/xx9Kpc
 o6B3U0BCwJiONebzMeujX+djIpiEOucyMaYaIjXbDoaW2UiIwih4SY5UcO2ijVH6BTjM
 OdOg==
X-Gm-Message-State: AOAM532dZDvNRoojB0gIaxFqHOMKXPMQ0a/35vPCKxF9crdLWjaQ+yLC
 UJY2au0TrJW5V/EOAJwx0UJjbEMt5Gc=
X-Google-Smtp-Source: ABdhPJw4iomcyehkGQ5AasMku4mXYD7PAR6aSGe3q84JWB/BcwK9a+MZx3JA312YFapSO0StggoJm7ip+sc=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:950b:: with SMTP id
 p11mr5443432pgd.475.1641443325897; 
 Wed, 05 Jan 2022 20:28:45 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:52 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 10/26] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 83 +++++++++++++++++++++++++++++++++------
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 723910267966..9a9055d60223 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -557,6 +557,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
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
+				    const struct id_reg_info *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -600,8 +639,25 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
 		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
 }
 
+static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
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
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
-				     const struct id_reg_info *idr)
+					 const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
@@ -618,6 +674,12 @@ static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : PTRAUTH_MASK;
 }
 
+static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -662,6 +724,13 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_info id_aa64dfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64DFR0_EL1,
+	.init = init_id_aa64dfr0_el1_info,
+	.validate = validate_id_aa64dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -673,6 +742,7 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
@@ -1593,17 +1663,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
