Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E437F
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 22:32:43 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695421962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vL8m+Ny4oeZyVymcpAEgDwDOn+d91ncUVgq4N1Cs7n0=;
	b=g9lc7sGXBSpWOAkVmWrFojYyN4PSTNXvOnNDJh2ZLAjMo6KmUum/b836nbcWDhbPnsAfLz
	x+NA4cCeVnXy5fe1qOsU42r6aYkNXX9siF0pibUuzdNhfqNKZIlmi4MCqDf3HvfA3iFViu
	nnw/FKUPqTRlpJmA/tPCUU3iFmdUVhs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vipin Sharma <vipinsh@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Always invalidate TLB for stage-2 permission faults
Date: Fri, 22 Sep 2023 22:32:29 +0000
Message-ID: <20230922223229.1608155-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It is possible for multiple vCPUs to fault on the same IPA and attempt
to resolve the fault. One of the page table walks will actually update
the PTE and the rest will return -EAGAIN per our race detection scheme.
KVM elides the TLB invalidation on the racing threads as the return
value is nonzero.

Before commit a12ab1378a88 ("KVM: arm64: Use local TLBI on permission
relaxation") KVM always used broadcast TLB invalidations when handling
permission faults, which had the convenient property of making the
stage-2 updates visible to all CPUs in the system. However now we do a
local invalidation, and TLBI elision leads to vCPUs getting stuck in a
permission fault loop. Remember that the architecture permits the TLB to
cache translations that precipitate a permission fault.

Invalidate the TLB entry responsible for the permission fault if the
stage-2 descriptor has been relaxed, regardless of which thread actually
did the job.

Cc: stable@vger.kernel.org
Fixes: a12ab1378a88 ("KVM: arm64: Use local TLBI on permission relaxation")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f155b8c9e98c..286888751793 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1314,7 +1314,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
 				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
-	if (!ret)
+	if (!ret || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
 }

base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

