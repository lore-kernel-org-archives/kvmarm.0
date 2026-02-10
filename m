Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF8438553D
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770739101; cv=none; b=einZtB3lD+z4f3QQywugUMihyO6woAR+j+TZZVS4KRXoZB5YGw/t2u9y2eSPoEiVMmo0rxQPq9Ug0xCR5yWeoQI1N7aMRxWvzjKq/ncxSE3hIpNvvhJMQ1NdEcDozofBcrtHqnz2GHuMhV+MU434R5Ns4uXuE+MWH5aAUmMKp5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770739101; c=relaxed/simple;
	bh=k066NWiBGjrC32wdnhVRStq7fRb2ByKNr7u/pC3VWKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqLO0s+bX0g5URUD3MyopA9urfjpM0tZk8rybOLjy1dfeLiVD/v681lR85irRPTCdpLX6fPt3ydxrfBaZdOWjWB63VFNH/gfFsjV0DKH7YsVBOEqE5T3i9po+JucHMhGpaq09c0oQe9cqxMEuEmp1/mLt3iS6C2VIaEJC+6fFMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4XNLNdIp; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4XNLNdIp"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-383122fbc9bso49666611fa.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770739098; x=1771343898; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0NBVBPVKCHxe9+RzT9q+YHkvlWYmf8ND5x6dqt+onUw=;
        b=4XNLNdIp6Z5zWD61ZEjd6blyepV9pvr4wlSmBcPXnpE9l780qb675FCe2KL7VXfvJW
         x8kEVk18Rdr4YEo3g3qkz+oJB4eUm/geDmkvYUJaLicCaWVB6sAgYQOTvuEse48aaHEG
         Ont8HLB95WhaXhMZHIAbSTKF50v1e8odVAxjPNoAqVxmMWysA+affwh/aR4Mc+mKOrGe
         CjRv0eCUpdVYJ9mdS1MpRddtbGnF0Wwu9YryWDHYHtBQL+cgY/xPtKWhB863ZL4jDQi8
         5jpRBp5wEUhm2BzqAeD8eluX3BPxx7bZIE96TC0sEDv1zYtZ/BgSCz7r7kj2AA3tbBtS
         URiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770739098; x=1771343898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0NBVBPVKCHxe9+RzT9q+YHkvlWYmf8ND5x6dqt+onUw=;
        b=Z+7VVIdSZVctQCCkVpwSVQmvBpkm8bCC+DLe2D96qpU1GKvCj2oR/Qq4J5DNtFlRBf
         A5BMK3OIharHauhwrua1WZZHafJ4I6JL8u65tNvu5GVLWQHGEiJRF9BRxL8p8nw6QfHA
         PU3c04S9Nwj+zHvtj5RYgQj0CUU14Ohd1DBr37IFufaPOLC5Kv8PcMMnUzUOvQhGKfmK
         YFsTSKXK2SH6x9LVoewDXfSliZCxiM0wSdTZQFjC56vwYqDjhH3Uzbsi7e8ETFg6GMZ+
         VDNPQAMZP5CNHoadkojDgNwEVyXK7vL6w6mUtilVhPoV7YRmXWgb9qntwkBwqElwEUd7
         Cacg==
X-Forwarded-Encrypted: i=1; AJvYcCXfzNAIAakdJGDaqgMYbTtBMHhhf01yNF3ePLFZU++LSHeYS7vArHUW9mwSynGiWCDLulffcjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYC1KW7/OeZUN9RPQi8Rq0xmBitt6QDyjmpS/hcFznZfubgpkx
	AK3qnIUDbAnCjQU+juYB9b4+IACF6E+YP0BmXI4SR8OSoNYJTtflxS3d2nduS2HYKA==
