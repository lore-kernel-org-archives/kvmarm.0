Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9C025A2C9
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753995538; cv=none; b=nKLmbb5IFV45qk2vqfdzUzxU0Rt9LHkSWURKvIB8rCyc0Klfk+hHsqWSh7EOxEfCTMZwS0OaXT1ssF3xdCCCu8Lc9NDdWtGdBYK6U4Y2TeGiHFS0BVQ/gjUVU3/cyNumB5GdWdTX4qkL6pGEdYUrihm4nmSRv4iuKDf0vW0uUIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753995538; c=relaxed/simple;
	bh=oZmAKS0zc6NvOTUiVXiXnE1DVkxtGlCzd92lP34vsmo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PKHlghPJg+InpMhj+uhlBhm38nmC6btb5My9sz4+Ppw05hn6pORdmjbyfqqo4UpljSjlVWhik8yuwScHj7MWujSvsIRxuI2NkQFviV62O7belTWUySPxFXhmVDFkmqfVJ9JbD3ZfWWOoUhkEmeLHVBzoyWdTKxnhbS/rnSahmiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Dh522u2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Dh522u2"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2403c86ff97so2547165ad.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 13:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753995535; x=1754600335; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eOUpQzKtFZYeNywfqlT/YzIj7U1gzFp8S5SCwF5sOXg=;
        b=0Dh522u2L0awXDVuGNb60Aa/K92YI3mU3YPYiiO9Kzm7Tso732hnSw6liP5Bw8ryJ5
         56XmnJY5hAuCLljWzP7k7JH2N9gWGYAp1z6fMneOhF56OlotxrnXy1afoEjYdk1Ch9FZ
         WsbhVAOameMJBO2WLsS9nFt5kBhWe4Lisvl3U3lJx+tzHzU5szqC6JD35kW9augo5r5G
         8dX3bI8ijKwKnMmhPMwoR+CZ/AR1dtkFSC2+C0DxcUFra22WPKEkIgdUK5gxpS9APt9u
         iEiciauBMtY2nCiZwbgOBV7ej8VuaaLCBTePBKYfAD+ak6rUJxxP3w51yNqnGTuO7ojI
         2n5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753995535; x=1754600335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eOUpQzKtFZYeNywfqlT/YzIj7U1gzFp8S5SCwF5sOXg=;
        b=Ze4M2JFoYW7ioTinqsI3wXPW8U3m7ugFTAQUCnryh3i/dZiFxARNS86KbxIteR8SUw
         CikSGJWicvCnEMpTDXwoDxcj3LRXvb8vW3DoI5WAKGl6hTrtjlvju7vB33gPk312qL91
         uD9KMigh+wTo1aaEltLlFLEYGiyLJa7pFdaPCB28EFD5C9+eV0Iynut9n75DGW/thyWF
         GXtyJsFZ2PwFdhLiuTNzmPlF6YrQ6Rw1psVCD6kJad3WbOV2+BtRBVsDxAk76woEbVC2
         eyg9egFnBDcRpAQvzq0Vc82+ZaVTb2eZXausdhHu1d1PO7kYR1RrF11jqtfZRH7cd4E4
         4t9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMn+FFRJBUwN+wvkpTV9q+5pKya5uGqUD2SKQJNk4EfPiLp9sUTsYIPQ200VYmGjs2+AY5Tr8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3DYAghvVxrQNnA3/kahZqIDzXyBeSzZTn5rstSDW1d2SdBcW7
	7XKYBVRLt1Yq8+WXW6Z3+dDWJIXAq+uKyyv5h5a2aTJVIs9pm/j+lEyRWdgQLvkV9kQ2jDMNn7/
	23iALZbV/CISbkg==
X-Google-Smtp-Source: AGHT+IFYBd0n/6m6Ox1Nv0VY06rvT/P3u/kIBdHylp6A2OvXCXAjXPjyyd0PyslE+N1LWREbAdmRywkwsgANvQ==
X-Received: from plbu12.prod.google.com ([2002:a17:902:e20c:b0:240:801d:1089])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5cd:b0:240:678c:d2b7 with SMTP id d9443c01a7336-24096ab6fc1mr124071855ad.15.1753995535319;
 Thu, 31 Jul 2025 13:58:55 -0700 (PDT)
Date: Thu, 31 Jul 2025 20:58:42 +0000
In-Reply-To: <20250731205844.1346839-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250731205844.1346839-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731205844.1346839-2-jiaqiyan@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: VM exit to userspace to handle SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

When APEI fails to handle a stage-2 synchronous external abort (SEA),
today KVM directly injects an async SError to the VCPU then resumes it,
which usually results in unpleasant guest kernel panic.

One major situation of guest SEA is when vCPU consumes recoverable
uncorrected memory error (UER). Although SError and guest kernel panic
effectively stops the propagation of corrupted memory, guest may
re-use the corrupted memory if auto-rebooted; in worse case, guest
boot may run into poisoned memory. So there is room to recover from
an UER in a more graceful manner.

Alternatively KVM can redirect the synchronous SEA event to VMM to
- Reduce blast radius if possible. VMM can inject a SEA to VCPU via
  KVM's existing KVM_SET_VCPU_EVENTS API. If the memory poison
  consumption or fault is not from guest kernel, blast radius can be
  limited to the triggering thread in guest userspace, so VM can
  keep running.
