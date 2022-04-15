Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAAAC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B614C4B0BE;
	Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HwNfl4ZMbLO6; Fri, 15 Apr 2022 17:59:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC0F49EE6;
	Fri, 15 Apr 2022 17:59:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CECDE4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uz05pVNPahhw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:17 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 823B04B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:15 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 p10-20020a056e02104a00b002caa828f7b1so5432291ilj.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JyIVyQg6UGD612cbxcwyNwFE+I6JblVf7Z7F7spTUWo=;
 b=LMqmd6P7Ue7Y9IYx3CzgSFOTxT7tT239JnYQyS2EtWQ3fN4qbQ0VflsOtSv+zaS5bk
 +bvfK/SmAwgiQklAVqKG84UBqOcNnfZBYDShTxLbmp4TCyU+thTgl31lI4p91fxWMOn/
 dd2QO+9mQAqSvAt90OOkgKcjFxVpl7VjcraP/FuiseUcuGPj+F+x30DmaWdzLXajn575
 2MLUXCslyvGHkc1BlYeAgCkKGGLpODBbWpAJnCW0QHKTJCA67zs859BL+KVaEhsWfoh0
 j+lM1SBjp+89lbo+kBMwvVR9gQck0ZWmyt7cTKZrx3+vLXytC9/xjlO4AIrc/U0c/XjQ
 nkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JyIVyQg6UGD612cbxcwyNwFE+I6JblVf7Z7F7spTUWo=;
 b=F/Ha095vv7UZGrsVXgw24mKdIo5SoWFs8+ugajC6MRQS3fx6BPPrLUxURi+UbvQshw
 nh2vUfPP/MxNXmnei+i/ns2hmM9qI1y+egSSydkug++OylYgeBAWdYH8cl+wuufFlpv4
 ISbgzQvObP4tITiWV4FebAUjmL43Yvwz65FR1iz6M7D4ojxLjsOkp5DUo7iqKap0liFZ
 2nJEYj/iOmBeR4qIpr9tUjr4BRXTjCz9dlNNWAa7VmRB7GtSkzNeeCDi2D7Hmizg5kyD
 ffUO+4Mjy0d2OKKD4yzo8/hJAyrrjpLaf3usIfooSr/zwh6KYc2CI6++nA/DAmk3B+YN
 4pXg==
X-Gm-Message-State: AOAM532YE0X9GN3j+rmPzm+Nqy8UVT5g1SjaAtxb8btTSF+V1ENVJsSk
 /DHJ5ksV3ragyEuTtkVHai4sUj1inDmx//tGzKVbvmiHpLlnuhgH9LFzbfyWQQKh+WEEKgH8va/
 oNRNTo0Lqgc1uZ27k+AZqfjGCAWvdrQ7cXBhNuo7Byr5nj+SUvCoTYriowmYkNt6lSKH5AQ==
X-Google-Smtp-Source: ABdhPJwW/MzIxEmQ87y7GaINMs+YHxfeosd37KaEM3yVPDMpYVf1oEXa8efMhhfJEE88ApB9wQ629pQLxlQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:27cc:b0:5f0:876e:126b
 with SMTP id
 l12-20020a05660227cc00b005f0876e126bmr328774ios.129.1650059954862; Fri, 15
 Apr 2022 14:59:14 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:51 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-8-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 07/17] KVM: arm64: Enlighten perm relax path about
 parallel walks
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

To date the permission relax path of the stage-2 fault handler hasn't
had to worry about the paging structures changing under its nose, as map
operations acquire the write lock. That's about to change, which means a
permission relaxation walker could traverse in parallel with a map
operation.

If at any point during traversal the permission relax walker finds a
locked pte, bail immediately. Either the instruction will succeed or the
vCPU will fault once more and (hopefully) walk the tables successfully.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 059ebb921125..ff6f14755d0c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1168,6 +1168,11 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct stage2_attr_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
+	if (stage2_pte_is_locked(pte)) {
+		WARN_ON(!shared);
+		return -EAGAIN;
+	}
+
 	if (!kvm_pte_valid(pte))
 		return 0;
 
@@ -1190,7 +1195,9 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
 			mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
 						  kvm_granule_size(level));
-		WRITE_ONCE(*ptep, pte);
+
+		if (!kvm_try_set_pte(ptep, data->pte, pte, shared))
+			return -EAGAIN;
 	}
 
 	return 0;
@@ -1199,7 +1206,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
 				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
-				    u32 *level)
+				    u32 *level, bool shared)
 {
 	int ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
@@ -1214,7 +1221,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 		.flags		= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, shared);
 	if (ret)
 		return ret;
 
@@ -1230,14 +1237,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL);
+					NULL, NULL, false);
 }
 
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL);
+				 &pte, NULL, false);
 	dsb(ishst);
 	return pte;
 }
@@ -1246,7 +1253,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
-				 &pte, NULL);
+				 &pte, NULL, false);
 	/*
 	 * "But where's the TLBI?!", you scream.
 	 * "Over in the core code", I sigh.
@@ -1259,7 +1266,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, false);
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
@@ -1282,7 +1289,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, true);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
 	return ret;
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
