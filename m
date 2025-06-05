Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF63E1F1515
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137894; cv=none; b=u1mFA0YRDWVmxjAc2W0BmGx/53kudgiHG/5L1Tr8337p1wa3otBT3u9fSPtXfml/WXHQKkNFLXf9Ktg1R8PpJgBGxd1F60OVQ96o8XjFfZMnkEu/NQk1PFys/ThaUXsVSLUrBLX0cXYW1kO7oAR+HjQdncgh/FLcLwu8LEB9KIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137894; c=relaxed/simple;
	bh=QJgSugRidDozCXPuIRXLTwtSBbKcxzGSNYJamSUOK7w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z2JTFrjzWInwchuMWMxIidiY884XnA+45UQeOPCRtJpAbW9L92yQEa2Pu9AiYq4XAOYugVZtifXoQzNG1+nKsxWrv5BPYmbIdHd2acbx+GWXbb8VaISxWa17JdJmYEs9d0cKavNdar91PzaSOGyPAhlWPr+Hfe+NldlAPlw/bso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vtjej2nh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vtjej2nh"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451e24dfe1dso9073875e9.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137891; x=1749742691; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cw6+Mpe4Y9YYGqB7SSsL2ZJhDik53zQn0HS8MVl9BPk=;
        b=Vtjej2nhL4Rh3nanX0mnofl2IpyM2AEt775zpBWncL0BitiG/0rswNZaDH5Ge6KgNF
         c3nJubNvhk7uJDu6id/ViqNtctKzPuaSK0XNp4HMbXIXBwfbDymATQUcxv7wkPf9dLDE
         TFkM90ta/mdJmfRKhMlV7wDG0FwnbQxQh7RnXrzJo0ed6LDcLUKvKA6elweUUYVIAJxA
         yNHypYDHs2HxC9o6c95MIFHJ8XG1lOFHkETS7C15jEeHVqMz6Xd+CcBiMGL/p3wrpwYz
         fHiBnOv+dEAavyVMGI74mmBIkbgwWP8rqLr+Vn3Vav6g7mz8EAT9Qeyu/CEAAsmWmdxr
         7T6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137891; x=1749742691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cw6+Mpe4Y9YYGqB7SSsL2ZJhDik53zQn0HS8MVl9BPk=;
        b=ppss9OxFXU5MMjXlc4wR7p7pxtFKwvYAOKdGzrFwEH6xFZmL2V7EF8WLN4SehMo6SU
         740cMNXxevkPQzzZV3/brKbZ5PUhrWJBNlp/9X5FfjXz+IhBZlVUobpdlpdf3LTqTUDh
         BRu4SB0MrkPbjW9wx1Tdy8PY2jziA8J/A5RfolasY1Ex4kHq7pC74Z8SnsplJLYCQXPR
         8UvbhmEiTili1/VIxDexhxVgVhXnquMsvv0JScU5gjWOzA5fJMUE565iBkC39haUSis6
         q2il67eOtZ1z6WAhLNjrnqU29RyCf+6hxH+xZ7Mhw3t62w1MtQ5Nsd8hAm11/skGoMvo
         NxRA==
X-Forwarded-Encrypted: i=1; AJvYcCVcAdB8X8jGX7+bHWrzV+JxfxNDNFUNkA1hDt+YoyJR2Gm8emkgmWbY6InrY3fuHHXL2TKONoc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwjhACr0Px5Jj7eMULcwq28YRBbkJcZVUZrfUWovpP/MMAQBwr
	WcwCAJNrNyyX2N9uqCRvg95n0P3HaOyiXVKNc60EbE/rNdTZwnSSvmWrBKeDmNXFeBFpknP+tt0
	Gew==
X-Google-Smtp-Source: AGHT+IFYsQ27vypuy4NYsL5G2D3PkTdK4tJz+eGgF3cJ530C6liNPHZmvXo6DXqMwIsM1QvbwO6I/y4yDw==
X-Received: from wrpk13.prod.google.com ([2002:adf:f5cd:0:b0:3a5:2a0b:d7a3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:250a:b0:3a4:f892:de7f
 with SMTP id ffacd0b85a97d-3a51d95dbbcmr6703161f8f.36.1749137891053; Thu, 05
 Jun 2025 08:38:11 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:46 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-5-tabba@google.com>
Subject: [PATCH v11 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
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

The bool has_private_mem is used to indicate whether guest_memfd is
supported. Rename it to supports_gmem to make its meaning clearer and to
decouple memory being private from guest_memfd.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/x86.c              | 3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a83fbae7056..709cc2a7ba66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,7 +1331,7 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	u8 vm_type;
-	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2254,7 +2254,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_supports_gmem(kvm) false
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b66f1bf24e06..69bf2ef22ed0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3486,7 +3486,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
 	 * case might go down the slow path. Either case will resolve itself.
 	 */
-	if (kvm->arch.has_private_mem &&
+	if (kvm->arch.supports_gmem &&
 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a89c271a1951..a05b7dc7b717 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5110,8 +5110,8 @@ static int svm_vm_init(struct kvm *kvm)
 			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 
-		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
-		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be7bb6d20129..035ced06b2dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12718,8 +12718,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.49.0.1266.g31b7d2e469-goog

