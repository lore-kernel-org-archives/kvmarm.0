Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714122FD681
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882141; cv=none; b=PUP9JgV5T3MSN7MrAkpFd6Qgt/bXO6pQeFCNbtR3BZ+6c47gyAfZqhEwtt9mvAJx7h8eCWSOn+x38qtOMn3OJP1GqqY/UcwkWQI7uuxj8H2GYAZXJrCSWh8cp79SZaBYUGJyP5wlkSIOP1S78NbJa5jVLdhcMWT3a0Xuqcpnoo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882141; c=relaxed/simple;
	bh=QaZdw+cKvQLXGdg14aZy7asM3jAbDolMGcxEF/Z3CVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLCNL+uq3P3c4FXgex3fMmmLXmSMsHgf0V5aDliQUGwTepmp3kVONNvYGEaFXm2frYQNp+lpXfp6koClAQjLNQ9/jFOOJ3U+zHbNz5eP199mYtzawwJzoUjEIUEKqTvOan/U9ConjST+JBPlgH6e2TnziOtj4HTF2oZxjrM3Qp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icn9PE3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icn9PE3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66032C19423;
	Mon, 30 Mar 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882141;
	bh=QaZdw+cKvQLXGdg14aZy7asM3jAbDolMGcxEF/Z3CVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icn9PE3D3gD3a8v+fq7y6CNB1xCwSVz63G0zJ6F1FJm5NSraD6hykwQULQC3cdGOi
	 /wdbCePrs4F2zP1ylOZjpKz0j6yXIzjMiPKtyFnC3vdyO5xpT5X4vv4lo1xgjM+bSD
	 HQweV9nHFi3qI282ljear5q0xFK1p5sOYbaVj47aWNmJFKELSZuxslTqFcYDOyOeyi
	 /Zie+EW7aT1Ug+HwWFFkHUZw58LVWePcj3t91jFD+FIPgq8U5ZuD7KbJjM2LwSzzKS
	 98bDxJ290cJslw/ZTaqRF+ZB2o4rWAGFTFz1pxuU9XDN/SBZ9/KtjoxedDhtloce/q
	 Jj0WvdRPKWRBA==
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
Subject: [PATCH v5 03/38] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
Date: Mon, 30 Mar 2026 15:48:04 +0100
Message-ID: <20260330144841.26181-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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
2.53.0.1018.g2bb0e51243-goog

