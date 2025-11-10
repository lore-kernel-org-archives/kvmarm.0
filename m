Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF7F314A94
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762786313; cv=none; b=iLoj/mxcqnFfP3Y9j+2h9CuWijkwozDH5zMAFOgHQi9l0UMZ3xJzR+QLtmuerckHUSwdEaULxI/gAstQ7fSLgSbS2Q/3QKGuhpMqUNTsbJPpO/JIH5feZ25dAFgQpqkSTEXYX+IuE84RcQHtxbmxjh+nJU5PykxNYYawLNthOHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762786313; c=relaxed/simple;
	bh=IefI19ZLF5w/5zStjmnhS9r+m4d/8TwRfKfvEVYhTCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O170H46P6ppJfcUXW29ZJxfS/AQeR4A8VgHltgAM/VGgktwNBGSqIT3LOBpsa7CKMlE305P0bF658T0G6ZwGe5WbIyGH11BN9UzcwfR0e6AkP7LPlltUpPvRBIUJGNXGEsW7p11zWlCoBM4ohqHjfxujjnTxyqT/krH6nW8dtP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 208FB2F;
	Mon, 10 Nov 2025 06:51:43 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50B833F63F;
	Mon, 10 Nov 2025 06:51:49 -0800 (PST)
Message-ID: <bc25a11a-d5b7-45de-bb99-c78100e5055d@arm.com>
Date: Mon, 10 Nov 2025 14:51:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] KVM: arm64: Fix MTE flag initialization for
 protected VMs
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, vladimir.murzin@arm.com
References: <20251110134525.3768197-1-tabba@google.com>
 <20251110134525.3768197-4-tabba@google.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251110134525.3768197-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 11/10/25 13:45, Fuad Tabba wrote:
> The function pkvm_init_features_from_host() initializes guest
> features, propagating them from the host. The logic to propagate
> KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
> has a couple of issues.
> 
> First, the check was in the common path, before the divergence for
> protected and non-protected VMs. For non-protected VMs, this was
> unnecessary, as 'kvm->arch.flags' is completely overwritten by
> host_arch_flags immediately after, which already contains the MTE flag.
> For protected VMs, this was setting the flag even if the feature is not
> allowed.
> 
> Second, the check was reading 'host_kvm->arch.flags' instead of using
> the local 'host_arch_flags', which is read once from the host flags.
> 
> Fix these by moving the MTE flag check inside the protected-VM-only
> path, checking if the feature is allowed, and changing it to use the
> correct host_arch_flags local variable. This ensures non-protected VMs
> get the flag via the bulk copy, and protected VMs get it via an explicit
> check.
> 
> Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index f6f8996c4f97..7e370e31260d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -337,9 +337,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>  	/* CTR_EL0 is always under host control, even for protected VMs. */
>  	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
>  
> -	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
> -		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
> -
>  	/* No restrictions for non-protected VMs. */
>  	if (!kvm_vm_is_protected(kvm)) {
>  		hyp_vm->kvm.arch.flags = host_arch_flags;
> @@ -372,6 +369,11 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>  		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
>  	}
>  
> +	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE)) {
> +		set_bit(KVM_CAP_ARM_MTE, allowed_features);

Isn't allowed_features a bitmap for the KVM_ARCH_VCPU_ defines? I think
MTE is treated as a property of the VM.

> +		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
> +	}
> +
>  	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
>  		   allowed_features, KVM_VCPU_MAX_FEATURES);
>  }


Thanks,

Ben

