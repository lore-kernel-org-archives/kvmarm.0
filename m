From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Fri, 13 Oct 2017 17:47:07 +0100
Message-ID: <20171013164706.GN19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
 <c28b3f0d-7beb-cca3-46db-3fce964f4725@arm.com>
 <20171012110409.GG19485@e103592.cambridge.arm.com>
 <d8a50bf1-bfe0-2423-c56b-adac3925309e@arm.com>
 <20171013141539.GK19485@e103592.cambridge.arm.com>
 <f273491e-2ae6-18b1-53de-6fbda2056631@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f273491e-2ae6-18b1-53de-6fbda2056631@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arch@vger.kernel.org, Christoffer Dall <cdall@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 13, 2017 at 03:21:59PM +0100, Marc Zyngier wrote:
> On 13/10/17 15:15, Dave Martin wrote:
> > On Thu, Oct 12, 2017 at 12:28:32PM +0100, Marc Zyngier wrote:
> >> On 12/10/17 12:04, Dave Martin wrote:
> >>> On Wed, Oct 11, 2017 at 05:28:06PM +0100, Marc Zyngier wrote:
> >>>> [+ Christoffer]
> >>>>
> >>>> On 10/10/17 19:38, Dave Martin wrote:

[...]

> >>>> Hmmm. How does this work if...
> >>>
> >>> !IS_ENABLED(CONFIG_ARM64_SVE) implies !system_supports_sve(), so
> >>> if CONFIG_ARM64_SVE is not set, the call is optimised away.
> >>>
> >>> [...]
> >>>
> >>>>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> >>>>> index a9cb794..6ae3703 100644
> >>>>> --- a/arch/arm64/kernel/fpsimd.c
> >>>>> +++ b/arch/arm64/kernel/fpsimd.c
> >>>>> @@ -1073,6 +1073,33 @@ void fpsimd_flush_task_state(struct task_struct *t)
> >>>
> >>> [...]
> >>>
> >>>>> +#ifdef CONFIG_ARM64_SVE
> >>>>> +void sve_flush_cpu_state(void)
> >>>>> +{
> >>>>> +	struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
> >>>>> +	struct task_struct *tsk;
> >>>>> +
> >>>>> +	if (!fpstate)
> >>>>> +		return;
> >>>>> +
> >>>>> +	tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
> >>>>> +	if (test_tsk_thread_flag(tsk, TIF_SVE))
> >>>>> +		fpsimd_flush_cpu_state();
> >>>>> +}
> >>>>> +#endif /* CONFIG_ARM64_SVE */
> >>>>
> >>>> ... CONFIG_ARM64_SVE is not set? Fixing this should just be a matter of
> >>>> moving the #ifdef/#endif inside the function...
> >>>
> >>> Because sve_flush_cpu_state() is not in the same compilation unit it
> >>> can't be static, and that means the compiler won't remove it
> >>> automatically if it's unused -- hence the #ifdef.
> >>>
> >>> Because the call site is optimised away, there is no link failure.
> >>>
> >>> Don't we rely on this sort of thing all over the place?
> >> Dunno. It just feels weird. But if you are sure that it won't break,
> >> fine by me. I guess we'll find out pretty quickly how this fares,
> >> specially with older toolchains.
> > 
> > I thought this was why the kernel doesn't support building with -O0.
> > There are many instances of this in the series, not just here.
> > 
> > Let me know if you feel this isn't good enough though.
> 
> That's OK to me. As I said, we'll find out pretty quickly if anything
> breaks unexpectedly.

Yup

> 
> > Do you have any other comments on this patch?
> None. You can add my:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

OK, thanks for the input.

Cheers
---Dave
