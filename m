Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386019413E
	for <kvmarm@lists.linux.dev>; Mon, 26 Aug 2024 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724693205; cv=none; b=nCtafGEvS727DkiqjRBXn1gKgMDF6pmcTlvP5OJbY/040aT6+SVZbPa6uqI3I0/EhQ0UXRv4UK4Sy/HkyjzToyNnKSFbDXX4F3tiF3+k4fKyNHCkmPqLQ+fV7lxrhxl83voeRLyY4Rx1OlbRkTyDWUiGY2LcrAwSWQ5PQK2O8UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724693205; c=relaxed/simple;
	bh=GqgVB090w58YCPvscwYDM6UX7sWFLZgtt2CAO3zxa4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMht6zQv8txZO3HlhfRDGBjQvvZ8ONZGNDm4VfLsrecNMJLXaTtMK5nj8LHr9GtuTFO5JCrOPMJOvHWDP6LvaR88WvKrLzeJfZKviM6zKAymhuznUebPXKugCu5AcBoA8Ho5PT7u6j+nIxBVhrQZhJqRT+RAC9gO/6L3GFepIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XadaqFYI; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XadaqFYI"
Date: Mon, 26 Aug 2024 17:26:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724693201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4r15OjCWQXJP22lq8qXOJn/e2ao1TXJuWZL1y5R4bVk=;
	b=XadaqFYIPXP4IKmaOJIQCTpl2dWOF/8Fua8wfNvGeYor3ZnaoOhqxBPtVn/GpIexZVqPh9
	xsGvfnZGVv48sKIvNbfDKhivhzgHGtEcWbmqsNniMRBcoQ/SadpTHKPiTBdB1m1xJ/mVit
	pNxMJK2BbZ811JXI0em7Ka341DkloOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Add EL2 PMU event filtering support
Message-ID: <Zsy6zNQT2o6sTidY@linux.dev>
References: <20240824001402.3909504-1-oliver.upton@linux.dev>
 <86v7zpvwym.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v7zpvwym.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Sun, Aug 25, 2024 at 09:16:33AM +0100, Marc Zyngier wrote:
> On Sat, 24 Aug 2024 01:13:59 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > We allow a nested VM to be configured with a vPMU, although it isn't
> > entirely functional. We do not currently respect the EL2 event filter
> > configuration from the guest hypervisor, which really needs to be
> > applied to EL1 when in a hyp context.
> > 
> > Series to do just that. Tested on Neoverse-V2 which fortunately
> > implements PMUv3 and NV, unlike the fruity stuff I'm typically using...
> > 
> > Oliver Upton (3):
> >   KVM: arm64: Add helpers to determine if PMC counts at a given EL
> >   KVM: arm64: nv: Honor NSH filter when in hyp context
> >   KVM: arm64: nv: Reprogram PMU events affected by nested transition
> > 
> >  arch/arm64/kvm/emulate-nested.c |  4 ++
> >  arch/arm64/kvm/pmu-emul.c       | 77 ++++++++++++++++++++++++++++-----
> >  include/kvm/arm_pmu.h           |  3 ++
> >  3 files changed, 72 insertions(+), 12 deletions(-)
> > 
> > 
> > base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
> 
> I had a quick look, and definitely like the way it is shaping up (it
> does the job without fuss, and NV isn't about performance anyway).
> 
> However, I think it needs a bit more work so that MDCR_EL2.HPMN is
> correctly handled. This shouldn't be hard to do, and if FEAT_FGT is
> supported in the guest, then we could even expose FEAT_HPMN0 (though I
> haven't worked out yet why FGT is a dependency).

Right, I was hoping to spoon-feed some more PMU patches going forward,
since we already allow the NV+PMU combination and can treat it as a 'bugfix'.
But I'm happy to throw some more cycles at the problem.

I think there are some gaps in the way the other coarse-grained PMU
traps are handled (TPM, TPMCR), since it looks like they also apply to
Host EL0 based on the pseudocode. I don't want to have a separate
mechanism for describing these 'InHost' traps, so I'm gonna try and
address this like so:

 - Indicate if CGTs apply to host EL0 in the trap_bits descriptor

 - Steal a trap_config bit to indicate if a sysreg can trap while
   InHost, and:

 - Mark a trap_config as InHost if any of the associated CGTs are
   InHost when inserting in the xarray

That way I can preserve the early return for is_hyp_ctxt() for all but a
few trap configs.

Thoughts?

-- 
Thanks,
Oliver
