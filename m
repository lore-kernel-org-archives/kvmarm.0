Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4913958E
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 20:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297996; cv=none; b=g81dPsQ1N/eKQ9zx8KqU/knDJuROV3FjrSS6uKSTQI3ssBDd0R8uG/UvOQzmrUYRoZrz0YFwxGkMJFHjrCcNCTy5yS4XlVTGJCF3q5ZHcddf4wS2VrvAgiB82IvLIZoUkGGD77mR59XzhfHuGQf2/HkiL2Jrofy40IBFFPq8e+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297996; c=relaxed/simple;
	bh=PUiKjYdx/ijwQUNZoKyA1Jd1EVBLjLbsiH4wIBNu4ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atF1CMjQGP6FRwO237wa17PXjyY4XPiRFH95ThXPKQfMq1vB9P+zCQR4BafMWlQbsjKSnwv55j+cxb052lFMvQapV1LISsNyyP9rmlSJXLJSb5LPYtYNxVs6K1Q6W1vOOkHrS0/G5upOlWYy/HdXutPNDKLr3+OBBO89wcjXDeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B3Vgsmvr; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B3Vgsmvr"
Date: Tue, 16 Apr 2024 20:06:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713297991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VSWPho2kknmGfgIdFVf+iWGjKotisbb0h2HUCV7V9K8=;
	b=B3VgsmvrFpWAjoUVeUtpn8K+mXtgPiZF6T3anGdR8d0uD1r54eKA2ZgBtMPwF4zSyI4kkj
	96MEqmfFQ1hRkQZXv0r+fON7NNgzfnWpmqaXyer9CFSpkdk1wWAZ7SFqVxbr5tqiq92FQc
	YU8OGIo5wgGNrzVM4G+T0AB76Loc23A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 04/15] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Message-ID: <Zh7aQm-TpDb6eBsp@linux.dev>
References: <20240321155356.3236459-1-maz@kernel.org>
 <20240321155356.3236459-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321155356.3236459-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 21, 2024 at 03:53:45PM +0000, Marc Zyngier wrote:
> It has become obvious that HCR_EL2.NV serves the exact same use
> as VCPU_HYP_CONTEXT, only in an architectural way. So just drop
> the flag for good.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 --
>  arch/arm64/kvm/hyp/vhe/switch.c   | 7 +------
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 839c76529bb2..3f1c3c91e5c2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -816,8 +816,6 @@ struct kvm_vcpu_arch {
>  #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
>  /* Save TRBE context if active  */
>  #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
> -/* vcpu running in HYP context */
> -#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
>  
>  /* SVE enabled for host EL0 */
>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 1581df6aec87..58415783fd53 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -197,7 +197,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * If we were in HYP context on entry, adjust the PSTATE view
>  	 * so that the usual helpers work correctly.
>  	 */
> -	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
> +	if (unlikely(read_sysreg(hcr_el2) & HCR_NV)) {

Can this be additionally predicated on vcpu_has_nv() so we condition on
the NV cpucap and avoid the sysreg read on non-nesting hardware?

-- 
Thanks,
Oliver
