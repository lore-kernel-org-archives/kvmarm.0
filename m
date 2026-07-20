Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DA2445AC6
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567725; cv=none; b=BgZ15i5Pex5qogU01u7Gj+Pob57HwiPFqTjscoRJFxNInL66rcBSIKEPYlYGWpA/biVC0CJMXwUPQ6MdMyt8DhhuMmvcG5AjF46rfXiFtrJN6kzKLXmPS8l8WffleXIdiil6Vbd8kH7WApqNSH3rmWfNnER8VdUOaJZcnny/CXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567725; c=relaxed/simple;
	bh=xPhHotVgi3UtDDRRKgaZEXaRB8BvlrE6zwflileImCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MCwHzrA6ag2M8vOC09tk1xKAuzbVogeFwCBPNYP+eSAVD6OPgoMCa0BapgWSE1RH1RjT/seCRA0W7i5dxIb0oxMYHp9WChPug9sG9TpTbJcnoeIAtY9hXFW7eimBL55wm3+4DHlCsMT6VIkujIjOy0JrMcOGtQOVqwUV7YH+elI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p5PzbDwB; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p5PzbDwB"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so6770265e9.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567719; x=1785172519; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o9KxvNMIvUtQq3xLQOoAWnVxOnpsU0qAP80ryNPLHJM=;
        b=p5PzbDwBYOw9VeNt7PRmDlQDgWclCVKFX69kHR61+kV95AllkB9wps7ImcSIjI35y2
         zaVtvpY0INRasEN7us1C0kdxBYL1mOML8EGNLkwIDXMopEa9T+tnulLDR7kC083jkftz
         jvzYajpn444yA8Mxwl2uGy9SR8tY/6eeQFliuXb6I7jC43q6CrkgNKpSTqFVp/H+Oaq0
         ZgGWpsON5OzSrxYxoKNiUVk9YDBz9taLP5w5e/uAQqbo+5dPCpOvhhF46IFzP2F42y16
         IzN7gjNqviGxj7kE6MuGcAdSSdrDowgqnRMCG5EK8sNhlWwsHieay+xPFAchmyVwKWO3
         ciZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567719; x=1785172519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o9KxvNMIvUtQq3xLQOoAWnVxOnpsU0qAP80ryNPLHJM=;
        b=CZDK36TG/IbGInZiseCdWHK8Ok36BETxQH0zRHYy3qvvqIPjoR5TJ3PaB868x89l9Q
         zAwN5a4FS0aoccFcfflRlNT6U3fAcmRrJXN9KD+kcGxEQzYPVQKixOdLaecLlAquksd3
         aHu+HbYWOSvt1eSZUE1NmIoC8rqJOVJptEB3OS6txxCanECZRajq4JrL4fi3nTgaPdIJ
         ZKvEdIgB9e3QQ5tKjqnAyTWkemDFIK9DoZSITGgUWdKneOX4TgZZFBQoMdHPZ8f1r4XH
         jGZQ7Xd5z9dZywXZE0MQ0LF7qQg6UpnyK9igbJKFgtE3zsEubDHBb5yC3rUPF8+0s2yZ
         4BHw==
X-Forwarded-Encrypted: i=1; AHgh+Rolc9LQcz8UskqVBflEVIuyH9aUBGdNY8J2TOF5EpIkpDinE4+9CQDfwEW0f+g19Bsirigs10c=@lists.linux.dev
X-Gm-Message-State: AOJu0YztC0cGOzGnt4d4odITxLQSNVegsogQe9AgDZvdxx0q94pPa7Cl
	py/z+en+MXJ4pVsSQq+P9MnfMJq+TyThZg1rZM0O9cFCCV5mIHq4nCmy64vsNnDkphLo4ZhzYpA
	JIseaFziyIVNoNYCYElM7yw==
X-Received: from wmbjl1.prod.google.com ([2002:a05:600c:6a81:b0:495:571e:e5e2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1554:b0:493:c10c:22f0 with SMTP id 5b1f17b1804b1-4954a50d963mr194510095e9.20.1784567719153;
 Mon, 20 Jul 2026 10:15:19 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:14:57 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-2-vdonnefort@google.com>
Subject: [PATCH v3 01/17] KVM: arm64: Add pkvm_private_va_range_pa
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Mappings in the pKVM private range are not identity mapped, making the
standard __hyp_pa() unsuitable for translating these addresses.

Introduce pkvm_private_va_range_pa() to resolve physical addresses for
this range by walking the hypervisor page-table. This will be useful for
the upcoming pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

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
index 3b0bee496bff..8b8c9d3dc82a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -90,6 +90,17 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	return ret;
 }
 
+phys_addr_t pkvm_private_va_range_pa(void *va)
+{
+	kvm_pte_t pte = 0;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, NULL));
+	WARN_ON(!kvm_pte_valid(pte));
+
+	return kvm_pte_to_phys(pte) + offset_in_page(va);
+}
+
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr)
-- 
2.55.0.229.g6434b31f56-goog

