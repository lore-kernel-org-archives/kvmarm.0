Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ED92567
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 08:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A069C433EF;
	Tue, 13 Dec 2022 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670920681;
	bh=FJu05SvHQlikwwMqoKZXjpViOUNu+6vP0hnnSOgnqIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z/TI21lC0GDf41xSnJoUsSX8+spGl7St9pSFcQm3V+GsfyFj9d8lftlM5gbk2YDtI
	 x8BxuxKc1QOyTtE57xHH7GBpeTM/6KYKjw8npyMkGAewpk84RSaSGxxpCqyeGqwx8U
	 ELFC4tGajyoW1yFmEX4MEASBoEi770LKTPaySBGInsVnI3kGlnAJln6gp24UTAljmE
	 77dZPnN6Wx26KFzO1ReBl7g7MFzjMpN1ZmKujA9peE8hS0msAL41dtg3hhdhO/IEEu
	 z+6G+60FoIA/IHY/JyEMhAKUIo+QL8KsvNplrcJcwWYJjAmKJ18zblCqMSaeL286HT
	 q3w5U8xCfxdwg==
Date: Tue, 13 Dec 2022 09:37:56 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y5g55A3N9rXmS4LK@lpieralisi>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
 <Y5IchpFrIB3y8575@lpieralisi>
 <Y5c0tW7sidPE0oxd@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5c0tW7sidPE0oxd@sirena.org.uk>

On Mon, Dec 12, 2022 at 02:03:33PM +0000, Mark Brown wrote:
> On Thu, Dec 08, 2022 at 06:19:02PM +0100, Lorenzo Pieralisi wrote:
> 
> > I think I found a nasty spot. We are currently not handling ALLINT in
> > arch_local_irq_enable/disable(). The issue I am facing is that we might
> > end up preempting in IRQ context with ALLINT set in the exception path
> > - arm64_preempt_schedule_irq() - which means we are running with all
> > IRQs masked (that's normal; what's not normal is that local_irq_enable()
> > does not clear ALLINT, see below).
> 
> Right, and handling ALLINT in arch_local_irq_enable/disable() isn't
> exactly ideal since it means that whenever we mask interrupts we also
> mask NMIs which somewhat reduces the value.

Understood but ALLINT should be cleared before scheduling on the
exception path that leads to preemption - where it is done to
be seen.

> > When we schedule (preempt_schedule_irq()) we do require a
> > local_irq_enable() to enable IRQs; ALLINT is still set, so
> > local_irq_enable() does not do what is expected so we are calling
> > __schedule() with IRQs disabled, which does not seem right.
> 
> > Now we need to debate what the fix for this can be but nonetheless
> > it is something to be addressed.
> 
> A first pass suggests that we should be handling this like we do for
> other preemptions and returning early from arm64_preempt_schedule_irq()
> if ALLINT is masked.  If we are handling a regular IRQ then ALLINT will
> be unmasked and we'll call into preempt_schedule_irq(), if we're
> handling a NMI then ALLINT will still be masked so we don't attempt to
> schedule.  I've pushed out a change which does this but not yet properly
> tested it.

Yes that's what should happen (actually if we are handling an NMI we
should not even get to the point where a decision about preemption is
made el1_interrupt() just returns).

> > Clearing and setting ALLINT in arch_local_irq_enable()/disable()
> > seems to solve the issue (now I moved on to debugging something
> > else, will post the outcome here because this fix does not seem
> > to fix the issue completely or I am hitting another bug).
> 
> Do you have any specifics on how you're seeing problems?  You did
> mention boot stalls offline but I've not been able to to reproduce this
> locally in a way that I can identify (based on your mail now I've made
> sure I've got preemption enabled).

defconfig, barebone rootfs, boot stalls (because we are scheduling with
IRQs off and there is nothing clearing ALLINT in the preemption path
so system hangs).

I don't know why you can't reproduce it don't know if it is the Kconfig
or file system configuration (or the FVP params - for this to show up
FEAT_NMI must obviously be enabled - I am testing the branch Marc posted
so that I can test the vGIC patches but this is definitely not a vGIC
bug).

Thanks,
Lorenzo
