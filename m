Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991547;
	b=fFOoxpjOvIv1R8JBULdRGpksqn/C3JkYfDTUqKIVV0i4fJ9GCLqyYveE73PLNDtf6dKE
	 px+6sNK0WwusFh2x1anb1A/kazuCtf9Up9WSA8qD4M0eGGGdBr4YNVsN4gVEo47WwVmYf
	 1a8smadN6Wg63oe/B97NbBgRMcfS/sM5hPO8bhHz/40Zt/vp4VToeGHULOwjrk84y+ocV
	 DgQFHZvioHF/spy3uDImd1Ej+CyLeqpb22UeThV46y8JlJGSmb391OyZI3gwvZHBvJjNg
	 mFhRkuxrP+fH56Db9w7uGvLy8Xa02mtxHoN78gfPQQ5ZiGsfXmwhrfdMoZ7wFUJaJwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991547;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hh1wVIGhMUtDEqA1RGRXhLPsq4X7xlZOf5Yg/x7bTfA=;
	b=l6z4xcUeeIqwDBSNLsJeTNWGQL+C2Ls13UbRnPQbugAepOQDrC1S7lhsn253ozXQGuu3
	 ffiAs613WNeYAipgNwMudEmmzJhUyeLu+KKO3mDaiT40qIqpd4Wa4TRbLzuVlh0We2rMH
	 cVZ7lOn9jUueepSWzJpqI57UcYCdW0AgiEb8p28O8bK1+Y2MX9xo/K2jw7I3/Xu8Qkyv5
	 GwLxILhZsB/2H6MyiBnEhVBJbFF9Lc0FhP3ZkNGL/b4kAPTGewEzUWumj1XvFfpBjxK9h
	 1ZYkHQmqOL8WF4PeAsuN0vpdVL61C14X6P+c+KT8rWRdrLFukYQgEibbRRs2laL6BrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRWqtfp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53638606A326;
	Fri,  6 Nov 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRWqtfp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC261F0089F;
	Fri,  6 Nov 2026 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991547;
	bh=hh1wVIGhMUtDEqA1RGRXhLPsq4X7xlZOf5Yg/x7bTfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lRWqtfp+1D498aBxxNnJJyG9ECqg+f/OfZ3IbBN3x25p6pxG/EdBJjp5O3EH94agq
	 G4S0/LF+z79xECrP3fyX7gwClgYK0RzJw9f9N3wi0e0o5s3jvO7ePlzSAmsak8VDRD
	 cUAdhEjJNEeQNF9q55IQx6OW5BBMj3KUGC7Vi2Sms6yntczCqpkTI4QcgPvgc0I1bk
	 zsTMLn/IvdjcnbQ3thc+emgG+L4sMVxWznkDRqMTFCVLh+O0aQo9ygdXuBfAX5QygY
	 XjXntwjXrnaRLax/wGU7yepiBQjqQ+XjzW3GXqjj4bp31h0zvRrYlfnNosyp/tcgJt
	 Y06IpJ3ja+I/A==
Date: Fri, 6 Nov 2026 10:59:05 -0800
From: Oliver Upton <oupton@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Allocate a protected vCPU's SVE state at
 EL2
Message-ID: <au4jeecA_FIk_yPT@kernel.org>
References: <20261105130456.1617185-1-fuad.tabba@linux.dev>
 <20261105130456.1617185-3-fuad.tabba@linux.dev>
 <au4TsO50x7BcFYpi@google.com>
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
In-Reply-To: <au4TsO50x7BcFYpi@google.com>

On Fri, Nov 06, 2026 at 05:51:44PM +0000, Vincent Donnefort wrote:
> > @@ -1243,6 +1253,9 @@ int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  			    PSCI_0_2_AFFINITY_LEVEL_ON) != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
> >  		return -ECANCELED;
> >  
> > +	if (vcpu_has_sve(&hyp_vcpu->vcpu))
> > +		memset(hyp_vcpu->vcpu.arch.sve_state, 0, vcpu_sve_state_size(&hyp_vcpu->vcpu));
> > +
> 
> Why wasn't this line around before?

Prior to this series SVE was only supported in non-protected guests, so
the host was responsible for resetting SVE state.

Now that we have pVM support we need to reset state for protected
vCPUs.

Thanks,
Oliver

> >  	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
> >  	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 32e82653ebf7e..06ea91415ad8b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -570,6 +570,7 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
> >  	RESET_UNKNOWN(MAIR_EL1),
> >  	RESET_ZERO(AMAIR_EL1),
> >  	RESET_ZERO(MDSCR_EL1),
> > +	RESET_ZERO(ZCR_EL1),
> >  	RESET_ZERO(CNTV_CTL_EL0),
> >  	RESET_UNKNOWN(TTBR0_EL1),
> >  	RESET_UNKNOWN(TTBR1_EL1),
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 10eb7249aa9e8..aaaa1b8634ba4 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -52,6 +52,8 @@ int __init kvm_arm_init_sve(void)
> >  		if (WARN_ON(kvm_sve_max_vl > VL_ARCH_MAX))
> >  			kvm_sve_max_vl = VL_ARCH_MAX;
> >  
> > +		kvm_nvhe_sym(kvm_sve_max_vl) = kvm_sve_max_vl;
> > +
> >  		/*
> >  		 * Don't even try to make use of vector lengths that
> >  		 * aren't available on all CPUs, for now:
> > -- 
> > 2.47.3
> > 
> 
> -- 
> Vincent