X-Gm-Gg: AZuq6aKkN0O1ag/v2sRro8G9/jyZWztm0YlnjmOmyWwApNZITD+kzyOTZE/436luBs4
	IM2konmmi+P1UlBDLg3zgH/5i27Ia2ZAduYy2F4s7WWxHP3+S5NtaVprisgR9ViuvBBWjDkjaD0
	kD3RPmXcRGJ1iZrNNnT4f1tFL2r1dMvaXJjhvl2gf0YchQJISH933bmyQQIWxwduAHaR8KGxH4J
	laINEwPaILLQvIOAH2kIs5xw/ntrgbvYYxCsn3tr2f51QcIuoCgt4HjSyFghoopes6zD4LpJyue
	IWxcKn+NonkfxxRK80GngkekmVEtN/L94DeIlqXR7x3P2KVLkm9ULCQ4m5m88HRebgdUzWHGXin
	OffoGWQ9O4EuDYz2WoH9YfmsS3ZeECU3wGcUT87PmIktSmdI8JqvEcAofhaQFkFpWpUC2P1YLDs
	jC+8HexFmwFodWp0tCufACusJg9V67BRm/tNOj/h5sGlyv++fj1KzHbrWuTY02+UDglWbZ
X-Received: by 2002:a05:651c:2117:b0:383:2537:f135 with SMTP id 38308e7fff4ca-386eefb4c67mr9602531fa.21.1770739097580;
        Tue, 10 Feb 2026 07:58:17 -0800 (PST)
Received: from google.com (133.23.88.34.bc.googleusercontent.com. [34.88.23.133])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-386b62921f6sm30286331fa.22.2026.02.10.07.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:58:17 -0800 (PST)
Date: Tue, 10 Feb 2026 15:58:14 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com
Subject: Re: Broken udelay() on KVM host with a vcpu loaded
Message-ID: <motrqsddhooajk66sq75dt74huvxmwtreoznwc6yjqirit36bl@2mlt2546mjnp>
References: <ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od>
 <86qzqsbw1m.wl-maz@kernel.org>
 <aYtP_rgolLfm_UDD@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtP_rgolLfm_UDD@willie-the-truck>

On Tuesday 10 Feb 2026 at 15:34:22 (+0000), Will Deacon wrote:
> On Tue, Feb 10, 2026 at 12:52:21PM +0000, Marc Zyngier wrote:
> > On Tue, 10 Feb 2026 12:27:48 +0000,
> > Quentin Perret <qperret@google.com> wrote:
> > > 
> > > Hi all,
> > > 
> > > I have just received a report from a partner of udelay misbehaving when
> > > running on the host whilst a vCPU is loaded. This hardware has FEAT_WFxT
> > > and uses the matching implementation of udelay. Interestingly, WFIT
> > > triggers using CNTVCT_EL0 unconditionally, but with KVM the host/guest
> > > switch for that happens from the preempt notifiers/vcpu_put which aren't
> > > invoked when e.g. handling an IRQ. Interestingly, udelay reads the arch
> > > timer to set the waiting time for WFIT using an absolute value, and that
> > > gets compared to CNTVCT_EL0 which in the aforementioned
> > > IRQ-with-vCPU-loaded case uses the _guest's_ CNTVCT_EL0.
> > 
> > Well, the underlying issue is that get_cycle(), as used by  __delay(),
> > is *either* using CNTVCT_EL0 (when booted at EL1) or CNTPCT_EL0 (when
> > booted at EL2).
> > 
> > > 
> > > I can think of two approaches to address the problem:
> > >   1. have KVM context switch cntvoff proactively prior to re-enabling
> > >   preemption when handling a guest exit;
> > >   2. modify the WFIT-based udelay implementation to read from CNTVCT_EL0
> > >   instead of the arch_timer to be a bit more self-consitent;
> > > 
> > > Other ideas welcome!
> 
> I suppose a third option would be to avoid WFxT when we're on a CPU
> with a vCPU loaded on it? The per-cpu state is grotty, mind.

It's one of the rare cases where we could look at that per-cpu data in
preemptible context, because that per-cpu state would migrate with the
task if it were migrated to a different CPU thanks to the preempt
notifiers, so that's nice.

