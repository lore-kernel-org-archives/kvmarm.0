Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792596336;
	b=s8k2w3USzsMPu8jPHwAjqs6F6vUs3PJZZd6PMlP0sWvSpEqBDsKmRKzxUSPby+VOJIgw
	 kCYW99FCKqE0Xk4Vx+KJm+50JTte1dm1m1eS/tD8ckIvIjf0z2Zg+qFAql1zwhmwcnvlC
	 yQBcWh3/AMO5YbmcR2RxdQS9rTzp/iTKxOQqjOyG5YaSbmFJnOhn6KFButUNeNrwwm+4V
	 G/we8fGnMjWiJ17XpNSK3pYx4c+4Qy21G+s3G3hqI2gWFtyrUIXbP2q0CxFy+/gblKDq2
	 5RW6qoDP56YmofGN56a4GTgf4IjvMnJP6uMBlDvubsEBVrePa/CAtt220G7myXA+s3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
	b=cmka/0Tx9gMHUERmxsN+TOuz3SQuRf3h2SMCyYnS/nSXS9Wi+RI92pulwTqM/hyt3Ehv
	 W6X2q11XvABx1QfVEqfOmJz8eGPNpfPW1ZasnHPp5xafDeara4HT0WjiwqMIKVwHyFg3i
	 Nk3fAZEI63IIl1C6dFNg+2IN31uxedocMkhqHrA0aLEJ2/Uu89IpdkX+v1sZj/Dx6yN9g
	 X3A8ysEBT5wdiAUjq84dRYQNeePAnNYH7nKws12BP270dVM5bLR+C4Bg/GvkNTQ/CuDsQ
	 vPx5onssQkma4l/cLG6zTEyGRBL/sPWEZKN7AXU+Hq/JsOYF9lOMpCE58OH7F1+OeKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iO8NDuIw;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF5B60A2634
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 15:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BF5B60A2634
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iO8NDuIw
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c41f85ee4a3so74564966b.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 08:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792596334; x=1793201134; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
        b=iO8NDuIwLJuvXU/uqOq6FY3rSZNDK+ekeNytAYT3SOUcIQIl0ya+8KySv+uR8eAF0T
         TIfo40b1tGSS7JPBDizbsfp2OK4d5EstQMv/hdyYdgcdfq09jNyzoN+Hdqbj6sqEIPpZ
         WERqN1TT5F/nW6lval3JKXN05UhJ4dMMsTc11GV2jv+aFxpRYvl1SSjVFcSXCePFUl/Q
         UqEayD0mqx8A1Th5JOiWVWVrSFRkl9Ra/7coW2MBYUkDOZSKPn4Wu7I6aLG9rk3I6J30
         Ya+aUu6C1XeEgQqFV3+2dayZU2zwojeagTy4WxInOFiedgAy2xKygpGdRq7JxAmGPTEK
         DqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596334; x=1793201134;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
        b=ipjy12ZfST2b/aKUK8SeTjmOFLEKFg4FxGfND9JaxJFx/6kdHS9Fxf8X1C8njdOuNY
         0l9ew/iz4ghYkkQVPx+kKUi1RHirKE84Z/uJaJxkd7R1GrP+SHy3ALUntJQJdGVdnl17
         vMgqhe7Ee4Y42flj3y7Z8Lwq1/sPYe8hwIwUIehc9tjnXtM73Z5v7TWYYLgE0HgSn6zk
         RiFCVartIBT+mE7Xi6eib6mnG2wDveOIVIAiJhDCye/0mGPX714vCmhGxnzM+DufIgg7
         MzjopqSYhRQxKu8KYW5IQW321521JoBdijHUriR32HuAEmc7d6QfPaLtMBj5qkWAMTKA
         jVPA==
X-Forwarded-Encrypted: i=1; AKwUvBwkJHwNzZXGKob9+4qnqKRCMTmGl6HcOMX9MA2wyH3YdsiS+qCGa1J416xZbibERpXR6TNRyh4=@lists.linux.dev
X-Gm-Message-State: AFq9FYJmhi175On68QN3ZvOs3pUpoMqUtjv+wZskiok8zK55taccAfdi
	i0NnATQ4QzkNOQ592yEyupgdXcwOVQuPbbXCOfg7579X4gu1Em/AOuxSyBJcEIvMciySxDzg2y0
	XHTeSz6OXDXTkzxGBfQ==
