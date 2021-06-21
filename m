Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124B3C48BC2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 16:18:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89F9761357
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 16:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89F9761357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E1A4079D;
	Mon, 21 Jun 2021 12:18:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 99eJGiE78QrA; Mon, 21 Jun 2021 12:18:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD44440617;
	Mon, 21 Jun 2021 12:18:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE93640623
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 12:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XY-ofj0N19-Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 12:18:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D3840256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 12:18:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBB921042;
 Mon, 21 Jun 2021 09:18:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 694C53F694;
 Mon, 21 Jun 2021 09:18:45 -0700 (PDT)
Subject: Re: [PATCH v4 7/9] KVM: arm64: timer: Refactor IRQ configuration
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210601104005.81332-1-maz@kernel.org>
 <20210601104005.81332-8-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <92a66e4a-a9bf-1568-5af8-7b2ecbb77661@arm.com>
Date: Mon, 21 Jun 2021 17:19:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-8-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 6/1/21 11:40 AM, Marc Zyngier wrote:
> As we are about to add some more things to the timer IRQ
> configuration, move this code out of the main timer init code
> into its own set of functions.
>
> No functional changes.

That looks to be the case for me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 57 +++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e2288b6bf435..3cd170388d88 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -973,6 +973,35 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
> +{
> +	*flags = irq_get_trigger_type(virq);
> +	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
> +		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
> +			virq);
> +		*flags = IRQF_TRIGGER_LOW;
> +	}
> +}
> +
> +static int kvm_irq_init(struct arch_timer_kvm_info *info)
> +{
> +	if (info->virtual_irq <= 0) {
> +		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> +			info->virtual_irq);
> +		return -ENODEV;
> +	}
> +
> +	host_vtimer_irq = info->virtual_irq;
> +	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
> +
> +	if (info->physical_irq > 0) {
> +		host_ptimer_irq = info->physical_irq;
> +		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
> +	}
> +
> +	return 0;
> +}
> +
>  int kvm_timer_hyp_init(bool has_gic)
>  {
>  	struct arch_timer_kvm_info *info;
> @@ -986,22 +1015,11 @@ int kvm_timer_hyp_init(bool has_gic)
>  		return -ENODEV;
>  	}
>  
> -	/* First, do the virtual EL1 timer irq */
> -
> -	if (info->virtual_irq <= 0) {
> -		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> -			info->virtual_irq);
> -		return -ENODEV;
> -	}
> -	host_vtimer_irq = info->virtual_irq;
> +	err = kvm_irq_init(info);
> +	if (err)
> +		return err;
>  
> -	host_vtimer_irq_flags = irq_get_trigger_type(host_vtimer_irq);
> -	if (host_vtimer_irq_flags != IRQF_TRIGGER_HIGH &&
> -	    host_vtimer_irq_flags != IRQF_TRIGGER_LOW) {
> -		kvm_err("Invalid trigger for vtimer IRQ%d, assuming level low\n",
> -			host_vtimer_irq);
> -		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
> -	}
> +	/* First, do the virtual EL1 timer irq */
>  
>  	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
>  				 "kvm guest vtimer", kvm_get_running_vcpus());
> @@ -1027,15 +1045,6 @@ int kvm_timer_hyp_init(bool has_gic)
>  	/* Now let's do the physical EL1 timer irq */
>  
>  	if (info->physical_irq > 0) {
> -		host_ptimer_irq = info->physical_irq;
> -		host_ptimer_irq_flags = irq_get_trigger_type(host_ptimer_irq);
> -		if (host_ptimer_irq_flags != IRQF_TRIGGER_HIGH &&
> -		    host_ptimer_irq_flags != IRQF_TRIGGER_LOW) {
> -			kvm_err("Invalid trigger for ptimer IRQ%d, assuming level low\n",
> -				host_ptimer_irq);
> -			host_ptimer_irq_flags = IRQF_TRIGGER_LOW;
> -		}
> -
>  		err = request_percpu_irq(host_ptimer_irq, kvm_arch_timer_handler,
>  					 "kvm guest ptimer", kvm_get_running_vcpus());
>  		if (err) {
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
