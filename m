Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9EB3D5229;
	Thu, 24 Sep 2026 10:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244363; cv=none; b=nuzQEK7JtcLFdw+sp+nGRQ0h/j3Dmqb8Yqz0hZHEkg8xCum9tARZcZF+2hiPdsvdqf935L5+gdv1WNoqXyyawPuDZ4UzQfxzAlLBykuoyReVpZvKL81MdUM9dRqNEVoskuqtrXEFgHWzVbOQ+nxnQIC6mlEau6t5hcfZlN66nhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244363; c=relaxed/simple;
	bh=hil2ZKOx5aGtpbjKP5MOaXdRTdaAEObH4UqBVZaD+mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JWEsV8bvS6iwqKwHNCoOG67Sj0Ve8U5CYbPsz8u8P/mbAe4sVdJ844dkZx/Pl2mZdDPOSCopKY6fTMNt+Qvp3pmjtPn183+UhU9LXjt74ltwJHqxQjdC9v0mUCRH7n/yGjMTg2Fj25gZMRr6lxXCf0bIJhvhEXXKHP8Az65g9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuU4b+q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuU4b+q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F5F1F000FF;
	Thu, 24 Sep 2026 10:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244350;
	bh=ztftWGB4Dg2CGLoIiNhW4BtmrBs2qH8L0ze0TvfkyVY=;
	h=From:To:Cc:Subject:Date;
	b=HuU4b+q4DW0y1jFU/pkX+Y4Fhfh0EI89bHg3rugjNjh68OTBVkfJc+jWtGFdfePnm
	 k+qTHsx1VdLGmFvtcQe3yLmTJMO+2UbYXbjlLAUNUeew/THoupZHRLbW1A+sOnnaQ3
	 suyP7PpixoipAIDRd40wP6z9vX1F9/BcjD/3E3z3FzealKw9unKna4CfSYTU3chF/M
	 BeCJzSCxycJ/7UMrx5MowndgxpxqIxGYqaQyXAS8Ec2aRI5BwolYB0Ad2GmT9tcAOp
	 yB9imNYXb3ltmkm/2TqZzdLOGvB5zSz7bCVC0xidic9b4NEkeHKnJBgiAZ81jpwAar
	 C+jT4eU3TVRTg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 00/14] coco: guest: Add a shared-granule allocator for host-shared memory
Date: Thu, 24 Sep 2026 15:35:15 +0530
Message-ID: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


This series tightens the alignment requirements for buffers that are shared
between confidential-computing guests and the host, and adds a common
allocator for host-shared memory.

When a guest runs with private memory, buffers shared with the hypervisor
are not only accessed by the guest. They are also accessed by the host
kernel, and the host may manage the corresponding shared/private state at a
granularity larger than the guest page size.

This matters for CCA systems where the Realm stage-2 mappings managed by
the RMM can still operate at 4K granularity, while the non-secure host may
manage the IPA state change at a larger page size, for example 64K. In that
case, allowing a guest to convert and share only a 4K subrange of a
host-managed granule is unsafe.

Architectures such as Arm can detect incorrect accesses to Realm physical
address space PFNs through GPC faults. However, relying on that as the only
line of defence is fragile and can still lead to kernel crashes. The risk
is especially visible for shared buffers that are later mmapped into
userspace, such as guest_memfd or dma-buf backed allocations. Once
userspace can access the mapping, the kernel cannot guarantee that
applications will only touch the intended 4K region rather than the whole
host page mapped into their address space. Those userspace addresses may
also be passed back into the kernel and accessed through the linear map,
resulting in a GPC fault.

To avoid this, host-shared buffers must satisfy two constraints:

  - the address must be aligned to the CoCo shared-granule size
  - the size must be a multiple of that granule size

The series adds a common CoCo shared-memory layer for enforcing these
constraints. It provides shared-granule geometry and range-validation
helpers, byte-oriented private/shared transition helpers, and
alloc_cc_shared_pages() with a node-aware variant. The allocator rounds a
request to the architecture shared granule, allocates suitably aligned
contiguous pages, transitions the complete allocation to shared state, and
returns the transitioned size alongside the page.

The corresponding free helper restores the complete allocation to private
state before returning it to the buddy allocator. If private state cannot
be restored safely, the allocation is deliberately leaked rather than
returning potentially shared memory for unrelated use. Since a
private-to-shared transition may modify memory contents, __GFP_ZERO is
applied after the transition.

The generic shared-granule size defaults to PAGE_SIZE. For arm64 CCA, the
series queries the host IPA state change alignment through the Realm Host
Interface, caches it during Realm initialization, and exposes it through
the arm64 memory-encryption operations.

The common allocator is used for host-shared allocations whose backing is
owned by an individual caller:

  - GIC ITS command queues and tables
  - dma-direct allocations backed by CMA or the page allocator
  - backing allocations for the CoCo atomic DMA pools
  - dma-buf system_cc_shared heap allocations

Hyper-V users of set_memory_encrypted() and set_memory_decrypted() are not
changed by this series. Those paths are not currently used by the arm64 CCA
code path, and therefore are not part of the arm64 CCA IPA state change
alignment problem addressed here.

NOTE: I have not added explicit MAINTAINERS entries for mm/cc_shared.c and
include/linux/cc_shared.h, as I am unsure whether we need a separate section
for common CoCo-related files. I will add the entries based on feedback.

Changes from v7:
https://lore.kernel.org/all/20260921144847.501151-1-aneesh.kumar@kernel.org
* Add the following new patches:
  * "irqchip/gic-v3-its: Preallocate VPE L1 tables"
  * "mm: Assert CoCo shared allocations may sleep"
  * "mm: Zero memory during shared memory transitions"
