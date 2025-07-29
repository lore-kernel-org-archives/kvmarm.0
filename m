Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22E52C08C0
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829754; cv=none; b=E/JSMj1nKbe5ZBJuvw++dFskSR1bmLaLmONrn0cF+vx+nSHte1f6uneCwKptZj4Z6E5vuejxyJXdBX0V44W+JnlPJctCFdVliUkj1woICCGbuyExgl3nlww/TCeamB7QlRA+TubCIHRcYTC9vNmfKK7pP9R+l3aePGps/s+C5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829754; c=relaxed/simple;
	bh=WeFKr3XwYMubF6PEa5sSz6hYZVpnww/5jO5Tu3utXR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tyQArk7OT+QhawszCU3wrLYhL8Hyh9ked1eR5xdfEO5gRGUvEfzT+PilEbBwjuhUV0+7om3lFYTyijPFh/j+barn1KHqIKIYxfxZ+QsrB284Cr9yvAnr+euKwx0Eth+9CbsD8NGkp7PgC1b0UESjUEMAiNM/C7FcgaCBknxp3FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jw6e3XQ6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jw6e3XQ6"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-240607653f4so11457385ad.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829752; x=1754434552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jTad4J8Qg1Nlv10PcvZ871whY+Aaj9TjlMyj9Irid8k=;
        b=jw6e3XQ6WElGpgz3UGT5zSUG32MqOvyTr7h3YkCWYY4xyHMSCnmtY2ObMsZweIEOVM
         G8/ZmPTGEPSR1kdECeMDw39DI/XY/MKWlYgNLSq/sxG736dZboRH9WaRmOd2EVYe/TBn
         g5pzZLlJrgfbc6q0ktzzB+1UXTPFZxiX3oFAuLons8UMAPAegU1VjAS84BcHMFpAAlBF
         9PtJH2j4s9MjFYEoPFnTd4SKWUcHGVy+gTmmVx8ReHLt5TR/fFFVZufyWujBlKTeUB1t
         dFQzQktOgNgWPLTzd3t27oaZGRUzJc2Al71g/SG3CKyQ54ZXcQxQdpSNx4irowXen6GB
         uHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829752; x=1754434552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTad4J8Qg1Nlv10PcvZ871whY+Aaj9TjlMyj9Irid8k=;
        b=FU49cntkcHDXE4oNpwAO/oSwgUX9WMkPh/MZDtlUpxNhM5zY5Sz6BlSOyLJ3KhsdDq
         TzMFT8fLvFZjF8baYoB7DxvvCm3RLBFps4KvungM45veHpZmn4UC5dfIgNoDJtEXBKoF
         Fk5WWNw6zlG3pIs1NBApCtt81gdfhQB4N0S0azsN2kdbnv+7t122zTn5sVVG33HLwdM/
         X1BA4flrxOPo0VrN9iFAR33t4Ax8CSL0xn2mqGqXk3xic+tcBaDvFLkgXNAaDRI5nTv6
         eLMtejgYzCnhed/CZpljtysAW90eljR9ksKq5P75P6pflEN1iIYf93gTkHFaAAzNp8jh
         B2gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOaRymbqpEHBl+WdOSG9GRvNUXGigrW/B2HwwOZqKGb7pTZIZlXPrXEwwbFi6htLkBJlZs1vY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9b8zxD11SPS5PgUDioiK7cPka8g+BjhEgm8MBEl6RfnwvhP46
	0WV7cA9VTQmntrkFUlNhwW0QeNuvbaYnLm+BMwDbUtuTvcHhjpM2XtSyCCGJbxRtO5B0taWRy9r
	WWnQOog==
X-Google-Smtp-Source: AGHT+IE+WmeXckPv5tF/SBSQrHY4ZKYybHI52HgzkPQNumcR9r+UIJ3cQitNOL7pJonSsZZzG7kXKsvAgds=
X-Received: from plblc3.prod.google.com ([2002:a17:902:fa83:b0:240:3906:c827])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d547:b0:234:8e78:ce8a
 with SMTP id d9443c01a7336-24096bfd5e2mr13095805ad.48.1753829752170; Tue, 29
 Jul 2025 15:55:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:43 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-13-seanjc@google.com>
Subject: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
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

From: Ackerley Tng <ackerleytng@google.com>

Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
in anticipation of extending guest_memfd support to non-private memory.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/mmu/mmu.c             | 2 +-
 arch/x86/kvm/svm/sev.c             | 2 +-
 arch/x86/kvm/svm/svm.c             | 2 +-
 arch/x86/kvm/svm/svm.h             | 4 ++--
 arch/x86/kvm/vmx/main.c            | 6 +++---
 arch/x86/kvm/vmx/tdx.c             | 2 +-
 arch/x86/kvm/vmx/x86_ops.h         | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 18a5c3119e1a..62c3e4de3303 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -145,7 +145,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
+KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50366a1ca192..c0a739bf3829 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdc2824755ee..b735611e8fcd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4532,7 +4532,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7744c210f947..be1c80d79331 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..8a66e2e985a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5180,7 +5180,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..d84a83ae18a1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..dd7687ef7e2d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,10 +831,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..b444714e8e8a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3318,7 +3318,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return PG_LEVEL_4K;
 }
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b3424f638db..6037d1708485 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.1.552.g942d659e1b-goog

