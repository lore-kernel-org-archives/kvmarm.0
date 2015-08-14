From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 2/3] Detect vGIC presence at runtime
Date: Fri, 14 Aug 2015 14:10:35 +0100
Message-ID: <55CDE8CB.5040205@arm.com>
References: <cover.1438770954.git.p.fedin@samsung.com> <cad42f98c38c042430da47bf69ac2db81cb957af.1438770954.git.p.fedin@samsung.com> <55CDD056.8010703@arm.com> <017201d0d68c$82ae4950$880adbf0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <017201d0d68c$82ae4950$880adbf0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/08/15 13:26, Pavel Fedin wrote:
>  Hello! Thank you for quick response.
> 
>> This is fairly unreadable. Please use a switch statement instead.
> 
>  Christoffer disliked it in v1, so i thought a bit and changed it. Ok, will change it back.
> 
>> And here, we're going to assume that the arch timer still usable. We
>> definitely need a way to *prevent* the timer to be used when there is no
>> GIC. Otherwise, we're going to start trying to setup the mapping for the
>> active state, and the guest may start poking it.
> 
> But, this seems to be already done, isn't it?
> According to http://lxr.free-electrons.com/source/arch/arm/kvm/arm.c#L439:
> --- cut ---
> 459         /*
> 460          * Enable the arch timers only if we have an in-kernel VGIC
> 461          * and it has been properly initialized, since we cannot handle
> 462          * interrupts from the virtual timer with a userspace gic.
> 463          */
> 464         if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
> 465                 kvm_timer_enable(kvm);
> --- cut ---

Right, I failed to remember that one. Sorry. It should be safe then.
Hopefully.

[...]

>  And some more. Actually, it is possible to emulate generic timer in userspace, just not the virtual
> one. IIRC access to physical timer can be trapped. So, if we modify guest's device tree by removing
> virtual timer IRQ, the guest will fall back to physical timer. And this will be caught by the
> hypervisor. After this all we have to do is to add corresponding exit code which would allow the
> userspace to emulate missing CP15 (or system in case of ARM64) registers. So, this timer issue is
> not grave, just i postpone implementing it until GIC issues are settled down.

This is completely Linux-specific, unfortunately. And it relies on
userpace to expose a modified DT, so you need to be able to report back
to userspace that you can't deal with the virtual timer.

Which brings me to the next point: how do you tell userspace that your
timers are non-functional?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
