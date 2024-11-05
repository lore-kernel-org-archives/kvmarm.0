Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3119220D513
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835281; cv=none; b=WlbmyBuhQ5TO4v4lFQAeht0rP/VfZQEyhqpXaUcsDOgArQOw06CgcW5FAYhjCQeBx2ZCWYJFZC6+MZgsWiVvUjpc+paC2UkyooJjF8n/tTCAsGfbZ9YDWQn7lJN90EFynTO4f3FURywgGtWxPU9CqSgkDrPpDLEYtWo5kiLqfY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835281; c=relaxed/simple;
	bh=kInf2EvZvTDFfM9GExpyeELhxqydn4SRTx15KOOumDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u9mxo9loJQAb91bInAi2ZeZLRJw8IsKS/CU6NARKQfvqIUmg1TiQvG7gavDYrT3sZOwm46lPWPR3SsN/dJ+dWJhhiGhd9Baiu0vNHLfJuKqkDEgbGMQGZu6X21Q7EUe10VMuy3pONgA/aCRTchsL+VCyom8RlFxRvMZFM5e3l8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVrfpRHW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVrfpRHW"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e789e56af4so5861090a91.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Nov 2024 11:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835279; x=1731440079; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4Mhq6EID/2WIdk3/r42uHlqiQKnepXjHLSNkiOJBVU=;
        b=MVrfpRHWJKAaYeIO4BZAmPJHH/aoDsLq1zK0b4P0hQIl6/gWB6lW3NnZsJeNMw8Mj6
         Z01cNZtxT06blHlTX60Uu+ULTyk8qZ8melWi+eRj2c1GMZzPrfGLZ/eNkp2Kc3SYH/cF
         AeDIqsJ3S0zMyrO0RF2Fmap85Q57GGLqq0T3x8vTPYYPwVAgl8a9EIFTOInu7PFkHhYT
         yp5IDqOHpYUTVrwqWqWGMKHwJnU4xQcGcNpVJb4XihYdndFRvhOZz9jUBvjQg+XjCoDG
         3X+BIqgg+ww/08Mp9f9cg8zfBiY/ulE6wOoOuBuzJ2K/cAl8eDxxM2xFI1LZZBAscNVX
         zEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835279; x=1731440079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4Mhq6EID/2WIdk3/r42uHlqiQKnepXjHLSNkiOJBVU=;
        b=YUxI6vEkfe5LM1RFG9s6Ax+CwMf/IFjnKy+7nsHY5TDB0AgQXpp801CL9bsXLYdBQX
         bO4aKTVARBdWerQgKrj4wnigZGZN0/ukT7ZPjJOcn+OdYmMV8WxS081QPwqTArlNEkH/
         fkjYhxCZiEtt9k9yt6X4UGAF52EdpQEYgDUOs9we2ohy1wenPLhsVbLNkj1Km02A665d
         pHc6LQE5HkNa5O0PVd7kyMd5fkqP/SYT3Xl/hOwwbWgN6FjoDBg/kCpOhAxSZf7cSyKQ
         rEYbSLBcwCUs1E03lMwWnWH5H520RqSFGrvyP/4OphjRqryit4z2M7eJGX1fkzNAzDdt
         PRSw==
X-Forwarded-Encrypted: i=1; AJvYcCXzyC9bLMbz1lRQlnmI/DNgKwS/hvIzMLEfEOVENLDYYNfDuBnmFFOYZdJPoJlU3/izXG6prN8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRwMnv8oseflmNO7nayNc+/1Mdr1wyR3nir5hQRyrOjOn/76yY
	EMOPmWGH61rkbTz9iYU94vfyCoGMgrF9+gUw+0sX5SeufhdFWTCmOgFKqnAHQml5hNLVrYC1YiV
	a5shEQuQkbiOdtKFs8ANKww==
X-Google-Smtp-Source: AGHT+IHz87qcpvtxC/VkG/BAwyvAhbHecX6y27KXqrrfOGHWL9v2Og5+yEETZmaCHahb+olcpsw/2zunD1KFOhiGpw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:4b86:b0:2e2:a63a:22f1 with
 SMTP id 98e67ed59e1d1-2e8f12f0e78mr58808a91.7.1730835279381; Tue, 05 Nov 2024
 11:34:39 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:21 -0800
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-4-jingzhangos@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: vgic-its: Return device/event id instead
 of offset in ITS tables restore
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

In ITS tables restore operation, the id offset is passing around during
table scanning. But, e can derive more information from a device/event
id, since device table and ITT are indexed by the id.
Pass around the next device/event id instead of id offset to ease the
implementation for incoming changes.
A side benefit of this change is that the 2-level device table scanning
would be more efficient. With the deivce id, we don't have to scan the
L1 table entry one by one, the scanning can jump directly to the DTE in
the L2 table.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 56 ++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 953af024d94a..867cc5d3521d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2041,15 +2041,17 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * (non zero for 2d level tables)
  * @fn: function to apply on each entry
  * @opaque: pointer to opaque data
