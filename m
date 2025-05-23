Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478E31E5210
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 20:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748033929; cv=none; b=OQ5aIKHo2gyfmVl4so262RchxY09L7KO5DMTMRZZuF1ANe1HslZF1EPrDOOnHv7XGUq3QhJcuFOSudSofoScMnthe49fQUOR99LacMvEIxfjqa3PnVqZfYhw9UtKdqUYnbWJNGsff+FDhY/NvG4mgeIxGIDnOJ6Pu2QTdKKVVK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748033929; c=relaxed/simple;
	bh=1fsbwowsch0zFKJgbgMoxNCUqcgMtY7CfOxtYR4geeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0GJfuQnfwVtu3ZbxgArQfs/tfQB0wTBqvCFmNyNWbtwLzu/jFnPycIYIgSYSphrAWtMNj56V1UGgJcvarBpBUPYpoiOTCib9UV0TRpgJB/xfk67o0N0Nv/je1uRlaDvCauez2qJ/OAgiKHVahx5MjY0+WZage7fjt97NQaYcDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S1lOC5yb; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S1lOC5yb"
Date: Fri, 23 May 2025 13:58:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748033925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d3eybYOpSJygaDVEjsqD3QF0vKbEMpBQXJyc1Wmw2s0=;
	b=S1lOC5ybQm8TStv3JUYLmwhg755xfKLwQH9dj+nDeU0OW1o3nChcvBaMIs5eUeQ3cXiF3a
	3fRJwcrTjowMU4/z79ugtLzLHzxu92lxQ+nn4ngQLdOG7rUrjum4nZKZufh1C09HvkiHgv
	RsiOJBs46AslU5jsaTdX3iflq/kS0S8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: Re: [PATCH 4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI
 routing information
Message-ID: <aDDhe3zALhGeoJux@linux.dev>
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
 <20250523160810.4049313-5-oliver.upton@linux.dev>
 <87tt5bdyqu.wl-maz@kernel.org>
 <aDC00iSx34wk8AeS@google.com>
 <87zff3urdi.wl-maz@kernel.org>
 <aDDgaZPV2lid3GeS@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDDgaZPV2lid3GeS@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 01:54:01PM -0700, Sean Christopherson wrote:
> On Fri, May 23, 2025, Marc Zyngier wrote:
> > On Fri, 23 May 2025 18:48:02 +0100,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Fri, May 23, 2025, Marc Zyngier wrote:
> > > > > @@ -2803,6 +2804,28 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> > > > >  	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
> > > > >  }
> > > > >  
> > > > > +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> > > > > +				  struct kvm_kernel_irq_routing_entry *new)
> > > > > +{
> > > > > +	if (new->type != KVM_IRQ_ROUTING_MSI)
> > > > > +		return true;
> > > > > +
> > > > > +	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
> > > > > +}
> > > > > +
> > > > > +int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> > > > > +				  uint32_t guest_irq, bool set)
> > > > 
> > > > If we're adding this, can we take out the trash and get rid of this
> > > > 'set' parameter? Its only purpose is to be set to '1' and fed to the
> > > > x86-specific stuff. How about this:
> > > 
> > > Can we hold off on any changes to the common APIs?  Unless they're urgent and
> > > need to land in 6.16, I've got a massive series that I've been slowing working
> > > on for ~7 months that fixes this wart, and several more, e.g. gets rid of
> > > kvm_arch_irqfd_route_changed() entirely, and make the above ugliness into:
> > > 
> > > void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
> > > 				   struct kvm_kernel_irq_routing_entry *old,
> > > 				   struct kvm_kernel_irq_routing_entry *new)
> > > 
> > > 
> > > I'm ~90% confident it'll land in 6.17:
> > > https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com
> > 
> > Sure, if you want to preserve this fossil for another round, I don't
> > really care. But if you are planning your grand plan for 6.17, you
> > could as well rebase on top of theses patches which are aimed at -rc1
> > (yes, they are bug fixes), and it would then be perfectly acceptable
> > to have this cleanup early.
> 
> I'll be rebasing either way, so I'm not comletely opposed to it, I just don't
> see much value in rushing this particular change into 6.16 given that there's a
> bigger cleanup looming.

+1. Having a minor refactor that survives for a single kernel release is
just unnecessary churn. I imagine some folks will want to backport this
and basing the fixes series on the existing pile of crap will make that
a bit easier.

Thanks,
Oliver
