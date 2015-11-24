From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Fix preemptible timer active state
 crazyness
Date: Tue, 24 Nov 2015 15:51:14 +0000
Message-ID: <20151124155114.2dcd18fb@arm.com>
References: <1448379840-17516-1-git-send-email-christoffer.dall@linaro.org>
	<1448379840-17516-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1448379840-17516-2-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 24 Nov 2015 16:43:58 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> We were setting the physical active state on the GIC distributor in a
> preemptible section, which could cause us to set the active state on
> different physical CPU from the one we were actually going to run on,
> hacoc ensues.
> 
> Since we are no longer descheduling/scheduling soft timers in the
> flush/sync timer functions, simply moving the timer flush into a
> non-preemptible section.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/kvm/arm.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index eab83b2..e06fd29 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -564,17 +564,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			vcpu_sleep(vcpu);
>  
>  		/*
> -		 * Disarming the background timer must be done in a
> -		 * preemptible context, as this call may sleep.
> -		 */
> -		kvm_timer_flush_hwstate(vcpu);
> -
> -		/*
>  		 * Preparing the interrupts to be injected also
>  		 * involves poking the GIC, which must be done in a
>  		 * non-preemptible context.
>  		 */
>  		preempt_disable();
> +		kvm_timer_flush_hwstate(vcpu);
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		local_irq_disable();

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
