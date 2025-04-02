Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25F136E37
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611889; cv=none; b=D3VvQloVz5kgyACP8XON0rW5ZP76Ih79jSp6jv7B8OTIZeZ1B58FP5uXlvzQ2BVorM3RO81IbCq0UQ+/o/FaSqdasSHPkJ8kH9SVqSrzkm68scXfnxOhv3RC2VjTUya+a4F6fCLDPyEWPJsQ3dmmB/6hNrYHIEE3zjio1Rt6w8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611889; c=relaxed/simple;
	bh=9HEorcM4vH9n403Q0NfWaZYVLg+0TocsBIeigxIJWSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3SOLPBIT7UM6CZ2Pd7KUhcJ48GaJXcLtWyIX9InH5/SMn7WNiN2T+/+J0mxYrgZXJ7j1FKnGdWSX5naYIknYaeOkeUNXwXv3NxGQUqYUBYcw4lJN20fq0+tE6RjPyzU2ANOsr+BmK+c7gMrdMwa4gsHDUCTvcjQOL5dBU0T04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qjyoqo6K; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qjyoqo6K"
Date: Wed, 2 Apr 2025 09:37:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743611885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2M2VtZdDIMEUK0qrE2xupckXlyKB8wvehDrTZjEUW2M=;
	b=qjyoqo6KKjeDYK1QoDi+Y3g8O4uK1qi8ORleL0pGbvYd5zwKf0G60RuLBctV+SAiSw6OTK
	s6g5NwslIhZZLzt4yPaQpnL+HR03+XZU38ToaAlj3JHBtbxcQBlwy89FntImEmr2tN13CX
	mKdSxgnJp5AAoUA/bcpzKXsrpviqoFo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Don't translate FAR if invalid/unsafe
Message-ID: <Z-1n5V5wqDTdXDq-@linux.dev>
References: <20250401224234.2906739-1-oliver.upton@linux.dev>
 <20250401224234.2906739-4-oliver.upton@linux.dev>
 <87friqzrfz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87friqzrfz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Apr 02, 2025 at 01:19:28PM +0100, Marc Zyngier wrote:
> On Tue, 01 Apr 2025 23:42:34 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >  static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
> >  {
> > -	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_EL2_FIPA) << 8;
> > +	u64 hpfar = vcpu->arch.fault.hpfar_el2;
> > +
> > +	if (unlikely(!(hpfar & HPFAR_EL2_NS)))
> > +		return INVALID_GPA;
> 
> Eh, why not ;-)
> 
> > +
> > +	return ((phys_addr_t)hpfar & HPFAR_EL2_FIPA) << 8;
> 
> nit: as you are reworking this area, I'd rather see
> 
> 	return FIELD_GET(HPFAR_EL2_FIPA, hpfar) << 12;
> 
> as it nicely shows what the FIPA field represents, instead of the
> odd-looking 8 here. The compiler will nicely sort it out anyway.
> 
> Same thing in handle_host_mem_abort(), both of which could be fixed in
> the previous patch.

Agreed, this reads better.

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 2feb6c6b63af..754f2fe0cc67 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1794,9 +1794,28 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  	gfn_t gfn;
> >  	int ret, idx;
> >  
> > +	/* Synchronous External Abort? */
> > +	if (kvm_vcpu_abt_issea(vcpu)) {
> > +		/*
> > +		 * For RAS the host kernel may handle this abort.
> > +		 * There is no need to pass the error into the guest.
> > +		 */
> > +		if (kvm_handle_guest_sea())
> > +			kvm_inject_vabt(vcpu);
> > +
> > +		return 1;
> > +	}
> > +
> 
> Maybe add a line to the commit message to indicate that you're moving
> this around?

I had this:

  Finally, fix up the rest of the abort path by checking for SEAs early
  and bugging the VM if we get further along with an UNKNOWN fault IPA.

But I'm happy to expand a bit to make that more clear.

> >  	esr = kvm_vcpu_get_esr(vcpu);
> >  
> > +	/*
> > +	 * The fault IPA should be reliable at this point as we're not dealing
> > +	 * with an SEA.
> > +	 */
> >  	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> > +	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
> > +		return -EFAULT;
> > +
> 
> I think you're missing something similar in handle_host_mem_abort(),
> which will take fault.hpfar_el2 at face value even when it is unsafe
> to translate. At least testing for HPFAR_EL2_NS seems necessary.

Good point, I'll respin in a moment.

Thanks for having a look!

Best,
Oliver
