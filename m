From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 06/18] kvm: arm/arm64: Allow arch specific
 configurations for VM
Date: Thu, 20 Sep 2018 12:22:17 +0200
Message-ID: <27461411-7c9d-7ea4-da39-b8f4628911ef@redhat.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-7-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2744A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 06:22:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QwnSD2A9xV0Z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Sep 2018 06:22:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1505B49F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 06:22:25 -0400 (EDT)
In-Reply-To: <20180917104144.19188-7-suzuki.poulose@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
> Allow the arch backends to perform VM specific initialisation.
> This will be later used to handle IPA size configuration and per-VM
> VTCR configuration on arm64.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm/include/asm/kvm_host.h   | 7 +++++++
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/reset.c            | 7 +++++++
>  virt/kvm/arm/arm.c                | 5 +++--
>  4 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 3ad482d2f1eb..72d46418e1ef 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -354,4 +354,11 @@ static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
>  struct kvm *kvm_arch_alloc_vm(void);
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> +static inline int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
> +{
> +	if (type)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3d6d7336f871..b04280ae1be0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -513,4 +513,6 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
>  struct kvm *kvm_arch_alloc_vm(void);
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> +int kvm_arm_config_vm(struct kvm *kvm, unsigned long type);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index e37c78bbe1ca..b0c07dab5cb3 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -133,3 +133,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	/* Reset timer */
>  	return kvm_timer_vcpu_reset(vcpu);
>  }
> +
> +int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
> +{
> +	if (type)
> +		return -EINVAL;
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index c92053bc3f96..327d0fd28380 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -120,8 +120,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	int ret, cpu;
>  
> -	if (type)
> -		return -EINVAL;
> +	ret = kvm_arm_config_vm(kvm, type);
> +	if (ret)
> +		return ret;
>  
>  	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
>  	if (!kvm->arch.last_vcpu_ran)
> 
