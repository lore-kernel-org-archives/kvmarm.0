From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Sat, 24 Jun 2017 22:56:09 +0800
Message-ID: <CAMj-D2D1HTvqGDO0DL8LtiKyMbxjZxocu+GMZ4Nc2WeHz4B9WQ@mail.gmail.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com>
 <594A4205.70201@arm.com> <3a02e425-5782-dad4-efda-fdc5df73dcf7@huawei.com>
 <594A6A45.60909@arm.com> <ae7a4ac0-d38a-d6fe-2138-c21da23607c6@huawei.com>
 <594BF2C0.9060904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <594BF2C0.9060904@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: wuquanming <wuquanming@huawei.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, gengdongjiu <gengdongjiu@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

2017-06-23 0:39 GMT+08:00, James Morse <james.morse@arm.com>:
> Hi gengdongjiu,
>
> On 22/06/17 07:47, gengdongjiu wrote:
>> On 2017/6/21 20:44, James Morse wrote:
>>> On 21/06/17 11:59, gengdongjiu wrote:
>>>> On 2017/6/21 17:53, James Morse wrote:
>>>>> I think we discussed this before[0], your CPU has a feature called
>>>>> 'hwpoison'
>>>>> that is uses to support RAS. Linux also has a feature called 'hwpoison'
>>>>> [1][2],
>>>>> which handles the offline-ing of memory pages when it receives a
>>>>> notification
>>>>> through APEI. I've tried to call this memory_failure() to avoid this
>>>>> confusion.
>>>>>
>>>>> This patch is to handle stage2 faults when the page was removed from
>>>>> the stage2
>>>>> mapping by the memory_failure() code. v3 of this patch[3] does a much
>>>>> better job
>>>>> of describing this.
>>>>>
>>>>> (... I don't think your question is related to this patch ...)
>>>>
>>>> I know your meaning about the Linux 'hwpoison' feature.
>
>>> Okay, I assume we are also talking about firmware-first RAS events and
>>> your APEI
>>> notifications use SEA.
>
> It doesn't look like you are using APEI firmware-first or SEA notifications
> here.
>
>
>>> I think we are looking at different parts of the code, here is what I see
>>> should
>>> happen:
>>>
>>> For a Synchronous External Abort the ESR {D,I}FSC bits will be in the
>>> range that
>>> indicates an external abort. For a data:external-abort
>>> kvm_handle_guest_abort()
>>> will matches this with kvm_vcpu_dabt_isextabt() and makes no further
>>> attempt to
>>> handle the fault.
>
>> The kvm_vcpu_dabt_isextabt() will check the ESR EA bit[9]
>> The EA bit [9] is "IMPLEMENTATION DEFINED", so whether match with the
>> kvm_vcpu_dabt_isextabt() depend on the CPU design.
>> In my platform the EA bit is zero for the RAS Synchronous External Abort,
>> so will not matches the kvm_vcpu_dabt_isextabt(),
>> so the code will continue handle the fault.
>
> This is the problem, you aren't notifying RAS errors to the OS with an
> SEA/synchronous-external-abort.
>
> For APEI firmware-first RAS you must use one of the notification methods
> listed
> in ACPI 6.2s '18.3.2.9 Hardware Error Notification, Table 18-383'.
>
> Notifications using 'SEA' hang on an existing part of the ARM architecture,
> firmware has to emulate what the CPU does to avoid breaking existing code.
>
>
>> EA, bit [9]
>> 	External Abort. As described in the Architecture Reference Manual.
>> Provides an IMPLEMENTATION
>> 	DEFINED classification of the external abort.
>
> This is from 'D7.2.28 - ESR_ELx, Exception Syndrome Register (ELx)' of
> DDI0487B.a. If you don't set that bit, its not an external abort.
> Implementation-defined refers to the classification: your CPU implementation
> is
> allowed to choose what it classifies as 'external'.
> For RAS, your firmware must set this bit if it wants to use SEA as the APEI
> notification type.
  I think this bit are not must set by firmware if the esr_el3 does
not set this bit.

>
> What is the ESR_EL2 value when this happens?
> Do you trap this to firmware first? (its not firmware-first RAS if you
> don't).
>
>
>>> This goes on to call ghes_notify_sea() which will handle the error and
>>> cause KVM
>>> to exit this function. KVM makes no further attempt to handle the fault
>>> as APEI
>>> should have done everything necessary. KVM will re-enter the guest,
>>> unless there
>>> are signals pending.
>
>> In my code, there is not Tyler's such modification.
>
> Tyler's series added support to KVM for handling RAS notifications via SEA.
>
>
>> firstly, the poison error is related with RAS, and poison error match the
>> is_abort_sea(fault_status)
>
> (So it is an external abort? Now I'm confused)
    you may misunderstand that as your another mail mentioned

>
>
>> so the KVM will exit,  and SIGBUS signal have no chance to be delivered.
>
> kvm_handle_guest_abort() will return 1 through handle_exit() and into
> kvm_arch_vcpu_ioctl_run()'s while (ret > 0) { } loop.
>
> KVM should re-enter the guest because the APEI GHES RAS code said it had
> handled
> the error.
yes, it is!  sorry, I  I didn't say it clearly, it should
kvm_handle_guest_abort() exit, not kvm exit.  thank you for your
correction.

>
>
>> I suggest it does not return in Tyler's patch
>
> This is required because the notification about a RAS fault may not be a
> sensible guest fault. In your example its not a sensible guest exit because
> you
> haven't set HPFAR_EL2. KVM can't handle a guest fault without this
> register.
In the firmware-first RAS solution, the HPFAR_EL2 does not set in any
case, becuase it traps to EL3, not EL2.
I think we should use "AT" instruction to translation GVA to IPA
address  and write the translation result to the hpfar_el2 in the
firmware.

>
>
>> or move kvm_send_hwpoison_signal function before return.
>
> Here we are talking about RAS notifications from firmware. (1)
>
> kvm_send_hwpoison_signal() is for handling normal stage2 faults where the
> page
> to map has been poisoned (2). By this point the CPU's RAS features and
> firmware
> are not involved.
>
> These are two different things, a well behaved machine-monitor and guest
> will
> never touch a poisoned page once its received a notification due to (1).
> This
> patch addresses a corner case that covers Qemu/kvmtool not handling (1)
> properly, or the guest ignoring the notification, (and all the races in
> between).
>
>
>>> (You're right that here the fault_ipa is the wrong thing to pass, but
>>> handle_guest_sea() doesn't use it...)
>>>
>>> We do need to enable HCR_EL2.TEA which was added with v8.2s RAS
>>> extensions, but
>>> the cpufeature patch is a pre-requisite.
>
>> HCR_EL2.TEA will Route synchronous External Abort exceptions from
>> Non-secure EL0 and EL1 to EL2, if not routed to EL3.
>>
>> in the firmware-first RAS solution, this bit can not control to route to
>> El2 because the exception is route to EL3.
>>
>> enabling HCR_EL2.TEA can be better for the non firmware-first RAS
>> solution.
>> but can not solve this issue.
>
> Your firmware receives an external abort from the CPU, trapped to EL3 by
> SCR_EL3.EA. It chooses to notify the OS via APEI's SEA notification type.
> How
> does it choose whether to target EL2 or EL1 for the fake software-generated
> SEA-notification? To correctly emulate what the CPU would do, it should
> inspect
> HCR_EL2.TEA, and route the notification accordingly.
  James, you are right, we should set the HCR_EL2.TEA, thanks for your
suggestion. I have submitted a patch for your review.

>
>
>> my firmware will route the injected-External-Aborts to the hypervisor if
>> the
>> error come from guest OS.
>
> How do you know there is a hypervisor at EL2 and guest OS at EL1? Disable
In my previous solution, firmware will check the vttbr_el2, if the
vttbr_el2 is not zero, then firmware jump to El1. otherwise, if the
vttbr_el2 is zero, jump to EL2.  this way may not good,  set the
hcr_el2.TEA is reasonable.

> both
> KVM and VHE in Linux and boot. Now you have host Linux at EL1 and only the
> hyp-stub at EL2.
>
> These are the complications with hanging APEI notification on an existing
> part
> of the architecture.
>
>
>>> The path to the below code that uses fault_ipa->gfn->pfn->hva is:
>>> kvm_handle_guest_abort()
>>> user_mem_abort()
>>> kvm_send_hwpoison_signal().
>>>
>>> But for an external abort due to RAS we never get past
>>> kvm_handle_guest_abort()
>>> as we call out to the APEI ghes to handle the RAS error instead.
>
>> so this patch can not work.
>
> To notify Qemu/kvmtool about a RAS fault? That's not what this patch does.
>
> v3 of this patch has a much better commit message:
> ----%<----
> memory_failure() has two modes, early and late. Early is used by
> machine-managers like Qemu to receive a notification when a memory error is
> notified to the host. These can then be relayed to the guest before the
> affected page is accessed. To enable this, the process must set
> PR_MCE_KILL_EARLY in PR_MCE_KILL_SET using the prctl() syscall.
>
> Once the early notification has been handled, nothing stops the
> machine-manager or guest from accessing the affected page. If the
> machine-manager does this the page will fail to be mapped and SIGBUS will
> be sent. This patch adds the equivalent path for when the guest accesses
> the page, sending SIGBUS to the machine-manager.
>
> These two signals can be distinguished by the machine-manager using their
> si_code: BUS_MCEERR_AO for 'action optional' early notifications, and
> BUS_MCEERR_AR for 'action required' synchronous/late notifications.
> ----%<----
>
> On receipt of a RAS notification, KVM calls out to the APEI code which
> handles
> the error. KVM can now go back to running the guest.
>
> Handling the error may have caused a signal to be sent to Qemu, in which
> case we
> won't get back into the guest, as the signal_pending() test in
> kvm_arch_vcpu_ioctl_run() will cause us to return to Qemu instead. This is
> the
> early path. It happens when we get the RAS notification from firmware.
>
>
> This patch is concerned with the late path. When either Qemu/kvmtool or the
> guest failed to handle the early notification and went and touched the
> affected
> memory again. In this case we don't take a fault via firmware as
> memory_failure() has unmapped the page from stage2, we take a normal stage2
> fault instead. KVM won't re-map the poisoned page, it sends a late
> notification
> instead.
  than you very much for your detailed explaination, got it.

>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
