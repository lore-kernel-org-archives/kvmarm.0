Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690128640A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829759; cv=none; b=INRukKOQqm2h6jZMs24OsKd2OtGy+dFXkA8SFBFRwoNiCwknOT2po8i+vizupvayseYHqV9iQNX3ixxQE54wtnU+72218uqQoC5Wqdo30Vv0EPgiObtzNaRyjNBYWYCZXnCSNTippUIjxnYTKsB5zdcLcwPvgEk6PjQSeRrpboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829759; c=relaxed/simple;
	bh=b802s1Jv2sQP3/H6I7vKO97dWqQ79fQ8pk1OW59DwLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VjgrueHOFRigkoqYWHnJKGqN3AfbM+apRUKgilclleSI/Dto+Ks+PeebHPVdxXT0V22fci9eF9NJmRbvDu61+/Ts0er/hxcNpok9Mch1Pz0dbStdyyq+jCYa2p/uR653sJBPI6nd6MH8tSf7b5KksR3llxK5RLVAzSGv2nxQLkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lab3BH11; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lab3BH11"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea430d543so3547424a91.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829757; x=1754434557; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qZ7UUMMTQmKo+oqwpxvtUgE6azYjzXKI1K1HySZjpRM=;
        b=Lab3BH11uEHuRq7TPil4lpCJ+Glt8UyOUSJR84MwrIBg9QYNMAQe/6Lf2Nxkfa7rQu
         Eh/h+YL3j/FfC7AIb4u/FUtKa2TixTEFeoKIErTb/Q4Weu+Syk8oxp4NgGKqmET7eQu9
         /gQUS7G9qVkTtHc/3ZH2ngef4ezk//gUCLHSxCxWCC15k87nSBYrC+vPOXccOogW+OHf
         ait5z9tgw0CfSLoSKUfOoufbqXvpPW5EKCfZUQ3xEQ6JdLnVZu0iFrnjSey9kUdJa2gt
         mqpfjButf1l63g7G3tdQgl/WmCcHtYTrw6sMl34WT3tzlMW90KC5fIpK/2o2razNkC0Q
         i55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829757; x=1754434557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZ7UUMMTQmKo+oqwpxvtUgE6azYjzXKI1K1HySZjpRM=;
        b=RMoNyPYJx/zFlr3TO4/IWk6lKz41ExU9acxLPxQrhVoCGJoTwkpMeyP04+MDpFdSbb
         90ucci18haEDaBetDo6ijNdf+ZgnOVtjRWOFA4A7JlTgm77BV8NQQ5vnBFHoz5ujWVBJ
         TyoEX4O3tI+ekdYn9ccc0bXcsMuKOwit/OjADZLNytWS6pn7lSRh02PA7D0lb8XoG3xg
         6It8jWJ+L6bm/wWkxbk1f8x9xyKagUS8NS7kC1g7BrPnSBG2QlbcVRWwOSPzK7+VB90c
         FdKbtaVRhyCdy/kw2JiIFaoZdqN4NdtmQ+XAg01HG0zLuZ5XGqcteekOWjwe951/XJCT
         tlOA==
X-Forwarded-Encrypted: i=1; AJvYcCUiPC3SPTXInMG10dHOLBzEp1wimigSoKs8quhlBX6RfzU0olXLgPqpecIxb242XNsTmOYuuL4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE7qfKOXyffyXRJxF3/AD9mIR3ryPeN3MkjKaEUgLy9vGTL5w9
	4H5IVe/5jh+7lVoaKeuHeRN8aHriC8WlgXSgi3pFUdUMeFHdhU9W5aOjHtOcmKZvcHFfC5mpZh8
	RzLW2bw==
X-Google-Smtp-Source: AGHT+IEi0LT633cR43d7c7trYUUKKhZMYkJ3vVlxY+rv8i3UqXQjtgYGy8SCvBIGqavUrw75WQrf6XchBFs=
X-Received: from pjsh5.prod.google.com ([2002:a17:90a:2ec5:b0:31f:b06:318d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c4:b0:31f:4272:c30a
 with SMTP id 98e67ed59e1d1-31f5de93957mr1400693a91.30.1753829757434; Tue, 29
 Jul 2025 15:55:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:46 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-16-seanjc@google.com>
Subject: [PATCH v17 15/24] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
not just private mappings, so that hugepage support plays nice with the
upcoming support for backing non-private memory with guest_memfd.

In addition to getting the max order from guest_memfd for gmem-only
memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
restrictions on page size only apply to Secure EPT mappings.  Do nothing
for SNP, as RMP restrictions apply to both private and shared memory.

Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 12 +++++++-----
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/main.c         |  5 +++--
 arch/x86/kvm/vmx/tdx.c          |  5 ++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c0a739bf3829..c56cc54d682a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61eb9f723675..e83d666f32ad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,8 +3302,9 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
-					const struct kvm_memory_slot *slot, gfn_t gfn)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+				     const struct kvm_memory_slot *slot, gfn_t gfn,
+				     bool is_private)
 {
 	u8 max_level, coco_level;
 	kvm_pfn_t pfn;
@@ -3327,7 +3328,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
 	 * restrictions.  A return of '0' means "no additional restrictions", to
 	 * allow for using an optional "ret0" static call.
 	 */
-	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
 	if (coco_level)
 		max_level = min(max_level, coco_level);
 
@@ -3361,8 +3362,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	if (is_private)
-		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	if (is_private || kvm_memslot_is_gmem_only(slot))
+		host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
+							is_private);
 	else
 		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index be1c80d79331..807d4b70327a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d84a83ae18a1..70df7c6413cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dd7687ef7e2d..bb5f182f6788 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,10 +831,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+				     bool is_private)
 {
 	if (is_td(kvm))
-		return tdx_gmem_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b444714e8e8a..ca9c8ec7dd01 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3318,8 +3318,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
+	if (!is_private)
+		return 0;
+
 	return PG_LEVEL_4K;
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6037d1708485..4c70f56c57c8 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.1.552.g942d659e1b-goog

