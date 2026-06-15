Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162322BD59C;
	Mon, 15 Jun 2026 04:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781498803; cv=none; b=EmHxsNmeZ9NNQiKl+yhzg4AdUtu6CXXWzypJLTjhIdtEshOV2c9I42UmpZTOMea7FNky2RDP7c3+6VMDSnrJLgbSYdFYI6uENeHGdC4TxOs2JlA/wEMzAPnfBDbI9MqK/46wdb7+k/ifv/l/f7FBk0eGfqEcqsy7qoXEsGPNwAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781498803; c=relaxed/simple;
	bh=pZ4Lj9sxuu4fCJZEfzfOLVeCOmNrnV+QzCfqdGQaGSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeGnWH106b5qqoRg7C2g8snVoLgwlVxGrlx6ualDWgcOdsd775R1sOZef+EyRuVgIY3wywfhEy/svFGGshnembr1B3HC94hFU7wwIvJd4+ACHeeJ8Ih0DfKz6s0ASRwm74rQG9wRVwMVLY2M/UGsuNqyj+qnfTaZ5yYGKIXeT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tm6bW9MN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tm6bW9MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4A31F000E9;
	Mon, 15 Jun 2026 04:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781498801;
	bh=Dj09pM2es9y/CXI2hKjzMBH0rjHFqzTBpycpBpv3EAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tm6bW9MN12hKKUYvKu8jHWW6gqS/Ud6gT0gblUQ5hGl/sAOSe5XJYkIXPtSiPyzrT
	 qJjTl3M3P/e3aY9Sg2yltv2evc99gKa+faYGY2vSO4BngEhnQvklj8p/rQD/e98tQS
	 rTFA8MYKtmEkuSnrmnvYddEBV5Vd5LBhN9dMgsyEsSkR9NajqSngLTBeOjfU07Wq/S
	 d4eOyIM6J+uU+4rBKZ0rF8UkmGS9Fs6ZTeTKkQl1ecSWZhGMhhI0xv9j8DFIWg+b6z
	 978FqYKWTvwL5mCv1bqpUJ2XTA4fl+mkWb9jqj6QzaIn9Y4D92KWEnZd+PTEfM/lcL
	 hItZNDMG0cwLQ==
Date: Sun, 14 Jun 2026 21:46:40 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6/7] KVM: arm64: Set IL for nested SError injection
Message-ID: <ai-DsLydd7ry0RpS@kernel.org>
References: <20260614163336.3490925-7-tabba@google.com>
 <20260614164416.D37E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614164416.D37E61F000E9@smtp.kernel.org>

On Sun, Jun 14, 2026 at 04:44:16PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] The constructed SError syndrome (ESR) is silently dropped during nested EL2 exception injection because `ESR_EL2` is never updated.
> - [High] When SCTLR2_EL1_EASE routes a Synchronous External abort to an SError, the ESR injected has the wrong EC (IABT/DABT instead of SERROR) and an incorrect ISS format.
> --
> 
> commit 09fd06d56ab3236a0e7af03e0d026ed6725ad6d6
> Author: Fuad Tabba <tabba@google.com>
> 
> KVM: arm64: Set IL for nested SError injection
> 
> This patch modifies the emulated SError injection to unconditionally
> set the IL (Instruction Length) bit in the generated ESR, as mandated
> by the architecture.
> 
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > index 4b39363cf8911..4262d4c17a877 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2938,6 +2938,6 @@ int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
> >  	 * vSError injection. Manually populate EC for an emulated SError
> >  	 * exception.
> >  	 */
> > -	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> > +	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
> >  	return kvm_inject_nested(vcpu, esr, except_type_serror);
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does the carefully constructed
> esr value actually get written to the guest's ESR_EL2?
> 
> Looking at kvm_inject_nested(), it passes the esr_el2 argument down:
> 
> kvm_inject_nested(vcpu, esr_el2, type) {
>     ...
>     kvm_inject_el2_exception(vcpu, esr_el2, type);
>     ...
> }
> 
> However, in kvm_inject_el2_exception():
> 
> static void kvm_inject_el2_exception(...) {
>     ...
>     switch (type) {
>     ...
>     case except_type_serror:
>         kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
>         break;
>     ...
> }
> 
> Since except_type_serror only pends the exception and doesn't explicitly
> write the esr_el2 argument into ESR_EL2 (unlike except_type_sync), does the
> nested hypervisor observe a stale or uninitialized syndrome when it takes
> the SError?

Oops, this definitely needs fixing :) OTOH...

> [Severity: High]
> This is a pre-existing issue, but since this code deals with fixing SError
> syndromes, what happens when SCTLR2_ELx.EASE is enabled and a Synchronous
> External abort is routed to an SError?
> 
> Looking at kvm_inject_nested_sea() in the same file:
> 
> int kvm_inject_nested_sea(struct kvm_vcpu *vcpu) {
>     ...
>     u64 esr = FIELD_PREP(ESR_ELx_EC_MASK,
>                          iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
>     ...
>     if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
>         return kvm_inject_nested(vcpu, esr, except_type_serror);
>     ...
> }
> 
> Does this result in an SError being injected with a Data/Instruction Abort
> EC? According to the ARM Architecture Reference Manual (D8.2.5), shouldn't
> an SError always have its ESR_ELx.EC field set to 0b101111 (SError)?
> 
> A similar pattern appears in inject_abt64() for EL1, where a DABT/IABT
> syndrome is constructed and actively written to exception_esr_elx(vcpu)
> even though an SError exception was pended. Would this incorrect EC format
> confuse the guest's exception handlers?

This is confidently wrong, down to citations of the Arm ARM.

While I couldn't find an explicit rule to cite in my cursory search of
the manual, the definition of the bit describes this as "External Abort
to SError Vector". On top of that, AArch64.DataAbort() just changes the
vector offset (but not the EC) based on EASE.

My understanding is that the exception syndrome of an external abort is
preserved despite taking the SError vector.

Thanks,
Oliver
