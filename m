From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Thu, 21 Sep 2017 15:55:25 +0800
Message-ID: <92f2fecc-9833-15e4-30cc-b4dd5ba93cb7@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
 <59BA7D72.4090403@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59BA7D72.4090403@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, Achin.Gupta@arm.com
Cc: peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@a
List-Id: kvmarm@lists.cs.columbia.edu

Hi James

On 2017/9/14 21:00, James Morse wrote:
> Hi gengdongjiu,

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
> 
> But in our example it wasn't really asynchronous, that was just a property of
> the original CPU->firmware notification. What happens? The guest vcpu is re-run,
> it re-runs the same instructions (this was a contained error so KVM's ELR points
> at/before the instruction that steps in the problem). This time KVM takes a
> stage2 fault, which the mm code will refuse to fixup because the relevant page
> was marked as PG_hwpoision by memory_failure(). KVM signals Qemu/kvmtool with
> SIGBUS_MCEERR_AR. Now Qemu/kvmtool can notify the guest using SEA.

CC Achin

I have some personal opinion, if you think it is not right, hope you can point out.

Synchronous External Abort and SError Interrupt are hardware exception(hardware concept), which is independent of software notification,
in armv8 without RAS, the two concepts already exist. In the APEI spec, in order to better describe the two exceptions, so use SEA and SEI notification to stand for them.

SEA notification stands for Synchronous External Abort, so may be it is not only a notification, it also stands for a hardware error type.
SEI notification stands for SError Interrupt, so may be it is not only a notification, it also stands for a hardware error type.

In the OS, it has different handling flow to the two exception(two notification):
when the guest OS running, if the hardware generates a Synchronous External Abort, we told the guest OS this error is SError Interrupt instead of Synchronous External Abort.
guest OS uses SEI notification handling flow to deal with it, I am not sure whether it will have problem, because the true hardware exception is Synchronous External Abort,
but software treats it as SError interrupt to handle.

In the mainline code, it does not have SEI notification support, the reason I think it is because of the error address record by firmware is not accurate(SError Interrupt is asynchronous exception).
so if treat a hardware Synchronous External Abort as SError interrupt(SEI). The default OS behavior for SEI is PANIC, that is to say, when hardware triggers a Synchronous External Abort(SEA), if guest
treat it as SError interrupt(SEI), the OS will be panic. in fact, it can be recoverable instead of Panic.

I ever added a patch to support the SEI notification, but not sure whether it is can be accepted by open source, until now, not receive response.
