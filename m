From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Wed, 14 Nov 2018 18:11:39 +0000
Message-ID: <20181114181138.GB2580@brain-police>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com>
 <20181019111542.6wrvjguirglzg7vg@mbp>
 <20181019112404.GD14246@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019112404.GD14246@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, linux-arch@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, gorcunov@openvz.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

On Fri, Oct 19, 2018 at 12:24:04PM +0100, Will Deacon wrote:
> On Fri, Oct 19, 2018 at 12:15:43PM +0100, Catalin Marinas wrote:
> > On Fri, Oct 05, 2018 at 09:47:44AM +0100, Kristina Martsenko wrote:
> > > diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> > > new file mode 100644
> > > index 000000000000..2aefedc31d9e
> > > --- /dev/null
> > > +++ b/arch/arm64/include/asm/pointer_auth.h
> > > @@ -0,0 +1,63 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#ifndef __ASM_POINTER_AUTH_H
> > > +#define __ASM_POINTER_AUTH_H
> > > +
> > > +#include <linux/random.h>
> > > +
> > > +#include <asm/cpufeature.h>
> > > +#include <asm/sysreg.h>
> > > +
> > > +#ifdef CONFIG_ARM64_PTR_AUTH
> > > +/*
> > > + * Each key is a 128-bit quantity which is split across a pair of 64-bit
> > > + * registers (Lo and Hi).
> > > + */
> > > +struct ptrauth_key {
> > > +	unsigned long lo, hi;
> > > +};
> > > +
> > > +/*
> > > + * We give each process its own instruction A key (APIAKey), which is shared by
> > > + * all threads. This is inherited upon fork(), and reinitialised upon exec*().
> > > + * All other keys are currently unused, with APIBKey, APDAKey, and APBAKey
> > > + * instructions behaving as NOPs.
> > > + */
> > 
> > I don't remember the past discussions but I assume the tools guys are ok
> > with a single key shared by multiple threads. Ramana, could you ack this
> > part, FTR?
> > 
> > (and it would help if someone from the Android and Chrome camps can
> > confirm)
> 
> FWIW: I think we should be entertaining a prctl() interface to use a new
> key on a per-thread basis. Obviously, this would need to be used with care
> (e.g. you'd fork(); use the prctl() and then you'd better not return from
> the calling function!).
> 
> Assuming we want this (Kees -- I was under the impression that everything in
> Android would end up with the same key otherwise?), then the question is
> do we want:
> 
>   - prctl() get/set operations for the key, or
>   - prctl() set_random_key operation, or
>   - both of the above?
> 
> Part of the answer to that may lie in the requirements of CRIU, where I
> strongly suspect they need explicit get/set operations, although these
> could be gated on CONFIG_CHECKPOINT_RESTORE=y.

I managed to speak to the CRIU developers at LPC. The good news is that
their preference is for a ptrace()-based interface for getting and setting
the keys, so the only prctl() operation we need is to set a random key
(separately for A and B).

Will
