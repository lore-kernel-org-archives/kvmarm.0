Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EB2324B31
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882184; cv=none; b=Rhz5PDGJfqPvQ1fHv0BfsmAO/J1/SazSp3OhMMns65C6JwZuYN6x7c9Z8CrIfyt6WI3PDLdfPfv5NrRRc2/g5OHYSyetwgYxgpSgLHKmOhQ510Z6Eci+nfTR/S8Q9Uia3jJUtJTc2YlTUeNlka86/s49thj0Ly0/Kx3OztsSLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882184; c=relaxed/simple;
	bh=6nkcrkCRHUqqlyZysnmg8tV49OWHt4pl882aBUvDfo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7S3sa4NmSEaGLU1XBk6ez/U0XdmqY1KyZ3KygR99zJDw0eHiG9o5gyPmbiCN4Z3tUizAE0wcQQrp3KVDFewouCKV7jymy2B2O93mANlz3ARYy1qgDseHIbLoWQTAjkhDWmm4nT7VAK04OTWRBIGNrvYJldY/JGkq0B0+vadVu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0EAgj4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0EAgj4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70320C2BCB1;
	Mon, 30 Mar 2026 14:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882184;
	bh=6nkcrkCRHUqqlyZysnmg8tV49OWHt4pl882aBUvDfo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0EAgj4E/0a0Ogua6aDe6AVN5nEabWoT35fQuFc5Z1qEmOjLNKpJRLWeOgFxf+r0r
	 qDQBWsSefe1cccRElJTqYqpAFyLZaHP5jMixtGljyO4YDp10By69rVaVmQVI0NWbEe
	 sIUzoY3aa7va/0epgq0tyed0jh8XBOitTJkAlM6JyyHyDVIh9OzsAOcNoLD8bwQ9bu
	 JM30Wkmn8MYNT02JQ81FyuMkU9A3io8jurZBWkPKgV+C8qM/ZK5D+6H/0dgIckRqga
	 hm++YqoAKzVBO9yP8l17PFDQjW2tSJ3MpAutxXRJlEIFAsf8EnNgmB09MWFjCv1NTo
	 IKVUk+sCOPCsQ==
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
Subject: [PATCH v5 16/38] KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
Date: Mon, 30 Mar 2026 15:48:17 +0100
Message-ID: <20260330144841.26181-17-will@kernel.org>
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

During teardown of a protected guest, its memory pages must be reclaimed
from the hypervisor by issuing the '__pkvm_reclaim_dying_guest_page'
hypercall.

Add a new helper, __pkvm_pgtable_stage2_reclaim(), which is called
during the VM teardown operation to reclaim pages from the hypervisor
and drop the GUP pin on the host.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7d0fe36fd8dc..3cf23496f225 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -328,6 +328,32 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
+static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64 end)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
+	int ret;
+
+	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
+		struct page *page;
+
+		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
+					handle, mapping->gfn);
+		if (WARN_ON(ret))
+			continue;
+
+		page = pfn_to_page(mapping->pfn);
+		WARN_ON_ONCE(mapping->nr_pages != 1);
+		unpin_user_pages_dirty_lock(&page, 1, true);
+		account_locked_vm(current->mm, 1, false);
+		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
+		kfree(mapping);
+	}
+
+	return 0;
+}
+
 static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64 end)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
@@ -361,7 +387,10 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 		kvm->arch.pkvm.is_dying = true;
 	}
 
-	__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
+	if (kvm_vm_is_protected(kvm))
+		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
+	else
+		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-- 
2.53.0.1018.g2bb0e51243-goog

