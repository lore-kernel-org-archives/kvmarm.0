Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EF41514F7
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757951595; cv=none; b=n/cvUsKQqDyWGO4sLT7c3XPKpddpZb4b0BzBIVMR4YpTltxbd9fbh72p/D2TxGKdmmFpWoWAu2BOjKH/7X2ZqerVYerUV0WoFp+o3Pn3bIl0MCqzxtnBd5f37YaT78zZebTMtqJTRMGAvOQS7dOVsaYwAuNyGP+a4UcjEWKnoKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757951595; c=relaxed/simple;
	bh=Zy7fEygFur5laiMuamnykXeX5bRhN6QGQjniPH/MJsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RXbRSNlvkfFhvWwGSCifO1KiUfPdSd1PYXIoK8hDuDdoE+PcPgY4pfpMa+G6j4+E9Mdu0SORp7vc5u508zozdTzyb0mwTezTa5VoW+Be75emgZ7zGRsC1cXyE5+jzvwLAt2eV+Gzinte1BKMRj/7ZTpdhZw1lMXBsj+KqB6659Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 499F71424;
	Mon, 15 Sep 2025 08:53:05 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 470753F673;
	Mon, 15 Sep 2025 08:53:11 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH] KVM: arm64: Update stale comment for sanitise_mte_tags()
Date: Mon, 15 Sep 2025 16:52:34 +0100
Message-ID: <20250915155234.196288-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c911f0d46879 ("KVM: arm64: permit all VM_MTE_ALLOWED mappings
with MTE enabled") allowed VM_SHARED VMAs in a VM with MTE enabled, so
remove the comment to the contrary.

Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
removed the race that can lead to tags being zeroed more than once when
multiple threads attempt initialisation at the same time, so remove the
comment about mmap_lock too. Note that sanitise_mte_tags() was never called
with the mmap_lock held from user_mem_abort() and the race was prevented by
kvm->mmu_lock.

However, the function still requires to have the kvm->mmu_lock held to
ensure that the memory remains mapped in the userspace process while the
tags are zeroed. Document this in a comment.

CC: Peter Collingbourne <pcc@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Price <steven.price@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 86f3d80daf37..33f4c923be70 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1459,11 +1459,8 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * able to see the page's tags and therefore they must be initialised first. If
  * PG_mte_tagged is set, tags have already been initialised.
  *
- * The race in the test/set of the PG_mte_tagged flag is handled by:
- * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
- *   racing to santise the same page
- * - mmap_lock protects between a VM faulting a page in and the VMM performing
- *   an mprotect() to add VM_MTE
+ * Must be called with kvm->mmu_lock held to ensure the memory remains mapped
+ * while the tags are zeroed.
  */
 static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			      unsigned long size)

base-commit: f83ec76bf285bea5727f478a68b894f5543ca76e
-- 
2.51.0

