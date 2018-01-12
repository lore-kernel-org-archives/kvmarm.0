From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Fri, 12 Jan 2018 18:05:23 +0000
Message-ID: <5A58F8E3.5060002@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
 <506cd212-3d16-ba2a-518f-34982bc162fc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2524649DB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 13:02:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OmziK6Pv4cOU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 13:02:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B940B49D51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 13:02:52 -0500 (EST)
In-Reply-To: <506cd212-3d16-ba2a-518f-34982bc162fc@huawei.com>
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
Cc: wuquanming@huawei.com, linux-doc@vger.kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, corbet@lwn.net, rjw@rjwysocki.net, linux@armlinux.org.uk, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, linux-arm-kernel@lists.infradead.org, huangshaoyu@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 15/12/17 03:30, gengdongjiu wrote:
> On 2017/12/7 14:37, gengdongjiu wrote:
>>> We need to tackle (1) and (3) separately. For (3) we need some API that lets
>>> Qemu _trigger_ an SError in the guest, with a specified ESR. But, we don't have
>>> a way of migrating pending SError yet... which is where I got stuck last time I
>>> was looking at this.
>> I understand you most idea.
>>
>> But In the Qemu one signal type can only correspond to one behavior, can not correspond to two behaviors,
>> otherwise Qemu will do not know how to do.
>>
>> For the Qemu, if it receives the SIGBUS_MCEERR_AR signal, it will populate the CPER
>> records and inject a SEA to guest through KVM IOCTL "KVM_SET_ONE_REG"; if receives the SIGBUS_MCEERR_AO
>> signal, it will record the CPER and trigger a IRQ to notify guest, as shown below:
>>
>> SIGBUS_MCEERR_AR trigger Synchronous External Abort.
>> SIGBUS_MCEERR_AO trigger GPIO IRQ.
>>
>> For the SIGBUS_MCEERR_AO and SIGBUS_MCEERR_AR, we have already specify trigger method, which all
>>
>> not involve _trigger_ an SError.
>>
>> so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.
> 
> As I explained above:
> 
> If Qemu received SIGBUS_MCEERR_AR, it will record CPER and trigger Synchronous External Abort;
> If Qemu received SIGBUS_MCEERR_AO, it will record CPER and trigger GPIO IRQ;

> So Qemu does not know when to _trigger_ an SError.

There is no answer to this. How the CPU decides is specific to the CPU design.
How Qemu decides is going to be specific to the machine it emulates.

My understanding is there is some overlap for which RAS errors are reported as
synchronous external abort, and which use SError. (Obviously the imprecise ones
are all SError). Which one the CPU uses depends on how the CPU is designed.

When you take an SIGBUS_MCEERR_AR from KVM, its because KVM can't complete a
stage2 fault because the page is marked with PG_poisoned. These started out as a
synchronous exception, but you could still report these with SError.

We don't have a way to signal user-space about imprecise exceptions, this isn't
a KVM specific problem.


> so here I "return a error" to Qemu if ghes_notify_sei() return failure in [1], if you opposed KVM "return error",
> do you have a better idea about it? thanks

If ghes_notify_sei() fails to claim the error, we should drop through to
kernel-first-handling. We don't have that yet, just the stub that ignores errors
where we can make progress.

If neither firmware-first nor kernel-first claim a RAS error, we're in trouble.
I'd like to panic() as we got a RAS notification but no description of the
error. We can't do this until we have kernel-first support, hence that stub.


> About the way of migrating pending SError, I think it is a separate case, because Qemu still does not know
> how and when to trigger the SError.

I agree, but I think we should fix this first before we add another user of this
unmigratable hypervisor state.

(I recall someone saying migration is needed for any new KVM/cpu features, but I
can't find the thread)


> [1]:
> static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
> {
>         .......................
> +       case ESR_ELx_AET_UER:   /* The error has not been propagated */
> +               /*
> +                * Userspace only handle the guest SError Interrupt(SEI) if the
> +                * error has not been propagated
> +                */
> +               run->exit_reason = KVM_EXIT_EXCEPTION;
> +               run->ex.exception = ESR_ELx_EC_SERROR;

I'm against telling user space RAS errors ever happened, only the final
user-visible error when the kernel can't fix it.

This is inventing something new for RAS errors not claimed by firmware-first.
If we have kernel-first too, this will never happen. (unless your system is
losing the error description).


Your system has firmware-first, why isn't it claiming the notification?
If its not finding CPER records written by firmware, check firmware and the UEFI
memory map agree on the attributes to be used when read/writing that area.


> +               run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
> +               return 0;


Thanks,

James
