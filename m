From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 11:23:50 +0100
Message-ID: <CAFEAcA9hn9WJYhbOMZX+qe9FVRgaTJPDfs-dbiYWxc0ej8OuLw@mail.gmail.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com> <560E4EC4.5050101@redhat.com>
 <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
 <560E56DC.6020406@redhat.com> <CAFEAcA9xuaE6DmpZGD1g9DXTSctiawwrV1iq1xXv+EO7qDR+xA@mail.gmail.com>
 <560E59FA.9070205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <560E59FA.9070205@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 October 2015 at 11:18, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 02/10/2015 12:16, Peter Maydell wrote:
>> On 2 October 2015 at 11:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> On 02/10/2015 11:58, Peter Maydell wrote:
>>>> I definitely dislike the latter -- userspace ends up having to
>>>> emulate part of the CPU even though that CPU support is really
>>>> there in hardware. Also it requires us to edit the device tree,
>>>> which means it won't work at all on boards other than 'virt'
>>>> where we use the kernel's device tree rather than creating our
>>>> own. Better for the kernel to forward the timer
>>>> interrupts back out to userspace's irq controller.
>>>
>>> How do boards other than 'virt' work when emulated without KVM?  It must
>>> be possible to emulate the physical timer in QEMU.
>>
>> Without KVM is easy -- we emulate the physical timer as just
>> one of the parts of the emulated CPU. With KVM, we don't emulate
>> the CPU at all. We don't try to handle a "half TCG half KVM" setup.
>
> I mean in the device tree.  Does the boot loader realize it's under a
> hypervisor, and provide different device trees to the kernel?

No. The device tree says "you have both physical and virtual
timers", the guest kernel always prefers the virtual timer, and
this works for both KVM and TCG.

-- PMM
