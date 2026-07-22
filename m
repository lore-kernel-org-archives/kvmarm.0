Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188E44399D2
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752046; cv=none; b=IGMhBoAnewN3d45ZzwcCz9mW0NhBLHlqGJgfkhd1QfEYKSoyX05WQ3wfELaZ+UHiwo2rRBRkGPj0ABcW2HSVkYOOblx6fcLnyp4DRh3n2G/e/jQ5yYpGOkzDCC2lA6HNQaq5EFTmZ8TnsmvljB7QsMTPDLa8oQRSQg8ufa8FS48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752046; c=relaxed/simple;
	bh=sWoNCKDIOcVGJeN8iQzc66aNcbKSfNecYDC8xyJos2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BpxyinjahEFdqaNRuRxU6MxoUg4VCYmV3PycCNOdInDSo273Mb2GB9CfRBPhMI92ljqGEi0FmPSnI7gS3xY2XZUJp68pFjZYJZ/g6BdUhizNNEDSlFQRxu9IQAGdQAmr15hl0Fh3YgSDWVT2D2vWV/F5eW96sNvUyfX6hYT72Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZrUDngjT; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZrUDngjT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784752044; x=1816288044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4tdZIKqk1KOwy6KV41836GjWMmzaCTY8AMcClAGUR5I=;
  b=ZrUDngjTw8j7meFmljCSsjRot2bjOX56qIRim8XnajPWUTCUC/R07gir
   /lV4c+up3p5JfN2XcKL+D5onr+Jvc0xDnrkUuKWZVtuC/zKGGyIggG81F
   e0Vw5/6CLOn2bUtTh7MMuknXScvGeEyp0lJGEjUX8oCk8ycTX3XzOwLjM
   leJ4dAeZlyfZHjGczeviA1gDzkeGw5KNAOYBCezAddBNnpyW8/Ly/JHAU
   +UMHc8cQPllsxJCY7peKDB1XJVCX3Qg/2OGQJ5i4Y8nmkWCoi/Vh39oDu
   6VF2c3vQrK08p6V5ODT5Tj8J4oEVfr3nMi0bOSOok4+C/2nJKXBlQzwFh
   Q==;
X-CSE-ConnectionGUID: ugh81CEfS0mBEyUZjWZN0w==
X-CSE-MsgGUID: UKx1CdUoQbOsXiVEsf/Wbg==
X-IronPort-AV: E=Sophos;i="6.25,179,1779148800"; 
   d="scan'208";a="24175846"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 20:27:23 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:15180]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.176:2525] with esmtp (Farcaster)
 id d2a3db87-e10d-48ee-8a5c-527d8b8a4244; Wed, 22 Jul 2026 20:27:23 +0000 (UTC)
X-Farcaster-Flow-ID: d2a3db87-e10d-48ee-8a5c-527d8b8a4244
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 20:27:23 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 20:27:22 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Haris
 Okanovic" <harisokn@amazon.com>, Geoff Blake <blakgeof@amazon.com>,
	"Stanislav Spassov" <stanspas@amazon.de>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/4] KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAPI
Date: Wed, 22 Jul 2026 20:27:00 +0000
Message-ID: <20260722202702.4165917-3-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260722202702.4165917-1-congkai@amazon.com>
References: <20260722202702.4165917-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
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
index 7ac00423fa8d..bcfd0a91e114 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -838,9 +838,9 @@ static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
 	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
 }
 
-static u64 compute_pmceid0(struct arm_pmu *pmu)
+static u64 compute_pmceid0(struct kvm_vcpu *vcpu)
 {
-	u64 val = __compute_pmceid(pmu, 0);
+	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 0);
 
 	/* always support SW_INCR */
 	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
@@ -849,32 +849,33 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
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

