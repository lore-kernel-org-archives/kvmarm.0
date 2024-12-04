Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA5C2391A0
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 21:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349431; cv=none; b=nd+n8ukL4Yp8cvr3jRa4ofq2A20+WNgm7tVIOpm2h853k4iCmai428nZvZ9BHGIe0vYNRg1UPWSzH2chSbqKWBN2wqu14duZJGxAVs5LJhRcY2S7S9q+4Exuiu9sliABpk0/07pP3mEVEssWKvSLwMrwP07Et+mqQtS+PteGGjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349431; c=relaxed/simple;
	bh=/LWCG9n7w965z/UOmQJBilR0ny5ELfMboiwTIMQeOeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu+ntv0iysyl6wwheV/GTQFvewKQrJ3QNuQyAgT0d49V6RHZghMkM2o5sH+XLguAUNK0uBIUXUS0H4rODjxtiVaACgmXGrAwqVrHMexyWJi9fjfHdds4lMuPWfEluPAz4V9OEQzfsEevC/Km/vGli0QnmwNB8ofoELhU6jIa3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DdpLPeLw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DdpLPeLw"
Date: Wed, 4 Dec 2024 13:56:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733349426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RmeqvqWWSUYBUtVoitaaIKcqngujk/6p1ETAIdV+/c=;
	b=DdpLPeLwbJUxOj1OhAJzwuUqWHe0NNhVATfvn06/ghXi31JPgry15DyHseooq4Zc9vaq9u
	80qAL8nXldMTrEDyb+zARIXGhyrtJrjMUApsPcHHkAXJBGCOeo3Ev7SsYTEBCshgqJEyzp
	KcqHk+//eBHCs4wS1IlR7aT8OZyEJXk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/14] KVM: arm64: Always allow fixed cycle counter
Message-ID: <Z1DQKg02tebLmGsO@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
 <20241203193220.1070811-6-oliver.upton@linux.dev>
 <87ldwwsbad.wl-maz@kernel.org>
 <Z0-HBsBgf6WB7x4R@linux.dev>
 <87ikrzstt1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ikrzstt1.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 04, 2024 at 09:04:26AM +0000, Marc Zyngier wrote:
> On Tue, 03 Dec 2024 22:32:38 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > > More importantly, the current filtering works in terms of events, and
> > > not in terms of counters.
> > > 
> > > Instead of changing the ABI, how about simply not supporting filtering
> > > on such non-compliant HW? Surely that would simplify a few things.
> > 
> > Yeah, that sounds reasonable. Especially if we allow programmable event
> > counters where the event ID space doesn't match the architecture.
> 
> Another thing I have been wondering is if a slightly better approach
> would be to move some of the handling to the PMU driver itself, and
> let it emulate PMUv3 if it can. This would allow conversion of event
> numbers in situ rather than polluting the PMUv3 code in KVM.

Sure, but I think the actual event fed into perf_event_create_kernel_counter()
should be the correct hardware event, not a PMUv3 event reinterpreted
behind the scenes. Otherwise, we'd need to devise an alternate config encoding
for PMUv3-like events since the event ID spaces overlap.

I'm thinking this could be a helper in the arm_pmu struct that takes a
PMUv3 event and spits out (in this case) an M1 event. The resulting KVM
code would be miniscule, like:

u64 kvm_map_pmu_event(struct kvm *kvm, u64 eventsel)
{
	struct arm_pmu *pmu = kvm->arch.arm_pmu;

	if (!pmu->map_pmuv3_event)
		return eventsel;

	return pmu->map_pmuv3_event(eventsel);
}

static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
{

	[...]

	attr.config = kvm_map_pmu_event(vcpu->kvm, eventsel);
	event = perf_event_create_kernel_counter(&attr, ...);
}

We could even have the M1 PMU driver populate arm_pmu->pmceid_bitmap
with the events it knows about and get PMCEID emulation for free.

-- 
Thanks,
Oliver
