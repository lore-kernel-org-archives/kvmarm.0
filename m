Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F531FCFE2
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 20:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748033644; cv=none; b=PF/QSEHlOcGqRa6OHaW6RtRUkNtKGTploX0KoLefdeh5+nvhojYIZMaf3cNaXETu7hYKVHGmJVU+HK9ae81ktgGed02aPwjvVQFrujWLnGrtJAJODdYW3Z3GsyAIdDqRQCVgts2vGChljZ0TGxN0hWW01xjaJ3AtzCv/rrQydOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748033644; c=relaxed/simple;
	bh=D/la6nyyDvfZHSN7wrPBUiosRwqvKJGj/G+FW1dlRec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1NGnlhlzJ73B05+VjY27MYANUAdv6T0WzxqX0q/hrVxxBCcUaSQeIhhoqjIgOOy3frd1qVILRA7kcEnTuAMMwbLhNdfNKx4TZpCUecTijYq++OYq4vEXUdSfxpNlRG0x4FNSTAHTqXXM3dYtN3NLoh9BW468UzVuahE4ALfplw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YNcY534P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YNcY534P"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73e0094706bso419019b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 13:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748033642; x=1748638442; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FmO3tTRMkNe41ePanUvvfw3XEdroZHZlVPZHo8rXIFk=;
        b=YNcY534Pt5zZgtJE5LqSLcgpBeBSywIktoReNMsq44yT4pd81wSQyIbV+YW4DgGy0Y
         88murcJYknw2svSWPFOm3++DeRlOSOy6GxxVnj7hvG81Ob2HWhXugDPz//r0omTiaOF1
         HIVF2lYS8CRgvdeSEs7QgCUu/kMSpaOXuB7e4o7Ghwv8ra0hUqnVGFDKG8PrMFaZ4r2K
         Q1Une3dB6EX4wfc4eM2idb7dAVD4d50pfkIuOkg3zaRZ6sBhEFRx5bZDLXBZVJBqxXwR
         /8+5o3oDEfai23a2Z54v96aXY+cTqpnzttQelnPVecijkwzYUI7B+yepzZTqp7Gx8jEN
         UydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748033642; x=1748638442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmO3tTRMkNe41ePanUvvfw3XEdroZHZlVPZHo8rXIFk=;
        b=WXB0WdZBldjoqT6uXf8NWaji2vsAL40IKwRGm5q3ZPGbhvHaE8n79Xkuc+W9stImoY
         tJ/nuilnWgUDQ2d9vFsF7lz+ekolG7IB8vDW5igi8yQvoINQgIrfq+iEzF+FTSN1J8tE
         dmssOZ3zqzjSaAhwO0O7lc/3Y+hOzoA7BIh7BkDYdXtVVrVdCS6zMn2JLnxyjl63pPW6
         pjtRaioZinT4sJ9HhUavp+AY859jpYsrudZX5DSdHsvBfWpCyl+8qrPoSFG6ZFOJFRb6
         On+5xNtrPA+kXBmmiSdncyuV/zpKThKW7+OrAQuAHoqsKz2CqjApyuyUknRyZgfoMegc
         doVQ==
X-Forwarded-Encrypted: i=1; AJvYcCURdkjbxV4K5tkdbJpfIROi1SpBBDqsWSZrhis+WvzcNAPXF8N64RhbQ4hAIPeS8hU/RPOU+Kg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnFMdhRIecwLNCct4S+CV3K07h9yF3T+Pi0GRfAf2WXam6i6d6
	1oLCJHQKjLtfQrvmIYKbvoThQ5EVf+nv0FST4JIGSs/y38h3Hmez8q8lXHSVJRd+AXctQX15HPO
	rcM2p5g==
X-Google-Smtp-Source: AGHT+IFbIwciSjSM98E7LzB9PQ4N643tCRO/ofEd36MoiOgqLW76e2q51bGMMrI1g4zqIyaGoY/KSAvuUg4=
X-Received: from pfbhd3.prod.google.com ([2002:a05:6a00:6583:b0:742:a60b:3336])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a0e:b0:736:5b85:a911
 with SMTP id d2e1a72fcca58-745fde9e23fmr1364791b3a.8.1748033642501; Fri, 23
 May 2025 13:54:02 -0700 (PDT)
Date: Fri, 23 May 2025 13:54:01 -0700
In-Reply-To: <87zff3urdi.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
 <20250523160810.4049313-5-oliver.upton@linux.dev> <87tt5bdyqu.wl-maz@kernel.org>
 <aDC00iSx34wk8AeS@google.com> <87zff3urdi.wl-maz@kernel.org>
Message-ID: <aDDgaZPV2lid3GeS@google.com>
Subject: Re: [PATCH 4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI
 routing information
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sweet Tea Dorminy <sweettea@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Marc Zyngier wrote:
> On Fri, 23 May 2025 18:48:02 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Fri, May 23, 2025, Marc Zyngier wrote:
> > > > @@ -2803,6 +2804,28 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> > > >  	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
> > > >  }
> > > >  
> > > > +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> > > > +				  struct kvm_kernel_irq_routing_entry *new)
> > > > +{
> > > > +	if (new->type != KVM_IRQ_ROUTING_MSI)
> > > > +		return true;
> > > > +
> > > > +	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
> > > > +}
> > > > +
> > > > +int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> > > > +				  uint32_t guest_irq, bool set)
> > > 
> > > If we're adding this, can we take out the trash and get rid of this
> > > 'set' parameter? Its only purpose is to be set to '1' and fed to the
> > > x86-specific stuff. How about this:
> > 
> > Can we hold off on any changes to the common APIs?  Unless they're urgent and
> > need to land in 6.16, I've got a massive series that I've been slowing working
> > on for ~7 months that fixes this wart, and several more, e.g. gets rid of
> > kvm_arch_irqfd_route_changed() entirely, and make the above ugliness into:
> > 
> > void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
> > 				   struct kvm_kernel_irq_routing_entry *old,
> > 				   struct kvm_kernel_irq_routing_entry *new)
> > 
> > 
> > I'm ~90% confident it'll land in 6.17:
> > https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com
> 
> Sure, if you want to preserve this fossil for another round, I don't
> really care. But if you are planning your grand plan for 6.17, you
> could as well rebase on top of theses patches which are aimed at -rc1
> (yes, they are bug fixes), and it would then be perfectly acceptable
> to have this cleanup early.

I'll be rebasing either way, so I'm not comletely opposed to it, I just don't
see much value in rushing this particular change into 6.16 given that there's a
bigger cleanup looming.
