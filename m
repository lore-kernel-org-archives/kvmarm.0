From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 12:05:16 +0200
Message-ID: <560E56DC.6020406@redhat.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <560E4EC4.5050101@redhat.com>
 <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 02/10/2015 11:58, Peter Maydell wrote:
> On 2 October 2015 at 10:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>
>> On 02/10/2015 09:28, Pavel Fedin wrote:
>>>  2. Another possible approach, based on how device tree binding is handled by Linux. It is possible
>>> to remove virtual timer IRQ from the device tree, in this case the kernel reverts to using physical
>>> timer. When running under hypervisor, accesses to physical CP15 timer are trapped into HYP,
>>> therefore we can forward them to userspace using new exit code, something like KVM_EXIT_REG_ACCESS.
>>> In this case the timer would be also emulated by the userspace, which is slower, but allows better
>>> emulation. Also, this could be used in order to run some other guests which just expect physical
>>> timer to be there.
>>>
>>>  Both approaches have their own limitations, but anyway this is much better than nothing. What do
>>> you think, and which approach do you like more?
>>
>> I like the latter.  But I guess one could even do both?
> 
> I definitely dislike the latter -- userspace ends up having to
> emulate part of the CPU even though that CPU support is really
> there in hardware. Also it requires us to edit the device tree,
> which means it won't work at all on boards other than 'virt'
> where we use the kernel's device tree rather than creating our
> own. Better for the kernel to forward the timer
> interrupts back out to userspace's irq controller.

How do boards other than 'virt' work when emulated without KVM?  It must
be possible to emulate the physical timer in QEMU.

Paolo
