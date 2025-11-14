Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49AB31B83B
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136507; cv=none; b=M8FGKgQt9gnrFvtED9bNi4A2PCgaF2ynPbD4A0vq5qXqBSM7x5uUw4OwCLL4ggKgPFvyTb02gZwybBEyCv2RWmNa3DHE5FJwJr/djschSCCS+8y8Ci/w4OHaJd9ELuPJx6E2db+Q83JxNZ+k1JhhZFDXa7WOmIZf1GW+pqTG7oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136507; c=relaxed/simple;
	bh=jCCElOt89KnuXUTWZQbL1wtmxX9VntAe0ABBgeFjIbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8rR+L1qesOGwkwepNwECtNt3o5X784ZjCsa9fuYI7vqT8VYgrtfolSheYzCszFYlwhZqO+NY8WwzHRwxVtTOOomTxrDCZqWft8LoM5C3GvUZnMph21t7248iel0wRGsMV4t43y+e3RT6EjqpNAJ0glZgEgEEIhLHvgQqOaVqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59D9A1BB2;
	Fri, 14 Nov 2025 08:08:17 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D01663F5A1;
	Fri, 14 Nov 2025 08:08:22 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 20/35] KVM: arm64: config: Use functions from spe.c to test FEAT_SPE_{FnE,FDS}
Date: Fri, 14 Nov 2025 16:07:01 +0000
Message-ID: <20251114160717.163230-21-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM's FGU mechanism will trap the registers introduced by FEAT_SPE_FnE and
FEAT_SPE_FDS if the feature is not present for the VM. Move the functions
that check for the presence of these features out of config.c and into
spe.c, since that's where the bulk of SPE virtualization lies.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h | 11 +++++++++++
 arch/arm64/kvm/config.c          | 16 +++-------------
 arch/arm64/kvm/spe.c             |  4 ++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 47b94794cc5f..6bc728723897 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -41,6 +41,9 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
 bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
 u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding);
+
+bool kvm_spe_has_feat_spe_fne(struct kvm *kvm);
+bool kvm_spe_has_feat_spe_fds(struct kvm *kvm);
 #else
 struct kvm_spe {
 };
@@ -82,6 +85,14 @@ static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encodi
 {
 	return 0;
 }
+static inline bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
+{
+	return false;
+}
+static inline bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
+{
+	return false;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index ed6b167b7aa8..51ad0bf936c0 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -285,16 +285,6 @@ static bool feat_sme_smps(struct kvm *kvm)
 		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
 }
 
-static bool feat_spe_fds(struct kvm *kvm)
-{
-	/*
-	 * Revists this if KVM ever supports SPE -- this really should
-	 * look at the guest's view of PMSIDR_EL1.
-	 */
-	return (kvm_has_feat(kvm, FEAT_SPEv1p4) &&
-		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FDS));
-}
-
 static bool feat_trbe_mpam(struct kvm *kvm)
 {
 	/*
@@ -548,7 +538,7 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
 		   HDFGRTR_EL2_PMBPTR_EL1	|
 		   HDFGRTR_EL2_PMBLIMITR_EL1,
 		   FEAT_SPE),
-	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, kvm_spe_has_feat_spe_fne),
 	NEEDS_FEAT(HDFGRTR_EL2_nBRBDATA		|
 		   HDFGRTR_EL2_nBRBCTL		|
 		   HDFGRTR_EL2_nBRBIDR,
@@ -852,7 +842,7 @@ static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
 		   HDFGRTR2_EL2_nPMSSDATA,
 		   FEAT_PMUv3_SS),
 	NEEDS_FEAT(HDFGRTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
-	NEEDS_FEAT(HDFGRTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
+	NEEDS_FEAT(HDFGRTR2_EL2_nPMSDSFR_EL1, kvm_spe_has_feat_spe_fds),
 	NEEDS_FEAT(HDFGRTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
 	NEEDS_FEAT(HDFGRTR2_EL2_nSPMACCESSR_EL1	|
 		   HDFGRTR2_EL2_nSPMCNTEN	|
@@ -885,7 +875,7 @@ static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
 		   feat_pmuv3p9),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMSSCR_EL1, FEAT_PMUv3_SS),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
-	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
+	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, kvm_spe_has_feat_spe_fds),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
 	NEEDS_FEAT(HDFGWTR2_EL2_nSPMACCESSR_EL1	|
 		   HDFGWTR2_EL2_nSPMCNTEN	|
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 92eb46276c71..fa24e47a1e73 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -92,7 +92,7 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 	return true;
 }
 
-static bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
+bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
 {
 	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
 
@@ -100,7 +100,7 @@ static bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
 	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
 }
 
-static bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
+bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
 {
 	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
 
-- 
2.51.2

