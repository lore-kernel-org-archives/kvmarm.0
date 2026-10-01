Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A35C51DDE7
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864943; cv=none; b=rXdLWALq1E8MAiBTTuS3hUr3c70QnrfWg4KRVkWSCJEjGre75mRCkz0Kx0UoOvMtuI8FmJ9VWd+oucjMjImOgwiWONNQEpN+TKZN9y9nbYoyFGbIOanCIBRvYwZuyz9wZes8nfZ3rVRkoGuDnLfcxQxKa4YF8n03KptCRZa0NEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864943; c=relaxed/simple;
	bh=uNc/EEEkHaZedSUCgutma0rSQYfZqQeS1apOBJquisc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OXWpBkJoG7zdqLjW8daisDll4tEDV8P4IjgAuQx1Yg6oJvp+GLvmEEQM0OJrDbp/PZVWhc04/Pr12gWVM8r61d83n4wHadFPGRpANkSHvQSrsN/S7g4RKy6OU0cr8srdtjeJmvgQhmybot7uT5jyiO7cFuAbKwUwpmq+uFXSowg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmMHvz/b; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmMHvz/b"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49fff093efcso63576595e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864937; x=1791469737; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xja7oOYe1wLd0F17wIDvUHEjaF9yTyywp22WM8XtFA8=;
        b=fmMHvz/b8/JVlOFhQvkHxerM9yqQyGGn6ZBc4YByVygf6JcXmqSEymPG9plq3KgaQR
         872eRPcZEm9R4EyDSxpnBXYY1/CH/GOd2sjR/GR8olnz4XExLTnNytDM0k4KeqdpwSjd
         bUQlmrPr2oiu/Dpan+LprrhywlNAh7DMIBDsxR6YDCa6yo40pdgM3tKANHT//eGnNj+a
         lbPs+TzSBesSerMKIC79TiZBw6QCVkc/tqh/I58s2gkt4b03DM4+kgHy+w/STJ+ooQhW
         Th3SU/oaeLzqf1aWQRcIjxXVOtZ+4uUxP5k1nX/Y+uWYlYiNX0jaK3zTHIhwNMCG7Wtx
         9uAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864937; x=1791469737;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xja7oOYe1wLd0F17wIDvUHEjaF9yTyywp22WM8XtFA8=;
        b=u5ylZPLW3KSFpxyVfec8xxDo4upFhFVmrtFfyIcOVoyqKhESj9RLF1Zl+tnRuoMDyN
         +/JBaCOF8mmHGI52uJa6pbPgAv3+wOs1G5vIjTEhZRakOr8scmdvbBVyrOujCLeEc5X3
         lkN+rJ/MGKdWw4fP6e20OZk6kI3rPcrVq5TfuJSL0kDMBUz9lrkiEyUTmP4GGdS4ViD8
         OEE+84pvhU45sNp3uHv0Ndpi5AgJgTsLMLF/968G+EaR6b5mqhsmG4DpX8Yni7YjnVh2
         udUvUL46f98Vx8fNYDwg9BkiZfWENNlCkTYuZgIx8mC7MDS0dJlBymyCmvBRPTQb7hUj
         dhIw==
X-Forwarded-Encrypted: i=1; AKwUvBwBgcEmvBSV9yzu9RnSVi8SbolPkPDkXzwSZXRa9N4uuGzPLtfPSdpHUck5FGbLn3hwZWtd4/Q=@lists.linux.dev
X-Gm-Message-State: AFuF++nJdAGZ8U1gNRHqugoy/7+w94ktCjDSnOB9jkunyJdGCc0EARYk
	dn3z6FWO6IBKfC/GJQvhXp3J5EFzAAUNl3mq3gfKItBwEEdF5qC5WLB/6noezu0xfyrUxdaeQOF
	fpmj9Iy9tdEwy+gvfT+NoiA==
X-Received: from wmoj8.prod.google.com ([2002:a05:600c:4848:b0:4a0:dbd:50a7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4505:b0:49e:69ff:c6b1 with SMTP id 5b1f17b1804b1-4a01b006b82mr77675755e9.31.1790864936388;
 Thu, 01 Oct 2026 07:28:56 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:32 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-2-vdonnefort@google.com>
Subject: [PATCH v6 01/18] KVM: arm64: Add pkvm_private_va_range_pa
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Mappings in the pKVM private range are not identity mapped, making the
standard __hyp_pa() unsuitable for translating these addresses.

Introduce pkvm_private_va_range_pa() to resolve physical addresses for
this range by walking the hypervisor page-table. This will be useful for
the upcoming pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h       |  1 +
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |  4 ++++
 arch/arm64/kvm/hyp/nvhe/mm.c               | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+)

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
2.56.0.rc1.315.gc6ed9934b7-goog

