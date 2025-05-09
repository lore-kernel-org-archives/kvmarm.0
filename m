Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FD295D8F
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796651; cv=none; b=WSDLFJQr9XuTPdX8rNIBWBe5bW90WB7zFansB1E6E+wSn7yg3154y+pBB42x8yRhSLJ2NzY5555hDU/Z7evQmpOeopq1BUTn0pCNPQ4+yMZAMVMF+XPSSNNpxZuyCyN2PM+QmNmUR9LtcU4dt1KAT3vLt3ovS+5FBodfFvku2RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796651; c=relaxed/simple;
	bh=4XzFUi2IUGhuTAc22HpxKl0V29jC7HNRX5NluMAstk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A5L5A4dA5QXTeajoKOW1ryzWLWK0UU7wTiYo4cyKgAlgwE3zIt7E99u5oeWNAaENsJUMFLW/8iUeGVSJecGbkDNjrK1CnP8fIN4t6hanJkzj5akQFtv9vD/cqE2RKhEe5zCHFQ4GCTwtse3RpXxrGVEOJ3DKFJWmsdd0rCUtel8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1eXU7mpk; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1eXU7mpk"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-441c96c1977so13845655e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796648; x=1747401448; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iY9xHEFUpTNbpzkbkz6w6fJAjv29kAFcmljY+gYvWx4=;
        b=1eXU7mpkqSDy7zV8xho/Xmy3K1AEmZS8azE7QJDF0vP6VHcOqtILMAP+2PzTAF1NHx
         JlkTqaCvMiii/4bbHndfB06gldYsqNIwG6Jklg8Nvz50d10bGicRdoD+ihUiUaI9P5xS
         DS9nvTqRxVqxFkmkZERTbHtCA8pMe78jVFXNeKYUi1UV9LsPtUageqJGmSKqrI0RnSCK
         IFnWlJ4rIUm6vSf2rgwT2qJ4mT8AaCgjjGXHtGNQQL4d1FMUkGIoB0N4gmL0nKHACLY0
         XggjCQ/GNf3WrH07rkK/o8rG4+jfB4+zbsaZLme/YvudyuZ7q8vnMZYjQRHQ0Bjzlpy4
         jQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796648; x=1747401448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iY9xHEFUpTNbpzkbkz6w6fJAjv29kAFcmljY+gYvWx4=;
        b=ZX/RCkWkBO0tznIc3ijXnw9xPtzvxqbBiictfCExvYVeBuuksg7nAfmRTGbIvZSFAz
         5K2TfdpwQnRfXg1UeV+itDMb5ntPCheKVRMFiVxwhFGas/MqLs47U1XoSPpRx99kA/jn
         fEd74gIV8vyW3EgYZh7gKu5hvFRaX+0KAxRoyKldObVkgWW6GSu5OadBRBNl0OMrXgTf
         2s47Qemz9p5UbUqPcARDQgJrF1AOpih7jt5kKGw+2NpmGT8wFQ75DEVplU7pV9EMvho1
         vK7/bAQ3ItcoaK7w7U2dMiugwYnI/TzxTkY3eLw21Rs7iyRQRcAR0+cGJ8ZkKW6iqdH3
         ARyw==
X-Forwarded-Encrypted: i=1; AJvYcCUFFr/jMfZ+0G3Y5UIXHo1cQ/I//ew2emZikNFZMg1WQfuCJ/BXYg8jk/qIRurPura58C5pYAc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlwX1GMDKBux09J658NEzYEzuzJfvY+O0hJneWU5nSa3xtZhdn
	PcOXsNH2KiPkEX6QFlW49NZmWpVjMTpeid2TWcgS+CrpItiPvqXNwFuF6UiwPECcYGOJG/k9lH/
	lOrmz2vr8Qg8WcjABFg==
X-Google-Smtp-Source: AGHT+IEF+XO6uPZe1MEto7eLqAL+0iiIrzIwhxZbJdzOlJd1PeGxlk1/ZzYpvt4tHE4RjgjMniLCrdsLZfZB2R8i
X-Received: from wmbdq15.prod.google.com ([2002:a05:600c:64cf:b0:441:bf4e:899c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e8c:b0:43c:f969:13c0 with SMTP id 5b1f17b1804b1-442d6ddec16mr29442225e9.29.1746796648033;
 Fri, 09 May 2025 06:17:28 -0700 (PDT)
Date: Fri,  9 May 2025 14:17:05 +0100
In-Reply-To: <20250509131706.2336138-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250509131706.2336138-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-10-vdonnefort@google.com>
Subject: [PATCH v4 09/10] KVM: arm64: Stage-2 huge mappings for np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Now np-guests hypercalls with range are supported, we can let the
hypervisor to install block mappings whenever the Stage-1 allows it,
that is when backed by either Hugetlbfs or THPs. The size of those block
mappings is limited to PMD_SIZE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 78fb9cea2034..97e0fea9db4e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -167,7 +167,7 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
-	return true;
+	return false;
 }
 
 static void *guest_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc67..7c8be22e81f9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1537,7 +1537,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1547,7 +1547,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		if (!is_protected_kvm_enabled() &&
+		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0e30f16149d5..9504169fb37f 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -328,7 +328,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 pfn = phys >> PAGE_SHIFT;
 	int ret;
 
-	if (size != PAGE_SIZE)
+	if (size != PAGE_SIZE && size != PMD_SIZE)
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.49.0.1015.ga840276032-goog

