Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676226772C
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746461659; cv=none; b=oGGPIFnt7esE48lknKe1JrXfLPynC2Zw2rSKnZXUq2l4TG9YovgKd4IA2geD6bZ76vrikb9c2kLhAczsTWYihdpr2NeTQ9DSmXDbeXx4BDNgkUKK9IO++sxBHj05mvXhDPuM2j7EcRxxXoxhAIbGj4piNrnF9bX1+N7y6v9sj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746461659; c=relaxed/simple;
	bh=v60h/PYlX3rvoNvgm4fRVRD4fD6gJf2WBSqw2Zx3QDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jzaDFKFQWRF059oyoyZVO5WfSZiUqtkIOx+Gnk5x7MFj+Bfo/x8NOxe3HgLDiE515YY+zU1Y7nwCLh1fZlBW51fi7fCH4LXfTC0syLyJO3Wutf42bvaPROJ58g/KndFQ54+z8eSg1Dmk7HbkBfAIwYLTnEXB2QJj3VVMxuyQQB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hcpjahuJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hcpjahuJ"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740774348f6so1270352b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746461657; x=1747066457; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YHUmRqC710I5Zczb2Gv8+GrvF7PyHiekDQRANAyhxgo=;
        b=hcpjahuJLAfUku6IL/1KKxeQCXOiZEKK33tLrCOxaYMDrcQrVEnJBcE9B6cfcHfb0c
         h6nthfm1GT6/+Ks8e13qfGFqFmiAI7G0gNz4KWJPp6Eu0JBA2WPjwY8hckhBjAxjBBdi
         v64NCSYfTF6zAszU+0mcwA82nytzMDIAecFGM9HKtblBO4WZWhyusy/wZaXzvK6IQArD
         R0vX311bWQ/mcMaAPl2zlpn0AMuHS2yviMMnwAh04d0V0Sj1AjpxX2SLGtqxlLsDrYuY
         Yto5MsfNwkKyO5i1gke8NV6vM4ngHUtMAlZbuyXO0mjJa/MRJtfXD+DJNQp39YG1UiBf
         F87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746461657; x=1747066457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YHUmRqC710I5Zczb2Gv8+GrvF7PyHiekDQRANAyhxgo=;
        b=uM2a9kCcGzOGEHb9tiKKcdeTsB/nXY7OapQw53Ukdrmhc1GXkPYUFwxnedEQFZ7nRR
         uV0/JowhsI75jZcJg+l+blS5Px2s3lWcv8cv37wKsUwwswwoJclyQOiee3DpSsmAlnr7
         C+P7JU+SYnlmCdftuRZUi4ekyRHR8Uwo57DtHHtIe40HMOU8SKfaaTbSvOpHj1+8Os81
         n0Z0W8k7699QiUP4kqVr5rNJTNfS+UQBJZ8U4/OfczPximBEGizzQEvu1sGYztuLgXI9
         miSpZAdSa2opDzTSQMJt9RFe5dHT6RLuip8zF1w36iC86jlUFuij5uyo6EnJGASMdVr2
         8ocQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvjw4in4SeWO7cIzm9korEZBbwDT7L2utstSkve9hd61hNs5UDgeBNeW05zU5CwvdaD1dD3nU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEJAtNustODly/BhocsbhTo64XsXDYJX3e22RWH8P/+rTnI/2S
	1dKUqgrNs7R6A1RlYKYlHiNT2XAQnfVRicelj3wRH+JOyXpnKb63RzNeJjp3U/e5k9q4QeX8DPI
	IkYj3WMQxlw==
X-Google-Smtp-Source: AGHT+IGpv50Wz1FmfbCrQKvOYpNfJ4AHoIP5XJSc/cts11lJ70nVyGRkWYp/qqNzmDSatbGKe3GytAHP4hN+Uw==
X-Received: from pfhp37.prod.google.com ([2002:a05:6a00:a25:b0:740:813:f7bb])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1bca:b0:734:b136:9c39 with SMTP id d2e1a72fcca58-7406f1769bemr10644622b3a.19.1746461657217;
 Mon, 05 May 2025 09:14:17 -0700 (PDT)
