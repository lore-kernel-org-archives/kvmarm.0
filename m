From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] ARM: kvm: fix a bad BSYM() usage
Date: Mon, 11 May 2015 11:27:07 +0100
Message-ID: <20150511102707.GC5856@e103592.cambridge.arm.com>
References: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
 <20150509200717.GA30634@cbox>
 <CAKv+Gu922cZLGUJ3-g8CJiUCuL-5L=XHPfgXUMo-jrdPKAuokA@mail.gmail.com>
 <20150511090537.GA2009@cbox>
 <20150511095657.GA5856@e103592.cambridge.arm.com>
 <20150511101738.GC2067@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150511101738.GC2067@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 11, 2015 at 11:17:39AM +0100, Russell King - ARM Linux wrote:
> On Mon, May 11, 2015 at 10:56:57AM +0100, Dave P Martin wrote:
> > ldr= will do the right thing *if* the target symbol's type is correctly
> > annotated.  This means that ldr =some_local_code_symbol does the right
> > thing for branch target addresses if and only if some_local_code_symbol
> > is marked with .type %function (or ENDPROC).
> > 
> > The fact that a symbol is in a code section is *not* enough.
> > 
> > For ARM code this never mattered, so local symbols in .S files are
> > probably under-annotated in general.  BSYM() might have been used to
> > work around this in some cases.
> > 
> > We should check that all the BSYMs removed by this series from ldr=
> > and .long/.word etc. point to a correctly annotated symbol, and add
> > the annotations if not.
> 
> I guess the problem here is that people forget what a patch series is
> actually doing and then start making comments based on hypothetical
> stuff rather than what the series is actually doing.
> 
> To recap, this series:
> 
> 1. Removes the wrong usage of BSYM() in the KVM code.  This is used with
>    the symbol "panic" which is a function declared by generic C code.
>    Therefore, panic will have the appropriate annotations attached to
>    this symbol, unless GCC itself is buggy.
> 
>    This is the _only_ case of "ldr rd, =BSYM(sym)".

That's a sound conclusion -- you did mention before that that was the
only BSYM with ldr=, but it slipped my mind again, sorry.

> 2. It replaces the remaining "adr rd, BSYM(sym)" with a new "badr" macro,
>    and removes the BSYM() preprocessor macro.  The new "badr" macro which
>    is identical in behaviour to the former, but ensures that BSYM()
>    doesn't get mis-used with "ldr".

And this part wasn't in question anyway, so all is fine.

Cheers
---Dave

