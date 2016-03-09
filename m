From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 9/9] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 8 Mar 2016 22:02:53 -0800
Message-ID: <20160309060253.GM26583@lvm>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-10-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457436573-6180-10-git-send-email-julien.grall@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 08, 2016 at 11:29:33AM +0000, Julien Grall wrote:
> The only call of arch_timer_get_timecounter (in KVM) has been removed.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> 
>     Changes in v3:
>         - Patch added
> ---
>  drivers/clocksource/arm_arch_timer.c | 5 -----
>  include/clocksource/arm_arch_timer.h | 6 ------
>  2 files changed, 11 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d8887f3..94696d3 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -463,11 +463,6 @@ struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
>  	return &arch_timer_kvm_info;
>  }
>  
> -struct timecounter *arch_timer_get_timecounter(void)
> -{
> -	return &arch_timer_kvm_info.timecounter;
> -}
> -
>  static void __init arch_counter_register(unsigned type)
>  {
>  	u64 start_count;
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 9dd996a..caedb74 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -58,7 +58,6 @@ struct arch_timer_kvm_info {
>  
>  extern u32 arch_timer_get_rate(void);
>  extern u64 (*arch_timer_read_counter)(void);
> -extern struct timecounter *arch_timer_get_timecounter(void);
>  extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
>  
>  #else
> @@ -73,11 +72,6 @@ static inline u64 arch_timer_read_counter(void)
>  	return 0;
>  }
>  
> -static inline struct timecounter *arch_timer_get_timecounter(void)
> -{
> -	return NULL;
> -}
> -
>  #endif
>  
>  #endif
> -- 
> 1.9.1
> 
