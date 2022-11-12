Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4022BA42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:22 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-3735edd4083so63305387b3.0
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcOfLt54IsOfCoqPxZfn8w9KDI4Dutt/bdjE+3a1Swo=;
        b=MofK9VK31xsO6tMy+bgRKy919ODPakIfC9zHrPHXualkPJkauN/HfhYMirTVJXZm8N
         7qTvmLxJUOmnw6xgPmtP9gAfuV13V6ofyNC8qso5hDcNO5+A01YEJZwjYahtcb7bMxdL
         X4aeN9FwW8UnZQC5t3eCnAPTOo2R5iQt8MQzey/B1xH2gGXycwewEfd2TtR9/hUyJX0K
         3bG122ZA+BoNVJ1Eb25XftTDbj8OgTmn9FvJsY2tHlS0Qwt+dheLsQJ00WBpirO6f+CB
         4qfT9l6WCPRj+I+QvgrGQa0ID0320vP0+ZKzIzAvYrgBuzhMjhZFgjd/yJSPKPp+aZtx
         df3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kcOfLt54IsOfCoqPxZfn8w9KDI4Dutt/bdjE+3a1Swo=;
        b=c+ru79TAwdAbvw/f3cShfGCNXeuYMStNF9+wwjzJw90gbHXfR6lk3Mxh9hGqyfC5UI
         /DaMxL/wxV9gbeeNr+pi73CZ+DiIDLC0NRXrfqLTzD1OjLWMIyyGM/N7AULZTPdeigpH
         hCpw9Eny0k6Y2MAYcoGM8tJEeGHeZqjJFTcCHcDqeBSXBMKxgJJdDzSGhL303f0lTuqE
         zBaLOsemeVyhkqZ4SS3A+GmJatWyjxD2Wzcwl/fUXSkHSSqBbEAz10PEsqSJwnXeQb2+
         OdLLHgfHH1I+JxstiU6K/zmEPyb9FxrrrMUxFUXdSM/yEbHgNJU48qi7Uh9/9AwBIRzr
         ncQw==
X-Gm-Message-State: ACrzQf3jpzMrhR5LwvKOrNSYl+5+pK6XqhufO3aE08ygE/ISVDwJ26rU
	iQxTBvKrvKWqDl4w7OZmBJ2zeei+179amQ==
X-Google-Smtp-Source: AMsMyM5u8pnpy6TfMYS8Jx9s0FAOyCRD3hWvryIkECHvdmklRnVRM8e/SdEeNekkj4jlvpJtossjVmN6ofSxTQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:380b:0:b0:6d2:715f:9ca2 with SMTP id
 f11-20020a25380b000000b006d2715f9ca2mr38281508yba.532.1668241040674; Sat, 12
 Nov 2022 00:17:20 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:04 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-3-ricarkol@google.com>
Subject: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in post-order
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081704.rJqI7Pxe9_TGK_rsb8_AhOJvX7HKORARZTKWk961fpE@z>

The page table walker does not visit block PTEs in post-order. But there
are some cases where doing so would be beneficial, for example: breaking a
1G block PTE into a full tree in post-order avoids visiting the new tree.

Allow post order visits of block PTEs. This will be used in a subsequent
commit for eagerly breaking huge pages.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e2edeed462e8..d2e4a5032146 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -255,7 +255,7 @@ struct kvm_pgtable {
  *					entries.
  * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
  *					children.
- * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
+ * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
@@ -263,7 +263,7 @@ struct kvm_pgtable {
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
-	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
+	KVM_PGTABLE_WALK_POST			= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index b47d969ae4d3..b0c1618d053b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -265,7 +265,7 @@ static int fix_hyp_pgtable_refcnt(void)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= fix_hyp_pgtable_refcnt_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_POST,
 		.arg	= pkvm_pgtable.mm_ops,
 	};
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b16107bf917c..1b371f6dbac2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -206,16 +206,15 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
-		goto out;
+	} else {
+		childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
+		ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
+		if (ret)
+			goto out;
 	}
 
-	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
-	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
-	if (ret)
-		goto out;
-
-	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
-		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
+	if (ctx.flags & KVM_PGTABLE_WALK_POST)
+		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_POST);
 
 out:
 	return ret;
@@ -494,7 +493,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_unmap_walker,
 		.arg	= &unmapped,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_POST,
 	};
 
 	if (!pgt->mm_ops->page_count)
@@ -542,7 +541,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_POST,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
@@ -1003,7 +1002,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
 		.arg	= pgt,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_POST,
 	};
 
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
@@ -1234,7 +1233,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
-			  KVM_PGTABLE_WALK_TABLE_POST,
+			  KVM_PGTABLE_WALK_POST,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
@@ -1249,7 +1248,7 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
-			  KVM_PGTABLE_WALK_TABLE_POST,
+			  KVM_PGTABLE_WALK_POST,
 	};
 	struct kvm_pgtable_walk_data data = {
 		.walker	= &walker,
-- 
2.38.1.431.g37b22c650d-goog

