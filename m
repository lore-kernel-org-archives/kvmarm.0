Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BFD287511
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661194; cv=none; b=gBYFMBWsy4VWtx0Z3yiy6e58TL+7nw7zObdyiXtoGlcQ/OPkp57LoZrVli7oNktlZnM7CXwdy1fYBZ4jSyHjklPEq53R++Lz9093noHzz52k74IOWP4kP+OW3GfGh53XRhX3zt5bTCn853cAUCMSMkkP1x59IP/dO+PCckhJY20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661194; c=relaxed/simple;
	bh=g9XE/XmOjyDDyTFp1eZETSR7kpDfFGyQ7oUmnFxVe5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i8OcC2+YvrFCuOC572sIvDy1CIW4RwpLUzqiyHfxX5hHizYdGZ9rF5mFm9Dl+R5DzEjt2fOFrZEtu/nv6yCyzdu5e2dvpKhVpUOzfaL+kjufjbTASePOx2P4ucmOBrw8ZRlJmwdeSXe2CdAQIa8Fl9rwdzr4KbStJp3TzOXI49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4AE8NTRG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4AE8NTRG"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so2174531a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661191; x=1761265991; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tdDvnnMBi79Itp61RxW2nV56QIHnitcyrtTO64NTOt8=;
        b=4AE8NTRGrqjQBBl5S0EhLHNt8PM7/kjAIff0b0iCJRXmsRRNBm6w8aHuXlYGgKxy3q
         y7MvkNXU5AMGsADgiwdnxd2MdEFHT35leK94+anlkfTjNc+xvqoyAf78oG1o4mt3OzLq
         7Qc5isIHdv1i8kcSr72VfxeM0IFo0xlGz4a44yB/XN7UsQnbQ/WWnrgaczyhgQ3xq60f
         6r8JZrvhEjFYlq6t0N317CEzldkoI+dpaMTJ85GB4b+PZKBd2m/tJ0P42x3PJau9gBrU
         aTmiJrF/tdI37VKQXz6yaVwsKxKrkKnPbDQxPNR3pIyoajNy8geKz5wHJoDSeYEEjgZZ
         UZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661191; x=1761265991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tdDvnnMBi79Itp61RxW2nV56QIHnitcyrtTO64NTOt8=;
        b=uZ1plPfcfycnmNWER5dKGRFHe/jTxk0o1j99g5kF0hae+kI43MBdiBUZri5pulgNXS
         bANs1oBaAzP4fFoz3ubRCdw5dx2SVyc4iN3xt9qayyB/UmgcedR54M6ibAlRS/uA0Let
         1voXJeI2JHJ4JnkN4JpZ3FpsMVFJ7PYOahVnaiwF2F2T3XNtPsus6leJQSHY1eLghep5
         E/TdNdqc/vFMb4MAONlDb2MmoL057qztOTyX4x6kkbf0tjMu+2YEEBpxX4BiwcCzgcmL
         f3ddc9W7D5p93OJf33wn9mzE1XYerEnELQ9kZFZ1KM/K+bMxHNvqNmr/IO4K7SAO1dPy
         HMTw==
X-Forwarded-Encrypted: i=1; AJvYcCWWwUJhxKerZf8QohIkQL5sC7hRL5YvafcchPRF0or3bLYdPoyoEYRgU+ZQYwkBKw+YCbDcJjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxVi8Z0s+/RP6PIISA+DnAP5gtOl20vusBwk1xAvv/UdZ5+705
	w251JW8+IOyIDjjHixf94ATqom9SsQd8BKR6PENE10XtHU4O3gdGq7XDrUwy0wdn3N+DE2hp692
	82RrnxA==
X-Google-Smtp-Source: AGHT+IFjbvhuJBf5rM9mXEGAaRcwet/6S3ph7hsVNQrCN7ddhA3ec/NJFjzeh48C6n1kB16/mom5cp7HTgE=
X-Received: from pjso17.prod.google.com ([2002:a17:90a:c091:b0:32e:3830:65f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc4:b0:330:6f13:53fc
 with SMTP id 98e67ed59e1d1-33bcf8f870bmr1842078a91.27.1760661191207; Thu, 16
 Oct 2025 17:33:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:31 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-14-seanjc@google.com>
Subject: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into
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
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6c0adc1b3bd5..c37591730cc5 100644
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
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -1638,14 +1615,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 
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
+	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pages
+	 * have been added to the image, to prevent running the TD with a
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
2.51.0.858.gf9c4a03a3a-goog

