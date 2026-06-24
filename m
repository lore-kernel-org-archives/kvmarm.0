Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CE233949;
	Wed, 24 Jun 2026 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293986; cv=none; b=ZblziJvqElOPic3FpB1AKfcPcPhOR4o8fWybc90VWbBB7WuQs95+pwUwzzzuOfOI3ww35U9PAIOKEVg4HzDRI/tzWm9qKiUwQTIGjNkYczN00YzmwQmuBocLSwbwgOluuV0Fveggor/jGTt7lPPyt+UKl8rO5QwPotruGUGVWrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293986; c=relaxed/simple;
	bh=am1i+epRIzitQwPkHGK9mN3QvZAj2VLGfsT0frDTPXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMV4R+gd99gaTQzDXExQx7lI1809DecHqU/6xf/Oz+GN/ktA+HxaBog7PzFo1E7wTtJPUTtcEGuG0ZTiVBptG7/kyJ9JbtuMPpbIRHcmIYNv78cIVrtevpQoStAddRE+DhuXGHTxdfKNHYG7pG1M+Aa2Jib5Z7+3fIlkffvt060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Is1EtY55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Is1EtY55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F8B1F000E9;
	Wed, 24 Jun 2026 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782293984;
	bh=4kY3FIfzNG6LAUaWpU5j0u7zvkjhWUgfSv2KxjICn4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Is1EtY551WP3Ug2ISOba4b+0Dgymoc71YI48RJ+JheciEdcc8WkRUzwWW/Ex3s+d6
	 aSYvOQmVzIyPpereAu8/k7jgTnU3FjJQ82Va4crwOhvL71OBApWSZnctbHi/AL+SRb
	 qIDYKy5gooQohMWXEjIfer7KOin/onrII5McX+ZyaZDTf8HQt7aBWTqlE0vdm5C8UR
	 n5PEpdyvOb+vjY8mELzC9ofem/2CNUcZS6HpGZGzQV/6C1AIf7gLOu6j5nlLEqnrp8
	 n3dcXiVHitfG1z6COUaH1Qi6HfyxOda/87I1CW8lZ7EDdemo+nG8pZiRD4RCQkeUYp
	 14JoCEIT514mA==
Date: Wed, 24 Jun 2026 02:39:43 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: nv: Check RW permissions for insn abort due
 to S1PTW
Message-ID: <ajul3_7XpTeDn57I@kernel.org>
References: <20260623211310.1529760-1-oupton@kernel.org>
 <20260623213225.A89CF1F000E9@smtp.kernel.org>
 <ajsf1v4X5sJk_Dv5@kernel.org>
 <86mrwkqqix.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mrwkqqix.wl-maz@kernel.org>

On Wed, Jun 24, 2026 at 09:41:26AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 5bf3d7e1d92c..d5c61e0027c8 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -479,21 +479,12 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
> >  
> >  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> >  {
> > -	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > -		/*
> > -		 * Only a permission fault on a S1PTW should be
> > -		 * considered as a write. Otherwise, page tables baked
> > -		 * in a read-only memslot will result in an exception
> > -		 * being delivered in the guest.
> > -		 *
> > -		 * The drawback is that we end-up faulting twice if the
> > -		 * guest is using any of HW AF/DB: a translation fault
> > -		 * to map the page containing the PT (read only at
> > -		 * first), then a permission fault to allow the flags
> > -		 * to be set.
> > -		 */
> > -		return kvm_vcpu_trap_is_permission_fault(vcpu);
> > -	}
> > +	/*
> > +	 * The architecture sucks; assume that the S1PTW fetched for write if
> > +	 * HA is enabled at stage-1.
> > +	 */
> > +	if (kvm_vcpu_abt_iss1tw(vcpu))
> > +		return effective_tcr_ha(vcpu);
> 
> OK, so you're trading the implicit state machine (translation fault ->
> RO, permission fault -> RW) for a direct TCR.HA lookup, because the
> only reason you'd get a S1PTW fault for write is if you were updating
> the descriptor. This is cute, and I wish I had thought of that, as it
> saves us a round trip.
> 
> But why can't that happen with HD? Surely this results in a similar
> fault, and I think we should also evaluate that bit.

The effective value of both HAFT and HD is 0 if TCR_ELx.HA is 0. So
evaluating HA covers them all :)

Thanks,
Oliver
