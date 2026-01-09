Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACC03644AD
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767972597; cv=none; b=RPYzcqBA0s4K64XDf/3oWrC0vwGQgL/hjh9oZOzs/qQZP173j/6k8v/hCCEv70ZRYVAD1HAcS0tXgY2XyWKUE6sYCYW2rTvM4xOqz8NbnYp5LqdhuiaF6ysP6gpeBdor9G+Axq2DGtrlN4QsNURZoB4uWswrQjBkJHatItdXtww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767972597; c=relaxed/simple;
	bh=1c0AQK3xhIu2znG0zekbf9B+11RVbRRJX5tzuxSaaU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3T96QOpVpnQodi3IvqcppN7LuRVvq+rGjlK3SzGHlMFlRHejRhyWuc1O5Xi8bVMkQAbXKVnKOvO14x5UE8F0yMcDXi2HDF0kP+iB2F+uPRaJY5ao5HPHPrg9m06M2InQhlVZ95FnqDXARwK3Pd+k79unynMJ8wf1UwgxgDo8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mLQbC2bK; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mLQbC2bK"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37fd6e91990so41226911fa.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 07:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767972583; x=1768577383; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zPBnskPpYnDrBKJagTKqMfwyx58rk4gEgkXSmBAM15I=;
        b=mLQbC2bKF8bIo6v4W5tVRtM4Ln1vNjtVtE+bixXqHY7BR9A6VSFgNu2TyZfwh7KY8H
         Z81275+711tZHtuBVh/4N3f1jv9sYvBmrNrEtmESrtBhU+XjDqEsTfytoU9kGznHp5od
         FuiaspyBt9qGM/6HTkq4Ar0JThr/Z3TehgfMHkolgFilnqwcEKjs+TFJwlwChDAaxalA
         VIg0RTGt+MNJ5oHGiD4GrJgICQGitHCvd3a1nJTUHlM97S1RpFS9vI7BF6WcvrrHVSLS
         hlR0YOom1Gv07k33wKADZ8XO2arAV7E/wj2rgJM1K+DQBhMwIFMa/lSnGLwABCVrAeBe
         vTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767972583; x=1768577383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPBnskPpYnDrBKJagTKqMfwyx58rk4gEgkXSmBAM15I=;
        b=HSMdC2ShrIb+rP4kSUNggHtftU1SbvoUQwcWEDfAxY32d0JCxBbIOd8a/SAGZUMMiu
         x0iTZHegoN6WiSTZxRs0OyfIhBmio+Lh6n6TKtCkR5vIkHUtTkqIvr7WtTxewfINq+/g
         7RmDyfSRBSJFdiwK4MiIhAENOvL3/r+ZbhJ2d9AyakQIyBjnx2a0EZDdls7koqWeYydx
         kWvUtZjdONW2OKkJybPQkouPhdWi+JP/roJNfa75afWuH+5VEa62RzSe9gXqS+K9QHGa
         2GfhayaIpPFgoxRnibA07IsXwS/WFZdaSy6KDSUSaXJHZSMHFDEbMrGNQxGtH9v2f7YN
         nN0w==
X-Gm-Message-State: AOJu0YzWKQMKA/GUA/WIyrYzSS3n4OY5Qo1B8YjuTMrkAZo2WZr5u3St
	FVKQSgDKVPWrfptSl/XJwbrHWKjDmOK4/sKZpgqbbIR07DrDFCm/CGVEZe+zsGmGJA==
X-Gm-Gg: AY/fxX5EmC6S883TLTmv2bkl6BJC01frGDsXb6dWqqzIDP9doP/zH2kkmyf5qP0ejZX
	PdRYd03jszRJGZB9qHDJfoYnIa7oFQKgJZy+SqeVSgRoKqKuCeZg8q7HctutFRuAbwkmy2R0NEn
	jsjMwCNVeU2DI+tpOMxdpHzcfVmcPcExCVWY9+hXD7u8ZdQ76GDySzCdKcV99OBSLYGLNSQiHBP
	HWSAx0GMKW3oXI+wQdFwxPsWGjTFHNOULsyHyMgB1YJuC7926xIoHlOKL+Nmeu6fgWpQnRLw6JC
	YELJkIerNQyjiIL9ndkox/bUrfBGjnx8DoQcxCjAWiWrP8h40sgfKgqFEvmE5UVinGueZHzexJi
	tZmIN8EXPs0ePG6kFAaPojamkyc0/LvXaWWCoXCDLwUz2cbGJ1W1kW4dGWQaA05URx7vBIXRCHq
	Sy/HC5Akgyp4dPSxC0gAQj+NLJCXX7RiGMFVhW1ZmIY9ReDwgY
