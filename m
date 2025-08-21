Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C942D480F
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810053; cv=none; b=Abab8AXvwXiHySD+qjGPV6WsH1l+vhnMUO9i1vdhT9LWKY0pT7q6YDop3l4cCS72aU7Nfd8BFEOvvJwTUoOn+oozY2Yi49sY/nzJ4PnhkE9ZwcbVOgKkJ1t2zCi8Lcuru2z3kCVB4dIPPFHmGlGlwSldmkKdpSUd1oTIUHxYto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810053; c=relaxed/simple;
	bh=j602bYy7T//lg/va0rJT1q0ixQZt9Mt92VBF3wJ5dKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KfLq//Al8hp5fLs2a3vf73fKAwoUMTGagS0199gqKFmHz9wwJNqdq9+VbUcMbQo/Ghc/dm/FJ86HVIRwY9/J7HtlrT55ccvbSPcnQMStKFTcyTZrKmRgmXiReYL4riL8+umfX1aVA/cAfdeOXXeg74hmB5m64gXS0Kmu+46SVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPkM+ZCV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPkM+ZCV"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47610d3879so1134187a12.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810051; x=1756414851; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1Z7dlZxBw5nHn1FPuYZbn+Y0LXB1yXFMLEbzmKHn2A=;
        b=LPkM+ZCVVIUsqeCgfJGyNeonutEqCM9L37ZluK7XCOCS1DZZ8aXX0c8lWWuh2VhfcO
         fY3vfnvLyt2vVYcaOwqtbN3m1rKh4Bn/x0i/QnmFE84TGYx08AuggDk62L8HS3e4h+h5
         rrsTDmpK9W+kUioBGT1OYzX3KsITb73YUIy9GuTYKt9mlIPoWUoFqAQMXmrysHat3jzZ
         cCAv/+hvWx1a0Q5Av4jXAScO5B2M0KVTlybGrivLpXEnWwWfBEsNUPcURnr+8It16cDG
         Xe8EMfSN6x9MrUIjK0GUcYZ2YdJ8mCeWt+0U2ppi8VGoEcwg4ymdHnzNOzSb22LcQCfa
         Bpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810051; x=1756414851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1Z7dlZxBw5nHn1FPuYZbn+Y0LXB1yXFMLEbzmKHn2A=;
        b=dVcUQuUWtrUvXgfolGWA15T5oxFQRNMmoW+0o6RX2n2KM26QAPwx/qup8HL+k3SEaF
         vA7lWy/h7/g29r9qpBbs838QllwHL2J9ZjGtZj2f6v5oeq1xPtdMPEqgy9xYTK4LPT+Y
         1b28QwWwQ9rTNORgjOjI/s0Mn2fozHsI7bUcfyijxlpSJbCNGRPeV/0jcILZyHO2VJmi
         mbspMPo/p2BsxbOXtv4IymZy1UR1yQTmiVvcYqwh2BKS2P+Vu/EMjP+7zhdTW/s3+API
         0oc+0rVC0f4nd1iwI6POB4aKbbmzi1597TxVjq0eK9P4iyc7jkt4tGujSBrNt55gp/EI
         yIvA==
X-Forwarded-Encrypted: i=1; AJvYcCXOiPPYwI8hNhLt6yNzjIHBV4Uchd8Z72HKwaaOryCimV41FrZ8fMk95dlujsKbXS8EP1VMe4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzV6crhkaOQpV7wyez98KNwFBp1gk8dmuZFmWcNfFLSpOhRbE9G
	9aEVj6PQm5JaGrFiMTYzgwieQPt1nRY8GF02rk5zrCZQEaOLS+LtQhxa73mXiko97Y/ql0CbVdQ
	+GEGLpg==
X-Google-Smtp-Source: AGHT+IFM0DDRKUEvT6bUujvJ11ucFjwG7bXTKg/FynvNfyXGnyLk/rw/50Ds3R7JLyodH6b8OqA5quCXy9I=
X-Received: from pfbfj2.prod.google.com ([2002:a05:6a00:3a02:b0:76b:c53c:7184])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5483:b0:240:11b3:bf2e
 with SMTP id adf61e73a8af0-24340b5b48bmr715813637.16.1755810050610; Thu, 21
 Aug 2025 14:00:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:29 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-4-seanjc@google.com>
