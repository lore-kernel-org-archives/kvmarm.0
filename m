From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 3/3] arm64: kvm: inject SError with user space specified
 syndrome
Date: Thu, 06 Jul 2017 17:39:24 +0100
Message-ID: <595E67BC.6050707@arm.com>
References: <1498481199-24118-1-git-send-email-gengdongjiu@huawei.com>
 <20170703083903.GE4066@cbox>
 <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com> <595B6A8A.1050809@arm.com>
 <b2b80fd0-4a8f-d605-590e-17785eee2e8b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC92440D14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 12:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eghqmZJ7boCs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jul 2017 12:40:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 616DF40D11
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 12:39:59 -0400 (EDT)
In-Reply-To: <b2b80fd0-4a8f-d605-590e-17785eee2e8b@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Christoffer Dall <cdall@linaro.org>, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, corbet@lwn.net, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Gaozhihui <zhihui.gao@huawei.com>, huangshaoyu@huawei.com, huhuajun@huawei.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 05/07/17 09:14, gengdongjiu wrote:
> On 2017/7/4 18:14, James Morse wrote:
>> Can you give us a specific example of an error you are trying to handle?

> For example:
> guest OS user space accesses device type memory, but happen SError. because the
> SError is asynchronous faults, it does not take immediately. when guest OS call "SVC" to enter guest os
> kernel space, the ESB instruction(Error Synchronization Barrier) will defter this SError. so the SError happen immediately.

Ah, this isn't necessarily a 'RAS notification' SError/SEI, it may be a
'vanilla', v8.0 SError.

You've given a guest access to a physical device (how?), the guest has done
something, which caused the device to respond with SError.

Do you have a specific use-case for this? What is the ESR? What kinds of CPER
records does firmware generate? (if any)


We have to be careful here as devices can still generate asynchronous-interrupts
using SError, these aren't contained by ESB barriers. For these we should fall
back to KVM's v8.0 SError behaviour. KVM can tell them apart as the APEI code
doesn't claim the SError as an SEI notification, and with the RAS extensions the
ESR has the 'IDS' bit set.


>> How would a non-KVM user space process handle the error?

> it is indeed, non-KVM user space can not get the notification from hypervisor or host kernel. thanks for the pointing out
> do you mean still Signal SIGBUS from memory_failure?

No, I was assuming this was a RAS notification SEI, (because your patch 1/3 of
touched the RAS cpu-features) being given to user space to handle.

Instead, can I ask how the host should handle this SError if it had accessed the
device itself?


I agree device pass-through is going to be a special case for KVM, but before
the host can deliver a device RAS error into the guest that was using the
device, it needs to fully understand what the error means:

The error may mean that the careful configuration that makes device-passthrough
safe no longer works, letting the guest continue to access the device may let it
damage another guest or the hyper visor.


We may need a way for the host RAS code to identify the driver responsible, to
handle the device error, or delegate it if that's appropriate.


[...]

>> So (a): a physical-CPU hardware error occurs, and then (c) we tell Qemu/kvmtool
>> via a KVM-specific API.
>>
>> Don't do this, it doesn't work for non-KVM users. You are exposing host-specific
>> implementation details to user space. What if I discover the same error via a
>> Polling GHES, or one of the IRQ flavours?

> James, you mainly concern the way that "tell Qemu/kvmtool via a KVM-specific API", right?
> so how about still delivered SIGBUS same as the SEA(Synchronous External Abort)?

> by the way, what is your meaning of below words?
>  >"What if I discover the same error via a Polling GHES, or one of the IRQ flavours?"

This was my mistaken assumption that you were passing an APEI RAS SEI
notification to user space via a KVM specific API. This wouldn't work for
applications not using KVM, or notifications not using SEI.

Here I was asking what happens if the notification used NOTIFY_POLL or
NOTIFY_IRQ (instead of NOTIFY_SEI) in the GHES, but this isn't relevant as it
doesn't look like this is a APEI RAS notification.

[...]


>> If there is another type of CPER record where we should notify userspace, please
>> do it from mm/memory-failure.c, drivers/acpi/apei/ghes.c or
>> drivers/firmware/efi/cper.c. These should consider all user-space applications,
>> not just users of KVM, and not just on arm64.
> 
> here I have a question, in the "drivers/acpi/apei/ghes.c" code, it only handle the memory section of CPER.

Yes, we are certainly missing processing for the other record types.


> if the section type of CPER is processor, it will not notify user-space. so only let userspace handle the memory section is reasonable?

I think the only errors that user-space can know more than the kernel are memory
errors. These are the only RAS errors we should expect user space to handle. All
the others fall into either 'corrected by the kernel' or 'fatal for userspace -
SIGKILL'.


>> For memory errors we already have BUS_MCEERR_AR - action-required, and
>> BUS_MCEERR_AO - action-optional.
>>
>> For a TLB error, (Table 250 of UEFI 2.6), what is Qemu expected to do? Linux has
>> to classify the error and handle it as far as possible. In most cases the error
>> is either handled (no notification required), or fatal. Memory errors are the
>> only example I've found so far where an application can do additional work to
>> handle the error.

>   James, only memory errors needs application to do additional work. UEFI spec mentioned that?

No, its my observation based on the record types. Memory is the only thing an
application can change. Everything else belongs to the kernel.
For a corrupt page of anonymous memory, there is nothing the kernel can do, but
report the data lost. The application (e.g. web browser) may know what the
corrupt data was, and if/how it can retrieve it again. This isn't true of
Processor/Cache/TLB/PCIe errors, which cover the other CPER records.


Thanks,

James
