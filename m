From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Fri, 22 Sep 2017 17:39:21 +0100
Message-ID: <59C53CB9.5000003@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com> <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com> <59BA7D72.4090403@arm.com> <5af0cb96-be13-4cc4-13bb-1f608cdc171c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5af0cb96-be13-4cc4-13bb-1f608cdc171c@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@hu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 18/09/17 14:36, gengdongjiu wrote:
> On 2017/9/14 21:00, James Morse wrote:
>> On 13/09/17 08:32, gengdongjiu wrote:
>>> On 2017/9/8 0:30, James Morse wrote:
>>>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>>> For BUS_MCEERR_A* from memory_failure() we can't know if they are caused by
>>>> an access or not.
>>
>> Actually it looks like we can: I thought 'BUS_MCEERR_AR' could be triggered via
>> some CPER flags, but its not. The only code that flags MF_ACTION_REQUIRED is
>> x86's kernel-first handling, which nicely matches this 'direct access' problem.
>> BUS_MCEERR_AR also come from KVM stage2 faults (and the x86 equivalent). Powerpc
>> also triggers these directly, both from what look to be synchronous paths, so I
>> think its fair to equate BUS_MCEERR_AR to a synchronous access and BUS_MCEERR_AO
>> to something_else.
> 
> James, thanks for your explanation.
> can I understand that your meaning that "BUS_MCEERR_AR" stands for synchronous access and BUS_MCEERR_AO stands for asynchronous access?

Not 'stands for', as the AR is Action-Required and AO Action-Optional. My point
was I can't find a case where Action-Required is used for an error that isn't
synchronous.

We should run this past the people who maintain the existing BUS_MCEERR_AR
users, in case its just a severity to them.


> Then for "BUS_MCEERR_AO", how to distinguish it is asynchronous data access(SError) and PCIE AER error?

How would userspace get one of these memory errors for a PCIe error?


> In the user space, we can check the si_code, if it is "BUS_MCEERR_AR", we use SEA notification type for the guest;
> if it is "BUS_MCEERR_AO", we use SEI notification type for the guest.
> Because there are only two values for si_code("BUS_MCEERR_AR" and BUS_MCEERR_AO), in which case we can use the GSIV(IRQ) notification type?

This is for Qemu/kvmtool to decide, it depends on what sort of machine they are
emulating.

For example, the physical machine's memory-controller may notify the CPU about
memory errors by triggering SError trapped to EL3, or with a dedicated FIQ, also
routed to EL3. By the time this gets to the host kernel the distinction doesn't
matter. The host has handled the error.

For a guest, your memory-controller is effectively the host kernel. It will give
you an BUS_MCEERR_AO signal for any guest memory that is affected, and a
BUS_MCEERR_AR if the guest directly accesses a page of affected memory.

What Qemu/kvmtool do with this is up to them. If they're emulating a machine
with no RAS features, printing an error and exit.

Otherwise BUS_MCEERR_AR could be notified as one of the flavours of IRQ, unless
the affected vcpu has interrupts masked, in which case an SEA notification gives
you some NMI-like behaviour.

For BUS_MCEERR_AO you could use SEI, IRQ or polled notification. My choice would
be IRQ, as you can't know if the guest supports SEI and it would be a shame to
kill it with an SError if the affected memory was free. SEA for synchronous
errors is still a good choice even if the guest doesn't support it as that
memory is still gone so its still a valid guest:Synchronous-external-abort.


[...]

>>> 1. Let us firstly discuss the SEA and SEI, there are different workflow for the two different Errors.

>> user-space can choose whether to use SEA or SEI, it doesn't have to choose the
>> same notification type that firmware used, which in turn doesn't have to be the
>> same as that used by the CPU to notify firmware.
>>
>> The choice only matters because these notifications hang on an existing pieces
>> of the Arm-architecture, so the notification can only add to the architecturally
>> defined meaning. (i.e. You can only send an SEA for something that can already
>> be described as a synchronous external abort).
>>
>> Once we get to user-space, for memory_failure() notifications, (which so far is
>> all we are talking about here), the only thing that could matter is whether the
>> guest hit a PG_hwpoison page as a stage2 fault. These can be described as
>> Synchronous-External-Abort.
>>
>> The Synchronous-External-Abort/SError-Interrupt distinction matters for the CPU
>> because it can't always make an error synchronous. For memory_failure()
>> notifications to a KVM guest we really can do this, and we already have this
>> behaviour for free. An example:
>>
>> A guest touches some hardware:poisoned memory, for whatever reason the CPU can't
>> put the world back together to make this a synchronous exception, so it reports
>> it to firmware as an SError-interrupt.
> 
>> Linux gets an APEI notification and memory_failure() causes the affected page to
>> be unmapped from the guest's stage2, and SIGBUS_MCEERR_AO sent to user-space.
>>
>> Qemu/kvmtool can now notify the guest with an IRQ or POLLed notification. AO->
>> action optional, probably asynchronous.

