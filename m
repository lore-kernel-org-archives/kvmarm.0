From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Thu, 07 Sep 2017 17:30:48 +0100
Message-ID: <59B17438.5070501@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 28/08/17 11:38, Dongjiu Geng wrote:
> when userspace gets SIGBUS signal, it does not know whether
> this is a synchronous external abort or SError,

Why would Qemu/kvmtool need to know if the original notification (if there was
one) was synchronous or asynchronous? This is between firmware and the kernel.


I think I can see why you need this: to choose whether to emulate SEA or SEI,
but what if the guest wasn't running? Or the guest was running, but it wasn't
guest-memory that is affected.

What happens if the dram-scrub hardware spots an error in guest memory, but the
guest wasn't running? KVM won't have a relevant ESR value to give you.

What happens if we start swapping a page of guest memory to disk, and discover
the memory is corrupt. This is synchronous, but it wasn't the guest, and KVM
still can't give you an ESR.

What about CPER records discovered through the polled interface? What happens if
I write a PFN into the corrupt-pfn sysfs interface?


I think what you need is some way of knowing if the BUS_MCEERR_A* was directly
caused by a user-space (or guest) access, and if so was it a data or instruction
fetch. These can become SEA notifications.

KVM's user-space shouldn't be a special-case where the kernel behaves
differently: if we tinker with this it needs to make sense for all user space
processes and mean something on all architectures.

I think this information could be useful to other users of these signals, e.g. a
JVM could silently regenerate/reload code/data for a non-direct-access fault
instead of exit-ing (or throwing an exception) for a direct access.

For BUS_MCEERR_A* from memory_failure() we can't know if they are caused by an
access or not. When the mm code gets -EHWPOISON when trying to resolve a
user-space fault we know it was due to a direct-access. (I don't know if/how x86
can know if it was code or data). Faulting guest accesses through KVM are just a
special version of this where KVM fixes-up stage2.

... but for any of this to work we need the address of the corrupt memory.
(-> cover letter)


Thanks,

James
