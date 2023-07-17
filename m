Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B841749C
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 15:27:28 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-66871648c25so4078269b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607648; x=1692199648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCQIj8rChbfCOl6GeXcnV+0FBKWws4kYFyMtOPVmVQ=;
        b=V2uLwfsnnPM44DdfSQuu1BkbVTyIjO+vUCUDSmyhWMMoTCHvDN9UlrJpA7P7bPfLxm
         t1BfUdLH5F3+dd/VgujBZvSpbytgIvASd0zwKVwixZSrLGg7JiA4ZgffOl3mHCqzlN+z
         RNf5Tq4MwCrSdkLG1NP55PRDCKJtZGkF6MYGpqiC9Wn5tMI4qRny3AVKOPKKjboSvGuB
         kOumAIzirxwPQNF4ulL02KMJlm7oEiKBWKr+1b+A3fk6L/Hk1paiapzRuohn0azeqPtG
         C8O+lqIKUe4D9ST/bOasewSFmLQalLrzH57c/XGUghh+PixoGr25ah87368yGdvMh5vY
         kdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607648; x=1692199648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCQIj8rChbfCOl6GeXcnV+0FBKWws4kYFyMtOPVmVQ=;
        b=XOhAekz3oaJmdOvPLmSSes1w9NiMmXYSLkiWGoQnrUy8W3O1LnWGNlqJuttiw4j1IJ
         foteVMEibf8xgNoTLQYv8QVm6t59rCc+Y5f1dkum7d4peeBu+euklYfwCJ1SZei5d/o8
         MyhKG0eUUdYWuRMT5L7OmC3ZIEtBLZ7mLpOjg6olNTV1WCSrKBQb0YeDWCQLzW1S++Z5
         BOepqUQN914wyH7xHvtN+kXCTjA/rFeyXKML7v7ScJO4qKlZAMRcOGcPty8VOgQQNJfv
         LjeiFJxqNyO7f7K8y7JUKbZ21vZmnrubjc0qCqm3+vA+rHoZMvmegLE3aN2kA9CJRipE
         r0Vg==
X-Gm-Message-State: ABy/qLYVFS0GfZR+LKrYNmIzhL1/tT+FkZUjZHORQjiSvcTfNaPcK9wq
	VwTUdcBFMpMQDIxtGXHp7nQ0P4HJZH33O+VcCg==
X-Google-Smtp-Source: APBJJlHt5JMRokoEdyLMXkVYl8bnTRXYt/VFatAnJx6tuzaITGsTM+Lynn51ngja4faQCfp0q8cLKIGAaMaUG6THSA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:3992:b0:668:9181:8e20 with
 SMTP id fi18-20020a056a00399200b0066891818e20mr135009pfb.1.1689607648372;
 Mon, 17 Jul 2023 08:27:28 -0700 (PDT)
Date: Mon, 17 Jul 2023 15:27:19 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-3-jingzhangos@google.com>
Subject: [PATCH v6 2/5] KVM: arm64: Reject attempts to set invalid debug arch version
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

The debug architecture is mandatory in ARMv8, so KVM should not allow
userspace to configure a vCPU with less than that. Of course, this isn't
handled elegantly by the generic ID register plumbing, as the respective
ID register fields have a nonzero starting value.

Add an explicit check for debug versions less than v8 of the
architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1a5ec1a016e..053d8057ff1e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1216,8 +1216,14 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	/* Some features have different safe value type in KVM than host features */
 	switch (id) {
 	case SYS_ID_AA64DFR0_EL1:
-		if (kvm_ftr.shift == ID_AA64DFR0_EL1_PMUVer_SHIFT)
+		switch (kvm_ftr.shift) {
+		case ID_AA64DFR0_EL1_PMUVer_SHIFT:
 			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		case ID_AA64DFR0_EL1_DebugVer_SHIFT:
+			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		}
 		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
@@ -1469,14 +1475,22 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
+({									       \
+	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
+	(val) &= ~reg##_##field##_MASK;					       \
+	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
+			min(__f_val, (u64)reg##_##field##_##limit));	       \
+	(val);								       \
+})
+
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
 	/* Limit debug to ARMv8.0 */
-	val &= ~ID_AA64DFR0_EL1_DebugVer_MASK;
-	val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1496,6 +1510,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
 	/*
@@ -1515,6 +1530,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
+	/*
+	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
+	 * nonzero minimum safe value.
+	 */
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
@@ -1528,6 +1550,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
@@ -1536,6 +1560,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1551,6 +1576,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

