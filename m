Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85D0332E1
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 17:02:54 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7603d830533so81079239f.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 10:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685725374; x=1688317374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=46U2EWEjxn55kWeKsj3lDgLNoam846hFcVZO+vAwdLA=;
        b=WAqGXaWPraSA2daImKoen5B6tdZ+WYHgTjxhUUeeZAsbrniK5QsoJdy6bnYalQom0q
         MTUHUxan0x428dbLSXOSDczGl+sVACZNDReIhyFVk8qGv8O19J818JqDUV+L39pYvd+O
         +D0peOAv5LwnSHuhbBKS4on+Spl3k1vhxR2tQ3f+hr+YwUTyNz098zCnNqlglZ99wmXF
         03RZCAfLMqzIZPxHZwDc+9cJzrwA0lt7idYGl5Mr8XHmSaECCNan2CtJJnr3I5Ts2P2r
         magwgDPHCmtfLDNKqCKxBMgHtvBcTUMA++iZxC/lrSlB4KiCVknekWOPC0oT6ZjtI3V8
         dGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725374; x=1688317374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46U2EWEjxn55kWeKsj3lDgLNoam846hFcVZO+vAwdLA=;
        b=GKS1tDUxxsMnd3JXdruqkSHF1vk2ObHHfG+JGn2G7tkdkwdVjwVwJo+lQRVr6qcXfK
         t/+/j4tZwqwnaAOv/OvaP/2oDyGGPSjWPxgCdhDdnOQTa9P+3RjZoiim2QMMWVHF31Xr
         i122p3cTVTufImXcJMljZ8nkxYpGvL56wvXLnh/9eG0aBiGR2EakSmtlQY0O66sahFFJ
         sd5bAN7YVdTi0uxr1emRsKnVQIUQrXXPR0qFH83OGQf3Nbn7VU9MDjZXnt+lWS98JOaw
         qd5/4+PSrc1evf59WoYsvRMuZqdgot1cFtW7bKLZkBU7eqsnAbC4HBJVRtWAV5BhCCqs
         qVvw==
X-Gm-Message-State: AC+VfDyv0Zfa+JXaGMviqXrmGgbofkTMVUzYhwHT+EjXZNoUdYL/wk9S
	F71xkcAEOuTNfioCbYwoC6R2QkLAkQRWnnOOiQ==
X-Google-Smtp-Source: ACHHUZ4geDJMOIvtQH6zUtgqB8OHUq2dHYHBZAw17LyumZCyIixhJcFdC+UZZW8jvomo19VQYFFEQblUZyGsWdbTIA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1503:b0:777:2367:a7d3 with
 SMTP id g3-20020a056602150300b007772367a7d3mr1813249iow.0.1685725373854; Fri,
 02 Jun 2023 10:02:53 -0700 (PDT)
Date: Fri,  2 Jun 2023 17:01:47 +0000
In-Reply-To: <20230602170147.1541355-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602170147.1541355-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602170147.1541355-4-coltonlewis@google.com>
Subject: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM level 2
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip the break phase of break-before-make when the CPU has FEAT_BBM
level 2. This allows skipping some expensive invalidation and
serialization and should result in significant performance
improvements when changing block size.

The ARM manual section D5.10.1 specifically states under heading
"Support levels for changing block size" that FEAT_BBM Level 2 support
means changing block size does not break coherency, ordering
guarantees, or uniprocessor semantics.

Because a compare-and-exchange operation was used in the break phase
to serialize access to the PTE, an analogous compare-and-exchange is
introduced in the make phase to ensure serialization remains even if
the break phase is skipped and proper handling is introduced to
account for this function now having a way to fail.

Considering the possibility that the new pte has different permissions
than the old pte, the minimum necessary tlb invalidations are used.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 58 +++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8acab89080af9..6778e3df697f7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -643,6 +643,11 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
 	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
 }

+static bool stage2_has_bbm_level2(void)
+{
+	return cpus_have_const_cap(ARM64_HAS_STAGE2_BBM2);
+}
+
 #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))

 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
@@ -730,7 +735,7 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
  * @ctx: context of the visited pte.
  * @mmu: stage-2 mmu
  *
- * Returns: true if the pte was successfully broken.
+ * Returns: true if the pte was successfully broken or there is no need.
  *
  * If the removed pte was valid, performs the necessary serialization and TLB
  * invalidation for the old value. For counted ptes, drops the reference count
@@ -750,6 +755,10 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		return false;
 	}

+	/* There is no need to break the pte. */
+	if (stage2_has_bbm_level2())
+		return true;
+
 	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
 		return false;

@@ -771,16 +780,45 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	return true;
 }

-static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+static bool stage2_pte_perms_equal(kvm_pte_t p1, kvm_pte_t p2)
+{
+	u64 perms1 = p1 & KVM_PGTABLE_PROT_RWX;
+	u64 perms2 = p2 & KVM_PGTABLE_PROT_RWX;
+
+	return perms1 == perms2;
+}
+
+/**
+ * stage2_try_make_pte() - Attempts to install a new pte.
+ *
+ * @ctx: context of the visited pte.
+ * @new: new pte to install
+ *
+ * Returns: true if the pte was successfully installed
+ *
+ * If the old pte had different permissions, perform appropriate TLB
+ * invalidation for the old value. For counted ptes, drops the
+ * reference count on the containing table page.
+ */
+static bool stage2_try_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu, kvm_pte_t new)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;

-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+	if (!stage2_has_bbm_level2())
+		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+
+	if (!stage2_try_set_pte(ctx, new))
+		return false;
+
+	if (kvm_pte_table(ctx->old, ctx->level))
+		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+	else if (kvm_pte_valid(ctx->old) && !stage2_pte_perms_equal(ctx->old, new))
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, mmu, ctx->addr, ctx->level);

 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);

-	smp_store_release(ctx->ptep, new);
+	return true;
 }

 static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
@@ -879,7 +917,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);

-	stage2_make_pte(ctx, new);
+	if (!stage2_try_make_pte(ctx, data->mmu, new))
+		return -EAGAIN;

 	return 0;
 }
@@ -934,7 +973,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	 * will be mapped lazily.
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+
+	if (!stage2_try_make_pte(ctx, data->mmu, new))
+		return -EAGAIN;

 	return 0;
 }
@@ -1385,7 +1426,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * writes the PTE using smp_store_release().
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+
+	if (!stage2_try_make_pte(ctx, mmu, new))
+		return -EAGAIN;
+
 	dsb(ishst);
 	return 0;
 }
--
2.41.0.rc0.172.g3f132b7071-goog