- Allow VMM to protect from future memory poison consumption by
  unmapping the page from stage-2, or to interrupt guest of the
  poisoned page so guest kernel can unmap it from stage-1 page table.
- Allow VMM to track SEA events that VM customers care about, to restart
  VM when certain number of distinct poison events have happened,
  to provide observability to customers in log management UI.

Introduce an userspace-visible feature to enable VMM handle SEA:
- KVM_CAP_ARM_SEA_TO_USER. As the alternative fallback behavior
  when host APEI fails to claim a SEA, userspace can opt in this new
  capability to let KVM exit to userspace during SEA if it is not
  owned by host.
- KVM_EXIT_ARM_SEA. A new exit reason is introduced for this.
  KVM fills kvm_run.arm_sea with as much as possible information about
  the SEA, enabling VMM to emulate SEA to guest by itself.
  - Sanitized ESR_EL2. The general rule is to keep only the bits
    useful for userspace and relevant to guest memory.
  - Flags indicating if faulting guest physical address is valid.
  - Faulting guest physical and virtual addresses if valid.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/arm.c              |  5 +++
 arch/arm64/kvm/mmu.c              | 68 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h          | 10 +++++
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d373d555a69ba..8b4133a5aacf3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -349,6 +349,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	/* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace */
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
+	/* Unhandled SEAs are taken to userspace */
+#define KVM_ARCH_FLAG_EXIT_SEA				11
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7a1a8210ff918..aec6034db1e75 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -133,6 +133,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SEA_TO_USER:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
+		break;
 	default:
 		break;
 	}
@@ -322,6 +326,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
+	case KVM_CAP_ARM_SEA_TO_USER:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9a45daf817bfd..f6a545700c15b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1812,8 +1812,48 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
+/*
+ * Returns true if the SEA should be handled locally within KVM if the abort
+ * is caused by a kernel memory allocation (e.g. stage-2 table memory).
+ */
+static bool host_owns_sea(struct kvm_vcpu *vcpu, u64 esr)
+{
+	/*
+	 * Without FEAT_RAS HCR_EL2.TEA is RES0, meaning any external abort
+	 * taken from a guest EL to EL2 is due to a host-imposed access (e.g.
+	 * stage-2 PTW).
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return true;
+
+	/* KVM owns the VNCR when the vCPU isn't in a nested context. */
+	if (is_hyp_ctxt(vcpu) && (esr & ESR_ELx_VNCR))
+		return true;
+
+	/*
+	 * Determine if an external abort during a table walk happened at
+	 * stage-2 is only possible when S1PTW is set. Otherwise, since KVM
+	 * sets HCR_EL2.TEA, SEAs due to a stage-1 walk (i.e. accessing the
+	 * PA of the stage-1 descriptor) can reach here and are reported
+	 * with a TTW ESR value.
+	 */
+	return (esr_fsc_is_sea_ttw(esr) && (esr & ESR_ELx_S1PTW));
+}
+
 int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_run *run = vcpu->run;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr_mask = ESR_ELx_EC_MASK	|
+		       ESR_ELx_IL	|
+		       ESR_ELx_FnV	|
+		       ESR_ELx_EA	|
+		       ESR_ELx_CM	|
+		       ESR_ELx_WNR	|
+		       ESR_ELx_FSC;
+	u64 ipa;
+
 	/*
 	 * Give APEI the opportunity to claim the abort before handling it
 	 * within KVM. apei_claim_sea() expects to be called with IRQs enabled.
@@ -1822,7 +1862,33 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 	if (apei_claim_sea(NULL) == 0)
 		return 1;
 
-	return kvm_inject_serror(vcpu);
+	if (host_owns_sea(vcpu, esr) ||
+	    !test_bit(KVM_ARCH_FLAG_EXIT_SEA, &vcpu->kvm->arch.flags))
+		return kvm_inject_serror(vcpu);
+
+	/* ESR_ELx.SET is RES0 when FEAT_RAS isn't implemented. */
+	if (kvm_has_ras(kvm))
+		esr_mask |= ESR_ELx_SET_MASK;
+
+	/*
+	 * Exit to userspace, and provide faulting guest virtual and physical
+	 * addresses in case userspace wants to emulate SEA to guest by
+	 * writing to FAR_ELx and HPFAR_ELx registers.
+	 */
+	memset(&run->arm_sea, 0, sizeof(run->arm_sea));
+	run->exit_reason = KVM_EXIT_ARM_SEA;
+	run->arm_sea.esr = esr & esr_mask;
+
+	if (!(esr & ESR_ELx_FnV))
+		run->arm_sea.gva = kvm_vcpu_get_hfar(vcpu);
+
+	ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	if (ipa != INVALID_GPA) {
+		run->arm_sea.flags |= KVM_EXIT_ARM_SEA_FLAG_GPA_VALID;
+		run->arm_sea.gpa = ipa;
+	}
+
+	return 0;
 }
 
 /**
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e4e566ff348b0..b2cc3d74d769c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_SEA          41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -469,6 +470,14 @@ struct kvm_run {
 				} get_tdvmcall_info;
 			};
 		} tdx;
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID	(1ULL << 0)
+			__u64 flags;
+			__u64 esr;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -957,6 +966,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_ARM_SEA_TO_USER 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.50.1.565.gc32cd1483b-goog

