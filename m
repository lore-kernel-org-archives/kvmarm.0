Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA8F380FD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250197; cv=none; b=bp7DxnkYRdUWJGlJh1xhVnniIlEe51n+PnDN9euxQfbDrYYbkPzNJMkd1njKYz8+2Gb9lV6Oq3Nyx/N7V54vyfl0wKOpzWcmpH6RT+B36vrviHJdneY4Y32uHFxVvJm+WkE88fevupk7/uSeibFZxb+2y3R8uefY4Ez9aYJyGa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250197; c=relaxed/simple;
	bh=ztCcnt82TkjRpBPxKEUmDsHT06SYZ1hQXmbme9YXr58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iatON+HJ1idlP313SJ1n6YqiJIcFAbvn469wlJPoGeaj6FHGJJXzPNkC37HPFSloscC324yRObckNQTDxW9fXmUmEvUkI+zZzASBnOxQeBsrW/ua5xa37eUsPwhav/bR6yOpFRAdo+dSVwnpJV+62capUHtF+K9TQ4tSfyHtfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YaRi0kRc; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YaRi0kRc"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15d4bd2afeso119453666b.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250193; x=1788854993; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+PNXfvvSVMdiv5W0xxEcK++hpZTu+rqnFDb2lmCj1j4=;
        b=YaRi0kRct3ieoLUhlSxI9BED79lXR9vop2qCWvhbkynocg5s8nUG3PZRdeUOIuYlwp
         BCYnbtSevbkyQwu+h5qbJhtxqhsXMzAEUYMdEbYJ8zXfGFZfLaCNQQjNs9H207EPVlm9
         nhRo5EoHhqEPFDSBAYQOU8K1HfNVf76jXsSoVbdyq1fSALUuBpareRjZyBEaD4YP0OWk
         gPRKhYFGxJRDk0RQla0wXu5uKpcCQPIjXGZYbzXoBScojkJ2h/PQrQWkd3wJ6FJ582ib
         jpLWFCLtkBDbQtmB6iYa1OS0xaHyp4RxbKm1taY/d/fO95klQtpcuGPnZexOj2IhltFW
         5gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250193; x=1788854993;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+PNXfvvSVMdiv5W0xxEcK++hpZTu+rqnFDb2lmCj1j4=;
        b=eb67h/uGg75/pT/c1mwC2paeznKGMBrNNwpGK7ybw/5b9Ndqjs+rAp784AaIocHWFl
         yjX8R96IoHpjm0605eKR4gDN5eaG8wo89AAKeBWDDR2ObfLIf7jZ/BEPVsOvWVbxKI/7
         BnD+YMxpQkgpzjXV8fU5MsrgYj126Plfbq8yur0crtjQ+GJk/yPmPpzJcwIGuP9AyvGD
         mnbEpoX7y35rDwNGI+YCv+qu/uDFK5LwbA39LtK+j5a5XsxOYn7BNRXQBxFEMsGQR3+c
         nDo/M6NG60Ec9m03BdEg6vGbMm7nWQtqQJDcgmDrCrMtgd4eqV6ew7x+rsRffvifcsP5
         7e7g==
X-Forwarded-Encrypted: i=1; AHgh+RrWtpCOsMMMy/fqpL6pV4n/AoQ2jSqU9BuHUZ84kkRQV5w+aKD8CN0nOHi6TthN9GVKE5ZnRy4=@lists.linux.dev
X-Gm-Message-State: AFuF++kXk5bg65mlbC9A0aMkIR7CYFfpFvOfPuc18+A21sQ4ee7+ZsVQ
	ngk9jc8vyiLGBWL/4foMs7jepO0LDDGrV40jzxPmD9zBQRzXjgz8Dl2TE0R8ww5uTlx23JQytFb
	NJKeyMlV1lkT7H71N2X0SxA==
X-Received: from ejih12.prod.google.com ([2002:a17:906:2dcc:b0:c25:34f8:440f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d4d:b0:c21:7feb:4574 with SMTP id a640c23a62f3a-c25b3b00031mr355498266b.1.1788250192206;
 Tue, 01 Sep 2026 01:09:52 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:26 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-4-vdonnefort@google.com>
Subject: [PATCH v5 03/18] KVM: arm64: Add pkvm_map_private_va_range
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
2.55.0.897.gb25b4bd76c-goog

