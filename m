Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53126E6E8
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368538; cv=none; b=I4XUOIWB1+NrEzaZAn3oErjpZEIKgVMYcJvtH/98qCNaH54ng0jgCSJEAx9gXJb0tcpVLVzNL1P/3OC3B447U7R9r3pP/LuI1jcjf7LbTmY/ozLCjnzb8QXecGpvDKroGNbmfsWAdkCNr91WtIWQF23HQlBwAFHMooCCCRXGA/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368538; c=relaxed/simple;
	bh=Dswut1G5DDjWHJ+VMwG3xofi3zOAgNz/greVPQp+nQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmCQjTKUslu6ZZZDmuNDBUEFLrJXM2BMhCqQbjvW+X2m90CAOxLy2DlwrKeCpafdk9mWnXfIW3uAj3LflWRc8+yEwu6Wuyn5g9vNpagHXWlw/n8F4cXcGnHSX/OubuQzyCgw+qQO5DgzWFRfJJkaZBuxhTCZ/H5k4MHDu7muLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BvG//cjg; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvG//cjg"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e47cca387so43588345e9.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 08:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760368534; x=1760973334; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+OYsx4qVrjFLJooxBU/tije1VKpZvCGcY9McxgoCoE=;
        b=BvG//cjgKVo81l7e197ASM1Kzp41keKiLVLEoD1uL/tH4jLteVQMAC58CG0yXm+P+u
         neCE2mG6H8iz8/S1bZTw5va8OiSxLa7JvycAELumcd9++IEtx1IO8sX7ltB02JBatJt/
         rVFiwOOWMGmZNEuMhmNO4U4qbb1ZnLbL7BCvz0/xRvvhW6kJrc1jrfHB2ukMnczhKdse
         yK/mvXOyeYohLOcCW0aZtExPM21oCdQuJriaCd4QQyUAGTAh3NJgs/udHQ28/vRA/yiH
         VtUvOQKNi8o0oF2pRlKOiDmoWvXsissr997GbfmdWxwUriWIb22VuAzi1uUqFGSn+00/
         2DQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368534; x=1760973334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+OYsx4qVrjFLJooxBU/tije1VKpZvCGcY9McxgoCoE=;
        b=ctTe6Q7Bgx0XXxBFzEqeaCpwaJzLNQsyV0KPz1QqsNcQF3QoOO2avabHM5oMR4v88O
         evh0S95VzJAjZOahjvF7guVL6B8FbH17SKSIruLqokogNLlLmptZMLF6QXbFiO/NZNHT
         2w/d2gAlyTyWrJJxmwGmNCQBCVNzaH68EWFm/Anrl6ksDfp32P0A/IAzY1w3R7GsXLU/
         0Y4TW6wOwB4fuGNQ0gFxDMJB6UWQaDRjMeXpntbMKtuk7m8VLgNqpFPtcINGXJwi+ERH
         aYR9OGALPjkZKrbhAv1RhYMcLPnJkbT9elWQrHStrP20ggjPdDp97DeAZrfEMbKklJCW
         2FXw==
X-Forwarded-Encrypted: i=1; AJvYcCVD0TvtAU3FeNtoOe4/prSoFrNNhC9gHYaTzzlmz6rXDtAVA3h8KiWxQdu4AXuvKGFWZ3utltM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/aZppZiXIPaq86i61UoRu1+69+wwv8lzTaT77qnQhWFxo9SM/
	QYuBHPHIxGypvJBSphzbffR5j9D/OATSelZTo2EhbkZBhR/itvUN/uhe
X-Gm-Gg: ASbGncs8v3OOub8tyIHjPtjfHgcUWbcHZxEH//ucamXiF3/KIiXs7cMjTK0Z57Omyiy
	Bw+1GhmnjFHJlYqUnD7mhVeUrPHIZrAlvAtaEtCaror+DrvHyY+hk001q9rgI57MuUMXBc0jARV
	/GFrVt+pXfKamcJYCDv047Do3EpBOAxSeci5rFQrwsZ1fncy/YI+t2UBXAT1Ak/xO2p38a1bzkn
	OQKk3fVIuY88B/pbZZ2T8lrarvjPUaQTMN7fjMpaRUYMb6gLaXCwUGV7DNUV/CRhiLhVjZ+8f/1
	7CTQkbp7wZa+5cgWoqIDw1GED9rywdHI/lWi78CVpt2nEFBd2Opqy7YjeWaRp8MRCePda7guy3/
	gt7g72QnqqXPWU/7B22LhcAIjJ9A6C1/nEUz/EFAKwASTgXYlkVvMIKtOuh4JKHUkDzkmSFWKTk
	UKH9cy
