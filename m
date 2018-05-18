From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Fri, 18 May 2018 10:56:18 -0700
Message-ID: <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
 <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com> <CAKwvOdm1kYedukCq=g74AvqJHp6KC03oNoouQy2nkvfo4idoEw@mail.gmail.com>
 <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: marc.zyngier@arm.com
Cc: Sami Tolvanen <samitolvanen@google.com>, christoffer.dall@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Andrey Konovalov <andreyknvl@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

+ Andrey

On Fri, May 18, 2018 at 10:45 AM Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 18/05/18 18:40, Nick Desaulniers wrote:
> > On Fri, May 18, 2018 at 10:30 AM Marc Zyngier <marc.zyngier@arm.com>
wrote:
> >> I'm going to ask the question I've asked before when this patch cropped
> >> up (must be the 4th time now):

The previous threads for context:
https://patchwork.kernel.org/patch/10060381/
https://lkml.org/lkml/2018/3/16/434

> >> Is it guaranteed that this is the only case where LLVM/clang is going
to
> >> generate absolute addresses instead of using relative addressing?
> >
> > It seems like if there's requirements that only relative addressing be
> > used, then the compiler should be told explicitly about this
restriction,
> > no?

> Certainly. What's the rune?

It seems like -fno-jump-tables covers all known issues and unblocks people
from doing further work.  It sounds like you'd like some kind of stronger
guarantee? Wont those cases still "crop up" as far as needing to annotate
either the code, or build scripts?
-- 
Thanks,
~Nick Desaulniers
