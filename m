Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61055298C10
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 17:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748022485; cv=none; b=O04t3bMyQIw7de7ZJQrZATrCYEFIQfshjuhPLuCXcQeBvDu6bf3Usb1FUraMm+Y0jZ60J1z0St3pLhCbUs5nf6CJ7W85ADPj/mgXXlW60K1Sw4aj60ynFXQWeqkefl5EX/6Xoco4Rt1kQV5HeSsPijgVKf30Is0mJXroYcH41IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748022485; c=relaxed/simple;
	bh=QXle2fwSNxrPc4e0B5VoVrEtNktUdDz1YQyzmEM8Sx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Je6JE5babJqeJ9s0lZHHa01GEtyVtts/4GxFkRFkHCz/culGC5SwOEoegTojTPn9GNBKfaLE73xLrVCHhzmtXukjHasPv3q4RheGKq8e8bROhM/QcZFw4oa9v00HEWqDtAer9GqXDvWFOMlGJSvOYjMOmx2q6PCjRL95PA/ZgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PxLDxSUs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PxLDxSUs"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311044c615fso293449a91.2
        for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 10:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748022483; x=1748627283; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LzrVx9ltC/nJ0P3fAJ66J1yXgBu3vK98xUgKVtbaiEE=;
        b=PxLDxSUskZpoeU6FSTjhPi9yChKB+R3hOm2AXVr30aZygZ9x2t1ZP9aBUTpCgJuLi+
         Q9Sm5jrZVZPfCUKZwS8R/ve/wHmM7my6tTEAOc1ttgtDrL+nS3NaJGwyXsdSvI/dSFvu
         0J4zR+NbUK5h7Mx1rNqnyr2327N52X/b7e6CpTt8zl/UGFm9w+SEKMq8ynnjOUl+n6HB
         Z2HuxRNqgJV6fZ/Glf47h6m/iGDDNf7QjRYZv2ZvEY91PrgrN7MA841risoIRJLkBAet
         54V/EMN9aYp5dXje4pVlGZuECSl/uLmhLQuR/9AAvKZICAyYagxh2jUffnMmxEWPjU+c
         zclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748022483; x=1748627283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LzrVx9ltC/nJ0P3fAJ66J1yXgBu3vK98xUgKVtbaiEE=;
        b=rMaviiW3Xn87hLSt4QEVyE+TgNJbajWvDjYYyQpQk+fsMyAakraI4u0EktRaZyusHt
         kTZsco63lKcnx7QRVvBDgB2g9qJG9pr71s5L8mtRYq0ygcYwgAN8cDCBf7YCGsBHfh3J
         OCc74Csj9uWtt/OLNX39PQZfNPPav7PuuYRHwIieYp2tvxRRD5s6jTOoauFli6W1p4/7
         JfrtfnmZ0aJ7KPEskGuGKD8nJ96PphaehIYB3B0VlV0RKXBxKE6ka+RswB1kUQFIc4Ga
         F5bhMszG9FLTiGmIv7G0MBJtJWN/c5e8MSgw8eunu4ckmLcSAOz2tOHhKZMMkqXJy8Sn
         YFRg==
X-Forwarded-Encrypted: i=1; AJvYcCW1fG+CEMUiGv5jj0aAwBF6W2MA6OzGpeStObOismKR3qzcO5Hxi4EsToNeq+0EBlcS5d/JDV8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTkXO4c7Eu5v1CprDZe3Enk9jUmkwhTUJFXn1hJrqKh2OC83XM
	74FDZFu8IxyGQYC+D/WVY0J7vGjPCsnByLQ5NvFsA15zwFnnuI0zbV/ETY6d2Yo1lirL0Z7dXfc
	TkKmN1w==
