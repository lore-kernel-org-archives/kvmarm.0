Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42777154B4
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:48:47 +0000 (UTC)
Date: Wed, 19 Jul 2023 17:48:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689788926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NH0eY5pTWM2W4SeZqyRzOXk4CTCgrZfxkq9mfYa2bdc=;
	b=Wm3VVgXjNFu0mdtmHM+FUd8P+9hAQyPHUWIJ1M172c75aIjGtCieMX+Etoz0Ba67aYAtJ+
	eM75KlEasif+CZRGMUV1pp0eRvV5afyhLq+wyDZRxUQIByZj2q67DFh9/ucqZN9qM9CNUC
	06PXubhrX8sQQgLjsWM6u9bdgjmcM7M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 3/5] KVM: arm64: Use the appropriate feature trap
 register when activating traps
Message-ID: <ZLgh+rPYxTjmD6xR@linux.dev>
References: <20230719150639.1968034-1-tabba@google.com>
 <20230719150639.1968034-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719150639.1968034-4-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 19, 2023 at 04:06:37PM +0100, Fuad Tabba wrote:
> Use the architectural feature trap/control register that
> corresponds to the current KVM mode, i.e., CPTR_EL2 or CPACR_EL1,
> when activating traps.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 0a6271052def..e5ea517bab9c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -63,7 +63,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  		__activate_traps_fpsimd32(vcpu);
>  	}
>  
> -	write_sysreg(val, cptr_el2);
> +	if (has_hvhe())
> +		write_sysreg(val, cpacr_el1);
> +	else
> +		write_sysreg(val, cptr_el2);
> +

Does it make sense to have an accessor that's shared with
kvm_reset_cptr_el2()? Due to the lack of synchronization between the
aliases we really want to avoid inconsistently using one or the other.

-- 
Thanks,
Oliver
