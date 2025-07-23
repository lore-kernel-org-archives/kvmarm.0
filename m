Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CEF28F942
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267654; cv=none; b=hSRnFCiqKZC26boasaWxqcSrjxftHQqlBhRduySzrc+uVp/Gd69Bd0AqgX6e+OvawSGkKWqgfXs2mmwDLhNSSGEqBiZffffwwkK/BBakhdQFk7Bj9pCdan7uK0HQbeP6e0em5eV0dYMJq+TSBYCNo08+JSoTa+NZz5nic9w8/Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267654; c=relaxed/simple;
	bh=4b3ScPRnhHbCHJvxlu57yj4eNBaylfG9sPtNOAIrk9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rK4Qy6ax6hZrvkd1N48onYTsZigntMJGgedR+U5yfW7nLxp0xYqq/aUPTbB6jFnNPSk9W+W1ZT5vti7FZWnIWJqCxTI51RNR4BGMC+IXXq+KzBPy9qMC2ZM+TrDEgdoiIzRHbeIueruOpST3tTBgHaDuiUe/n+dLmoUUbn3QAak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rw7x3Xen; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rw7x3Xen"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so41230525e9.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267651; x=1753872451; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ew3dVk5+ay5qzekeBZl+5uhpvVmEbTs/qm55dG7cn/M=;
        b=Rw7x3XenuyndaX5yEtT6pvomeIB2D1KGa+XoUQrKvDHTFwkkC7v6kxKtA7jjnqiVST
         lq3NgCKzHLFfOHP9wT1cE5jE+DXhx2/v46LncNA0hJYqPzDMbBvSiFq6cqujINvR8FtY
         pcDSdcHaE1EvsuARLNS744blYn3XE01oTZq4DqQqX+ohBeNHVqkNBKXNT0aswG1l66nV
         W3/sVYUdNmDpaxvcBGF5EQKtCrw2HfdlhGPIOFrAcpaVmYRjElJUu2cxcKxKzoGosoRH
         pBuFhei3wV75AuBNpGkW7fNhnEmTcfyTdFmfkm8dFoAg7EtSaec49424dlxQ556GbnIJ
         oIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267651; x=1753872451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ew3dVk5+ay5qzekeBZl+5uhpvVmEbTs/qm55dG7cn/M=;
        b=U5hKvBsL4etjRuGe2RVWNbyC32J+QNQlEb1qhB1iOQepgvGI/e81CJ+sNoOJC6UtWh
         BwkcGf2H7lLKNQNXyKsWPDvJ/kacUHLIjmBK7PmA5HZvaaDrY8ucPy60pikVyzmKNkpj
         Ds8Nz3MxbmQ3doCCcmT8cISP9sIAnQfZ03B/0GAPP10HsS8RQ5RLssN7yLcMabJJULhA
         oJbx/rEZ/yYZg42XiOrQqn93UhiMfpwIgzTFym+rjmw+1R7/dAMoGNUgTLlJr/sBtcAG
         GupLIkdS44N2MSeGTAhvc6SmIZA8R/OkV0V+e1ZKlnPVp5H0ZuaIOx467rVPF6zuzhLM
         WGrA==
X-Forwarded-Encrypted: i=1; AJvYcCXLqFCpJbQiAB/XHwlZlQKO814g4WZRiyG5DmipWpS6fNLoTBaYmbVfyADP72n3owzgANQsRbg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaVJlExqCxk/kBILPcj3Xn8BrqxtcQ4Tdtvf9E4euFvXhSJnvm
	NN/AkqAvgUvH+iKIRZ/as/KkD7Kpe0UylN965UixXvMQaJE56zkddHBjMQBVbwwZSs+zeQ7szbl
	kMg==
X-Google-Smtp-Source: AGHT+IG5QM7+4yl5LSLpnYIEZUfkj7Qa6xIUOEe0hQKZQ77BuTEsaT+1bAcGhHUv94wQAK7RvfJxA+CrMg==
X-Received: from wmbdv7.prod.google.com ([2002:a05:600c:6207:b0:456:365f:4281])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:430d:b0:3b6:176c:2a13
 with SMTP id ffacd0b85a97d-3b768ee09c6mr1798667f8f.15.1753267650882; Wed, 23
 Jul 2025 03:47:30 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:07 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-16-tabba@google.com>
Subject: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
not just private mappings, so that hugepage support plays nice with the
upcoming support for backing non-private memory with guest_memfd.

In addition to getting the max order from guest_memfd for gmem-only
memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
restrictions on page size only apply to Secure EPT mappings.  Do nothing
for SNP, as RMP restrictions apply to both private and shared memory.

Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/main.c         |  5 +++--
 arch/x86/kvm/vmx/tdx.c          |  5 ++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 29 insertions(+), 15 deletions(-)

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
index 6148cc96f7d4..57c18ab91646 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,12 +3302,13 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
-					const struct kvm_memory_slot *slot, gfn_t gfn)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+				     const struct kvm_memory_slot *slot, gfn_t gfn,
+				     bool is_private)
 {
+	u8 max_level, coco_level;
 	struct page *page;
 	kvm_pfn_t pfn;
-	u8 max_level;
 
 	/* For faults, use the gmem information that was resolved earlier. */
 	if (fault) {
@@ -3331,8 +3332,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
 	if (max_level == PG_LEVEL_4K)
 		return max_level;
 
-	return min(max_level,
-		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
+	/*
+	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+	 * restrictions.  A return of '0' means "no additional restrictions", to
+	 * allow for using an optional "ret0" static call.
+	 */
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
+	if (coco_level)
+		max_level = min(max_level, coco_level);
+
+	return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
@@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
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
index 0d84fe0d2be4..ff44f4bd76b5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3338,8 +3338,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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
2.50.1.470.g6ba607880d-goog

