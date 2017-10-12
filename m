From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 13/28] arm64/sve: Signal handling support
Date: Thu, 12 Oct 2017 17:11:57 +0100
Message-ID: <20171012161156.GI19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-14-git-send-email-Dave.Martin@arm.com>
 <20171011164052.exvy2w5p47mewrmg@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011164052.exvy2w5p47mewrmg@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 11, 2017 at 05:40:52PM +0100, Catalin Marinas wrote:
> On Tue, Oct 10, 2017 at 07:38:30PM +0100, Dave P Martin wrote:
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index aabeaee..fa4ed34 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -310,6 +310,32 @@ static void fpsimd_to_sve(struct task_struct *task)
> >  		       sizeof(fst->vregs[i]));
> >  }
> >  
> > +/*
> > + * Transfer the SVE state in task->thread.sve_state to
> > + * task->thread.fpsimd_state.
> > + *
> > + * Task can be a non-runnable task, or current.  In the latter case,
> > + * softirqs (and preemption) must be disabled.
> > + * task->thread.sve_state must point to at least sve_state_size(task)
> > + * bytes of allocated kernel memory.
> > + * task->thread.sve_state must be up to date before calling this function.
> > + */
> > +static void sve_to_fpsimd(struct task_struct *task)
> > +{
> > +	unsigned int vq;
> > +	void const *sst = task->thread.sve_state;
> > +	struct fpsimd_state *fst = &task->thread.fpsimd_state;
> > +	unsigned int i;
> > +
> > +	if (!system_supports_sve())
> > +		return;
> > +
> > +	vq = sve_vq_from_vl(task->thread.sve_vl);
> > +	for (i = 0; i < 32; ++i)
> > +		memcpy(&fst->vregs[i], ZREG(sst, vq, i),
> > +		       sizeof(fst->vregs[i]));
> > +}
> 
> Nit: could we actually just do an assignment with some pointer casting?
> It looks like we invoke memcpy for every 16 bytes (same for
> fpsimd_to_sve).

I was uneasy about what the type of ZREG(sst, vq, i) ought to be.
In any case, memest() is magic: my oldskool GCC (5.3.0) generates:

ffff000008084c70 <sve_to_fpsimd>:
ffff000008084c70:       14000004        b       ffff000008084c80 <sve_to_fpsimd+0x10>
ffff000008084c74:       d503201f        nop
ffff000008084c78:       d65f03c0        ret
ffff000008084c7c:       d503201f        nop
ffff000008084c80:       f0007d61        adrp    x1, ffff000009033000 <reset_devices>
ffff000008084c84:       f942a021        ldr     x1, [x1,#1344]
ffff000008084c88:       36b001c1        tbz     w1, #22, ffff000008084cc0 <sve_to_fpsimd+0x50>
ffff000008084c8c:       b94ca805        ldr     w5, [x0,#3240]
ffff000008084c90:       912a0001        add     x1, x0, #0xa80
ffff000008084c94:       91320004        add     x4, x0, #0xc80
ffff000008084c98:       f9465006        ldr     x6, [x0,#3232]
ffff000008084c9c:       121c6ca5        and     w5, w5, #0xfffffff0
ffff000008084ca0:       52800000        mov     w0, #0x0                        // #0
ffff000008084ca4:       8b2040c2        add     x2, x6, w0, uxtw
ffff000008084ca8:       0b050000        add     w0, w0, w5
ffff000008084cac:       a9400c42        ldp     x2, x3, [x2]
ffff000008084cb0:       a8810c22        stp     x2, x3, [x1],#16
ffff000008084cb4:       eb01009f        cmp     x4, x1
ffff000008084cb8:       54ffff61        b.ne    ffff000008084ca4 <sve_to_fpsimd+0x34>
ffff000008084cbc:       d65f03c0        ret
ffff000008084cc0:       d65f03c0        ret
ffff000008084cc4:       d503201f        nop


Without volatile, I think assigning a single object and doing a memcpy()
are equivalent to the compiler: which it actually uses depends solely on
optimisation considerations.

(But then I'm not a language lawyer ... not a professional one anyway).


Are you concerned compilers may mess this up?

Cheers
---Dave
