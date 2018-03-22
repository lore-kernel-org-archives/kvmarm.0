From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 00/11] APEI in_nmi() rework and arm64 SDEI wire-up
Date: Thu, 22 Mar 2018 18:14:34 +0000
Message-ID: <20180322181445.23298-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB57E4A083
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Mar 2018 14:10:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RPpJNuGzM2-j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Mar 2018 14:09:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4158E49EB6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Mar 2018 14:09:41 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

The aim of this series is to wire arm64's SDEI into APEI.

What changed since v1? The NMI-like GHES entries now have an additional
fixmap+lock, instead of choosing which lock to use, and being surprised
when it turns out all GHES are processed from process-context during
boot. (Thanks to Tyler for catching this...)
Some comments and code cleanup, noted in each patch.


The earlier boiler-plate:

What's SDEI? Its ARM's "Software Delegated Exception Interface" [0]. It's
used by firmware to tell the OS about firmware-first RAS events.

These Software exceptions can interrupt anything, so I describe them as
NMI-like. They aren't the only NMI-like way to notify the OS about
firmware-first RAS events, the ACPI spec also defines 'NOTFIY_SEA' and
'NOTIFY_SEI'.

(Acronyms: SEA, Synchronous External Abort. The CPU requested some memory,
but the owner of that memory said no. These are always synchronous with the
instruction that caused them. SEI, System-Error Interrupt, commonly called
SError. This is an asynchronous external abort, the memory-owner didn't say no
at the right point. Collectively these things are called external-aborts
How is firmware involved? It traps these and re-injects them into the kernel
once its written the CPER records).

APEI's GHES code only expects one source of NMI. If a platform implements
more than one of these mechanisms, APEI needs to handle the interaction.
'SEA' and 'SEI' can interact as 'SEI' is asynchronous. SDEI can interact
with itself: its exceptions can be 'normal' or 'critical', and firmware
could use both types for RAS. (errors using normal, 'panic-now' using
critical).

What does this series do?
Patches 1-3 refactor APEIs 'estatus queue' so it can be used for all
NMI-like notifications. This defers the NMI work to irq_work, which will
happen when we next unmask interrupts.

Patches 4&5 move the arch and KVM code around so that NMI-like notifications
are always called in_nmi().

Patch 6 changes the 'irq or nmi?' path through ghes_copy_tofrom_phys()
to be per-ghes. When called in_nmi(), the struct ghes is expected to
provide a fixmap slot and lock that is safe to use. NMI-like notifications
that mask each other can share these resources. Those that interact should
have their own fixmap slot and lock.

Patch 7 renames NOTIFY_SEA's use of NOTIFY_NMI's infrastructure, as we're
about to have multiple NMI-like users that can't share resources.

Pathes 8&9 add the SDEI helper, and notify methods for APEI.

After this, adding further firmware-first pieces for arm64 is simple
(and safe), and all our NMI-like notifications behave the same as x86's
NOTIFY_NMI.


All of this makes the race between memory_failure_queue() and
ret_to_user worse, as there is now always irq_work involved.

Patch 10 makes the reschedule to memory_failure() run as soon as possible.
Patch 11 makes sure the arch code knows whether the irq_work has run by
the time do_sea() returns. We can skip the signalling step if it has as
APEI has done its work.


ghes.c became clearer to me when I worked out that it has three sets of
functions with 'estatus' in the name. One is a pool of memory that can be
allocated-from atomically. This is grown/shrunk when new NMI users are
allocated.
The second is the estatus-cache, which holds recent notifications so it
can suppress notifications we've already handled.
The last it the estatus-queue, which holds data from NMI-like notifications
(in pool memory) to be processed from irq_work.


Testing?
Tested with the SDEI FVP based software model and a mocked up NOTFIY_SEA using
KVM. I've added a case where 'corrected errors' are discovered at probe time
to exercise ghes_probe() during boot. I've only build tested this on x86.


Thanks,

James

[0] http://infocenter.arm.com/help/topic/com.arm.doc.den0054a/ARM_DEN0054A_Software_Delegated_Exception_Interface.pdf


James Morse (11):
  ACPI / APEI: Move the estatus queue code up, and under its own ifdef
  ACPI / APEI: Generalise the estatus queue's add/remove and notify code
  ACPI / APEI: Switch NOTIFY_SEA to use the estatus queue
  KVM: arm/arm64: Add kvm_ras.h to collect kvm specific RAS plumbing
  arm64: KVM/mm: Move SEA handling behind a single 'claim' interface
  ACPI / APEI: Make the nmi_fixmap_idx per-ghes to allow multiple
    in_nmi() users
  ACPI / APEI: Split fixmap pages for arm64 NMI-like notifications
  firmware: arm_sdei: Add ACPI GHES registration helper
  ACPI / APEI: Add support for the SDEI GHES Notification type
  mm/memory-failure: increase queued recovery work's priority
  arm64: acpi: Make apei_claim_sea() synchronise with APEI's irq work

 arch/arm/include/asm/kvm_ras.h       |  14 +
 arch/arm/include/asm/system_misc.h   |   5 -
 arch/arm64/include/asm/acpi.h        |   3 +
 arch/arm64/include/asm/daifflags.h   |   1 +
 arch/arm64/include/asm/fixmap.h      |   8 +-
 arch/arm64/include/asm/kvm_ras.h     |  29 ++
 arch/arm64/include/asm/system_misc.h |   2 -
 arch/arm64/kernel/acpi.c             |  49 ++++
 arch/arm64/mm/fault.c                |  30 +-
 drivers/acpi/apei/ghes.c             | 519 ++++++++++++++++++++---------------
 drivers/firmware/arm_sdei.c          |  75 +++++
 include/acpi/ghes.h                  |   4 +
 include/linux/arm_sdei.h             |   8 +
 mm/memory-failure.c                  |  11 +-
 virt/kvm/arm/mmu.c                   |   4 +-
 15 files changed, 505 insertions(+), 257 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_ras.h
 create mode 100644 arch/arm64/include/asm/kvm_ras.h

-- 
2.16.2
