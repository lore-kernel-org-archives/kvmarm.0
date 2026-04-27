Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0F2773E5;
	Mon, 27 Apr 2026 06:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777271477; cv=none; b=XiE1v4jQG22bow2Yx4MWzZ66TdKjHccPuis7ZyP+Ykw1+/YyJ/3RTvK/m2gyLsvByBYJyITry4BlCYNHXp6JtBuJ7kEXiRjHnNT9PN/Ca4sneVj3rgT4Kmxw81BSgFFy3fIZ2QI51LPxAJ69XWbDGiCfJOxxwlxQeAWcSI+toN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777271477; c=relaxed/simple;
	bh=TT3ZABo3gdbLCPLVCA/3gAb1IpW94r3+NRwJmZ4Vdas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fPUJpCPo1o2Wtic4hKBBqXisH/4uJMXVm+xiPKYYvla/liWWSa4cCExUDtumv3IBlNw0FXLI+KMxEJ9xuxMVjDTJi+vtL8ZdBq1sPcLoGUeTewwC84cJvo2oJC6ok6szFRgPiDYOyBJ6CiO53m0vE/tiEmW7AztggQ9ytEI56+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r44Pt2ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r44Pt2ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9294DC19425;
	Mon, 27 Apr 2026 06:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777271476;
	bh=TT3ZABo3gdbLCPLVCA/3gAb1IpW94r3+NRwJmZ4Vdas=;
	h=From:To:Cc:Subject:Date:From;
	b=r44Pt2ZR8rT+xlusdriUwtEEiy0YDkqD78pNWIlbVj1zLLqmVZqNduCbhvByi5Gj1
	 EY0vxn4WO9IibbXFwfukUBlRyxBywJQDBgAsApZqir9RmRIX4wWwnCKMPhd8rFvkW9
	 rM+wvm9fdz+dI/adkMdR5TWdwGljh/eQxGjfEOCHvOC/iq7w1U9A9mVM3beYdOqvFY
	 IeuXC0ThOAbGcl9mBXzDBj9DzSRRtv6lshW7bFFILIha/gOM3qsAL9O7TiP42nXf04
	 x+kpAWvF/LB0JbnIZ1fqUqkSZ/YSEm8UajaIMvm3/AhI4Ps4rMbwvyp7YkLJyAIMi9
	 igb4TCgupRd1A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 0/3] Enforce host page-size alignment for shared buffers
Date: Mon, 27 Apr 2026 12:01:05 +0530
Message-ID: <20260427063108.909019-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This patch series addresses alignment requirements for buffers shared between
private-memory guests and the host.

When running private-memory guests, the guest kernel must apply additional
constraints when allocating buffers that are shared with the hypervisor. These
shared buffers are also accessed by the host kernel and therefore must be
aligned to the host’s page size.

Architectures such as Arm can tolerate realm physical address space PFNs being
mapped as shared memory, as incorrect accesses are detected and reported as GPC
faults. However, relying on this mechanism alone is unsafe and can still lead to
kernel crashes.

This is particularly likely when guest_memfd allocations are mmapped and
accessed from userspace. Once exposed to userspace, it is not possible to
guarantee that applications will only access the intended 4K shared region
rather than the full 64K page mapped into their address space. Such userspace
addresses may also be passed back into the kernel and accessed via the linear
map, potentially resulting in a GPC fault and a kernel crash.

To address this, the series introduces a new helpers,
mem_decrypt_granule_size() and mem_decrypt_align(), which allows callers to
enforce the required alignment for shared buffers.

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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>

Aneesh Kumar K.V (Arm) (3):
  dma-direct: swiotlb: handle swiotlb alloc/free outside
    __dma_direct_alloc_pages
  swiotlb: dma: its: Enforce host page-size alignment for shared buffers
  coco: guest: arm64: Query host IPA-change alignment via RHI

 arch/arm64/include/asm/mem_encrypt.h |  3 ++
 arch/arm64/include/asm/rhi.h         | 24 ++++++++++++
 arch/arm64/include/asm/rsi.h         |  2 +
 arch/arm64/include/asm/rsi_cmds.h    | 10 +++++
 arch/arm64/include/asm/rsi_smc.h     |  7 ++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/rhi.c              | 54 ++++++++++++++++++++++++++
 arch/arm64/kernel/rsi.c              | 13 +++++++
 arch/arm64/mm/mem_encrypt.c          | 27 +++++++++++--
 drivers/irqchip/irq-gic-v3-its.c     | 20 ++++++----
 include/linux/mem_encrypt.h          | 14 +++++++
 kernel/dma/contiguous.c              | 10 +++++
 kernel/dma/direct.c                  | 58 ++++++++++++++++++++++++----
 kernel/dma/pool.c                    |  4 +-
 kernel/dma/swiotlb.c                 | 21 ++++++----
 15 files changed, 240 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm64/include/asm/rhi.h
 create mode 100644 arch/arm64/kernel/rhi.c

-- 
2.43.0

