From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Fri, 15 Dec 2017 11:30:57 +0800
Message-ID: <506cd212-3d16-ba2a-518f-34982bc162fc@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/12/7 14:37, gengdongjiu wrote:
>> We need to tackle (1) and (3) separately. For (3) we need some API that lets
>> Qemu _trigger_ an SError in the guest, with a specified ESR. But, we don't have
>> a way of migrating pending SError yet... which is where I got stuck last time I
>> was looking at this.
> I understand you most idea.
> 
> But In the Qemu one signal type can only correspond to one behavior, can not correspond to two behaviors,
> otherwise Qemu will do not know how to do.
> 
> For the Qemu, if it receives the SIGBUS_MCEERR_AR signal, it will populate the CPER
> records and inject a SEA to guest through KVM IOCTL "KVM_SET_ONE_REG"; if receives the SIGBUS_MCEERR_AO
> signal, it will record the CPER and trigger a IRQ to notify guest, as shown below:
> 
> SIGBUS_MCEERR_AR trigger Synchronous External Abort.
> SIGBUS_MCEERR_AO trigger GPIO IRQ.
> 
> For the SIGBUS_MCEERR_AO and SIGBUS_MCEERR_AR, we have already specify trigger method, which all
> 
> not involve _trigger_ an SError.
> 
> so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.

As I explained above:

If Qemu received SIGBUS_MCEERR_AR, it will record CPER and trigger Synchronous External Abort;
If Qemu received SIGBUS_MCEERR_AO, it will record CPER and trigger GPIO IRQ;
So Qemu does not know when to _trigger_ an SError.

so here I "return a error" to Qemu if ghes_notify_sei() return failure in [1], if you opposed KVM "return error",
do you have a better idea about it? thanks

About the way of migrating pending SError, I think it is a separate case, because Qemu still does not know
how and when to trigger the SError.

[1]:
static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
{
        .......................
+       case ESR_ELx_AET_UER:   /* The error has not been propagated */
+               /*
+                * Userspace only handle the guest SError Interrupt(SEI) if the
+                * error has not been propagated
+                */
+               run->exit_reason = KVM_EXIT_EXCEPTION;
+               run->ex.exception = ESR_ELx_EC_SERROR;
+               run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
+               return 0;
        .......................
}

> 

