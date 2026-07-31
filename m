Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B541A41D102
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508559; cv=none; b=si9rUVkH7prCu4SXvsCBpGWRMrDQrQBaHuCygx1hhEeTW6MDWnbnb94y4idORSo9ca8V5jbBcOKz3iPSyhG4ha4On1taNCvDuBsM1fX8/MCCk2h7UJTDka+QPNtsLDx4GzjmqamZnlluhiSMAtprMKNn06OOHeuamQWV8ghFLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508559; c=relaxed/simple;
	bh=to2rI2h4oLld+0SrlQnfC16iYGzpPyYDBokx9ar8AcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hzjmn0idygSXQ6XlGatSVQIQ2Y3/VB1AzrjTaNFN7DVZz8yOx2/MXhplTk5MaYvJvl43A42eDtY9BwXbCpdZd4p9honU2XksB6q75Xg7lv3MnnfDTjz8ywGwFVrLl3YryNIhL4+fsdDm4tBDobYYBVW6sMrXO5VPTL4c6C8YD8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ExrhX5eL; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ExrhX5eL"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15ce19923fso96479766b.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508556; x=1786113356; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qKOwBg8VjRp3KcPnvImzU2H7TkPNw/D0Sb8YPOClQWM=;
        b=ExrhX5eLLNND7q0JS5B4wVcmge+whP+M72KJ0qc0rFfrUFoOZV7hVuymM7vRoRpK5V
         KpscarAA8Lnb5BQPkPt3AKgYtS4pkqYXHkjoFj0AUhXP4ZgaVq6pAFWWUePg7nJo17bg
         ta7Wgzo32L1FmTyz9zdyYKKGG2KJcat/bJTWd8oURspWt7bWLUAmm4nhKcr1+9Gtukeo
         EBDHeHTfcF3/BwqSJcs8KyOwoUL+nyj6btzfHfCVlc5tpMu5K1ouq7HKxQW4g9ZM+5Fj
         aDBY4hiy6KL8ArC2nl6NxPd817DPZAeixO6A0Ih4IuM7XoOQc+HPUogcUxB9nh3oc0H/
         6FzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508556; x=1786113356;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qKOwBg8VjRp3KcPnvImzU2H7TkPNw/D0Sb8YPOClQWM=;
        b=qKgDKfJQz/affpx2x+v4QmYv/TxK3BCHr1/rnIdGZONIN1udFHc1aIqumAuGQyAwLK
         e7l94HournkRg7mOpAdt8TNQaZvR/66iaHUMBo0QtsqScZnYB1JdPQe+RskxWNUBPQRe
         bA+9D1zkv/hX982Mh8c+VKX3gTg0FEJJjrjTfKNha4huQ5mDxWQmoY//uciHTkT6KKTC
         ezalqxlVzoySRUmcVfxnsxs5VAv1S19hOxu5burNS5AYx72phQAkthDNOxz7kaU5aXDk
         weD1gCF+PlNGDEZA36zKBP3meGyF4xdCWRzCBg+DeQYAwX4QeXLB7qFTnbBeOua2etnb
         YGGA==
X-Forwarded-Encrypted: i=1; AHgh+Rpf4OZ3iUyvIXDBAR6oNpcMKebBmkMB9JvvLmt+ptYshZ4PSWuJOeYde8u6QB1tCao0Nf2mJ6g=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo0mOoXaaSrOLV2qo74asrImmNM0ZRv31S6WSgk++Tvz89mIto
	Y2YIIwRjdXjvQ/K22VFtOgUb2ohCQRsqBP7DPIJWvaIx04K458CxiR/A+umEIVevcWB7yK4solI
	ZoxjWcSBaIxiHjDg/9wGT+Q==
X-Received: from wmcq19.prod.google.com ([2002:a05:600c:c113:b0:495:3f99:8463])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:fe05:b0:c16:19fc:9976 with SMTP id a640c23a62f3a-c1fd26d6344mr149012766b.53.1785508555746;
 Fri, 31 Jul 2026 07:35:55 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:25 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-2-vdonnefort@google.com>
Subject: [PATCH v4 01/17] KVM: arm64: Add pkvm_private_va_range_pa
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
2.55.0.508.g3f0d502094-goog