Date: Mon,  5 May 2025 16:14:07 +0000
In-Reply-To: <20250505161412.1926643-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250505161412.1926643-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505161412.1926643-2-jiaqiyan@google.com>
Subject: [PATCH v1 1/6] KVM: arm64: VM exit to userspace to handle SEA
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

When APEI fails to handle a stage2 abort that is synchrnous external
abort (SEA), today KVM directly injects an async SError to the VCPU
then resumes it, which usually results in unpleasant guest kernel panic.

One major situation of guest SEA is when vCPU consumes recoverable
uncorrected memory error (UER). Although SError and guest kernel panic
effectively stops the propagation of corrupted memory, there is still
room to recover from memory UER in a more graceful manner.

Alternatively KVM can redirect the synchronous SEA event to VMM to
- Reduce blast radius if possible. VMM can inject a SEA to VCPU via
  KVM's existing KVM_SET_VCPU_EVENTS API. If the memory poison
  consumption or fault is not from guest kernel, blast radius can be
  limited to the triggering thread in guest userspace, so VM can
  keep running.
- VMM can protect from future memory poison consumption by unmapping
  the page from stage-2 with KVM userfault [1]. VMM can also
  track SEA events that VM customer cares about, restart VM when
  certain number of distinct poison events happened, provide
  observability to customers [2].

Introduce following userspace-visible features to make VMM handle SEA:
- KVM_CAP_ARM_SEA_TO_USER. As the alternative fallback behavior
  when host APEI fails to claim a SEA, userspace can opt in this new
  capability to let KVM exit to userspace during synchronous abort.
- KVM_EXIT_ARM_SEA. A new exit reason is introduced for this, and
  KVM fills kvm_run.arm_sea with as much as possible information about
  the SEA, including
  - ESR_EL2.
  - If faulting guest virtual and physical addresses are available.
  - Faulting guest virtual address if available.
  - Faulting guest physical address if available.

[1] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/LPC_%20KVM%20Userfault.pdf
[2] https://cloud.google.com/solutions/sap/docs/manage-host-errors

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 12 +++++++
 arch/arm64/include/asm/kvm_host.h    |  8 +++++
 arch/arm64/include/asm/kvm_ras.h     | 21 ++++-------
 arch/arm64/kvm/Makefile              |  3 +-
 arch/arm64/kvm/arm.c                 |  5 +++
 arch/arm64/kvm/kvm_ras.c             | 54 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 12 ++-----
 include/uapi/linux/kvm.h             | 11 ++++++
 8 files changed, 101 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bd020fc28aa9c..a9de30478a088 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -429,6 +429,18 @@ static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 	}
 }
 
+/* Return true if FAR holds valid faulting guest virtual address. */
+static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
+{
+	return !(kvm_vcpu_get_esr(vcpu) & ESR_ELx_FnV);
+}
+
+/* Return true if HPFAR_EL2 holds valid faulting guest physical address. */
+static inline bool kvm_vcpu_sea_ipa_valid(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fault.hpfar_el2 & HPFAR_EL2_NS;
+}
+
 static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 73b7762b0e7d1..e0129f9799f80 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -342,6 +342,14 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	/* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace */
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
+	/*
+	 * When APEI failed to claim stage-2 synchronous external abort
+	 * (SEA) return to userspace with fault information. Userspace
+	 * can opt in this feature if KVM_CAP_ARM_SEA_TO_USER is
+	 * supported. Userspace is encouraged to handle this VM exit
+	 * by injecting a SEA to VCPU before resume the VCPU.
+	 */
+#define KVM_ARCH_FLAG_RETURN_SEA_TO_USER		11
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 9398ade632aaf..a2fd91af8f97e 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -4,22 +4,15 @@
 #ifndef __ARM64_KVM_RAS_H__
 #define __ARM64_KVM_RAS_H__
 
