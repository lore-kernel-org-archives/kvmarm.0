Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE04C83
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392736; cv=none; b=IO/J+ZA33vSEnubcHolTW8v2rsQD/NHgZWqAptL6LoCr6n43W5aJ955pshhkIP6NipdFBkOJYpqoSRfz76ZiuNFlX5BR9R3ibAJGF/DVD/4SuBT5cGHhtTiPrhvNrxBuPoXnaattE++dR/zO/307W8OwlNVBNqhsZrnwsqoArp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392736; c=relaxed/simple;
	bh=5VC9JxVG/MnzPe32qgOZJvC9+h/6mt0fn+04mmR6EA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VuhRmXZr0jYJRr16RZuDzO6yklzpL4i0qIUWUXqshAxf8d3U7kMD8lXIHi7xjnC1BYimF+EuAV/QPdDP9RtK61lKlHhkCj4QoPIOUioeGlC8+zMUuR/Eq4K8LbzlC4Iz6ryxaXaDNjjOaV1v89cOwBpWIxsSvnI8erxspKIkaWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRR+3X41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRR+3X41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA95C433F1;
	Mon, 25 Mar 2024 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711392735;
	bh=5VC9JxVG/MnzPe32qgOZJvC9+h/6mt0fn+04mmR6EA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRR+3X41/frNKQpo6GkyBimMxAofL3xe8b6d8Gkd1GzgbE1ZcKJKHWtZhrPwAPm1D
	 vlk6iVLTeRzZPStF6jiWZOk7aX7o1mmLuclHZjWII5F4fImPb54vSiWGTv4a8OsML1
	 iemPkxJJ3cvhehYXVsOA8C1yEZSTp8/YP4JjlsiPYxO8HZWeFAYf9x1ewoqmCT056I
	 DkzsJhdysXzYTu+6XRsU+qlXGiIqmergAfW2m8av7xTg7qj65tS02BtV7BoiiBX357
	 t2vXubitUsJGEhqPlXTN4oC6E/buIg+NrBPKxMTgrHE1yJiQmruuLnvlRm9qtufck/
	 dCMFKx+OKpLhQ==
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
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
Date: Mon, 25 Mar 2024 18:51:58 +0000
Message-Id: <20240325185158.8565-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240325185158.8565-1-will@kernel.org>
References: <20240325185158.8565-1-will@kernel.org>
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

Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
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