+ * @l1_tbl: true if it is a l1 table in a 2-level structure
  *
- * Return: < 0 on error, 0 if last element was identified, 1 otherwise
- * (the last element may not be found on second level tables)
+ * Return: < 0 on error, 0 if last element was identified, next id (device id or
+ * event id) of next valid entry.
  */
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
-			  int start_id, entry_fn_t fn, void *opaque)
+			  int start_id, entry_fn_t fn, void *opaque, bool l1_tbl)
 {
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
+	int next_id = start_id;
 	int id = start_id;
 	gpa_t gpa = base;
 	char entry[ESZ_MAX];
@@ -2065,8 +2067,16 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 		if (ret)
 			return ret;
 
-		next_offset = fn(its, id, entry, opaque);
-		if (next_offset <= 0)
+		next_id = fn(its, next_id, entry, opaque);
+		if (next_id <= 0)
+			return next_id;
+
+		if (l1_tbl)
+			next_offset = next_id * esz / SZ_64K - id;
+		else
+			next_offset = next_id - id;
+
+		if (!next_offset)
 			return next_offset;
 
 		byte_offset = next_offset * esz;
@@ -2077,7 +2087,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	return 1;
+	return next_id;
 }
 
 /*
@@ -2128,7 +2138,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
 
 	if (!lpi_id)
-		return 1; /* invalid entry, no choice but to scan next entry */
+		return event_id + 1; /* invalid entry, no choice but to scan next entry */
 
 	if (lpi_id < VGIC_MIN_LPI)
 		return -EINVAL;
@@ -2158,7 +2168,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	}
 	ite->irq = irq;
 
-	return offset;
+	return event_id + offset;
 }
 
 static int vgic_its_ite_cmp(void *priv, const struct list_head *a,
@@ -2238,7 +2248,7 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 	size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
 
 	ret = scan_its_table(its, base, max_size, ite_esz, 0,
-			     vgic_its_restore_ite, dev);
+			     vgic_its_restore_ite, dev, false);
 
 	/* scan_its_table returns +1 if all ITEs are invalid */
 	if (ret > 0)
@@ -2280,8 +2290,8 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
  * @ptr: kernel VA where the 8 byte DTE is located
  * @opaque: unused
  *
- * Return: < 0 on error, 0 if the dte is the last one, id offset to the
- * next dte otherwise
+ * Return: < 0 on error, device id of the current DTE if it
+ * is the last one, device id of the next DTE otherwise
  */
 static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
@@ -2303,7 +2313,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
 
 	if (!valid)
-		return 1;
+		return id + 1;
 
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
@@ -2321,7 +2331,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 		return ret;
 	}
 
-	return offset;
+	return id + offset;
 }
 
 static int vgic_its_device_cmp(void *priv, const struct list_head *a,
@@ -2409,33 +2419,33 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
  * handle_l1_dte - callback used for L1 device table entries (2 stage case)
  *
  * @its: its handle
- * @id: index of the entry in the L1 table
+ * @id: the start device id to scan in the L2 table
  * @addr: kernel VA
  * @opaque: unused
  *
- * L1 table entries are scanned by steps of 1 entry
  * Return < 0 if error, 0 if last dte was found when scanning the L2
- * table, +1 otherwise (meaning next L1 entry must be scanned)
+ * table, device id of the next valid DTE otherwise
  */
 static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 			 void *opaque)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	int l2_start_id = id * (SZ_64K / abi->dte_esz);
 	u64 entry = *(u64 *)addr;
 	int dte_esz = abi->dte_esz;
+	int dte_per_table = SZ_64K / dte_esz;
+	gpa_t gpa_offset = (id % dte_per_table) * dte_esz;
 	gpa_t gpa;
 	int ret;
 
 	entry = le64_to_cpu(entry);
 
 	if (!(entry & KVM_ITS_L1E_VALID_MASK))
-		return 1;
+		return (id + 1) * dte_per_table;
 
-	gpa = entry & KVM_ITS_L1E_ADDR_MASK;
+	gpa = (entry & KVM_ITS_L1E_ADDR_MASK) + gpa_offset;
 
-	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
-			     l2_start_id, vgic_its_restore_dte, NULL);
+	ret = scan_its_table(its, gpa, SZ_64K - gpa_offset , dte_esz,
+			     id, vgic_its_restore_dte, NULL, false);
 
 	return ret;
 }
@@ -2460,11 +2470,11 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     handle_l1_dte, NULL);
+				     handle_l1_dte, NULL, true);
 	} else {
 		l1_esz = abi->dte_esz;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     vgic_its_restore_dte, NULL);
+				     vgic_its_restore_dte, NULL, false);
 	}
 
 	/* scan_its_table returns +1 if all entries are invalid */
-- 
2.47.0.199.ga7371fff76-goog

