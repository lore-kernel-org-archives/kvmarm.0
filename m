Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453F8171C2
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065327; cv=none; b=A1cOSEhL6Cxhmx/MAociBCYvEJ6sK+0IJ4iOFvmr3q8UmFRcD3eu0ZUqf2yngf7nQNP+ooYPAynY9r04r9p7H81nOg7SW0oBJgE0/WKdQryC5+WHUUHUAi0AC3mwoyFUitimOcvPHdcWP0u69Z4O4BVln3Qqc59TrWm8/jc/hV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065327; c=relaxed/simple;
	bh=CwLkYcmzZttiwi369ZHLZf654OyS2he0I+I/bemyL94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EZDx1kPryhI+ci16Y8DPag/FpohpLDtOgF5xd95klee5/f3bOiVlp305N50gfbV5q+ZfAi639nW26ugpAVqg7qZ0gT6+Y5DxICZx29DkG7Q1NtYhhVvioUa2ZjqcgYYn1CUFqho9DDO7WFQYoWqeWhKW72ASk/D3+mE6UHIt6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jaPzILNq; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jaPzILNq"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a0841402aso82809467b3.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 17:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065324; x=1718670124; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HV93t1qtvLY2HqXeqD4WwNLQ267HOmhqjDYyVDwgnFc=;
        b=jaPzILNqt+ByoMLkLNU+p/wzAGqu5V/ulyq5xb7ckzuq5pLdd+2gTQSTvRTrMCXO0b
         MkVuBAvT3TQiixL6cF+mP0dbscbEk5dCc0gjPhseLV9QfypzrkmGJlhRpt39bAel/fc2
         roqbLN3U/UJRZHPn7RcdktxOAgrQuOVHaSkOhnUFUA/9kLSsmlMBtQBC0JMjXMaz/Jvc
         z9Q5zv0ucM4wnBdTP7cTa+hZYrb3NRmjhDopBJD34tXv7zdXSIJMMhVBW7im7QTulSYu
         xvnX/GMciheg4gGF44ZLQaw7loHYLfFGyh33bGz63qLKHN6+Q7AvuKm9iOvCUGl6WdO5
         dobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065324; x=1718670124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HV93t1qtvLY2HqXeqD4WwNLQ267HOmhqjDYyVDwgnFc=;
        b=S4RJLNLf/stYJe1NTBaTSkR/DSV8dgTXoVzywZ7Mg4SF0bRs0um16xDtNqA4f+/pOH
         LwMS/0nl4d19+Eg+rUjwThOQe0iFC7txZIO4rzOWhnPX2TQku4GP1FYICTo5n68cnXMy
         5TcMZaquVcUrfqLU3UbyAjmv8XRVNTK/P6vuqj+EqPwnSeryThnxC4bOEfgEvCh8T6L6
         NXr/dAnN72PWlpeyNimGudcICNrxgPqs36OaCg9O/F/kZJE4quc2gZF4qR4BlJo2UCL2
         VZg+fcX/NhnVo12+SI3huH4qL1IzjgZb2ZcqOfMqNKifmzUmPQOrSsULR2FTwhbX+C+b
         XtJA==
X-Forwarded-Encrypted: i=1; AJvYcCXbM/mo/TVsLGqzHPJ5xfOBeekZ+K52PIyOmT4XsnyvriWZwEZJgBgP5vIeqARSq8svst8AwPQ7ikyZPNUkjG+6n/qL+dD7
X-Gm-Message-State: AOJu0YxW0wfHQKNSq0n0OTuwpAWvmepH8Pbpxd4o4HTqIP++BXdhn/dY
	1IE8rJ92e5Zs3iBe6gqx3NNh0GdfGKsTKlRlhbcnZXo7YyGh7SQ8b8iLgQljx8KYEmhgJgQZUPm
	Xrd/eh7mP3Ns2ir1aBQ==
X-Google-Smtp-Source: AGHT+IGdrDSzxMWV88JW0LA6UnAEJXd+QZJzNBe66poa1GZZ236cqaZmaxZKOwtkV9plz4I87xyLdQPCAlnoV8zg
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:38b:b0:627:7563:95b1 with SMTP
 id 00721157ae682-62cd5652459mr33516247b3.5.1718065324168; Mon, 10 Jun 2024
 17:22:04 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:42 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-7-jthoughton@google.com>
Subject: [PATCH v5 6/9] KVM: x86: Move tdp_mmu_enabled and shadow_accessed_mask
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Yu Zhao <yuzhao@google.com>

tdp_mmu_enabled and shadow_accessed_mask are needed to implement
kvm_arch_young_notifier_likely_fast().

Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 arch/x86/kvm/mmu.h              | 6 ------
 arch/x86/kvm/mmu/spte.h         | 1 -
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 011c8eb7c8d3..0dc1fa99cdbb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1855,6 +1855,7 @@ struct kvm_arch_async_pf {
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
+extern u64 __read_mostly shadow_accessed_mask;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
@@ -1960,6 +1961,11 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask);
 
 extern bool tdp_enabled;
+#ifdef CONFIG_X86_64
+extern bool tdp_mmu_enabled;
+#else
+#define tdp_mmu_enabled false
+#endif
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2e454316f2a2..267f72b065f5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -271,12 +271,6 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 	return smp_load_acquire(&kvm->arch.shadow_root_allocated);
 }
 
-#ifdef CONFIG_X86_64
-extern bool tdp_mmu_enabled;
-#else
-#define tdp_mmu_enabled false
-#endif
-
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 52fa004a1fbc..9ca6d80fb86c 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -172,7 +172,6 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
-extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
 extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
-- 
2.45.2.505.gda0bf45e8d-goog

