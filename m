From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/3] KVM: arm: Detect vGIC presence at runtime
Date: Fri, 17 Jul 2015 18:14:00 +0100
Message-ID: <55A937D8.6030307@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <e664e112531093dcb47c2028c72670d755e76f08.1436874248.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2467F58D9C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 13:02:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9EkhJB8PTsyx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 13:02:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D604E58D97
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 13:02:06 -0400 (EDT)
In-Reply-To: <e664e112531093dcb47c2028c72670d755e76f08.1436874248.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/15 13:06, Pavel Fedin wrote:
> Allows to use KVM on hardware without vGIC. Interrupt controller has to be
> emulated in userspace in this case.
> 
> -ENODEV return code from probe function means there's no GIC at all. -ENXIO
> happens when, for example, there is GIC node in the device tree, but it does
> not specify vGIC resources. Normally this means that vGIC hardware is defunct.
> Any other code is still treated as full stop because it might mean some really
> serious problems.

As mentioned in a previous email, supporting systems that don't even
have a GIC at all (hence don't support the management of an ACTIVE
state) is going to keep us in the dark ages. See the active timer series
that mandates it.

So keeping KVM alive when we get an -ENODEV is not acceptable. No GIC,
no fun.

> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/arm.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 5668c4e..7e389fd 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -61,6 +61,8 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
>  static u8 kvm_next_vmid;
>  static DEFINE_SPINLOCK(kvm_vmid_lock);
>  
> +static bool vgic_present;
> +

This needs documentation.

>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	BUG_ON(preemptible());
> @@ -131,7 +133,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.vmid_gen = 0;
>  
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
> -	kvm->arch.max_vcpus = kvm_vgic_get_max_vcpus();
> +	kvm->arch.max_vcpus = vgic_present ?
> +				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  
>  	return ret;
>  out_free_stage2_pgd:
> @@ -172,6 +175,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	switch (ext) {
>  	case KVM_CAP_IRQCHIP:
>  	case KVM_CAP_IRQFD:
> +		r = vgic_present;
> +		break;
>  	case KVM_CAP_IOEVENTFD:
>  	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
> @@ -850,6 +855,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>  
>  	switch (dev_id) {
>  	case KVM_ARM_DEVICE_VGIC_V2:
> +		if (!vgic_present)
> +			return -ENXIO;
>  		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
>  	default:
>  		return -ENODEV;
> @@ -864,6 +871,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  
>  	switch (ioctl) {
>  	case KVM_CREATE_IRQCHIP: {
> +		if (!vgic_present)
> +			return -ENXIO;
>  		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  	}
>  	case KVM_ARM_SET_DEVICE_ADDR: {
> @@ -1046,8 +1055,17 @@ static int init_hyp_mode(void)
>  	 * Init HYP view of VGIC
>  	 */
>  	err = kvm_vgic_hyp_init();
> -	if (err)
> +	switch (err) {
> +	case 0:
> +		vgic_present = true;
> +		break;
> +	case -ENODEV:
> +	case -ENXIO:
> +		vgic_present = false;
> +		break;
> +	default:
>  		goto out_free_context;
> +	}
>  
>  	/*
>  	 * Init HYP architected timer support
> 


-- 
Jazz is not dead. It just smells funny...
