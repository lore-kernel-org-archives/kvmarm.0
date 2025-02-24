Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF078F2E;
	Mon, 24 Feb 2025 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740389989; cv=none; b=U7gE9y/vxcLk3bI2ePuTBUxl5Yo80F3JLXF+HeC+vR0t9gS9Tl79Y7XEby2TW3Hq6MOI8gth4wklDERj5pdjAX5Xnl8PPkRaS+kf8aZsdnnWOII3QJVgDZqU3H4zk971/kXbcd7H3rmgzaKowd1eMZkNDLoE/LtwDxwghAvzLKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740389989; c=relaxed/simple;
	bh=R+HmxPG16H8vvvu0uSUgZflbClb30RDYT9Rf/tlkZUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CK+gUszokWHx+846W/+KbZhxPLJljxroRZPMP8lmMkLWTreETRAXvMIWXWaj80UqFQmvOFBEH5o+DDdMNja1E/B176zPWL+xNwqk/FCFUpPpPu1Q8piyicqbqYrmbPv46jJzWhDTQLTkiC6liDG/o4glLLBdDFUBWSNdUEpG09Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frWUrc+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frWUrc+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D10FC4CED6;
	Mon, 24 Feb 2025 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740389988;
	bh=R+HmxPG16H8vvvu0uSUgZflbClb30RDYT9Rf/tlkZUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=frWUrc+pFtazhaExLu8Sa4PymlW7J14mDrwpxHtqsB9nPfZ3ytNZFQhSPPjiyOwKS
	 znweSFBFw0i8wBai/gTKv447hgW+cXbDQ5JEmNkkCoukRvQ5VLET0yS3UsR0lLviyI
	 MEkVN76MMS5HfLFSEIw5glKfevVz++uiM+zBP1YOSMYCtYg7GQ+EQRGRJLJFYIIS9a
	 4fCe86/3O3flmYHXQHSiP7zmNnwTJ99VQJe5R0iVQVQ2FaVY94YyHRFyql2hEuxvwE
	 /g/EF9VAhvk6hiK52qHNaO3cCnqCKhXvoTZTcLuMl7lNVt1mLXQ6it4BeOqs/c0Vs2
	 fyo6Ae4NHqF6A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH] KVM: arm64: Drop mte_allowed check during memslot creation
Date: Mon, 24 Feb 2025 15:09:38 +0530
Message-ID: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before commit d89585fbb308 ("KVM: arm64: unify the tests for VMAs in
memslots when MTE is enabled"), kvm_arch_prepare_memory_region() only
rejected a memory slot if VM_SHARED was set. This commit unified the
checking with user_mem_abort(), with slots being rejected if either
VM_MTE_ALLOWED is not set or VM_SHARED set. A subsequent commit
c911f0d46879 ("KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE
enabled") dropped the VM_SHARED check, so we ended up with memory slots
being rejected if VM_MTE_ALLOWED is not set. This wasn't the case before
the commit d89585fbb308. The rejection of the memory slot with VM_SHARED
set was done to avoid a race condition with the test/set of the
PG_mte_tagged flag. Before Commit d77e59a8fccd ("arm64: mte: Lock a page
for MTE tag initialization") the kernel avoided allowing MTE with shared
pages, thereby preventing two tasks sharing a page from setting up the
PG_mte_tagged flag racily.

Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
initialization") further updated the locking so that the kernel
allows VM_SHARED mapping with MTE. With this commit, we can enable
memslot creation with VM_SHARED VMA mapping.

This patch results in a minor tweak to the ABI. We now allow creating
memslots that don't have the VM_MTE_ALLOWED flag set. If the guest uses
such a memslot with Allocation Tags, the kernel will generate -EFAULT.
ie, instead of failing early, we now fail later during KVM_RUN.

This change is needed because, without it, users are not able to use MTE
with VFIO passthrough (currently the mapping is either Device or
NonCacheable for which tag access check is not applied.), as shown
below (kvmtool VMM).

[  617.921030] vfio-pci 0000:01:00.0: resetting
[  618.024719] vfio-pci 0000:01:00.0: reset done
  Error: 0000:01:00.0: failed to register region with KVM
  Warning: [0abc:aced] Error activating emulation for BAR 0
  Error: 0000:01:00.0: failed to configure regions
  Warning: Failed init: vfio__init

  Fatal: Initialisation failed

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kvm/mmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ef53af6df6de..1f1b5aa43d2d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2178,11 +2178,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
-			ret = -EINVAL;
-			break;
-		}
-
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
 			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-- 
2.43.0

