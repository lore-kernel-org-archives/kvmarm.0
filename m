Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD98BC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82CC04B1F0;
	Wed, 27 Apr 2022 14:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hZSWrSCcMdG2; Wed, 27 Apr 2022 14:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D990A4B229;
	Wed, 27 Apr 2022 14:48:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B06C94B1E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgIgxwbf-rlg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:48:22 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B50D49EBE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:22 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 q91-20020a17090a756400b001d951f4846cso3781961pjk.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cxxvMCNZeVbSnvKA2qdbM4fbtMJ+yHcSGuyT17AD6dQ=;
 b=e4sA4jfm+rWhALZYwHLB6njNTs6Wb97KPoc3OTVuID8F7aBVjW50U7XBOVFUoU1Gun
 UdPeobwkJ9yMzcy2SHfgL5CORXWT9OD9e22D2Ba5J7NXy6npGNvF0oBSjLtTuwpnryX/
 qR3usaPkOPnE9ugKYDIAVowYZeWQbIqzr6FeHCFozOR2lfizFaTBpcE0HfM4ZJwFLCK7
 hfU5TYpxx0gzAowKUAq5zss86Xzv9dwVoCtRlhHUn9a0JOaP7uG/5Ld8RXtqVuAtYAXJ
 gX/kvFPAaJ2YrWmxFQRNSjpyKIZqQvSnN9pTd617t7vDjlOwElhZWmiaylmLsAKyu1Mi
 HIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cxxvMCNZeVbSnvKA2qdbM4fbtMJ+yHcSGuyT17AD6dQ=;
 b=2OLXwH67yiad1EHWEAPaTsOCu8uXw5xIXksiKINK/7HCPgO05q5JsK5+jTRhubJlUx
 f0LYV48b54TyCuNzCevSdX6SwVkEgoEHtpCZmipABEyia7FeuARsBFWuFvUchQHMbEQd
 3Jx/pBwqw3u3tiy79Y8zW42ojR9M+2XKkhzFbnVWhE0yjE7gYysZYtikailN03wbD9XU
 HLh64u1zPo/dro7AyvBoOFtXPaduHuHovFGa4F8e39kryx+Fz7eOq7FCmKGz0KqdD/oW
 qek1ngxkHFylGLMo6wk24R+wUdavzMH2zxKOBaD7z5RCjHGCTFiMyLVU3E8SC8Wtgrqc
 zwKQ==
X-Gm-Message-State: AOAM531mznbbKk3fAspbOjHYvM+rOM2zAM/O13QvJUhAZ18NKDMYeVw+
 9AwN+JrCvNI6698lJDLo/RQN+Tzi3Dr+rQ==
X-Google-Smtp-Source: ABdhPJyknPlo5DBIr5KBuqPWpNATajXUqy1RAWRHznIjdBuSCbRAzwcaMXDVvDKPr6EbhIw5bJiJDDG9lmFPCQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:2285:b0:15b:cd9e:f018 with SMTP
 id b5-20020a170903228500b0015bcd9ef018mr28691242plh.106.1651085301614; Wed,
 27 Apr 2022 11:48:21 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:48:13 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte
 failures
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
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

Restoring a corrupted collection entry is being ignored and treated as
success. More specifically, vgic_its_restore_cte failure is treated as
success by vgic_its_restore_collection_table.  vgic_its_restore_cte uses
a positive number to return ITS error codes, and +1 to return success.
The caller then uses "ret > 0" to check for success. An additional issue
is that invalid entries return 0 and although that doesn't fail the
restore, it leads to skipping all the next entries.

Fix this by having vgic_its_restore_cte return negative numbers on
error, and 0 on success (which includes skipping an invalid entry).
While doing that, also fix alloc_collection return codes to not mix ITS
error codes (positive numbers) and generic error codes (negative
numbers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb2d26a73880..86c26aaa8275 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
 	return __is_visible_gfn_locked(its, gpa);
 }
 
+/*
+ * Adds a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1101,7 +1102,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		int ret;
+
+		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+			return E_ITS_MAPC_COLLECTION_OOR;
+
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
 		if (ret)
 			return ret;
 		new_coll = collection;
@@ -1256,6 +1262,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2497,6 +2507,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restores a collection entry into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2511,7 +2525,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 		return ret;
 	val = le64_to_cpu(val);
 	if (!(val & KVM_ITS_CTE_VALID_MASK))
-		return 0;
+		return 0; /* invalid entry, skip it */
 
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
@@ -2523,11 +2537,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	collection = find_collection(its, coll_id);
 	if (collection)
 		return -EEXIST;
+
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+		return -EINVAL;
+
 	ret = vgic_its_alloc_collection(its, &collection, coll_id);
 	if (ret)
 		return ret;
 	collection->target_addr = target_addr;
-	return 1;
+	return 0;
 }
 
 /**
@@ -2593,15 +2611,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 
 	while (read < max_size) {
 		ret = vgic_its_restore_cte(its, gpa, cte_esz);
-		if (ret <= 0)
+		if (ret < 0)
 			break;
 		gpa += cte_esz;
 		read += cte_esz;
 	}
 
-	if (ret > 0)
-		return 0;
-
 	return ret;
 }
 
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
