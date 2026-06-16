Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617B472798;
	Tue, 16 Jun 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635888; cv=none; b=n54RFGadBD4t8ImuO2ODcpkmevznzeVs7xvmop27dBmTuuxWlFa8Mc05RFQPHQhzb0aO3Dpi2I66/Wz3cjz63Dk8EoNlZrFNbAWNSMff+8aBnsemO0cJPRGV3/5r8mZ9ciESmDXPsxjfFb6txkKXA9hpN2AIMEwyZhu77x7nxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635888; c=relaxed/simple;
	bh=rmBRnG8AxqdlIuJyRiYimv60Y6yDX53K41LT0+N6dNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ie/0gkJguq3tzBsTOxfR5QNjtBaBHwR1DPVKPQx0fXkhiOS0FVJ0IeKsvZzr27bMvPHxpDDZpXcjKrDD9g8WuRirEni71VOSiHYR0K4PlmIMh4N21yItZSYQ/IyHc73rFBFOd24Owjqf22u5z2iiLl2H3oqfrQZBHlxvjwic+AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzT+Vjc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzT+Vjc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6989F1F000E9;
	Tue, 16 Jun 2026 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781635886;
	bh=+lcXMh4NrdCZ0Zg9FeWlSVZOphMiPhiVRq4MaeywrPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kzT+Vjc6/j4GgYdCUNbgJSqQ7q94v02nODN/3pdO0nfdWRj7kEULdzZeZLqBPpSUU
	 9NztSq6DMy5IZRdVuH8G91taxjMt/Lqdvt5/P5n7tC1foUe0yC5YNsBqPEXce22Z26
	 t5H+UfVZaNklQH258oPKO/AWsQ/bo8Dp1kKI2PB4kuhW0Dv4oXA7tAhePY8j7IbVBd
	 XiqR0YRw28X7EoiVpoYupOyTnPmp5gC+i72Qpo0jHFx1dIGAlzdlXfK5VCdr6h4lmR
	 nNO8tC7gfFjEqCE8Q2kMbK7BszKgpfMbgFuByd3SB5Sh6G7e6pHT8HAB84xwMCbcdD
	 ZNdkru2braFlQ==
Date: Tue, 16 Jun 2026 11:51:25 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Handle race between interrupt affinity
 change and LPI disabling
Message-ID: <ajGbLXf8Yc67cSI9@kernel.org>
References: <20260615181625.3029352-1-maz@kernel.org>
 <20260615183314.65A571F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615183314.65A571F00A3A@smtp.kernel.org>

On Mon, Jun 15, 2026 at 06:33:14PM +0000, sashiko-bot@kernel.org wrote:
> > @@ -795,7 +796,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
> >  			continue;
> >  		}
> >  
> > -		/* This interrupt looks like it has to be migrated. */
> > +		/*
> > +		 * This interrupt looks like it has to be migrated,
> > +		 * make sure it is kept alive while locks are dropped.
> > +		 */
> > +		vgic_get_irq_ref(irq);
> 
> [Severity: Critical]
> This isn't a bug introduced by this patch, but could the lock-dropping window
> here lead to a double list_del() and a use-after-free under certain race
> conditions?
> 
> When vgic_prune_ap_list() drops the irq and ap_list locks shortly after this
> reference is taken, another thread could concurrently execute
> vgic_flush_pending_lpis() above and remove the irq from the list.
> 
> If a third thread then concurrently injects the same LPI before the locks are
> reacquired, the irq_lock is taken and pending_latch is set to true again.
> 
> When vgic_prune_ap_list() reacquires the locks further down in the function,
> the target_vcpu oracle check will pass because the interrupt is pending again:
> 
> arch/arm64/kvm/vgic/vgic.c:vgic_prune_ap_list() {
>     ...
>     if (target_vcpu == vgic_target_oracle(irq)) {
>         struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
> 
>         list_del(&irq->ap_list);
>         irq->vcpu = target_vcpu;
>     ...
> }
> 
> Because there is no check verifying that irq->vcpu is still equal to the
> source vcpu, does this unconditionally execute list_del() on a list entry
> that has already been removed and poisoned?
> 
> Would this also bypass acquiring a new list reference, leaving the LPI on the
> new list with a deficient reference count if it avoids a crash?

Urgh... Marc, I think we need Hyunwoo's patch in addition to yours. Even
though this 3-way race seems improbable, it does appear possible :/

[*]: https://lore.kernel.org/kvmarm/aiHnI1mu6SGQrgnz@v4bel/

Thanks,
Oliver
