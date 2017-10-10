From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 17/20] KVM: arm/arm64: Move phys_timer_emulate function
Date: Tue, 10 Oct 2017 10:21:22 +0100
Message-ID: <87a80zwe7h.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-18-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-18-cdall@linaro.org> (Christoffer Dall's
        message of "Sat, 23 Sep 2017 02:42:04 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:04 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> We are about to call phys_timer_emulate() from kvm_timer_update_state()
> and modify phys_timer_emulate() at the same time.  Moving the function
> and modifying it in a single patch makes the diff hard to read, so do
> this separately first.
>
> No functional change.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index d5b632d..1f82c21 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -252,6 +252,22 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  	}
>  }
>  
> +/* Schedule the background timer for the emulated timer. */
> +static void phys_timer_emulate(struct kvm_vcpu *vcpu,
> +			      struct arch_timer_context *timer_ctx)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +
> +	if (kvm_timer_should_fire(timer_ctx))
> +		return;
> +
> +	if (!kvm_timer_irq_can_fire(timer_ctx))
> +		return;
> +
> +	/*  The timer has not yet expired, schedule a background timer */
> +	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
> +}
> +
>  /*
>   * Check if there was a change in the timer state (should we raise or lower
>   * the line level to the GIC).
> @@ -278,22 +294,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
>  }
>  
> -/* Schedule the background timer for the emulated timer. */
> -static void phys_timer_emulate(struct kvm_vcpu *vcpu,
> -			      struct arch_timer_context *timer_ctx)
> -{
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -
> -	if (kvm_timer_should_fire(timer_ctx))
> -		return;
> -
> -	if (!kvm_timer_irq_can_fire(timer_ctx))
> -		return;
> -
> -	/*  The timer has not yet expired, schedule a background timer */
> -	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
> -}
> -
>  static void vtimer_save_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
