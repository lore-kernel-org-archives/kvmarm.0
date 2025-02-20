Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0CF2673AB
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094206; cv=none; b=n0x22zlRGyrOaf3vQodtleRgX7pB3OTAg7d6Z4OLf8vQD8AGoKkdo3X8ZQnCsr98Z3ZAR8Qun2K5mqakmt0HUogvtNNmkGnKeO2aBHrUUHeCzNLO0I+zwbEbTW5QWu8t2Hrrv2g0srUTEBr50E0deXN2KTOxjrs7G9lLgU6cYGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094206; c=relaxed/simple;
	bh=BcXcrtm0K01Xeqh58KAhFqHzuEUgX433PHRzOQkqfgI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i6TfMmDMNtjNiGrWeTjjOn5ln2f7PDkvDWekiS2x8xUTF9D3Yx0pifn05Coh6y1YdOnL95wwCVLfjTHJOr8kFL1NAoeXkNfyoWVD9kMYFNXKUmN9el7YAYdjIpnc64COkysH5dQH0RO9S42LmZmHLYQdLzMZAcdoiZ/tuXDVWdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H4PHKK+1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H4PHKK+1"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2fee4425so5046052a91.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 15:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740094203; x=1740699003; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=16mDfwgtMHX4C5Bzktye9hLGYxEoL74KODcm/rd0Vtg=;
        b=H4PHKK+1ApKzq0P0ztG99um2x24WalI+btJp84hS0bvt+iVqrcqyYEO3V+gJDZnNDx
         x6DhK2JSmr4svQlKxBdRrR/ThciB6nuQU5Ulri0suRPjhc79sJAUUP4eCL4BghXAdj+b
         uKUVhegf3bpWK0bZl63SkLjh41DVCLRygVwGjXutwi0Uu0qONQ2fF3cQwh+8gT23EAS4
         0+zMHdb0lH2xYQ+ooBBJGgKBKJquWgiMHyu734GmLo0UOlJbXjAyu6O9AG3yLUS1kj1E
         1YOvedCfsHM9EmuGZ7ueKccoa3aTpWQf5C28F9kcTSP3G0ycToyA4UuvcM6P8HjIl0Fd
         /rpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094203; x=1740699003;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16mDfwgtMHX4C5Bzktye9hLGYxEoL74KODcm/rd0Vtg=;
        b=COv16pdqoYX5Wxzu0cyi6M/Gf7HalVC8IMU9qFk1rAJIfRysGzzsv6KuCr8JtbQUVn
         5L/LSd8cOEhVwYhKEce3EElyJWCtulOib7ep7LNJ+h1bsnWDKoSqEcIsSwcjHttw0Wf/
         pfdHOWulVbi5dunSNtRM7XkUNHZMhh+QAERXGVmNe2Sn6LyiSpdyh/YdqAH4kJF/Q/O8
         OBSWdZET4X5ONofWrprcML71n2NGKl/QEpY3Mb4IVee8RsZZ1DAcMqth8SafND56iNYN
         Z/ucZNbi+dL5XIMBKcJ/FNYHgobv4hmuJh9Thrkp0IVh6mD0DX0ekvg5lWgXrX2gwTiv
         he9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUgpiXX+uzTvQX9uxM/0c1qUst1rExjsvAKu+3XY5HA1zdIEuotYutGZR7StcSWGGX8PIqy668=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpOiTUXca8qJVdYuiqQtkvurWWevTehDYGoVcZuHlJxxQLsQiz
	pBDJZVgX9TYinCnsCC7E+uFf61xRh4x67QBj11Qx0CFpPSeKhriRhEB0CL/tPPb1i/9Mt4v7LmI
	uL8jG8NK3Ag==