X-Received: from ejeck13-n2.prod.google.com ([2002:a17:907:e1cd:20b0:c2e:8317:2af9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c64b:10b0:c46:7fa4:922b with SMTP id a640c23a62f3a-c467fa4a587mr117629166b.33.1792596333890;
 Wed, 21 Oct 2026 08:25:33 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:25:27 +0000
In-Reply-To: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021152527.375070-5-tarunsahu@google.com>
Subject: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

Embed the fixed-size 128-byte struct luo_feature_hdr at the start of
struct memfd_luo_ser and define enum memfd_luo_feature
(MEMFD_LUO_FEAT_CORE and MEMFD_LUO_FEAT_MAX) for memfd preservation.

All current struct memfd_luo_ser fields (pos, size, seals, flags,
nr_folios, folios) and MEMFD_LUO_ALL_SEALS belong to
MEMFD_LUO_FEAT_CORE (LUO_FEAT_REQUIRED in memfd_luo_features). Future
changes add new entries to enum memfd_luo_feature before
MEMFD_LUO_FEAT_MAX and append any new fields to the end of struct
memfd_luo_ser so existing field offsets never shift.

Signed-off-by: Logan Odell <loganodell@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/memfd.h | 35 ++++++++++++++++++++++++++++++-----
 mm/memfd_luo.c                | 14 ++++++++++++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 371ffd108a79..f0b5235a408d 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
 
 /**
  * DOC: memfd Live Update ABI
@@ -21,11 +22,20 @@
  * reboot using the LUO.
  *
  * The state is serialized into a packed structure `struct memfd_luo_ser`
- * which is handed over to the next kernel via the KHO mechanism.
+ * which is handed over to the target kernel via the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
- * constitutes a breaking change. Such changes require incrementing the
- * version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ * This interface is a contract. `struct memfd_luo_ser` starts with a fixed
+ * 128-byte `struct luo_feature_hdr`. The relative order and offsets of
+ * fields must remain unchanged as features are added or retired: new fields
+ * are appended at the end of `struct memfd_luo_ser` under a new feature
+ * flag in `enum memfd_luo_feature` (before `MEMFD_LUO_FEAT_MAX`), and
+ * retired fields are kept in place so subsequent offsets never shift. In
+ * the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are guaranteed
+ * present once `luo_feature_hdr_validate()` succeeds, whereas fields of a
+ * `LUO_FEAT_OPTIONAL` feature should be accessed only after checking
+ * `luo_feature_is_active()`. All current fields (`pos`, `size`, `seals`,
+ * `flags`, `nr_folios`, `folios`) and `MEMFD_LUO_ALL_SEALS` belong to
+ * `MEMFD_LUO_FEAT_CORE` (`LUO_FEAT_REQUIRED` in `memfd_luo_features`).
  */
 
 /**
@@ -58,7 +68,7 @@ struct memfd_luo_folio_ser {
 
 /*
  * The set of seals this version supports preserving. If support for any new
- * seals is needed, add it here and bump version.
+ * seals is needed, gate them behind a new feature flag.
  */
 #define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
 			     F_SEAL_SHRINK | \
@@ -67,8 +77,22 @@ struct memfd_luo_folio_ser {
 			     F_SEAL_FUTURE_WRITE | \
 			     F_SEAL_EXEC)
 
+/**
+ * enum memfd_luo_feature - Feature indices for &struct memfd_luo_ser.
+ * @MEMFD_LUO_FEAT_CORE: Core feature covering `pos`, `size`, `seals`, `flags`,
+ *                       `nr_folios`, `folios`, and %MEMFD_LUO_ALL_SEALS.
+ * @MEMFD_LUO_FEAT_MAX:  Number of defined &enum memfd_luo_feature features.
+ */
+enum memfd_luo_feature {
+	MEMFD_LUO_FEAT_CORE = 0,
+	MEMFD_LUO_FEAT_MAX,
+};
+
+static_assert((int)MEMFD_LUO_FEAT_MAX <= LUO_FEAT_MAX);
+
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * @features:  ABI feature and size header for memfd_luo_ser.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
@@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
  *             struct memfd_luo_folio_ser.
  */
 struct memfd_luo_ser {
+	struct luo_feature_hdr features;
 	u64 pos;
 	u64 size;
 	u32 seals;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 64f8b8cb75bd..ea1f4c8cd259 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -84,6 +84,10 @@
 
 #include "internal.h"
 
+static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] = {
+	[MEMFD_LUO_FEAT_CORE] = LUO_FEAT_REQUIRED,
+};
+
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
 				     struct memfd_luo_folio_ser **out_folios_ser,
@@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_free_ser;
 	}
 
+	luo_feature_hdr_init(&ser->features, sizeof(*ser),
+			     memfd_luo_features);
 	ser->pos = args->file->f_pos;
 	inode_size = i_size_read(inode);
 
@@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	err = luo_feature_hdr_validate(&ser->features, memfd_luo_features);
+	if (err) {
+		pr_err("memfd_luo_ser feature header validation failed (size=%llu, flags[0]=%#llx): %pe\n",
+		       ser->features.size, ser->features.flags[0],
+		       ERR_PTR(err));
+		goto free_ser;
+	}
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-- 
2.56.0.212.g129ede20d9-goog

