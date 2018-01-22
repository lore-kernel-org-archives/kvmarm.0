From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by categorization
Date: Mon, 22 Jan 2018 19:36:23 +0000
Message-ID: <5A663D37.50209@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com> <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com> <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com> <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com> <5A3419FF.30101@arm.com> <b98d911d-afc3-115b-3ba0-35b1daf63723@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <b98d911d-afc3-115b-3ba0-35b1daf63723@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, wuquanming@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 16/12/17 03:44, gengdongjiu wrote:
> On 2017/12/16 2:52, James Morse wrote:
>>> signal, it will record the CPER and trigger a IRQ to notify guest, as shown below:
>>>
>>> SIGBUS_MCEERR_AR trigger Synchronous External Abort.
>>> SIGBUS_MCEERR_AO trigger GPIO IRQ.
>>>
>>> For the SIGBUS_MCEERR_AO and SIGBUS_MCEERR_AR, we have already specify trigger method, which all
>>>
>>> not involve _trigger_ an SError.
>> It's a policy choice. How does your virtual CPU notify RAS errors to its virtual
>> software? You could use SError for SIGBUS_MCEERR_AR, it depends on what type of
>> CPU you are trying to emulate.
>>
>> I'd suggest using NOTIFY_SEA for SIGBUS_MCEERR_AR as it avoids problems where
>> the guest doesn't take the SError immediately, instead tries to re-execute the

> I agree it is better to use NOTIFY_SEA for SIGBUS_MCEERR_AR in this case.

>> code KVM has unmapped from stage2 because its corrupt. (You could detect this
>> happening in Qemu and try something else)

> For something else, using NOTIFY_SEI for SIGBUS_MCEERR_AR?

Sorry that was unclear. If you use NOTIFY_SEI, the guest may have PSTATE.A set,
in which case the the CPU will patiently wait for it to unmask, (or consume it
with an ESB-instruction), before delivering the notification. The guest may not
have unmasked SError because its hammering the same page taking the same fault
again and again. Pending the asynchronous notification and re-running the vcpu
doesn't guarantee progress will be made.

In this case user-space can spot its pended an asynchronous notification (for
the same address!) more than once in the last few seconds, and try something
else, like firing a guest:reboot watchdog on another CPU.


> At current implementation,
> It seems only have this case that "KVM has unmapped from stage2", do you thing we
> still have something else?

I'm wary that this only works for errors where we know the guest PC accessed the
faulting location.

The arch code will send this signal too if user-space touches the PG_poisoned
page. (I recall you checked Qemu spots this case and acts differently).
Migration is the obvious example for Qemu read/writing guest memory.

On x86 the MachineCheck code sends these signals too, so our kernel-first
implementation may do the same. As a response to a RAS error notified by
synchronous-external-abort, this is fine. But we need to remember '_AR' implies
the error is related to the code the signal interrupted, which wouldn't be true
for an error notified by SError.


>> Synchronous/asynchronous external abort matters to the CPU, but once the error
>> has been notified to software the reasons for this distinction disappear. Once
>> the error has been handled, all trace of this distinction is gone.
>>
>> CPER records only describe component failures. You are trying to re-create some
>> state that disappeared with one of the firmware-first abstractions. Trying to
>> re-create this information isn't worth the effort as the distinction doesn't
>> matter to linux, only to the CPU.
>>
>>
>>> so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.
>> You mean there is no reason for Qemu to trigger an SError when it gets a signal
>> from the kernel.
>>
>> The reasons the CPU might have to generate an SError don't apply to linux and
>> KVM user space. User-space will never get a signal for an uncontained error, we
>> will always panic(). We can't give user-space a signal for imprecise exceptions,
>> as it can't return from the signal. The classes of error that are left are
>> covered by polled/irq and NOTIFY_SEA.
>>
>> Qemu can decide to generate RAS SErrors for SIGBUS_MCEERR_AR if it really wants
>> to, (but I don't think you should, the kernel may have unmapped the page at PC
>> from stage2 due to corruption).

> yes, you also said you do not want to generate RAS SErrors for SIGBUS_MCEERR_AR,
> so Qemu does not know in which condition to generate RAS SErrors.

There are two things going on here, firstly the guest may have masked PSTATE.A,
and be hammering an unmapped page. (this this 'sorry that was unclear' case
above). This would happen if the exception-entry code or stack became corrupt
when an exception was taken.
The second is what does existing non-RAS-aware software do? For SError it
panic()s, whereas for synchronous external abort there are some cases that can
be handled. (e.g. on linux: synchronous external abort from user-space).


>> I think the problem here is you're applying the CPU->software behaviour and
>> choices to software->software. By the time user-space gets the error, the
>> behaviour is different.

> In the KVM, as a policy choice to reserve this API to specify guest ESR and 
> drive to trigger SError is OK,
> At least for Qemu it does not know in which condition to trigger it.

I think you're saying "lets keep it KVM for now, Qemu doesn't have a better idea
of what to do."


Thanks,

James




