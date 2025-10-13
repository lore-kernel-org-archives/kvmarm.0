Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198992D8DD1
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760381952; cv=none; b=nPvX9NgH2GKNsMNYFXsdBHidZFaPe7liKOT/AxMUmNVrDVjohF9VEWx9KnygjG9UfJX3qqv5xewlTGAh09P8F7unQgk/yaxIbnMj5pDIogwb6sJrKKlc19Z1gaKmYhT4CrQ55J+Z60UB4Fxblzw8Hnnb0YqD6jmEgLMwMFhkD24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760381952; c=relaxed/simple;
	bh=3LVB1aLou5xTC3CEzbRutNwGsay2oHu725iR8lxH+DA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PHc6O2Q8B4LH4YyBU4jWPqqC1zrPlQyD3LuUrvKHXbV0iCZQsv1v+Zc8Dzizvi2UtC0UUwEP6IJTsIiciZeXzFuQdfVFzqMXz4st0MogXIonGIUez92txlJr8nNjZTROS6AKXc+RmKEgTcdg6s+5ClOtexepdZva8aLZAKhRo+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y08VR4r1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y08VR4r1"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so9805277a91.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760381950; x=1760986750; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XXhIYULAxICUn9TkT19/Y6DKrYnSPgT1DB4+CIVl/38=;
        b=Y08VR4r1dtb5wnwuTpIRNY/Y1nJ2uF1oMk2QaeB6IQL9LLYVmzspl+7iHs2uQnPsFg
         p7I/+foz3on7aE3m+ZTzUiXOw6w3NZe8RB9o7qkOiw7hYJsbMoVzuo+eBuvAvgI2plX1
         ims1I1BQSz9UHdVs6LB3/Gv8iK3GQbAnK+/sHOOsVoL1pK+iLLOaDtWzMMyy6qfVOWqF
         TFVZk30RtLNpjgQoghF2s/N57ZkvfHH0vHEU1KNPsWjBMiphmJ0aTXHh2b5brMCmy/A9
         5qGlT7Nr4fGXRyz8QfwtMjwENy2qVg/IgPwic5kn1m/gAGBH71zyIcEENkWUkJ8Almn8
         AUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381950; x=1760986750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XXhIYULAxICUn9TkT19/Y6DKrYnSPgT1DB4+CIVl/38=;
        b=ZQ6HbWc5I72c8wbugTjQroa+1650KPJFdC5d0VJs/s1PQL3DgjvR8cPaaQOXf7emQv
         Nrw4UNxBfpM7ar1bgcZfLm5PHOcyLfh3Gq/LSfLxnJRLENqo0W8b8NLcJN5+hdrl0elc
         5/pBXR9/VdGrc0bwfN2Jzli4rteFc/bs0eFxLAzzre94CkgLS1gUD61bjluHcvRJYSu1
         D9A5T7paUazpfamB5+TPPK+DY8MFp6be6COZ8V52Inmo10Wi14YsTukOlWvqgcVysByF
         YRM4h9Zhta3mSRNXSHGdAWnjMy4kIrStGqxXfUK9DRJN9DQPJjI5POOH+87t76YEg0Sq
         rr0g==
X-Forwarded-Encrypted: i=1; AJvYcCXIY894FWIAhgUdoIu+Lac9MTrQeDzWlloUATqGRp22zzbFC+W1BePjSyAZTP+emrGfJF74tEU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmssTYOGINBeVr8HWUEnhoqUgyc67YJ8/3Jp1dNUQYs3OYze5q
	uiee7e7l/QBq7IKjMDtEU6FErZhfQOd/O2+xeBtCaPUCK9qitUcJKJdRmFhGBTHlvKoZEiiQowP
	VVBDpiPMsuCvh8g==
X-Google-Smtp-Source: AGHT+IHOf3DZfW9zZyIl0kJ/pBycWUnxUTjpWjo8DJTyDQLcIovHjIqDa1SzEWfbNsnd/tK4ZqlDB42LUt629w==
X-Received: from pjbfh3.prod.google.com ([2002:a17:90b:343:b0:330:b9e9:7acc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3511:b0:32e:5646:d43f with SMTP id 98e67ed59e1d1-33b513b4c25mr31159759a91.19.1760381950362;
 Mon, 13 Oct 2025 11:59:10 -0700 (PDT)
Date: Mon, 13 Oct 2025 18:59:01 +0000
In-Reply-To: <20251013185903.1372553-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013185903.1372553-2-jiaqiyan@google.com>
Subject: [PATCH v4 1/3] KVM: arm64: VM exit to userspace to handle SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	vsethi@nvidia.com, jgg@nvidia.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

When APEI fails to handle a stage-2 synchronous external abort (SEA),
today KVM injects an asynchronous SError to the VCPU then resumes it,
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
index b763293281c88..e2c65b14e60c4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -350,6 +350,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	/* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace */
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
+	/* Unhandled SEAs are taken to userspace */
+#define KVM_ARCH_FLAG_EXIT_SEA				11
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f21d1b7f20f8e..888600df79c40 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -132,6 +132,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -327,6 +331,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
+	case KVM_CAP_ARM_SEA_TO_USER:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d305..09210b6ab3907 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1899,8 +1899,48 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
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
+	 * stage-2 is only possible with S1PTW is set. Otherwise, since KVM
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
@@ -1909,7 +1949,33 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
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
index 6efa98a57ec11..acc7b3a346992 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_SEA          41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -473,6 +474,14 @@ struct kvm_run {
 				} setup_event_notify;
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
@@ -963,6 +972,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_MMAP 244
+#define KVM_CAP_ARM_SEA_TO_USER 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.0.760.g7b8bcc2412-goog

