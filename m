Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCE4CA26B
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658626; cv=none; b=UOnuy0zeGAGRqVHTvpOIITraJsQiNPcFWvCPs4Nja7yDvrUp2tE18OHayB5VaRpb6LPyGDuYTa3aHZOyApKcjyL8NbDCC0KYFgL+R3KUjf8aW0z9hxwkJT27391dZ1SUFc3gOqqC5VJg2OCEHLtnW5pmJzo8UCyP07G+WGd+tgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658626; c=relaxed/simple;
	bh=7b39oZ1rabssA2077RWT7WLd87NqooKg4iMrl/4iZOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohYD7T6fRVGgqEOkBgJPJ7Y/gcSwvjnvNfjjNUtVRLJiMI/jvnunQMvvUZFz1cwt/f2uuNeaw7M8Nyq0PWQ2kvCjS3fchKf7KKbb2WvE/m+kBLHHpEzwNthemDq/Cy5fw1dwPhCfuESNVQWWzyc+lzJe4JdzWHBlaLrqxMh3MrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnOLGxRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnOLGxRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE861F00893;
	Fri,  5 Jun 2026 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780658625;
	bh=ibrDkw4cplAxEvZj2EPWnYhxrc+tDX6PdpXQVAA6Xj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nnOLGxRa1wovQ0EhFRYD9rILOeVIOgDCNz1pDQBWiyUv9YQf4O/m1N/AqS3j5OjNs
	 6tu+xfb7PtLKhiswywQIvQlu7stn6CpQ5vsc8qbtTngrIteqHgc3cdfx9e2N1Tr0iD
	 d1AGbeAG6pX+bJ7lNE4+NF0hE3WRR5Czb13ku0a5cLi5zJVAiubA2l4HYw9i0IDD/u
	 R+Nh/iK5epaZ09K1jdBBRnPfxVVIPCWA3/QAklV2xtfbBEp9Egq2Px2FL34e03ltFf
	 T9/vVO0dm60VeAMGVTOJIXV2D90LXu5j1Z2Rv0yhOzDbsrMOUYdjj8ABQLYoyBhRzf
	 R6sdU6RS0i+mg==
Date: Fri, 5 Jun 2026 12:23:40 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-team@android.com, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Set a linux errno on SMCCC error in
 kvm_call_hyp_nvhe()
Message-ID: <aiKxvK8HXCac4SYU@willie-the-truck>
References: <20260603110312.2909844-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603110312.2909844-1-vdonnefort@google.com>

On Wed, Jun 03, 2026 at 12:03:12PM +0100, Vincent Donnefort wrote:
> If the HVC called in kvm_call_hyp_nvhe() fails with an SMCCC error code,
> we WARN. However, the returned value isn't initialized and the caller
> might get garbage or 0 which is likely to be interpreted as success.
> 
> Set a default -EPERM error value, ensuring all callers get the message
> when SMCCC calls fail.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> ---
> 
> I have encountered this issue while working on a follow-up contribution to the
> hypervisor tracing. In that case it completely crashed the kernel because
> IS_ERR() failed on that res.a1 value.
> 
> Now, if it makes that function more robust, I do not believe it is fixing any
> existing bug which is why I haven't added a "Fixes:" tag. 
> 
> In case we want to stick one, here it is:
> 
> Fixes: 054698316d87 ("KVM: arm64: nVHE: Migrate hyp interface to SMCCC")
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a49042bfa801..6b8fd494792c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1273,13 +1273,14 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
> -#define kvm_call_hyp_nvhe(f, ...)						\
> +#define kvm_call_hyp_nvhe(f, ...)					\
>  	({								\
>  		struct arm_smccc_res res;				\
>  									\
>  		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
>  				  ##__VA_ARGS__, &res);			\
> -		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
> +		if (WARN_ON(res.a0 != SMCCC_RET_SUCCESS))		\
> +			res.a1 = -EPERM;				\
>  									\
>  		res.a1;							\
>  	})

Looks like the only error code we return to the host is
SMCCC_RET_NOT_SUPPORTED, so maybe -EOPNOTSUPP would be more appropriate?

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will
