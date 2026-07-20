Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9E3D25CC
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567727; cv=none; b=X+TxShiWCEufxKVElgVWNfGx/lp8i2R9SC/d7mSzuKOJo21sMJHVEQc40zQt3G3kfcCNCr0iRmVjN0JJWa00BD2cNVg30pLozZjb9+xvB3/tcPh7Lh6BoILdkfe+VBz2VWqMh1kST4hwJu5BqazJ3iUs4OiYn9/dQ8cVtiOG5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567727; c=relaxed/simple;
	bh=5FAHXNNTqCk6d7A/G6m0QWAfn6wwv2hO6qDg7faQFk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t9vNtPzKjEXzCdDApUrxD6W6XDHTtf3Gfvsuz4R4GRzc4nzp2JcI+FrObbz5ZU6z9piZA2yGCCwbZfeea7Vrz4vtZTm9UGb90FzDRpEVl1DInaxf2c4zWNqtB7VtlZ4iwU4028D3YD3JuJbqDZIi7sVmlK0pO1WvzLvk/1nJrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gnenEMaG; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gnenEMaG"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49244130073so104169055e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567722; x=1785172522; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n84aHT6T0oE5lzqBHFQym45G2HUtzO8AvZXDSFiZelQ=;
        b=gnenEMaGYRT2Bpls6URM6Jbb5NRJI9w0LvvtpIcJxXWvoCXUjrzsbHl98r7GUVTY35
         0hn+8B7bgAcVJXAIgLom5+DdE6mDR7FM7M3Sn70ug+mQGR6k0WXTdmUaGNExE1zHreAg
         ti1LX5qfkVs5Zj+li5wQFKlzEM+KCA8N4enbG4PVFuKDZlbrZI31zEV45+mpaBxFLvTb
         SoY7IKwq7Ca09ynx3LmWkSX5K25lN9pU4fQ5fW5o6fBKwQL7eYrhkSVa52l9f2QZk1yo
         uP+VUUTOTlmZVq+dj5zamM9UGo5zeIQaxkv3bCCh+rDDH+2tC5S2wc38uXKcNxmNwILa
         L+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567722; x=1785172522;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n84aHT6T0oE5lzqBHFQym45G2HUtzO8AvZXDSFiZelQ=;
        b=IBSjl3B1NvjSmfjZ3Dt7f2VueTC+/l7WfCD7jes7dyOIwxHFmu5bw3siYnjqWTaf2w
         scs21K3qRUT/7u5YVKFLccnpOvTxYaExx04mBX9dl7jsucrwFJhQMbYEiPh1U9vFEauH
         whpFaBLZJIao6wpbFxLIo1pijuimHih+SvdH9E68Q1IUmfXF9+sK+H9TDFU80r/apFkr
         YnICJfKAhlSHzhxc+jlBuficaQFUsZLL0O3vjtAK4/oRHX6pCQ1u/Fp0+qc6KYIRkjZV
         PiObw7Nrn6iCkEPuTR6xmgMVr6pXv0NbSU5cqg+crztX/D6OeUd0fipf1FTSG+4uVoOE
         pW4Q==
X-Forwarded-Encrypted: i=1; AHgh+RpdRDWOZLLp7OpMrKnv2Tc+EjcLn5KhOMdc3UlZgmH0prxkTRn2geJDre97E/mvJJxE7r2eKQg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUoFSFMNSnOU4VNGAqO/Ul0dzts5h4TIOuVTexfshzWyI0kLyA
	o1wktoLrI1OuAQ/y2dp4tBVz5eN9SF92un9s5kxpa/3Hn72IJTVEK4pStr/fLBy2GaRlCUccUQR
	4Lv3bOOs+n1KFv5VOpVsBIQ==
X-Received: from wmix23-n2.prod.google.com ([2002:a05:600c:e557:20b0:495:549c:80ad])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c16:b0:495:5022:71b9 with SMTP id 5b1f17b1804b1-495502272f2mr148937275e9.33.1784567721456;
 Mon, 20 Jul 2026 10:15:21 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:14:59 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-4-vdonnefort@google.com>
Subject: [PATCH v3 03/17] KVM: arm64: Add pkvm_map_private_va_range
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for the pKVM heap allocator, introduce
pkvm_map_private_va_range() to map a physical range into the pKVM
private range.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
index 5cd2f1fe51e4..20e4445dd57b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -25,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
+static u64 __hyp_private_va_start;
 
 struct hyp_fixmap_slot {
 	u64 addr;
@@ -90,6 +91,31 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	return ret;
 }
 
+/**
+ * pkvm_map_private_va_range() - Map a physical range into the private VA range
+ * @haddr:	The virtual address in the private range.
+ * @phys:	The physical address to map.
+ * @size:	The size of the range to map.
+ *
+ * The hypervisor VA @haddr must have been first allocated with pkvm_alloc_private_va_range()
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size)
+{
+	unsigned long addr = (unsigned long)haddr;
+
+	if (!PAGE_ALIGNED(addr | phys | size))
+		return -EINVAL;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+
+	if (addr < __hyp_private_va_start || addr + size > __io_map_base)
+		return -EINVAL;
+
+	return kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, PAGE_HYP);
+}
+
 phys_addr_t pkvm_private_va_range_pa(void *va)
 {
 	kvm_pte_t pte = 0;
@@ -450,6 +476,7 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	 */
 	__io_map_base = start & BIT(hyp_va_bits - 2);
 	__io_map_base ^= BIT(hyp_va_bits - 2);
+	__hyp_private_va_start = __io_map_base;
 	__hyp_vmemmap = __io_map_base | BIT(hyp_va_bits - 3);
 
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
-- 
2.55.0.229.g6434b31f56-goog

