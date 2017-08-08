From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] KVM: arm64: add esr_el2 and far_el2 to sysreg
Date: Wed, 9 Aug 2017 02:27:19 +0800
Message-ID: <24d1038f-2f6c-92af-b308-9313853aaa0b@huawei.com>
References: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com>
 <9fe6aa3a-98f9-6cae-6932-054858b54744@arm.com>
 <b834276b-b47d-51fb-7661-3eb5a2f6a68d@huawei.com> <59889C59.80207@arm.com>
 <7569b9a7-ce5f-8cb2-2997-a2818ac7d854@huawei.com> <5989E655.2070905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD25840A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 14:35:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nB9cNMDG-Wai for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 14:35:04 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B680240017
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 14:35:03 -0400 (EDT)
In-Reply-To: <5989E655.2070905@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/8/9 0:27, James Morse wrote:
> Hi gengdongjiu,
> 
> On 07/08/17 18:43, gengdongjiu wrote:
>> Another question, For the SEI, I want to also use SIGBUS both for the KVM user and non-kvm user,
>> if SEA and SEI Error all use the SIGBUS to notify user space(Qemu),
> 
> User-space shouldn't necessarily be notified about Synchronous External Aborts
> or SError Interrupts. You're really asking about RAS firmware-first
> notifications that use these as the notification mechanism.
Firstly, we am talking the RAS firmware-first solution. I mainly
want to let user space to know what is the Error type for this hardware error(Synchronous or asynchronous).
we do not care the notification mechanism. As our agreement before , Qemu will record the CPER for the
guest OS. if Qemu does not know the Error type, it can not record the CPER. because in the ghes there is a field to
fill the error type.

I paste the APEI table layout:
https://wiki.linaro.org/LEG/Engineering/Kernel/RAS/APEITables

usual the notification type is classified by the hardware type




> 
> We should not notify user-space that the guest happened to be interrupted by a
> RAS firmware-first notification. It may not be relevant, and we can't know until
> we parse the CPER records. The notification mechanism is between firmware and
> the host kernel, we should never expose anything about it to user space or a guest.
I agree with you this sentence, for the hardware error, host kernel will firstly deal with, and then decided whether to
notified Qemu/KVM tools. In this process, we do not care what is the notification mechanism between
firmware and host kernel. we only concern the hardware error type. different type, Qemu/KVM tools will have different behavior.

> 
> Linux should act on the CPER records first to determine if the host kernel can
> keep running. Once it has done this it can deliver signals to affected
> processes, but which signal and its properties depends on the CPER records.

 if want Qemu to handle this Error, I think qemu/kvmtools should know hardware error type, else it will be confused and do not know how to deal with.

> 
> The example here is BUS_MCEERR_AO and BUS_MCEERR_AR. These notify userspace that
> si_addr_lsb bits of memory are corrupt at si_addr, this is either
> Action-Optional or Action-Required.
> 
> For arm64 we just needed to turn this code on, it already presents the minimum
> necessary information to user-space in an architecture-agnostic way. We didn't
> need to do anything to this code to support NOTIFY_SEA, the notification
> mechanism is irrelevant, this is all driven by the CPER records.
 we do not care the notification type, we are only care the hardware error type.
 if user-space do not know the error type, it can not record the CPER and can not inject the proper Error to guest OS.
 because record CPER and inject the Error to guest OS need this hardware error type. different Error type, there is
 different behavior.

 For different hardware error type, X86 Qemu/kvm tools code also have different behaviour in

> 
> If you have a class of error that isn't covered by the memory-failure code, then
> we need to add something similar. This should be based on the CPER records, and
> should work in exactly the same way for all processes on all ACPI platforms.
> 
> 
>> do you agree my solution for the SEI? thanks.
> 
> No, you are trying to notify userspace that firmware notified the host. This
> creates an ABI between EL3 firmware and EL0 user space that we can't possibly
> support.

you may misunderstand I mentioned solution here. I mean using memory-failure code to signal user space
for the SError(SEI), this way does not creates any ABI. SEA/SEI all use same method.
Qemu can judge the ESR to know the hardware type.


> 
> I think you've come to this because you are merging two steps together:
> 1. The OS uses the v8.2 RAS extensions to isolate errors and notify firmware.
> 2. If firmware has to tell the OS about the error, firmware generates CPER records.
> 3. Firmware triggers the GHES notification mechanism for this error source.
> 4. Linux receives the notification and calls ghes_proc(), (if KVM gets the
> notification because a guest happened to be running, it should switch back to
> the host and arrange for ghes_proc() to be called).
> 5. ghes_proc() parses the CPER records and calls other kernel helpers to handle
> the specific type of error, e.g. memory_failure().
> 6. If the helper knows the kernel can keep running, the error is visible to
> user-space and user space could do further processing to correct the error, an
> error-specific signal is sent.
> 7. User-space reloads the webpage, notifies the guest or whatever is appropriate.
> 
> You are merging steps 3 and 7.
  No, not merge them. in above steps, the steps 7 needs to know the hardware type. if it does not know the
  hardware error type, user space can not correctly do further processing. we do not care the notification type.
  we only care what is the hardware error type.

> 
> The notification method is an abstraction that only matters to steps 3&4, this
> lets us add more without rewriting the world.
> User-space signals are an abstraction between steps 6&7, this works across
> architectures, even those not using APEI firmware first.
  so here can I understand that you also agree that SError type can also use signals to be delivered to user space?


> There are no shortcuts here. Doing anything else creates more work for user
> space, another platform or another architecture.
> 
> 
> Thanks,
> 
> James
> 
> .
> 
