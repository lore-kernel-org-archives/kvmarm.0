Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97424C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:00:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E6049E3C;
	Mon, 14 Feb 2022 02:00:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yo2lKZPFH4zN; Mon, 14 Feb 2022 02:00:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1F049DFF;
	Mon, 14 Feb 2022 02:00:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00E640B75
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UgnGWW4EfnfD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:00:21 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A9B840AEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:21 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 e20-20020a17090ab39400b001b96a809640so5608843pjr.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3YXTeyXBEmNCdPDjiReBLqzjLxovi4NAJDqchxZh9cs=;
 b=hqjIH2MDABDU/OeLEKZWo+DdKFtbNKPzc8DzAsmSoewDb0TQvvmNYfZoqr4LRPXuCu
 3/MsTvJul6Ij9zh2P/rEwbxSoWxJwP9B3mBPhm7La4N4RoGaWILY7KjdW5Ujj+uLPPvm
 M8Rne1sT9cGZvK0KeTNOmjBlWuqyGQ7lIqjcUAy21IrRnsS/u00py3MfG7ueSilWBRKe
 SG+Y7xvtyl4UaohTa/VoGlSW5XHwO4NES1aGnE+cCOEbkyF3DSgDWWRVfIcu/KgBuFdE
 5GTsbRB0iQ3R9rrjRdgHrJVZ7GoLfXXoxQVXuhy5kcR6limdJhuizj5foMhZAqnFY7pX
 7jPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3YXTeyXBEmNCdPDjiReBLqzjLxovi4NAJDqchxZh9cs=;
 b=GDlJOWCSTDHykFVsLrKAUkVHN30LHO1H3zoxRInqF7K5Ax3VwFl4mLdavefl1UJw57
 lEcJPFFRsAxefXQlidfn2sQcCgRm9POEFpHGOJOCDRvT0fLVepMbUzXFFwS5mBokr4Bl
 UhghnI/RvFX32DG6Q5ND7SQXTw/0lo48tsLcLydxWi4REfpOnjVwJehVHFRwdDYqbmGF
 NHezey+98KFqUIwgIa54qWq0gzgjQCqAs0a9pn6PDXwWHCzdDmUVzXOcUmiAIfap3N4m
 FZttn18g7AOxIELX4nZwWScuKUNnj4y5HoRnxiad+iVe/GY5Jn0V4MJFBfxm+Jr2Owxd
 ieig==
X-Gm-Message-State: AOAM531YX7P4j9hrO04h7zFH7VDtVjFOkN0h+4EG2CGz/PYZ7FUFMn5f
 XRMRNcEZvFqmv4qfzRoQPA4f0Az4Agc=
X-Google-Smtp-Source: ABdhPJyq9BwnHRiqYEmw3Jv6ypDLwMjFgJah6jMEDc6CbrOMpkBYC8Pq1R+X3qit7EcVAKLFGgrEBsgt/Rk=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:368f:: with SMTP id
 d137mr10488057pga.475.1644822020701; 
 Sun, 13 Feb 2022 23:00:20 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:31 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-13-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 12/27] KVM: arm64: Make ID_DFR0_EL1 writable
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

This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PerfMon field of the
register to a value that conflicts with the PMU configuration.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 55 ++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ae379755fa26..90e6a85d4e31 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -633,6 +633,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				const struct id_reg_info *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -693,8 +714,17 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val =
+		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
-					 const struct id_reg_info *idr)
+				     const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
@@ -717,6 +747,12 @@ static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
 	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
 }
 
+static u64 vcpu_mask_id_dfr0_el1(const struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -773,6 +809,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
 };
 
+static struct id_reg_info id_dfr0_el1_info = {
+	.sys_reg = SYS_ID_DFR0_EL1,
+	.init = init_id_dfr0_el1_info,
+	.validate = validate_id_dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -782,6 +825,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1712,15 +1756,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		/* Clear fields for opt-in features that are not configured. */
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
-	switch (id) {
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
-
 	return val;
 }
 
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
