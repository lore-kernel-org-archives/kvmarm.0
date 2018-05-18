From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Fri, 18 May 2018 19:13:43 +0100
Message-ID: <3fd89842-86cd-ee01-0c2c-5438dd2d5f2a@arm.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
 <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com>
 <CAKwvOdm1kYedukCq=g74AvqJHp6KC03oNoouQy2nkvfo4idoEw@mail.gmail.com>
 <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com>
 <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, christoffer.dall@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Andrey Konovalov <andreyknvl@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 18/05/18 18:56, Nick Desaulniers wrote:
> + Andrey
> 
> On Fri, May 18, 2018 at 10:45 AM Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 18/05/18 18:40, Nick Desaulniers wrote:
>>> On Fri, May 18, 2018 at 10:30 AM Marc Zyngier <marc.zyngier@arm.com>
> wrote:
>>>> I'm going to ask the question I've asked before when this patch cropped
>>>> up (must be the 4th time now):
> 
> The previous threads for context:
> https://patchwork.kernel.org/patch/10060381/
> https://lkml.org/lkml/2018/3/16/434
> 
>>>> Is it guaranteed that this is the only case where LLVM/clang is going
> to
>>>> generate absolute addresses instead of using relative addressing?
>>>
>>> It seems like if there's requirements that only relative addressing be
>>> used, then the compiler should be told explicitly about this
> restriction,
>>> no?
> 
>> Certainly. What's the rune?
> 
> It seems like -fno-jump-tables covers all known issues and unblocks people
> from doing further work.  It sounds like you'd like some kind of stronger
> guarantee? Wont those cases still "crop up" as far as needing to annotate
> either the code, or build scripts?

What I'd really like is to apply that patch knowing that:

- you have checked that with a released version of the compiler, you
don't observe any absolute address in any of the objects that are going
to be executed at EL2 on a mainline kernel,

- you have successfully run guests with a mainline kernel,

- it works for a reasonable set of common kernel configurations
(defconfig and some of the most useful debug options),

- I can reproduce your findings with the same released compiler.

Is that the case? I don't think any of the above is completely outlandish.

	M.
-- 
Jazz is not dead. It just smells funny...
