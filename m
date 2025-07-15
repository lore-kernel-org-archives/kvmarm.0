Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83A2D97A7
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572056; cv=none; b=XiGtY1Ft3A/NP9UuQu1ga2yPnP5zAsIB9OeSqE0X1Juj8ydQyt3eWLhfMdKzzH/RJLOo00GBhixDPTmuYZDd/8Y+BoEiPBjBKllZzv8Y+NLsp3gQff+zPEnssZhcolIA7t5a0rzw4vGWgIyyKh0HiZBlfvPojtq0RZY0MZQ9c8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572056; c=relaxed/simple;
	bh=fmyVA4apzYgqUG5P12eOkabRZ7I06Ji1D21qUx8asvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sGlYDDrIKpOQZ99M5s+UMDQdpPfd+f7V2OcTmaYAAOenwlZP8yhA0SE2W8CH4BZ6tCffkGUvu0pNvyeiHayVLVM/YR7CQUOuzwwri6TtM8W3mSuQvlT+Ggmu+832OqUZCokG+RqQmQ0SQqTkRlEmJKSLqU0Asm5kTKrFPp3dc5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fo2KyO67; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fo2KyO67"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a579058758so2100213f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572053; x=1753176853; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QnPPXFiOPfdg04/AUjNCkvc1fLkuMc1LvyVi5jzElg=;
        b=fo2KyO67khGAl3zqwWWHOdZpS60r5XLLPFFjVg6B4jtR4i3vhM6Y7cE47luO/HirU7
         jRJ+fahzelNIgrVN2//KcBdhCCSdzziF0NFD/ZIyK9x4ufnr/mw0Sd57fGTRFKEAapaB
         3exOdHpuBwtno7b1d8yzLlcaD6oMsfzKcbWFLZJyZfV2QU7JjlBX04lCGi3pgbiw8oZC
         +eHO3yyg2TBaShz5e2y2NVA0cAnzJDhsRZdZHbbIRMnTOmDmXtdqkhzaNas9aQ5N4Va8
         27XJ53mDr0GlGIwADqCp1xpM7gWtLWzmnzFmkwoO/D+SHWdC1ObBceJtlOO1tNnbHZQY
         UdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572053; x=1753176853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QnPPXFiOPfdg04/AUjNCkvc1fLkuMc1LvyVi5jzElg=;
        b=G/rPmrdsSeN3TZBvkc88ZRgZlYh257sUf8dkdU+2+gFoP28M373Ll7Bib/swwuFc7e
         dE+2M3e+30q/5wUYVthHThrxgP3NdXXpWl1xv2oUwaxFfUKIyglD+dpNuv/Xlpv+t3u0
         +qJSf8FjBYRrN8hD652YsTBabhXQ2vhvgj8HdcSAyfqSbrSiFCoFxRqYefRlA7KasoaO
         U+op3RscfPnoDRLqUFwVx/8oB4+vfanX2fWUkNMtZ16T0z4iDTOX2oFRihA2hFS3G1xW
         /meI/jX/9x+FHdSuKMe9++59z+FY4rBh5wXBMeDRCfTMdh3nJ5aQ9WwqQ9OCsTsOBDT9
         WPHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJy9RjN94CeX/Y4bft3rHo91VxGQSQsz1jEFOXU+TG+0SqQ5m+beQuvdIdr2VvVF+8a/ycooM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3t2SaoVr8P5ksLUKQ7PCLcGYBHw2pQ52prkxaR3gdl9noTGRY
	p6sviN545zk04AVP/HY2oGhK1oYGAkseuRR5Aj+XSOmafTzORwX56KOeS+juRDNVF/UpHb7FYRg
	I8g==
