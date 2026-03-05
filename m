Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9F03AE70E
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721903; cv=none; b=aiAxDu7ZBYsaci7KcxwkFKTi6azIPHFbJjvsZJzb0XJyLDM1xvaL9MRwHnemIJSl0v6yvrlM2lAGrAxcsdhSXgeBhLZErYWb/xujFS9v1q1DJ/HrNs/NpSzgOJj87I0oCDW9NVDyADjth+1YPo0prNx1kylO1UjQLaHLKvGe6Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721903; c=relaxed/simple;
	bh=ZFZN8A37nToAI6B0WJ6a2JQ5jY/kc1n7WNlM0zbyq1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0ZMqtmZdsUEJmGVNU+W1KcRFihWp5IIUmzhQbZ5LuwdmVFQ3oiIyD5MlgOVTBWGPcDxWdy7fdG5PqZGVoOkEtYgV9YRDLZQrcVrC6eW0CQy7SfZE9hfZtl360HMX/7Llkjw4x5GL4xWg2VnM/6QlFOxpUedvN5v1M1M9jDZe/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkJkB7ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkJkB7ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E2CC116C6;
	Thu,  5 Mar 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721903;
	bh=ZFZN8A37nToAI6B0WJ6a2JQ5jY/kc1n7WNlM0zbyq1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkJkB7ksSNwLIw2GgCnVzGeueoattv7HH5DypH4MQStkBY72xV5tHtYIho33GAGxn
	 G+KC0v/bk+nBo6cipzrt/Y79CAP0fXJtof5Z+e8XF82cEltnit6ro1ZWFTmhniNUd6
	 57bHZYtw+D34OUsghu6w7h27cWZEHIM7xD3rCSIDbIlqzgP0eGBXxmOZZP3A7X/Qfk
	 Y3sOZM2KwtWFDpx0YUxnBeW13UMpuW+9lQ6WNgPjd+8ySWBrsew30ais87qCVUWEoa
	 YpnvD8jeFGao673jqilAlPrg5OLu40/XfD3p58vUH9qT1yWhtaAjNwULu3j+HOe8a3
	 fmfFS1IxtXG0Q==
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
Subject: [PATCH v3 15/36] KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
Date: Thu,  5 Mar 2026 14:43:28 +0000
Message-ID: <20260305144351.17071-16-will@kernel.org>
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

During teardown of a protected guest, its memory pages must be reclaimed
from the hypervisor by issuing the '__pkvm_reclaim_dying_guest_page'
hypercall.

Add a new helper, __pkvm_pgtable_stage2_reclaim(), which is called
during the VM teardown operation to reclaim pages from the hypervisor
and drop the GUP pin on the host.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 1814e17d600e..8be91051699e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -322,6 +322,32 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
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
+			return ret;
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
@@ -355,7 +381,10 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
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
2.53.0.473.g4a7958ca14-goog

