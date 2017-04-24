From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with
 percpu irq request
Date: Mon, 24 Apr 2017 20:33:38 +0200
Message-ID: <20170424183338.xglbm6ytdrexlsdh@kozik-lap>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, Mark Rutland <mark.rutland@arm.com>, Vineet Gupta <vgupta@synopsys.com>, Marc Zyngier <marc.zyngier@arm.com>, Patrice Chotard <patrice.chotard@st.com>, Kukjin Kim <kgene@kernel.org>, Javier Martinez Canillas <javier@osg.samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, kernel@stlinux.com, linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 24, 2017 at 04:01:31PM +0200, Daniel Lezcano wrote:
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
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> 
> ---
> Changelog:
> 
>    V9:
> 	- Clarified the patch description
> 	- Fixed EXPORT_SYMBOL_GPL(request_percpu_irq_flags)
> ---
>  arch/arm/kernel/smp_twd.c                |  3 ++-
>  drivers/clocksource/arc_timer.c          |  4 ++--
>  drivers/clocksource/arm_arch_timer.c     | 20 ++++++++++++--------
>  drivers/clocksource/arm_global_timer.c   |  4 ++--
>  drivers/clocksource/exynos_mct.c         |  7 ++++---
>  drivers/clocksource/qcom-timer.c         |  4 ++--
>  drivers/clocksource/time-armada-370-xp.c |  9 +++++----
>  drivers/clocksource/timer-nps.c          |  6 +++---
>  include/linux/interrupt.h                | 11 ++++++++++-
>  kernel/irq/manage.c                      | 15 ++++++++++-----
>  virt/kvm/arm/arch_timer.c                |  5 +++--
>  11 files changed, 55 insertions(+), 33 deletions(-)
>

For exynos-mct:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
