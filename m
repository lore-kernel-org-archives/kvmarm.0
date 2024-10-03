Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48374C92
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914379; cv=none; b=DE+YKkTZfcapiOfP3mg5CDjnNSlf34i19APC6sZ22LhNAQ8ytgTTw7RxWTNsijX8YsppLuL3mJzqpYV8XTQV88xlazKm314ilps1+gEdS+IoP7DV+/3YnWN5HbqKdmd9MJYyxo8D/U4xfm+1kVfMJEZ8nAwTfhOzbRjDm99NSWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914379; c=relaxed/simple;
	bh=Y62vgAdPMqyAk56mFW+wIy0i9uAnDSmro1exnTXwaLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R54oegU87J2lKby1oRXHSvQn1W0AGaArr7pHLH+uFO6EteI5K3Dqu8I78CxlT+CWEtvpSh2t1N7YhjyuXkJbJIJighnnyHR5OpFw5jsmvXwaQqUW3jsTU04JaBgAesNRCWBNKjba+A1s/YZNlY38ceWSLCB3HPpwHQKdzNE2SX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FGqUcIK2; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FGqUcIK2"
Date: Thu, 3 Oct 2024 00:12:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727914374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TjhSod9+vVM0x9AQtvn4kjgpPDKTDcl2kmuRYLvi3i0=;
	b=FGqUcIK26lS6bFt/naWa6Zl1FNPKoHW0mmIn4HQJrDiCf1kbRO9MgCKN52x8mLq/dwH1a/
	X3oV5bfqAHycczYQMDg6ho6x3ncJdY0bxHuheaMQB2nRAANV4H6n4LBo+tt+sx2/3zvw8k
	fD2gvXJ8iaMA/GDk1gf0ZuP+RgGG2gY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <Zv3hgOhjaQGAuIOG@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev>
 <ZvxH3el9SNuNWwi8@google.com>
 <ZvxeeVn8LphHxWeS@linux.dev>
 <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org>
 <ZvyOcnZqNzfD7MZx@linux.dev>
 <ZvySjfDWOhl2O1IA@google.com>
 <865xqa6q0a.wl-maz@kernel.org>
 <Zv3fcT9lCSujib7J@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv3fcT9lCSujib7J@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 03, 2024 at 12:04:06AM +0000, Oliver Upton wrote:
> Hey,
> 
> On Thu, Oct 03, 2024 at 12:31:33AM +0100, Marc Zyngier wrote:
> > On Wed, 02 Oct 2024 01:23:41 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > IIUC, KVM round-robins across 2*nr_vcpus MMUs, and when L1 switches to a different
> > > VTTBR, it will first drop its reference to the previous MMU.  So at any given time,
> > > there are nr_vcpus worth of unused MMUs, i.e. a vCPU is guaranteed to be able to
> > > find an unused slot, even if vCPUs that are scheduled out hold onto their S2 MMU
> > > reference.
> > 
> > It's not about not finding a slot, but about making sure that vcpus
> > that context switch rapidly between VTTBRs for their own guests can do
> > so freely without sacrificing the TLBs they have just produced. Not
> > reusing the TLBs hogged by a vcpu that cannot run is a waste of
> > resource.
> 
> OTOH, our global TLBs don't model hardware exactly since a vCPU doing
> rapid context switches trash the TLBs of *all* vCPUs in the system.
> The cost of reusing an MMU is quite noticeable, since our unmap
> implementation is slightly crap at the moment, the cost of which shows
> up both on sides of the reclaim (victim and user).

Oh, and why unmap is crap:

The walker has no way of informing the iterator how far into the range
the walk actually got. Instead, the iterator forcibly walks every
PUD/PMD sized chunk.

So if you have massive holes in your IPA space (which we generally do)
then you wind up revisiting the same invalid PGD entry a bunch of times.
And TLBI for it too when you have TLBIRANGE.

I'm working on a fix for this too, but what I have right now needs to be
aggressively de-crapified first.

> > >
> > > At that point, choosing an MMU that no vCPU is using seems more likely to recycle
> > > a cold/dead MMU than a soon-to-be-reused MMU.
> > > 
> > > And the round-robin approach makes it all heavily luck-based anyways.  E.g. if
> > > a vCPU puts VTTBR A and then loads VTTBR B, B could recycle A's S2 MMU if that
> > > MMU slot is next up for recycling.
> > 
> > Well, we'll have to agree to disagree. It's a terrible hack to add
> > artificial ties between a vcpu and TLBs. Because that's what the
> > shadow MMU is, nothing else.
> > 
> > So if you don't like the TLB eviction policy, please come up with a
> > better one, making sure that a recently preempted vcpu gets its S2 MMU
> > recycled last. But please don't add the notion of "locked TLBs" to the
> > mix, because that's a pretty dodgy architectural concept.
> 
> Well, I've effectively implemented "locked" TLBs by way of allowing
> vCPUs to pin an MMU when doing some MMU operation. It's just that the
> detail gets encoded in the callsite instead of being some general
> property of MMU assignment.
> 
> After fiddling with this a bit more (diff below), I'm actually inclined
> to go for holding a reference on scheduled out vCPUs *if* we have reason
> to believe it is gonna do something useful. You get a stable hw_mmu
> pointer in the places where it matters and can avoid taking the MMU lock
> for write during vcpu_load() in the 'fast path'.
> 
> Still should drop the reference in most other cases, as I do *not* want
> to entertain vCPUs holding a reference when they've gone out to
> userspace.
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index f9e30dd34c7a..df670c14e1c6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -663,6 +663,13 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>  
>  void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * The vCPU kept its reference on the MMU after the last put, keep
> +	 * rolling with it.
> +	 */
> +	if (vcpu->arch.hw_mmu)
> +		return;
> +
>  	if (is_hyp_ctxt(vcpu)) {
>  		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>  	} else {
> @@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  
>  void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
> +	/*
> +	 * Keep a reference on the associated stage-2 MMU if the vCPU is
> +	 * scheduling out and not in WFI emulation, suggesting it is likely to
> +	 * reuse the MMU sometime soon.
> +	 */
> +	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
> +		return;
> +
> +	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu))
>  		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
> -		vcpu->arch.hw_mmu = NULL;
> -	}
> +
> +	vcpu->arch.hw_mmu = NULL;
>  }
>  
>  /*
> -- 
> 2.47.0.rc0.187.ge670bccf7e-goog
> 
> 
> -- 
> Thanks,
> Oliver

-- 
Thanks,
Oliver
