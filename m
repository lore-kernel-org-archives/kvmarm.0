Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53861E521
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543747; cv=none; b=RB/GKAgZMNyca8hCWvua4ZgyJ8TC7kTACQp5CimYnlYRHJrAWD43vwfgv5WBNDxfoV3HDzrgIYS7PXpaP0eDZkGm2MertOMOQwjFn+RpDUF2RXOqbxq8JkXR1wWMHfTLQorS2/KVu8sG6m6/+0rjBlDHCsR8GApDsTnBAocr05M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543747; c=relaxed/simple;
	bh=RUbUwiDDCmKdVzP1MptQx2+25gra+2nVr0exWg9VYxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g4LmwSefkSTUtdoAicCUYnzh1emoankSNvMg8eCUAHK2D3u6PSkpGLOsYcM8927FpJN50UiSYQcKTD1ZMZD0XX5odgPYjSQFY58YF9W+pP35qA4ALmTWuySF7i+N91bWmtElyaMZIkOJdhvX+TUZZaRPNouJNe7jYsHF5/tzBMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFfLlfW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFfLlfW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41156C43399;
	Wed, 27 Mar 2024 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543747;
	bh=RUbUwiDDCmKdVzP1MptQx2+25gra+2nVr0exWg9VYxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFfLlfW+8VqDLHrIgG3G7EIhdB4e2uSOo0qBiKw1dYwO+LgbN7VCySLQNEgrYHLDE
	 qtPeM3nlUN7OqAqHJwwOKHs/to/tsOO3eq1h4YdZJjYratX1gWhxL7/yOp5OiKvWX5
	 SyfTQ8l6SJ6E81JEC1nwBJJmIEzUOQd1GhaL/rOEDHYUcngzOMPFNMEu3YwBepgEcb
	 CKBtKmyjwh6V5flzlGiGR1S139Ih7jJd2uSrm7Q9nw04tPgsIPZ/d3YPH28NjDvW7F
	 QHmGoxatjwmntE4kVq08ln57ZYbiCNwaTBckyI+RAAJ2Kvf9xCZ5Gc0ZjDMBkrMgsk
	 vb+Ze52bwGebA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH v2 3/4] KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
Date: Wed, 27 Mar 2024 12:48:52 +0000
Message-Id: <20240327124853.11206-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240327124853.11206-1-will@kernel.org>
References: <20240327124853.11206-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c910f2b65518 ("arm64/mm: Update tlb invalidation routines for
FEAT_LPA2") updated the __tlbi_level() macro to take the target level
as an argument, with TLBI_TTL_UNKNOWN (rather than 0) indicating that
the caller cannot provide level information. Unfortunately, the two
implementations of __kvm_tlb_flush_vmid_range() were not updated and so
now ask for an level 0 invalidation if FEAT_LPA2 is implemented.

Fix the problem by passing TLBI_TTL_UNKNOWN instead of 0 as the level
argument to __flush_s2_tlb_range_op() in __kvm_tlb_flush_vmid_range().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: c910f2b65518 ("arm64/mm: Update tlb invalidation routines for FEAT_LPA2")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index a60fb13e2192..2fc68da4036d 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -154,7 +154,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt, false);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
+				TLBI_TTL_UNKNOWN);
 
 	dsb(ish);
 	__tlbi(vmalle1is);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index b32e2940df7d..1a60b95381e8 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -171,7 +171,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
+				TLBI_TTL_UNKNOWN);
 
 	dsb(ish);
 	__tlbi(vmalle1is);
-- 
2.44.0.396.g6e790dbe36-goog

