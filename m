From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Fri, 18 May 2018 11:31:50 -0700
Message-ID: <CAKwvOdk+=JKcQP1ieLEkZftRGf-pqCTTzEuYvT_45YNMkEw_wA@mail.gmail.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
 <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com> <CAKwvOdm1kYedukCq=g74AvqJHp6KC03oNoouQy2nkvfo4idoEw@mail.gmail.com>
 <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com> <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
 <3fd89842-86cd-ee01-0c2c-5438dd2d5f2a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3fd89842-86cd-ee01-0c2c-5438dd2d5f2a@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: marc.zyngier@arm.com
Cc: Sami Tolvanen <samitolvanen@google.com>, christoffer.dall@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Andrey Konovalov <andreyknvl@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 18, 2018 at 11:13 AM Marc Zyngier <marc.zyngier@arm.com> wrote:
> What I'd really like is to apply that patch knowing that:

> - you have checked that with a released version of the compiler, you
> don't observe any absolute address in any of the objects that are going
> to be executed at EL2 on a mainline kernel,

To verify, we should disassemble objects from arch/arm64/kvm/hyp/*.o and
make sure we don't see absolute addresses?  I can work with Sami to get a
sense of what the before and after of this patch looks like in disassembly,
then verify those changes are pervasive.

> - you have successfully run guests with a mainline kernel,

I believe Andrey has already done this.  If he can verify (maybe during
working hours next week), then maybe we can add his Tested-by to this
patches commit message?

> - it works for a reasonable set of common kernel configurations
> (defconfig and some of the most useful debug options),

It's easy for us to test our kernel configs for Android, ChromeOS, and
defconfig.  I'd be curious to know the shortlist of "most useful debug
options" just to be a better kernel developer, personally.

> - I can reproduce your findings with the same released compiler.

Lets wait for Andrey to confirm his test setup.  On the Android side, I
think you should be able to get by with a released version, but I'd be
curious to hear from Andrey.

> Is that the case? I don't think any of the above is completely outlandish.

These are all reasonable. Thanks for the feedback.
-- 
Thanks,
~Nick Desaulniers
