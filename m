Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607AD32196
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J6WaDZTy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697741792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9copWJRI5bIhEpSobDgLYfZGrEBdG4q2+NHphLIhWWI=;
	b=J6WaDZTy+S8ZWUrC6A747koFbi9O38gRhAnFhgnmXOVUG98dqMXdLGco1V5729ad2zFRSE
	1vMVioqs/HUg1UDfCatGAB21dBjCNybl2lYPg47rshycxh6qBrfrbhY8ANtwO29XZSUQmm
	mXnVP2fNnKERIR/5gwipxENLfzKVHy4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 2/2] KVM: arm64: Add PMU event filter bits required if EL3 is implemented
Date: Thu, 19 Oct 2023 18:56:18 +0000
Message-ID: <20231019185618.3442949-3-oliver.upton@linux.dev>
In-Reply-To: <20231019185618.3442949-1-oliver.upton@linux.dev>
References: <20231019185618.3442949-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Suzuki noticed that KVM's PMU emulation is oblivious to the NSU and NSK
event filter bits. On systems that have EL3 these bits modify the
filter behavior in non-secure EL0 and EL1, respectively. Even though the
kernel doesn't use these bits, it is entirely possible some other guest
OS does. Additionally, it would appear that these and the M bit are
required by the architecture if EL3 is implemented.

Allow the EL3 event filter bits to be set if EL3 is advertised in the
guest's ID register. Implement the behavior of NSU and NSK according to
the pseudocode, and entirely ignore the M bit for perf event creation.

Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c      | 15 +++++++++++++--
 include/linux/perf/arm_pmuv3.h |  9 ++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 32d83db9674e..e6be14e38cee 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -69,6 +69,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL2, pfr0))
 		mask |= ARMV8_PMU_INCLUDE_EL2;
 
+	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr0))
+		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
+			ARMV8_PMU_EXCLUDE_NS_EL1 |
+			ARMV8_PMU_EXCLUDE_EL3;
+
 	return mask;
 }
 
@@ -596,6 +601,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, reg, data;
+	bool p, u, nsk, nsu;
 
 	reg = counter_index_to_evtreg(pmc->idx);
 	data = __vcpu_sys_reg(vcpu, reg);
@@ -622,13 +628,18 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
 		return;
 
+	p = data & ARMV8_PMU_EXCLUDE_EL1;
+	u = data & ARMV8_PMU_EXCLUDE_EL0;
+	nsk = data & ARMV8_PMU_EXCLUDE_NS_EL1;
+	nsu = data & ARMV8_PMU_EXCLUDE_NS_EL0;
+
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
-	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
-	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
+	attr.exclude_user = (u != nsu);
+	attr.exclude_kernel = (p != nsk);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index e3899bd77f5c..9c226adf938a 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -234,9 +234,12 @@
 /*
  * Event filters for PMUv3
  */
-#define ARMV8_PMU_EXCLUDE_EL1	(1U << 31)
-#define ARMV8_PMU_EXCLUDE_EL0	(1U << 30)
-#define ARMV8_PMU_INCLUDE_EL2	(1U << 27)
+#define ARMV8_PMU_EXCLUDE_EL1		(1U << 31)
+#define ARMV8_PMU_EXCLUDE_EL0		(1U << 30)
+#define ARMV8_PMU_EXCLUDE_NS_EL1	(1U << 29)
+#define ARMV8_PMU_EXCLUDE_NS_EL0	(1U << 28)
+#define ARMV8_PMU_INCLUDE_EL2		(1U << 27)
+#define ARMV8_PMU_EXCLUDE_EL3		(1U << 26)
 
 /*
  * PMUSERENR: user enable reg
-- 
2.42.0.655.g421f12c284-goog

