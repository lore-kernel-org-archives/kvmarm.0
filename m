Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539FA34FF78
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 02:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788402905; cv=none; b=iiHdkmEyw50J4pVUKO+FltAAvyoSX1sCQVNPsCqiyH02rEEiGQnF/KVsfdDuX45akjA0y+MVNqJdXeOiLRxIK9wMPTyzRVArqjetWHBWs1mNnyAzX6at3BkWuBwoT0mJjcuTgz99KhTXKivQcSTD5l+3suuYVOgYKL8F0+dtN9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788402905; c=relaxed/simple;
	bh=KkllZ0CXRBgyZYgnbfWvEuICZuPWHeEgnlWGgS0PT3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tpmFWoww08V1CNj5Ne5+b8bLKBnAih1V7x5do6sqNdLC5TmmC5XBEsSdQQoKSmGT+sI+WP+mu2Xvh1xvHW08qXLfoEGssRKng5SgnGGw81C7Bi0bJ4yt1LtNlEen33K0bugFdYi8J0nnE9RTTmiFfrHSgMykRtceybaVLE1P8Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--loganodell.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TS4aD6zd; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--loganodell.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TS4aD6zd"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso2720077a91.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 19:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402899; x=1789007699; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3jZRbPTlJQ2oU3N5reiU/R1oleIxZE7zMycKAHKHmwY=;
        b=TS4aD6zdwxEN/eCiiXWKbuo3v1HQ7BAba2lIu1u6lgxD57I+nU90+a71xO54WBCqqG
         bR0TjVGfDRNYmP0kJzHSvLoqydkjemOrn9lwcrrl2kgnQihSmy0sokwKhKa/xuUFVNeM
         xxOzWDw2l+G51kpOoyof5MkYe/zhMQR43ojJVH/OuM+erfEuvKZDSrZqN/kz3+I/QYnQ
         gYM6YkuWHmk5g17CpCIIyXTfDGJT0oWnAgdtZsX79mLoGte66J5RhA6QPbdM22AxL8pl
         FCbye5bbxRAoDmnEX7BQofmqp6vWnQwgO39qK5OZP2WWNJZml5TZdv0zNu6Mvp52buls
         OO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402899; x=1789007699;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3jZRbPTlJQ2oU3N5reiU/R1oleIxZE7zMycKAHKHmwY=;
        b=ZphFsLs2tgeLze+8I9VhqRmoQaPA8jnyyVG4vFhDa7MMz2/ATTRCZFJ/mDpVsGdhV7
         U3OL7v5sRI1ugovYp0pFki7GnsAxjAEuO0YH1bSXYOWrn4sI92SfLDq38AYdwD1zgutp
         xBbaMs6QfbK5ksLc83Y6csquN1R4qg0oeOjgcKBwCV9UWhR5NGhymHscO2MRwN64ViMy
         iaXfRmDxEXUAwAkv/yrS2tB9kZ9Gqbf0FZweNyc7POgbbBqXyoF5PumqyfjK31mkGmRO
         30dIlYfF1WsOnljN6TydJUgP/dqBNxNcQPcyXRfzzudjmCdLfz70qsbJibrS4CXlHcMe
         AFyg==
X-Forwarded-Encrypted: i=1; AKwUvBxabIde3Q5t1LuczhqiwUBt4u7rDUk3F0Q7eVN142lthrpjMbX1jwvosbMPRBrxfckwQDEynic=@lists.linux.dev
X-Gm-Message-State: AFuF++meOk1bKjR7VPHij+BZSVwI7WYVpA8xcFdmnyOFnV8UTUfUXvG5
	L+DXrfR+T7OAENFXW34hEdy8P2rcn6uRddB9GvLU3zbcK4Ltcf05uOcCfDFRJtIohgMyAXLLgAs
	wCChKNGhY0CWy5qSrbtrr1w==
X-Received: from dyboc22.prod.google.com ([2002:a05:7301:3f16:b0:32b:1306:42ad])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:288a:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-39aee0848bbmr14352175a91.14.1788402898410;
 Wed, 02 Sep 2026 19:34:58 -0700 (PDT)
Date: Wed,  2 Sep 2026 19:34:52 -0700
In-Reply-To: <20260903023452.721732-1-loganodell@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903023452.721732-4-loganodell@google.com>
Subject: [RFC PATCH 3/3] luo: memfd: Move to feature flags instead of
 compatibility strings
