Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAD0370AE2
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250194; cv=none; b=B++I7vCwFJtLOvpTh2DLEoyK3gal3ISq7LiVnSHkneMAKKN+OY4hylHsCh3OXvOSefap/q5LbFFzzMjXJd7IJw641DS5orY1BtYAeHVU/67NMbBIYeprolBycHCKOLTvgwYb3F72TaN0P4t+bJVGuC4z0OYCnPjpAIprmERiCDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250194; c=relaxed/simple;
	bh=/SkIgKM4GonQAMd14BbG43HKfqX9tQ/5SXMItiJgx1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bE9sbpO1qzM9XsAy7//JzcgovEs5vHeAkB4nIIEs6JlKCLp5DtfxP5METcR05TnAvs2mSEgi9R3LvGCA2hVwYz+GZcFpKNuujfuOJK7G4izk4N1YU+XFfVxiC3YrupQ157JLltoQUDFCV6mO8GNQwWEpV4QS13RV+FMMbQuczKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QzTwy3wi; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QzTwy3wi"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49554715277so41126865e9.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250191; x=1788854991; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C7nBgl70e5xfSJ2oqkVr0tglewdp5qWUVF45E6u5ip4=;
        b=QzTwy3wiKP8I8yow5z47jkYlhT/gRB2F/cimSmS+DaHhon1iR3Q4oO4BfFU8+ALuKs
         nbpVdTbbW6ie7huU0+FYBIvvpsME3ZUM3MGnpj9QNVTT5ynp47vfsBBxEpdu/TmIYrTz
         QI4kYP3qDiFqSvTc+WOSvuzCjCfExZLUBqKXNiFbNLNURMEskJbk3YeavmvopIsFs8wI
         qmtoCT8b2n2hpuyUL29+E+AySy7pxaEynQvSoyn9DXSPQNA0xngyotVm2Eo3XGp6HLGx
         GCsPO25h/Yqsk/zdM7XPJI8H2b0lvx3XvVwhHQL0gmKhC3t8YFJWmHIitZIuqhyoJVt0
         LEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250191; x=1788854991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7nBgl70e5xfSJ2oqkVr0tglewdp5qWUVF45E6u5ip4=;
        b=FiIbOSjXpIZMJ/O90oADr9/RHsuRWCxhRP80OH5EQxI0/HYfRAYfh/A0GsGt/hDRQv
         et9dYGl17hnDzgahD4GfPjXU297ll2Qk9iKovth9RzSSDfWKgZaAXf1Ylb9bXqeSmX7g
         xoRve8IqZ2RsoPKVR/IlYSp0Fzb91aQxjMPCmE8zzJ6b4NAh4Sfpsbj73zdcFvapRSLX
         kd3YXNr0saexXw8FFa0J862oyvU8ObJGqGvuMbBtTy8Uu60mII+DhXUUdq+qkiYvDeT3
         ysFW7mMDGdc05AAJo92A+yj34FcIIfsebPfHPlwcdmycNXAXWRfEFqX5wgBtY8ggK5zv
         dzpA==
X-Forwarded-Encrypted: i=1; AHgh+RpfOtXPisu1gB0Mo1SSfKW9DOJH538Y2eiBvb7Ap4rPkX7cSgxqcaEP4EB80zZtBjfxesQmGxY=@lists.linux.dev
X-Gm-Message-State: AFuF++lZrFqJGoHanZtCt8+bMfPjpcf7stqD87npA7ndEHTp1TV8fx43
	AjBn9h5z0KFXPwHWL+Ff28YXuWgNt/rT734upCG5YcBKpjiSEBmKg2rXvs9KgiTasW1asN+JFIr
	irp24vTZCgoYJ+p62he+agQ==
X-Received: from wmpx23.prod.google.com ([2002:a05:600c:1897:b0:499:b2be:d4b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b88:b0:49b:4d64:bbc4 with SMTP id 5b1f17b1804b1-49cdc4403e4mr121681065e9.8.1788250190134;
 Tue, 01 Sep 2026 01:09:50 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:24 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-2-vdonnefort@google.com>
Subject: [PATCH v5 01/18] KVM: arm64: Add pkvm_private_va_range_pa
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Mappings in the pKVM private range are not identity mapped, making the
standard __hyp_pa() unsuitable for translating these addresses.

Introduce pkvm_private_va_range_pa() to resolve physical addresses for
this range by walking the hypervisor page-table. This will be useful for
the upcoming pKVM heap allocator.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 6e83ce35c2f2..85f1e3c711d9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -30,5 +30,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  unsigned long *haddr);
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
+phys_addr_t pkvm_private_va_range_pa(void *va);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 7c7ea8c55405..260e14d6d200 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -17,6 +17,8 @@
 #include <asm/lse.h>
 #include <asm/rwonce.h>
 
+#include <linux/cleanup.h>
+
 typedef union hyp_spinlock {
 	u32	__val;
 	struct {
@@ -122,4 +124,6 @@ static inline void hyp_assert_lock_held(hyp_spinlock_t *lock)
 static inline void hyp_assert_lock_held(hyp_spinlock_t *lock) { }
 #endif
 
+DEFINE_LOCK_GUARD_1(hyp_spinlock, hyp_spinlock_t, hyp_spin_lock(_T->lock),
+		    hyp_spin_unlock(_T->lock))
 #endif /* __ARM64_KVM_NVHE_SPINLOCK_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 3b0bee496bff..755630c0d15e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -90,6 +90,24 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	return ret;
 }
 
+/**
+ * pkvm_private_va_range_pa - Translate a private VA to a physical address.
+ * @va:		The private virtual address to translate.
+ *
+ * Return: The physical address corresponding to @va.
+ */
+phys_addr_t pkvm_private_va_range_pa(void *va)
+{
+	kvm_pte_t pte;
+	s8 level;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, &level));
+	WARN_ON(!kvm_pte_valid(pte));
+
+	return kvm_pte_to_phys(pte) + ((u64)va & (kvm_granule_size(level) - 1));
+}
+
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr)
-- 
2.55.0.897.gb25b4bd76c-goog

