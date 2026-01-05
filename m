Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C5A3321BD
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628200; cv=none; b=fxvt3mXxZjg7rn6oHfrsUUg3FUN4CQjDQmzUXPzF8YAFm/8d2I5RmenN5gpywSUUGx6NFegMyS1+s84bYj2Ncy3Os2q63L/g912vfAZFJ6roV4avw/9HRP5eCCvFEyyGeg53wHfsiqB+Dti1AqIT0PHzyLMaF0DqN8f+NTFT4sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628200; c=relaxed/simple;
	bh=27wZopcJw7/cJco+fEt26YdM4d1w7aPLBlaekI7TuiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/6DPrA/VyH1G/SUUM/1bqp/ethrt0z4amW79ZLCNa0EQP007mtrSu+tAb/32zzbpiSOFG5GORAQ2q+kmZPOo9LimkAGrxSfaAyqJuhw8vCKFDoLvk/qwh2e/cwcJLCjGMOY6KlxIOt4XLS/FLvda1rAtQWkINc60rb2SWgWn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuGYWTvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuGYWTvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35A0C116D0;
	Mon,  5 Jan 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628199;
	bh=27wZopcJw7/cJco+fEt26YdM4d1w7aPLBlaekI7TuiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuGYWTvqQD1sFgUn6M1jUx+okntJxvijjH9G/U1Fm1THAZh7nbLBhg22GlhcRhtKu
	 0oayrkClGgGOCYJiJU+/1xUEJJx7nR8P7Yb78AAgYzvN3/P/IipeNA7L3aTYMvPZWs
	 8D/Uz0GFvCjhIRzLziiVg3ArVvQx+NhDztYrOmKvkl9TZ5B+YUTkH3zhpHbm7bgy3Q
	 rbPu6mIRlKZyWpaEhazWP1ST3VVAF1gWNAi7HEEVrRf1pXSm7ZzKKSq6kW0mgTwnf3
	 blWHPGM4NuliCyelt37YGxTxvocDg64+ofBYv2pqashSdDhWvMMHGwZ3VwVBRC8k7+
	 qZCQ69X+H8kug==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 03/30] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
Date: Mon,  5 Jan 2026 15:49:11 +0000
Message-ID: <20260105154939.11041-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding support for protected VMs, where pages are
donated rather than shared, rename __pkvm_pgtable_stage2_unmap() to
__pkvm_pgtable_stage2_unshare() to make it clearer about what is going
on.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7797813f4dbe..42f6e50825ac 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -322,7 +322,7 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
-static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 end)
+static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64 end)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
@@ -350,7 +350,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 	if (!handle)
 		return;
 
-	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+	__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
@@ -386,7 +386,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return -EAGAIN;
 
 		/* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
-		ret = __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+		ret = __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 		if (ret)
 			return ret;
 		mapping = NULL;
@@ -409,7 +409,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(pgt->mmu)->mmu_lock);
 
-	return __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
 int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
-- 
2.52.0.351.gbe84eed79e-goog