X-Google-Smtp-Source: AGHT+IH+8WmaJO0kxfCWQE2RPwoBlC27rMLx+Y0gqPcFuf286nwSQ2Sl5j9cfWQe1J0V1YWWD8+BUw==
X-Received: by 2002:a05:651c:a07:b0:37a:2d8c:c0a8 with SMTP id 38308e7fff4ca-382ff841fd7mr29287061fa.34.1767972582971;
        Fri, 09 Jan 2026 07:29:42 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382ff00220esm16720351fa.24.2026.01.09.07.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 07:29:42 -0800 (PST)
Date: Fri, 9 Jan 2026 15:29:38 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 22/30] KVM: arm64: Return -EFAULT from VCPU_RUN on access
 to a poisoned pte
Message-ID: <vs26wb435olhc4p5b4owotm5zzwr2znwafsgfskkicymj25mbj@nllj54ubgtgl>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-23-will@kernel.org>
 <s4p2ximtz7pki3waw245jtbl5znuco2ijrzsddlmln5x6rgxee@qbek4vpwn3kl>
 <aWEXRgagcULlftqk@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWEXRgagcULlftqk@willie-the-truck>

On Friday 09 Jan 2026 at 14:57:10 (+0000), Will Deacon wrote:
> On Tue, Jan 06, 2026 at 03:54:06PM +0000, Quentin Perret wrote:
> > On Monday 05 Jan 2026 at 15:49:30 (+0000), Will Deacon wrote:
> > > +int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > > +	kvm_pte_t pte;
> > > +	s8 level;
> > > +	u64 ipa;
> > > +	int ret;
> > > +
> > > +	switch (kvm_vcpu_trap_get_class(&hyp_vcpu->vcpu)) {
> > > +	case ESR_ELx_EC_DABT_LOW:
> > > +	case ESR_ELx_EC_IABT_LOW:
> > > +		if (kvm_vcpu_trap_is_translation_fault(&hyp_vcpu->vcpu))
> > > +			break;
> > > +		fallthrough;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ipa = kvm_vcpu_get_fault_ipa(&hyp_vcpu->vcpu);
> > > +	ipa |= kvm_vcpu_get_hfar(&hyp_vcpu->vcpu) & GENMASK(11, 0);
> > 
> > Why is all the above needed? Could we simplify by having the host pass
> > the IPA to the hcall?
> 
> I was just a little nervous about exposing an oracle here if we take the
> gfn as an argument as it would provide the host with a pretty easy
> mechanism to monitor the page access pattern of a guest after the initial
> donation had occurred.

Aha, I see what you mean. I guess if we scope that hcall to only
discover if a gfn is poisoned we're not exposing too much, but
contextualizing the call to the fault also sounds good to me. Perhaps a
small comment would help?

> > > +	guest_lock_component(vm);
> > > +	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> > > +	if (ret)
> > > +		goto unlock;
> > > +
> > > +	if (level != KVM_PGTABLE_LAST_LEVEL) {
> > > +		ret = -EINVAL;
> > > +		goto unlock;
> > > +	}
> > > +
> > > +	ret = guest_pte_is_poisoned(pte);
> > > +unlock:
> > > +	guest_unlock_component(vm);
> > > +	return ret;
> > > +}
> > > +
> > >  int __pkvm_host_share_hyp(u64 pfn)
> > >  {
> > >  	u64 phys = hyp_pfn_to_phys(pfn);
> > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > index d1926cb08c76..14865907610c 100644
> > > --- a/arch/arm64/kvm/pkvm.c
> > > +++ b/arch/arm64/kvm/pkvm.c
> > > @@ -417,10 +417,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > >  			return -EINVAL;
> > >  
> > >  		/*
> > > -		 * We raced with another vCPU.
> > > +		 * We either raced with another vCPU or the guest PTE
> > > +		 * has been poisoned by an erroneous host access.
> > >  		 */
> > > -		if (mapping)
> > > -			return -EAGAIN;
> > > +		if (mapping) {
> > > +			ret = kvm_call_hyp_nvhe(__pkvm_vcpu_in_poison_fault);
> > 
> > It's not too bad, but it's a shame we now issue that every time we have
> > such a race (which is frequent-ish). Could we perhaps only issue it if
> > at least one page has been forcefully reclaimed since boot?
> 
> On the plus side, it avoids an unconditional walk from the fault path
> at EL2 (which is what we have in Android!).
> 
> It's a bit fiddly to implement your idea in the host, since the forceful
> reclaim happens in a really terrible context but I could track it at EL2
> and make __pkvm_vcpu_in_poison_fault() return early instead?

I guess EL2 could easily publish something in the host kvm struct as
well if we really wanted to, it's pinned as shared with EL2 and
accessible from the hyp_vm, which we retrieve in the force reclaim path.

> It's also
> worth bearing in mind that we've already serialised the concurrent fault
> and done a GUP by this point, so performance is somewhat of a lost
> cause...

That is very true, so happy to keep all these micro-optimization for
later.

Thanks,
Quentin
