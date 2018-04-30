From: Julien Grall <julien.grall@arm.com>
Subject: Re: [kvmtool PATCH 21/17] kvmtool: arm: Add support for creating VM
 with PA size
Date: Mon, 30 Apr 2018 15:17:01 +0100
Message-ID: <21da5232-5be6-7d48-a5a6-2d89f3c0f682@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-22-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-22-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 5701d41..a9a9140 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -11,6 +11,8 @@
>   #include <linux/kvm.h>
>   #include <linux/sizes.h>
>   
> +unsigned long kvm_arm_type;
> +
>   struct kvm_ext kvm_req_ext[] = {
>   	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
>   	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
> @@ -18,6 +20,25 @@ struct kvm_ext kvm_req_ext[] = {
>   	{ 0, 0 },
>   };
>   
> +#ifndef KVM_ARM_GET_MAX_VM_PHYS_SHIFT
> +#define KVM_ARM_GET_MAX_VM_PHYS_SHIFT		_IO(KVMIO, 0x0a)
> +#endif
> +
> +void kvm__arch_init_hyp(struct kvm *kvm)
> +{
> +	unsigned max_ipa;
> +
> +	max_ipa = ioctl(kvm->sys_fd, KVM_ARM_GET_MAX_VM_PHYS_SHIFT);
> +	if (max_ipa < 0)

Another issues spotted while doing some testing. This will always be 
false because max_ipa is unsigned.

I think we want to turn max_ipa to signed.

Cheers,

-- 
Julien Grall
