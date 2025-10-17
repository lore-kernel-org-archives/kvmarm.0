Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7759242D89
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661180; cv=none; b=HTXVJUnhT2R6y0ILS8UABdlsfLPsvigyLL3ogP1MB1b7O2UADOkiNxn7D/z4b6ULlKLl/1g2Fx5XMCSLjhOdEqmJIk/Y5jU2RoypE97TJihmj1DeT6XuTmvye5/3Q86bf1AZtFW3BW8CI39AAcnetaedQsy2Coptja0nE+jqqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661180; c=relaxed/simple;
	bh=lN6TxI+PfhLHjdoqy+h+mIIhaLO+a3s8opjxmb2B/Lc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1SCar/h+n0uygYyrrcrGn9nd5I/YGNgxb6HBGXNjLpFX4nyEnbs1wGh0vCpjHeylcaBpsDMOPk8bpP6mp57tvXpUt/K5ZDC8R2KcFTaAhqGI//kcnNYCJzqv+Uy566ksCg2UjCeiEnrGOOs2T2OJL/ZYghBod8g8cJSxcFchQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OoxmptsQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OoxmptsQ"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso2007035a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661177; x=1761265977; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YWIeng8BsOTkZWInydege0vVgImBIZwpoQ1m6PsVarA=;
        b=OoxmptsQ+WqIyPddDlpDwB+DHjplUpstA4n3ImffLnhkSwdt+N8/rUwq8LR/0eeLrD
         aEPQWutBfXoyhPns9WVZt1ifTHuC/wsJ6QFoS8i/UbNjfVRplAPQWIGIQIdxxk03ZJ3j
         m/EB7vYnWDFTlwKuUlLz1tVjx6hRQIAfgfDSyQUOWnbrjgDPfA5G2gjiW22OddbgHxfB
         9Z0qyJS3k8+S0h54oT+j6fCt27igzF8EO3/pzF1yJc3bn1/8Ynr9OWsPiISLYtxIbvZA
         P1sq/ZEw8ej2kYdblkvGcmjO4ckUBa7kcGsy7ySEYC4NxTdDdQPO08Y6zrlWIkzJwriS
         /wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661177; x=1761265977;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YWIeng8BsOTkZWInydege0vVgImBIZwpoQ1m6PsVarA=;
        b=m8gkqh7oN2uEvRX0cLEg3d5dStSx4KB3AIp9eB9MRtgI0WbPPPaNVVBsmql6UlHdgZ
         yQBMnajbyJ2SEJwagT+f3U/FG2oiw4w8gyo2buzhjwjTNeGVBNal6dBpa49C3u1DR64O
         xbxODDkiwMJh5QC0sFgOJckwvf1izmxyyjbdsW2Fsryflqj/fe1ieLJJUfVPbTR8oFSz
         RyzkJD9tx+YfA4x10pXnBxOkjmtLEr9gKfDlhLdCnGLQlM0ZhfUwsd5euUZoaR4tLp7g
         NztbsTHnDPTZq5TE311t+h8jiaBNDEvPCg5eiBKoBgJfLQCfwszie3glsiKXg4BqjGKR
         rtQA==
X-Forwarded-Encrypted: i=1; AJvYcCVeZCUrx7QbH37HfnKCj678rjp0xI5jpqAyx1649+tl8zgTwu8kBU0FL6gD3wMCNRaUWCyTgYc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4Eac/lX8cOipb7p4lrM8vges80UGVawr6yvPev/BB2D+FFIPk
	5hLi40/ck1m6YB3nJidBU+YdKxPLNWURVsUV9rjxf4Fmz8Ok0v+Jm0u7agpglasVL2OciJ46PUc
	xLw0wxg==
X-Google-Smtp-Source: AGHT+IFms9prLqRWu4j+VpVVO9qXU7xKhQ1tryuBH0Kw5CCld5HGLDevmfw2rLOsCJwDJFMJbPJJK8xVq/g=
X-Received: from pjzh17.prod.google.com ([2002:a17:90a:ea91:b0:32f:46d:993b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:330:6d5e:f17b
 with SMTP id 98e67ed59e1d1-33bcf8fa140mr1764119a91.21.1760661177139; Thu, 16
 Oct 2025 17:32:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:23 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-6-seanjc@google.com>
Subject: [PATCH v3 05/25] Revert "KVM: x86/tdp_mmu: Add a helper function to
 walk down the TDP MMU"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Remove the helper and exports that were added to allow TDX code to reuse
kvm_tdp_map_page() for its gmem post-populate flow now that a dedicated
TDP MMU API is provided to install a mapping given a gfn+pfn pair.

This reverts commit 2608f105760115e94a03efd9f12f8fbfd1f9af4b.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h         |  2 --
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++--------------------------------
 3 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2f108e381959..9e5045a60d8b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -257,8 +257,6 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
 int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba5cca825a7f..3711dba92440 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4924,7 +4924,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			    u8 *level)
 {
 	int r;
 
@@ -4966,7 +4967,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5734ca5c17d..9b4006c2120e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1939,13 +1939,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-				  struct kvm_mmu_page *root)
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
+	*root_level = vcpu->arch.mmu->root_role.level;
+
 	for_each_tdp_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1954,36 +1957,6 @@ static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
-{
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
-	*root_level = vcpu->arch.mmu->root_role.level;
-
-	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
-}
-
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
-{
-	struct kvm *kvm = vcpu->kvm;
-	bool is_direct = kvm_is_addr_direct(kvm, gpa);
-	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
-				 vcpu->arch.mmu->mirror_root_hpa;
-	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
-	int leaf;
-
-	lockdep_assert_held(&kvm->mmu_lock);
-	rcu_read_lock();
-	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
-	rcu_read_unlock();
-	if (leaf < 0)
-		return false;
-
-	spte = sptes[leaf];
-	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_gpa_is_mapped);
-
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.51.0.858.gf9c4a03a3a-goog

