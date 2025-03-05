Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A5925C6E5
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206451; cv=none; b=EyrydJK/0QjEz7/PO2fo2amQPyIcN+ZBmrEPBuIDCKYK89vN3K81LFSHeHcWEUJHQkPm6dBthySFZRIOCA0xxH1d1Y4xJqlG0sEnOzwWIaqRVxu+lwEG79v2rA7Pv9ncwhxgutc964PzwIIOpCdBNHXXur7MU566z+CiXT2UZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206451; c=relaxed/simple;
	bh=v72i9ZH+iPBdgthNaHtc/GiAHWIJJ4cxFYQyr0iAwOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=psFVqEqZvjTYGyv8pMNgfm4VyTvE4hc8an16YVEuJbpPMH/AlfdWye4EA3m87F9aU9EB9ytg1T9xYbyB2ODz9pIif7dQ3CosdUASgmZfUjfDypDLrRcP3l11be4dVqwoIo9VCTMwMgmEpHZuc5Rh3b1wnK3UgWdEQvndFXDWbgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M2R3OIBO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M2R3OIBO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfEdFUvQ2EkRiUWOzt1MvFJ8DJkkjSEDwZPsVt74AJw=;
	b=M2R3OIBO2T2joABxVS4DWe8rw8KKxwY5m9riq5I9pxyXhzZ4kifOy+Qdm2MNmL0VC8c2A3
	H6cb+zuqg0mL9+SgzWjE6JqFJCvOzxQ/VOs8NGbcESgdLV5aAWuYUERI1xw3mQA9kOxBud
	jKhdb+/5aZ/YhSuWnluCHt1QF13Iu+8=
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
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 11/14] KVM: arm64: Remap PMUv3 events onto hardware
Date: Wed,  5 Mar 2025 12:26:38 -0800
Message-Id: <20250305202641.428114-12-oliver.upton@linux.dev>
In-Reply-To: <20250305202641.428114-1-oliver.upton@linux.dev>
References: <20250305202641.428114-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Map PMUv3 event IDs onto hardware, if the driver exposes such a helper.
This is expected to be quite rare, and only useful for non-PMUv3 hardware.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c    | 25 ++++++++++++++++++++++++-
 include/linux/perf/arm_pmu.h |  4 ++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 38d9490c17fd..5f4e9be8aa8b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -677,6 +677,20 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
 	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
 }
 
+static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
+{
+	struct arm_pmu *pmu = kvm->arch.arm_pmu;
+
+	/*
+	 * The CPU PMU likely isn't PMUv3; let the driver provide a mapping
+	 * for the guest's PMUv3 event ID.
+	 */
+	if (unlikely(pmu->map_pmuv3_event))
+		return pmu->map_pmuv3_event(eventsel);
+
+	return eventsel;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -687,7 +701,8 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
 	struct perf_event *event;
 	struct perf_event_attr attr;
-	u64 eventsel, evtreg;
+	int eventsel;
+	u64 evtreg;
 
 	evtreg = kvm_pmc_read_evtreg(pmc);
 
@@ -713,6 +728,14 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
 		return;
 
+	/*
+	 * Don't create an event if we're running on hardware that requires
+	 * PMUv3 event translation and we couldn't find a valid mapping.
+	 */
+	eventsel = kvm_map_pmu_event(vcpu->kvm, eventsel);
+	if (eventsel < 0)
+		return;
+
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 4b5b83677e3f..7ce6dea5bfa9 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -100,6 +100,10 @@ struct arm_pmu {
 	void		(*stop)(struct arm_pmu *);
 	void		(*reset)(void *);
 	int		(*map_event)(struct perf_event *event);
+	/*
+	 * Called by KVM to map the PMUv3 event space onto non-PMUv3 hardware.
+	 */
+	int		(*map_pmuv3_event)(unsigned int eventsel);
 	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
 	bool		secure_access; /* 32-bit ARM only */
 #define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
-- 
2.39.5

