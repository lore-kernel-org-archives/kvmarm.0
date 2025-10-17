Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC512264A8
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661201; cv=none; b=F//zOs2LOeTO9PQEVihrtframV1ZMMriOUwUdayx417RCx0ldEG4lmVb72STLsUnmDoNdCEAuwOpz8LJiYBV8DiC5Z1TQJcGyD8tpgdehCaizDHoS88Px1m71YCS8rClbhHhI6nyElQPOq0Sas5gf/utgC1a0tqTwZUrCTNZdeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661201; c=relaxed/simple;
	bh=xsVeZVCpJopvRN613ExtBgtC+UVk2ov6pGM6BGmA2r8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nCNyugZzXLgv92mZCYNnAgfA4jXzpQBW7ueFpGyOCRB8R6NHfcbKEleB5ZVc1odlX1n1UhxsBxNHM7MLl4rd6D+9luj7v1z/EKw5uNY4YKJlRqwGyR/YTlri+Lm62uq/5cXeYPAmqAtZyu7h+ltF6BoOuoBQ93Yjzj4ZZ23m1PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RrCTDnBe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RrCTDnBe"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bdd0479a9so103034a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661198; x=1761265998; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4L4VN8U7RJUEbpzDtbDieIOtt/3ZiFqFZJAEpu6W9XM=;
        b=RrCTDnBeFxwvfp8KOM0Ha4YbDWZVEZUmRaWkQz/7ItapEYCDJyRsO1rbvknX/IloCy
         f5OT7Bp/Id1RF6Ej5/59/9Eb14DafotNrgGF8xeQVeLjtMvK4xo7OvXMj8vXXHp2w6rb
         mpeK2EFbAsSjgJMYCRYh2h6HdBZhZy2u1aj+PJfUM6bxX/3oaElrd4L59rmFiPDDQb7x
         hdIePiw2ivSz4iTF1rjMc3fQRw1i/f+e7Q2olRtYVnlynOEYyJhLVP+21gIL6YodMlSK
         OSRismRmrgkUrUfkzUsn28U9R2s9IFGGtAWVVgk++mKsQR4PW9VXQGiUwQ6niwHh0GAL
         Vp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661198; x=1761265998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4L4VN8U7RJUEbpzDtbDieIOtt/3ZiFqFZJAEpu6W9XM=;
        b=vYFRC9fqKMq9NG6zHD7LLqD+h+6EPqCLzFOLjJUTbyKDuOw2AW5rvnXIo9VDnPxcNB
         +Ch5XXHKkoevi3osbDnmNJEsrQxr/C0oi+OPJul4qIb7EfdIy3vE/JyiLjb+LjeWPmW+
         OBKyeEbISG03aeqoCTs2AAsUTvDTv6s6Dn+XeJhQRfb2vNCSsg3wxW6WmjrhSlCRN/4F
         o2NzHJTfWkJg7rU+7qT/wxcAKaEi9zwLLJLtG+GutG2r1SSSC5ehgHEy/AU5jCSaDQdO
         3nu3/KuIyl0+wthx3br+D04lRS/7Ec/XxwpNa/mNiZ08gStlLPSIOfBC63XEzPy6B8c1
         Eosg==
X-Forwarded-Encrypted: i=1; AJvYcCX/ariLCf/r6IQnBUE+xhEUr0xMp8bpno0thOM8rgDxVp2UWLgyoSVNgPRxq1boh+AJ8d6ZTN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbC1ibHCaNnlAMPYL1UqINUZxgxqlow8AcKrcNVwhkf5Alqp1i
	atYX7BWuqI0YuPmbxuKkq6Y83i9NXJ652UJQmx/GhPgKADrfSfKSt/0vBf3PCgnk1tJXOFKD10D
	6RITklQ==
