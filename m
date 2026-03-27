Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8E4314D21
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620064; cv=none; b=HLFVIi2CRyp9OD6hh/LmIaZO7z7ELtKfUr0mcUskO9SVb0ueVd5x4SvlDT5DwGsESrBx+hqTNhtjSgX+QVvKaukgd7nraG+wxbOKhwFoLA8YPl70WjBTmWZDNHXtgV07YMT9cx3t8l7X5yY2O82mahqrieGRei9QejOGfIk1hYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620064; c=relaxed/simple;
	bh=03J6umtHfd+8x3jSWjUFyG+CUtvyPNtbJU/vryIouac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFgCbjE8b6I3b+7l9cPmBL3VF+vLytS2ku0NFEi96CHPp8awwMojwpeRJK2y9lH4sSTSEOYADg+YJTrMH3cFLFCMbICeOw9qfHZXzwsnnrgBC569Iht8kIDGovG13DodhbIuFzmcsXyy2/7C/xOHLmpfSr7o7VYtszC2AIAHJmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTbJGcYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTbJGcYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F04C19423;
	Fri, 27 Mar 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620064;
	bh=03J6umtHfd+8x3jSWjUFyG+CUtvyPNtbJU/vryIouac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTbJGcYpBT76rucUq4rz0ma98df9MXZlXSVNzmIKliPFjo7EspcQUkzLNYlwQY6i1
	 u4S9+dhvlSGOOWwzmStdCpdTRI8vC2kAC4PNwjJLS0e1zDpVqYVpw1hbsiWH/SwKlZ
	 /T98aFeSpCRBGkm8KtL1hZnYZqIMyzc0wDEEsiIcJCnDDukjfbYza7jy2qezkgbSRn
	 40HklWcfN0ANG4lc3BDHagVLzK0hJwfdxYRdljpEcbHlmpGY8H/oH+qd/naRnFdXRg
	 4lNE2QqmHagXu/dd0PwUbaLN/Q/hOE+wtmmH44es1OnJfsm734E4zIbAhA+21Fz/W8
	 782OfjPs+f85g==
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
Subject: [PATCH v4 04/38] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
Date: Fri, 27 Mar 2026 14:00:03 +0000
Message-ID: <20260327140039.21228-5-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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
2.53.0.1018.g2bb0e51243-goog

