Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9BC22B585
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014469; cv=none; b=MFait8mU7Z+m/BAyfGLOc5AtHGDlnrXYontdo3aJMvBj2txDlgIBXoOOQyzxbLdRzn19pEg/zVgESA8jHDSyp+7q+oZMeaiiU4hM4iKj+fcZeIcHtFGxOl/fMTnAgVr6VHIy1ED2Hg66uBcqQCTqv9C22ONkuA4wZDbF8e1f5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014469; c=relaxed/simple;
	bh=cSaWMlG3D7f39sDYeOOmQiW5NsLLNPUoCpZkJMcp+iw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hfx4dXpv5D6gtDr5XlLTxxrkwGO+1GLd8G98ayudAS9yNMH6LE2rkgjH5zW1cIQn887tdRSqLFvnSK9d4PDQtJK7ekzsRr0yMDoBznNqo+h736xj4R0JHqhviHqFkSLXxvsjiizqvftKosRoHK8p43rPK2IcIIbW6KzsyrpddBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gcmHLfNZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gcmHLfNZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so27058285e9.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014466; x=1744619266; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRbmnXi/kMVYfkZ+DJBP7bhEsGPG5CEmYLC9waH1gHc=;
        b=gcmHLfNZnvvEHUjL9uUFhje3mRhhvuwT7KupIEX+muGx+qMUKv2/+BCSYaP6ptF8F8
         MFqyfr9AeYYmqn5R1vwrlYvVyBb6EuX3eBDCrvb5YtnSv3/rekZ7UH3DpnZYzQ95hHC4
         GZzdsfh4RPAb13LNMIBULvza8X0aI0v2fyWFI6PY2wDu2KuO1slBzqd3zXWyBhQ5RH0L
         XrzS2Qppu/3RcRM/9Y2jyZdQUlmLw9nTOvXS2sESNYRBag+l63kCjKTAHpsHFZjLKULx
         MogfSiQeRGpjvYdPVQE/Zj9AYduVpzBMxOKedwatHlZyikdCezLULQPVTBuxAhRYChqB
         pqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014466; x=1744619266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRbmnXi/kMVYfkZ+DJBP7bhEsGPG5CEmYLC9waH1gHc=;
        b=n1aiylelbjsd5HS4ZgzyJe5AMHwhe1suSFQ92+q6vw8QnbDvMQkfrFebv7F8JEnj5U
         1euLfeUPYfeXmss8o+fh094lzuQip484eRvUG1TmZmgXjt3uef0Mu/zFxvSMiNvN2ZBB
         gA+ogrrooVSr8eAF+yc3V0IT9zYowBeZmH1AI5+6XTSqngbTP4jrNGDMFAXuif2ZVi9G
         1yRxrS6lTcgENsVP8jYZ/092FU/Yuxp5irOL1FXfnYbHU1z+58SPf/z9ES3ygYR6WFO3
         UAaEEDyRCQQ5BWH9c4xIFbqrH1UL7yYXMEYSwDGTZEWviPM1GHf+4AB+9rNLdocBxbnl
         rAyw==
X-Forwarded-Encrypted: i=1; AJvYcCXg6c6YSYGPfHEOgo9oZtW+h9ywO98UcoYF/qGyp6Iko6xWte/9yjBiN4UjUL+FxXAtp300EFU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8D5fxSd90Y1ffjwCk/hNCk5PIosfECqlvH6Q3gWVti0lR0pSU
	Ft318qq8isRXChmf1nSt+GAAQnP+wT5kCC0fPkhoJk/0Rq2v23VkR/FaJQHPF8RMAUJkmZ3icmL
	f1OyBSykbwqBS6CqgTA==
X-Google-Smtp-Source: AGHT+IEic6OXLHFjJFcSMjX6yW+diABGg79TavoXgMJoLPcFtBwYVwRi0D0qAEBQti0q9fFPcQTMJ2BeP0VaFbsn
X-Received: from wmqe6.prod.google.com ([2002:a05:600c:4e46:b0:43b:c914:a2d9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:500c:b0:43d:bb9:ad00 with SMTP id 5b1f17b1804b1-43ecf8cf6b2mr129812945e9.15.1744014466013;
 Mon, 07 Apr 2025 01:27:46 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:27:05 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-9-vdonnefort@google.com>
Subject: [PATCH v3 8/9] KVM: arm64: Stage-2 huge mappings for np-guests
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
index ad14b79a32e2..da82d554ff88 100644
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
index 2feb6c6b63af..b1479e607a9b 100644
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
index 97ce9ca68143..18dfaee3143e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -345,7 +345,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 pfn = phys >> PAGE_SHIFT;
 	int ret;
 
-	if (size != PAGE_SIZE)
+	if (size != PAGE_SIZE && size != PMD_SIZE)
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.49.0.504.g3bcea36a83-goog

