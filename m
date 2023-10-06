Received: from out-208.mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC36F9DF
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 09:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iX+VyBhv"
Date: Fri, 6 Oct 2023 09:41:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696585297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dmT/ZnCt0gWb0fl3TeqqXjxc6m6Vc6HmmLBlt4vvIbE=;
	b=iX+VyBhv3KtGoceLedWKPsvSZMLH2vfYSHoVVYxCkvTmGRb4lAmrEveLnjzJtWI5txw2rh
	cPbuA0drLlTzACHSs988kg8VRxcU1bm2YU30hIJWFJ7PWPESxgZgxKKjoqyJTlEoakrMWB
	8NOm83ECTrJ2GJ0WqIsFEIivE6D3Cxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't zero VTTBR in
 __tlb_switch_to_host()
Message-ID: <ZR_WTS-bqrd3L5j2@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
 <20231006093600.1250986-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006093600.1250986-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 06, 2023 at 09:35:58AM +0000, Oliver Upton wrote:
> HCR_EL2.TGE=0 is sufficient to disable stage-2 translation, so there's

TGE=1, obviously :)

> no need to explicitly zero VTTBR_EL2. Note that this is exactly what we
> do on the guest exit path in __kvm_vcpu_run_vhe() already.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/vhe/tlb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index 46bd43f61d76..f3f2e142e4f4 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -66,7 +66,6 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
>  	 * We're done with the TLB operation, let's restore the host's
>  	 * view of HCR_EL2.
>  	 */
> -	write_sysreg(0, vttbr_el2);
>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>  	isb();
>  
> -- 
> 2.42.0.609.gbb76f46606-goog
> 

-- 
Thanks,
Oliver