X-Google-Smtp-Source: AGHT+IEcNdClssFPjkTzPuqkvJUN+FYze63JA5JjmLepK2R4xHK6Nv89kV4xlNwvelnLZlz3gXi/0kQY2g==
X-Received: from wmbgw8.prod.google.com ([2002:a05:600c:8508:b0:451:4d6b:5b7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:43d8:b0:3b5:dc05:79b
 with SMTP id ffacd0b85a97d-3b5f188e8f5mr9189412f8f.14.1752572052811; Tue, 15
 Jul 2025 02:34:12 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:39 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-11-tabba@google.com>
Subject: [PATCH v14 10/21] KVM: x86/mmu: Generalize private_max_mapping_level
 x86 op to max_mapping_level
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

From: Ackerley Tng <ackerleytng@google.com>

Generalize the private_max_mapping_level x86 operation to
max_mapping_level.

The private_max_mapping_level operation allows platform-specific code to
limit mapping levels (e.g., forcing 4K pages for certain memory types).
While it was previously used exclusively for private memory, guest_memfd
can now back both private and non-private memory. Platforms may have
specific mapping level restrictions that apply to guest_memfd memory
regardless of its privacy attribute. Therefore, generalize this
operation.

Rename the operation: Removes the "private" prefix to reflect its
broader applicability to any guest_memfd-backed memory.

Pass kvm_page_fault information: The operation is updated to receive a
struct kvm_page_fault object instead of just the pfn. This provides
platform-specific implementations (e.g., for TDX or SEV) with additional
context about the fault, such as whether it is private or shared,
allowing them to apply different mapping level rules as needed.

Enforce "private-only" behavior (for now): Since the current consumers
of this hook (TDX and SEV) still primarily use it to enforce private
memory constraints, platform-specific implementations are made to return
0 for non-private pages. A return value of 0 signals to callers that
platform-specific input should be ignored for that particular fault,
indicating no specific platform-imposed mapping level limits for
non-private pages. This allows the core MMU to continue determining the
mapping level based on generic rules for such cases.

Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/mmu/mmu.c             | 11 ++++++-----
 arch/x86/kvm/svm/sev.c             |  8 ++++++--
 arch/x86/kvm/svm/svm.c             |  2 +-
 arch/x86/kvm/svm/svm.h             |  4 ++--
 arch/x86/kvm/vmx/main.c            |  6 +++---
 arch/x86/kvm/vmx/tdx.c             |  5 ++++-
 arch/x86/kvm/vmx/x86_ops.h         |  2 +-
 9 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..02301fbad449 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -146,7 +146,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
+KVM_X86_OP_OPTIONAL_RET0(max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 938b5be03d33..543d09fd4bca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1907,7 +1907,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*max_mapping_level)(struct kvm *kvm, struct kvm_page_fault *fault);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 213904daf1e5..bb925994cbc5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4467,9 +4467,11 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm,
+					struct kvm_page_fault *fault,
+					int gmem_order)
 {
+	u8 max_level = fault->max_level;
 	u8 req_max_level;
 
 	if (max_level == PG_LEVEL_4K)
@@ -4479,7 +4481,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
@@ -4511,8 +4513,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
 
 	return RET_PF_CONTINUE;
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 687392c5bf5d..dd470e26f6a0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -29,6 +29,7 @@
 #include <asm/msr.h>
 #include <asm/sev.h>
 
+#include "mmu/mmu_internal.h"
 #include "mmu.h"
 #include "x86.h"
 #include "svm.h"
@@ -4906,7 +4907,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
 {
 	int level, rc;
 	bool assigned;
@@ -4914,7 +4915,10 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	if (!sev_snp_guest(kvm))
 		return 0;
 
-	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (!fault->is_private)
+		return 0;
+
+	rc = snp_lookup_rmpentry(fault->pfn, &assigned, &level);
 	if (rc || !assigned)
 		return PG_LEVEL_4K;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1c484eaa8ad..6ad047189210 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5347,7 +5347,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
+	.max_mapping_level = sev_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6f3c6a153a0..c2579f7df734 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -787,7 +787,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -816,7 +816,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..8e53554932ba 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -871,10 +871,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
 {
 	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, fault);
 
 	return 0;
 }
@@ -1044,7 +1044,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
+	.max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a3db6df245ee..7f652241491a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3322,8 +3322,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
 {
+	if (!fault->is_private)
+		return 0;
+
 	return PG_LEVEL_4K;
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..ca7bc9e0fce5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -163,7 +163,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.0.727.gbf7dc18ff4-goog

