Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CF820F080
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607555; cv=none; b=Wan8y6okOKmgx3aRvf5aw3OOHzxeatEv3pGInlHFPtK/AEx9C6zOsXM00UvJcblWkMV4o2+G2gksFIQHUyrEWg/FjlJrFnZUn02SLO3V+5dXxyudBzvRXV5y5Kr9eCHMLDm6C6fivWaf/avQkclKY3sm6la0Z68/th8J9ipWzIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607555; c=relaxed/simple;
	bh=gfVeTaYGvJgjF3+5dv8ThgPZCvgtXsyI4dPTBxdrunc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iIalBO7appP7QTYpKUZwTh85Z0FiWCnqjR/fj/iIp1oQe4O12TIk79KlqH+s5RHZ6/7+7FrZIVed8uspIql0T2m5ot0SL+TM5SgZIYRj/wTjIK7nEllxMEdWZC34t5bAi3ZELsIPncPpK2C697MOzK0P/jczXu6AV9PYVsYNl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=URmdA1um; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="URmdA1um"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738607552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fk4znlvn6GbakMwTeJliB+Oo4bK3C8L8Zl+LfXy3Y/M=;
	b=URmdA1um0bGgiad2xuSYS+M2AFDxdiAhjsORqGvAvOLpYPM96w6DIyJyZrbs9uCva4jhMG
	ZuyF7k8yj+JTEyYqMR9Q0//F1Nq/b73X0txi8cCNdii5yMQKpGc50VkAT6DK3Jj/tmpDnw
	59L15zZAd+LzcseSJ7p1t5+Iy1XS9oA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH v2 10/14] KVM: arm64: Move PMUVer filtering into KVM code
Date: Mon,  3 Feb 2025 10:31:07 -0800
Message-Id: <20250203183111.191519-11-oliver.upton@linux.dev>
In-Reply-To: <20250203183111.191519-1-oliver.upton@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The supported guest PMU version on a particular platform is ultimately a
KVM decision. Move PMUVer filtering into KVM code.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/cpufeature.h | 23 -----------------------
 arch/arm64/kvm/pmu-emul.c           | 15 +++++++++------
 2 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 0eff048848b8..c4326f1cb917 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -525,29 +525,6 @@ cpuid_feature_extract_unsigned_field(u64 features, int field)
 	return cpuid_feature_extract_unsigned_field_width(features, field, 4);
 }
 
-/*
- * Fields that identify the version of the Performance Monitors Extension do
- * not follow the standard ID scheme. See ARM DDI 0487E.a page D13-2825,
- * "Alternative ID scheme used for the Performance Monitors Extension version".
- */
-static inline u64 __attribute_const__
-cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
-{
-	u64 val = cpuid_feature_extract_unsigned_field(features, field);
-	u64 mask = GENMASK_ULL(field + 3, field);
-
-	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
-	if (val == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
-		val = 0;
-
-	if (val > cap) {
-		features &= ~mask;
-		features |= (cap << field) & mask;
-	}
-
-	return features;
-}
-
 static inline u64 arm64_ftr_mask(const struct arm64_ftr_bits *ftrp)
 {
 	return (u64)GENMASK(ftrp->shift + ftrp->width - 1, ftrp->shift);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3048e22c240b..57ef4f2814fc 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1238,13 +1238,16 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void)
 {
-	u64 tmp;
+	unsigned int pmuver;
 
-	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-	tmp = cpuid_feature_cap_perfmon_field(tmp,
-					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-					      ID_AA64DFR0_EL1_PMUVer_V3P5);
-	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
+	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
+			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
+
+	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
+	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return 0;
+
+	return min(pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
 }
 
 /**
-- 
2.39.5

