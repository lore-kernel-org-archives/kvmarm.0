From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v4 00/10] Provide the EL1 physical timer to the VM
Date: Fri, 3 Feb 2017 11:51:03 -0500
Message-ID: <CAHyh4xivs-0jA4-HDK8H9YsJqdTioGfDaW5WZMdyLQTc57aNDQ@mail.gmail.com>
References: <1486135208-13415-1-git-send-email-jintack@cs.columbia.edu> <11908d08-6e2d-010c-2e6f-fd677c7ad8b1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11908d08-6e2d-010c-2e6f-fd677c7ad8b1@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, KVM General <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 3, 2017 at 11:14 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 03/02/17 15:19, Jintack Lim wrote:
>> The ARM architecture defines the EL1 physical timer and the virtual timer,
>> and it is reasonable for an OS to expect to be able to access both.
>> However, the current KVM implementation does not provide the EL1 physical
>> timer to VMs but terminates VMs on access to the timer.
>>
>> This patch series enables VMs to use the EL1 physical timer through
>> trap-and-emulate only on arm64. The KVM host emulates each EL1 physical
>> timer register access and sets up the background timer accordingly.  When
>> the background timer expires, the KVM host injects EL1 physical timer
>> interrupts to the VM.  Alternatively, it's also possible to allow VMs to
>> access the EL1 physical timer without trapping.  However, this requires
>> somehow using the EL2 physical timer for the Linux host while running the
>> VM instead of the EL1 physical timer.  Right now I just implemented
>> trap-and-emulate because this was straightforward to do, and I leave it to
>> future work to determine if transferring the EL1 physical timer state to
>> the EL2 timer provides any performance benefit.
>>
>> This feature will be useful for any OS that wishes to access the EL1
>> physical timer. Nested virtualization is one of those use cases. A nested
>> hypervisor running inside a VM would think it has full access to the
>> hardware and naturally tries to use the EL1 physical timer as Linux would
>> do. Other nested hypervisors may try to use the EL2 physical timer as Xen
>> would do, but supporting the EL2 physical timer to the VM is out of scope
>> of this patch series. This patch series will make it easy to add the EL2
>> timer support in the future, though.
>>
>> Note that Linux VMs booting in EL1 will be unaffected by this patch series
>> and will continue to use only the virtual timer and this patch series will
>> therefore not introduce any performance degredation as a result of
>> trap-and-emulate.
>>
>> v3 => v4:
>>  - Fix a bug that prevents a VM from booting on 32-bit architecture
>>  - Clarify that the emulated physical timer is only supported on arm64
>>    in the cover letter
>
> Hi Jintack,
>
> I've now applied this to queue, and will push it out later today.

Thanks, Marc.

>
> Out of curiosity, is there any reason why this is arm64 only?

It was simply because I didn't have a convenient 32bit architecture
develop environment at hand and didn't spend time to set it up myself
:(
(As specified in the nesting RFC patch series cover letter, the
nesting patches are compiled, but not tested on 32-bit architecture
yet.)
I guess it's time to set it up.

> As far as
> I can tell, we're only missing the cp15 handling (both for arm and in
> the 32bit handling in arm64).

I think so, too. I can't promise when, but I'll try to add those once
I set the develop environment.

>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
