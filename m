Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821581ACECF
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675497; cv=none; b=Z/UxV1IlEv3lqO6nmA6hVMH7xDx2nhd2CST6oY/nMrVT9LSxXR8cvqR41ndf2Yr8d+LxB+RylALuEQaBM4lcM+Fp5V6j6cvUnnoPbpjZQ3GBulPF49AHLAiONmy6CvHwb7TMKTgEvB4TJaQPxxcSDnzaIdIzP7le5YKMZsFLcwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675497; c=relaxed/simple;
	bh=touKBY9UedlGapGcSpdPBG2IVcFm8n2X7CrGEsXrISQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/8Q1UkHvT2x4T1etuQbHfq9WjyLw9ro8qH+s+1CiGJOYszC6DgL2idVP/39/aG1ravP5BwIRQaB3TPcTJBNw5KdwKSHfyiCri6zirTtVEdaEakJhNAyYusIaxjvqTyoMiv+bxSzCI2EV18BrdG6iovwwC2uw81qnhDVIa/+3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72A6A153B;
	Thu, 27 Feb 2025 08:58:31 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9E773F5A1;
	Thu, 27 Feb 2025 08:58:14 -0800 (PST)
Date: Thu, 27 Feb 2025 16:58:12 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 3/7] arm64: micro-bench: fix timer IRQ
Message-ID: <Z8CZpNMWOYffln4b@raptor>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-4-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220141354.2565567-4-joey.gouly@arm.com>

Hi Joey,

On Thu, Feb 20, 2025 at 02:13:50PM +0000, Joey Gouly wrote:
> Enable the correct (hvtimer) IRQ when at EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/micro-bench.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 22408955..f47c5fc1 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -42,7 +42,7 @@ static void gic_irq_handler(struct pt_regs *regs)
>  	irq_received = true;
>  	gic_write_eoir(irqstat);
>  
> -	if (irqstat == TIMER_VTIMER_IRQ) {
> +	if (irqstat == TIMER_VTIMER_IRQ || irqstat == TIMER_HVTIMER_IRQ) {
>  		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
>  			     cntv_ctl_el0);
>  		isb();
> @@ -215,7 +215,11 @@ static bool timer_prep(void)
>  	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	local_irq_enable();
>  
> -	gic_enable_irq(TIMER_VTIMER_IRQ);
> +	if (current_level() == CurrentEL_EL1)
> +		gic_enable_irq(TIMER_VTIMER_IRQ);
> +	else
> +		gic_enable_irq(TIMER_HVTIMER_IRQ);
> +

Looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  
> -- 
> 2.25.1
> 
