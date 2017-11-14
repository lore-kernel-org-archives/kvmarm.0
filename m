From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 0/7] Support RAS virtualization in KVM
Date: Tue, 14 Nov 2017 16:00:44 +0000
Message-ID: <5A0B132C.6070400@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 10/11/17 19:54, Dongjiu Geng wrote:
> This series patches mainly do below things:
> 
> 1. Trap RAS ERR* registers Accesses to EL2 from Non-secure EL1,
>    KVM will will do a minimum simulation, there registers are simulated
>    to RAZ/WI in KVM.
> 2. Route synchronous External Abort exceptions from Non-secure EL0
>    and EL1 to EL2. When exception EL3 routing is enabled by firmware,
>    system will trap to EL3 firmware instead of EL2 KVM, then firmware
>    judges whether El2 routing is enabled, if enabled, jump to EL2 KVM, 
>    otherwise jump to EL1 host kernel.
> 3. Enable APEI ARv8 SEI notification to parse the CPER records for SError
>    in the ACPI GHES driver, KVM will call handle_guest_sei() to let ACPI
>    driver to parse the CPER record for SError which happened in the guest
> 4. Although we can use APEI driver to handle the guest SError, but not all
>    system support SEI notification, such as kernel-first. So here KVM will
>    also classify the Error through Exception Syndrome Register and do different
>    approaches according to Asynchronous Error Type

> 5. If the guest SError error is not propagated and not consumed, then KVM return
>    recoverable error status to user-space, user-space will specify the guest ESR

I thought we'd gone over this. There should be no RAS errors/notifications in
user space. Only the symptoms should be sent, using the SIGBUS_MCEERR_A{O,R} if
the kernel has handled as much as it can. This hides the actual mechanisms the
kernel and firmware used.

User-space should not have to know how to handle RAS errors directly. This is a
service the operating system provides for it. This abstraction means the smae
user-space code is portable between x86, arm64, powerpc etc.

What if the firmware uses another notification method? User space should expect
the kernel to hide things like this from it.

If the kernel has no information to interpret a notification, how is user space
supposed to know?

I understand you are trying to work around your 'memory corruption at an unknown
address'[0] problem, but if the kernel can't know where this corrupt memory is
it should really reboot. What stops this corrupt data being swapped to disk?

Killing 'the thing' that was running at the time is not sufficient because we
don't know that this 'got' all the users of the corrupt memory. KSM can merge
pages between guests. This is the difference between the error persisting
forever killing off all the VMs one by one, and the corrupt page being silently
re-read from disk clearing the error.


>    and inject a virtual SError. For other Asynchronous Error Type, KVM directly
>    injects virtual SError with IMPLEMENTATION DEFINED ESR or KVM is panic if the
>    error is fatal. In the RAS extension, guest virtual ESR must be set, because
>    all-zero  means 'RAS error: Uncategorized' instead of 'no valid ISS', so set
>    this ESR to IMPLEMENTATION DEFINED by default if user space does not specify it.


Thanks,

James


[0] https://www.spinics.net/lists/arm-kernel/msg605345.html
