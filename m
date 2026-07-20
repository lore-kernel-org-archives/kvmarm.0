Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1153DA5AE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567727; cv=none; b=dsLA6AzwbY8sKAJf4DPtCoupykhKZ0cKO5u4DhhVK+H3XqDeaRXOzHpLA+psk5KIgbtiu6t8C4lIEdKSoE8+pRgSMcapfJDQrcu7K3PCxtVp8pn0/OCyhI6iwfTZilvRYXsefJi3jw3TKgNtK+bPkO1QOWErcHF1hIxAl+5vAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567727; c=relaxed/simple;
	bh=STrNSoaRaszPDCM5qa+W1sX2l8dltFZoaa9YzJXTibY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qaLuaGhS58TYx8xAeQOZ+y1obExcM/6z3mmsJD8HWtnbjynS9qrs++5IQUFA5cqDstU4qIRhGkXFh6bGgYN95YaQgIigwZbefpZi+VTu77gRY2BoruEOuje/EHq38YoIihl/2quo5oK6ry24B7nzCiadJ8HeZbeqUFfhkvwmAOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a4WGapbj; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a4WGapbj"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493bfc3b84aso53560565e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567721; x=1785172521; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4di4LOaQ0A+3KcJ0AQoWnaq05/jwn7QirA2DB77Ss6c=;
        b=a4WGapbjR5vcnkY42fbZOPu5ujIAbtT+Etur9FHRoDZWCPCOdWUxcLe+r2/nAqnRwe
         UK5UAZDp0oOdhersYMLgYRV/Z7TiJHCWJZrqExkhQjcYT3UhJiDf0zBYUfJ4O8NihnxV
         NNIw6yZUPMFVUYHZoFxMLoCaaLjRhE6c6qfchxsPm7c3oB3W0pdIUaS6OI/OrsFpw496
         urtvO+chgeYAlTm47V03JRhYWVS86Od2Q/r6k1Lo+tXx5TP+tXFzlybptCpdDXFhHmCT
         RZ9j7/QEYHSxG+c/UX/lnRw3XYvc90Qiw8Oj7z5VK/yco626RK9LiHqNQy7qLaRzQA1Q
         k4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567721; x=1785172521;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4di4LOaQ0A+3KcJ0AQoWnaq05/jwn7QirA2DB77Ss6c=;
        b=CMr0oiR+pjgXVv/O+/JFpXrjN7aGwloBwNlmEspwkPxb2kcUvbKg/rGcf7UM3znETW
         /DhKLUj1YZ04K3O2wxyEJ/0cyMeXaaBoZGSP3WUMO6Ht46r2YCql3KgT5sr9EbmtiTjb
         teYAOyoKnq97237t2Csc1f7AVewZRP+Er3Op5eGGLyC4PHb6fKMG4A1Mj+8QpS6u871r
         CyUmTsQMxngMJZnhB2wuAWPPLKMIdFNhAQWciMBlpMD6w6Wo5pmdZnf/3EPBAd1ED4fk
         HYfud1RJDF0U2ilSefL5nKm9wBCnb+Cgnu+HXDQq5HcDWSH5ky3rPLLBz8/gCyatlM3M
         DN1Q==
X-Forwarded-Encrypted: i=1; AHgh+RonmqV8DJDSvU0g7GVI1JyLa9L4nJO6FfGMQTfzOcGvYOudcj/dwcLhQWMebp8+J6mdlL0IVM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrebEjOdxLY1JkVdrVBx8cCj0lAq8KmQlwjRjW3DtLOm1Fe4LY
	/wfgGg1Fv0CPsJMzRmef2lLQoNKI+ZAcGCOcl9ig1TwnGr1ajs24Fg6Tbro+OKtJLpr6NU/nQn6
	y3jZZmrtBdenlkOmUvZR2WA==
X-Received: from wmcq16.prod.google.com ([2002:a05:600c:c110:b0:495:43e1:542c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6d82:b0:495:4072:4194 with SMTP id 5b1f17b1804b1-4954a40c4acmr115784495e9.28.1784567720395;
 Mon, 20 Jul 2026 10:15:20 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:14:58 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-3-vdonnefort@google.com>
Subject: [PATCH v3 02/17] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 85f1e3c711d9..00cadd13ee5d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
+void pkvm_remove_mappings(void *from, void *to);
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 8b8c9d3dc82a..5cd2f1fe51e4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -157,6 +157,19 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+	WARN_ON(from > to);
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.55.0.229.g6434b31f56-goog

