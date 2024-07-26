Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2302818C325
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038094; cv=none; b=ErADfpyT9UCX638TdOwSp3UC/KKtzg1gX7rzZXn52qgcgZkHOWmMHeQtwMJagidYqaKZScP17laGEwdE7lRjh9Q+FietZiOVLyg1TEiJRlIsttLAJwCvnhkK9NBJdJFvJ670f33RW2Tfn5EOAZL0PYdwCZT/1N/3MZQ1HnnSjVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038094; c=relaxed/simple;
	bh=Z7iItHoG1Un0PHfLJEkTiTxR+0KDEJBb6FOtFGyXsoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RjyhjzgddojLWETebr+khlqAn6lbzHFgfF1HJbzfpUumYW/8SLsST+3ecvq0p9hXowef4VYOZflo7BiIehWuClWDlWhQ53fd+RyZAAw+7neMdq4FpTxjGPo0mA9IodsH87cnPT5201GiGJDcf5+dAMphAfWtiKx35462vUs0QVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZ5A2/dG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZ5A2/dG"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5f04f356so10598445ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038093; x=1722642893; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rpwXsNxFJqP0CEr/yEQ2h0r+lN6KBTuvETCSKMoe8FQ=;
        b=BZ5A2/dGmDxLMUl8tn73p4jpwKMHuTGLN9EfhqIBjhSlZNwQ8CUcKB9gArxcqPfyxZ
         zwANSe9BF0aNkYLD+IGpokagIt4lq0A7y4vDVYIrHV3/8tIAw1zYL4wC84DlYQihA9rk
         CDQbgqJyV6ZPyG2U25J1OkBOfQ2I2A2YuZk3kB0VKZaAL3Y/9GP6bCginj8HKUneP7YY
         NRE3LfLwuNUbdyIimBsfsrKzO2jtydSNXjy1j2I7ap6ny8XIml3DGJPb1bojqffIKGTD
         vMEz5K4Fp39kGxTfZ+RGc6j/ITPpBzdITsVbDVBCKrS4se04MdIFOMz01rbVFNd2gFY5
         Vgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038093; x=1722642893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rpwXsNxFJqP0CEr/yEQ2h0r+lN6KBTuvETCSKMoe8FQ=;
        b=kzW94Tj53coAwWlD9NKzZrylgSy02w8kZHremyFAz0Xok+mBYCBxWwtoCbTZcGJ1Cm
         b4fRiVWDgQkg8TaiFhbcY1PHHM0T2CJcWcYI8hfneqnly99TziQVgHQkQ6sVeevEpikf
         KMZTr2iNjudDb3lBjA+kgIAc4AXWYngS2FaxYuC5wWUiH25nN0TzQXs/jCnx9H+A2FJ8
         5UzUPKwNJLjpkEW9c9xv7idNfx6suckZFVVd7CNtYbY/1LzsHXl8CXml+s1DOYWYbkie
         siCuSKybXmTvrikcC48O33pIdpKdQ3Y083AVGpctGsniuabCTZkzy5zpIHGg/eFSDFpC
         NXFg==
X-Forwarded-Encrypted: i=1; AJvYcCWyMQsJ62KHZrFgE1fF9FENEMPTah1xqK+A7jI7bKlaw2UmQLuv/+xL0uhBTZ5YeWaUMmwfI/buRsek7kffvGQy5pXtOsId
X-Gm-Message-State: AOJu0YwPT38ONZigE0BkhM6wxRUNZPsyfXIxQAOW4OJp+yJtmEIybU/4
	Fw6o1XnbIOaFZhVCYpDryWYgPmvSQeiBeW/b84odufwBM/Jmb5ixAgFOfPPWIYIgDC84qljt7jp
	pJg==
X-Google-Smtp-Source: AGHT+IEz1qMb/9xSOR6pziERGmR6RlcO2d1FpOxR3ZCse98fOqCGJ5ia3ZBUMMNkI3e0ioyh2oD8FsbOxx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:1fd:63d7:5d34 with SMTP id
 d9443c01a7336-1ff04803eeamr27405ad.5.1722038092373; Fri, 26 Jul 2024 16:54:52
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:14 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-66-seanjc@google.com>
Subject: [PATCH v12 65/84] KVM: LoongArch: Mark "struct page" pfns accessed
 only in "slow" page fault path
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

Mark pages accessed only in the slow path, before dropping mmu_lock when
faulting in guest memory so that LoongArch can convert to
kvm_release_faultin_page() without tripping its lockdep assertion on
mmu_lock being held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 364dd35e0557..52b5c16cf250 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -552,12 +552,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 {
 	int ret = 0;
-	kvm_pfn_t pfn = 0;
 	kvm_pte_t *ptep, changed, new;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memory_slot *slot;
-	struct page *page;
 
 	spin_lock(&kvm->mmu_lock);
 
@@ -570,8 +568,6 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 
 	/* Track access to pages marked old */
 	new = kvm_pte_mkyoung(*ptep);
-	/* call kvm_set_pfn_accessed() after unlock */
-
 	if (write && !kvm_pte_dirty(new)) {
 		if (!kvm_pte_write(new)) {
 			ret = -EFAULT;
@@ -595,23 +591,11 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 	}
 
 	changed = new ^ (*ptep);
-	if (changed) {
+	if (changed)
 		kvm_set_pte(ptep, new);
-		pfn = kvm_pte_pfn(new);
-		page = kvm_pfn_to_refcounted_page(pfn);
-		if (page)
-			get_page(page);
-	}
+
 	spin_unlock(&kvm->mmu_lock);
 
-	if (changed) {
-		if (kvm_pte_young(changed))
-			kvm_set_pfn_accessed(pfn);
-
-		if (page)
-			put_page(page);
-	}
-
 	if (kvm_pte_dirty(changed))
 		mark_page_dirty(kvm, gfn);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