* Drop the arm64 RHI and shared granule size patches so that the series can
  be rebased on top of upstream to enable Shashiko review.

Changes from v6:
https://lore.kernel.org/all/20260904103452.1197239-1-aneesh.kumar@kernel.org
* Add a common allocator and geometry/transition helpers for CoCo host-shared
  memory.
* Convert GIC ITS, dma-direct, atomic DMA pools, and the dma-buf
  system_cc_shared heap to the common allocator.
* Limit dma-buf scatterlist entries to the requested buffer size so rounded
  backing is not exposed to importers.

Changes from v5:
https://lore.kernel.org/all/20260706060432.1375570-1-aneesh.kumar@kernel.org
* Rebased to latest kernel
* Drop patch arm64: realm: Move Realm memory encryption ops to RSI code

Changes from v4:
https://lore.kernel.org/all/20260427063108.909019-1-aneesh.kumar@kernel.org
* Rename the helpers to use CoCo terminology
  (mem_cc_shared_granule_size() / mem_cc_align_to_shared_granule() instead of
  mem_decrypt_granule_size() / mem_decrypt_align()).
* Use __DMA_ATTR_ALLOC_CC_SHARED to pass CoCo shared allocation requirements
  down to CMA-based allocation helpers.
* Add validation for restricted DMA pools to reject pools that are not aligned
  to the shared granule size.
* Add dma-buf system heap handling for cc-shared buffers.
* Split the previous combined DMA/SWIOTLB/ITS change into smaller subsystem
  patches covering ITS, DMA direct, SWIOTLB, restricted DMA pools, dma-buf
  system heap, and arm64 Realm support.
* Rework arm64 Realm support by moving Realm memory encryption ops into RSI
  code and exposing the CCA shared granule size through arm64_mem_crypt_ops.

Changes from v3:
https://lore.kernel.org/all/20260309102625.2315725-1-aneesh.kumar@kernel.org
* Fix build error reported by kernel test robot <lkp@intel.com>

Changes from v2:
https://lore.kernel.org/all/20251221160920.297689-1-aneesh.kumar@kernel.org
* Rebase to latest kernel
* Consider swiotlb always decrypted and don't align when allocating from swiotlb.

Changes from v1:
* Rename the helper to mem_encrypt_align
* Improve the commit message
* Handle DMA allocations from contiguous memory
* Handle DMA allocations from the pool
* swiotlb is still considered unencrypted. Support for an encrypted swiotlb pool
  is left as TODO and is independent of this series.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel (AMD) <joro@8bytes.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: Brian Starkey <Brian.Starkey@arm.com>
Cc: John Stultz <jstultz@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Radu Rendec <radu@rendec.net>
Cc: "T.J. Mercier" <tjmercier@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: dri-devel@lists.freedesktop.org
Cc: iommu@lists.linux.dev
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org

Aneesh Kumar K.V (Arm) (14):
  mm: Add an allocator for CoCo shared memory
  mm: Zero memory during shared memory transitions
  irqchip/gic-v3-its: Resolve the default NUMA node explicitly
  irqchip/gic-v3-its: Allocate shared tables using CoCo shared memory
    allocator
  dma-contiguous: Derive shared alignment from DMA attributes
  dma-pool: Allocate CoCo atomic pools using CoCo shared memory
    allocator
  dma-direct: Align CoCo shared DMA allocations to the shared granule
    size
  swiotlb: Align shared IO TLB pools to the shared granule size
  swiotlb: Reject misaligned restricted DMA pools for CoCo guests
  dma-buf: system_heap: Limit scatterlist entries to the buffer size
  dma-buf: system_heap: Allocate shared buffers using CoCo shared memory
    allocator
  swiotlb: Make rounded shared pool capacity allocatable
  mm: Assert CoCo shared allocations may sleep
  irqchip/gic-v3-its: Preallocate VPE L1 tables

 arch/arm/mm/dma-mapping.c                     |   5 +-
 arch/arm64/mm/pageattr.c                      |   3 +
 arch/powerpc/platforms/pseries/svm.c          |   2 +
 arch/s390/mm/init.c                           |   3 +
 arch/x86/coco/tdx/tdx.c                       |   3 +
 arch/x86/hyperv/hv_init.c                     |   6 +-
 arch/x86/hyperv/ivm.c                         |   4 +
 arch/x86/kernel/kvmclock.c                    |   6 +-
 arch/x86/mm/mem_encrypt_amd.c                 |   4 +
 drivers/dma-buf/heaps/system_heap.c           | 128 +++++-----
 drivers/hv/connection.c                       |  41 ++--
 drivers/hv/hv.c                               |  11 +-
 drivers/hv/hv_common.c                        |   2 -
 drivers/iommu/dma-iommu.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c              | 153 +++++++++---
 drivers/irqchip/irq-gic-v3.c                  |   4 +-
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |   3 +
 include/linux/cc_shared.h                     |  39 +++
 include/linux/dma-map-ops.h                   |   9 +-
 include/linux/irqchip/arm-gic-v3.h            |   3 +-
 kernel/dma/contiguous.c                       |  41 +++-
 kernel/dma/direct.c                           |  73 ++++--
 kernel/dma/ops_helpers.c                      |   2 +-
 kernel/dma/pool.c                             |  25 +-
 kernel/dma/swiotlb.c                          |  80 ++++--
 kernel/kexec_file.c                           |   3 +-
 mm/Makefile                                   |   1 +
 mm/cc_shared.c                                | 232 ++++++++++++++++++
 28 files changed, 682 insertions(+), 206 deletions(-)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c


base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.43.0

