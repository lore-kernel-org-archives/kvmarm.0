From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 23/23] arm64: Panic when VHE and non VHE CPUs coexist
Date: Mon, 8 Feb 2016 16:24:03 +0000
Message-ID: <20160208162402.GC14146@leverpostej>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-24-git-send-email-marc.zyngier@arm.com>
 <20160208160445.GS6076@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C6A49958
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 11:18:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DkpRSfPsmx7Z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 11:18:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F34149954
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 11:18:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20160208160445.GS6076@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 04:04:46PM +0000, Catalin Marinas wrote:
> On Wed, Feb 03, 2016 at 06:00:16PM +0000, Marc Zyngier wrote:
> > Having both VHE and non-VHE capable CPUs in the same system
> > is likely to be a recipe for disaster.
> > 
> > If the boot CPU has VHE, but a secondary is not, we won't be
> > able to downgrade and run the kernel at EL1. Add CPU hotplug
> > to the mix, and this produces a terrifying mess.
> > 
> > Let's solve the problem once and for all. If you mix VHE and
> > non-VHE CPUs in the same system, you deserve to loose, and this
> > patch makes sure you don't get a chance.
> > 
> > This is implemented by storing the kernel execution level in
> > a global variable. Secondaries will park themselves in a
> > WFI loop if they observe a mismatch. Also, the primary CPU
> > will detect that the secondary CPU has died on a mismatched
> > execution level. Panic will follow.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/include/asm/virt.h | 17 +++++++++++++++++
> >  arch/arm64/kernel/head.S      | 20 ++++++++++++++++++++
> >  arch/arm64/kernel/smp.c       |  3 +++
> >  3 files changed, 40 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> > index 9f22dd6..f81a345 100644
> > --- a/arch/arm64/include/asm/virt.h
> > +++ b/arch/arm64/include/asm/virt.h
> > @@ -36,6 +36,11 @@
> >   */
> >  extern u32 __boot_cpu_mode[2];
> >  
> > +/*
> > + * __run_cpu_mode records the mode the boot CPU uses for the kernel.
> > + */
> > +extern u32 __run_cpu_mode[2];
> > +
> >  void __hyp_set_vectors(phys_addr_t phys_vector_base);
> >  phys_addr_t __hyp_get_vectors(void);
> >  
> > @@ -60,6 +65,18 @@ static inline bool is_kernel_in_hyp_mode(void)
> >  	return el == CurrentEL_EL2;
> >  }
> >  
> > +static inline bool is_kernel_mode_mismatched(void)
> > +{
> > +	/*
> > +	 * A mismatched CPU will have written its own CurrentEL in
> > +	 * __run_cpu_mode[1] (initially set to zero) after failing to
> > +	 * match the value in __run_cpu_mode[0]. Thus, a non-zero
> > +	 * value in __run_cpu_mode[1] is enough to detect the
> > +	 * pathological case.
> > +	 */
> > +	return !!ACCESS_ONCE(__run_cpu_mode[1]);
> > +}
> > +
> >  /* The section containing the hypervisor text */
> >  extern char __hyp_text_start[];
> >  extern char __hyp_text_end[];
> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> > index 6f2f377..f9b6a5b 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> > @@ -578,7 +578,24 @@ ENTRY(set_cpu_boot_mode_flag)
> >  1:	str	w20, [x1]			// This CPU has booted in EL1
> >  	dmb	sy
> >  	dc	ivac, x1			// Invalidate potentially stale cache line
> > +	adr_l	x1, __run_cpu_mode
> > +	ldr	w0, [x1]
> > +	mrs	x20, CurrentEL
> > +	cbz	x0, skip_el_check
> > +	cmp	x0, x20
> > +	bne	mismatched_el
> >  	ret
> > +skip_el_check:			// Only the first CPU gets to set the rule
> > +	str	w20, [x1]
> > +	dmb	sy
> > +	dc	ivac, x1	// Invalidate potentially stale cache line
> > +	ret
> > +mismatched_el:
> > +	str	w20, [x1, #4]
> > +	dmb	sy
> > +	dc	ivac, x1	// Invalidate potentially stale cache line
> > +1:	wfi
> > +	b	1b
> >  ENDPROC(set_cpu_boot_mode_flag)
> 
> Do we need to wait for the D-cache maintenance completion before
> entering WFI (like issuing a DSB)? Same for the skip_el_check path
> before the RET.

We would need that to complete the maintenance, yes.

However, given we're going into WFI immediately afterwards, and not
signalling completion to other CPUs, what we gain is somewhat
questionable.

Perhaps it's always better to do the maintenance on the read side (for
consistency with [1]).

Regardless, we'd probably want a DSB to ensure the write had
completed...

Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/404661.html
