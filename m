Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241B2EC09B
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737668; cv=none; b=k+vsyQ4SRgqrTfdZ+AAGvfYnEy/gLCqegXc2ddD3bdffQG3/c8nUJznOpzJ6dQtYkNX8wTcgTTO04MG1HlqeytJpAZNImWUVB9HRlv11su/m8fIiPOEV43jtX3PJWb/2a4PwePnwyWEEzI40UQ+mGoBfs4H9oz/rdP1roP1VxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737668; c=relaxed/simple;
	bh=YF/ys+EZvnIwGaBdD2UoHiG9+XohBgFMfRlROTVTxFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkkCnzPrnOkPxJfp4wiysW53rS2DpCplHOFKJylRss+/CQo/zsLF3pEUXvAYvOWlEWLfb4m9zt9Gt95FzObTXsxEzdrciEz0GqPUfCq9c3OXO32qVJgD8F+bGqMtHcIp3l2DvxJgQv2oMg3egVUQOawHvujorZZwE8TqpFU1zJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFfSkC0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFfSkC0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA21C19424;
	Tue, 10 Feb 2026 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770737667;
	bh=YF/ys+EZvnIwGaBdD2UoHiG9+XohBgFMfRlROTVTxFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NFfSkC0pcIlaO+CUBldQvzlz4HT0fxbIjIju9fxIOi2lxEkdcVjMRyTwQYvmotB0N
	 rgGoJMGuO+ople3NkqFgogcOkqy9siqML988ZOYgFQv+KgdT7WlFgUMz4pNWfDC53L
	 En/HsAwMFYhY5HGV48BOFsQEJVE0zEa7QrnSLWGlOJ73l5QDa1UTXKupnbKZTcUBfi
	 UUFMRoVZjRnV9oMBu8hTwMYIwJ02j2dgK6OGOJpwqXnegEUzCyLoa76CrAHA8VKMFv
	 b+8tbtO9ABBWOrS5Gm4EObfRHsIkoUrKPQbElJ8hS7jWG6akdvBi7Zx5n16QIFa+rS
	 66TnUF7YCRzUQ==
Date: Tue, 10 Feb 2026 15:34:22 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com
Subject: Re: Broken udelay() on KVM host with a vcpu loaded
Message-ID: <aYtP_rgolLfm_UDD@willie-the-truck>
References: <ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od>
 <86qzqsbw1m.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qzqsbw1m.wl-maz@kernel.org>

On Tue, Feb 10, 2026 at 12:52:21PM +0000, Marc Zyngier wrote:
> On Tue, 10 Feb 2026 12:27:48 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Hi all,
> > 
> > I have just received a report from a partner of udelay misbehaving when
> > running on the host whilst a vCPU is loaded. This hardware has FEAT_WFxT
> > and uses the matching implementation of udelay. Interestingly, WFIT
> > triggers using CNTVCT_EL0 unconditionally, but with KVM the host/guest
> > switch for that happens from the preempt notifiers/vcpu_put which aren't
> > invoked when e.g. handling an IRQ. Interestingly, udelay reads the arch
> > timer to set the waiting time for WFIT using an absolute value, and that
> > gets compared to CNTVCT_EL0 which in the aforementioned
> > IRQ-with-vCPU-loaded case uses the _guest's_ CNTVCT_EL0.
> 
> Well, the underlying issue is that get_cycle(), as used by  __delay(),
> is *either* using CNTVCT_EL0 (when booted at EL1) or CNTPCT_EL0 (when
> booted at EL2).
> 
> > 
> > I can think of two approaches to address the problem:
> >   1. have KVM context switch cntvoff proactively prior to re-enabling
> >   preemption when handling a guest exit;
> >   2. modify the WFIT-based udelay implementation to read from CNTVCT_EL0
> >   instead of the arch_timer to be a bit more self-consitent;
> > 
> > Other ideas welcome!

I suppose a third option would be to avoid WFxT when we're on a CPU
with a vCPU loaded on it? The per-cpu state is grotty, mind. A bigger
hammer would be to use WFxT only when using VHE.

> (1) is a real nightmare, and would force a complete redesign of the
> life cycle of guest timers (switching from load/put to enter/exit for
> the context switch, but only on !VHE). I'd rather avoid that, as this
> is a pretty large performance penalty.
> 
> (2) is much more palatable, and easily hacked, see below. Can you
> please five it a go?
> 
> Thanks,
> 
> 	M.
> 
> From b1b45d591aed3e5276ff857dbc6cfa3bce181766 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Tue, 10 Feb 2026 12:43:07 +0000
> Subject: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
> 
> Quentin reports an interesting problem with the use of WFxT in __delay()
> when a vcpu is loaded and that KVM is *not* in VHE mode.
> 
> In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
> state of the guest virtual counter. At the same time, __delay() is
> using get_cycles() to read the counter value, which is indirected to
> reading CNTPCT_EL0.
> 
> The core of the issue is that WFxT is using the *virtual* counter,
> while the kernel is using the physical counter, and that the offset
> introduces a really bad discrepancy between the two.
> 
> Fix this by forcing the use of CNTVCT_EL0, making __delay() consistent
> irrespective of the value of CNTVOFF_EL2.
> 
> Reported-by: Quentin Perret <qperret@google.com>
> Fixes: 7d26b0516a0df ("arm64: Use WFxT for __delay() when possible")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/lib/delay.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index cb2062e7e2340..26a39bb301ef6 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -23,9 +23,16 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
>  	return (xloops * loops_per_jiffy * HZ) >> 32;
>  }
>  
> +/*
> + * Force the use of CNTVCT_EL0 in order to have the same base as
> + * WFxT. This avoids some annoying issues when CNTVOFF_EL2 is not
> + * reset 0 on a KVM host until we do a vcpu_put() on the vcpu.
> + */
> +#define __delay_cycles()	__arch_counter_get_cntvct_stable()
> +
>  void __delay(unsigned long cycles)
>  {
> -	cycles_t start = get_cycles();
> +	cycles_t start = __delay_cycles();
>  
>  	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
>  		u64 end = start + cycles;
> @@ -35,17 +42,17 @@ void __delay(unsigned long cycles)
>  		 * early, use a WFET loop to complete the delay.
>  		 */
>  		wfit(end);
> -		while ((get_cycles() - start) < cycles)
> +		while ((__delay_cycles() - start) < cycles)
>  			wfet(end);
>  	} else 	if (arch_timer_evtstrm_available()) {
>  		const cycles_t timer_evt_period =
>  			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
>  
> -		while ((get_cycles() - start + timer_evt_period) < cycles)
> +		while ((__delay_cycles() - start + timer_evt_period) < cycles)
>  			wfe();
>  	}
>  
> -	while ((get_cycles() - start) < cycles)
> +	while ((__delay_cycles() - start) < cycles)
>  		cpu_relax();

I can't put my finger on a specific bug, but it does feel pretty scary
to use the virtual counter in the host while running with a guest
voffset. Is the offset userspace controllable? If so, can we guarantee
that we're ok with overflow and is it ok if we get preempted in the
middle of the loop? It's making my head hurt!

The smp_cond_load_{relaxed,acquire}_timeout() series from Ankur looks
like it has the same issue (it uses arch_timer_read_counter()).

Will
