Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED016C43217
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A364740B6C;
	Wed,  5 Jan 2022 23:28:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QKOcRONoLm8h; Wed,  5 Jan 2022 23:28:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9790E49F1B;
	Wed,  5 Jan 2022 23:28:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1E549F20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JFirn+baDsU5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:48 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AAEA49E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:48 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 o67-20020a62cd46000000b004ba4d2f70b5so922190pfg.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kduJ8W7D23BHwaQqjKYPNo6TWtKwdbe4Pc0zb3RITt8=;
 b=fKlXAux6G7PjhGP2oJRAOU0jZOCiN6+OnCweQVroA6ACLMYmdQ3VyAoWtutcib5ZKj
 30QA6RUJpRG8JzLhKgPmimoHkW4yLy+UKVHqwu90LnsGQus1oYaHJ7UhFlFcSPBSUuzX
 mUI+n7ioNGsSvMe7aR8nT5ag1xqNVpQ+B+/6e/wP4y9NuwHejlv5akE1DtvgVnntXB9R
 9rtnO0Q5HTSinZbv31ZjvBKELAXybcYQhRLY6V5jvJQG0dBOT7r1LjeB6VXxgBLyzPnf
 8sp/96HX8tzitwF+hgIgruNcOvCJwhT0AM2x9Pt4phAKqk3bgRnW1i6tImUBprVoRkA6
 4fEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kduJ8W7D23BHwaQqjKYPNo6TWtKwdbe4Pc0zb3RITt8=;
 b=i/5RKVTOVr/t5v5zwHIOfrFyHXKep17v9Lr/Y46e3sbu0EMSVUYrqcglvW958FupLJ
 GaNwwwR+ZSNGZurHIcx6bwAEq04gaFz3rzKrtcllcwemXymsK0lcm7am5kH9wRv6MpS2
 33EFOUY0o7hWjuhlRNsVekfOui3U3NDWXpKHRlFy1qzb0uOXyjp2kw87rXC+EqZU9W6Z
 o1rvzfj4DYp2MmCqw57N3mca/uhHS8KIaDsUP5QoUuwUbASuJ5jOpGXV6V7EXUKnh1VN
 6IbCKFrlAuMOLnM7wPOrhDekSQNiCQq0rgbPk6MdQDqYBqhTh/320mHEj25IpaIm6G9H
 zJQQ==
X-Gm-Message-State: AOAM532zbjUWBJqEfjpW2Gwb626xeHiUwW2pC4TkIf/BzofN5o8meNMz
 jCcFfhkQSEJyWPbzVs51FjkMNvD106o=
X-Google-Smtp-Source: ABdhPJzPTNL48G0HNzxfO0ns7AexR+6gb/acsiG8g9dhMwIoRkX3C10ON5Y8LUKx4GNdP776NLQAWlwRwGo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:6d23:: with SMTP id
 z32mr7912129pjj.144.1641443327365; Wed, 05 Jan 2022 20:28:47 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:53 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 11/26] KVM: arm64: Make ID_DFR0_EL1 writable
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
index 9a9055d60223..1707c7832593 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -596,6 +596,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -656,8 +677,17 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
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
@@ -680,6 +710,12 @@ static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
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
@@ -731,6 +767,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -740,6 +783,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1662,15 +1706,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
