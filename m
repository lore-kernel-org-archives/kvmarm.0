From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH V2 0/7] 52-bit kernel VAs for arm64
Date: Mon, 18 Dec 2017 21:47:29 +0000
Message-ID: <20171218214736.13761-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38EA349D9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BMN30bmpTjHw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 16:44:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AB2A40D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:07 -0500 (EST)
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
need to re-arrange the current kernel VA space. In particular, the KASAN
end address needs to be valid for both 48-bit and 52-bit VA spaces, meaning
we need to flip the kernel VA space s.t. the KASAN end address is high and
the direct linear mapping is low.

In V1 of this patch set the kernel position was also changed, this reduced
the possible variation in KASLR; so in V2 of this series the changes to the
kernel VA space are restricted to just swapping the halves of the kernel
VA space. In a future patch it would be possible to further expand the KASLR
offset space by adding a negative offset when running with a 52-bit VA.

In the series, the KASAN_SHADOW_OFFSET logic is altered to match the system
used for x86; namely that KASAN_SHADOW_OFFSET is a Kconfig constant rather
than a derived quantity. In order to simplify future VA work, the code to
compute the KASAN shadow offset is supplied as a script in the documentation
folder. It may be possible in a future patch to put the KASAN end address
at the end of the kernel VA space. This would allow one to use the same
KASAN shadow offset for all VA spaces.

If KASAN is not enabled, we use the same address layout for modules and
kernel for both 48-bit and 52-bit address spaces. The VMEMMAP region is
placed dynamically (it is larger for 52-bit VAs) which affects the positon
of the fixed map and PCI IO region.

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

This patch series applies to 4.15-rc4, with the early pagetable patches I
posted earlier:
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-November/543494.html

and in V2 this is based on Marc Zyngier's HASLR series at:
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-December/547456.html

Basing this series on HASLR means that we no longer need the HYP mapping
logic fixes and adjustments to HYP mapping logic for variable VA spaces;
thus reduces the number of patches needed in V2 of this series.

Changes to V2:
 * Kernel VA space only flipped, the order of modules, kImage etc are now
   retained,
 * 4.15-rc4 is used as a base as it includes a fix from V1 that has been
   merged already,
 * HASLR patch series is used as a base meaning HYP VA fixes are no
   longer required.

Steve Capper (7):
  arm/arm64: KVM: Formalise end of direct linear map
  arm64: mm: Flip kernel VA space
  arm64: kasan: Switch to using KASAN_SHADOW_OFFSET
  arm64: mm: Replace fixed map BUILD_BUG_ON's with BUG_ON's
  arm64: dump: Make kernel page table dumper dynamic again
  arm64: mm: Make VA_BITS variable, introduce VA_BITS_MIN
  arm64: mm: Add 48/52-bit kernel VA support

 Documentation/arm64/kasan-offsets.sh | 17 +++++++++++
 arch/arm/include/asm/memory.h        |  1 +
 arch/arm64/Kconfig                   | 22 ++++++++++++++
 arch/arm64/Makefile                  |  7 -----
 arch/arm64/include/asm/assembler.h   |  2 +-
 arch/arm64/include/asm/efi.h         |  4 +--
 arch/arm64/include/asm/kasan.h       | 21 +++++--------
 arch/arm64/include/asm/memory.h      | 35 ++++++++++++++--------
 arch/arm64/include/asm/mmu_context.h |  2 +-
 arch/arm64/include/asm/pgtable.h     |  6 ++--
 arch/arm64/include/asm/processor.h   |  2 +-
 arch/arm64/kernel/head.S             | 13 ++++----
 arch/arm64/kernel/kaslr.c            |  4 +--
 arch/arm64/kvm/hyp-init.S            |  2 +-
 arch/arm64/mm/dump.c                 | 58 +++++++++++++++++++++++++++++-------
 arch/arm64/mm/fault.c                |  2 +-
 arch/arm64/mm/init.c                 | 14 ++++-----
 arch/arm64/mm/kasan_init.c           | 14 +++++----
 arch/arm64/mm/mmu.c                  | 15 ++++++----
 arch/arm64/mm/proc.S                 | 42 +++++++++++++++++++++++++-
 virt/kvm/arm/mmu.c                   |  4 +--
 21 files changed, 204 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/arm64/kasan-offsets.sh

-- 
2.11.0
