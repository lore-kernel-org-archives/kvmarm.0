From: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] KVM: arm64: Delegate support for SDEI to userspace
Date: Tue, 6 Jun 2017 21:58:35 +0200
Message-ID: <20170606195835.GL9464@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515174400.29735-12-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Mon, May 15, 2017 at 06:43:59PM +0100, James Morse wrote:
> The Software Delegated Exception Interface allows firmware to notify
> the OS of system events by returning into registered handlers, even
> if the OS has interrupts masked.
> 
> While we could support this in KVM, we would need to expose an API for
> the user space hypervisor to inject events, (and decide what to do it

'the user space hypervisor' ?

s/it/if/

> the event isn't registered or all the CPUs have SDE events masked). We
> already have an API for guest 'hypercalls', so use this to push the
> problem onto userspace.
> 
> Advertise a new capability 'KVM_CAP_ARM_SDEI_1_0' and when any SDEI
> call comes in, exit to userspace with exit_reason = KVM_EXIT_HYPERCALL.

Documentation/virtual/kvm/api.txt says this is unused.

We should add something there to say that this is now used for arm64,
and the api doc also suggests that the hypercall struct in kvm_run has
some meaningful data for this exit.

Have we checked that the guest can't provoke QEMU to do something weird
by causing this exit on arm64 currently (given that we always enable
this handling of SDEI calls)?

> 
> N.B. There is no enable/feature bit for SDEI exits as telling the guest
> the interface exists via DT/ACPI should be sufficient.
> 
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> 
> ---
> While I'm in here, why does KVM_CAP_ARM_SET_DEVICE_ADDR have a separate
> entry for r=1;break?
> 
>  arch/arm64/kvm/handle_exit.c | 10 +++++++++-
>  include/uapi/linux/kvm.h     |  1 +
>  virt/kvm/arm/arm.c           |  5 +++--
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index fa1b18e364fc..2bed62fbdc00 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -21,6 +21,7 @@
>  
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <linux/sdei.h>
>  
>  #include <asm/esr.h>
>  #include <asm/kvm_asm.h>
> @@ -42,7 +43,14 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			    kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> -	ret = kvm_psci_call(vcpu);
> +	if (IS_SDEI_CALL(vcpu_get_reg(vcpu, 0))) {
> +		/* SDEI is handled by userspace */
> +		run->exit_reason = KVM_EXIT_HYPERCALL;
> +		ret = 0;
> +	} else {
> +		ret = kvm_psci_call(vcpu);
> +	}
> +
>  	if (ret < 0) {
>  		kvm_inject_undefined(vcpu);
>  		return 1;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 577429a95ad8..e9ebfed9d624 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -895,6 +895,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SPAPR_TCE_VFIO 142
>  #define KVM_CAP_X86_GUEST_MWAIT 143
>  #define KVM_CAP_ARM_USER_IRQ 144
> +#define KVM_CAP_ARM_SDEI_1_0 145
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3a776ec99181..0bf2d923483c 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -206,8 +206,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_MP_STATE:
>  	case KVM_CAP_IMMEDIATE_EXIT:
> -		r = 1;
> -		break;
> +#ifdef CONFIG_ARM_SDE_INTERFACE
> +	case KVM_CAP_ARM_SDEI_1_0:
> +#endif

What's the point of conditionally supporting this based on the config
option when the rest of the KVM functionality does not depend on the
CONFIG_ARM_SDE_INTERFACE functionality?

Could a user want to play with SDEI calls in a VM without the host
having the proper support, or is that never relevant?


>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
>  		r = 1;
>  		break;
> -- 
> 2.10.1
> 

Thanks,
-Christoffer

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
