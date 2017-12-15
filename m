From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by categorization
Date: Fri, 15 Dec 2017 18:52:47 +0000
Message-ID: <5A3419FF.30101@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com> <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com> <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com> <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 07/12/17 06:37, gengdongjiu wrote:
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

It's a policy choice. How does your virtual CPU notify RAS errors to its virtual
software? You could use SError for SIGBUS_MCEERR_AR, it depends on what type of
CPU you are trying to emulate.

I'd suggest using NOTIFY_SEA for SIGBUS_MCEERR_AR as it avoids problems where
the guest doesn't take the SError immediately, instead tries to re-execute the
code KVM has unmapped from stage2 because its corrupt. (You could detect this
happening in Qemu and try something else)


Synchronous/asynchronous external abort matters to the CPU, but once the error
has been notified to software the reasons for this distinction disappear. Once
the error has been handled, all trace of this distinction is gone.

CPER records only describe component failures. You are trying to re-create some
state that disappeared with one of the firmware-first abstractions. Trying to
re-create this information isn't worth the effort as the distinction doesn't
matter to linux, only to the CPU.


> so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.

You mean there is no reason for Qemu to trigger an SError when it gets a signal
from the kernel.

The reasons the CPU might have to generate an SError don't apply to linux and
KVM user space. User-space will never get a signal for an uncontained error, we
will always panic(). We can't give user-space a signal for imprecise exceptions,
as it can't return from the signal. The classes of error that are left are
covered by polled/irq and NOTIFY_SEA.

Qemu can decide to generate RAS SErrors for SIGBUS_MCEERR_AR if it really wants
to, (but I don't think you should, the kernel may have unmapped the page at PC
from stage2 due to corruption).


I think the problem here is you're applying the CPU->software behaviour and
choices to software->software. By the time user-space gets the error, the
behaviour is different.



Thanks,

James
