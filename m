Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BDE190466
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038119; cv=none; b=VgYurW3cZmuJBhSMZ+AUZzb6wb9MjPoK+qch3ASas70anS4OK07YeVTwbbZGEgJTL2yEQdJocw47kBuo31hIylwzrLzzaQX98NAVPvx5ce5LYu9U6olIy6yqa7TRfDvnjnRNQkeT+vWnk9sMPagvP/pCKxyim+JooUv6zrtQj0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038119; c=relaxed/simple;
	bh=kO+V5lywh2xQ6zUlGeGo1/DXznX6QAOefV6EtN6ZZqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i3M0R71ZuaXuoShK2OrfsyBXoRDaDqoRMVp2mhx6cK4ysdV1TOvSrK83sULLOHTtc+5G/ajcyJPZ8AsKnRMkPbZzTfIgyEAF5wROt51D5Sbnz375J/aqH2zdu6ZqStYVbunrv2pTb+hqiM+IQjBtgNzCjcGb3oBy6W3hYnVVtQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QqGSsv92; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QqGSsv92"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd8677380dso10149825ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038118; x=1722642918; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6h2fNXv3Lnt/1e1wvaAdv81wiOKkGDK2sT+OsnVLOZA=;
        b=QqGSsv925EY4VBm1/wje8d1ANavWyWJb4Rq9+b6miGwayAAow+el7ezD5GXEWuzphV
         SOdreGZ/SEKFel+9hTi/DHEfhimrxBMj0eq/7ihqQf5+iQOLXzGJ+UbT+8Ct3uwWwaAo
         EcZREnn6I+G5dnHJbuJQ3U7QYLws+Z2u0XJ4XTL5q1YqxGqT8cjIUksJQ2XLX++TLMGB
         qXKunn7UKAU5KiAoFTJFfT/TqG5llPoqf6KGDM/iKpUI4QJpdpSHEqFPkxzWHM5YRr+5
         af3vJVjTDmhj2OpN4YQLN50UH/FZ7f1BFBrhKhc1IziK/y+AQH8zzwLorRXtTNzNnJu6
         I01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038118; x=1722642918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6h2fNXv3Lnt/1e1wvaAdv81wiOKkGDK2sT+OsnVLOZA=;
        b=VXowGS7fIVCOK/TtXQwOYEvTwikUqJMW9PrtAmq/1zdWkxXlFqu1jdJNe2eykotutL
         vgJahtkqOF5BirWJBW5jdRKMNLmfZRkH6IrRLompfxhTrP/gkqpC8iZ1GvQSW1JLSgyE
         jznNdBeq5tUh8DNh3D9F59EK/cme36SMpJarGvi5MrFYJdzbIussUIZpP459ScfQQIu9
         rFwNzMlMItdapvsGiDKsGQGI+FKUlblto+J1ZpiZ1imG0JvD4LLZQ6HbODfoEvBXc9hz
         g6JsMTMaH81+TtigAwUhX13F3rsV0vgCKjmOBXd9k6tc3abkD91KCurJwAH//uhCxMVq
         2y9g==
X-Forwarded-Encrypted: i=1; AJvYcCXCr0Ru1MhcwjxI+JWBJ56cGPrxVTKV40ou5gWb3nj7X9aSxmV+Iie1L4obBCpyd34rOfNBzeLO59Zctv24eFFcGWJLGkD1
X-Gm-Message-State: AOJu0YwjHA1fn/cillfxnDaySa58FHt9EsZTVJjyGC4xnIAJpQSm7SVm
	p8em5jnW6ExKg4VagOaU1KFOaFQMroCvmJBrL33+rB/yW2+RiUQYs/wkZ2tLpwjB6ZEHCgkU5q7
	5Qg==
X-Google-Smtp-Source: AGHT+IEudPW7JEwYI6UrgE0ex8JC6EzLtvCIl4+qVoUW1lZq2cn7k6X5ytnrRNqYuzfOTIfNZ2CfrPbG7k4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f693:b0:1fb:b3f:b9bf with SMTP id
 d9443c01a7336-1ff046e1217mr520495ad.0.1722038117916; Fri, 26 Jul 2024
 16:55:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:26 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-78-seanjc@google.com>
Subject: [PATCH v12 77/84] KVM: PPC: Explicitly require struct page memory for
 Ultravisor sharing
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Explicitly require "struct page" memory when sharing memory between
guest and host via an Ultravisor.  Given the number of pfn_to_page()
calls in the code, it's safe to assume that KVM already requires that the
pfn returned by gfn_to_pfn() is backed by struct page, i.e. this is
likely a bug fix, not a reduction in KVM capabilities.

Switching to gfn_to_page() will eventually allow removing gfn_to_pfn()
and kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 92f33115144b..3a6592a31a10 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -879,9 +879,8 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 {
 
 	int ret = H_PARAMETER;
-	struct page *uvmem_page;
+	struct page *page, *uvmem_page;
 	struct kvmppc_uvmem_page_pvt *pvt;
-	unsigned long pfn;
 	unsigned long gfn = gpa >> page_shift;
 	int srcu_idx;
 	unsigned long uvmem_pfn;
@@ -901,8 +900,8 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 
 retry:
 	mutex_unlock(&kvm->arch.uvmem_lock);
-	pfn = gfn_to_pfn(kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
 		goto out;
 
 	mutex_lock(&kvm->arch.uvmem_lock);
@@ -911,16 +910,16 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 		pvt = uvmem_page->zone_device_data;
 		pvt->skip_page_out = true;
 		pvt->remove_gfn = false; /* it continues to be a valid GFN */
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		goto retry;
 	}
 
-	if (!uv_page_in(kvm->arch.lpid, pfn << page_shift, gpa, 0,
+	if (!uv_page_in(kvm->arch.lpid, page_to_pfn(page) << page_shift, gpa, 0,
 				page_shift)) {
 		kvmppc_gfn_shared(gfn, kvm);
 		ret = H_SUCCESS;
 	}
-	kvm_release_pfn_clean(pfn);
+	kvm_release_page_clean(page);
 	mutex_unlock(&kvm->arch.uvmem_lock);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
@@ -1083,21 +1082,21 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gpa,
 
 int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 {
-	unsigned long pfn;
+	struct page *page;
 	int ret = U_SUCCESS;
 
-	pfn = gfn_to_pfn(kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
 		return -EFAULT;
 
 	mutex_lock(&kvm->arch.uvmem_lock);
 	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL))
 		goto out;
 
-	ret = uv_page_in(kvm->arch.lpid, pfn << PAGE_SHIFT, gfn << PAGE_SHIFT,
-			 0, PAGE_SHIFT);
+	ret = uv_page_in(kvm->arch.lpid, page_to_pfn(page) << PAGE_SHIFT,
+			 gfn << PAGE_SHIFT, 0, PAGE_SHIFT);
 out:
-	kvm_release_pfn_clean(pfn);
+	kvm_release_page_clean(page);
 	mutex_unlock(&kvm->arch.uvmem_lock);
 	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog

