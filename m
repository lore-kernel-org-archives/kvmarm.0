Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9B0320F
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327703; cv=none; b=OG87fBoEYCicMXc+C0lZ9f1n8g9f8Rt9MocBW8w4kVP8075SdCZWm3eMH/sqphl4z/O5PQ8t4FJzlYE1lAYFKG0Z0Wfrvi8snmjXvYXFail5qk3m+aHZiT6YsrptliERGiUFGEfPkwn32zINIeN2cFY69gJur4kN4z+Ik2GtTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327703; c=relaxed/simple;
	bh=xpyWHqGivExbSJ7S2uVZrScEQBC6epvg5+pG2WEENu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPJveBe599TpyVKKIzrnG7/FqsDMPSlL1g+1dbc0REtvaS1aJV6xV3eUg9T8CvDiNqCWuiP1v0XSycLdDF5UqWTDn5sXc3yNBMNDxxKgDBfjt85wdykg94+PGWBK3CrrbUECgytOFNIu9zUxEzMcy35RWMpZ48ueXLrKz34m7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h5irivX+; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h5irivX+"
Date: Mon, 7 Oct 2024 12:01:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728327697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzXwIGIqZaBFXRCh371CFF3SJoN/+ruGCqDb32pnidU=;
	b=h5irivX+JEAjocRRem8cdWz4DNbTTvAKc1FXU1Yiqt2z+5q02vF9qE3EV/1uDyXK2tS7w7
	K/YjpejIgkQUhGySfr0Ss+DyY/62knwNSL9WzZ+7TB53wfZfs4rndsx5t1SuPReqr4io+7
	udXVfRbJlErzr2TkKXjzYOlE9buTfBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU
 when scheduled out
Message-ID: <ZwQwCqR11wlADRUA@linux.dev>
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-2-oliver.upton@linux.dev>
 <ZwQq6Vk5_7Or4hW1@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwQq6Vk5_7Or4hW1@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 11:39:37AM -0700, Sean Christopherson wrote:
> > @@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> >  {
> > -	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
> > +	/*
> > +	 * Keep a reference on the associated stage-2 MMU if the vCPU is
> > +	 * scheduling out and not in WFI emulation, suggesting it is likely to
> > +	 * reuse the MMU sometime soon.
> > +	 */
> > +	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
> > +		return;
> 
> Assuming KVM arm64 supports halt-polling, I think it makes more sense to check
> kvm_vcpu_is_blocking() instead of IN_WFI.  That way, KVM will keep the MMU resident
> if the vCPU happens to be preempted and halt-polling is successful.
> 
> And somewhat of a side topic, calling kvm_vgic_put() from kvm_arch_vcpu_blocking()
> instead of kvm_vcpu_wfi() would provide the same optimization for the GIC, as KVM
> would only need to put/reload the vGIC if the vCPU is actually scheduled out.

That wouldn't be an optimization, it'd render the halt polling loop
useless.

The most recent view of the guest's CPU interface is sitting in
hardware at this point, so we need to synchronize KVM's view of
the CPUIF with it to determine if a pending interrupt exceeds the
priority mask.

On top of that, we need to activate the doorbell IRQ for GICv4 to give
KVM a kick when something arrives for the vPE.

-- 
Thanks,
Oliver
