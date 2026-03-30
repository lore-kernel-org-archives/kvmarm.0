Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC7324B23
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882145; cv=none; b=GAeKR1/3oKNfVnFL/vv5QxH9M4B3uDP9bXufYu+ogmzeY73E9rMNx+VBCv+K9GWi4TK2KY849HBilhDQmCw1VTO6WwkkziIrH2wpmpIgec6CPWLWCxzUvDkNFyene5tCSyiMeDBRJs5lQQL67glfF/cl/yXT6PbuI8aNpyqQmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882145; c=relaxed/simple;
	bh=03J6umtHfd+8x3jSWjUFyG+CUtvyPNtbJU/vryIouac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIS+GvIUo8yMkZhUhQRyt287Kv7nYcx4aUKnWbyTI8DZn5B5dSi/T9eIDlAPP8tfZ8u107KpJodi9iy18h1++IK0uI8d0rQUUm0fMySw9IOciHClx3/dVJrx/Mfdm9ufhHWPiZ+4jHW2ZLiZvSpu5GB0Il4ibZ5/5d4awjh2Bis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW6n3URx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW6n3URx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCB2C4AF09;
	Mon, 30 Mar 2026 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882144;
	bh=03J6umtHfd+8x3jSWjUFyG+CUtvyPNtbJU/vryIouac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AW6n3URxgaVJRnXW2D2AGOM2N6BOG7qPEQRpvZpV1tp/Fh5woKf4ZfxDjD/IORMGx
	 fQ05cUCMLBDmd1T6dhkzZMxDKMPQ0e56GD9Amisx8T4nZTGgIt4Bdq9L6FfsEnPNfq
	 +EaMqsfmVfFiZurYPmbRr52ImhGpfh8tgUASrL2xvFCyXKbDRdPBxzCNbyTTkSwXgn
	 Z8/WZbRDn27yhKNUdd3yZOvURgiJnccI90p6CmyEeS/NkzzzAFwiEv3M1z+gpB/CYg
	 RbYz0b+hsQzcC0fKgUOY+a9YazVJl1CNLvAkeG/vnxhr2lkfEYAUDOE6HJj3k6WYTt
	 HUdAe07VzAN4g==
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
Subject: [PATCH v5 04/38] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
Date: Mon, 30 Mar 2026 15:48:05 +0100
Message-ID: <20260330144841.26181-5-will@kernel.org>
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

