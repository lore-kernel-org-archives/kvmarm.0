From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 10:58:21 +0100
Message-ID: <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <560E4EC4.5050101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 633A64130B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 05:56:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vSNrQMvgnDkf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 05:56:58 -0400 (EDT)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
 [209.85.213.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FBBB41B69
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 05:56:58 -0400 (EDT)
Received: by vkat63 with SMTP id t63so56631231vka.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Oct 2015 02:58:41 -0700 (PDT)
In-Reply-To: <560E4EC4.5050101@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 October 2015 at 10:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 02/10/2015 09:28, Pavel Fedin wrote:
>>  2. Another possible approach, based on how device tree binding is handled by Linux. It is possible
>> to remove virtual timer IRQ from the device tree, in this case the kernel reverts to using physical
>> timer. When running under hypervisor, accesses to physical CP15 timer are trapped into HYP,
>> therefore we can forward them to userspace using new exit code, something like KVM_EXIT_REG_ACCESS.
>> In this case the timer would be also emulated by the userspace, which is slower, but allows better
>> emulation. Also, this could be used in order to run some other guests which just expect physical
>> timer to be there.
>>
>>  Both approaches have their own limitations, but anyway this is much better than nothing. What do
>> you think, and which approach do you like more?
>
> I like the latter.  But I guess one could even do both?

I definitely dislike the latter -- userspace ends up having to
emulate part of the CPU even though that CPU support is really
there in hardware. Also it requires us to edit the device tree,
which means it won't work at all on boards other than 'virt'
where we use the kernel's device tree rather than creating our
own. Better for the kernel to forward the timer
interrupts back out to userspace's irq controller.

-- PMM
