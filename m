From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Clang arm64 build is broken
Date: Fri, 20 Apr 2018 16:38:47 +0100
Message-ID: <20180420153846.5m5ngqcfn4v4q6wh@lakrids.cambridge.arm.com>
References: <CAAeHK+wDMH_G=3UuGOda2t0g4TH4TmDAeyG-ydJwg9vmThd3eQ@mail.gmail.com>
 <c61336a2-7c66-ea48-3daa-e644403d7a6e@arm.com>
 <CAAeHK+zpAnC3Ppjq2W=r-5fYh+ceEwYymER0iLTan7+pcFDiJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+zpAnC3Ppjq2W=r-5fYh+ceEwYymER0iLTan7+pcFDiJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrey,

On Fri, Apr 20, 2018 at 04:59:35PM +0200, Andrey Konovalov wrote:
> On Fri, Apr 20, 2018 at 10:13 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >> The issue is that
> >> clang doesn't know about the "S" asm constraint. I reported this to
> >> clang [2], and hopefully this will get fixed. In the meantime, would
> >> it possible to work around using the "S" constraint in the kernel?
> >
> > I have no idea, I've never used clang to build the kernel. Clang isn't
> > really supported to build the arm64 kernel anyway (as you mention
> > below), and working around clang deficiencies would mean that we leave
> > with the workaround forever. I'd rather enable clang once it is at
> > feature parity with GCC.
> 
> The fact that there are some existing issues with building arm64
> kernel with clang doesn't sound like a good justification for adding
> new issues :)

I appreciate this is somewhat frustrating, but every feature where clang
is not at parity with GCC is effectively a functional regression for us.

Recently, the code that clang hasn't liked happens to be security
critical, and it is somewhat difficult to justify making that code more
complex to cater for a compiler that we know has outstanding issues with
features we rely upon.

Which is to say, I'm not sure that there's much justification either
way. We really need clang to be at feature parity with GCC for it to be
considered supported.

It would be great if some effort could be focussed on bringing clang to
feature parity with GCC before implementing new clang-specific features.

> However in this case I do believe that this is more of a bug in clang
> that should be fixed.

Just to check: does clang implement the rest of the AArch64 machine
constraints [1]?

We're liable to use more of them in future, and we should aim for parity
now so that we don't fall into the same trap in future.

> >> While we're here, regarding the other issue with kvm [3], I didn't
> >> receive any comments as to whether it makes sense to send the fix that
> >> adds -fno-jump-tables flag when building kvm with clang.
> >
> > Is that the only thing missing? Are you sure that there is no other way
> > for clang to generate absolute addresses that will then lead to a crash?
> > Again, I'd rather make sure we have the full picture.
> 
> Well, I have tried applying that patch and running kvm tests that I
> could find [1], and they passed (actually I think there was an issue
> with one of them, but I saw the same thing when I tried running them
> on a kernel built with GCC).

I think what Marc wants is a statement as to whether -fno-jump-tables is
sufficient to ensure that clang will not try to use absolute addressing,
based on an understanding of the AArch64 LLVM backend rather than test
cases.

For example, could any other pass result in the use of an absolute
address? Or are jump tables the *only* reason that clang would try to
use an absolute address.

Are there other options that we might need to pass?

Are there any options that we can pass to forbid absolute addressing?

Thanks,
Mark.

[1] https://gcc.gnu.org/onlinedocs/gccint/Machine-Constraints.html
