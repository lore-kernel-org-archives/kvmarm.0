Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B060216E1F
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880688; cv=none; b=u7hjIkDHdOFCqIIXrISgmmj3Pb6f3sRu8TZgKvLUzw3stap24nAVyevC6l04YF0BNIbf/6bvbEVDIrfmsEvwJiI8eaDwN8eGXkBZs6+sxE4OcWNXypaMTmksNO/2u5McA1F+wzGiOBcB86H3+CYWOhKw4BzKl8JC6Tdvas2c26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880688; c=relaxed/simple;
	bh=hfE2jrLI8Wub6PeIsfHPmMzyzyRjeYZOW47T7BeWD+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PivowFKqaYk2H9xOsLjvwFbt/uq4cX98s663Hy7N6u1svInN76gCqdNmuhE8eH+y+zlerdiUA2lzzpGZBk48eQ6ZHs6NdFxX3YmvO9IAV64pYA0MfZXyEOTY8fqseAnfhL51rLWCktgFqJ+GUXUdiAveS21E4MmF1updu/M9ffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tzsa6SIp; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tzsa6SIp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O7f8WlbTuKg/9ktNP6L6Uj0B1bwQ9caDZTgl7idjk1c=;
	b=tzsa6SIpMG2GGdxlZz43xIRwLBzOu3M1d3lUZt7g+JKNgpiibDr3Zh11gbQ2IVr/R+jZcw
	BmNMehCrxb69CuK+1R3Mko9Lg0pBjDBUk/9/BfquiDSI1oA/Tt8wlh2fuQVa5Wcu+WEWUS
	LwSl11kGz29JVI1HwUt5VXIwfSUcJgc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 17/18] KVM: arm64: nv: Apply EL2 event filtering when in hyp context
Date: Fri, 25 Oct 2024 18:23:52 +0000
Message-ID: <20241025182354.3364124-18-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It hopefully comes as no surprise when I say that vEL2 actually runs at
EL1. So, the guest hypervisor's EL2 event filter (NSH) needs to actually
be applied to EL1 in the perf event. In addition to this, the disable
bit for the guest counter range (HPMD) needs to have the effect of
stopping the affected counters.

Do exactly that by stuffing ::exclude_kernel with the combined effect of
these controls. This isn't quite enough yet, as the backing perf events
need to be reprogrammed upon nested ERET/exception entry to remap the
effective filter onto ::exclude_kernel.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1e9cdbc235a8..e2eb2ba903b6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -653,6 +653,17 @@ static bool kvm_pmc_counts_at_el1(struct kvm_pmc *pmc)
 	return p == nsk;
 }
 
+static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	u64 mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+	if (!kvm_pmu_counter_is_hyp(vcpu, pmc->idx) && (mdcr & MDCR_EL2_HPMD))
+		return false;
+
+	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -695,11 +706,19 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
 	attr.exclude_user = !kvm_pmc_counts_at_el0(pmc);
-	attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
 
+	/*
+	 * Filter events at EL1 (i.e. vEL2) when in a hyp context based on the
+	 * guest's EL2 filter.
+	 */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		attr.exclude_kernel = !kvm_pmc_counts_at_el2(pmc);
+	else
+		attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
+
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
 	 * code, carefully dealing with the initial sample period
-- 
2.47.0.163.g1226f6d8fa-goog