> A bigger hammer would be to use WFxT only when using VHE.
> 
> > (1) is a real nightmare, and would force a complete redesign of the
> > life cycle of guest timers (switching from load/put to enter/exit for
> > the context switch, but only on !VHE). I'd rather avoid that, as this
> > is a pretty large performance penalty.
> > 
> > (2) is much more palatable, and easily hacked, see below. Can you
> > please five it a go?
> > 
> > Thanks,
> > 
> > 	M.
> > 
> > From b1b45d591aed3e5276ff857dbc6cfa3bce181766 Mon Sep 17 00:00:00 2001
> > From: Marc Zyngier <maz@kernel.org>
> > Date: Tue, 10 Feb 2026 12:43:07 +0000
> > Subject: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
> > 
> > Quentin reports an interesting problem with the use of WFxT in __delay()
> > when a vcpu is loaded and that KVM is *not* in VHE mode.
> > 
> > In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
> > state of the guest virtual counter. At the same time, __delay() is
> > using get_cycles() to read the counter value, which is indirected to
> > reading CNTPCT_EL0.
> > 
> > The core of the issue is that WFxT is using the *virtual* counter,
> > while the kernel is using the physical counter, and that the offset
> > introduces a really bad discrepancy between the two.
> > 
> > Fix this by forcing the use of CNTVCT_EL0, making __delay() consistent
> > irrespective of the value of CNTVOFF_EL2.
> > 
> > Reported-by: Quentin Perret <qperret@google.com>
> > Fixes: 7d26b0516a0df ("arm64: Use WFxT for __delay() when possible")
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/arm64/lib/delay.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> > index cb2062e7e2340..26a39bb301ef6 100644
> > --- a/arch/arm64/lib/delay.c
> > +++ b/arch/arm64/lib/delay.c
> > @@ -23,9 +23,16 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
> >  	return (xloops * loops_per_jiffy * HZ) >> 32;
> >  }
> >  
> > +/*
> > + * Force the use of CNTVCT_EL0 in order to have the same base as
> > + * WFxT. This avoids some annoying issues when CNTVOFF_EL2 is not
> > + * reset 0 on a KVM host until we do a vcpu_put() on the vcpu.
> > + */
> > +#define __delay_cycles()	__arch_counter_get_cntvct_stable()
> > +
> >  void __delay(unsigned long cycles)
> >  {
> > -	cycles_t start = get_cycles();
> > +	cycles_t start = __delay_cycles();
> >  
> >  	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
> >  		u64 end = start + cycles;
> > @@ -35,17 +42,17 @@ void __delay(unsigned long cycles)
> >  		 * early, use a WFET loop to complete the delay.
> >  		 */
> >  		wfit(end);
> > -		while ((get_cycles() - start) < cycles)
> > +		while ((__delay_cycles() - start) < cycles)
> >  			wfet(end);
> >  	} else 	if (arch_timer_evtstrm_available()) {
> >  		const cycles_t timer_evt_period =
> >  			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
> >  
> > -		while ((get_cycles() - start + timer_evt_period) < cycles)
> > +		while ((__delay_cycles() - start + timer_evt_period) < cycles)
> >  			wfe();
> >  	}
> >  
> > -	while ((get_cycles() - start) < cycles)
> > +	while ((__delay_cycles() - start) < cycles)
> >  		cpu_relax();
> 
> I can't put my finger on a specific bug, but it does feel pretty scary
> to use the virtual counter in the host while running with a guest
> voffset. Is the offset userspace controllable? If so, can we guarantee
> that we're ok with overflow and is it ok if we get preempted in the
> middle of the loop? It's making my head hurt!

Ouch, it does seem that the SET_ONE_REG stuff allows to mess with that
value _out of vcpu context_, so yeah userspace could change the value
while a vcpu thread is preempted in the middle of a udelay loop ...

> The smp_cond_load_{relaxed,acquire}_timeout() series from Ankur looks
> like it has the same issue (it uses arch_timer_read_counter()).
> 
> Will
