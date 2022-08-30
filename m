Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C787AECAAA1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 19:42:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 567CE4B98D;
	Tue, 30 Aug 2022 15:42:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4FYMA1DAS3wv; Tue, 30 Aug 2022 15:42:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E618C4B999;
	Tue, 30 Aug 2022 15:42:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EE14B991
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WUtYCcphGd4X for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 15:42:23 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D25E24B99A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:22 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661888542;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PAa+cBkl9mtwNYK8/w+PcWpN4aBBuzKZQpA5735hA3U=;
 b=ZLs5MEMDu72sPbf1oddAbPXFBK5HqyrH0LLuSMgJABWcVJhbffI94ChKh6fxlG4PUKb7Vt
 fp76TAzFIbxRDAKaCkX+hrkh4G3NnP0ojf+1rETVa0eO6qJqWT0Ozz+ovLennkecVRUXjy
 TzWk0l+KpUzy6uyX60KuJjkrZ/YIBkM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, Ricardo Koller <ricarkol@google.com>,
 Reiji Watanabe <reijiw@google.com>, David Matlack <dmatlack@google.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Date: Tue, 30 Aug 2022 19:41:26 +0000
Message-Id: <20220830194132.962932-9-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The use of RCU is necessary to change the paging structures in parallel.
Acquire and release an RCU read lock when traversing the page tables.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 78fbb7be1af6..7d2de0a98ccb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
  */
 enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
 
+#if defined(__KVM_NVHE_HYPERVISOR___)
+
+static inline void kvm_pgtable_walk_begin(void) {}
+static inline void kvm_pgtable_walk_end(void) {}
+
+#define kvm_dereference_ptep rcu_dereference_raw
+
+#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
+
+#define kvm_pgtable_walk_begin	rcu_read_lock
+#define kvm_pgtable_walk_end	rcu_read_unlock
+#define kvm_dereference_ptep	rcu_dereference
+
+#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
+
 static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
+
+	return READ_ONCE(*kvm_dereference_ptep(p));
 }
 
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f911509e6512..215a14c434ed 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -284,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
+	int r;
 
-	return _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_begin();
+	r = _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_end();
+
+	return r;
 }
 
 struct leaf_walk_data {
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