From: Logan Odell <loganodell@google.com>
To: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"

Update struct memfd_luo_ser to embed struct luo_feature_hdr features.
Define feature flags for memfd (MEMFD_LUO_FEATURE_SEALS and
MEMFD_LUO_FEATURE_FOLIOS), emit the liveupdate feature entry for memfd,
and validate required features and active flags during deserialization.
Also replace the version bump requirement for seals with
MEMFD_LUO_BASE_SEALS to allow new seals to be introduced granularly as
feature bits.

Signed-off-by: Logan Odell <loganodell@google.com>
---
 include/linux/kho/abi/luo.h   |  8 +++---
 include/linux/kho/abi/memfd.h | 41 ++++++++++++++++++++----------
 include/linux/liveupdate.h    | 10 ++++----
 kernel/liveupdate/luo_file.c  | 28 ++++++++++-----------
 kernel/liveupdate/luo_flb.c   |  2 +-
 lib/tests/liveupdate.c        |  2 +-
 mm/memfd_luo.c                | 47 +++++++++++++++++++++++++----------
 7 files changed, 87 insertions(+), 51 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 5b25e1b48cf5..450a0e40e2ab 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -132,18 +132,18 @@ struct luo_ser {
 	u64 flbs_pa;
 } __packed;
 
-#define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
+#define LIVEUPDATE_HNDL_NAME_LENGTH	48
 
 /**
  * struct luo_file_ser - Represents the serialized preserves files.
- * @compatible:  File handler compatible string.
+ * @name:        File handler name.
  * @data:        Private data
  * @token:       User provided token for this file
  *
  * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_file_ser {
-	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	char name[LIVEUPDATE_HNDL_NAME_LENGTH];
 	u64 data;
 	u64 token;
 } __packed;
@@ -256,7 +256,7 @@ struct liveupdate_ver_hdr {
  * @active:     Bitmask of active features.
  */
 struct liveupdate_feature_entry {
-	char name[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	char name[LIVEUPDATE_HNDL_NAME_LENGTH];
 	u32 feat_bytes;
 	u32 reserved;
 	u64 supp;
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..9961df5be423 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_KHO_ABI_MEMFD_H
 #define _LINUX_KHO_ABI_MEMFD_H
 
+#include <linux/bits.h>
+#include <linux/kho/abi/luo.h>
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
 
@@ -23,11 +25,20 @@
  * The state is serialized into a packed structure `struct memfd_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
- * constitutes a breaking change. Such changes require incrementing the
- * version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ * This interface is a contract. Any changes should be additive using feature
+ * flags to ensure backwards compatibility.
  */
 
+#define MEMFD_LUO_FEATURE_SEALS		BIT_ULL(0)
+#define MEMFD_LUO_FEATURE_FOLIOS	BIT_ULL(1)
+
+#define MEMFD_LUO_FEATURES_SUPP		(MEMFD_LUO_FEATURE_SEALS | \
+					 MEMFD_LUO_FEATURE_FOLIOS)
+#define MEMFD_LUO_FEATURES_REQ		(MEMFD_LUO_FEATURE_SEALS | \
+					 MEMFD_LUO_FEATURE_FOLIOS)
+#define MEMFD_LUO_FEATURES_ACTIVE	(MEMFD_LUO_FEATURE_SEALS | \
+					 MEMFD_LUO_FEATURE_FOLIOS)
+
 /**
  * MEMFD_LUO_FOLIO_DIRTY - The folio is dirty.
  *
@@ -57,18 +68,21 @@ struct memfd_luo_folio_ser {
 } __packed;
 
 /*
- * The set of seals this version supports preserving. If support for any new
- * seals is needed, add it here and bump version.
+ * The set of base seals supported by MEMFD_LUO_FEATURE_SEALS.
+ * If support for new seals is needed, define a dedicated feature bit
+ * (e.g. MEMFD_LUO_FEATURE_SEAL_<NAME>) to allow granular compatibility.
  */
-#define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
-			     F_SEAL_SHRINK | \
-			     F_SEAL_GROW | \
-			     F_SEAL_WRITE | \
-			     F_SEAL_FUTURE_WRITE | \
-			     F_SEAL_EXEC)
+#define MEMFD_LUO_BASE_SEALS	(F_SEAL_SEAL | \
+				 F_SEAL_SHRINK | \
+				 F_SEAL_GROW | \
+				 F_SEAL_WRITE | \
+				 F_SEAL_FUTURE_WRITE | \
+				 F_SEAL_EXEC)
+#define MEMFD_LUO_ALL_SEALS	MEMFD_LUO_BASE_SEALS
 
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * @features:  Bit mask of supported, required, and active features.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
@@ -79,6 +93,7 @@ struct memfd_luo_folio_ser {
  *             struct memfd_luo_folio_ser.
  */
 struct memfd_luo_ser {
+	struct luo_feature_hdr features;
 	u64 pos;
 	u64 size;
 	u32 seals;
@@ -87,7 +102,7 @@ struct memfd_luo_ser {
 	struct kho_vmalloc folios;
 } __packed;
 
-/* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+/* The name for memfd file handler */
+#define MEMFD_LUO_FH_NAME	"memfd"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index e058df23fed1..4489e344f76f 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -90,10 +90,10 @@ struct liveupdate_file_ops {
 /**
  * struct liveupdate_file_handler - Represents a handler for a live-updatable file type.
  * @ops:                Callback functions
- * @compatible:         The compatibility string (e.g., "memfd-v1", "vfiofd-v1")
- *                      that uniquely identifies the file type this handler
- *                      supports. This is matched against the compatible string
- *                      associated with individual &struct file instances.
+ * @name:               The name (e.g., "memfd", "vfiofd") that uniquely
+ *                      identifies the file type this handler supports. This
+ *                      is matched against the name associated with individual
+ *                      &struct file instances.
  *
  * Modules that want to support live update for specific file types should
  * register an instance of this structure. LUO uses this registration to
@@ -102,7 +102,7 @@ struct liveupdate_file_ops {
  */
 struct liveupdate_file_handler {
 	const struct liveupdate_file_ops *ops;
-	const char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	const char name[LIVEUPDATE_HNDL_NAME_LENGTH];
 
 	/* private: */
 
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index dbae0715220b..775484af0750 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -480,13 +480,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		err = luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
-				luo_file->token, luo_file->fh->compatible,
+				luo_file->token, luo_file->fh->name,
 				ERR_PTR(err));
 			goto err_unfreeze;
 		}
 
-		strscpy(file_ser->compatible, luo_file->fh->compatible,
-			sizeof(file_ser->compatible));
+		strscpy(file_ser->name, luo_file->fh->name,
+			sizeof(file_ser->name));
 		file_ser->data = luo_file->serialized_data;
 		file_ser->token = luo_file->token;
 	}
@@ -732,7 +732,7 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
 
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-		if (!strcmp(fh->compatible, ser->compatible)) {
+		if (!strcmp(fh->name, ser->name)) {
 			if (try_module_get(fh->ops->owner))
 				handler_found = true;
 			break;
@@ -741,9 +741,9 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
 	up_read(&luo_register_rwlock);
 
 	if (!handler_found) {
-		pr_warn("No registered handler for compatible '%.*s'\n",
-			(int)sizeof(ser->compatible),
-			ser->compatible);
+		pr_warn("No registered handler for name '%.*s'\n",
+			(int)sizeof(ser->name),
+			ser->name);
 		return -ENOENT;
 	}
 
@@ -774,9 +774,9 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
  * in-memory linked list of 'struct luo_file' instances.
  *
  * For each serialized entry, it performs the following steps:
- *   1. Reads the 'compatible' string.
+ *   1. Reads the 'name' string.
  *   2. Searches the global list of registered file handlers for one that
- *      matches the compatible string.
+ *      matches the name.
  *   3. Allocates a new 'struct luo_file'.
  *   4. Populates the new structure with the deserialized data (token, private
  *      data handle) and links it to the found handler. The 'file' pointer is
@@ -870,7 +870,7 @@ void luo_file_set_destroy(struct luo_file_set *file_set)
  * liveupdate_register_file_handler - Register a file handler with LUO.
  * @fh: Pointer to a caller-allocated &struct liveupdate_file_handler.
  * The caller must initialize this structure, including a unique
- * 'compatible' string and a valid 'fh' callbacks. This function adds the
+ * 'name' string and valid 'fh' callbacks. This function adds the
  * handler to the global list of supported file handlers.
  *
  * Context: Typically called during module initialization for file types that
@@ -893,11 +893,11 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	}
 
 	down_write(&luo_register_rwlock);
-	/* Check for duplicate compatible strings */
+	/* Check for duplicate handler names */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
-		if (!strcmp(fh_iter->compatible, fh->compatible)) {
-			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
-			       fh->compatible);
+		if (!strcmp(fh_iter->name, fh->name)) {
+			pr_err("File handler registration failed: Handler name '%s' already registered.\n",
+			       fh->name);
 			err = -EEXIST;
 			goto err_unlock;
 		}
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cd715a7c1d99..cb8c15f181e0 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -337,7 +337,7 @@ static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
 
 	if (!found) {
 		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
-			flb->compatible, fh->compatible);
+			flb->compatible, fh->name);
 		return;
 	}
 
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 4c08a7c6fb78..d3a8573a648e 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -135,7 +135,7 @@ void liveupdate_test_register(struct liveupdate_file_handler *fh)
 	}
 
 	pr_info("Registered %d FLBs with file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
+		TEST_NFLBS, fh->name);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..36ee503672a2 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -52,8 +52,8 @@
  *
  * Seals
  *   File seals set on the memfd are preserved and re-applied on restore.
- *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
- *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
+ *   Only base seals supported by this LUO version (see ``MEMFD_LUO_BASE_SEALS``)
+ *   may be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
  *
  * Non-Preserved Properties
  * ========================
@@ -273,6 +273,10 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_unlock;
 	}
 
+	ser->features.supp = MEMFD_LUO_FEATURES_SUPP;
+	ser->features.req = MEMFD_LUO_FEATURES_REQ;
+	ser->features.active = MEMFD_LUO_FEATURES_ACTIVE;
+
 	seals = memfd_get_seals(args->file);
 	if (seals < 0) {
 		err = seals;
@@ -352,8 +356,9 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 
-	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
-				    ser->nr_folios);
+	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_FOLIOS) && ser->nr_folios)
+		memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
+					    ser->nr_folios);
 
 	kho_unpreserve_free(ser);
 	inode_unlock(inode);
@@ -401,7 +406,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return;
 
-	if (ser->nr_folios) {
+	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_FOLIOS) && ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
 			goto out;
@@ -526,12 +531,21 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
-	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+	if (ser->features.req & ~MEMFD_LUO_FEATURES_SUPP) {
+		pr_err("Unsupported required memfd feature (req: 0x%llx, supp: 0x%llx)\n",
+		       ser->features.req, (u64)MEMFD_LUO_FEATURES_SUPP);
 		err = -EOPNOTSUPP;
 		goto free_ser;
 	}
 
+	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_SEALS)) {
+		/* Make sure the file only has seals supported by this version. */
+		if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+			err = -EOPNOTSUPP;
+			goto free_ser;
+		}
+	}
+
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
 	 * later.
@@ -543,16 +557,18 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 		goto free_ser;
 	}
 
-	err = memfd_add_seals(file, ser->seals);
-	if (err) {
-		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
-		goto put_file;
+	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_SEALS)) {
+		err = memfd_add_seals(file, ser->seals);
+		if (err) {
+			pr_err("failed to add seals: %pe\n", ERR_PTR(err));
+			goto put_file;
+		}
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
-	if (ser->nr_folios) {
+	if (LUO_FEATURE_IS_ACTIVE(ser, MEMFD_LUO_FEATURE_FOLIOS) && ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
 			err = -EINVAL;
@@ -601,9 +617,14 @@ static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.owner = THIS_MODULE,
 };
 
+LIVEUPDATE_FEATURE_ENTRY(memfd_luo, MEMFD_LUO_FH_NAME,
+			 MEMFD_LUO_FEATURES_SUPP,
+			 MEMFD_LUO_FEATURES_REQ,
+			 MEMFD_LUO_FEATURES_ACTIVE);
+
 static struct liveupdate_file_handler memfd_luo_handler = {
 	.ops = &memfd_luo_file_ops,
-	.compatible = MEMFD_LUO_FH_COMPATIBLE,
+	.name = MEMFD_LUO_FH_NAME,
 };
 
 static int __init memfd_luo_init(void)
-- 
2.55.0.979.g7e5102b832-goog

