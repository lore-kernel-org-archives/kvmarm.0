Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D779E1
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 10:33:02 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-30940b01998so2083689f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 03:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684751580; x=1687343580;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OuYPfEC3lTolcZHxyOkV/uA5U2PRVKfanaHh5bZLyhs=;
        b=CARegYa+KCOwleIKli38zoCxH29KqzVeIJg1egkQJ+MmU9Q9rqahxU5AGUpAG1Cxfh
         kXqXxKBsgC6wpqzv14W6j+lfAEsvYiDZURa7TvYu/zu9DUqVKUdnspgckdn4ZaQ+b7KT
         TTYLeoqeo/RVcOlcOHZDdfzvmX+3AwXp0o7ofYIhm//AQRw81EH7ZvcgrjrWRX07EQI8
         EM56X1uuSY81dDT9atIJDkj9Xjxb86o/rEOmrc55qjD/QYWhF+8TjTwL6VRKlCzB0n+M
         Lydh2WeIc/4k5YSNCPo7V0zoaBkljTCRijOwVpfQ33g8ZPfB2KE7+bt4tYJroHzBmSvX
         q3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684751580; x=1687343580;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OuYPfEC3lTolcZHxyOkV/uA5U2PRVKfanaHh5bZLyhs=;
        b=P68X5WIVmxkn27VZSkq+1z3EvbIqqVfbE17pb+F3ZtoGQYMz3583+Ea7oHp5PRosY2
         HDuCcd/DkM+IR16VofIEU5IShKTsXMxw+qlON24guqGKOqtwdn7p56fHKJm9S6hZFX2S
         wuZS6idftJchcv7fIQoqe2nR8yzjZ/HOreughXRCJleQjZlGi0JeGeuKBjhq4AummSSs
         0fEYGcwyc6aBDb60tTd2pDfBeZBmdYrzMg8p70iO1NN8KQyKhxKXse+Ozkgd7Ts1Tazp
         8FC4MTCbyYp5FPVV65xa/nw/4xnr7n8as3SIHtzvAMtx2KxyRWsMWk6dLOxcVmVze66f
         pMRw==
X-Gm-Message-State: AC+VfDxM2YKl+fHGbzjfX5EKRqtT7p1ey03JRBqFywGDntjguju9SUbi
	Spc9OC3od1BnOSc9P5qjOfIhdHXo8Z+nVHhKrLQS1k3ZuUIJqk7gEhv2+Or+6vcwhJM+GMgKoEb
	q5ln2Adaq1PSU5O+D2mfVt7RMOZOIE7cdtH9CW2MCiKSHhDX44KgNm3WAsMQ=
X-Google-Smtp-Source: ACHHUZ7tbe/scTwu6g/5zpaMTnOczY/wXe97y7NmSgNxXaS0NalPf4tWe6vF9ztRICdSstWe82RuI721SQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:dcca:0:b0:309:4424:9ce with SMTP id
 x10-20020adfdcca000000b00309442409cemr1191431wrm.5.1684751580720; Mon, 22 May
 2023 03:33:00 -0700 (PDT)
Date: Mon, 22 May 2023 11:32:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522103258.402272-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Reload PTE after invoking walker callback on
 preorder traversal
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, 
	catalin.marinas@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	reijiw@google.com, ricarkol@google.com, dmatlack@google.com, 
	qperret@google.com, bgardon@google.com, gshan@redhat.com, peterx@redhat.com, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The preorder callback on the kvm_pgtable_stage2_map() path can replace
a table with a block, then recursively free the detached table. The
higher-level walking logic stashes the old page table entry and
then walks the freed table, invoking the leaf callback and
potentially freeing pgtable pages prematurely.

In normal operation, the call to tear down the detached stage-2
is indirected and uses an RCU callback to trigger the freeing.
RCU is not available to pKVM, which is where this bug is
triggered.

Change the behavior of the walker to reload the page table entry
after invoking the walker callback on preorder traversal, as it
does for leaf entries.

Tested on Pixel 6.

Fixes: 5c359cca1faf ("KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make")

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>

---

Based on: f1fcbaa18b28 (6.4-rc2)

The bug can be triggered by applying Will's FFA series [1] to
android mainline [2] and booting a Pixel 6 in protected mode
(pKVM).

[1] 20230419122051.1341-1-will@kernel.org
[2] https://android.googlesource.com/kernel/common/+/refs/tags/android-mainline-6.3
---
 arch/arm64/include/asm/kvm_pgtable.h |  6 +++---
 arch/arm64/kvm/hyp/pgtable.c         | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..3664f1d85ce6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -631,9 +631,9 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
  *
  * The walker will walk the page-table entries corresponding to the input
  * address range specified, visiting entries according to the walker flags.
- * Invalid entries are treated as leaf entries. Leaf entries are reloaded
- * after invoking the walker callback, allowing the walker to descend into
- * a newly installed table.
+ * Invalid entries are treated as leaf entries. The visited page table entry is
+ * reloaded after invoking the walker callback, allowing the walker to descend
+ * into a newly installed table.
  *
  * Returning a negative error code from the walker callback function will
  * terminate the walk immediately with the same error code.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..120c49d52ca0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -207,14 +207,26 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		.flags	= flags,
 	};
 	int ret = 0;
+	bool reload = false;
 	kvm_pteref_t childp;
 	bool table = kvm_pte_table(ctx.old, level);
 
-	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
+	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);
+		reload = true;
+	}
 
 	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
+		reload = true;
+	}
+
+	/*
+	 * Reload the page table after invoking the walker callback for leaf
+	 * entries or after pre-order traversal, to allow the walker to descend
+	 * into a newly installed or replaced table.
+	 */
+	if (reload) {
 		ctx.old = READ_ONCE(*ptep);
 		table = kvm_pte_table(ctx.old, level);
 	}

base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.40.1.698.g37aff9b760-goog

