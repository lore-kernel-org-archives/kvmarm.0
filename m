Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04CC197A87
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732101929; cv=none; b=BbjwHMAVkeIOZeswS09GimTjPrnXEivZllDQ9iTBOE2WaR5hMtsO+sdsLeHPZFwzIpg+/jqaoyv/XMV4BT1d1SiQuwcgejtQmK9E+1jwjzPDy4bZnXZvDGpQLKkk++P0EybSSjPUBJzkhbXrGshQ9nBrGuFnb4ZOlOpZxoEEJEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732101929; c=relaxed/simple;
	bh=XIN409179OeGHhGWtojZY91e4TTjwqCU9Nstx8LiqT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6ZI9dmLG5uppRxbxj1mCeOTqkgHcO2TCB1kzTJDLZCY40eCkFrhaXD7Ilui+s/yayZki3jMuju0HC52hCdJm/aScoXc8PyppdAHLVJwWSIdFVtZSgZNFj8jfSyE2Tefxi767VB9NDJv8Eq9a2HjYDUK+zKM2L/HukDBUQt2vW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 668511480;
	Wed, 20 Nov 2024 03:25:49 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77C3E3F5A1;
	Wed, 20 Nov 2024 03:25:18 -0800 (PST)
Date: Wed, 20 Nov 2024 11:25:13 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm64: Mark set_sysreg_masks() as inline to avoid
 build failure
Message-ID: <20241120112513.GA1500059@e124191.cambridge.arm.com>
References: <20241120111516.304250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120111516.304250-1-maz@kernel.org>

On Wed, Nov 20, 2024 at 11:15:16AM +0000, Marc Zyngier wrote:
> When compiling with CONFIG_CC_OPTIMIZE_FOR_SIZE=y, set_sysreg_masks()
> fails to compile thanks to:
> 
> 	BUILD_BUG_ON(!__builtin_constant_p(sr));
> 
> as the compiler doesn't identify sr as a constant, despite all the
> callers passing constants.
> 
> Fix the issue by always inlining this function, which allows GCC to
> do the right thing.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202411201857.ZNudtGJl-lkp@intel.com/
> Fixes: a0162020095e2 ("KVM: arm64: Extend masking facility to arbitrary registers")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index aeaa6017ffd89..9b36218b48def 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -951,7 +951,7 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
>  	return v;
>  }
>  
> -static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> +static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
>  {
>  	int i = sr - __SANITISED_REG_START__;
>  


Reviewed-by: Joey Gouly <joey.gouly@arm.com>