X-Google-Smtp-Source: AGHT+IE0UCb7fstOq8GvjQmovtZG7N52pSWA/eoj0xYpz/TJAddrAEm6ZQs55YbiR88DnJaYKlzvY93re7M0jA==
X-Received: from pjg5.prod.google.com ([2002:a17:90b:3f45:b0:2ef:d136:17fc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ece:b0:2ee:6d04:9dac with SMTP id 98e67ed59e1d1-2fce7b3e506mr1466909a91.32.1740094203403;
 Thu, 20 Feb 2025 15:30:03 -0800 (PST)
Date: Thu, 20 Feb 2025 23:29:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250220232959.247600-1-jiaqiyan@google.com>
Subject: [RFC PATCH v3 1/3] KVM: arm64: SIGBUS VMM for SEA guest abort
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

When APEI is unable claim or handles synchronous external abort (SEA)
today KVM handles SEA for guest by injecting an async SError into the
guest directly, bypassing VMM, usually results in guest kernel panic.

One major situation of guest SEA is when vCPU consumes uncorrectable
memory error on the physical memory. Although SError and guest kernel
panic effectively stops the propagation of corrupted memory, it is not
easy for VMM and guest to recover from memory error in a more graceful
manner.

This patch teaches KVM to send a SIGBUS BUS_OBJERR to VMM/vCPU, like
how core kernel signals SIGBUS BUS_OBJERR to a gernal poison consuming
userspace thread when APEI is unable to claim the SEA. In addition to
the benifit that KVM's handling for SEA becomes aligned with core
kernel's behavior:
- VMM can inject SEA to guest. Compared to SError, the blast radius in
  VM is possible to be limited to only the consuming thread in guest,
  instead of the entire guest kernel (unless the poison consumption is
  from guest kernel).
- VMM usually tracks the poisoned guest pages. Together with [1], if
  guest consumes again the already poisoned guest pages, VMM can protect
  itself and the host by stopping the consumption at software level, by
  intercepting guest's access to poisoned pages, and again injecting
  SEA to guest.

KVM now handles SEA as follows:
1. Delegate to APEI and GHES to see if SEA can be claimed by them.
2. If APEI failed to claim the SEA, send current thread (i.e. VMM in EL0)
   a si_code=BUS_OBJERR SIGBUS signal. If the DIMM error's physical
   address is available from FAR_EL2, si_addr will be the DIMM error's
   host virtual address in VMM/vCPU's memory space.

Tested on a machine running Siryn AmpereOne processor. A dummy application
in VM allocated some memory buffer. The test used EINJ to inject an
uncorrectable recoverable memory error at a page in the allocated memory
buffer. The dummy application then consumed the memory error. Some hack
was done to make core kernel's memory_failure triggered by poison
generation to fail, so KVM had to deal with the SEA guest abort due to
poison consumption. vCPU thread in VMM received SIGBUS BUS_OBJERR with
valid host virtual address of the poisoned page. VMM then injected a SEA
into guest using KVM_SET_VCPU_EVENTS with ext_dabt_pending=1. At last
the dummy application in guest was killed by SIGBUS BUS_OBJERR, while the
guest survived and continued to run.

[1] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/LPC_%20KVM%20Userfault.pdf

Changelog

RFC V3 -> RFC v2
- SEA or ECC error at all levels of TTW can be handled by SIGBUS EL0,
  and no case to inject SError to guest anymore.
- move #include from kvm_ras.h to kvm_ras.c.

RFC v2 -> RFC v1
- reword commit msg
- drop unused parameters from kvm_delegate_guest_sea
- remove KVM_CAP_ARM_SIGBUS_ON_SEA and its opt in code
- set FnV bit in vcpu's ESR_ELx if host ESR_EL2's FnV is set
- add documentation for this new SIGBUS feature

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/include/asm/kvm_ras.h | 29 +++++++-------
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/kvm_ras.c         | 65 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c             |  8 +---
 4 files changed, 83 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c

diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 87e10d9a635b5..bacae54013b4e 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -4,22 +4,25 @@
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
+ * For synchrnous external abort taken to KVM at EL2, not on translation
+ * table walk or hardware update of translation table, is FAR_EL2 valid?
  */
-static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
-{
-	/* apei_claim_sea(NULL) expects to mask interrupts itself */
-	lockdep_assert_irqs_enabled();
+bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu);
 
-	return apei_claim_sea(NULL);
-}
+/*
+ * Handle synchronous external abort (SEA) in the following order:
+ * 1. Delegate to APEI/GHES to see if they can claim SEA. If so, all done.
+ * 2. Send SIGBUS to current with si_code=BUS_OBJERR and si_addr set to
+ *    the poisoned host virtual address. When accurate HVA is unavailable,
+ *    si_addr will be 0.
+ *
+ * Note this applies to both instruction and data abort (ESR_ELx_EC_IABT_*
+ * and ESR_ELx_EC_DABT_*). As the name suggests, KVM must be taking the SEA
+ * when calling into this function, e.g. kvm_vcpu_abt_issea == true.
+ */
+void kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_RAS_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b5038..c4a3a6d4870e6 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o kvm_ras.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
new file mode 100644
index 0000000000000..47531ed378910
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ras.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/acpi.h>
+#include <linux/types.h>
+
+#include <asm/acpi.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_ras.h>
+#include <asm/system_misc.h>
+
+bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
+{
+	/*
+	 * FnV is valid only for Data/Instruction aborts and if DFSC/IFSC
+	 * is ESR_ELx_FSC_EXTABT(0b010000).
+	 */
+	if (kvm_vcpu_trap_get_fault(vcpu) == ESR_ELx_FSC_EXTABT)
+		return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
+
+	/* Other exception classes or aborts don't care about FnV field. */
+	return true;
+}
+
+/*
+ * Was this synchronous external abort a RAS notification?
+ * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ */
+static int kvm_delegate_guest_sea(void)
+{
+	/* apei_claim_sea(NULL) expects to mask interrupts itself */
+	lockdep_assert_irqs_enabled();
+	return apei_claim_sea(NULL);
+}
+
+void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
+{
+	int idx;
+	u64 vcpu_esr = kvm_vcpu_get_esr(vcpu);
+	phys_addr_t fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	unsigned long hva = 0UL;
+
+	/*
+	 * For RAS the host kernel may handle this abort.
+	 * There is no need to SIGBUS VMM, or pass the error into the guest.
+	 */
+	if (kvm_delegate_guest_sea() == 0)
+		return;
+
+	if (kvm_vcpu_sea_far_valid(vcpu)) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		hva = gfn_to_hva(vcpu->kvm, gfn);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
+	/*
+	 * When FAR is not valid, or GFN to HVA translation failed, send 0
+	 * as si_addr like what do_sea() does.
+	 */
+	if (kvm_is_error_hva(hva))
+		hva = 0UL;
+
+	arm64_notify_die("synchronous external abort",
+			 current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vcpu_esr);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d9..ef6127d0bf24f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1808,13 +1808,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
-			kvm_inject_vabt(vcpu);
-
+		kvm_handle_guest_sea(vcpu);
 		return 1;
 	}
 
-- 
2.48.1.658.g4767266eb4-goog

