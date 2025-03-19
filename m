Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE61EEE6
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 07:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742369675; cv=none; b=ZkQ5As3N7usPTtTe3YyMXr2Q99FI/etUQUDGqTgeIcHRx4X8PFa0x8RJQy6Qnsdo6mESooRwThZUFpWn4Xhs+oj8g7LFrG8OVOyYdcGii9kV5kuCZhWoZWUdKXC+5zVIR4kxL0YI0B9hD6oOHg0Q4542vn610udvlhdT9FKZtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742369675; c=relaxed/simple;
	bh=ibfZ9ZaoDMGk9xUy8BLoGPKx4OXKnCGLoNOb0wj3ew8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFuHLIAXHS60JbdAdp1vcn/YhSaP+EWAo9F5tpFup8OmDAcmsseAxJ5P9RyF6oPp3wBXHGGC+qWQYxM6X9NxW0ulGhvnBgKVWtWVHKQ9uuPtJGducijMvG05Jk9x2xZ6Xc/ACKUrjyIXeWfD7VAwSoma1uC2GWPTLg7nLpA9QHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ncfmaFx0; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ncfmaFx0"
Date: Wed, 19 Mar 2025 00:34:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742369671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hVzS1cKjgXiIBmmhKBquRUyIr9x4Sbg/Puy66Jc/XtY=;
	b=ncfmaFx0/mTHHJGzal1ucHChoQgst0wOX9bqBOQI2NbZZkS9AxVV3nu8BZo6rHB9KLw2Ew
	WnbG1juHt47MAPrqg6uXRvD9hKpq/uO/HDvsuBP6F1w1bysitWkEILnJJPHfOSpnHSMmNo
	5JOQKnx71oSPTJgG9vPG6tyCy7/SEFg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com
Subject: Re: [PATCH RFC] KVM: arm64: PMU: Use multiple host PMUs
Message-ID: <Z9pze3J2_zrTk_yC@linux.dev>
References: <20250319-hybrid-v1-1-4d1ada10e705@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319-hybrid-v1-1-4d1ada10e705@daynix.com>
X-Migadu-Flow: FLOW_OUT

Hi Akihiko,

On Wed, Mar 19, 2025 at 03:33:46PM +0900, Akihiko Odaki wrote:
> Problem
> -------
> 
> arch/arm64/kvm/pmu-emul.c used to have a comment saying the follows:
> > The observant among you will notice that the supported_cpus
> > mask does not get updated for the default PMU even though it
> > is quite possible the selected instance supports only a
> > subset of cores in the system. This is intentional, and
> > upholds the preexisting behavior on heterogeneous systems
> > where vCPUs can be scheduled on any core but the guest
> > counters could stop working.
> 
> Despite the reference manual says counters may not continuously
> incrementing, Windows is not robust enough to handle stopped PMCCNTR_EL0
> and crashes with a division-by-zero error and it also crashes when the
> PMU is not present.
> 
> To avoid such a problem, the userspace should pin the vCPU threads to
> pCPUs supported by one host PMU when initializing the vCPUs or specify
> the host PMU to use with KVM_ARM_VCPU_PMU_V3_SET_PMU after the
> initialization. However, QEMU/libvirt can pin vCPU threads only after the
> vCPUs are initialized. It also limits the pCPUs the guest can use even
> for VMMs that support proper pinning.
> 
> Solution
> --------
> 
> Ideally, Windows should fix the division-by-zero error and QEMU/libvirt
> should support pinning better, but neither of them are going to happen
> anytime soon.
> 
> To allow running Windows on QEMU/libvirt or with heterogeneous cores,
> combine all host PMUs necessary to cover the cores vCPUs can run and
> keep PMCCNTR_EL0 working.

I'm extremely uneasy about making this a generalized solution. PMUs are
deeply tied to the microarchitecture of a particular implementation, and
that isn't something we can abstract away from the guest in KVM.

For example, you could have an event ID that counts on only a subset of
cores, or better yet an event that counts something completely different
depending on where a vCPU lands.

I do appreciate the issue that you're trying to solve.

The good news though is that the fixed PMU cycle counter is the only
thing guaranteed to be present in any PMUv3 implementation. Since
that's the only counter Windows actually needs, perhaps we could
special-case this in KVM.

I have the following (completely untested) patch, do you want to give it
a try? There's still going to be observable differences between PMUs
(e.g. CPU frequency) but at least it should get things booting.

Thanks,
Oliver

---
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a1bc10d7116a..913a7bab50b5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -724,14 +724,21 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
-	attr.type = arm_pmu->pmu.type;
+
+	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
+		attr.type = PERF_TYPE_HARDWARE;
+		attr.config = PERF_COUNT_HW_CPU_CYCLES;
+	} else {
+		attr.type = arm_pmu->pmu.type;
+		attr.config = eventsel;
+	}
+
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
 	attr.exclude_user = !kvm_pmc_counts_at_el0(pmc);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
-	attr.config = eventsel;
 
 	/*
 	 * Filter events at EL1 (i.e. vEL2) when in a hyp context based on the
