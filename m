From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/10] arm/arm64: KVM: Move vgic handling to a
 non-preemptible section
Date: Tue, 30 Jun 2015 22:19:19 +0200
Message-ID: <20150630201919.GZ11332@cbox>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433783045-8002-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 08, 2015 at 06:03:57PM +0100, Marc Zyngier wrote:
> As we're about to introduce some serious GIC-poking to the vgic code,
> it is important to make sure that we're going to poke the part of
> the GIC that belongs to the CPU we're about to run on (otherwise,
> we'd end up with some unexpected interrupts firing)...
> 
> Introducing a non-preemptible section in kvm_arch_vcpu_ioctl_run
> prevents the problem from occuring.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/arm.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 46db690..4986300 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -529,8 +529,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (vcpu->arch.pause)
>  			vcpu_pause(vcpu);
>  
> +		/*
> +		 * Disarming the timer must be done with in a

s/with //

> +		 * preemptible context, as this call may sleep.
> +		 */
>  		kvm_timer_flush_hwstate(vcpu);
>  
> +		/*
> +		 * Preparing the interrupts to be injected also
> +		 * involves poking the GIC, which must be done in a
> +		 * non-preemptible context.
> +		 */
> +		preempt_disable();
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		local_irq_disable();
> @@ -546,6 +556,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
>  			local_irq_enable();
>  			kvm_vgic_sync_hwstate(vcpu);
> +			preempt_enable();
>  			kvm_timer_sync_hwstate(vcpu);
>  			continue;
>  		}
> @@ -580,6 +591,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		kvm_vgic_sync_hwstate(vcpu);
>  
> +		preempt_enable();
> +
>  		kvm_timer_sync_hwstate(vcpu);
>  
>  		ret = handle_exit(vcpu, run, ret);
> -- 
> 2.1.4
> 
This should get more simple when rebased on cpu time accounting patch,
but otherwise looks good.

-Christoffer
