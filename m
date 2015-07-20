From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Mon, 20 Jul 2015 09:08:19 +0100
Message-ID: <55ACAC73.9090500@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com> <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/07/15 15:05, Pavel Fedin wrote:
>  Hello!
> 
>> Believe it or not, we're not only patch reviewing machines, and if you
>> count the number of pending patches, you'll quickly notice that yours
>> are basically noise in the grand scheme of things.
>>
>> So please cut us some slack.
> 
> What do you mean exactly? Stop discussions and just do everything you
> suggest before respin? Plz don't attempt to read this between lines,
> i can be bad at communication; this is not a complain and/or hurt
> indication, i am just asking. :)

It means that a pause in the discussion for a week (or even more) is not
uncommon at all. It just means that the other party is busy with things
of higher priority. In all cases, a gentle "ping" will be better
received than this "you've stopped replying so I'm going to repost until
you stop ignoring me" kind of behaviour. It is unnecessary, irritating,
and overall counter-productive.

>>> complete implementation of API which allows to emulate GIC in userspace by
>>> qemu, and now i can run any virtual machine, including generic timer, on
>>> vGIC-less machine. RasPI-2 is expected to benefit too.
>>
>> Do you mean feeding interrupts back to userspace?
> 
>  Yes, exactly. I have a working proof-of-concept here.
> 
>> How is that going to
>> work with the active-timer series that really mandates a full blown GIC?
>> Your pet platform might cope with it, but I can't see that happening on
>> the RPi.
> 
> I don't know, sorry, things are happening too fast and i can't follow
> everything.

It uses the host GIC to perform a context switch of the ACTIVE state of
the timer interrupt instead of the ugly hack we have. Without a GIC, the
is no context switching, and the timer is useless.

> Well, actually it is possible to work without virtual timer at all.
> Yes, this means qemu has to implement some memory-mapped timer. With
> HW models like vexpress this is already done and works fine. I even
> tried to address this:
> https://lists.gnu.org/archive/html/qemu-devel/2015-06/msg06627.html,
> but Peter suggested to complete an API instead.
> I have done this as a proof-of-concept and case study for my project,
> so i want to upstream this in order not to be lost.

I don't care much for such an API, mostly because it will obviously
bitrot very quickly (your "broken VGIC" platform is hopefully a one off
that won't be repeated again, and the RPi is out of scope anyway).

It would have to be extremely non-intrusive and completely safe for this
to be taken in...

> After all, recent specs say that generic timer can also be
> memory-mapped. So, making KVM working without both vGIC and vTimer is
> not a real problem. This patchset addresses this scenario too, just 
> needs some extra bits on vtimer side (ability to init KVM without
> it).

Different generic timer. That's the memory-mapped one, which is not
per-CPU. Per-CPU timer is what we care about.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
