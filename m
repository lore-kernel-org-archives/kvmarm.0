Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286930;
	b=K23wdKMkQzHpYAvLOLVWxsgl9I3GWAMi+KIKmt+oRDf5E0a4aCbI2xcfmCMc5yOuIPOT
	 nDaxsnNz1XE9DExP/oOdI05HcZlYFwlPBRrbhweos8szbmpTanYkFXNPX910JlgJXe5as
	 IoG2ZZmAU/LoOiKPzt2KOqXGhF7+OqN9gba4Dv74JAfMerReyOOtvt1loDMdEUjo7bqPa
	 Yk0ipIdzEDnT8wQcAMPiCrNx71SS2d17rS2ZX7AFodM7wBrnu9rdmCe3jxr0qfRRhluUh
	 pONm8/3DxCe8pjE7uiWtvtl3GPFPNmCZwNiK//fM9/aJaQKHSOROz8jBebHdHaPyR+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286930;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
	b=jMctKqH6bp87Amk2/VJJjp9kyLIIYwg9O+01qHI3KAclLoTF14eb7gOMElCCvHlTBCS1
	 gFq5efh9y2l7Njpzo8XyuI+NyehiIGWZrs3ZAh9aP3z8PTnV0NiBgAqbPfqunssCof2s1
	 ClQ5mFwYDSVqwyX+F0Mz+/r4TUX6mPzoYAyOawrFmSVeFgKEeHbyPQXBNa2SbqYkAJ8AZ
	 i8HlYphOtUmbtAe1hHZJSkf8BRJt6O68fcmg15wCmUxobCmQ3u/W3efy+iFPadlnAMz03
	 +XI+85YFKVV1jTV7IG2Q2KMs2BJABu9V6Di9hOCjBxDEJ8jC159xDuHGIs/BmAU3Vww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Aze0dxpG;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D3606A330
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A13D3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Aze0dxpG
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4322d31021so170411166b.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286927; x=1794891727; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
        b=Aze0dxpGpH15AqeNNmvwdMrrDF4LByy2GlK4dKKb5lUwWeKsKEJi4JisE0anJ/DIkT
         F+7RRmKn5ffgB9EYeoJRVd9AQ9gyODq55/eiYjKHiBivGESeyW0i5ORDzMeOoOpi6hTL
         GpN2B3Ovv63dz8/++PgtKfddHXZHldZzK8AUVaB4htDayjoTTBz9e9wHlALkRmndeNH6
         4OxeRzI2T9c4CKNLqChKefAYWlU6/mbM5eB6cXyNBYILjGc6MI+qubclaT2C0G8xGla4
         V8lbnguXAiC/G+nGcWjq3Q4yIUepwSH0jOI1HRcjQWOASdDWTkwqttBpzDm9FcjsrKXp
         LeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286927; x=1794891727;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
        b=t+Ja91IQ/ppd3Gnl9UCj5YcmruEJ9DbcDUFlq9yamqKyNkPpMk6ML+yCCW2q9PIrmh
         uqZyl0ihFi56DG+RLXh0GwPaXDjKphn7O6WWDITLZF31I+R1pnZSsdtGdRjvrzsTUzN/
         oZrpDObmlgl2OocgS6Y9dTp5T64OjkEKcT2qLJKMtvC4rP1ocJTtG9LBemU1n3Gn5p1J
         fCfSLSml0kV3v12G/8P5nXcuKtE6NCCOAKGy7jsjFFGnKTYqExbxMUw55kOGfFaXS9kD
         7Hnxk4Tj7C819Eb2oN+jQH16ZyiID99tw2vb4FUjObD+SKlgoEswFkB908ohS4hCkJM0
         jTVQ==
X-Gm-Message-State: APuU4Z+7JAfzJyEstS1EWgl0nIXwmXmPlKZecRk6iJuU83u+80y5LdWF
	SiyMksMEIC/SZ++QcJtrCr1s0WrRozuPeoJC3P+Ki+pK0suk7z5xGVAuLUwwSkCVI4C5YBEAQMr
	c8IogbpyBbAMDmX7lzg==
X-Received: from ejzl18.prod.google.com ([2002:a17:906:a412:b0:c4d:1fbc:e718])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3dac:b0:c31:5bb8:4b3b with SMTP id a640c23a62f3a-c5048f79e02mr108053466b.2.1794286927522;
 Mon, 09 Nov 2026 21:02:07 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:45 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-3-tarunsahu@google.com>
Subject: [PATCH v4 02/19] kho: block: Record the entry size in the block header
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

Subsystems using the KHO Serialization Blocks framework currently do
not record the serialized entry size in the block header. The entry size
is only known to individual callers, which must track and store it in an
owning serialized data structure. If a newer source kernel adds fields
to an entry, the changed entry size breaks the stride when an older
target kernel iterates over blocks.

