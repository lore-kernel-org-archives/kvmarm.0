Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522472C0F81
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758320881; cv=none; b=FwpRJzonEve0bH14O2W/qGPqiececxPkZ8xuu1vpcZIlUxWkc1ffidoVQybzWkoH+7d6SIXxTq7s4ioRv6VVkg2f8bAamTtrvNFEw0l3zEhw3uVeLKq52kndRmcSsCjEyqT+kXxbpobnn8cnN+/pkDUXXwoJGYW//Jx80OsvJ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758320881; c=relaxed/simple;
	bh=8UcB0oi/7oRgEcV823QkdAHAFr875yhnEdcWdcjNvI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hevWoLvWNxopH676HDT+QquS0rSLJwK2dxCIUq+C0bTQ64l8AIzQkfRs0oRnu8ypNVg7LA6dhU7LwEt0kp5Z/0q60XMaDYueXpYh0FXtTJP4SMFWHWvYZoNmi5yxBw7d4aNaX1Qa9D1vaZH9glne6YT2iOvWWEVi26X3TORRjzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wnp+UmoB; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wnp+UmoB"
Date: Fri, 19 Sep 2025 15:27:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758320877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPVacn2PmZ4z0RLVYVdIubbfP3TwF2TL+jrZNbrpOZY=;
	b=wnp+UmoBpZAXPiLW7xIF+MCTKCUgSQe49oVMjUVwo32FGzBFzYThwgln/M/PavQ5rmsWHK
	keJSMnkJTjwrtOWXId+jlkZhJivC4jle8gpL8K8e9N/ButtDNsdoPY87wCYwhUerRos2zj
	qP8Yu+AhdtLPbcQIWoumXqdkKDX2UNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 10/16] KVM: arm64: Allow use of S1 PTW for non-NV vcpus
Message-ID: <aM3Y6DcAqhGJJer7@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-11-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:45PM +0100, Marc Zyngier wrote:
> As we are about to use the S1 PTW in non-NV contexts, we must make
> sure that we don't evaluate the EL2 state when dealing with the EL1&0
> translation regime.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 1230907d0aa0a..4f6686f59d1c4 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -108,8 +108,9 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	case TR_EL20:
>  		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
>  	case TR_EL10:
> -		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
> -			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE);
> +		return ((!vcpu_has_nv(vcpu) ||
> +			 (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En)) &&
> +			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE));

Hmm, dealing with the effectiveness of bits gated by HCRX_EL2.xEN is a
pain. Rather than open-coding this everywhere:

static bool __effective_tcr2_bit(struct kvm_vcpu *vcpu, enum trans_regime regime,
				 unsigned int idx)
{
	bool bit;

	if (tr != TR_EL10)
		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & BIT(idx);

	bit = __vcpu_read_sys_reg(vcpu, TCR2_EL1) & BIT(idx);
	if (vcpu_has_nv(vcpu))
		bit &= (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En);

	return bit;
}

static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
{
	return __effective_tcr2_bit(vcpu, regime, TCR2_EL1_PIE_SHIFT);
}

static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
{
	if (!kvm_has_s1poe(vcpu->kvm)) {
		wi->poe = wi->e0poe = false;
		return;
	}

	wi->poe = __effective_tcr2_bit(vcpu, wi->regime, TCR2_EL1_POE_SHIFT);
	if (wi->regime != TR_EL2)
		wi->poe = __effective_tcr2_bit(vcpu, wi->regime, TCR2_EL1_E0POE_SHIFT);
}

Thoughts?

Thanks,
Oliver