-#include <linux/acpi.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-
-#include <asm/acpi.h>
+#include <linux/kvm_host.h>
 
 /*
- * Was this synchronous external abort a RAS notification?
- * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ * Handle stage2 synchronous external abort (SEA) in the following order:
+ * 1. Delegate to APEI/GHES and if they can claim SEA, resume guest.
+ * 2. If userspace opt-ed in KVM_CAP_ARM_SEA_TO_USER, exit to userspace
+ *    with details about the SEA.
+ * 3. Otherwise, inject async SError into the VCPU and resume guest.
  */
-static inline int kvm_handle_guest_sea(void)
-{
-	/* apei_claim_sea(NULL) expects to mask interrupts itself */
-	lockdep_assert_irqs_enabled();
-
-	return apei_claim_sea(NULL);
-}
+int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_RAS_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 209bc76263f10..785d568411e88 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
+	 kvm_ras.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19ca57def6292..47544945fba45 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -133,6 +133,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SEA_TO_USER:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_RETURN_SEA_TO_USER, &kvm->arch.flags);
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
diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
new file mode 100644
index 0000000000000..83f2731c95d77
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ras.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/acpi.h>
+#include <linux/types.h>
+#include <asm/acpi.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_ras.h>
+#include <asm/system_misc.h>
+
+/*
+ * Was this synchronous external abort a RAS notification?
+ * Returns 0 for errors handled by some RAS subsystem, or -ENOENT.
+ */
+static int kvm_delegate_guest_sea(void)
+{
+	/* apei_claim_sea(NULL) expects to mask interrupts itself. */
+	lockdep_assert_irqs_enabled();
+	return apei_claim_sea(NULL);
+}
+
+int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	bool exit = test_bit(KVM_ARCH_FLAG_RETURN_SEA_TO_USER,
+			     &vcpu->kvm->arch.flags);
+
+	/* For RAS the host kernel may handle this abort. */
+	if (kvm_delegate_guest_sea() == 0)
+		return 1;
+
+	if (!exit) {
+		/* Fallback behavior prior to KVM_EXIT_ARM_SEA. */
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	run->exit_reason = KVM_EXIT_ARM_SEA;
+	run->arm_sea.esr = kvm_vcpu_get_esr(vcpu);
+	run->arm_sea.flags = 0ULL;
+	run->arm_sea.gva = 0ULL;
+	run->arm_sea.gpa = 0ULL;
+
+	if (kvm_vcpu_sea_far_valid(vcpu)) {
+		run->arm_sea.flags |= KVM_EXIT_ARM_SEA_FLAG_GVA_VALID;
+		run->arm_sea.gva = kvm_vcpu_get_hfar(vcpu);
+	}
+
+	if (kvm_vcpu_sea_ipa_valid(vcpu)) {
+		run->arm_sea.flags |= KVM_EXIT_ARM_SEA_FLAG_GPA_VALID;
+		run->arm_sea.gpa = kvm_vcpu_get_fault_ipa(vcpu);
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc673..a605ee56fa150 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1795,16 +1795,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	int ret, idx;
 
 	/* Synchronous External Abort? */
-	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea())
-			kvm_inject_vabt(vcpu);
-
-		return 1;
-	}
+	if (kvm_vcpu_abt_issea(vcpu))
+		return kvm_handle_guest_sea(vcpu);
 
 	esr = kvm_vcpu_get_esr(vcpu);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b5..79dc4676ff74b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_ARM_SEA          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +447,15 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+			__u64 esr;
+#define KVM_EXIT_ARM_SEA_FLAG_GVA_VALID	(1ULL << 0)
+#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID	(1ULL << 1)
+			__u64 flags;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -930,6 +940,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_SEA_TO_USER 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.49.0.967.g6a0df3ecc3-goog