X-Google-Smtp-Source: AGHT+IHwKGGGa4m5M1W7jqsI/R5h3OJVPBjEtxc4cdxaxYKjI+g6cOxN4sNEEy5un4NQXPXvDR9RCj/00QE=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b03:b0:310:8d9a:95b6
 with SMTP id 98e67ed59e1d1-310e972b365mr6493398a91.25.1748022483578; Fri, 23
 May 2025 10:48:03 -0700 (PDT)
Date: Fri, 23 May 2025 10:48:02 -0700
In-Reply-To: <87tt5bdyqu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
 <20250523160810.4049313-5-oliver.upton@linux.dev> <87tt5bdyqu.wl-maz@kernel.org>
Message-ID: <aDC00iSx34wk8AeS@google.com>
Subject: Re: [PATCH 4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI
 routing information
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sweet Tea Dorminy <sweettea@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Marc Zyngier wrote:
> On Fri, 23 May 2025 17:08:09 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > KVM's interrupt infrastructure is dodgy at best, allowing for some ugly
> > 'off label' usage of the various UAPIs. In one example, userspace can
> > change the routing entry of a particular "GSI" after configuring
> > irqbypass with KVM_IRQFD. KVM/arm64 is oblivious to this, and winds up
> > preserving the stale translation in cases where vLPIs are configured.
> > 
> > Honor userspace's intentions and tear down the vLPI mapping if affected
> > by a "GSI" routing change. Make no attempt to reconstruct vLPIs if the
> > new target is an MSI and just fall back to software injection.
> > 
> > Tested-by: Sweet Tea Dorminy <sweettea@google.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/arm.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 1de49b48e35e..505d504b52b5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2790,6 +2790,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> >  	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
> >  					  &irqfd->irq_entry);
> >  }
> > +
> >  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> >  				      struct irq_bypass_producer *prod)
> >  {
> > @@ -2803,6 +2804,28 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> >  	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
> >  }
> >  
> > +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> > +				  struct kvm_kernel_irq_routing_entry *new)
> > +{
> > +	if (new->type != KVM_IRQ_ROUTING_MSI)
> > +		return true;
> > +
> > +	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
> > +}
> > +
> > +int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> > +				  uint32_t guest_irq, bool set)
> 
> If we're adding this, can we take out the trash and get rid of this
> 'set' parameter? Its only purpose is to be set to '1' and fed to the
> x86-specific stuff. How about this:

Can we hold off on any changes to the common APIs?  Unless they're urgent and
need to land in 6.16, I've got a massive series that I've been slowing working
on for ~7 months that fixes this wart, and several more, e.g. gets rid of
kvm_arch_irqfd_route_changed() entirely, and make the above ugliness into:

void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
				   struct kvm_kernel_irq_routing_entry *old,
				   struct kvm_kernel_irq_routing_entry *new)


I'm ~90% confident it'll land in 6.17:
https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index df5b99ea1f181..2d69609c1ec00 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13613,9 +13613,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>  }
>  
>  int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> -				   uint32_t guest_irq, bool set)
> +				   uint32_t guest_irq)
>  {
> -	return kvm_x86_call(pi_update_irte)(kvm, host_irq, guest_irq, set);
> +	return kvm_x86_call(pi_update_irte)(kvm, host_irq, guest_irq, true);
>  }
>  
>  bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 11e5d1e3f12ea..2e60d0bf02e2f 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -287,7 +287,7 @@ void __attribute__((weak)) kvm_arch_irq_bypass_start(
>  
>  int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
>  				struct kvm *kvm, unsigned int host_irq,
> -				uint32_t guest_irq, bool set)
> +				uint32_t guest_irq)
>  {
>  	return 0;
>  }
> @@ -621,7 +621,7 @@ void kvm_irq_routing_update(struct kvm *kvm)
>  		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
>  			int ret = kvm_arch_update_irqfd_routing(
>  					irqfd->kvm, irqfd->producer->irq,
> -					irqfd->gsi, 1);
> +					irqfd->gsi);
>  			WARN_ON(ret);
>  		}
>  #endif
> 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