Add an entry_size field to struct kho_block_header_ser. On the outgoing
side, record bs->entry_size into every block header during allocation.
During restoration, derive the entry stride directly from the block
header instead of relying on caller-supplied dimensions. The
kho_block_set_init() interface remains unchanged. A zero entry size,
or one that differs between blocks of a set, is rejected during
restoration.

This change modifies the serialized layout of struct kho_block_header_ser
and shifts the offset of serialized entries within preserved blocks.
Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
kernels cleanly reject mismatched handover state during boot. Also
update the stale compatible string example in the documentation.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/block.h          | 10 ++++----
 include/linux/kho/abi/kexec_handover.h |  6 ++---
 kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
index 36bdbaf9b3b8..a40b0906c821 100644
--- a/include/linux/kho/abi/block.h
+++ b/include/linux/kho/abi/block.h
@@ -40,9 +40,10 @@
 
 /**
  * struct kho_block_header_ser - Header for the serialized data block.
- * @next:  Physical address of the next struct kho_block_header_ser.
- * @count: The number of entries that immediately follow this header in the
- *         memory block.
+ * @next:       Physical address of the next struct kho_block_header_ser.
+ * @count:      The number of entries that immediately follow this header in the
+ *              memory block.
+ * @entry_size: The size in bytes of each serialized entry in the block.
  *
  * This structure is located at the beginning of a block of physical memory
  * preserved across a kexec. It provides the necessary metadata to interpret
@@ -51,9 +52,10 @@
 struct kho_block_header_ser {
 	u64 next;
 	u64 count;
+	u64 entry_size;
 };
 
-static_assert(sizeof(struct kho_block_header_ser) == 16);
+static_assert(sizeof(struct kho_block_header_ser) == 24);
 static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 	      __alignof__(struct kho_block_header_ser) == 8);
 
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 2f4fb9c63942..6f12f5037ea5 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -41,7 +41,7 @@
  *   restore the preserved data.::
  *
  *     / {
- *         compatible = "kho-v3";
+ *         compatible = "kho-v5";
  *
  *         preserved-memory-map = <0x...>;
  *
@@ -62,7 +62,7 @@
  *     };
  *
  *   Root KHO Node (/):
- *     - compatible: "kho-v3"
+ *     - compatible: "kho-v5"
  *
  *       Identifies the overall KHO ABI version.
  *
@@ -90,7 +90,7 @@
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v4"
+#define KHO_FDT_COMPATIBLE "kho-v5"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..9b148009085e 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -16,6 +16,12 @@
  * array of serialized entries. Multiple blocks are linked together via a
  * physical pointer in the header, forming a linked list that can be easily
  * traversed in both the current and the next kernel.
+ *
+ * Each block header also records the size of its entries. A newer kernel may
+ * append fields to an entry, so the kernel that writes a block and the kernel
+ * that reads it can use different entry sizes. The reader steps through the
+ * entries with the recorded size, so every entry is found, and it does not read
+ * beyond the recorded size of an entry.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -110,6 +116,8 @@ static int kho_block_set_grow_one(struct kho_block_set *bs)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
+	ser->entry_size = bs->entry_size;
+
 	err = kho_block_add(bs, ser);
 	if (err) {
 		kho_block_free_ser(bs, ser);
@@ -242,7 +250,8 @@ static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
  *
  * Restores a serialized block set from a given physical address. The caller is
  * responsible for ensuring that the block set @bs has been allocated and
- * initialized prior to calling this function.
+ * initialized prior to calling this function. The entry size and the number
+ * of entries per block are taken from the restored block headers.
  *
  * Return: 0 on success, or a negative errno on failure.
  */
@@ -250,6 +259,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 {
 	struct kho_block_header_ser *ser;
 	u64 next_pa = head_pa;
+	u64 entry_size = 0;
 	int err;
 
 	/* Restored block sets use size from the previous kernel */
@@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	}
 
 	while (next_pa) {
+		u64 capacity;
+
 		ser = phys_to_virt(next_pa);
-		if (!ser->count || ser->count > bs->count_per_block) {
+		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
+			pr_warn("Block contains invalid entry size: %llu\n",
+				ser->entry_size);
+			err = -EINVAL;
+			goto err_destroy;
+		}
+		entry_size = ser->entry_size;
+		bs->entry_size = entry_size;
+		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
+		bs->count_per_block = capacity;
+
+		if (!ser->count || ser->count > capacity) {
 			pr_warn("Block contains invalid entry count: %llu\n",
 				ser->count);
 			err = -EINVAL;
@@ -370,7 +393,10 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
  * @it: The block iterator.
  *
  * Iterates through previously written entries during state deserialization,
- * respecting the actual count stored in each block's header.
+ * respecting the actual count stored in each block's header. Entries are
+ * spaced by the entry size recorded by the kernel that wrote them, which can
+ * be smaller or larger than the caller's structure. Fields beyond that size
+ * are not present in the entry.
  *
  * Return: A pointer to the next serialized entry, or NULL if all serialized
  * entries have been read.
-- 
2.56.0.506.g506a7eabc5-goog

