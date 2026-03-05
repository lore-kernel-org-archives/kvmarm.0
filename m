Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485A390209
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721858; cv=none; b=uDH3RcLiCu0q3Ip7oU/OnLtQW/EK9AiA8lcbPFzhScXxN6F4Zm9YtihSWzWsQbJj4VOZsPMPa0/M2PyET3vn/kOxuq+ugDLE8cRVfmjHg7j5IpX1h5Se4FlbPHOK2ukCSnIhG6PL6WrgipV0l83/0svcVzg2s7bGi1XgER6zYlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721858; c=relaxed/simple;
	bh=wZVmEHB0G05iVbLfQG8WFVsGMKRmMo8Y6r4p8KFCNmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEDqJWEH65hWTtyiEUEPOCGYQksswHXRAcUFZTk+cKNGCKwsXfbKyu8HHqcjouvNZJ4C7RLk9VfgfP2AzoA98lzVyaeWsmCJ8mR+HSp1/d0O9hr/Xs92WGk1bHlfkoQf+lvI6XR+ZjeZ/bxv0Bne5axKQZpP7WAAPAA8TOO4kB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWDDvJ6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWDDvJ6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE21C19423;
	Thu,  5 Mar 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721858;
	bh=wZVmEHB0G05iVbLfQG8WFVsGMKRmMo8Y6r4p8KFCNmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWDDvJ6NdhqslzfixUaChGLoKcM+mHugfQggkJxnHzAmOzF1FVifMLnVve+aXRWMc
	 qt8Tge1fg3hnkVPupZw4lKk52E5ROrOMjRY/hpAMBP28bCT6Q1MXY1PJz1frMiFi4u
	 dbzaIJzCpJV1wui1vLZZWxHHn14UEdGllepMj1EwFSVwwxsLKOf+KN1upGScMbS//E
	 54zXC26GnlnJQQ8emwcfGON0D6WCGrDsZDdn7dIn+W1I+ZebR6dRupGreRw0hmoMsV
	 U/K7n05yMhToAjT/KGK/5NA8R3ssK7dsTdepL3tB/qsRGf8C1ZkEHeR3h285NYA5ug
	 ighmWb4DVOl/w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 02/36] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
Date: Thu,  5 Mar 2026 14:43:15 +0000
Message-ID: <20260305144351.17071-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pKVM is enabled, a VM has a 'handle' allocated by the hypervisor
in kvm_arch_init_vm() and released later by kvm_arch_destroy_vm().

Consequently, the only time __pkvm_pgtable_stage2_unmap() can run into
an uninitialised 'handle' is on the kvm_arch_init_vm() failure path,
where we destroy the empty stage-2 page-table if we fail to allocate a
handle.

Move the handle check into pkvm_pgtable_stage2_destroy_range(), which
will additionally handle protected VMs in subsequent patches.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..7797813f4dbe 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -329,9 +329,6 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 	struct pkvm_mapping *mapping;
 	int ret;
 
-	if (!handle)
-		return 0;
-
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
 					mapping->nr_pages);
@@ -347,6 +344,12 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 					u64 addr, u64 size)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+
+	if (!handle)
+		return;
+
 	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
 }
 
-- 
2.53.0.473.g4a7958ca14-goog

