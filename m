Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53452D94A5
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 07:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763622533; cv=none; b=mGcBtO9L7QwwZNmOXwBbwaJhB6oanO3ro1OKdvRHLazhsw4ynNxwJqFw7GZtxqiDcv3W8nf7BqnNNsJkc7y93SMc2PpKwOAImMR01+mapaDhZ7dp4jHxogsQYcUOFQ1BpQPBcDmyvevmD8d37rB1hpA/yVkPpois5iXmej7mv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763622533; c=relaxed/simple;
	bh=zH15zyMIwUMOqHAJyCLXPlWCPX2LpqzF9ocFnzF8Jsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loj0I7LlBZeV9jbR6gdiOmSG4XsiFjRnGIpDyRf4TSBvSZRSGlGysqnxVF+1teL70WAvhHBqW9dq/lsMXCfSKPtJkeektvJ1Miv/5dZxr6N/8g+O+zIZo/ScIQJUklhea73s54az7PIeztcoEPqK6JhlbFbTe5QuiDCn6sdJUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qo1P8sxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qo1P8sxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CE7C4CEF1;
	Thu, 20 Nov 2025 07:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763622533;
	bh=zH15zyMIwUMOqHAJyCLXPlWCPX2LpqzF9ocFnzF8Jsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qo1P8sxi/N0H14Z3Q0Pj9cfyd4rsHxCxK2iLxCgESsIu43rMRvAtaHU/OZZHWnUM0
	 zfhx6n/NmQ5FEn8VrVTQYTuCKsjRy4+CiiDkLMEewP1CGn3Dwel2qU1NyOj56ScRi8
	 jKbL2EJkL/gofJMl6MmCJg05xPqFAeCeXMiiGggbtXgF0z9Ej+aCCZiIld44sjuJys
	 VDYkQwW2L7kTZrQm5h5LCucSPoXT1iNva91vH0eNRTt6A4eOcybtGydZlR/d43T973
	 W8oiYq3OhZKJzrxzJcGUyN53QmhSRKPoXaoaKO1BmueCYrfyBiuoBhFo7GqENmNuY0
	 giFXJyg4b2WNg==
Date: Thu, 20 Nov 2025 00:08:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Drop useless __GFP_HIGHMEM from kvm
 struct allocation
Message-ID: <20251120070848.GA1879143@ax162>
References: <20251119093822.2513142-1-oupton@kernel.org>
 <20251119093822.2513142-2-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119093822.2513142-2-oupton@kernel.org>

On Wed, Nov 19, 2025 at 01:38:21AM -0800, Oliver Upton wrote:
> A recent change on the receiving end of vmalloc() started warning about
> unsupported GFP flags passed by the caller. Nathan reports that this
> warning fires in kvm_arch_alloc_vm(), owing to the fact that KVM is
> passing a meaningless __GFP_HIGHMEM.
> 
> Do as the warning says and fix the code.
> 
> Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/kvmarm/20251118224448.GA998046@ax162/
> Signed-off-by: Oliver Upton <oupton@kernel.org>

Tested-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!

> ---
>  arch/arm64/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 870953b4a8a7..e791fa52f874 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -440,7 +440,7 @@ struct kvm *kvm_arch_alloc_vm(void)
>  	if (!has_vhe())
>  		return kzalloc(sz, GFP_KERNEL_ACCOUNT);
>  
> -	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
> +	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  }
>  
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> -- 
> 2.47.3
> 
