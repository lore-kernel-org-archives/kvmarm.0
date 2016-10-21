From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 07/10] arm/arm64: add
 initial gicv3 support
Date: Fri, 21 Oct 2016 14:49:24 +0200
Message-ID: <20161021124924.lv6ebl5u44ntnjtg@kamzik.brq.redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-8-git-send-email-drjones@redhat.com>
 <0b1de847-a402-b816-a01d-c4bdcd248e75@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED09449B35
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 08:39:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J983uU1j4uF7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 08:39:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB90F49B32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 08:39:01 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <0b1de847-a402-b816-a01d-c4bdcd248e75@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Hi Andre,

On Thu, Oct 20, 2016 at 06:29:01PM +0100, Andre Przywara wrote:
> Hi Drew,
> 
> On 15/07/16 14:00, Andrew Jones wrote:
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > v2: configure irqs as NS GRP1
> > ---
> >  lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++++++
> >  lib/arm/asm/gic-v3.h       | 321 +++++++++++++++++++++++++++++++++++++++++++++
> >  lib/arm/asm/gic.h          |   1 +
> >  lib/arm/gic.c              |  73 +++++++++++
> >  lib/arm64/asm/arch_gicv3.h | 169 ++++++++++++++++++++++++
> >  lib/arm64/asm/gic-v3.h     |   1 +
> >  lib/arm64/asm/sysreg.h     |  44 +++++++
> >  7 files changed, 793 insertions(+)
> >  create mode 100644 lib/arm/asm/arch_gicv3.h
> >  create mode 100644 lib/arm/asm/gic-v3.h
> >  create mode 100644 lib/arm64/asm/arch_gicv3.h
> >  create mode 100644 lib/arm64/asm/gic-v3.h
> >  create mode 100644 lib/arm64/asm/sysreg.h
> > 
> > diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> > new file mode 100644
> > index 0000000000000..d529a7eb62807
> > --- /dev/null
> > +++ b/lib/arm/asm/arch_gicv3.h
> > @@ -0,0 +1,184 @@
> > +/*
> > + * All ripped off from arch/arm/include/asm/arch_gicv3.h
> 
> So I was wondering if - from a test suite's perspective - it's really
> clever to pull in copies of Linux headers here.
> First it's really a lot of text we pull in while not using most of it
> (at least now). Also they keep changing (4.9-rc1 saw so me changes, for
> instance). So do we update them?

The thought was we'd synchronize occasionally as needed. If somebody
adds new gic tests that require new defines, then they'd just synch
everything. I agree it's less than ideal to try and maintain duplicate
copies of stuff though.

> 
> But more importantly those headers are also used in the emulation code,
> so we would just copy any bugs or typos and would probably not detect
> them here. IIRC there was a fix for a bitmask lately.

This is certainly a bigger concern. Duplicating blindly would indeed
just copy bugs. OTOH, I found a couple of bitmask bugs in the kernel
precisely because I was reviewing them while duplicating. I think I
agree with you though that we should be extra cautious with macros,
and even have the spec open to confirm register offsets aren't wrong
while copying.

> It's probably fine to copy the register offsets, but anything that
> defines Linux specific things like default priorities or more complex
> macros should be avoided, I think. This just makes kvm-unit-test copying
> Linux behaviour.

I agree the Linux defaults should not be the only inputs kvm-unit-tests
uses. That was never the plan. In this series I've introduced
gicv[23]_enable_defaults, which do indeed mimic Linux (but with much
simplification). They serve two purposes, 1) I can confirm the framework
works as least as well as Linux in order to provide a solid base for
new tests and 2) unit tests that need a gic, but don't plan to test it
specifically, and thus don't care much about how it's enabled, can use
these enable functions just to get a functioning one. However, gic unit
test writers (like you :-) should only use gic_init(), which does nothing
other than probe DT for the base addresses.

> 
> Maybe we stick to the Linux naming, but pull in only the fields as we
> need them? This would both limit the amount of lines being merged, as
> would simplify the review effort (and quality), as people would just
> need to look at a very limited number of defines, allowing them to
> actually check it against the specification?

It's a similar idea to what we were going to do - synchronizing as we
go, but instead of seeding the file with everything Linux has today we
only seed it with what we use today. If, however, somebody writes the
test Christoffer and you both proposed independently, which is to write
all registers and then read them all back to make sure they have the
expected values after considering their behaviors, then we'll be
importing nearly all register defines at once anyway. That said, we
haven't written that test yet, so I can live with this initial series
only taking what it needs.

> 
> I gave this a try and could reduce the header files significantly.
> Please let me know if you need any bits from this effort to be shared.

Yes please. I'll take your advise on this and post with minimal defines
for now. Do you have patches that apply to my branch? If so, I'll
integrate them for the v4 posting.

> 
> > + *
> > + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> > + */
> > +#ifndef _ASMARM_ARCH_GICV3_H_
> > +#define _ASMARM_ARCH_GICV3_H_
> > +
> > +#ifndef __ASSEMBLY__
> > +
> > +#include <libcflat.h>
> > +#include <asm/barrier.h>
> > +#include <asm/io.h>
> > +
> > +#define __stringify xstr
> > +
> > +
> > +#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
> > +#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
> > +
> > +#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
> > +#define ICC_DIR				__ACCESS_CP15(c12, 0, c11, 1)
> > +#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
> > +#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
> > +#define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
> > +#define ICC_CTLR			__ACCESS_CP15(c12, 0, c12, 4)
> > +#define ICC_SRE				__ACCESS_CP15(c12, 0, c12, 5)
> > +#define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
> > +
> > +#define ICC_HSRE			__ACCESS_CP15(c12, 4, c9, 5)
> > +
> > +#define ICH_VSEIR			__ACCESS_CP15(c12, 4, c9, 4)
> > +#define ICH_HCR				__ACCESS_CP15(c12, 4, c11, 0)
> > +#define ICH_VTR				__ACCESS_CP15(c12, 4, c11, 1)
> > +#define ICH_MISR			__ACCESS_CP15(c12, 4, c11, 2)
> > +#define ICH_EISR			__ACCESS_CP15(c12, 4, c11, 3)
> > +#define ICH_ELSR			__ACCESS_CP15(c12, 4, c11, 5)
> > +#define ICH_VMCR			__ACCESS_CP15(c12, 4, c11, 7)
> > +
> > +#define __LR0(x)			__ACCESS_CP15(c12, 4, c12, x)
> > +#define __LR8(x)			__ACCESS_CP15(c12, 4, c13, x)
> 
> So for instance we clearly don't need those defines (the list registers
> being hypervisor only).
> 
> > +
> > +#define ICH_LR0				__LR0(0)
> > +#define ICH_LR1				__LR0(1)
> > +#define ICH_LR2				__LR0(2)
> > +#define ICH_LR3				__LR0(3)
> > +#define ICH_LR4				__LR0(4)
> > +#define ICH_LR5				__LR0(5)
> > +#define ICH_LR6				__LR0(6)
> > +#define ICH_LR7				__LR0(7)
> > +#define ICH_LR8				__LR8(0)
> > +#define ICH_LR9				__LR8(1)
> > +#define ICH_LR10			__LR8(2)
> > +#define ICH_LR11			__LR8(3)
> > +#define ICH_LR12			__LR8(4)
> > +#define ICH_LR13			__LR8(5)
> > +#define ICH_LR14			__LR8(6)
> > +#define ICH_LR15			__LR8(7)
> > +
> > +/* LR top half */
> > +#define __LRC0(x)			__ACCESS_CP15(c12, 4, c14, x)
> > +#define __LRC8(x)			__ACCESS_CP15(c12, 4, c15, x)
> > +
> > +#define ICH_LRC0			__LRC0(0)
> > +#define ICH_LRC1			__LRC0(1)
> > +#define ICH_LRC2			__LRC0(2)
> > +#define ICH_LRC3			__LRC0(3)
> > +#define ICH_LRC4			__LRC0(4)
> > +#define ICH_LRC5			__LRC0(5)
> > +#define ICH_LRC6			__LRC0(6)
> > +#define ICH_LRC7			__LRC0(7)
> > +#define ICH_LRC8			__LRC8(0)
> > +#define ICH_LRC9			__LRC8(1)
> > +#define ICH_LRC10			__LRC8(2)
> > +#define ICH_LRC11			__LRC8(3)
> > +#define ICH_LRC12			__LRC8(4)
> > +#define ICH_LRC13			__LRC8(5)
> > +#define ICH_LRC14			__LRC8(6)
> > +#define ICH_LRC15			__LRC8(7)
> 
> ....
> > +
> > +/*
> > + * Cavium ThunderX erratum 23154
> > + *
> > + * The gicv3 of ThunderX requires a modified version for reading the
> > + * IAR status to ensure data synchronization (access to icc_iar1_el1
> > + * is not sync'ed before and after).
> > + */
> > +static inline u64 gicv3_read_iar_cavium_thunderx(void)
> 
> Are we looking at including those errata workarounds?
> I think this may be needed if we want to run tests on those machines,
> but may open up a can of worms....

We can drop these erratas for now, and then add them as necessary. I
wouldn't want kvm-unit-tests to discriminate hardware though.

Thanks for looking at this!

drew
