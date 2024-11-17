Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529071DA617
	for <kvmarm@lists.linux.dev>; Sun, 17 Nov 2024 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731862684; cv=none; b=DJd/2eExhGG1ejNw0qAzD5QRZ5TQRrkiqRHSdQkvch/grULV8CRcLnGz9T+RmR8YFYF3hFuRjoLBvUeofjZbuEKRpNgqyX2gb6I94WJfIMhZaFa7ObBMZSOlm0k0QjFF6GH9clbW+r9TmWbscV1ogTHsrk9Dw7PJW1E5T4KWFa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731862684; c=relaxed/simple;
	bh=mWhPaomnOXIgrD90VDCLQx2pcsTIDq2vpHhdQxlg0Zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f1zXlN9XrbP4dwCmHwwHiad6NaaZqZdFrM4LRivDKRAgCFXmLkIo0alEfuhawiU+an5XxBvnilPq3c6GGxqSOj1ZgPL8l+g72biPGWSdDJ9jq5TRU9RsXFX2/Hfh2EvIIvFZG4BrJmdkS3MvkHY4ZWrjthBRbxxisDaeSOmzxhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlTyCdwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlTyCdwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9FEC4CEDA;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731862684;
	bh=mWhPaomnOXIgrD90VDCLQx2pcsTIDq2vpHhdQxlg0Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlTyCdwl+ylkYTUH8o20nA4vPxY0ALVYp064B1P0yx+yBwjubzOAhXsFt4ecy2SbU
	 zzafKCVIxOOA0PwXKQ/wYnd6LjegtvmZHLyyHuFEnsY7+v73/COOWkL+RZcF3F7OIY
	 iOLavYDwHHebVldgPMGgw0oqYOjpCewmt5zxTDtzrs1RU8UdG/WxIq5pfXU4Z6O+s5
	 vzJqT6wKvSWq+5i+g5efICTPJP4umOvenfaAqH7DFPCcCbx3kCZXtlytGeajVFr+8S
	 /+Ujke0YhGaNq60+ISrrt1pf/CFmxM4yZq+f7zQOlqr1z8TiwXzkK6QX7OXohE2IdF
	 +vW0x/go0bfiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tCib3-00DYt6-Sl;
	Sun, 17 Nov 2024 16:58:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/4] KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry sizes
Date: Sun, 17 Nov 2024 16:57:57 +0000
Message-Id: <20241117165757.247686-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241117165757.247686-1-maz@kernel.org>
References: <20241117165757.247686-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ITS ABI infrastructure allows for some pretty lax code, where
the size of the data doesn't have to match the size of the entry,
potentially leading to a collection of interesting bugs.

