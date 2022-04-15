Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEB6C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C66034B0F4;
	Fri, 15 Apr 2022 17:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l0Cor+QflWRK; Fri, 15 Apr 2022 17:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 908244B0CC;
	Fri, 15 Apr 2022 17:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C70A149F24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mLEUQZd8zT8v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0F2B49EE8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 x1-20020a056e020f0100b002c98fce9c13so5430282ilj.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tskkletjI1xqy2hmf+NUDTVo6kgDSU4EL5qdYTa3BLw=;
 b=QA94h9r9pTA8GiRYxYPRCc5lnTzXtNJwZmjCbvYN9o6CVFPh0a2tzWI0hkn2GGLweA
 Txpvs213Jksx0vyr2ngPBysyiEw8KC95EbN0Ju8DT94akH1bQ62gDiZBnBpVmOCl0cU/
 aVzTHXbtTPOJrXqnXT7zTKFXplRLdZ7urB7/NYg8iYE+D1B5NQXQp/3h+iCMDQQGzAYs
 +i1QI9nvkwP3sApqy92wxAC2ykVI1oGcIkQRiYST9T63+AoQWeZ9+xAr1yQAoB7YwpSw
 L5Y0d4II8kHY6IRbv/oLjeQ9jnR7XErbOljztHLeXABbdjtB3zDvW2Om/oADovnpl9yM
 AUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tskkletjI1xqy2hmf+NUDTVo6kgDSU4EL5qdYTa3BLw=;
 b=QN5tlci6fwSOR0HUCv5kkcKEsUv3q/7uh70TAi5OpErvDLmj5n0DCfqbA0IQ7GACUr
 xl8ZqmKipCWrCPGNEquL5Iubikgiup4nZo7yGl7240brYjbom9ljXyzIGQWyVkrD9w1a
 78Y9JeHiIS5QAmIgAEIeEsY06GDgXX5ghm593adNaK3j2kBa8DHPYNohqouyBY42d3jV
 C7B6Lcv2uTMcuzasyMpuYIv6IsBmWZZwiUbhMNVGzid8NzA9Zb+Sqa73ocbuIjBcmJdP
 jnZEH39yFYE6j7WUsGCG9rPIrgvgPqFnIPDdla9+13riOxPtsvMmuNEVHWmYLBP19jgh
 JZKA==
X-Gm-Message-State: AOAM531vUXPtuqasnTD4vQ+2o5mHhUd9zp39HNG7v8ydw1OdUWCpBaCv
 Yk1Kzf4rL50DO5ld7Vz/rkcouy3sNz/ofY8F//caZnYBz5hqqed6L5pQN8JZSphn2DpBhESGy01
 6e1jzUh9qlhX4b8TghqGp5p3t0IVSvACSvxrVDdGtiHrUK/kC/89TtyPkChPGOWBz3JoSHA==
X-Google-Smtp-Source: ABdhPJyVhtFMabjcfJB2grqI91o53/8kDGiTwPio15sftKb54bR0cux4tb8br2mZT5w8v0L5arzr0CpVpX8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:20cd:b0:2ca:c074:4ebb
 with SMTP id
 13-20020a056e0220cd00b002cac0744ebbmr283965ilq.73.1650059952284; Fri, 15 Apr
 2022 14:59:12 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:48 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-5-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with RCU
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

Use RCU to safely traverse the page tables in parallel; the tables
themselves will only be freed from an RCU synchronized context. Don't
even bother with adding support to hyp, and instead just assume
exclusive access of the page tables.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5b64fbca8a93..d4699f698d6e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
+
+#if defined(__KVM_NVHE_HYPERVISOR__)
+static inline void kvm_pgtable_walk_begin(void)
+{}
+
+static inline void kvm_pgtable_walk_end(void)
+{}
+
+#define kvm_dereference_ptep	rcu_dereference_raw
+#else
+#define kvm_pgtable_walk_begin	rcu_read_lock
+
+#define kvm_pgtable_walk_end	rcu_read_unlock
+
+#define kvm_dereference_ptep	rcu_dereference
+#endif
+
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
+	kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
+
+	return kvm_dereference_ptep(ptep);
 }
 
 static void kvm_clear_pte(kvm_pte_t *ptep)
@@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.walker	= walker,
 	};
 
+	kvm_pgtable_walk_begin();
 	return _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_end();
 }
 
 struct leaf_walk_data {
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