X-Google-Smtp-Source: AGHT+IHMdPj8KO0Ow+VsHoVT8Wut4d4xJXGIy0YSxbMRshGdS2z8MCnnKR/WSj9gCLIaYnBljUnbwyVx82E=
X-Received: from pjir1.prod.google.com ([2002:a17:90a:5c81:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2883:b0:32e:3830:65d5
 with SMTP id 98e67ed59e1d1-33bcf9222aemr1525254a91.36.1760661198266; Thu, 16
 Oct 2025 17:33:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:35 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-18-seanjc@google.com>
Subject: [PATCH v3 17/25] KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
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

Add TDX_BUG_ON() macros (with varying numbers of arguments) to deduplicate
the myriad flows that do KVM_BUG_ON()/WARN_ON_ONCE() followed by a call to
pr_tdx_error().  In addition to reducing boilerplate copy+paste code, this
also helps ensure that KVM provides consistent handling of SEAMCALL errors.

Opportunistically convert a handful of bare WARN_ON_ONCE() paths to the
equivalent of KVM_BUG_ON(), i.e. have them terminate the VM.  If a SEAMCALL
error is fatal enough to WARN on, it's fatal enough to terminate the TD.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d77b2de6db8a..2d587a38581e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -24,20 +24,32 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define pr_tdx_error(__fn, __err)	\
-	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
+#define __TDX_BUG_ON(__err, __f, __kvm, __fmt, __args...)			\
+({										\
+	struct kvm *_kvm = (__kvm);						\
+	bool __ret = !!(__err);							\
+										\
+	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
+		if (_kvm)							\
+			kvm_vm_bugged(_kvm);					\
+		pr_err_ratelimited("SEAMCALL " __f " failed: 0x%llx" __fmt "\n",\
+				   __err,  __args);				\
+	}									\
+	unlikely(__ret);							\
+})
 
-#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
-	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
+#define TDX_BUG_ON(__err, __fn, __kvm)				\
+	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
 
-#define pr_tdx_error_1(__fn, __err, __rcx)		\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
+#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
 
-#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
+#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
+
+#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
 
-#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
 
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -313,10 +325,9 @@ static int __tdx_reclaim_page(struct page *page)
 	 * before the HKID is released and control pages have also been
 	 * released at this point, so there is no possibility of contention.
 	 */
-	if (WARN_ON_ONCE(err)) {
-		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, rcx, rdx, r8);
+	if (TDX_BUG_ON_3(err, TDH_PHYMEM_PAGE_RECLAIM, rcx, rdx, r8, NULL))
 		return -EIO;
-	}
+
 	return 0;
 }
 
@@ -404,8 +415,8 @@ static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
 		return;
 
 	smp_call_function_single(cpu, tdx_flush_vp, &arg, 1);
-	if (KVM_BUG_ON(arg.err, vcpu->kvm))
-		pr_tdx_error(TDH_VP_FLUSH, arg.err);
+
+	TDX_BUG_ON(arg.err, TDH_VP_FLUSH, vcpu->kvm);
 }
 
 void tdx_disable_virtualization_cpu(void)
@@ -464,8 +475,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 	}
 
 out:
-	if (WARN_ON_ONCE(err))
-		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
+	TDX_BUG_ON(err, TDH_PHYMEM_CACHE_WB, NULL);
 }
 
 void tdx_mmu_release_hkid(struct kvm *kvm)
@@ -504,8 +514,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
 	if (err == TDX_FLUSHVP_NOT_DONE)
 		goto out;
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
+	if (TDX_BUG_ON(err, TDH_MNG_VPFLUSHDONE, kvm)) {
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
 		       kvm_tdx->hkid);
 		goto out;
@@ -528,8 +537,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * tdh_mng_key_freeid() will fail.
 	 */
 	err = tdh_mng_key_freeid(&kvm_tdx->td);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
+	if (TDX_BUG_ON(err, TDH_MNG_KEY_FREEID, kvm)) {
 		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
 		       kvm_tdx->hkid);
 	} else {
@@ -580,10 +588,9 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	 * when it is reclaiming TDCS).
 	 */
 	err = tdh_phymem_page_wbinvd_tdr(&kvm_tdx->td);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
-	}
+
 	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
 
 	__free_page(kvm_tdx->td.tdr_page);
