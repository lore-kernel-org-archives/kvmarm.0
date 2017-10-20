From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/8] arm/arm64: KVM: limit icache invalidation to prefetch aborts
Date: Fri, 20 Oct 2017 16:48:56 +0100
Message-ID: <20171020154904.31427-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It was recently reported that on a VM restore, we seem to spend a
disproportionate amount of time invalidation the icache. This is
partially due to some HW behaviour, but also because we're being a bit
dumb and are invalidating the icache for every page we map at S2, even
if that on a data access.

The slightly better way of doing this is to mark the pages XN at S2,
and wait for the the guest to execute something in that page, at which
point we perform the invalidation. As it is likely that there is a lot
less instruction than data, we win (or so we hope).

We also take this opportunity to drop the extra dcache clean to the
PoU which is pretty useless, as we already clean all the way to the
PoC...

Running a bare metal test that touches 1GB of memory (using a 4kB
stride) leads to the following results on Seattle:

4.13:
do_fault_read.bin:       0.565885992 seconds time elapsed
do_fault_write.bin:       0.738296337 seconds time elapsed
do_fault_read_write.bin:       1.241812231 seconds time elapsed

4.14-rc3+patches:
do_fault_read.bin:       0.244961803 seconds time elapsed
do_fault_write.bin:       0.422740092 seconds time elapsed
do_fault_read_write.bin:       0.643402470 seconds time elapsed

We're almost halving the time of something that more or less looks
like a restore operation. Some larger systems will show much bigger
benefits as they become less impacted by the icache invalidation
(which is broadcast in the inner shareable domain). I've tried to
measure the impact on a VM boot in order to assess the impact of
taking an extra permission fault, but found that any difference was
simply noise.

I've also given it a test run on both Cubietruck and Jetson-TK1.

Tests are archived here:
https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvm-ws-tests.git/

I'd value some additional test results on HW I don't have access to.

* From v1:
  - Some function renaming (coherent->clean/invalidate)
  - Made the arm64 icache invalidation a macro that's now used in
    two places
  - Fixed BTB flushing on 32bit
  - Added stage2_is_exec as a predicate for XN being absent from the
    entry
  - Dropped patch #10 which was both useless and broken, and patch #9
    that thus became useless
  - Tried to measure the impact on kernel boot time and failed to see
    any difference

Marc Zyngier (8):
  arm64: KVM: Add invalidate_icache_range helper
  arm: KVM: Add optimized PIPT icache flushing
  arm64: KVM: PTE/PMD S2 XN bit definition
  KVM: arm/arm64: Limit icache invalidation to prefetch aborts
  KVM: arm/arm64: Only clean the dcache on translation fault
  KVM: arm/arm64: Preserve Exec permission across R/W permission faults
  KVM: arm/arm64: Drop vcpu parameter from guest cache maintenance
    operartions
  KVM: arm/arm64: Detangle kvm_mmu.h from kvm_hyp.h

 arch/arm/include/asm/kvm_hyp.h         |  3 +-
 arch/arm/include/asm/kvm_mmu.h         | 61 +++++++++++++++++++++++++++-----
 arch/arm/include/asm/pgtable.h         |  4 +--
 arch/arm/kvm/hyp/switch.c              |  1 +
 arch/arm/kvm/hyp/tlb.c                 |  1 +
 arch/arm64/include/asm/assembler.h     | 26 ++++++++++++++
 arch/arm64/include/asm/cacheflush.h    |  8 +++++
 arch/arm64/include/asm/kvm_hyp.h       |  1 -
 arch/arm64/include/asm/kvm_mmu.h       | 33 ++++++++++++++----
 arch/arm64/include/asm/pgtable-hwdef.h |  2 ++
 arch/arm64/include/asm/pgtable-prot.h  |  4 +--
 arch/arm64/kvm/hyp/debug-sr.c          |  1 +
 arch/arm64/kvm/hyp/switch.c            |  1 +
 arch/arm64/kvm/hyp/tlb.c               |  1 +
 arch/arm64/mm/cache.S                  | 26 ++++++++------
 virt/kvm/arm/hyp/vgic-v2-sr.c          |  1 +
 virt/kvm/arm/mmu.c                     | 64 +++++++++++++++++++++++++++-------
 17 files changed, 195 insertions(+), 43 deletions(-)

-- 
2.14.1
