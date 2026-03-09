Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD119E97B;
	Mon,  9 Mar 2026 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052025; cv=none; b=I7BSDMRHSzCZeJQkYmcDUlg+AEppX+ecijYq6IU28Q8kyc+t5B7QzfBm0Nk0/pZ/Vnfx2HZNw3sIBaApjyIy82LL+8a1DriGVv2A23SiAZjdTJLgbi7o0EQi47ZbPlBJhlqvS4K+vXi/QqRM/cEKVcjhkF8PqDoIceOSRrEw/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052025; c=relaxed/simple;
	bh=9j2Aki75Xq2R0K0rBVeN5S4byHjjWMPEXb1/HloQCQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Tca3nRtTDdQfiuL4u+2ZIkg4t58kFPC0liM5IC1yNZ5ZTEeeiAOKlfa1l/JCPorCnFEBIAuRQCv3wPWrAwpz0EGUOzPuijwpUq01qFoQuyBFZpxg39LQ3L+GOmyTPu2ycwGXPhWJ6gBV+iagEkt4hi5CRw0seQv55mL0HkjAvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA83fQ8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA83fQ8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80696C4CEF7;
	Mon,  9 Mar 2026 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773052025;
	bh=9j2Aki75Xq2R0K0rBVeN5S4byHjjWMPEXb1/HloQCQs=;
	h=From:To:Cc:Subject:Date:From;
	b=AA83fQ8hiRPciaUr/DFWygfHqj8E3x0dtQ/9sVgM13e+mIYj42DD0U9diKz4o++tA
	 q1KJM+ndJp6VwxBmYnENEkqRF7kyOTUJLunktj3qzQZPJTgJgjmC61CU39N3uUcJ0z
	 CKNEqoLvAwXnWbVWSjQNTL8shgk1FTOU5p5FoClcFl/UtAHmqfIw6PU8c5JLwLtilk
	 vQ5azLpihR3rqDo9gPPhf9rj398sGGk9t1GB39iLoQXaDnFDkb8kIp0oGArxkqZLAo
	 0pxtzbIALdm9KxIUoQBIbnpCWp+jyQMOeaZEAMmiFp4+7pzvv4rxZ7PioI2bVQ9P/s
	 qGAQ5d4jy1oEQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v3 0/3] Enforce host page-size alignment for shared buffers
Date: Mon,  9 Mar 2026 15:56:22 +0530
Message-ID: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
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


Changes from v2:
* Rebase to latest kernel
* Consider swiotlb always decrypted and don't align when allocating from swiotlb.

Changes from v1:
* Rename the helper to mem_encrypt_align
* Improve the commit message
* Handle DMA allocations from contiguous memory
* Handle DMA allocations from the pool
* swiotlb is still considered unencrypted. Support for an encrypted swiotlb pool
  is left as TODO and is independent of this series.


Aneesh Kumar K.V (Arm) (3):
  dma-direct: swiotlb: handle swiotlb alloc/free outside
    __dma_direct_alloc_pages
  swiotlb: dma: its: Enforce host page-size alignment for shared buffers
  coco: guest: arm64: Add Realm Host Interface and hostconf RHI

 arch/arm64/include/asm/mem_encrypt.h |  3 ++
 arch/arm64/include/asm/rhi.h         | 24 ++++++++++++
 arch/arm64/include/asm/rsi.h         |  2 +
 arch/arm64/include/asm/rsi_cmds.h    | 10 +++++
 arch/arm64/include/asm/rsi_smc.h     |  7 ++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/rhi.c              | 53 +++++++++++++++++++++++++
 arch/arm64/kernel/rsi.c              | 13 +++++++
 arch/arm64/mm/mem_encrypt.c          | 27 +++++++++++--
 drivers/irqchip/irq-gic-v3-its.c     | 20 ++++++----
 include/linux/mem_encrypt.h          | 12 ++++++
 kernel/dma/contiguous.c              | 10 +++++
 kernel/dma/direct.c                  | 58 ++++++++++++++++++++++++----
 kernel/dma/pool.c                    |  4 +-
 kernel/dma/swiotlb.c                 | 21 ++++++----
 15 files changed, 237 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm64/include/asm/rhi.h
 create mode 100644 arch/arm64/kernel/rhi.c

-- 
2.43.0

