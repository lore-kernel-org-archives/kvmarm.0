From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCH kvm-unit-tests v8 03/10] arm/arm64: add some
 delay routines
Date: Fri, 9 Dec 2016 13:15:41 +0100
Message-ID: <20161209121541.i3advgnpbu5gvoft@hawk.localdomain>
References: <20161208175030.12269-1-drjones@redhat.com>
 <20161208175030.12269-4-drjones@redhat.com>
 <dfb48863-82a7-3bd2-d2dc-498570325970@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfb48863-82a7-3bd2-d2dc-498570325970@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 09, 2016 at 11:41:06AM +0000, Andre Przywara wrote:
> Hi,
> 
> On 08/12/16 17:50, Andrew Jones wrote:
> > Allow a thread to wait some specified amount of time. Can
> > specify in cycles, usecs, and msecs.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > v8: rewrote basing on new sysreg framework. Also decided delay
> >     functions warrant their own files (delay.[ch])
> > ---
> >  arm/Makefile.common       |  1 +
> >  lib/arm/asm/delay.h       | 14 ++++++++++++++
> >  lib/arm/asm/processor.h   | 15 +++++++++++++++
> >  lib/arm64/asm/delay.h     |  1 +
> >  lib/arm64/asm/processor.h | 12 ++++++++++++
> >  lib/arm/delay.c           | 29 +++++++++++++++++++++++++++++
> >  6 files changed, 72 insertions(+)
> >  create mode 100644 lib/arm/asm/delay.h
> >  create mode 100644 lib/arm64/asm/delay.h
> >  create mode 100644 lib/arm/delay.c
> > 
> > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > index b2c0fc8a2fdc..89fe3f69eb44 100644
> > --- a/arm/Makefile.common
> > +++ b/arm/Makefile.common
> > @@ -48,6 +48,7 @@ cflatobjs += lib/arm/mmu.o
> >  cflatobjs += lib/arm/bitops.o
> >  cflatobjs += lib/arm/psci.o
> >  cflatobjs += lib/arm/smp.o
> > +cflatobjs += lib/arm/delay.o
> >  
> >  libeabi = lib/arm/libeabi.a
> >  eabiobjs = lib/arm/eabi_compat.o
> > diff --git a/lib/arm/asm/delay.h b/lib/arm/asm/delay.h
> > new file mode 100644
> > index 000000000000..2436b28c77ae
> > --- /dev/null
> > +++ b/lib/arm/asm/delay.h
> > @@ -0,0 +1,14 @@
> > +#ifndef _ASMARM_DELAY_H_
> > +#define _ASMARM_DELAY_H_
> > +/*
> > + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> > + */
> > +#include <libcflat.h>
> > +
> > +extern void delay(u64 cycles);
> 
> Nit: Shouldn't this parameter be called "ticks"? Cycles might be a bit
> misleading, especially since this prototype is the only documentation on
> this. You might just want to fix this when applying the patches.

Right or wrong the kernel uses 'cycles' for this function, named
__timer_delay for arm and __delay for arm64. I guess I prefer
consistency here.

> 
> That notwithstanding:
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks!

drew
