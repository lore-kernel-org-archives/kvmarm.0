Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BE138287E
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855030; cv=none; b=qFTkXde8YIW5U4Bu5GuEkzV76/ZNqkJF1MXi1Lj2tr5XdXgt0SbZCJxRyIS3J0jhXZCD8r4tMREInfBsg/H37CR9wjmRKZiadG27S0OjRzH1YbF13epbaGeVfmPfV8nHV+xLgrcbc3iKD8CP38VChISz+rev2A80bN5bSjVQD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855030; c=relaxed/simple;
	bh=ko0pi49hMMjXayjy5Hc2PgynQuEfPA92uCBi4fQ9ie0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+sEt2wIEO3UUy2NnnKFn0zAQZQNykTkGSm6eOnETgibhIT9Qp6K5P1eZDhW1iGswJJt3Hd6E155332agPHaxs2cbAt13+nbsz9NTM5wQVrCN2DyLlGpSL2JtaOC0eb9T5+YwzE8C0dWqAfNLmhMWtIJkMZAMQ6CMNO5TjnC9bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jQ4cj0t5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jQ4cj0t5"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34077439124so1055058a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855028; x=1762459828; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KH8ZMUFkaBzXjpSahKr3XCuyUdT65ecO9/HP1PAb4RI=;
        b=jQ4cj0t5Jwfg5C7vZoOZ2W4ZpcVGu7qODCT+32uXiOY1Y8WOw9R3B3qF3rl9sALkDA
         iUsEvODI7jYrJsFaeoBek9ansXmY8vAI2haDAjOUUlUdlWwOZg69IGQUWJhxFOes2JJo
         2rgMWCNbt2YTObzrDVIil7E40ZyjYeBQyO2yRSI2K19sC1tltPaS0PKkNC4fChaVll1Z
         hyd+7ZSQRXF4v5KViTYNbu28QTFCTNRidRTyxNdO6W08b7MNc1go3oKlcVVuTXtv6LUD
         FkZVsy2fJ24+MgntbCrY5ePuy0kfUuv97um2UilYfpiT5S1/n/xstm1Kp+QXbPTEwR2I
         8ggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855028; x=1762459828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KH8ZMUFkaBzXjpSahKr3XCuyUdT65ecO9/HP1PAb4RI=;
        b=VlLaWmd0piRzF+lgH80bF5sor1JlyZbwGt+qq5z+r9S22LPTFD9POXBcXFutXpwrdd
         R50kSECT9hoLAs66bh3V12IM7HOT21ersEDmrpyg3pXwFLigucOF5pDBO4ymV/Irjysz
         Cba8Wq0LYp5xCAwJpKO7ef2VC7Z4oPBaVXjAnL17IetMxK7Qsu0jgatWrL9t+4wSDmbx
         Xn/B2x9G6bu0jEFu3FvNmdNrGlm7xf/a7LP4yLVsFi06sKloHsjPpMCYqnlQW8kEEvXq
         J9zvCWVke79Zc6m2Jh+8hXJkK1lecXpWJaXKW4yRTfpB01PLXMCta0QOh2keAX3QAq9r
         W4TA==
X-Forwarded-Encrypted: i=1; AJvYcCURA1ng3Hkhp+zNAce2Y9y62mpRYVDItMkqV1V9JVF/2p2NsxtYfdBDkjPL8hzdzZ0TL1c8nSk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRiefK8CCWoBK4FIsJG9Hz9pLI7wR49vTRbfca/n2B+aFXGMxL
	FvSov57wm0G+k4CXUFgd6TIt8PldzcCQZ/Ua8Kg26Csdb65ikn/LbgC11UGW63FrGIgWmdPt9mE
	olf/Isw==
X-Google-Smtp-Source: AGHT+IGrJrKalEV3VAWt2uGzDiDeYhZVGRjeI1LK3deyE8hSeRDQF6nrnXg4JLxn0CpF+AukaegC2zqX/UE=
X-Received: from pjbgj23.prod.google.com ([2002:a17:90b:1097:b0:33b:cfaf:ce3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1801:b0:330:6d5e:f17b
 with SMTP id 98e67ed59e1d1-34083074dddmr1219299a91.21.1761855028166; Thu, 30
 Oct 2025 13:10:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:35 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-13-seanjc@google.com>
Subject: [PATCH v4 12/28] KVM: TDX: WARN if mirror SPTE doesn't have full RWX
 when creating S-EPT mapping
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
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass in the mirror_spte to kvm_x86_ops.set_external_spte() to provide
symmetry with .remove_external_spte(), and assert in TDX that the mirror
SPTE is shadow-present with full RWX permissions (the TDX-Module doesn't
allow the hypervisor to control protections).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 arch/x86/kvm/vmx/tdx.c          | 6 +++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b5867f8fe6ce..87a5f5100b1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1848,7 +1848,7 @@ struct kvm_x86_ops {
 				void *external_spt);
 	/* Update the external page table from spte getting set. */
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				 kvm_pfn_t pfn_for_gfn);
+				 u64 mirror_spte);
 
 	/* Update external page tables for page table about to be freed. */
 	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e1a96e9ea1bb..9c26038f6b77 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -515,7 +515,6 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
 	int ret = 0;
 
 	KVM_BUG_ON(was_present, kvm);
@@ -534,7 +533,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	 * external page table, or leaf.
 	 */
 	if (is_leaf) {
-		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_pfn);
+		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
 	} else {
 		void *external_spt = get_external_spt(gfn, new_spte, level);
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7ab67ad83677..658e0407eb21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1629,14 +1629,18 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 }
 
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, kvm_pfn_t pfn)
+				     enum pg_level level, u64 mirror_spte)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EIO;
 
+	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
+		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
+
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
 	 * barrier in tdx_td_finalize().
-- 
2.51.1.930.gacf6e81ea2-goog