Commit 7fe28d7e68f9 ("KVM: arm64: vgic-its: Add a data length check
in vgic_its_save_*") added some checks, but starts by implicitly
casting all writes to a 64bit value, hiding some of the issues.

Instead, introduce macros that will check the data type actually used
for dealing with the table entries. The macros are taking a symbolic
entry type that is used to fetch the size of the entry type for the
current ABI. This immediately catches a couple of low-impact gotchas
(zero values that are implicitly 32bit), easy enough to fix.

Given that we currently only have a single ABI, hardcode a couple of
BUILD_BUG_ON()s that will fire if we use anything but a 64bit quantity,
and some (currently unreachable) fallback code that may become useful
one day.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 69 ++++++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic.h     | 23 ------------
 2 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 79c40708b6646..f4c4494645c34 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -31,6 +31,41 @@ static int vgic_its_commit_v0(struct vgic_its *its);
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
+#define vgic_its_read_entry_lock(i, g, valp, t)				\
+	({								\
+		int __sz = vgic_its_get_abi(i)->t##_esz;		\
+		struct kvm *__k = (i)->dev->kvm;			\
+		int __ret;						\
+									\
+		BUILD_BUG_ON(NR_ITS_ABIS == 1 &&			\
+			     sizeof(*(valp)) != ABI_0_ESZ);		\
+		if (NR_ITS_ABIS > 1 &&					\
+		    KVM_BUG_ON(__sz != sizeof(*(valp)), __k))		\
+			__ret = -EINVAL;				\
+		else							\
+			__ret = kvm_read_guest_lock(__k, (g),		\
+						    valp, __sz);	\
+		__ret;							\
+	})
+
+#define vgic_its_write_entry_lock(i, g, val, t)				\
+	({								\
+		int __sz = vgic_its_get_abi(i)->t##_esz;		\
+		struct kvm *__k = (i)->dev->kvm;			\
+		typeof(val) __v = (val);				\
+		int __ret;						\
+									\
+		BUILD_BUG_ON(NR_ITS_ABIS == 1 &&			\
+			     sizeof(__v) != ABI_0_ESZ);			\
+		if (NR_ITS_ABIS > 1 &&					\
+		    KVM_BUG_ON(__sz != sizeof(__v), __k))		\
+			__ret = -EINVAL;				\
+		else							\
+			__ret = vgic_write_guest_lock(__k, (g),		\
+						      &__v, __sz);	\
+		__ret;							\
+	})
+
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
  * If this LPI is already mapped on another ITS, we increase its refcount
@@ -794,7 +829,7 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 		its_free_ite(kvm, ite);
 
-		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;
@@ -1143,7 +1178,6 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
-	int dte_esz = vgic_its_get_abi(its)->dte_esz;
 	struct its_device *device;
 	gpa_t gpa;
 
@@ -1168,7 +1202,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * is an error, so we are done in any case.
 	 */
 	if (!valid)
-		return vgic_its_write_entry_lock(its, gpa, 0, dte_esz);
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, dte);
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
@@ -2090,7 +2124,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
  * vgic_its_save_ite - Save an interrupt translation entry at @gpa
  */
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
-			      struct its_ite *ite, gpa_t gpa, int ite_esz)
+			      struct its_ite *ite, gpa_t gpa)
 {
 	u32 next_offset;
 	u64 val;
@@ -2101,7 +2135,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, gpa, val, ite_esz);
+	return vgic_its_write_entry_lock(its, gpa, val, ite);
 }
 
 /**
@@ -2201,7 +2235,7 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 		if (ite->irq->hw && !kvm_vgic_global_state.has_gicv4_1)
 			return -EACCES;
 
-		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
+		ret = vgic_its_save_ite(its, device, ite, gpa);
 		if (ret)
 			return ret;
 	}
@@ -2240,10 +2274,9 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
  * @its: ITS handle
  * @dev: ITS device
  * @ptr: GPA
- * @dte_esz: device table entry size
  */
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
-			     gpa_t ptr, int dte_esz)
+			     gpa_t ptr)
 {
 	u64 val, itt_addr_field;
 	u32 next_offset;
@@ -2256,7 +2289,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, ptr, val, dte_esz);
+	return vgic_its_write_entry_lock(its, ptr, val, dte);
 }
 
 /**
@@ -2332,10 +2365,8 @@ static int vgic_its_device_cmp(void *priv, const struct list_head *a,
  */
 static int vgic_its_save_device_tables(struct vgic_its *its)
 {
-	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_device_table;
 	struct its_device *dev;
-	int dte_esz = abi->dte_esz;
 
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
@@ -2354,7 +2385,7 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 		if (ret)
 			return ret;
 
-		ret = vgic_its_save_dte(its, dev, eaddr, dte_esz);
+		ret = vgic_its_save_dte(its, dev, eaddr);
 		if (ret)
 			return ret;
 	}
@@ -2435,7 +2466,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 
 static int vgic_its_save_cte(struct vgic_its *its,
 			     struct its_collection *collection,
-			     gpa_t gpa, int esz)
+			     gpa_t gpa)
 {
 	u64 val;
 
@@ -2444,7 +2475,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       collection->collection_id);
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, gpa, val, esz);
+	return vgic_its_write_entry_lock(its, gpa, val, cte);
 }
 
 /*
@@ -2452,7 +2483,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
  * Return +1 on success, 0 if the entry was invalid (which should be
  * interpreted as end-of-table), and a negative error value for generic errors.
  */
-static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
+static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa)
 {
 	struct its_collection *collection;
 	struct kvm *kvm = its->dev->kvm;
@@ -2460,7 +2491,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	ret = vgic_its_read_entry_lock(its, gpa, &val, esz);
+	ret = vgic_its_read_entry_lock(its, gpa, &val, cte);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
@@ -2507,7 +2538,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
-		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
+		ret = vgic_its_save_cte(its, collection, gpa);
 		if (ret)
 			return ret;
 		gpa += cte_esz;
@@ -2521,7 +2552,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * table is not fully filled, add a last dummy element
 	 * with valid bit unset
 	 */
-	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
+	return vgic_its_write_entry_lock(its, gpa, 0ULL, cte);
 }
 
 /*
@@ -2546,7 +2577,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	while (read < max_size) {
-		ret = vgic_its_restore_cte(its, gpa, cte_esz);
+		ret = vgic_its_restore_cte(its, gpa);
 		if (ret <= 0)
 			break;
 		gpa += cte_esz;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8290f3276cf07..122d95b4e2845 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -146,29 +146,6 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
-static inline int vgic_its_read_entry_lock(struct vgic_its *its, gpa_t eaddr,
-					   u64 *eval, unsigned long esize)
-{
-	struct kvm *kvm = its->dev->kvm;
-
-	if (KVM_BUG_ON(esize != sizeof(*eval), kvm))
-		return -EINVAL;
-
-	return kvm_read_guest_lock(kvm, eaddr, eval, esize);
-
-}
-
-static inline int vgic_its_write_entry_lock(struct vgic_its *its, gpa_t eaddr,
-					    u64 eval, unsigned long esize)
-{
-	struct kvm *kvm = its->dev->kvm;
-
-	if (KVM_BUG_ON(esize != sizeof(eval), kvm))
-		return -EINVAL;
-
-	return vgic_write_guest_lock(kvm, eaddr, &eval, esize);
-}
-
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
-- 
2.39.2

