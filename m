Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8B384B9C
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855039; cv=none; b=jkHRGEalifSj6Uguv+wfu3tP1q/6rl8UINijQElxWEJUTmHIhVUzJ+69Xl3pIfWRvS28uWukgRA3ULYIQgCXfqRTcwWWm2vnCIWVwG7a5vcIJQpVml9E3P4LtkFg8mjJb2ZnZxZ/APViGm6Vhdt9+8LuutFCd4b+Ra6jSfWddRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855039; c=relaxed/simple;
	bh=/ZmwuSI1/TsBi/hdaMNzxUBuHFwJZlKVkIuQ67ClOls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jWQMa6CRPVFayE8paiZeuobHM3IVuefff8uq+YiBmi+mbRjjamcCnD1B8wcpEK66+qvg01jdIy7nXgO0FGAPvONOUgFwlGMQAkmjsybERs5OIf36BBsln3HdJKyGa76idRFoKesUIMdLzjxEO6HHdZAojD1EN8g0aC33PLJscL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bBKkNxF4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bBKkNxF4"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32edda89a37so1493111a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855037; x=1762459837; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z7Z4VCKxvbeclMBJpiAZWPr8rGnQCyDletBZbiKOLg=;
        b=bBKkNxF4tjobOUK1m44200L9WaDzD9uJIL/jhl3jvoUZ6SAyWoFHMQvGrMzJqCDX+k
         Sq+RS/3Tcgh44XekuA3wrm1FMu5DFgFxSorUn/TO6T8zx0bvCBvfEZ+Vb6+mXM4k5hQr
         j5yQX7lmNVvaiwbuCfs4wmjwmE2rudkPMHn8CHpNvEYQKyrxr/1s5li6NpeOYwoQuAea
         K+xjd+tEhudQgAvfTasAHRmZc6fTjDJSqRkGepNf9gmh3OO+fLyJoCynCHxqFzz57HzI
         GT/0gVTZt7nbduxDs56Jd7G5GJ3rfNo548AJaoihn0Bb8C4vCVlNrntKMBE2EGMgmsMM
         GaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855037; x=1762459837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Z7Z4VCKxvbeclMBJpiAZWPr8rGnQCyDletBZbiKOLg=;
        b=G+dw4e+yA0sM8edbJsLJfqc+eKBzkj5fqLTGjoJNFD2Zeu4CqhgDEzQjxf9nf49eR2
         BLLSmHFTJckyoFawQzyfQUYMAbz+WyfUdoRhlvMvlCmbTYszkNHMHVYVVXqXKR/HZOaw
         s1Fv6iqvd8e0vPoY1P6hYlewO9vYsr2Dbd5SmlFL/ERcTR2/X31pbNzWsv6WIGgHmNou
         fg5DqPDqL+HrtQAqDCpPsaWQO1KCTT4pdqp0P9FnFISxCn4Sagl3Q6Dj0ZHFt9a1SKVd
         3O1wY+cjkPR2p8ZQn0j3ne7K1+dJFEVsX9zipBhlJ9RAXEuevjEpotVhN7pemONBTSqC
         LhtA==
X-Forwarded-Encrypted: i=1; AJvYcCXY3iZ4bLTObXjQ54CO4rk76vEXoecVjz/gaM/ZU5bZyJ3bDYdVX5XtNCWUJIZ2WMjpS+/QzQU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3CKgzwH0Ezraqnkhhlmphjb+pRQWpnBD2Tb7IZgAdomM+80/X
	VDQADZSj1NqUwycXG4sJclqv3tU/MSzR64ayLDqiOeBHhjF2d4T/tcMhC9ZJYXc1NDCyhpAcajS
	Z4a9G6Q==
X-Google-Smtp-Source: AGHT+IGuQ9tseR+UxrPGQmatIE4dzuj8mufA6J/LivL787A5dSoSjpBpOEZB47eEhvzGXFTpSKaWylv+I0w=
X-Received: from pjqx5.prod.google.com ([2002:a17:90a:b005:b0:32d:dbd4:5cf3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3141:b0:339:a323:30fe
 with SMTP id 98e67ed59e1d1-34082fdc1a5mr1313871a91.14.1761855037257; Thu, 30
 Oct 2025 13:10:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:38 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-16-seanjc@google.com>
Subject: [PATCH v4 15/28] KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into
 its sole caller
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

Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
providing a one-off helper for effectively three lines of code is at best a
wash, and splitting the code makes the comment for smp_rmb()  _extremely_
confusing as the comment talks about reading kvm->arch.pre_fault_allowed
before kvm_tdx->state, but the immediately visible code does the exact
opposite.

Opportunistically rewrite the comments to more explicitly explain who is
checking what, as well as _why_ the ordering matters.

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 99db19e02cf1..a30471c972ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1605,29 +1605,6 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-/*
- * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
- * callback tdx_gmem_post_populate() then maps pages into private memory.
- * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
- * private EPT structures for the page to have been built before, which is
- * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
- * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
- * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
- * are no half-initialized shared EPT pages.
- */
-static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
-					  enum pg_level level, kvm_pfn_t pfn)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-		return -EIO;
-
-	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
-	atomic64_inc(&kvm_tdx->nr_premapped);
-	return 0;
-}
-
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, u64 mirror_spte)
 {
@@ -1642,14 +1619,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
 	/*
-	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
-	 * barrier in tdx_td_finalize().
+	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
+	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
+	 * arbitrary memory until the initial memory image is finalized.  Pairs
+	 * with the smp_wmb() in tdx_td_finalize().
 	 */
 	smp_rmb();
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	/*
+	 * If the TD isn't finalized/runnable, then userspace is initializing
+	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
+	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
+	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all pre-mapped
+	 * pages have been added to the image, to prevent running the TD with a
+	 * valid mapping in the mirror EPT, but not in the S-EPT.
+	 */
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
+		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+			return -EIO;
+
+		atomic64_inc(&kvm_tdx->nr_premapped);
+		return 0;
+	}
+
+	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.51.1.930.gacf6e81ea2-goog

