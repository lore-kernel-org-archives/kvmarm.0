From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 11:22:24 +0100
Message-ID: <20151002112224.73e46be1@arm.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 2 Oct 2015 10:28:42 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

[...]

>  1. If there's no in-kernel irqchip, we revert to older timer
> behavior (ARCH_TIMER_CTRL_IT_MASK hack), and forward the timer IRQ to
> userspace using new KVM_EXIT_IRQ return code. Timer IRQ has to be
> treated as edge-triggered in this case. This is the approach which my
> current implementation uses.

No way I'm putting this hack back in. We're working hard enough to make
KVM architecture compliant (making the timer LEVEL triggered), and this
hack prevents legitimate guests from running properly. So it is gone,
never to return.

>  2. Another possible approach, based on how device tree binding is
> handled by Linux. It is possible to remove virtual timer IRQ from the
> device tree, in this case the kernel reverts to using physical timer.
> When running under hypervisor, accesses to physical CP15 timer are
> trapped into HYP, therefore we can forward them to userspace using
> new exit code, something like KVM_EXIT_REG_ACCESS. In this case the
> timer would be also emulated by the userspace, which is slower, but
> allows better emulation. Also, this could be used in order to run
> some other guests which just expect physical timer to be there.

A few things:

- How do you find out that your guest is Linux?
- How do you ensure that the guest will not require the virtual timer?
- Who is going to maintain this new ABI that would exist for the sole
  benefit of broken hardware?
- What is wrong with exposing another, memory mapped timer and remove
  the architected timer entirely?

My guess is that this particular ball of hacks will just bitrot as soon
as your product has shipped, because the world will have moved on and
ditched/reworked the broken HW.

So let me put it another way. The only way I look into this is when we
have this particular platform fully supported in mainline.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
