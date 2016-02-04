From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 20/23] arm64: perf: Count EL2 events if the kernel is
 running in HYP
Date: Thu, 4 Feb 2016 20:23:01 +0100
Message-ID: <20160204192301.GG13974@cbox>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-21-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB8248535
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 14:17:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id heV5E7pkTOuK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 14:17:02 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38CE048531
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 14:17:01 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id p63so132015076wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2016 11:22:31 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454522416-6874-21-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 06:00:13PM +0000, Marc Zyngier wrote:
> When the kernel is running in HYP (with VHE), it is necessary to
> include EL2 events if the user requests counting kernel or
> hypervisor events.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/perf_event.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index f7ab14c..6013a38 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -20,6 +20,7 @@
>   */
>  
>  #include <asm/irq_regs.h>
> +#include <asm/virt.h>
>  
>  #include <linux/of.h>
>  #include <linux/perf/arm_pmu.h>
> @@ -693,10 +694,15 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  		return -EPERM;
>  	if (attr->exclude_user)
>  		config_base |= ARMV8_EXCLUDE_EL0;
> -	if (attr->exclude_kernel)
> -		config_base |= ARMV8_EXCLUDE_EL1;
> -	if (!attr->exclude_hv)
> -		config_base |= ARMV8_INCLUDE_EL2;
> +	if (is_kernel_in_hyp_mode()) {
> +		if (!attr->exclude_kernel || !attr->exclude_hv)
> +			config_base |= ARMV8_INCLUDE_EL2;

is exclude_hv a perf generic construct?

is it really correct to count everything the host kernel does (even
unrelated to running VMs) when counting hypervisor events?

Other than my ignorance in this area, this patch looks fine to me.

Thanks,
-Christoffer

> +	} else {
> +		if (attr->exclude_kernel)
> +			config_base |= ARMV8_EXCLUDE_EL1;
> +		if (!attr->exclude_hv)
> +			config_base |= ARMV8_INCLUDE_EL2;
> +	}
>  
>  	/*
>  	 * Install the filter into config_base as this is used to
> -- 
> 2.1.4
> 
