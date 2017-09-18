From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Mon, 18 Sep 2017 21:36:43 +0800
Message-ID: <5af0cb96-be13-4cc4-13bb-1f608cdc171c@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
 <59BA7D72.4090403@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59BA7D72.4090403@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@a
List-Id: kvmarm@lists.cs.columbia.edu

James，
   Thanks for your comments, hope we can make the solution better.

On 2017/9/14 21:00, James Morse wrote:
> Hi gengdongjiu,
> 
> (re-ordered hunks)
> 
> On 13/09/17 08:32, gengdongjiu wrote:
>> On 2017/9/8 0:30, James Morse wrote:
>>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>> For BUS_MCEERR_A* from memory_failure() we can't know if they are caused by
>>> an access or not.
> 
> Actually it looks like we can: I thought 'BUS_MCEERR_AR' could be triggered via
> some CPER flags, but its not. The only code that flags MF_ACTION_REQUIRED is
> x86's kernel-first handling, which nicely matches this 'direct access' problem.
> BUS_MCEERR_AR also come from KVM stage2 faults (and the x86 equivalent). Powerpc
> also triggers these directly, both from what look to be synchronous paths, so I
> think its fair to equate BUS_MCEERR_AR to a synchronous access and BUS_MCEERR_AO
> to something_else.

James, thanks for your explanation.
can I understand that your meaning that "BUS_MCEERR_AR" stands for synchronous access and BUS_MCEERR_AO stands for asynchronous access?
Then for "BUS_MCEERR_AO", how to distinguish it is asynchronous data access(SError) and PCIE AER error?
In the user space, we can check the si_code, if it is "BUS_MCEERR_AR", we use SEA notification type for the guest;
if it is "BUS_MCEERR_AO", we use SEI notification type for the guest.
Because there are only two values for si_code("BUS_MCEERR_AR" and BUS_MCEERR_AO), in which case we can use the GSIV(IRQ) notification type?


> 
> I don't think we need anything else.
> 
> 
>>> When the mm code gets -EHWPOISON when trying to resolve a
>>
>> Because of that, so I allow  userspace getting exception information
> 
> ... and there are cases where you can't get the exception information, and other
> cases where it wasn't an exception at all.
> 
> [...]
> 
> 
>>> What happens if the dram-scrub hardware spots an error in guest memory, but
>>> the guest wasn't running? KVM won't have a relevant ESR value to give you.
> 
>> if the dram-scrub hardware spots an error in guest memory, it will generate
>> IRQ in DDR controller, not SEA or SEI exception. I still do not consider the
>> GSIV. For GSIV, may be we can only handle it in the host OS.
> 
> Great example: this IRQ pulls us out of a guest, we tromp through APEI and then
> memory_failure(), the memory happened to belong to the same guest
> (coincidence!), we send it some signal and now its user-space's problem.
> 
> Your KVM_REG_ARM64_FAULT mechanism is going to return stale data, even though
> the notification interrupted the guest, and it was guest memory that was
> affected. KVM doesn't have a relevant ESR.
> 
> 
> I'm strongly against exposing 'which notification type' this error originally
> came from because:
> * it doesn't matter once we've got the CPER records,
> * there isn't always an answer (there are/will-be other ways of tripping
>   memory_failure())
> * it creates ABI between firwmare, host userspace and guest userspace.
>   Firmware's choice of notification type shouldn't affect anything other than
>   the host kernel.
> 
> 
> On 13/09/17 08:32, gengdongjiu wrote:
>> On 2017/9/8 0:30, James Morse wrote:
>>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>>> when userspace gets SIGBUS signal, it does not know whether
>>>> this is a synchronous external abort or SError,
>>>
>>> Why would Qemu/kvmtool need to know if the original notification (if there was
>>> one) was synchronous or asynchronous? This is between firmware and the kernel.
> 
>> there are two reasons:
>>
>> 1. Let us firstly discuss the SEA and SEI, there are different workflow for the two different Errors.
>> 2. when record the CPER in the user space, it needs to know the error type, because SEA and SEI are different Error source,
>>    so they have different offset in the APEI table, that is to say they will be recorded to different place of the APEI table.
> 
> user-space can choose whether to use SEA or SEI, it doesn't have to choose the
> same notification type that firmware used, which in turn doesn't have to be the
> same as that used by the CPU to notify firmware.
> 
> The choice only matters because these notifications hang on an existing pieces
> of the Arm-architecture, so the notification can only add to the architecturally
> defined meaning. (i.e. You can only send an SEA for something that can already
> be described as a synchronous external abort).
> 
> Once we get to user-space, for memory_failure() notifications, (which so far is
> all we are talking about here), the only thing that could matter is whether the
> guest hit a PG_hwpoison page as a stage2 fault. These can be described as
> Synchronous-External-Abort.
> 
> The Synchronous-External-Abort/SError-Interrupt distinction matters for the CPU
> because it can't always make an error synchronous. For memory_failure()
> notifications to a KVM guest we really can do this, and we already have this
> behaviour for free. An example:
> 
> A guest touches some hardware:poisoned memory, for whatever reason the CPU can't
> put the world back together to make this a synchronous exception, so it reports
> it to firmware as an SError-interrupt.

> Linux gets an APEI notification and memory_failure() causes the affected page to
> be unmapped from the guest's stage2, and SIGBUS_MCEERR_AO sent to user-space.
> 
> Qemu/kvmtool can now notify the guest with an IRQ or POLLed notification. AO->
> action optional, probably asynchronous.
If so, in this case, Qemu/kvmtool only got a little information(receive a SIGBUS), for this SIGBUS,
it only include the SIGBUS_MCEERR_AO, error address. not include other information,
only according the SIGBUS_MCEERR_AO and error address, user space does not know whether to use IRQ or POLLed notification.
for example, SIGBUS_MCEERR_AO means asynchronous access, user space can use SEI, IRQ or POLLed notification.
so user space will be confused to use which method.

