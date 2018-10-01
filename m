From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v6 22/18] kvmtool: arm: Add support for creating
 VM with PA size
Date: Mon, 1 Oct 2018 15:13:15 +0100
Message-ID: <0efe3696-e6fd-531d-c473-9dedf6b9d057@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
 <20180926163258.20218-23-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-23-suzuki.poulose@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, eric.auger@redhat.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 26/09/18 17:32, Suzuki K Poulose wrote:
> Specify the physical size for the VM encoded in the vm type.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arm/include/arm-common/kvm-arch.h |  6 +++++-
>   arm/kvm.c                         | 32 +++++++++++++++++++++++++++++++
>   2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index b29b4b1..d77f3ac 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -44,7 +44,11 @@
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
> index eac2ad2..c8db6b3 100644
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
> @@ -18,6 +20,36 @@ struct kvm_ext kvm_req_ext[] = {
>   	{ 0, 0 },
>   };
>   
> +#ifndef KVM_CAP_ARM_VM_IPA_SIZE
> +#define KVM_CAP_ARM_VM_IPA_SIZE	159
> +#endif

Note that when merged on top of 4.19-rc5, this is already 160. I assume 
this will be even different once this lands in mainline.

Thanks,

	M.

> +
> +#ifndef KVM_VM_TYPE_ARM_IPA_SIZE
> +#define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
> +#define KVM_VM_TYPE_ARM_IPA_SIZE(x)	\
> +	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +#endif
> +
> +void kvm__arch_init_hyp(struct kvm *kvm)
> +{
> +	int max_ipa;
> +
> +	if (!kvm->cfg.arch.phys_shift)
> +		kvm->cfg.arch.phys_shift = 40;
> +	if (kvm->cfg.arch.phys_shift == 40)
> +		return;
> +	max_ipa = ioctl(kvm->sys_fd,
> +			KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +	if (!max_ipa)
> +		die("Kernel doesn't support IPA size configuration\n");
> +	if ((kvm->cfg.arch.phys_shift > max_ipa) ||
> +	    (kvm->cfg.arch.phys_shift < 32))
> +		die("Requested PA size (%u) is not supported by the host"
> +		    " [32 - %u]bit\n",
> +		    kvm->cfg.arch.phys_shift, max_ipa);
> +	kvm_arm_type = KVM_VM_TYPE_ARM_IPA_SIZE(kvm->cfg.arch.phys_shift);
> +}
> +
>   bool kvm__arch_cpu_supports_vm(void)
>   {
>   	/* The KVM capability check is enough. */
> 


-- 
Jazz is not dead. It just smells funny...
