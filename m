Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593865;
	b=Yx+5oDu+e2o1A6irI162NxBWlJE8bZ2a39DkWNtdl3w9slrdD//6p28cjKecxU222OG/
	 7y2XBoHZZVkxoX9gqAgzrCyNF8Rcf0+cN44abSTpSkNWaDJzuphQd5oQTqfth2QyFJrO4
	 F1eGcqJIhNvLVMTSm9mDOv1pXNKejZb9GPX85U+V/oQjqWCqyT55VTX5oOZyNByxpk/7M
	 vbyGcyhlGAX7PE5131xAYyfV1du3wZCPAyYc5G+ZTGsIHI7RPA6qEP531Mtq+ev49P3VR
	 gL9ZfK/homSnRrLE8XKv8+M0wp2YyvRE1gWcnPGYIKL/sUjv4Ex74GXQgTFzD9jZJ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593865;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/1qjbzhxlB1Ss6WAwvDVAp8mW+VQV6QUtd1PRvHad3I=;
	b=eoZEH/5OxTo50Cu2Xx++xtRgdxchVnWfRDyBMkEOSNoVjVpJ2lp1Vgdaq81hVQVuchqf
	 Ybe3ojdvcs9NhEak3cpwd6IH50OW4gKYPsEZXyXLgZJBMYO8GZbU0Xdy3dL5DoCzbmrmc
	 dOvrbY1Q1eYIoHdmsv4n5L3DE5g+cGKvOSIxrKpJ7tH6e/t/8ddZxdakWD41jkUP/1nKg
	 ZGgQ8rgh6TfGesbIhybU53shAt+AWyFHz1q0gjy2j59Oqs8DxKHK3W/7VfNuzLyUWVz6m
	 koEX6RC+nEk/FjTIUwlPZM/BHYhzd8urWnFC6bYwBP2VycpAkPdwA9FnNwSbQNDzKTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6wllsET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7717F606A31E;
	Wed, 25 Nov 2026 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6wllsET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FC21F000D0;
	Wed, 25 Nov 2026 08:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593864;
	bh=/1qjbzhxlB1Ss6WAwvDVAp8mW+VQV6QUtd1PRvHad3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6wllsETRQP8h4zX2i/eR/EItnbHEhz7gMP/JF2w0ohJu45ENWnKOJy1CSZpRLI5t
	 ooBoLu/B95QAx++71XcXUMXyQiiZYtvSxe+m/uMLAm7pMxRJ4VHY+1YWEeRqjbXcQK
	 1QKj2ynw/a9vjqPE4zX2KzqF2RKR8u/ei5RKJgpIBjH0cCCh2rENOAO/tgjCV6lo5g
	 k5y3NSh1F1ovlc2NH2w8sELuot0zH7nHNkLj/QSYlSAFQyKqv4oqGbfhM0vLxIBT2Y
	 8o/4cArVVES1311yPmDhFPgSEcNBqmaAX5KIIUjXKUouK+drghxHfAJ/RueMoiHtjJ
	 QkWsVUP2ShFFA==
Date: Wed, 25 Nov 2026 00:04:23 -0800
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 6/8] KVM: arm64: nv: Don't deliver a pending SError to
 the wrong guest
Message-ID: <awaWhy3IywYrP2JZ@kernel.org>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
 <sashiko-outbox-232776@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-232776@kernel.org>

On Wed, Nov 25, 2026 at 07:24:38AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] KVM: arm64: nv: sleeping in atomic context via
>   kvm_nested_flush_hwstate()
> --
> 
> commit 81f527c7f211ae919b4cadce520f83a546cfd38d
> Author: Dan Carpenter <dan@pereq.eu>
> 
> KVM: arm64: nv: Don't deliver a pending SError to the wrong guest
> 
> This commit stashes a pending HCR_EL2.VSE bit into NESTED_SERROR_PENDING
> when switching between L1 and L2 so that kvm_nested_flush_hwstate()
> re-evaluates SError routing in the new context.
> 
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > index 39136a89d74bb..cccaf02610e87 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2792,6 +2792,18 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
> >  	return spsr;
> >  }
> >  
> > +/*
> > + * HCR_EL2.VSE was set for the context we are leaving.  Store the SError
> > + * instead, so that kvm_nested_flush_hwstate() routes it in the new context.
> > + */
> > +static void kvm_nested_stash_serror(struct kvm_vcpu *vcpu)
> > +{
> > +	if (*vcpu_hcr(vcpu) & HCR_EL2_VSE) {
> > +		*vcpu_hcr(vcpu) &= ~HCR_EL2_VSE;
> > +		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
> > +	}
> > +}
> > +
> >  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> >  {
> >  	u64 spsr, elr, esr;
> > @@ -2823,6 +2835,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> >  	preempt_disable();
> >  	vcpu_set_flag(vcpu, IN_NESTED_ERET);
> >  	kvm_arch_vcpu_put(vcpu);
> > +	kvm_nested_stash_serror(vcpu);
> 
> [Severity: High]
> Can stashing NESTED_SERROR_PENDING here cause sleeping in atomic context
> on the next guest entry when a virtual PMU counter is active?
> 
> When L1 has a masked pending SError in HCR_EL2_VSE with HCR_EL2.AMO set
> and executes ERET into L2, setting NESTED_SERROR_PENDING causes the next
> iteration of kvm_arch_vcpu_ioctl_run() to re-inject the SError back to
> vEL2 while preemption is disabled:
> 
>   kvm_arch_vcpu_ioctl_run()
>     preempt_disable()
>     kvm_nested_flush_hwstate()
>       kvm_inject_serror_esr()
>         kvm_inject_nested_serror()
>           kvm_inject_nested()
>             preempt_disable()
>             ...
>             preempt_enable()
>             kvm_pmu_nested_transition()
>               kvm_pmu_create_perf_event()

The PMU crap should probably go in a vCPU request to avoid this.

Thanks,
Oliver
