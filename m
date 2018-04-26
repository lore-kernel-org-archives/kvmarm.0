From: Julien Grall <julien.grall@arm.com>
Subject: Re: [kvmtool PATCH 21/17] kvmtool: arm: Add support for creating VM
 with PA size
Date: Thu, 26 Apr 2018 15:08:55 +0100
Message-ID: <c660b148-34ae-5409-665f-aadc94669752@arm.com>
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

Hi Suzuki,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> Specify the physical size for the VM encoded in the vm type.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arm/include/arm-common/kvm-arch.h |  6 +++++-
>   arm/kvm.c                         | 21 +++++++++++++++++++++
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index ca7ab0f..64bc92a 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -42,7 +42,11 @@
>   
>   #define KVM_IRQ_OFFSET		GIC_SPI_IRQ_BASE
>   
> -#define KVM_VM_TYPE		0
> +extern unsigned long		kvm_arm_type;
> +extern void kvm__arch_init_hyp(struct kvm *kvm);
> +
> +#define KVM_VM_TYPE		kvm_arm_type
> +#define kvm__arch_init_hyp	kvm__arch_init_hyp
>   
>   #define VIRTIO_DEFAULT_TRANS(kvm)	\
>   	((kvm)->cfg.arch.virtio_trans_pci ? VIRTIO_PCI : VIRTIO_MMIO)
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

Once the IOCTL is agreed, I think you would need to update 
include/linux/kvm.h.

> +
> +void kvm__arch_init_hyp(struct kvm *kvm)
> +{
> +	unsigned max_ipa;
> +
> +	max_ipa = ioctl(kvm->sys_fd, KVM_ARM_GET_MAX_VM_PHYS_SHIFT);
> +	if (max_ipa < 0)
> +		max_ipa = 40;
> +	if (!kvm->cfg.arch.phys_shift)
> +		kvm->cfg.arch.phys_shift = 40;
> +	if (kvm->cfg.arch.phys_shift > max_ipa)
> +		die("Requested PA size (%u) is not supported by the host (%ubits)\n",
> +		    kvm->cfg.arch.phys_shift, max_ipa);
> +	kvm_arm_type = kvm->cfg.arch.phys_shift;

FWIW, older Linux will not accept a KVM type other than 0. So I think 
the best would be to bail out if KVM_ARM_GET_MAX_VM_PHYS_SHIFT does not 
exist.

For safety, you could even check that arch.phys_shift is always 40 when 
running under older Linux.

Cheers,

-- 
Julien Grall
