Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44D1C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:44 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2562fbb193bso845135a91.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722184; x=1688314184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYi36v/YAwaQRjgMVH+8EY8FA7aBBtQ+BKuLP6eDkvQ=;
        b=Dw12ocPSe9vJUzYvSsSf9AU3CWoiwTk/XWOJWSQ28tLpoS2cFvmMFQbSf/qpjpxy7v
         oO7YPmr7slJeCTpuInsqqCsWP0mQqS3ua3oN9mzqlTzskeKCsUc+Eng3akxDWWH0DIw4
         jhV0Z/aBx0lDztLRsncoYBKeU0QZUKmq2gyk1zRIGBfBu0xTC7gF0pRwGDV7061++Ztg
         o5Q/lPpRn/0BOjk3RHl0WBfcrcdb3R1NScbQhD6quOJddTL53tPtBy4zB10NE0mDM/7t
         Ap9iqqT0iz8St+1DIUrYSZSYDvTKdSKGgplDSGDJzXhKejoEUVmNl+mnTfSIjic7IX8O
         rhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722184; x=1688314184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYi36v/YAwaQRjgMVH+8EY8FA7aBBtQ+BKuLP6eDkvQ=;
        b=S8GtDtTqmFaFLD/wj0+a1XeY9xGHhbBXM915sidsuEvl9RdUCM1U+XedkpMO43Ysto
         PhhwWdgH56JF5vfCxk29ctU7KMGlHMiPgcNc7uB04BgG+rKv27rIV4sv/ZOcfsIlQwe/
         M5t00B61DJSYsXHxj+T52wX4Sjk4bSu5PGPe2LchywFFLNxRd3lr5n+OXnLAJfogx4r/
         BJGkzzEViPO1DtnoN84QpHTOlgQ5l3O5ywI+FmbyZCRF2ip+Alf7FF2H3IqWvlx+r5KN
         RP3CAYmXfPQ9rRfEZciAJ22AFUwU3fpxOWc3IbTCoeIiUt+vM7m+NHzBz9aPdFLzO14F
         mvVQ==
X-Gm-Message-State: AC+VfDwzievgAxu42Qf4C1lNjtzuDp7kEbGfPw/HsNt4oIPNcM8Vw5Uf
	qdFvvfihWZp2dMGQOcTOeWZT3f17jCFd
X-Google-Smtp-Source: ACHHUZ4+c4f5xcGK/eLSU3xHgu8tOZbN6Cv39+hh+7NNc/cJ0dF1+UQE1gqaCbeHO9GT4u+sOrr9aoJh/Nwo
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:c08e:b0:252:733d:15dc with SMTP id
 o14-20020a17090ac08e00b00252733d15dcmr97816pjs.2.1685722183850; Fri, 02 Jun
 2023 09:09:43 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:10 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-13-vipinsh@google.com>
Subject: [PATCH v2 12/16] KVM: arm64: Retry shared page table walks outside of
 fault handler
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

For a shared page walker which is not fault handler, retry the walk if
walker callback function returns -EAGAIN, or continue to the next SPTE
if callback function return -ENOENT. Update the kvm_pgtable_walk
documentation.

For fault handler logic remains same, i.e. exit the walk and resume the
guest when getting -EAGAIN and -ENOENT errors from walker callback
function.

Currently, there is no page walker which is shared and not a fault
handler, but this will change in future patches when clear-dirty-log
walker will use MMU read lock and run via shared walker.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 23 ++++++++++-------
 arch/arm64/kvm/hyp/pgtable.c         | 38 +++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 23e7e7851f1d..145be12a5fc2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -716,15 +716,20 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * type of the walker, i.e. shared walker (vCPU fault handlers) or non-shared
  * walker.
  *
- * Walker Type  | Callback         | Walker action
- * -------------|------------------|--------------
- * Non-Shared   | 0                | Continue
- * Non-Shared   | -EAGAIN          | Continue
- * Non-Shared   | -ENOENT          | Continue
- * Non-Shared   | Any other        | Exit
- * -------------|------------------|--------------
- * Shared       | 0                | Continue
- * Shared       | Any other        | Exit
+ * Walker Type            | Callback         | Walker action
+ * -----------------------|------------------|--------------
+ * Non-Shared             | 0                | Continue
+ * Non-Shared             | -EAGAIN          | Continue
+ * Non-Shared             | -ENOENT          | Continue
+ * Non-Shared             | Any other        | Exit
+ * -----------------------|------------------|--------------
+ * Shared                 | 0                | Continue
+ * Shared                 | -EAGAIN          | Retry
+ * Shared                 | -ENOENT          | Continue
+ * Shared                 | Any other        | Exit
+ * -----------------------|------------------|--------------
+ * Shared (Fault Handler) | 0                | Continue
+ * Shared (Fault Handler) | Any other        | Exit
  *
  * Return: 0 on success, negative error code on failure.
  */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 7f80e953b502..23cda3de2dd4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -191,15 +191,21 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
 	 * Callbacks can also return ENOENT when PTE which is visited is not
 	 * valid.
 	 *
-	 * In the context of a shared walker interpret these as a signal
+	 * In the context of a fault handler interpret these as a signal
 	 * to retry guest execution.
 	 *
-	 * Ignore these return codes altogether for walkers outside a fault
-	 * handler (e.g. write protecting a range of memory) and chug along
+	 * In the context of a shared walker which is not fault handler
+	 * interpret:
+	 * 1. EAGAIN - A signal to retry walk again.
+	 * 2. ENOENT - A signal to ignore and move on to next SPTE.
+	 *
+	 * Ignore these return codes altogether for other walkers and chug along
 	 * with the page table walk.
 	 */
-	if (r == -EAGAIN || r == -ENOENT)
+	if (r == -EAGAIN)
 		return !(walker->flags & KVM_PGTABLE_WALK_SHARED);
+	if (r == -ENOENT)
+		return !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
 
 	return !r;
 }
@@ -260,24 +266,44 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	return ret;
 }
 
+static bool kvm_pgtable_walk_retry(const struct kvm_pgtable_walker *walker,
+				   int r)
+{
+	/*
+	 * All shared page table walks where visitor callbacks return -EAGAIN
+	 * should be retried with the exception of fault handler. In case of
+	 * fault handler retry is achieved by resuming the guest.
+	 */
+	if (r == -EAGAIN)
+		return (walker->flags & KVM_PGTABLE_WALK_SHARED) &&
+				!(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
+
+	return !r;
+}
+
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level)
 {
 	u32 idx;
 	int ret = 0;
+	kvm_pteref_t pteref;
 
 	if (WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS))
 		return -EINVAL;
 
 	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
-		kvm_pteref_t pteref = &pgtable[idx];
+retry:
+		pteref = &pgtable[idx];
 
 		if (data->addr >= data->end)
 			break;
 
 		ret = __kvm_pgtable_visit(data, mm_ops, pteref, level);
-		if (ret)
+		if (ret) {
+			if (kvm_pgtable_walk_retry(data->walker, ret))
+				goto retry;
 			break;
+		}
 	}
 
 	return ret;
-- 
2.41.0.rc0.172.g3f132b7071-goog

