From: Pavel Fedin <p.fedin@samsung.com>
Subject: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 02 Oct 2015 10:28:42 +0300
Message-ID: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 Since c2f58514cfb374d5368c9da945f1765cd48eb0da ("arm/arm64: KVM: vgic: Check for
!irqchip_in_kernel() when mapping resources") we can run qemu with kernel_irqchip=off option. The
only remaining problem is how to handle CP15 timer in this case.
 I have applied my old experimental patches to kernel 4.2.2. Using them, i can run 'virt' machine
with software-emulated GICv2 on GICv3 hardware without v2 backwards compatibility. Also, i studied
4.3 code, and it seems to be feasible to add this support to 4.3 and on.
 The only main question now is how would we do it. We can actually use two possible approaches:

 1. If there's no in-kernel irqchip, we revert to older timer behavior (ARCH_TIMER_CTRL_IT_MASK
hack), and forward the timer IRQ to userspace using new KVM_EXIT_IRQ return code. Timer IRQ has to
be treated as edge-triggered in this case. This is the approach which my current implementation
uses.

 2. Another possible approach, based on how device tree binding is handled by Linux. It is possible
to remove virtual timer IRQ from the device tree, in this case the kernel reverts to using physical
timer. When running under hypervisor, accesses to physical CP15 timer are trapped into HYP,
therefore we can forward them to userspace using new exit code, something like KVM_EXIT_REG_ACCESS.
In this case the timer would be also emulated by the userspace, which is slower, but allows better
emulation. Also, this could be used in order to run some other guests which just expect physical
timer to be there.

 Both approaches have their own limitations, but anyway this is much better than nothing. What do
you think, and which approach do you like more?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


