Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4D41D102
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508561; cv=none; b=WzsKzcgKbovVxyU0xYOqdLBTJ+9iiHjm1Wabthtww6FnE6IYu0Ogua/7jCcr1F0vVGCbBzAVSPjq0dossihacSzAuEf3deX/jikMFJZ7hYl9nDfXcZvg534Wck3WTI43Nt3P26JC0EEAuVJq7UfpbCfT9gOiMezy1FNUFiLfGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508561; c=relaxed/simple;
	bh=jYFXl7oK0ris0wS0YfIb16ts/ukap7SAbIm79s1MV1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mEP00sGvqDc5yQAor/On1TYMYzgbU3mC0RKOtEv6tm1qyhPI8+mE3oqsEOh0cCIR1MP9zhyyETbmiBlfwvx6RIwaofikWx1OctrACTFxK3v2DmvrEaKJIeSLTKaRV2xxyC1bSU2N8aewtCdPL+T0lCFl9IhQLjJtG6E6/N0Oj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fd8sUa/x; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fd8sUa/x"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c16711b9473so96596966b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508558; x=1786113358; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dBeJnOBeGvR3Kq4srtpyurlmLcYd2v/y6WTlhJ89Sk4=;
        b=fd8sUa/xUKjqWu9GUp7n0OQghQbd1xJIuxfWdH/f/ilbRcVgKP9hemD+ARg1NtBaU4
         fVJ1uhcdFo7gZo6K601h3wq2M/BuQDKJpYRsDoAsOFF2+6F0VJV7L//aq+DwfIf9xoTG
         /qmL6e4TUAy2BADWH7bwbXTqdTa04cOKvOWwqv9HZstZb8/SDxN2x2ty6hV1+BRV+r/Y
         AEeKjxoAkTPCxB2mcg5reh42OtbKa72XDpO7I2/wIscFlsyw36NEhHRiaN/lkdu98YPl
         oF/JpvBCLIfQcpXOU/FmGMEOmIxDenh7AzO4ViflSN1CS+R8V0HJtc8syIYN8a1inzG/
         xIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508558; x=1786113358;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBeJnOBeGvR3Kq4srtpyurlmLcYd2v/y6WTlhJ89Sk4=;
        b=h/EoLOGQcdPMJl8Xg1ExTxF8cErfqVvev9xTby86qIXezj81feyJDw+1dSIZuu/2Nz
         LoZIgUBdHioUt90xpDAsgAIao18jI61en8YtN638MkwAaNSNUhitIK+df7Dwe6hcC5be
         9916Va9llv/KSHAp3iEE59cfbHDuOWXJqkzL19d5KC5/rMO8xsDSaYLQ8YQsIb87DAo5
         e+TSi3/6kYWUBd17aPFsIo9d84XRmAzPKYug0LwOSbfMgstDn61DFX2645mkwCT9Nn73
         G5VWpgmu28G33oHMTMzbWNx4fIync9DZ9PhfYqeN7eP6vNW96bWmOK2D8uhHpf9fS9r8
         VXeQ==
X-Forwarded-Encrypted: i=1; AHgh+RozvdEYyyRFqFujlxiVwiM1SUObaJirYCsZ7UReqaU2mdbvxE5pixwgueRa5ZkwArQHQeb9vLM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzey3AQDGC3iZ6UeUfuZamQSfhEhx62yESzRByILUABC9E8ikie
	yL5rCuDBWDFk1zz3cSR8nO2vjYRXE62vgMVQiYRv70dK8yoNlHXB9E7oaNF6FTDgHUkOrXohP11
	nfQ0iRDgPvz+Z666XeNww6w==
X-Received: from wmpw24.prod.google.com ([2002:a05:600c:998:b0:495:4837:275e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:4783:b0:c1c:2173:d412 with SMTP id a640c23a62f3a-c1fd23982c8mr146275266b.1.1785508557986;
 Fri, 31 Jul 2026 07:35:57 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:27 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-4-vdonnefort@google.com>
Subject: [PATCH v4 03/17] KVM: arm64: Add pkvm_map_private_va_range
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for the pKVM heap allocator, introduce
pkvm_map_private_va_range() to map a physical range into the pKVM
private range.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
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
index 9ab7f613fa36..22f6aae42f29 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -25,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
+static u64 __hyp_private_va_start;
 
 struct hyp_fixmap_slot {
 	u64 addr;
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
+	if (addr < __hyp_private_va_start || addr >= __io_map_base)
+		return -EINVAL;
+
+	if (size > __io_map_base - addr)
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
@@ -462,6 +504,7 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	 */
 	__io_map_base = start & BIT(hyp_va_bits - 2);
 	__io_map_base ^= BIT(hyp_va_bits - 2);
+	__hyp_private_va_start = __io_map_base;
 	__hyp_vmemmap = __io_map_base | BIT(hyp_va_bits - 3);
 
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
-- 
2.55.0.508.g3f0d502094-goog

