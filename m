Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E291B1B0128
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727992995; cv=none; b=lpwBSqZizcIIwtMxFNbBndnKJnXb36OlPtrNLLVHiljhsC3x1CPq3snzFLJ3SmTDQHoUMFkoyTjrISvbxBRb8HNs/NBsJSIbrixBFhLJ/HqBfrn89kUmtvUsI4zh5PjtPMvNV0zvCu2P/gHlM5DIGi2xjLVzSV/3AMvNqgZYrDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727992995; c=relaxed/simple;
	bh=+lTvyA/52YqlDRDE+Duq7tIHKJoAz1lKasl1XJEMpEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1Hh9jdH9LWGs4biLbmXvjWGOqYuAtYvV0D0FpNRyjXYkt2n4BkiUgYUnH0pN9BJemSZQjBRxtEOXdsU7XbC+CqKwRkZANDOINTb6kVlwP31wQbbToWPZgYjJTM24+hGR+4a+Yk8InbiHH098sfqoEpYagBkMMKiDqNjSU6/DB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mxr+SL3F; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mxr+SL3F"
Date: Thu, 3 Oct 2024 15:03:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727992989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xrRurHdEImnrmwD+VXbixWPyqn6Q045pXhmaqABhGYc=;
	b=mxr+SL3FtlaFk9dXEBtud3uYcrtHW+sWJAogY4eociNU4hmsGS2KYjWnmnaEQqKa1bnd2a
	bqd57FBj0OfADbpxlERzxfZn2j5bjP+mHwehz0rs/bMVlOSUCzGL3fkeb3pVx8wxZxn8Ws
	HP6gYKZXjdr3P1U2NWQcaRFp3VE2L20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <Zv8UmMfXOqT2A9_A@linux.dev>
References: <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org>
 <ZvyOcnZqNzfD7MZx@linux.dev>
 <ZvySjfDWOhl2O1IA@google.com>
 <865xqa6q0a.wl-maz@kernel.org>
 <Zv3fcT9lCSujib7J@linux.dev>
 <Zv3hgOhjaQGAuIOG@linux.dev>
 <Zv7KNFX4Mykff6I5@google.com>
 <Zv7Z4D0L3bnxJi8h@linux.dev>
 <Zv7hKD_6Pvhg4ULY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv7hKD_6Pvhg4ULY@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 03, 2024 at 11:23:36AM -0700, Sean Christopherson wrote:
> > > Why not?  The vCPU is still running, keeping its S2 MMU resident is desirable, no?
> > 
> > How could we possibly know what the intent of userspace is? The VMM
> > could just as well throw that vCPU fd on ice for an eternity.
> > 
> > For example, you could have a PSCI implementation that lives in
> > userspace. Guest does CPU_OFF and the VMM decides to terminate the
> > backing thread and keep the FD around for the next CPU_ON.
> 
> Yes, but we need to play the odds.

I agree that we can make an educated guess about the state of a vCPU
when it remains in kernel, but anything outside of that is guesswork.

> I.e. make the common case fast/efficient.
> KVM obviously needs to not fallover or crater performance in the presence of edge
> cases, but IMO, disallowing a vCPU from pinning a vCPU because it _might_ go
> offline is the wrong tradeoff.

But in the event of a 'rare' offline event the vCPU took out an MMU slot
forever, or at least until the VM decides to online it again. That feels
off to me.

So like I mentioned earlier, the common case is that the L1 is running a
VM where all of the vCPUs are sharing the same stage-2 MMU context.

In this case, it is highly likely that the L2 VM's nested MMU keeps an
elevated refcount, as at least one of the vCPUs remains in the KVM_RUN
loop.

In addition to that, we likely have quite a few free slots as we
overprovision the nested MMUs to make sure the worst case remains
functional. The only practical situation in which we would see thrashing
of the nested stage-2 MMUs is if the L1 were running more than 2*NR_VCPUS
VMs, which is already a 2x overcommit of the L1.

> > Since KVM still views that fd as 'runnable', it'd sit on the reference
> > that vCPU holds indefinitely. On top of that, it adds complexity to the
> > implementation since we would need more refcount cleanup flows to handle
> > these straggler references.
> 
> But only one flow, vCPU destruction, is mandatory.  Anything beyond that is pure
> optimization.

vcpu_load() / vcpu_put() is the mandatory flow in this design. We reload
the vCPU to handle nested transitions (i.e. L1<->L2), and we need to attach
an MMU that matches the new context.

> > > Essentially all I'm suggesting is that instead of having a common pool of 2*vCPUs
> > > TLBs per L1 VMM, have 2 (or however many) TLBs per L1 vCPU, plus maybe N extra
> > > TLBs per L1 VMM.  I.e. mimic the hierarchical design of hardware caches and TLBs
> > > to some extent.
> > 
> > Making TLBs private to the L1 vCPU is almost guaranteed to be a net loss
> > in performance.
> 
> I'm not saying make TLBs private, I'm saying allow each vCPU to "pin" (i.e. hold
> a reference) up to N TLBs/MMUs, regardless of "where" that vCPU is in the flow
> of things.  Versus the proposed behavior of pinning TLBs only when it's absolutely
> mandatory to do so for functional correctness.

Ah, got it. It is an interesting idea, if we want to explore any meaningful
value of N then we're gonna need to fix the allocation scheme. We'd
probably also need that mechanism to be more tightly integrated into
TLBIs to potentially drop references when a scope has been invalidated.

> Holding a reference across preemption would be the first step towards that model.

I'm OK with doing this for non-WFI preemption, which has the favorable
property of avoiding lock serialization at vcpu_load() in most cases
too.

-- 
Thanks,
Oliver
