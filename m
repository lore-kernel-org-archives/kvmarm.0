From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: add esr_el2 and far_el2 to sysreg
Date: Tue, 08 Aug 2017 17:27:01 +0100
Message-ID: <5989E655.2070905@arm.com>
References: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com> <9fe6aa3a-98f9-6cae-6932-054858b54744@arm.com> <b834276b-b47d-51fb-7661-3eb5a2f6a68d@huawei.com> <59889C59.80207@arm.com> <7569b9a7-ce5f-8cb2-2997-a2818ac7d854@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7569b9a7-ce5f-8cb2-2997-a2818ac7d854@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 07/08/17 18:43, gengdongjiu wrote:
> Another question, For the SEI, I want to also use SIGBUS both for the KVM user and non-kvm user,
> if SEA and SEI Error all use the SIGBUS to notify user space(Qemu),

User-space shouldn't necessarily be notified about Synchronous External Aborts
or SError Interrupts. You're really asking about RAS firmware-first
notifications that use these as the notification mechanism.

We should not notify user-space that the guest happened to be interrupted by a
RAS firmware-first notification. It may not be relevant, and we can't know until
we parse the CPER records. The notification mechanism is between firmware and
the host kernel, we should never expose anything about it to user space or a guest.

Linux should act on the CPER records first to determine if the host kernel can
keep running. Once it has done this it can deliver signals to affected
processes, but which signal and its properties depends on the CPER records.

The example here is BUS_MCEERR_AO and BUS_MCEERR_AR. These notify userspace that
si_addr_lsb bits of memory are corrupt at si_addr, this is either
Action-Optional or Action-Required.

For arm64 we just needed to turn this code on, it already presents the minimum
necessary information to user-space in an architecture-agnostic way. We didn't
need to do anything to this code to support NOTIFY_SEA, the notification
mechanism is irrelevant, this is all driven by the CPER records.

If you have a class of error that isn't covered by the memory-failure code, then
we need to add something similar. This should be based on the CPER records, and
should work in exactly the same way for all processes on all ACPI platforms.


> do you agree my solution for the SEI? thanks.

No, you are trying to notify userspace that firmware notified the host. This
creates an ABI between EL3 firmware and EL0 user space that we can't possibly
support.

I think you've come to this because you are merging two steps together:
1. The OS uses the v8.2 RAS extensions to isolate errors and notify firmware.
2. If firmware has to tell the OS about the error, firmware generates CPER records.
3. Firmware triggers the GHES notification mechanism for this error source.
4. Linux receives the notification and calls ghes_proc(), (if KVM gets the
notification because a guest happened to be running, it should switch back to
the host and arrange for ghes_proc() to be called).
5. ghes_proc() parses the CPER records and calls other kernel helpers to handle
the specific type of error, e.g. memory_failure().
6. If the helper knows the kernel can keep running, the error is visible to
user-space and user space could do further processing to correct the error, an
error-specific signal is sent.
7. User-space reloads the webpage, notifies the guest or whatever is appropriate.

You are merging steps 3 and 7.

The notification method is an abstraction that only matters to steps 3&4, this
lets us add more without rewriting the world.
User-space signals are an abstraction between steps 6&7, this works across
architectures, even those not using APEI firmware first.
There are no shortcuts here. Doing anything else creates more work for user
space, another platform or another architecture.


Thanks,

James
