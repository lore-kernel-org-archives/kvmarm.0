From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] Detect vGIC presence at runtime
Date: Thu, 9 Jul 2015 13:37:21 +0200
Message-ID: <20150709113721.GJ13530@cbox>
References: <cover.1436264839.git.p.fedin@samsung.com>
 <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 07, 2015 at 02:11:01PM +0300, Pavel Fedin wrote:
> Allows to use KVM on hardware without vGIC. Interrupt controller has to be
> emulated in userspace in this case.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/arm.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..f2f7a13 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -61,6 +61,8 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
>  static u8 kvm_next_vmid;
>  static DEFINE_SPINLOCK(kvm_vmid_lock);
>  
> +static bool vgic_present;
> +
>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	BUG_ON(preemptible());
> @@ -172,6 +174,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	switch (ext) {
>  	case KVM_CAP_IRQCHIP:
>  	case KVM_CAP_IRQFD:
> +		r = vgic_present;
> +		break;
>  	case KVM_CAP_IOEVENTFD:
>  	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
> @@ -850,6 +854,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>  
>  	switch (dev_id) {
>  	case KVM_ARM_DEVICE_VGIC_V2:
> +		if (!vgic_present)
> +			return -ENXIO;
>  		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
>  	default:
>  		return -ENODEV;
> @@ -864,6 +870,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  
>  	switch (ioctl) {
>  	case KVM_CREATE_IRQCHIP: {
> +		if (!vgic_present)
> +			return -ENXIO;
>  		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  	}
>  	case KVM_ARM_SET_DEVICE_ADDR: {
> @@ -1046,8 +1054,17 @@ static int init_hyp_mode(void)
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

why not report ENXIO as an error?  If probing the vgic fails due to
being unable to request the irq or something similar, then surely your
system has and error and this should be reported.

This may be more nicely implemented by letting the vgic init/probe
functions set the vgic_present, or maybe better yet, just export a
function from vgic.c:

bool kvm_vgic_present(void)
{
	return vgic_ops != NULL;
}

> +		break;
> +	default:
>  		goto out_free_context;
> +	}
>  
>  	/*
>  	 * Init HYP architected timer support
> -- 
> 2.4.4
> 

-Christoffer
