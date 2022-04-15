Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B439C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C540849EDF;
	Fri, 15 Apr 2022 17:59:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fkYlZMjWPF7G; Fri, 15 Apr 2022 17:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6454B121;
	Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B16B4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T3l0r3WgD8JD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:18 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79FF249EEB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:17 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 j6-20020a5d93c6000000b0064fbbf9566bso5428654ioo.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0g9zJiooWDeKugRAQw4FN5FN0/UzyXcPgqHvAqWzKag=;
 b=oLCH+GSdJvXkd0Gi9+H7vA79g6hjv3mWJ8f1Ky8MSz9VGrXihtRm2Q2mQk94XB6R1V
 rI0BdGd8LpAzMP3bNbGXHpcJwONP3gy5q638j75OkVYuPzBzMikI3B/GpnP4ZHi6WYgC
 1NnjFM6MAYPTaJtge/P7t3M0AOj4J/HW1tzhhrT32UjnHREO3sHO9Q6aRYB6eSSaw14y
 1XJYEXTFyIROlajcWQONhn8qbXtAQymvl+UmDZ5XpOcMbLVur2O69+FsbWoSTYPTr05p
 24KmSiJ75xiAF16xI5zuCM76equOlcpV45VjmXOI3Dw1o6nycZZCyMKAyu7F35txmRD/
 JODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0g9zJiooWDeKugRAQw4FN5FN0/UzyXcPgqHvAqWzKag=;
 b=CPX7q8oaMFz6c2SOzWI8B8UnXP6pfyovcHfzwX8Qx8mZBoWV9rA4NtN7XIMJnht/F7
 8QDwtNoqOx16b8zOAVu2el+YC+9AP600VaL3YGQ9fgu4PvApj2D1EVUw2KSSBO9pE/a9
 aSLrIm+cqZ6qRR2xHchScb8RphH+H5NozUVdVDK4ys0hpjxC+SiXUa2Exf7v3Zm7OtA5
 i+Mg4O4V7SEreSSdnoJt9WMetekQLNhc5YKzLtXE9XyzorHrzN5jQ8Jh9RQeJwU1AUEx
 VaBY7kQykz/751tZTLMHGBCdmmKj3z9qIo3675qP/GZRp8MvzM4j4xUidUjfCBzmAeAn
 aDnQ==
X-Gm-Message-State: AOAM531Iff5SUa+0K+ZXPHbQZxa2coZJncGS+HoArEkCOX6imqpMxXa/
 WvKetzl7ghC3rOi40pyFjEWORCxf2H2ysdpFaCgHjNlwfFhgykm6RPq4d4acpf5pDqs0716dg0k
 zbv17I92FPAd3q+kaRiLhdO4lEPTpjGdnDU2Xr6FByDtTVBwh/Bw+WgQ8xCIjgZeP3f/PWw==
X-Google-Smtp-Source: ABdhPJy38Wy2JIODUbPjdCPdcAqin2kc7u187gx+PAUVY0P1F7nHnp3qVfiaCtdGLADk1YLKoWq+Y853FYQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:218a:b0:326:6ed7:c011
 with SMTP id
 s10-20020a056638218a00b003266ed7c011mr473714jaj.242.1650059956892; Fri, 15
 Apr 2022 14:59:16 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:53 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-10-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
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

Breaking a table pte is insufficient to guarantee ownership of an
unlinked subtree. Parallel software walkers could be traversing
substructures and changing their mappings.

Recurse through the unlinked subtree and lock all descendent ptes
to take ownership of the subtree. Since the ptes are actually being
evicted, return table ptes back to the table walker to ensure child
tables are also traversed. Note that this is done both in both the
pre-order and leaf visitors as the underlying pte remains volatile until
it is unlinked.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 56 +++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ffdfd5ee9642..146fc44acf31 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -838,6 +838,54 @@ static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_m
 	}
 }
 
+static kvm_pte_t stage2_unlink_pte_shared(kvm_pte_t *ptep)
+{
+	kvm_pte_t old;
+
+	while (true) {
+		old = xchg(ptep, KVM_INVALID_PTE_LOCKED);
+		if (old != KVM_INVALID_PTE_LOCKED)
+			return old;
+
+		cpu_relax();
+	}
+}
+
+
+/**
+ * stage2_unlink_pte() - Tears down an unreachable pte, returning the next pte
+ *			 to visit (if any).
+ *
+ * @ptep: pointer to the pte to unlink
+ * @level: page table level of the pte
+ * @shared: true if the tables are shared by multiple software walkers
+ * @mm_ops: pointer to the mm ops table
+ *
+ * Return: a table pte if another level of recursion is necessary, 0 otherwise.
+ */
+static kvm_pte_t stage2_unlink_pte(kvm_pte_t *ptep, u32 level, bool shared,
+				   struct kvm_pgtable_mm_ops *mm_ops)
+{
+	kvm_pte_t old;
+
+	if (shared) {
+		old = stage2_unlink_pte_shared(ptep);
+	} else {
+		old = *ptep;
+		WRITE_ONCE(*ptep, KVM_INVALID_PTE_LOCKED);
+	}
+
+	WARN_ON(stage2_pte_is_locked(old));
+
+	if (kvm_pte_table(old, level))
+		return old;
+
+	if (stage2_pte_is_counted(old))
+		mm_ops->put_page(ptep);
+
+	return 0;
+}
+
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -922,8 +970,10 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     struct stage2_map_data *data,
 				     bool shared)
 {
-	if (data->anchor)
+	if (data->anchor) {
+		*old = stage2_unlink_pte(ptep, level, shared, data->mm_ops);
 		return 0;
+	}
 
 	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
@@ -944,9 +994,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	int ret;
 
 	if (data->anchor) {
-		if (stage2_pte_is_counted(*old))
-			mm_ops->put_page(ptep);
-
+		*old = stage2_unlink_pte(ptep, level, shared, data->mm_ops);
 		return 0;
 	}
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
