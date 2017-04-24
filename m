From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with percpu
 irq request
Date: Mon, 24 Apr 2017 19:46:43 +0100
Message-ID: <398f3f3d-c567-0f1f-1a43-9b8d5805d5fd@arm.com>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>, tglx@linutronix.de
Cc: Mark Rutland <mark.rutland@arm.com>, Vineet Gupta <vgupta@synopsys.com>, Patrice Chotard <patrice.chotard@st.com>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Javier Martinez Canillas <javier@osg.samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, kernel@stlinux.com, linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/04/17 15:01, Daniel Lezcano wrote:
> In the next changes, we track when the interrupts occur in order to
> statistically compute when is supposed to happen the next interrupt.
> 
> In all the interruptions, it does not make sense to store the timer interrupt
> occurences and try to predict the next interrupt as when know the expiration
> time.
> 
> The request_irq() has a irq flags parameter and the timer drivers use it to
> pass the IRQF_TIMER flag, letting us know the interrupt is coming from a timer.
> Based on this flag, we can discard these interrupts when tracking them.
> 
> But, the API request_percpu_irq does not allow to pass a flag, hence specifying
> if the interrupt type is a timer.
> 
> Add a function request_percpu_irq_flags() where we can specify the flags. The
> request_percpu_irq() function is changed to be a wrapper to
> request_percpu_irq_flags() passing a zero flag parameter.
> 
> Change the timers using request_percpu_irq() to use request_percpu_irq_flags()
> instead with the IRQF_TIMER flag set.
> 
> For now, in order to prevent a misusage of this parameter, only the IRQF_TIMER
> flag (or zero) is a valid parameter to be passed to the
> request_percpu_irq_flags() function.

[...]

> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 35d7100..602e0a8 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -523,8 +523,9 @@ int kvm_timer_hyp_init(void)
>  		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
>  	}
>  
> -	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
> -				 "kvm guest timer", kvm_get_running_vcpus());
> +	err = request_percpu_irq_flags(host_vtimer_irq, kvm_arch_timer_handler,
> +				       IRQF_TIMER, "kvm guest timer",
> +				       kvm_get_running_vcpus());
>  	if (err) {
>  		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
>  			host_vtimer_irq, err);
> 

How is that useful? This timer is controlled by the guest OS, and not
the host kernel. Can you explain how you intend to make use of that
information in this case?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