X-Google-Smtp-Source: AGHT+IG8YKjqV8/Bcai3s9JU+QHESTLB1iWcAO0SGLhAlri+L595vz6YBO/3o6gN4/HNAHvPqWUe0g==
X-Received: by 2002:a05:600c:8b42:b0:45d:e6b6:55fe with SMTP id 5b1f17b1804b1-46fa9b16607mr164819835e9.34.1760368534209;
        Mon, 13 Oct 2025 08:15:34 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36a773sm135545825e9.0.2025.10.13.08.15.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 08:15:34 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH v2 1/4] KVM: arm64: Add pre_fault_memory implementation
Date: Mon, 13 Oct 2025 16:14:58 +0100
Message-ID: <20251013151502.6679-2-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251013151502.6679-1-jackabt.amazon@gmail.com>
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add kvm_arch_vcpu_pre_fault_memory() for arm64. The implementation hands
off the stage-2 faulting logic to either gmem_abort() or
user_mem_abort().

Add an optional page_size output parameter to user_mem_abort() to
return the VMA page size, which is needed when pre-faulting.

Update the documentation to clarify x86 specific behaviour.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 Documentation/virt/kvm/api.rst |  3 +-
 arch/arm64/kvm/Kconfig         |  1 +
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 73 ++++++++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c17a87a0a5ac..9e8cc4eb505d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6461,7 +6461,8 @@ Errors:
 KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
 for the current vCPU state.  KVM maps memory as if the vCPU generated a
 stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
-CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
+CoW.  However, on x86, KVM does not mark any newly created stage-2 PTE as
+Accessed.
 
 In the case of confidential VM types where there is an initial set up of
 private guest memory before the guest is 'finalized'/measured, this ioctl
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index bff62e75d681..1ac0605f86cb 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,6 +25,7 @@ menuconfig KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_VFIO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..65654a742864 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -322,6 +322,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
+	case KVM_CAP_PRE_FAULT_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a36426ccd9b5..82f122e4b08c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1597,8 +1597,8 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+			  struct kvm_memory_slot *memslot, long *page_size,
+			  unsigned long hva, bool fault_is_perm)
 {
 	int ret = 0;
 	bool topup_memcache;
@@ -1871,6 +1871,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
+	if (page_size)
+		*page_size = vma_pagesize;
+
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
@@ -2069,8 +2072,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
 				 esr_fsc_is_permission_fault(esr));
 	else
-		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-				     esr_fsc_is_permission_fault(esr));
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, NULL,
+				     hva, esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
@@ -2446,3 +2449,65 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	int ret, idx;
+	hva_t hva;
+	phys_addr_t end;
+	struct kvm_memory_slot *memslot;
+	struct kvm_vcpu_fault_info stored_fault, *fault_info;
+
+	long page_size = PAGE_SIZE;
+	phys_addr_t ipa = range->gpa;
+	gfn_t gfn = gpa_to_gfn(range->gpa);
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	if (ipa >= kvm_phys_size(vcpu->arch.hw_mmu)) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	fault_info = &vcpu->arch.fault;
+	stored_fault = *fault_info;
+
+	/* Generate a synthetic abort for the pre-fault address */
+	fault_info->esr_el2 = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_CUR);
+	fault_info->esr_el2 &= ~ESR_ELx_ISV;
+	fault_info->esr_el2 |= ESR_ELx_FSC_FAULT_L(KVM_PGTABLE_LAST_LEVEL);
+
+	fault_info->hpfar_el2 = HPFAR_EL2_NS |
+		FIELD_PREP(HPFAR_EL2_FIPA, ipa >> 12);
+
+	if (kvm_slot_has_gmem(memslot)) {
+		ret = gmem_abort(vcpu, ipa, NULL, memslot, false);
+	} else {
+		hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
+		if (kvm_is_error_hva(hva)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		ret = user_mem_abort(vcpu, ipa, NULL, memslot, &page_size, hva,
+				     false);
+	}
+
+	if (ret < 0)
+		goto out;
+
+	end = (range->gpa & ~(page_size - 1)) + page_size;
+	ret = min(range->size, end - range->gpa);
+
+out:
+	*fault_info = stored_fault;
+out_unlock:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}
-- 
2.43.0

