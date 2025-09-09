Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55BA2EDD52;
	Tue,  9 Sep 2025 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427394; cv=none; b=oeUGaDz9Hel0numgcgBfUtOgmup2R/g6qlpCM0+suHf6Gb2qNUBTEdEKtL0ZqhcJfwmGtxK1kPqAAjsA9P6ocqAZlRdEPIgzjnupj6nGcxEBCE5miHIl+hBfIOYN6o9BMwsuPRkEuEV4JilOp/5S77+wwiU7OFkkcsjSliV8X5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427394; c=relaxed/simple;
	bh=2l6KZN5Zc9kV5MLkJIQhcmAGY9mNemETDpLwFvQUzWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5DFAnXNruTsbqsYM8WOlersDO3eBw9ZuFWcCDUa528sU40MYOkhgRCGNPwHhjsFrOBoqFtf8XluT8cmleNLmmGSowd7Hh7uLGog+7dyjhVBdabXT7M9Vkn9FOlstv1w0qhFMyfHhIKrVgGeJNfv/QcoPV2zawueRzhKrK0y8W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLkqCTKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLkqCTKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C963BC4CEF4;
	Tue,  9 Sep 2025 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757427393;
	bh=2l6KZN5Zc9kV5MLkJIQhcmAGY9mNemETDpLwFvQUzWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LLkqCTKJuacndmqViTJT4y49WssfoH6kozYjLZvwCQGsczOTRO59xxXjIa06L7nyl
	 Y+jhH6jCzDmqSpxCK0kZNL788FD2bxf5nhnWFyBA8I29dfOARW35OwBMoWq9QrEyfL
	 EwIz7nKNJxs+RcXRoNfAMvcpwL+k6DnZ5YXK+zDDiqMG1GRuJBoNXQCuL5yXrBWz/C
	 q/jaNfCOhjw7bsHjjt4p/YbSuZic7i7qjPOSoUO7KZ+zM0TEZPDa2c7AoT+CmwdQZm
	 W6x2eaIRuuuXgejOpBCMi8BbNfojSoL/A900rYDM0AejW8AgPoBo2wViMnRUUvZcXd
	 05P9Y3XnwAsag==
Date: Tue, 9 Sep 2025 15:16:26 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 03/28] KVM: arm64: pkvm: Add pkvm_time_get()
Message-ID: <aMA2ugNakqrA1Pg0@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-4-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-4-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:31PM +0000, Mostafa Saleh wrote:
> Add a function to return time in us.
> 
> This can be used from IOMMU drivers while waiting for conditions as
> for SMMUv3 TLB invalidation waiting for sync.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/setup.c        |  4 ++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 33 ++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index ce31d3b73603..6c19691720cd 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -87,4 +87,6 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
>  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
>  int kvm_check_pvm_sysreg_table(void);
>  
> +int pkvm_timer_init(void);
> +u64 pkvm_time_get(void);
>  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index a48d3f5a5afb..ee6435473204 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -304,6 +304,10 @@ void __noreturn __pkvm_init_finalise(void)
>  	};
>  	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
>  
> +	ret = pkvm_timer_init();
> +	if (ret)
> +		goto out;
> +
>  	ret = fix_host_ownership();
>  	if (ret)
>  		goto out;
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index ff176f4ce7de..e166cd5a56b8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -11,6 +11,10 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +#include <nvhe/pkvm.h>
> +
> +static u32 timer_freq;
> +
>  void __kvm_timer_set_cntvoff(u64 cntvoff)
>  {
>  	write_sysreg(cntvoff, cntvoff_el2);
> @@ -68,3 +72,32 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  
>  	sysreg_clear_set(cnthctl_el2, clr, set);
>  }
> +
> +static u64 pkvm_ticks_get(void)
> +{
> +	return __arch_counter_get_cntvct();
> +}
> +
> +#define SEC_TO_US 1000000
> +
> +int pkvm_timer_init(void)
> +{
> +	timer_freq = read_sysreg(cntfrq_el0);
> +	/*
> +	 * TODO: The highest privileged level is supposed to initialize this
> +	 * register. But on some systems (which?), this information is only
> +	 * contained in the device-tree, so we'll need to find it out some other
> +	 * way.
> +	 */
> +	if (!timer_freq || timer_freq < SEC_TO_US)
> +		return -ENODEV;
> +	return 0;
> +}

Right, I think the frequency should be provided by the host once the arch
timer driver has probed successfully. Relying on CNTFRQ isn't viable imo.

Will
