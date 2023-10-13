Received: from out-203.mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D55685
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 05:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M9Jybmmb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697174956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyjEKyXMo0g4AwiKVIa7onkN+7h/B5Cdn+wGrTBr5+4=;
	b=M9JybmmbJR7PdzMKMUmHQJMasIg7Gec03TwLFrNxdX2Y9apgsx5IUNB0AyhyLJ/EkOXocp
	lOD3uS71hOXN15u2EreeeC0AE8c1K9l+9TPKpVBuaVVUkRTOju+rw/b9CDy5rDP1ngho3C
	OiAtly3HSAfYuOarYgzyCDJZ986qrJQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/2] KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
Date: Fri, 13 Oct 2023 05:29:01 +0000
Message-ID: <20231013052901.170138-3-oliver.upton@linux.dev>
In-Reply-To: <20231013052901.170138-1-oliver.upton@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
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
OS does.

Implement the behavior of NSU and NSK as it appears in the pseudocode.

Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c      | 11 +++++++++--
 include/linux/perf/arm_pmuv3.h |  8 +++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f0d4a9ace5ad..d28e0e989c98 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -63,6 +63,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 {
 	return ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
+	       ARMV8_PMU_EXCLUDE_NS_EL1 | ARMV8_PMU_EXCLUDE_NS_EL0 |
 	       kvm_pmu_event_mask(kvm);
 }
 
@@ -590,6 +591,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, reg, data;
+	bool p, u, nsk, nsu;
 
 	reg = counter_index_to_evtreg(pmc->idx);
 	data = __vcpu_sys_reg(vcpu, reg);
@@ -616,13 +618,18 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
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
index e3899bd77f5c..b74e71da1fa7 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -234,9 +234,11 @@
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
 
 /*
  * PMUSERENR: user enable reg
-- 
2.42.0.655.g421f12c284-goog