@@ -606,11 +613,8 @@ static int tdx_do_tdh_mng_key_config(void *param)
 
 	/* TDX_RND_NO_ENTROPY related retries are handled by sc_retry() */
 	err = tdh_mng_key_config(&kvm_tdx->td);
-
-	if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
-		pr_tdx_error(TDH_MNG_KEY_CONFIG, err);
+	if (TDX_BUG_ON(err, TDH_MNG_KEY_CONFIG, &kvm_tdx->kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1601,10 +1605,8 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_ADD, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_ADD, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1623,10 +1625,8 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_AUG, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1671,10 +1671,8 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1722,8 +1720,7 @@ static void tdx_track(struct kvm *kvm)
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm))
-		pr_tdx_error(TDH_MEM_TRACK, err);
+	TDX_BUG_ON(err, TDH_MEM_TRACK, kvm);
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
@@ -1780,10 +1777,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
 		return;
-	}
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
@@ -1810,16 +1805,12 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
-	}
 
 	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
-	}
 
 	tdx_quirk_reset_page(page);
 }
@@ -2459,8 +2450,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_packages;
 	}
 
-	if (WARN_ON_ONCE(err)) {
-		pr_tdx_error(TDH_MNG_CREATE, err);
+	if (TDX_BUG_ON(err, TDH_MNG_CREATE, kvm)) {
 		ret = -EIO;
 		goto free_packages;
 	}
@@ -2501,8 +2491,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 			ret = -EAGAIN;
 			goto teardown;
 		}
-		if (WARN_ON_ONCE(err)) {
-			pr_tdx_error(TDH_MNG_ADDCX, err);
+		if (TDX_BUG_ON(err, TDH_MNG_ADDCX, kvm)) {
 			ret = -EIO;
 			goto teardown;
 		}
@@ -2519,8 +2508,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		*seamcall_err = err;
 		ret = -EINVAL;
 		goto teardown;
-	} else if (WARN_ON_ONCE(err)) {
-		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
+	} else if (TDX_BUG_ON_1(err, TDH_MNG_INIT, rcx, kvm)) {
 		ret = -EIO;
 		goto teardown;
 	}
@@ -2788,10 +2776,8 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
 	if (tdx_operand_busy(cmd->hw_error))
 		return -EBUSY;
-	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
-		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
+	if (TDX_BUG_ON(cmd->hw_error, TDH_MR_FINALIZE, kvm))
 		return -EIO;
-	}
 
 	kvm_tdx->state = TD_STATE_RUNNABLE;
 	/* TD_STATE_RUNNABLE must be set before 'pre_fault_allowed' */
@@ -2878,16 +2864,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	err = tdh_vp_create(&kvm_tdx->td, &tdx->vp);
-	if (KVM_BUG_ON(err, vcpu->kvm)) {
+	if (TDX_BUG_ON(err, TDH_VP_CREATE, vcpu->kvm)) {
 		ret = -EIO;
-		pr_tdx_error(TDH_VP_CREATE, err);
 		goto free_tdcx;
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
 		err = tdh_vp_addcx(&tdx->vp, tdx->vp.tdcx_pages[i]);
-		if (KVM_BUG_ON(err, vcpu->kvm)) {
-			pr_tdx_error(TDH_VP_ADDCX, err);
+		if (TDX_BUG_ON(err, TDH_VP_ADDCX, vcpu->kvm)) {
 			/*
 			 * Pages already added are reclaimed by the vcpu_free
 			 * method, but the rest are freed here.
@@ -2901,10 +2885,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
-	if (KVM_BUG_ON(err, vcpu->kvm)) {
-		pr_tdx_error(TDH_VP_INIT, err);
+	if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
 		return -EIO;
-	}
 
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
@@ -3111,10 +3093,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
 		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
-		if (KVM_BUG_ON(err, kvm)) {
-			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
+		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
 			return -EIO;
-		}
 	}
 
 	return 0;
-- 
2.51.0.858.gf9c4a03a3a-goog

