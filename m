Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91AB51E459
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864948; cv=none; b=alJI5UumjbEQ1p1i+BbsmdxjHytJJXv58KESNDXpY4h5xNlXbqbz3w0HGGhAMtCRPFO4McfIIDDl5h+OOddVs/GfG5UqivZ3HosR47zZQfL0emc5mjR7VMqTxcn3sD2ki/cfWdwVm0TyYyyvOi7JwhWzajptubyBAnf4wn0h1Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864948; c=relaxed/simple;
	bh=X7z2VqUdb1mszQvQ5haxq9XQqck94bSRhUiPAVRNmJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImTIp+TAG7AqW2TePKLNfTH3OiTTXTyM7PHsnZEdzdt3d3BT0s9VwKsqqDwLnfKcLATcgBPl41S/cF9FyzspaL4ZfXDphYtaz68kzBf12wq3K5rgAsTiBlUS4wfKYIz2VwibA6nrmiLz15szmIW/NpaHLxqH3kdi75qXviHI/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HCe/UhkH; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HCe/UhkH"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a0185655deso15393145e9.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864939; x=1791469739; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+s4NWOlWqk4S+J0HZTfoSpJM7Gl6B52/Z0IH4Bg+ix8=;
        b=HCe/UhkH9JJS8MMsY2i034IKZpUWQ3ESvwKtMnAJLHPIfOJZlfwkndJUDOzq8UWB5k
         G/SMXyZzPulckAX3XxCN8reqRDZSPAUjVGl2tqtgITKRNbATasa/9ogDyXps2rMunERa
         CJd1EXi2/SjNEYrTtUrFr+7BS7gmq7sAT5ySWVtaPjj2xuG+qKb5kSzX3K10bYX5DqS1
         ZLfq1Yh8rEkbfWtsbTKhsmS6U5jtIwLg6bZjD8RWqw5tSKbL6gMcPWK0/jox+QEpuinw
         Dpyb8HPVs9sXWUIeepFSLy7h8MToO8I/T1puQ1fDrUoO5ozImOcqaxEGYTCW8wp9cXmE
         PurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864939; x=1791469739;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+s4NWOlWqk4S+J0HZTfoSpJM7Gl6B52/Z0IH4Bg+ix8=;
        b=EDttloBlSh5epPb8sxL/OnRCfa3ynGLBofTX08BtOjyfAvg2ZK4x26zDLn+kt5lkju
         p/wF1rVFK46CVhQBg8AqM5GIrLvv/3OnvoudTcyCXo+cUuHRelABHds8bpF0GbyQ2Pxa
         2+o4/MIsfcyqbmKnltp4WwTEfn4EyC4kO3T6WDfIwHFqemUXWrJKW/HB5iCB4DBniixG
         zrUtvpC0nE8ALKeHTmZN8hqPNmDUSnICW+0v9No1rJ13e2HgISaA4GY9Gv6NkaaqYH0x
         mo+hscdlEhuCy4KlDTXVynIkbqMn+UuosHAb+pXwYy6rXbicRLRhWKK6PSuTlggMNFVp
         92ww==
X-Forwarded-Encrypted: i=1; AKwUvBwbluDvio6cNUFUcS1IfK20PRDLTlAQYEPH/Jk+jlh17qy5enBb8EgVjyrMk42CaLtu4nxbUAQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lIZoNxFkCC43HIlFus9jJwM3CxkP7tD0RgqMuGqNJNbwckZarN
	V7u/K5tBBKTpMfnHHUA3picfikZv8iErfqJCXIiBQrlC0p/7CggezrcwECsnkXm4A+5YihrHRf0
	GZyMarCqFj/iaDB+x2S19rA==
X-Received: from wmpr23.prod.google.com ([2002:a05:600c:3217:b0:4a0:1622:59a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3d92:b0:4a0:25d5:e853 with SMTP id 5b1f17b1804b1-4a025d5eaf7mr14273125e9.35.1790864938529;
 Thu, 01 Oct 2026 07:28:58 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:34 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-4-vdonnefort@google.com>
Subject: [PATCH v6 03/18] KVM: arm64: Add pkvm_map_private_va_range
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for the pKVM heap allocator, introduce
pkvm_map_private_va_range() to map a physical range into the pKVM
private range.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 59 ++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 00cadd13ee5d..ea97ea49820e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -31,6 +31,7 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  unsigned long *haddr);
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
+int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size);
 phys_addr_t pkvm_private_va_range_pa(void *va);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 9ab7f613fa36..4a22fb74182b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -25,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
