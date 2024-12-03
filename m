Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091FD20ADE7
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733254404; cv=none; b=aWkKE49sVEGeZ48PIbGQGSA8BsjuRezkqbfvje7aPqOVoZeVNJt46GuCLf5o1XZ0sB3UT+ogg6RrZ4OiB3GWK9noLBUpaJSaHA6Q05dflfDxabwODorWB503pF/logvWzy615qdRERx0Xet7ZDkHNoB2prX8DFINgjcYea4eGFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733254404; c=relaxed/simple;
	bh=Vn8n2PWQvXFkvaGouEvec2v6QQPFUEMydzdqXsqXr80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V4lH9E9h64dEjxcVZfUlKsc+3Gi6QBIJk0V3OP/3NahEai/FLX0x90xyX1WjKDro0DcEN131jJkBe2WCZJSph2SpB5xePpHezqQ2WinCZ/2r2Fm5jlFiUsyu4BsohJlIE/AMMK97mgyPGKUchcIcfp5vWNUlw642FuqnHyri6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgsLhuFb; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgsLhuFb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733254401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCN2Ihx+VL+9+rceDgeVt8aarCk5BHzbeGK/3PSSsRM=;
	b=dgsLhuFbvfMVCX1vTnlmFzbSxlCog4psIpYA3Noff3FjkqZW4EuC6FV998Nu17iIeh6nqN
	w3zggeCCYCvtXtJhd5b3v5GdEvd8WYNEd1cfaacl3eHNMoulB/8fdG84YEpLZp+sIjfvnR
	y67QvsSu47T2HbRBBuCw8N8vSmhwUTA=
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
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH 10/14] KVM: arm64: Move PMUVer filtering into KVM code
Date: Tue,  3 Dec 2024 11:32:16 -0800
Message-Id: <20241203193220.1070811-11-oliver.upton@linux.dev>
In-Reply-To: <20241203193220.1070811-1-oliver.upton@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/cpufeature.h | 23 -----------------------
 arch/arm64/kvm/pmu-emul.c           | 15 +++++++++------
 2 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 3718840e9767..50ffb09132e9 100644
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
index b9756a0d054a..8a565817a814 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1255,13 +1255,16 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
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

