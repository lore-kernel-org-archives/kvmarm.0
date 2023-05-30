Received: from out-47.mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75B206B4
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 19:32:37 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685475155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JVMjAcGuC6Xgi+ZFZsup7ky2vHzlpmovl5JmDiIW5nc=;
	b=kDWUwBDegAAuCx6HvZFIsr+TVKEhenp67RnujftDpVCLsUuQpeDe2r+ghL9J98aTT0Kmuc
	thvj8xz3lzjgRmaZlV+pWyMltur71y+cXaeyImJndnYHGHcstvVMuLveGVw8PPbyrDjIpR
	s8m8bH953j0ZPcZX6ywLEPh4D6DTa3k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>
Subject: [PATCH] KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
Date: Tue, 30 May 2023 19:32:13 +0000
Message-ID: <20230530193213.1663411-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The reference count on page table allocations is increased for every
'counted' PTE (valid or donated) in the table in addition to the initial
reference from ->zalloc_page(). kvm_pgtable_stage2_free_removed() fails
to drop the last reference on the root of the table walk, meaning we
leak memory.

Fix it by dropping the last reference after the free walker returns,
at which point all references for 'counted' PTEs have been released.

Cc: stable@vger.kernel.org
Fixes: 5c359cca1faf ("KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make")
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e1eacffbc41f..95dae02ccc2e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1332,4 +1332,7 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
 	};
 
 	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
+
+	WARN_ON(mm_ops->page_count(pgtable) != 1);
+	mm_ops->put_page(pgtable);
 }

base-commit: 811154e234db72f0a11557a84ba9640f8b3bc823
-- 
2.41.0.rc0.172.g3f132b7071-goog