Subject: [RFC PATCH 03/16] KVM: arm64: Move SRCU-protected region of
 kvm_handle_guest_abort() to helper
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the SRCU-protected portion of the abort handler to a separate helper
in anticipation of adding "struct kvm_page_fault" to track state related
to resolving the fault.  Using a separate helper will allow making several
fields in kvm_page_fault "const", without having to do something funky
like create a temporary copy in the middle of kvm_handle_guest_abort().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 172 ++++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1e3ac283c519..de028471b9eb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1811,82 +1811,16 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-/**
- * kvm_handle_guest_abort - handles all 2nd stage aborts
- * @vcpu:	the VCPU pointer
- *
- * Any abort that gets to the host is almost guaranteed to be caused by a
- * missing second stage translation table entry, which can mean that either the
- * guest simply needs more memory and we must allocate an appropriate page or it
- * can mean that the guest tried to access I/O memory, which is emulated by user
- * space. The distinction is based on the IPA causing the fault and whether this
- * memory region has been registered as standard RAM by user space.
- */
-int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
+static int __kvm_handle_guest_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+				    unsigned long esr)
 {
 	struct kvm_s2_trans nested_trans, *nested = NULL;
-	unsigned long esr;
-	phys_addr_t fault_ipa; /* The address we faulted on */
-	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
-	unsigned long hva;
 	bool write_fault, writable;
+	unsigned long hva;
+	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	gfn_t gfn;
-	int ret, idx;
-
-	/* Synchronous External Abort? */
-	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea())
-			return kvm_inject_serror(vcpu);
-
-		return 1;
-	}
-
-	esr = kvm_vcpu_get_esr(vcpu);
-
-	/*
-	 * The fault IPA should be reliable at this point as we're not dealing
-	 * with an SEA.
-	 */
-	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
-	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
-		return -EFAULT;
-
-	if (esr_fsc_is_translation_fault(esr)) {
-		/* Beyond sanitised PARange (which is the IPA limit) */
-		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
-			kvm_inject_size_fault(vcpu);
-			return 1;
-		}
-
-		/* Falls between the IPA range and the PARange? */
-		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
-			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
-
-			return kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu),
-					      fault_ipa);
-		}
-	}
-
-	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
-			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
-
-	/* Check the stage-2 fault is trans. fault or write fault */
-	if (!esr_fsc_is_translation_fault(esr) &&
-	    !esr_fsc_is_permission_fault(esr) &&
-	    !esr_fsc_is_access_flag_fault(esr)) {
-		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
-			kvm_vcpu_trap_get_class(vcpu),
-			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
-			(unsigned long)kvm_vcpu_get_esr(vcpu));
-		return -EFAULT;
-	}
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	int ret;
 
 	/*
 	 * We may have faulted on a shadow stage 2 page table if we are
@@ -1906,13 +1840,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
 		if (ret) {
 			kvm_inject_s2_fault(vcpu, kvm_s2_trans_esr(&nested_trans));
-			goto out_unlock;
+			return ret;
 		}
 
 		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
 		if (ret) {
 			kvm_inject_s2_fault(vcpu, kvm_s2_trans_esr(&nested_trans));
-			goto out_unlock;
+			return ret;
 		}
 
 		ipa = kvm_s2_trans_output(&nested_trans);
@@ -1935,10 +1869,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		if (kvm_vcpu_abt_iss1tw(vcpu)) {
-			ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-			goto out_unlock;
-		}
+		if (kvm_vcpu_abt_iss1tw(vcpu))
+			return kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
 		/*
 		 * Check for a cache maintenance operation. Since we
@@ -1952,8 +1884,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
 			kvm_incr_pc(vcpu);
-			ret = 1;
-			goto out_unlock;
+			return 1;
 		}
 
 		/*
@@ -1963,8 +1894,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
-		ret = io_mem_abort(vcpu, ipa);
-		goto out_unlock;
+		return io_mem_abort(vcpu, ipa);
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
@@ -1972,8 +1902,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	if (esr_fsc_is_access_flag_fault(esr)) {
 		handle_access_fault(vcpu, fault_ipa);
-		ret = 1;
-		goto out_unlock;
+		return 1;
 	}
 
 	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
@@ -1983,7 +1912,82 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 out:
 	if (ret == -ENOEXEC)
 		ret = kvm_inject_sea_iabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-out_unlock:
+	return ret;
+}
+
+/**
+ * kvm_handle_guest_abort - handles all 2nd stage aborts
+ * @vcpu:	the VCPU pointer
+ *
+ * Any abort that gets to the host is almost guaranteed to be caused by a
+ * missing second stage translation table entry, which can mean that either the
+ * guest simply needs more memory and we must allocate an appropriate page or it
+ * can mean that the guest tried to access I/O memory, which is emulated by user
+ * space. The distinction is based on the IPA causing the fault and whether this
+ * memory region has been registered as standard RAM by user space.
+ */
+int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
+{
+	unsigned long esr;
+	phys_addr_t fault_ipa; /* The address we faulted on */
+	int ret, idx;
+
+	/* Synchronous External Abort? */
+	if (kvm_vcpu_abt_issea(vcpu)) {
+		/*
+		 * For RAS the host kernel may handle this abort.
+		 * There is no need to pass the error into the guest.
+		 */
+		if (kvm_handle_guest_sea())
+			return kvm_inject_serror(vcpu);
+
+		return 1;
+	}
+
+	esr = kvm_vcpu_get_esr(vcpu);
+
+	/*
+	 * The fault IPA should be reliable at this point as we're not dealing
+	 * with an SEA.
+	 */
+	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	if (KVM_BUG_ON(fault_ipa == INVALID_GPA, vcpu->kvm))
+		return -EFAULT;
+
+	if (esr_fsc_is_translation_fault(esr)) {
+		/* Beyond sanitised PARange (which is the IPA limit) */
+		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
+			kvm_inject_size_fault(vcpu);
+			return 1;
+		}
+
+		/* Falls between the IPA range and the PARange? */
+		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
+			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+			return kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu),
+					      fault_ipa);
+		}
+	}
+
+	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
+			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
+
+	/* Check the stage-2 fault is trans. fault or write fault */
+	if (!esr_fsc_is_translation_fault(esr) &&
+	    !esr_fsc_is_permission_fault(esr) &&
+	    !esr_fsc_is_access_flag_fault(esr)) {
+		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
+			kvm_vcpu_trap_get_class(vcpu),
+			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
+			(unsigned long)kvm_vcpu_get_esr(vcpu));
+		return -EFAULT;
+	}
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	ret = __kvm_handle_guest_abort(vcpu, fault_ipa, esr);
+
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return ret;
 }
-- 
2.51.0.261.g7ce5a0a67e-goog

