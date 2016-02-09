From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 23/23] arm64: Panic when VHE and non VHE CPUs coexist
Date: Tue, 9 Feb 2016 12:02:17 +0000
Message-ID: <20160209120217.GE16122@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-24-git-send-email-marc.zyngier@arm.com>
 <20160208160445.GS6076@e104818-lin.cambridge.arm.com>
 <20160208162402.GC14146@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7FC499FF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 06:56:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Jwj2r+at9Ca for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 06:56:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5945B499FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 06:56:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20160208162402.GC14146@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 04:24:03PM +0000, Mark Rutland wrote:
> On Mon, Feb 08, 2016 at 04:04:46PM +0000, Catalin Marinas wrote:
> > On Wed, Feb 03, 2016 at 06:00:16PM +0000, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> > > index 6f2f377..f9b6a5b 100644
> > > --- a/arch/arm64/kernel/head.S
> > > +++ b/arch/arm64/kernel/head.S
> > > @@ -578,7 +578,24 @@ ENTRY(set_cpu_boot_mode_flag)
> > >  1:	str	w20, [x1]			// This CPU has booted in EL1
> > >  	dmb	sy
> > >  	dc	ivac, x1			// Invalidate potentially stale cache line
> > > +	adr_l	x1, __run_cpu_mode
> > > +	ldr	w0, [x1]
> > > +	mrs	x20, CurrentEL
> > > +	cbz	x0, skip_el_check
> > > +	cmp	x0, x20
> > > +	bne	mismatched_el
> > >  	ret
> > > +skip_el_check:			// Only the first CPU gets to set the rule
> > > +	str	w20, [x1]
> > > +	dmb	sy
> > > +	dc	ivac, x1	// Invalidate potentially stale cache line
> > > +	ret
> > > +mismatched_el:
> > > +	str	w20, [x1, #4]
> > > +	dmb	sy
> > > +	dc	ivac, x1	// Invalidate potentially stale cache line
> > > +1:	wfi
> > > +	b	1b
> > >  ENDPROC(set_cpu_boot_mode_flag)
> > 
> > Do we need to wait for the D-cache maintenance completion before
> > entering WFI (like issuing a DSB)? Same for the skip_el_check path
> > before the RET.
> 
> We would need that to complete the maintenance, yes.
> 
> However, given we're going into WFI immediately afterwards, and not
> signalling completion to other CPUs, what we gain is somewhat
> questionable.
> 
> Perhaps it's always better to do the maintenance on the read side (for
> consistency with [1]).
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/404661.html

While [1] looks clearer to me, it seems that it is not consistent with
the rest of the head.S file. Maybe we can clean them up as a separate
patch and leave the dc ivac here. We also seem to miss barriers in other
similar situations in head.S.

-- 
Catalin
