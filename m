Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C4A1DD9D7
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323207; cv=none; b=kWfgGCiUzHkKAlMp+k7TTKDpFe1CbiStTerv31In+uv58KkkuU1fqZ9OVvjV8HO5SbE4343BNx88TuGAxkoH91fGlr2HKHDTf0Ssbppkm+B1rij0xVy31EsuGTaGIs2zWPI8clPmBY2XGO4Zb3C27BuFS/QI8ujhnkaF1+ZE6xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323207; c=relaxed/simple;
	bh=UEnBRWw5cOCtzZP//oZEV2bbH4JXTHnXnKVLLFyBWNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP/w8oMgUAuY4KAM2R0wjiCN/43SBPu1Y2b7WOz4s5nFqmL3FqEi7iqWshx37Cm6bj6QBytgEVya3tOLU1090uf8fVxBMXwWxsqnAr/uQzGWbutjGzu5FLBPE+irMhuoMLSSIZGeLG4wF2Wgu2FOGN/T/A5j5+2CKtbH7BRqYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UIx+tGz9; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UIx+tGz9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bAG8UHUI3pYArufL9uFnVVDA9vJn7ykGDPmuqHtF0jY=;
	b=UIx+tGz9IxiQq6WJDForEwsKyEoNCpji8wnxoJEO2fhNwV5J9yFECcKzql3v4uWN8Oua01
	6Vgx0ZOXm/VPkTPF8jtpnYTIRercvNwaZANZkzykWMiXjPJWu4haowV/18JaIZisS2Iqv+
	8j/wM/m5YKKgyAUYfXx+K99b5qYs38w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 16/17] KVM: arm64: nv: Apply EL2 event filtering when in hyp context
Date: Mon,  7 Oct 2024 17:45:58 +0000
Message-ID: <20241007174559.1830205-17-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
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
index 69c11c46c79a..e7e9f8f25cbe 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -646,6 +646,17 @@ static bool kvm_pmc_counts_at_el1(struct kvm_pmc *pmc)
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
@@ -688,11 +699,19 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
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
2.47.0.rc0.187.ge670bccf7e-goog

