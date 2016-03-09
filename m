From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 2/9] clocksource: arm_arch_timer: Extend
 arch_timer_kvm_info to get the virtual IRQ
Date: Tue, 8 Mar 2016 19:27:13 -0800
Message-ID: <20160309032713.GF26583@lvm>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-3-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE6A412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 22:27:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2AUf-Wgw67hc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2016 22:27:14 -0500 (EST)
Received: from mail-pf0-f181.google.com (mail-pf0-f181.google.com
 [209.85.192.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B744840FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 22:27:13 -0500 (EST)
Received: by mail-pf0-f181.google.com with SMTP id x188so28448748pfb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2016 19:27:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1457436573-6180-3-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 08, 2016 at 11:29:26AM +0000, Julien Grall wrote:
> Currently, the firmware table is parsed by the virtual timer code in
> order to retrieve the virtual timer interrupt. However, this is already
> done by the arch timer driver.
> 
> To avoid code duplication, extend arch_timer_kvm_info to get the virtual
> IRQ.
> 
> Note that the KVM code will be modified in a subsequent patch.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
> ---
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
>     Changes in v3:
>         - Move the KVM changes in a separate patch and rename the patch
>         - Move the initialization of the virtual_irq to
>         arch_timer_common_init
> ---
>  drivers/clocksource/arm_arch_timer.c | 2 ++
>  include/clocksource/arm_arch_timer.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index b7ab588..d8887f3 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -701,6 +701,8 @@ static void __init arch_timer_common_init(void)
>  	arch_timer_banner(arch_timers_present);
>  	arch_counter_register(arch_timers_present);
>  	arch_timer_arch_init();
> +
> +	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[VIRT_PPI];

why is this in common_init and not just in init?

>  }
>  
>  static void __init arch_timer_init(void)
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 9101ed6b..9dd996a 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -51,6 +51,7 @@ enum arch_timer_reg {
>  
>  struct arch_timer_kvm_info {
>  	struct timecounter timecounter;
> +	int virtual_irq;
>  };
>  
>  #ifdef CONFIG_ARM_ARCH_TIMER
> -- 
> 1.9.1
> 