+static u64 __io_map_next;
 
 struct hyp_fixmap_slot {
 	u64 addr;
@@ -50,7 +51,7 @@ static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
 
 	hyp_assert_lock_held(&pkvm_pgd_lock);
 
-	if (!start || start < __io_map_base)
+	if (!start || start < __io_map_next)
 		return -EINVAL;
 
 	/* The allocated size is always a multiple of PAGE_SIZE */
@@ -60,7 +61,7 @@ static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
 	if (cur > __hyp_vmemmap)
 		return -ENOMEM;
 
-	__io_map_base = cur;
+	__io_map_next = cur;
 
 	return 0;
 }
@@ -70,7 +71,7 @@ static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
  * @size:	The size of the VA range to reserve.
  * @haddr:	The hypervisor virtual start address of the allocation.
  *
- * The private virtual address (VA) range is allocated above __io_map_base
+ * The private virtual address (VA) range is allocated above __io_map_next
  * and aligned based on the order of @size.
  *
  * Return: 0 on success or negative error code on failure.
@@ -81,7 +82,7 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	int ret;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
-	addr = __io_map_base;
+	addr = __io_map_next;
 	ret = __pkvm_alloc_private_va_range(addr, size);
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
@@ -90,6 +91,41 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	return ret;
 }
 
+/**
+ * pkvm_map_private_va_range() - Map a physical range into the private VA range
+ * @haddr:	The virtual address in the private range.
+ * @phys:	The physical address to map.
+ * @size:	The size of the range to map.
+ *
+ * The hypervisor VA @haddr must have been first allocated with
+ * pkvm_alloc_private_va_range(). The created mapping can later be removed
+ * with pkvm_remove_mappings().
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size)
+{
+	unsigned long addr = (unsigned long)haddr;
+	int ret;
+
+	if (!PAGE_ALIGNED(addr | phys | size))
+		return -EINVAL;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+
+	if (addr < __io_map_base || addr >= __io_map_next)
+		return -EINVAL;
+
+	if (size > __io_map_next - addr)
+		return -EINVAL;
+
+	ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, PAGE_HYP);
+	if (ret)
+		kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
+
+	return ret;
+}
+
 /**
  * pkvm_private_va_range_pa - Translate a private VA to a physical address.
  * @va:		The private virtual address to translate.
@@ -168,6 +204,12 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
  * pkvm_remove_mappings - Remove mappings from the hypervisor page-table
  * @from:	The starting virtual address of the range to remove
  * @to:		The ending virtual address of the range to remove
+ *
+ * The range [@from, @to) can be a subset of the range previously mapped by
+ * pkvm_create_mappings(), as the latter enforces PTE-level mappings. However,
+ * it cannot be a subset of a range mapped by pkvm_map_private_va_range() as
+ * that function allows block mappings which the hypervisor page-table does not
+ * split.
  */
 void pkvm_remove_mappings(void *from, void *to)
 {
@@ -377,7 +419,7 @@ static int create_fixblock(void)
 		return -EINVAL;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
-	addr = ALIGN(__io_map_base, PMD_SIZE);
+	addr = ALIGN(__io_map_next, PMD_SIZE);
 	ret = __pkvm_alloc_private_va_range(addr, PMD_SIZE);
 	if (ret)
 		goto unlock;
@@ -462,6 +504,7 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	 */
 	__io_map_base = start & BIT(hyp_va_bits - 2);
 	__io_map_base ^= BIT(hyp_va_bits - 2);
+	__io_map_next = __io_map_base;
 	__hyp_vmemmap = __io_map_base | BIT(hyp_va_bits - 3);
 
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
@@ -475,13 +518,13 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	prev_base = __io_map_base;
+	prev_base = __io_map_next;
 	/*
 	 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
 	 * an alignment of our allocation on the order of the size.
 	 */
 	size = NVHE_STACK_SIZE * 2;
-	addr = ALIGN(__io_map_base, size);
+	addr = ALIGN(__io_map_next, size);
 
 	ret = __pkvm_alloc_private_va_range(addr, size);
 	if (!ret) {
@@ -497,7 +540,7 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr + NVHE_STACK_SIZE,
 					  NVHE_STACK_SIZE, phys, PAGE_HYP);
 		if (ret)
-			__io_map_base = prev_base;
+			__io_map_next = prev_base;
 	}
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

