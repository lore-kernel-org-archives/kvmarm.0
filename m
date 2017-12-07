From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Thu, 7 Dec 2017 14:37:19 +0800
Message-ID: <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5A283F26.3020507@arm.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/12/7 3:04, James Morse wrote:
> Hi gengdongjiu,
> 
> On 06/12/17 10:26, gengdongjiu wrote:
>> On 2017/11/15 0:00, James Morse wrote:
>>>> +		 * error has not been propagated
>>>> +		 */
>>>> +		run->exit_reason = KVM_EXIT_EXCEPTION;
>>>> +		run->ex.exception = ESR_ELx_EC_SERROR;
>>>> +		run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
>>>> +		return 0;
>>> We should not pass RAS notifications to user space. The kernel either handles
>>> them, or it panics(). User space shouldn't even know if the kernel supports RAS
>>> until it gets an MCEERR signal.
>>>
>>> You're making your firmware-first notification an EL3->EL0 signal, bypassing the OS.
>>>
>>> If we get a RAS SError and there are no CPER records or values in the ERR nodes,
>>> we should panic as it looks like the CPU/firmware is broken. (spurious RAS errors)
> 
>> do you think whether we need to set the guest ESR by user space?  if need, I need to
>> notify user space that there is a SError happen and need to set ESR for guest in some place of
>> KVM.
> 
> I think you are still coming from a world where user-space gets raw RAS
> notifications via KVM. This should not happen because the notification method is
> private to firmware and the kernel. KVM is just in the way when a guest is running.
> 
> Notifications reaching KVM should be plumbed into the APEI-firmware-first-code
> or eventually, a kernel-first mechanism if APEI doesn't 'claim' them.
> 
> The kernel RAS code may signal user-space with the symptoms of the error, and
> user-space may decided to generate a new RAS notification for the guest.
> 
> This should function in exactly the same way, regardless of which notification
> method is in use between the kernel and firmware. (its the only way to make this
> future-proof).
> 
> Which notification user-space chooses to use entirely depends on what (if
> anything) it advertised to the guest in the HEST. User-space has to be in
> control of triggering any SError, not just overriding the ESR when KVM has
> decided it wants to kill the guest.

thanks, I will explain more.

> 
> 
>> so here I return a error code to user space. you mean we should not pass RAS notifications
>> to user space, so could you give some suggestion how to notify user space to set guest ESR.
> 
> KVM shouldn't give the guest an SError when it takes a RAS notification, it
> should pass the notification to the kernel RAS code. It only needs to 'fall
> through' to some default cause if both APEI and kernel-first deny-all-knowledge
> of this notification.
> 
> 
> The end-to-end flow is then (assuming no-VHE):
> (1)An error occurs, taking the CPU to EL3.
> EL3: triage the error, generate CPER, notify the OS
> EL2: KVM takes the notification, exits the guest, returns to host EL1.
> EL1: KVM handle_exit() calls APEI to handle the error.
> This is the end of KVMs involvement in RAS - its just plumbing.
> 
> (2)APEI processes the CPER records and signals affected processes.
> If KVM's user-space is affected, KVM will spot the pending signal when it goes
> to re-enter the guest, and exit to user-space instead.
> Qemu takes the SIGBUS_MCEERR_A{O,R}.
> 
> (3) Qemu decides it wants to hand the guest a RAS error, it populates the CPER
> records (in memory only Qemu knows about), then drives the KVM API to make the
> appropriate notification appear.
> 
> 
> (1) only happens if the guest was running when the error arrived. GHES has ~4
> flavours of IRQ which may be used to describe corruption in guest memory. Steps
> (2) and (3) are exactly the same in this case.
> 
> Qemu may decide to trigger RAS errors all by itself, (probably for testing and
> debugging), in which case (1) and (2) don't happen, but (3), is exactly the same.
> 
> 
> This way platform-firmware/host-kernel can use kernel-first or firmware-first
> with any of the notifications, independently from Qemu/guest-kernel making a
> different kernel-first or firmware-first with different notifications.
> 
> Passing information out of KVM breaks this, forcing Qemu to know about the
> mechanism platform-firmware is using.
> 
> 
> We need to tackle (1) and (3) separately. For (3) we need some API that lets
> Qemu _trigger_ an SError in the guest, with a specified ESR. But, we don't have
> a way of migrating pending SError yet... which is where I got stuck last time I
> was looking at this.

I understand you most idea.

But In the Qemu one signal type can only correspond to one behavior, can not correspond to two behaviors,
otherwise Qemu will do not know how to do.

For the Qemu, if it receives the SIGBUS_MCEERR_AR signal, it will populate the CPER
records and inject a SEA to guest through KVM IOCTL "KVM_SET_ONE_REG"; if receives the SIGBUS_MCEERR_AO
signal, it will record the CPER and trigger a IRQ to notify guest, as shown below:

SIGBUS_MCEERR_AR trigger Synchronous External Abort.
SIGBUS_MCEERR_AO trigger GPIO IRQ.

For the SIGBUS_MCEERR_AO and SIGBUS_MCEERR_AR, we have already specify trigger method, which all

not involve _trigger_ an SError.

so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.

> 
> 
> 
> James
> 
> .
> 