I think if we use such solution, user space only judging SIGBUS_MCEERR_A* is not enough.
how we provide other extra information to let it choose the proper notification?

> 
> But in our example it wasn't really asynchronous, that was just a property of
> the original CPU->firmware notification. What happens? The guest vcpu is re-run,
> it re-runs the same instructions (this was a contained error so KVM's ELR points
> at/before the instruction that steps in the problem). This time KVM takes a
> stage2 fault, which the mm code will refuse to fixup because the relevant page
> was marked as PG_hwpoision by memory_failure(). KVM signals Qemu/kvmtool with
> SIGBUS_MCEERR_AR. Now Qemu/kvmtool can notify the guest using SEA.
> 
> 
> 
> 
>>          etc/acpi/tables                               etc/hardware_errors
>>         ====================                    ==========================================
>>     + +--------------------------+            +------------------+
>>     | | HEST                     |            |    address       |              +--------------+
>>     | +--------------------------+            |    registers     |              | Error Status |
>>     | | GHES0                    |            | +----------------+              | Data Block 0 |
>>     | +--------------------------+ +--------->| |status_address0 |------------->| +------------+
>>     | | .................        | |          | +----------------+              | |  CPER      |
>>     | | error_status_address-----+-+ +------->| |status_address1 |----------+   | |  CPER      |
>>     | | .................        |   |        | +----------------+          |   | |  ....      |
>>     | | read_ack_register--------+-+ |        |  .............   |          |   | |  CPER      |
>>     | | read_ack_preserve        | | |        +------------------+          |   | +-+------------+
>>     | | read_ack_write           | | | +----->| |status_address10|--------+ |   | Error Status |
>>     + +--------------------------+ | | |      | +----------------+        | |   | Data Block 1 |
>>     | | GHES1                    | +-+-+----->| | ack_value0     |        | +-->| +------------+
>>     + +--------------------------+   | |      | +----------------+        |     | |  CPER      |
>>     | | .................        |   | | +--->| | ack_value1     |        |     | |  CPER      |
>>     | | error_status_address-----+---+ | |    | +----------------+        |     | |  ....      |
>>     | | .................        |     | |    | |  ............. |        |     | |  CPER      |
>>     | | read_ack_register--------+-----+-+    | +----------------+        |     +-+------------+
>>     | | read_ack_preserve        |     |   +->| | ack_value10    |        |     | |..........  |
>>     | | read_ack_write           |     |   |  | +----------------+        |     | +------------+
>>     + +--------------------------|     |   |                              |     | Error Status |
>>     | | ...............          |     |   |                              |     | Data Block 10|
>>     + +--------------------------+     |   |                              +---->| +------------+
>>     | | GHES10                   |     |   |                                    | |  CPER      |
>>     + +--------------------------+     |   |                                    | |  CPER      |
>>     | | .................        |     |   |                                    | |  ....      |
>>     | | error_status_address-----+-----+   |                                    | |  CPER      |
>>     | | .................        |         |                                    +-+------------+
>>     | | read_ack_register--------+---------+
>>     | | read_ack_preserve        |
>>     | | read_ack_write           |
>>     + +--------------------------+
>>
> 
> (nice ascii art!)
> 
>>> I think I can see why you need this: to choose whether to emulate SEA or SEI,
> 
>> emulating SEA or SEI is one reason, another reason is that the CPER will be recorded to different place of APEI.
> 
> (This doesn't matter: Generate the CPER records after you've chosen the
> notification and this isn't a problem. Or map your 'Error Status Data Blocks'
> to status_address* depending on usage not in a fixed 1:1 way)
> 
> 
>>> I think what you need is some way of knowing if the BUS_MCEERR_A* was directly
>>> caused by a user-space (or guest) access, and if so was it a data or instruction
> 
>> when user space received the signal, it will judge whether the memory address is user-space (or guest) address
> 
>>> fetch. These can become SEA notifications.
> 
>> In fact, it can be SEI, not always SEA, why it will always SEA notifications?
>> If the memory properties of data is device type, it may become SEI notification.
> 
> Let's take a step back: in what scenario should we use an emulated-SEA instead
> of an emulated-SEI? (forget what the CPU and firmware did, this is up to Qemu to
> decide).
> 
> It can use SEA if this is a valid Synchronous-external-abort. Stage 2 faults are
> synchronous exceptions, if you hit a PG_hwpoision page on this path you can
> report this back to the guest as a Synchronous-external-abort/SEA.
> How do you know? You get SIGBUS_MCEERR_AR from KVM.
I understand your idea, I agree we can use SEA notification for guest if it is SIGBUS_MCEERR_AR.
I am worried about the SIGBUS_MCEERR_AO.
if it is SIGBUS_MCEERR_AO, we can choose SEI, IRQ or POLLed notification. so according to what principles to choose that?

In my platform, there is another issue.
for the stage2 fault, we get the IPA from the HPFAR_EL2 register,
but for  huawei's CPU, if it is data Error(DFSC[5:0] is 0b010000), not translation error(DFSC[5:0] is 0b0101xx),
the HPFAR_EL2 is NULL, so the IPA is not recorded, in our current KVM code, we get the IPA from the HPFAR_EL2, so
we can not get the right IPA value, because its value is zero.I do not know whether you have same issue.

Although hpfar_el2 does not record IPA, but host firmware can still record the PA
If call memory_failure(), memory_failure can translate the PA to host VA, then deliver host VA to Qemu. Qemu can translate the host VA to IPA.
so we rely on memory_failure() to get the IPA.



> 
> 
> Thanks,
> 
> James
> 
> .
> 
