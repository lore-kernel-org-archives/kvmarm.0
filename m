From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 25 Jun 2015 10:04:57 +0200
Message-ID: <20150625080457.GD28244@cbox>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 24, 2015 at 03:54:57PM +0100, Marc Zyngier wrote:
> Userspace is allowed to set the guest's view of CNTVCT, which turns
> into setting CNTVOFF for the whole VM. One thing userspace is not supposed
> to do is to update that register while the guest is running. Time will
> either move forward (best case) or backward (really bad idea). Either way,
> this shouldn't happen.
> 
> This patch prevents userspace from touching CNTVOFF as soon as a vcpu
> has been started. This ensures that time will keep monotonically increase.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> 
> QEMU seems to trigger this at boot time, and I have no idea why it does so.
> It would be good to find out, hence the RFC tag.

Is this at kernel boot time you see this, or at system startup time?

IIRC, QEMU creates a throw-away VM with the default CPU target time,
reads out all the system registers to get the KVM reset values of those,
then creates the real VM, and feeds back in all the system register
reset values, as a method for QEMU and KVM to be in sync about the reset
state of the machine.  If we do this, and include CNTVCT, then that
would probably trigger this, but the VCPU really shouldn't have been run
at that time...

We should prevent userspace from fiddling with this register post VCPU
start regardless, but yes, it would be good to find out why this is
happening in the first place.

How did you notice this and does it manifest itself in some user-visible
ugliness?

Thanks,
-Christoffer

> 
>  virt/kvm/arm/arch_timer.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 98c95f2..660f348 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -220,9 +220,26 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  	case KVM_REG_ARM_TIMER_CTL:
>  		timer->cntv_ctl = value;
>  		break;
> -	case KVM_REG_ARM_TIMER_CNT:
> -		vcpu->kvm->arch.timer.cntvoff = kvm_phys_timer_read() - value;
> +	case KVM_REG_ARM_TIMER_CNT: {
> +		struct kvm_vcpu *tmp;
> +		int i;
> +		u64 cntvoff = kvm_phys_timer_read() - value;
> +
> +		/*
> +		 * If any of the vcpus has started, don't update
> +		 * CNTVOFF. Userspace is severely brain damaged.
> +		 */
> +		kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +			if (tmp->arch.has_run_once) {
> +				kvm_debug("Won't set CNTVOFF to %llx (%llx)\n",
> +					  cntvoff,
> +					  vcpu->kvm->arch.timer.cntvoff);
> +				return -1;
> +			}
> +		}
> +		vcpu->kvm->arch.timer.cntvoff = cntvoff;
>  		break;
> +	}
>  	case KVM_REG_ARM_TIMER_CVAL:
>  		timer->cntv_cval = value;
>  		break;
> -- 
> 2.1.4
> 
