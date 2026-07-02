Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362273803E9
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783019088; cv=none; b=ilbDpTR8Zk8+F2CmN2jzVHdne3iqp65Bmnz9kQIaNHFRTY8uI/bY+pGA9HRW2oY1fwLWBtJUgmb+VE2mGR3aB7hwxMFgJafqbO/sDQtpH4Q1upF6bdKPSRnmFz07P0K6qObfZvO8+mX4a+CsdRZnOFYorNcgADp+eOkM/p/jC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783019088; c=relaxed/simple;
	bh=8tuJxCNBOWXuUagNrDc+bjsm5o3QNE9mkekLHhRL+ko=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=naur8rH3e9JKj12R5sKP6DHImzouZtExOj2xOR+cCdKuLclzCHFssGRIBeQz6Age+sgsX1dRT+FIkTrPdhCi0CZzf9KBno5BpMc49Z54now62DAL79lpMe1+qLimxfm/8blYq0bBRo2ZiEDsX91NuyIMKvQqkdM+eVsvGpgPy1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=pqGNjnPK; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="pqGNjnPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783019087; x=1814555087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=28PbrJsue24gxCxFzMj1TZNmDll7upM8xjPIwGE2HHc=;
  b=pqGNjnPKznFlsBd3A72LbumvG1E8KxcOuzW62eAGPcZN9LwAueetoqAB
   I1TgzB+DGxcacMLsMq7SusLfEHIUiqZIuEvLL1fjb12uKNORHU4j93K7m
   4NLaIjSZGbEM6JtB4bfnRcjOoMCRZsuwWk6sYuuXtrAeldA3G2XOjj+Qa
   BiX1TKpV8JunCxCDthm3EpAcRIkdUt3EoeWSCI6tdWmuKzsnKCTWCNPPx
   rjFHVLJLYXkD1dQ3r5iiVgZ3eDERY/gHWyzoxlHqv30TSoMSJG3IiWmfp
   FX5NqllJIU/2VAFmIikZdT4D/1no6w96OXOt1sObksQQtV10p/PCVTnHS
   Q==;
X-CSE-ConnectionGUID: Z1BcOmIYQYKK6k3LUBa7pQ==
X-CSE-MsgGUID: 3IFZy54RQYaqxgK0r4k1gA==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22933538"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 19:04:43 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:32053]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.112:2525] with esmtp (Farcaster)
 id 8a338137-edab-4456-8313-f0c7488aa835; Thu, 2 Jul 2026 19:04:42 +0000 (UTC)
X-Farcaster-Flow-ID: 8a338137-edab-4456-8313-f0c7488aa835
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 19:04:42 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 19:04:42 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Haris Okanovic <harisokn@amazon.com>, Geoff Blake
	<blakgeof@amazon.com>, Stanislav Spassov <stanspas@amazon.de>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAPI
Date: Thu, 2 Jul 2026 19:04:21 +0000
Message-ID: <20260702190421.420992-4-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260702190421.420992-1-congkai@amazon.com>
References: <20260702190421.420992-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Skip masking STALL_SLOT, STALL_SLOT_FRONTEND and STALL_SLOT_BACKEND out
of PMCEID1 when KVM_ARM_VCPU_PMU_V3_STRICT is set, because this is when
PMMIR_EL1.SLOTS is exposed to guests, making these events meaningful for
collection.

Change the parameter of compute_pmceid1() from arm_pmu to kvm_vcpu, to
check if KVM_ARM_VCPU_PMU_V3_STRICT is set. Also updated the signature of
compute_pmceid0() for consistency.

Signed-off-by: Congkai Tan <congkai@amazon.com>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Reviewed-by: Stanislav Spassov <stanspas@amazon.de>
---
 arch/arm64/kvm/pmu-emul.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9595bce6519f..89eec5a1a499 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -851,9 +851,9 @@ static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
 	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
 }
 
-static u64 compute_pmceid0(struct arm_pmu *pmu)
+static u64 compute_pmceid0(struct kvm_vcpu *vcpu)
 {
-	u64 val = __compute_pmceid(pmu, 0);
+	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 0);
 
 	/* always support SW_INCR */
 	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
@@ -862,32 +862,33 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
 	return val;
 }
 
-static u64 compute_pmceid1(struct arm_pmu *pmu)
+static u64 compute_pmceid1(struct kvm_vcpu *vcpu)
 {
-	u64 val = __compute_pmceid(pmu, 1);
+	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 1);
 
 	/*
-	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
-	 * as RAZ
+	 * If KVM_ARM_VCPU_PMU_V3_STRICT is not set, PMMIR_EL1 is
+	 * unconditionally RAZ, so don't advertise STALL_SLOT* events.
 	 */
-	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+	if (!kvm_vcpu_has_pmuv3_strict(vcpu))
+		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+
 	return val;
 }
 
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
-	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
 	if (!pmceid1) {
-		val = compute_pmceid0(cpu_pmu);
+		val = compute_pmceid0(vcpu);
 		base = 0;
 	} else {
-		val = compute_pmceid1(cpu_pmu);
+		val = compute_pmceid1(vcpu);
 		base = 32;
 	}
 
-- 
2.50.1