> If so, in this case, Qemu/kvmtool only got a little information(receive a SIGBUS), for this SIGBUS,
> it only include the SIGBUS_MCEERR_AO, error address. not include other information,
> only according the SIGBUS_MCEERR_AO and error address, user space does not know whether to use IRQ or POLLed notification.

The kernel can't tell it which to use: user space has to decide. This has to be
a property of the machine you are emulating, not the machine you happen to be
running on.

What happens if the notification came using a future notification type that user
space doesn't know about.
What if user space does know about this type, but the guest doesn't.
What if you migrate to a machine that uses a new notification type that you
didn't advertise to the guest via the HEST at boot time.

These dependencies have to break somewhere, and the right place is between the
host kernel and host user-space. This way whatever Qemu/kvmtool do will work in
the above 'what-ifs'.


> for example, SIGBUS_MCEERR_AO means asynchronous access, user space can use SEI, IRQ or POLLed notification.
> so user space will be confused to use which method.

There isn't a wrong choice here. I suggest always-use-IRQ. Its faster than
POLLed, but won't kill a guest that doesn't support NOTIFY_SEI.


> I think if we use such solution, user space only judging SIGBUS_MCEERR_A* is not enough.
> how we provide other extra information to let it choose the proper notification?

Forget the original notification. This physical machine's hardware configuration
and how its memory controller is wired up to report errors should not be
relevant to Qemu/kvmtool.

You need to decide how your emulated platform reports errors, you may want to
make it a configuration option which defaults to something safe.

[...]

> In my platform, there is another issue.
> for the stage2 fault, we get the IPA from the HPFAR_EL2 register,
> but for  huawei's CPU, if it is data Error(DFSC[5:0] is 0b010000),

'Synchronous External Abort, not on a translation table walk'

> not translation error(DFSC[5:0] is 0b0101xx),

(the set of external abort, parity or ECC errors that we get from the
page-table-walker)

> the HPFAR_EL2 is NULL, so the IPA is not recorded, in our current KVM code, we get the IPA from the HPFAR_EL2, so
> we can not get the right IPA value, because its value is zero.I do not know whether you have same issue.

This is something the ARM-ARM allows, so we have to live with it in software.

For external aborts the ESR has a 'FnV' bit 10 that for your first DSFSC
'Synchronous External Abort, not on a translation table walk' indicates there is
no FAR, (or presumably HPFAR). I assume you have this bit set in the ESR.

This shouldn't be a problem, for firmware-first we should take the address from
the CPER records as this also gives us a range. For kernel-first we'd take
whatever is in the v8.2 RAS ERR records. Its only if this wasn't a RAS error
that we're likely to print out this address as we kill-the-task/panic.


> Although hpfar_el2 does not record IPA, but host firmware can still record the PA

I agree, it can get the PA from the v8.2 RAS ERR registers and hand it to the OS
using CPER.


> If call memory_failure(), memory_failure can translate the PA to host VA, then deliver
> host VA to Qemu.

Yes, this is how it works for any user-space process as two processes sharing
the same page may map it in different locations.


> Qemu can translate the host VA to IPA. so we rely on memory_failure() to get
> the IPA.

Yes. I don't see why this is a problem: The kernel isn't going to pass RAS
events into the guest, so it never needs to know the IPA.

Instead we notify user-space about ranges of memory affected by
memory_failure(), KVM's user-space isn't a special case here.

As you point out, if Qemu wants to notify the guest it can calculate the IPA and
either use CPER for firmware-first, or in the future, update some representation
of the v8.2 ERR records once we can virtualise kernel-first.

(I'm not sure I understand your point here, but I don't think we disagree,)


Thanks,

James
