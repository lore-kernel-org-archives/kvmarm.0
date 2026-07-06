Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E9A3AA4E7
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360466; cv=none; b=JeqtIAKVrkNE/+PXnSpR+Zuoy9iAV4Wa7jdQFQTEThB3CvlX81+bKiTIk/DgsNjsZd/VWb8Ghy53rq7LJLlUeKpJ9kLW8P87XmdvYHr0x1XgG9pjAm6PKS10mvxd/MHcvuYivVV+VLc5jsWaPxFz52SQOghV5v/Uyb10hd0ZA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360466; c=relaxed/simple;
	bh=50idfbBTpnirHi0gW1qRmwGgWNRBskkmBo0Acc8r53c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o5IoI/OBhnq+YUmlFvT1hP/ljwLNL4Y09V1CJUvbP02MKWDVLOm9jLgDMOapydwK+Q1XkHmoKwc2vBjYPsJewQDlQMkfym2+DA/mTo0C4YljmfMNet9rHGhXWgIlCAm3oEgQ9SQB+RynQz3ljhBSlorumXlspH4MxwxQ1P43iKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PqLhqELW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PqLhqELW"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-473de38dcfaso1870998f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360463; x=1783965263; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8PDm8oG4+65SlSCHXlAGQHcFz/7pVlJ6WK47/KCblA=;
        b=PqLhqELWiQ4d2iYKMDCwjLqnyOE093PeQjyJ0FXxulkuui1G9fAJB119wzqazds9yY
         5JcI0p7oRdZXAzOBgEhxSnrlnNg7WMlmsBw7d458+bw3P36o44wT+8cebUQrqU+jSgOP
         gmID3v74gNEzRZOffQGSiAzjWiX/1JN9uldEhfdV/ggd6WwOEXvAtvFmSnBmJz3RRh6Y
         +50rK6iqd0q0FjmS+kCgWlwSVQjs4OyqQ+uhRwpbA6WTdqYo9qCN4czpHWyPWQ31oWfE
         Kah6v8fXLAbnKjqP/dfOupgd+4ofFiRsrT1uhhkILVlmqN7KhdaT121pF7Mvtwk82bvb
         4jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360463; x=1783965263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8PDm8oG4+65SlSCHXlAGQHcFz/7pVlJ6WK47/KCblA=;
        b=jxMlv1zJojVz7BlXl5UeA1n7nwRl48otPrtqTYAFYbQQHZxLwwHdIPuSEGkSzZZQTa
         7j3gRjPXcXdFo/OBNRTIdMGvLfIR1bZLSeRmYWNoel1ier2u0UIcodhuI5MTFGY39sLM
         E5eOYPWp/OIXOSEgMB6FqUKQ2KZ+JIxl6PFOdLTobfHpxLK943wIkdguCFXcs9DAWWVq
         fTcR30gSFFETq40oYZY0s78nw5/AfaWcdhTZ7zw61eTMEP6NDH89pvI5+So7PhEVA+Ob
         P37Ew6eB5zBjXHWEYmyV4t+soK3eZxd3HVFGTOU/Rq0IO9oHtFP3JLrUNGtGyU0K4xSE
         hu1g==
X-Forwarded-Encrypted: i=1; AHgh+RosW0o3Ab5uElgcTL169l73UFahGTcUIYltImh2CCfnr6qgffYRLBP7IgVY0b0PIXJtFGKAl+A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg900vtpXvpPq5dOUG87ulInAbTujbgCKWz+/gzjujZpqshb4W
	qVVvZSOQcJ7g2ShgxerzSC7sNjIre2XVaRjrbXeTWr3suRWfEiBTJNROrr19t5gi+qDVeSqV0c8
	wZjl1g0+jW6VWAjUY0CjusA==
X-Received: from wrsb12.prod.google.com ([2002:a5d:45cc:0:b0:473:1fcb:48a8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e4f:b0:490:b189:212d with SMTP id 5b1f17b1804b1-493df09a140mr16985925e9.33.1783360463046;
 Mon, 06 Jul 2026 10:54:23 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:53:58 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-2-vdonnefort@google.com>
Subject: [PATCH v2 01/18] KVM: arm64: Add __pkvm_private_range_pa
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Mappings in the pKVM private range are not identity mapped, making the
standard __hyp_pa() unsuitable for translating these addresses.

Introduce __pkvm_private_range_pa() to resolve physical addresses for
this range by walking the hypervisor page-table. This will be useful for
the upcoming pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 6e83ce35c2f2..d3137c16b632 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -30,5 +30,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  unsigned long *haddr);
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
+phys_addr_t __pkvm_private_range_pa(void *va);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 3b0bee496bff..773426a68d2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -502,3 +502,17 @@ int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 
 	return ret;
 }
+
+phys_addr_t __pkvm_private_range_pa(void *va)
+{
+	kvm_pte_t pte = 0;
+	s8 level;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, &level));
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	WARN_ON(!kvm_pte_valid(pte));
+
+	return kvm_pte_to_phys(pte) + offset_in_page(va);
+}
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

