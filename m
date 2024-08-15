Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BF01714DB
	for <kvmarm@lists.linux.dev>; Thu, 15 Aug 2024 12:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723723694; cv=none; b=PC41MfsHIVEcOyYcmsnjZZsqcLnubzL+lwRI8HhK6Fy8PuoYIpkV7DGZ+o2vEWqQNa9q7uIHQn5DCwcJqTL1PWP1bEkU8QbouQy051Rs5QehZ+YTuAs5Rtx4YGkaPB4Hq6iZNVVodofxqcnlD/FD/sDuxVPES2JtAOIAC7W0FmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723723694; c=relaxed/simple;
	bh=PwO7Q0OxKpR0x01p8xfvh019piHM7daDQq117UP0e50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnuoyzB6LyWg/Oj2M5H/jmOExOPIDbrAFMSwlD9qJ73OEFX910AuC9MBj5rfZ/2NSIrOmV54RKY1ay6voLjLIkMo6COwuHZvhjsMLbtbPYZ8ifR3JnSF4th6L6js/QZcHzooCwP3ZgKJCWcDZC1p4D1h/p6jYSs3Tz7tr1arQ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBaEX6+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBaEX6+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFC3C32786;
	Thu, 15 Aug 2024 12:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723723693;
	bh=PwO7Q0OxKpR0x01p8xfvh019piHM7daDQq117UP0e50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lBaEX6+AvNexhoNsl3j9IWShjXCMsI6jJeA6yWUX9wHysd8BnTddsgiyqcmlILNjL
	 dXI9Q/UdW53o0QJ0lW27IrEwmgyjPZV4BgjFbeOnrYmxuEcv79BstygnIijBObv3/I
	 HGSIuunD6KrEmwjvo6nYGSSxgp5oELaVDq9+dHoDK//YQdSLqQXdzZs6XZ59xHCKF2
	 bowWxnEUjs0uMQlpJwXnb89QlCET2ADRmgrUIElGtYd6AJVI8DI5iTKOGKODKl7nqg
	 aogLNm1GAMi6FnBVl7jjEqNQIDk/3SGoUEFMZ+W5stN34yfwwR1rgxTr67f3zyvebU
	 TslJJscbG2DxQ==
Date: Thu, 15 Aug 2024 13:08:03 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBI uses correct VMID after
 changing context
Message-ID: <20240815120803.GA21444@willie-the-truck>
References: <20240814123429.20457-1-will@kernel.org>
 <20240814123429.20457-3-will@kernel.org>
 <86ttfnz0xe.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttfnz0xe.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hey Marc,

Thanks for having a look.

On Wed, Aug 14, 2024 at 02:30:53PM +0100, Marc Zyngier wrote:
> On Wed, 14 Aug 2024 13:34:29 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > When the target context passed to enter_vmid_context() matches the
> > current running context, the function returns early without manipulating
> > the registers of the stage-2 MMU. This can result in a stale VMID due to
> > the lack of an ISB instruction in exit_vmid_context() after writing the
> 
> This refers to the exit_vmid_context() *before* a subsequent
> enter_vmid_context(), right?

Yes!

> > VTTBR when ARM64_WORKAROUND_SPECULATIVE_AT is not enabled.
> 
> I'm not sure I completely get the failure mode, so please bear with me.

Of course, it's confused me a tonne of times and writing the commit
message was a real pain.

> > For example, with pKVM enabled:
> > 
> > 	// Initially running in host context
> > 	enter_vmid_context(guest);
> > 		-> __load_stage2(guest); isb	// Writes VTCR & VTTBR
> > 	exit_vmid_context(guest);
> > 		-> __load_stage2(host);		// Restores VTCR & VTTBR
> > 
> > 	enter_vmid_context(host);
> > 		-> Returns early as we're already in host context
> 
> Is this the code you are referring to?
> 
> 	vcpu = host_ctxt->__hyp_running_vcpu;
> 
> 	[...]
> 
> 	if (vcpu) {
> 		/*
> 		 * We're in guest context. However, for this to work, this needs
> 		 * to be called from within __kvm_vcpu_run(), which ensures that
> 		 * __hyp_running_vcpu is set to the current guest vcpu.
> 		 */
> 		if (mmu == vcpu->arch.hw_mmu || WARN_ON(mmu != host_s2_mmu))
> 			return;
> 
> 		cxt->mmu = vcpu->arch.hw_mmu;
> 	} else {
> 		/* We're in host context. */
> 		if (mmu == host_s2_mmu)
> 			return;
> 
> 		cxt->mmu = host_s2_mmu;
> 	}

Yes, this is the "early return" where we don't bother touching the MMU
because we're already in the correct context.

> So I take it that no vcpu is running at this point, and that we have
> done a vcpu_put().
> 
> Is there an actual path within pKVM that causes a guest TLBI to be
> followed by a host __kvm_tlb_flush_vmid() *without* a CSE? I can't
> convinced myself that such a path exist in the current upstream code
> base.

I think you're right that this can't happen upstream. We see the issue
in Android when reclaiming pages from a guest during teardown. That
amounts to unmapping pages from the guest, poisoning them and mapping
them back into the host. Mapping them into the host can then trigger
table -> block conversion and the associated TLB invalidation wasn't
effective because it was still using the guest VMID.

We can carry this patch in Android if you prefer, but given that
{enter,exit}_vmid_context() are upstream, it would be nice to land the
fix so that we don't run into this bug again in future (it took some
debugging!).

Cheers,

Will
