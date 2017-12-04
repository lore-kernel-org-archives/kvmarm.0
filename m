From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 00/12] 52-bit kernel VAs for arm64
Date: Mon,  4 Dec 2017 14:13:01 +0000
Message-ID: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC4A49D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vy+cf4p7+rVF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4562B40651
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:24 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch series brings 52-bit kernel VA support to arm64; if supported
at boot time. A new kernel option CONFIG_ARM64_VA_BITS_48_52 is available
when configured with a 64KB PAGE_SIZE (as on ARMv8.2-LPA, 52-bit VAs are
only allowed when running with a 64KB granule).

Switching between 48 and 52-bit does not involve any changes to the number
of page table levels. The number of PGDIR entries increases when running
with a 52 bit kernel VA.

In order to allow the kernel to switch between VA spaces at boot time, we
need to re-arrange the current kernel VA space. If we place the kernel at
the bottom of the address space, then symbol addresses will be independent
of address space size. (We can't assume relocation will be enabled).

The new kernel VA space looks like this (running with 48/52-bit kernel VA):

0xffff000000000000/0xfff0000000000000	ttbr1 start - linear mapping start
0xffff800000000000/0xfff8000000000000	midpoint of address space
0xffff800000000000/0xfffda00000000000	KASAN start
0xffffa00000000000/0xffffa00000000000	vmalloc start
---
0xfffffbdfd67b0000			vmemmap start
0xfffffbffd6800000			Fixed map start
0xffffffffd6c00000			PCI IO start
0xffffffffd7e00000			kernel modules start
0xffffffffdfe00000			kernel image start
0xffffffffffe00000			guard region for PTR_ERR

The KASAN end address is the same for both 48 and 52 bit kernel VA spaces,
meaning that KASAN "grows upwards" into the extra VA space available when
running with 52-bit. This allows us to run with inline KASAN, where the
offset is baked into the code in many places, on both VA spaces using the
same binary.

In order to allow for this logic, the KASAN_SHADOW_OFFSET logic was altered
to match the system used for x86; namely that KASAN_SHADOW_OFFSET is a
Kconfig constant rather than a derived quantity. In order to simplify
future VA work, the code to compute the KASAN shadow offset is supplied
as a script in the documentation folder.

If KASAN is not enabled, then the VMALLOC start position is variable
depending on VA_BITS. Thus VMALLOC_START cannot always be considered
constant.

This patch series modifies VA_BITS from a constant pre-processor macro, to
a runtime variable and this requires changes to other parts of the arm64
code such the page table dumper. Some parts of the code require pre-processing
constants derived from VA_BITS, so two new pre-processor constants have
been introduced:
 VA_BITS_MIN	the minimum number of VA_BITS used, this can be used to bound
		addresses conservatively s.t. mappings work for both address
		space sizes. An example use case being the EFI stub code
		efi_get_max_initrd_addr(). Another example being to determine
		whether or not we need an extra page table level for the
		identity mapping (on 64KB PAGE_SIZE we already have 3-levels
		for both 48-bit and 52-bit VA space).

 VA_BITS_ALT	if running with a higher kernel VA space, this is the number
		of bits available. VA_BITS_MIN and VA_BITS_ALT can be used
		together to generate constants (or test compile time asserts)
		which are then chosen at runtime.

I am mindful how disruptive the change to VA_BITS is, but I have so far been
unable to simplify this further. One idea I had was to remove VA_BITS completely
but that just makes the seris a lot more complicated.

Another idea was to fix VA_BITS to either 48 or 52, this doesn't really help
things. Either choice breaks derived addresses and also, less obviously, breaks
the meaning behind the constant. efi_get_max_initrd_addr will give the wrong
results if we choose 52 for example.

Though disruptive, having VA_BITS de-constified will help us pick out bugs at
compile time that one may not otherwise notice if it is set to the wrong constant.
That said, I'm receptive to any ideas that can simplify this.

One can't assume that ARMv8.2-LPA implies ARMv8.1-VHE, so changes are also made
to the KVM HYP mapping code to support both 48 and 52-bit VAs. In writing the
support, I unearthed some subtle bugs in the KVM HYP mapping logic and these
are addressed in the first two patches of this series.

This patch series applies to 4.15-rc2, and the early pagetable patches I
posted earlier:
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-November/543494.html

Steve Capper (12):
  KVM: arm/arm64: vgic: Remove spurious call to kern_hyp_va
  arm64: KVM: Enforce injective kern_hyp_va mappings
  arm/arm64: KVM: Formalise end of direct linear map
  arm64: Initialise high_memory global variable earlier
  arm64: mm: Remove VMALLOC checks from update_mapping_prot(.)
  arm64: mm: Flip kernel VA space
  arm64: mm: Place kImage at bottom of VA space
  arm64: kasan: Switch to using KASAN_SHADOW_OFFSET
  arm64: dump: Make kernel page table dumper dynamic again
  arm64: mm: Make VA_BITS variable, introduce VA_BITS_MIN
  arm64: KVM: Add support for an alternative VA space
  arm64: mm: Add 48/52-bit kernel VA support

 Documentation/arm64/kasan-offsets.sh | 17 ++++++++
 arch/arm/include/asm/kvm_hyp.h       |  2 +
 arch/arm/include/asm/memory.h        |  1 +
 arch/arm64/Kconfig                   | 22 ++++++++++
 arch/arm64/Makefile                  |  7 ---
 arch/arm64/include/asm/assembler.h   |  2 +-
 arch/arm64/include/asm/cpucaps.h     |  6 ++-
 arch/arm64/include/asm/efi.h         |  4 +-
 arch/arm64/include/asm/kasan.h       | 24 +++++------
 arch/arm64/include/asm/kvm_hyp.h     | 10 +++++
 arch/arm64/include/asm/kvm_mmu.h     | 83 ++++++++++++++++++++++++++++--------
 arch/arm64/include/asm/memory.h      | 42 +++++++++++-------
 arch/arm64/include/asm/mmu_context.h |  2 +-
 arch/arm64/include/asm/pgtable.h     | 13 ++++--
 arch/arm64/include/asm/processor.h   |  2 +-
 arch/arm64/kernel/cpufeature.c       | 47 +++++++++++++++++---
 arch/arm64/kernel/head.S             | 13 +++---
 arch/arm64/kvm/hyp-init.S            |  2 +-
 arch/arm64/mm/dump.c                 | 59 ++++++++++++++++++++-----
 arch/arm64/mm/fault.c                |  2 +-
 arch/arm64/mm/init.c                 | 16 +++----
 arch/arm64/mm/kasan_init.c           | 14 +++---
 arch/arm64/mm/mmu.c                  | 11 ++---
 arch/arm64/mm/proc.S                 | 42 +++++++++++++++++-
 virt/kvm/arm/hyp/vgic-v2-sr.c        |  4 +-
 virt/kvm/arm/mmu.c                   |  4 +-
 26 files changed, 336 insertions(+), 115 deletions(-)
 create mode 100644 Documentation/arm64/kasan-offsets.sh

-- 
2.11.0
