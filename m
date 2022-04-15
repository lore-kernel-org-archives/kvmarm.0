Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA857C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62767402A9;
	Fri, 15 Apr 2022 17:59:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id an6Cx8DGhyCn; Fri, 15 Apr 2022 17:59:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D12849EEB;
	Fri, 15 Apr 2022 17:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FFC49EBA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKgjTLZ7Pj33 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A69849F11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:11 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2ec44c52e7fso76083827b3.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rJSIRdYzlgGDLU7B2Sk5nACgnVsuidWq4rds0LFJzOM=;
 b=SkrQ1f8DZ8O/NnR7vbyJvJQIHE/etfmq3uFO690m3CAYnbo6y2Ixqb7gAvpAOTVELL
 6wOSAg7n/y+F6WeMp05hmHl1fcyiWC8VoNMxEO4OeOYzRlFDvzzQ7jFGCTtm845QHSoG
 LccB7cLdd71eA0BI0Ru81TgjWmc8dS30Ot2pDg0Hy1uI1b5zb05v+/GrUfnWCauhOnPJ
 NySizl2te/E7Y0lMCQzjXVzUzPthbWsjhBBncJtixhl5pRXhKQ3taAldhzHbsTSuXMOE
 rm5tR4TfdW/tfw/Uf8GxBSY3l4Dd0OpWCNbMfnbvgCpEtN0cME8Q2ExGtfE12VB6U/GX
 +VFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rJSIRdYzlgGDLU7B2Sk5nACgnVsuidWq4rds0LFJzOM=;
 b=wF0k+LaNsZ2QkcC9BDasi32ZBCDymcLClRVU6zJPfsrME3s5KO7S8D5ZwwgbOqJoPP
 NcFSHgWe/01GoQIdc5cLEV2UPSpO1Mehk/oWbJ9Yaar14N/L2l+XqBXmD8hOMWCxzCNg
 PccoIKbHm+NGaC8OuKvrwWU/96EoqbnqmGJzoIWPmaHppJ59niF/3Bosognjg1+RKfv8
 o7wdV71IwCdbkf9BTEOKPltTjsLezv8pbmYzT/7mHPmuSJUQTWUXvjn15cK6GRJxMDrz
 ebGttY2S0kOukS/daQ6zmTl50HmsNVCnzJonOkrYydvlDmfTv51FPPjB+uwTLv5PHWoQ
 /ZPg==
X-Gm-Message-State: AOAM530Q9DXuboXZnozHwjNb8Pnus6kxRjvYjPMLWA7woT3f7vy9L/e2
 OvcDcKYZfQAvJGQJZZom2+Ygz/krULuVCcTNdkyxwihEY66BOrLO6SLdEcF3F3IOggqFWK4t6lw
 E4vdELnG5u8NpMCrl1Q7ELp+lAfxBgzjL0qnLW1MjceCtwZLE3HA/6OvFvFNXvcj0fKb0kA==
X-Google-Smtp-Source: ABdhPJwz4sx5L43ob0Z3jNzyJVyA2Jzsl+sCY5ofO1Xxk9cu0zlH1igqV35RpwEAUlFfB8+y4wm6MGToMi4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:6f55:0:b0:63e:7447:7c19 with
 SMTP id
 k82-20020a256f55000000b0063e74477c19mr1036666ybc.551.1650059951469; Fri, 15
 Apr 2022 14:59:11 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:47 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-4-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 03/17] KVM: arm64: Return the next table from map callbacks
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

The stage-2 and hyp stage-1 map walkers install new page tables during
their traversal. In order to support parallel table walks, make callers
return the next table to traverse.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ad911cd44425..5b64fbca8a93 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -205,13 +205,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_LEAF);
-		pte = *ptep;
-		table = kvm_pte_table(pte, level);
 	}
 
 	if (ret)
 		goto out;
 
+	table = kvm_pte_table(pte, level);
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
@@ -429,6 +428,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
+	*old = *ptep;
 	return 0;
 }
 
@@ -828,7 +828,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
-
+	*old = *ptep;
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
