Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7875C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 18:22:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82ECA4BA19;
	Fri, 18 Nov 2022 13:22:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rmw1TdcryVj1; Fri, 18 Nov 2022 13:22:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990544B9F1;
	Fri, 18 Nov 2022 13:22:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A964B9E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 13:22:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Uys3VrJFaIa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 13:22:42 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5FFD4BA12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 13:22:42 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668795761;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7go3+H51QR8+lH2MFJhouDdMualoRRzB14E5HXw/Lg4=;
 b=OU0PXGROkLqlvr+0xrh4JUkII6X/ARfgpVkJYuvfJrYF3OJPVmFKIy2YhSD8EPhLuQ7Bpy
 CMW1W+zHgGVDkMpkWVIPdz25L/dWzYFudVc3ine+AMpyGs2g8ZmVFxvEeFEMBnMvMGShBO
 W5EPNzAH9+x+8p5fi2zfLnap/xhqNbU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v4 3/3] KVM: arm64: Reject shared table walks in the hyp code
Date: Fri, 18 Nov 2022 18:22:22 +0000
Message-Id: <20221118182222.3932898-4-oliver.upton@linux.dev>
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

Exclusive table walks are the only supported table walk in the hyp, as
there is no construct like RCU available in the hypervisor code. Reject
any attempt to do a shared table walk by returning an error and allowing
the caller to clean up the mess.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c         |  5 ++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4b6b52ebc11c..d5cb01f8dc06 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,7 +229,18 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
-static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker) {}
+static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
+{
+	/*
+	 * Due to the lack of RCU (or a similar protection scheme), only
+	 * non-shared table walkers are allowed in the hypervisor.
+	 */
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		return -EPERM;
+
+	return 0;
+}
+
 static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker) {}
 
 static inline bool kvm_pgtable_walk_lock_held(void)
@@ -247,10 +258,12 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
-static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
+static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
 		rcu_read_lock();
+
+	return 0;
 }
 
 static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d6f3753cb87e..58dbe0ab567f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -289,7 +289,10 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 	int r;
 
-	kvm_pgtable_walk_begin(walker);
+	r = kvm_pgtable_walk_begin(walker);
+	if (r)
+		return r;
+
 	r = _kvm_pgtable_walk(pgt, &walk_data);
 	kvm_pgtable_walk_end(walker);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
