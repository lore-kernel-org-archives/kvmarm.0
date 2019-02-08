From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v8 00/26] APEI in_nmi() rework and SDEI wire-up
Date: Fri, 08 Feb 2019 12:40:07 +0100
Message-ID: <15200237.N8Ro7ITLGE@aspire.rjw.lan>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190129184902.102850-1-james.morse@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tuesday, January 29, 2019 7:48:36 PM CET James Morse wrote:
> Changes since v7?
>  * Removed the memory allocation in the task_work stuff.
>  * More user-friendly and easier on the eye,
>  * Switched the irq-mask testing in the arch code to be safe before&after
>    Julien's GIC PMR series.
> Specific changes are noted in each patch.
> 
> 
> This series aims to wire-up arm64's fancy new software-NMI notifications
> for firmware-first RAS. These need to use the estatus-queue, which is
> also needed for notifications via emulated-SError. All of these
> things take the 'in_nmi()' path through ghes_copy_tofrom_phys(), and
> so will deadlock if they can interact, which they might.
> 
> To that end, this series removes the in_nmi() stuff from ghes.c.
> Locks are pushed out to the notification helpers, and fixmap entries
> are passed in to the code that needs them. This means the estatus-queue
> users can interrupt each other however they like.
> 
> While doing this there is a fair amount of cleanup, which is (now) at the
> beginning of the series. NMIlike notifications interrupting
> ghes_probe() can go wrong for three different reasons. CPER record
> blocks greater than PAGE_SIZE dont' work.
> The estatus-pool allocation is simplified and the silent-flag/oops-begin
> is removed.
> 
> Nothing in this series is intended as fixes, as its all cleanup or
> never-worked.
> 
> ----------%<----------
> The earlier boiler-plate:
> 
> What's SDEI? Its ARM's "Software Delegated Exception Interface" [0]. It's
> used by firmware to tell the OS about firmware-first RAS events.
> 
> These Software exceptions can interrupt anything, so I describe them as
> NMI-like. They aren't the only NMI-like way to notify the OS about
> firmware-first RAS events, the ACPI spec also defines 'NOTFIY_SEA' and
> 'NOTIFY_SEI'.
> 
> (Acronyms: SEA, Synchronous External Abort. The CPU requested some memory,
> but the owner of that memory said no. These are always synchronous with the
> instruction that caused them. SEI, System-Error Interrupt, commonly called
> SError. This is an asynchronous external abort, the memory-owner didn't say no
> at the right point. Collectively these things are called external-aborts
> How is firmware involved? It traps these and re-injects them into the kernel
> once its written the CPER records).
> 
> APEI's GHES code only expects one source of NMI. If a platform implements
> more than one of these mechanisms, APEI needs to handle the interaction.
> 'SEA' and 'SEI' can interact as 'SEI' is asynchronous. SDEI can interact
> with itself: its exceptions can be 'normal' or 'critical', and firmware
> could use both types for RAS. (errors using normal, 'panic-now' using
> critical).
> ----------%<----------
> 
> This series is base on v5.0-rc1, and can be retrieved from:
> git://linux-arm.org/linux-jm.git -b apei_ioremap_rework/v8
> 
> 
> Known issues:
>  * ghes_copy_tofrom_phys() already takes a lock in NMI context, this
>    series moves that around, and makes sure we never try to take the
>    same lock from different NMIlike notifications. Since the switch to
>    queued spinlocks it looks like the kernel can only be 4 context's
>    deep in spinlock, which arm64 could exceed as it doesn't have a
>    single architected NMI. This would be fixed by dropping back to
>    test-and-set when the nesting gets too deep:
>  lore.kernel.org/r/1548215351-18896-1-git-send-email-longman@redhat.com
> 
> * Taking an NMI from a KVM guest on arm64 with VHE leaves HCR_EL2.TGE
>   clear, meaning AT and TLBI point at the guest, and PAN/UAO are squiffy.
>   Only TLBI matters for APEI, and this is fixed by Julien's patch:
>  http://lore.kernel.org/r/1548084825-8803-2-git-send-email-julien.thierry@arm.com
> 
> * Linux ignores the physical address mask, meaning it doesn't call
>   memory_failure() on all the affected pages if firmware or hypervisor
>   believe in a different page size. Easy to hit on arm64, (easy to fix too,
>   it just conflicts with this series)
> 
> 
> [v7] https://lore.kernel.org/linux-arm-kernel/20181203180613.228133-1-james.morse@arm.com/
> [v6] https://www.spinics.net/lists/linux-acpi/msg84228.html
> [v5] https://www.spinics.net/lists/linux-acpi/msg82993.html
> [v4] https://www.spinics.net/lists/arm-kernel/msg653078.html
> [v3] https://www.spinics.net/lists/arm-kernel/msg649230.html
> 
> [0] https://static.docs.arm.com/den0054/a/ARM_DEN0054A_Software_Delegated_Exception_Interface.pdf
> 
> 
> James Morse (26):
>   ACPI / APEI: Don't wait to serialise with oops messages when
>     panic()ing
>   ACPI / APEI: Remove silent flag from ghes_read_estatus()
>   ACPI / APEI: Switch estatus pool to use vmalloc memory
>   ACPI / APEI: Make hest.c manage the estatus memory pool
>   ACPI / APEI: Make estatus pool allocation a static size
>   ACPI / APEI: Don't store CPER records physical address in struct ghes
>   ACPI / APEI: Remove spurious GHES_TO_CLEAR check
>   ACPI / APEI: Don't update struct ghes' flags in read/clear estatus
>   ACPI / APEI: Generalise the estatus queue's notify code
>   ACPI / APEI: Don't allow ghes_ack_error() to mask earlier errors
>   ACPI / APEI: Move NOTIFY_SEA between the estatus-queue and NOTIFY_NMI
>   ACPI / APEI: Switch NOTIFY_SEA to use the estatus queue
>   KVM: arm/arm64: Add kvm_ras.h to collect kvm specific RAS plumbing
>   arm64: KVM/mm: Move SEA handling behind a single 'claim' interface
>   ACPI / APEI: Move locking to the notification helper
>   ACPI / APEI: Let the notification helper specify the fixmap slot
>   ACPI / APEI: Pass ghes and estatus separately to avoid a later copy
>   ACPI / APEI: Make GHES estatus header validation more user friendly
>   ACPI / APEI: Split ghes_read_estatus() to allow a peek at the CPER
>     length
>   ACPI / APEI: Only use queued estatus entry during
>     in_nmi_queue_one_entry()
>   ACPI / APEI: Use separate fixmap pages for arm64 NMI-like
>     notifications
>   mm/memory-failure: Add memory_failure_queue_kick()
>   ACPI / APEI: Kick the memory_failure() queue for synchronous errors
>   arm64: acpi: Make apei_claim_sea() synchronise with APEI's irq work
>   firmware: arm_sdei: Add ACPI GHES registration helper
>   ACPI / APEI: Add support for the SDEI GHES Notification type
> 
>  arch/arm/include/asm/kvm_ras.h       |  14 +
>  arch/arm/include/asm/system_misc.h   |   5 -
>  arch/arm64/include/asm/acpi.h        |   4 +-
>  arch/arm64/include/asm/daifflags.h   |   1 +
>  arch/arm64/include/asm/fixmap.h      |   6 +-
>  arch/arm64/include/asm/kvm_ras.h     |  25 +
>  arch/arm64/include/asm/system_misc.h |   2 -
>  arch/arm64/kernel/acpi.c             |  54 ++
>  arch/arm64/mm/fault.c                |  25 +-
>  drivers/acpi/apei/Kconfig            |  12 +-
>  drivers/acpi/apei/ghes.c             | 725 ++++++++++++++++-----------
>  drivers/acpi/apei/hest.c             |  10 +-
>  drivers/firmware/arm_sdei.c          |  68 +++
>  include/acpi/ghes.h                  |   7 +-
>  include/linux/arm_sdei.h             |   9 +
>  include/linux/mm.h                   |   1 +
>  mm/memory-failure.c                  |  15 +-
>  virt/kvm/arm/mmu.c                   |   4 +-
>  18 files changed, 646 insertions(+), 341 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_ras.h
>  create mode 100644 arch/arm64/include/asm/kvm_ras.h

I can apply patches in this series up to and including patch [21/26].

Do you want me to do that?

Patch [22/26] requires an ACK from mm people.

Patch [23/26] has a problem that randconfig can generate a configuration
in which memory_failure_queue_kick() is not present, so it is necessary
to add a CONFIG_MEMORY_FAILURE dependency somewhere for things to
work (or define an empty stub for that function in case the symbol is
not set).

If patches [24-26/26] don't depend on the previous two, I can try to
apply them either, so please let me know.

Thanks,
Rafael
