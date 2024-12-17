Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978D51FAC29
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470477; cv=none; b=OZ58l2v4egAT2PTCCX6jO7gz7Gryct2WoEQe4vVS6ycZDpmtXqGuAR86u+HCHmUR/2XSt1hGR+t9/bfRL2XK7J97RDnx7aVTYDoPUpGUE4iJ2GBSp5qpmpoUZkuRRIdrxlkuaCoLql2vdrG40aUCuRtlPUMBXac4gCpxhS3TqQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470477; c=relaxed/simple;
	bh=H1i76oQ62PnNOz7LOn+mMYk6kiHYTKnh8qFew67NezM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BaCetmZ0GExt7syx+kWyMiTOu/C8j4WLbQ+Hgy7+C5azSUDFlh/6qdPQLklL6kVjFTeDrfmXpoyu/acbSyDlsknQCd/jEDegYPmFUuWL9PSg+/xcVPQylDh4W/JLM09zvBCiGqkM5/dEbUSX+vWkbsbKoJ/DcgIq+KoJ5PHXz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g8y3R8+1; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g8y3R8+1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t1F52j19RSTD/ExLTuDEtZGAnpbJL/8p4C5yMUPDC6w=;
	b=g8y3R8+1mLdj6B0rrZccFsB+xmnkWbkci/JOQqvtvSISIfYMAJm57YPMEWQ6wQg26SrtvH
	uFu0b6D0s4B8HdUqpw9OS5bvlR9KXr4Y5/bdsKTWstMN27yA9TvenzkT8dOpWQReDrnjm5
	7QTmXH4ZmGLW1O3SpxtmEAyKt8hE9DY=
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
Subject: [PATCH 05/18] KVM: arm64: Compute PMCEID from arm_pmu's event bitmaps
Date: Tue, 17 Dec 2024 13:20:35 -0800
Message-Id: <20241217212048.3709204-6-oliver.upton@linux.dev>
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The PMUv3 driver populates a couple of bitmaps with the values of
PMCEID{0,1}, from which the guest's PMCEID{0,1} can be derived. This
is particularly convenient when virtualizing PMUv3 on IMP DEF hardware,
as reading the nonexistent PMCEID registers leads to a rather unpleasant
UNDEF.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 47 ++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 456102bc0b55..809d65b912e8 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -861,8 +861,42 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	return pmu;
 }
 
+static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
+{
+	u32 hi[2], lo[2];
+
+	bitmap_to_arr32(lo, pmu->pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+	bitmap_to_arr32(hi, pmu->pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+
+	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
+}
+
+static u64 compute_pmceid0(struct arm_pmu *pmu)
+{
+	u64 val = __compute_pmceid(pmu, 0);
+
+	/* always support CHAIN */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
+	return val;
+}
+
+static u64 compute_pmceid1(struct arm_pmu *pmu)
+{
+	u64 val = __compute_pmceid(pmu, 1);
+
+	/*
+	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
+	 * as RAZ
+	 */
+	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+	return val;
+}
+
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
+	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
 	u64 val, mask = 0;
 	int base, i, nr_events;
@@ -871,19 +905,10 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		return 0;
 
 	if (!pmceid1) {
-		val = read_sysreg(pmceid0_el0);
-		/* always support CHAIN */
-		val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
+		val = compute_pmceid0(cpu_pmu);
 		base = 0;
 	} else {
-		val = read_sysreg(pmceid1_el0);
-		/*
-		 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
-		 * as RAZ
-		 */
-		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
-			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
-			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+		val = compute_pmceid1(cpu_pmu);
 		base = 32;
 	}
 
-- 
2.39.5

