From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 00/14] kvm/arm: Align the VMID allocation with the arm64 ASID one
Date: Thu, 21 Mar 2019 16:36:09 +0000
Message-ID: <20190321163623.20219-1-julien.grall@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@arm.com, james.morse@arm.com, marc.zyngier@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch series is moving out the ASID allocator in a separate file in order
to re-use it for the VMID. The benefits are:
    - CPUs are not forced to exit a roll-over.
    - Context invalidation is now per-CPU rather than
      broadcasted.

There are no performance regression on the fastpath for ASID allocation.
Actually on the hackbench measurement (300 hackbench) it was .7% faster.

The measurement was made on a Seattle based SoC (8 CPUs), with the
number of VMID limited to 4-bit. The test involves running concurrently 40
guests with 2 vCPUs. Each guest will then execute hackbench 5 times
before exiting.

The performance difference between the current algo and the new one are:
    - 2.5% less exit from the guest
    - 22.4% more flush, although they are now local rather than
    broadcasted
    - 0.11% faster (just for the record)

The ASID allocator rework to make it generic has been divided in multiple
patches to make the review easier.

A branch with the patch based on 5.1-rc1 can be found:

http://xenbits.xen.org/gitweb/?p=people/julieng/linux-arm.git;a=shortlog;h=refs/heads/vmid-rework/rfc

Cheers,

Julien Grall (14):
  arm64/mm: Introduce asid_info structure and move
    asid_generation/asid_map to it
  arm64/mm: Move active_asids and reserved_asids to asid_info
  arm64/mm: Move bits to asid_info
  arm64/mm: Move the variable lock and tlb_flush_pending to asid_info
  arm64/mm: Remove dependency on MM in new_context
  arm64/mm: Store the number of asid allocated per context
  arm64/mm: Introduce NUM_ASIDS
  arm64/mm: Split asid_inits in 2 parts
  arm64/mm: Split the function check_and_switch_context in 3 parts
  arm64/mm: Introduce a callback to flush the local context
  arm64: Move the ASID allocator code in a separate file
  arm64/lib: asid: Allow user to update the context under the lock
  arm/kvm: Introduce a new VMID allocator
  kvm/arm: Align the VMID allocation with the arm64 ASID one

 arch/arm/include/asm/kvm_asid.h   |  81 +++++++++++++++
 arch/arm/include/asm/kvm_asm.h    |   2 +-
 arch/arm/include/asm/kvm_host.h   |   5 +-
 arch/arm/include/asm/kvm_hyp.h    |   1 +
 arch/arm/kvm/Makefile             |   1 +
 arch/arm/kvm/asid.c               | 191 +++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/tlb.c            |   8 +-
 arch/arm64/include/asm/asid.h     |  81 +++++++++++++++
 arch/arm64/include/asm/kvm_asid.h |   8 ++
 arch/arm64/include/asm/kvm_asm.h  |   2 +-
 arch/arm64/include/asm/kvm_host.h |   5 +-
 arch/arm64/kvm/hyp/tlb.c          |  10 +-
 arch/arm64/lib/Makefile           |   2 +
 arch/arm64/lib/asid.c             | 191 +++++++++++++++++++++++++++++++++++
 arch/arm64/mm/context.c           | 205 ++++++--------------------------------
 virt/kvm/arm/arm.c                | 112 +++++++--------------
 16 files changed, 638 insertions(+), 267 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_asid.h
 create mode 100644 arch/arm/kvm/asid.c
 create mode 100644 arch/arm64/include/asm/asid.h
 create mode 100644 arch/arm64/include/asm/kvm_asid.h
 create mode 100644 arch/arm64/lib/asid.c

-- 
2.11.0
