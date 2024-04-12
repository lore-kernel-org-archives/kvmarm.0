Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D5612C47E;
	Fri, 12 Apr 2024 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911488; cv=none; b=f6bxPKOcEf82cguQGtUcL6YoVuMOGoGc9ZnoLH73eTMpDAoBNsqxcvs0jcE9KV0/f7C8OvqDVguUdafqkalHoqcMoNxvDO04tdVaDTSB62XyXkiGKB+pEFoJhfomey2BQOxLPMK5P/OdOi8dzbX6WTsiQvMw/NJpnqc/VcT1wgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911488; c=relaxed/simple;
	bh=5QXYqk96uLmEOaxBZ0QXColWBs0Ax/8cnj2/H+KSoks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=byT/LVgpbL5LNzO07fwtYQ//Hk7ibHQuzcVYOQnTeiY7hCPk7BmeOGmaaM4ehc5JxjUdGhmowuqXe+UFceDA4UQJqPdLoUuDi19scwAU682ADSPK8x9xgk39KIhmpiBAfuzYoATcBg4E8mfuoYY7rJGdzk7cIhL9//fXp1MmLdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26C25113E;
	Fri, 12 Apr 2024 01:45:15 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A29183F6C4;
	Fri, 12 Apr 2024 01:44:43 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 37/43] arm64: RME: Initialize PMCR.N with number counter supported by RMM
Date: Fri, 12 Apr 2024 09:43:03 +0100
Message-Id: <20240412084309.1733783-38-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Provide an accurate number of available PMU counters to userspace when
setting up a Realm.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h | 1 +
 arch/arm64/kvm/pmu-emul.c        | 3 +++
 arch/arm64/kvm/rme.c             | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 44aa95befc14..9c00bcb018f8 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -88,6 +88,7 @@ struct realm_rec {
 
 int kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
+u8 kvm_realm_max_pmu_counters(void);
 u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val);
 
 bool kvm_rme_supports_sve(void);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ce7c8e55d904..39790736f1e2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -912,6 +912,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (kvm_is_realm(kvm))
+		return kvm_realm_max_pmu_counters();
+
 	/*
 	 * The arm_pmu->num_events considers the cycle counter as well.
 	 * Ignore that and return only the general-purpose counters.
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 51ac8c3462ea..1bd97e206846 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -271,6 +271,11 @@ u32 kvm_realm_ipa_limit(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+u8 kvm_realm_max_pmu_counters(void)
+{
+	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS);
+}
+
 u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 {
 	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
-- 
2.34.1

