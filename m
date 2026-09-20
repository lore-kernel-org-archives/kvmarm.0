Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D016547ECC1
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933246; cv=none; b=flhLpA3vwXJcj0gJil0HwvABvIf3JiUXzv43F2NDhZR+PiGgGZPVpV2sHLdAOig6O4Id/ez2igg7f34+Le37DERv+vaCMVHpu69pZMQr9s2ckPaBb7IUUCe+cTKjbe0kPVHzbzqcXzpBi4fnBAnVMYHeP/MEt9+oyVVEJ8aBe7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933246; c=relaxed/simple;
	bh=J9QKtrGAaF50V1/K3NLzH0ap/jSm7bxH/X5wDu97RuY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtShSXPUjqWwWf95MnZhNZ96zVTlcSQ7SO454iUwM5qUDJXTakiXDDfVtIR34FZ4f1S3zHnqZXAAa/tt4/9me5OOwfh5l4dTA/cZePxPgvwacQGfOYkxHwyUVfwWwYQP6d5MJ5l68yBkEMH1lIKIiJNN1nfgxxa4BEF54FKMQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=WwQ3vm6K; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="WwQ3vm6K"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895fd505832so15697187b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933243; x=1790538043; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8AnhgWYPBDTyEtljyN9gDdKnSFvI32a3E+pDg291Dw4=;
        b=WwQ3vm6KGMDs0cCWLZPrsfvL14jV2LBi9JNmpOI+FwvnddqtGF8HRhfwKwQSGeCvBg
         dcaQpMVxyl7NnVUu0tqbc/da5ijNvV+ectpkMIw8+SITW/E+ScOFuqGwMdWaYV3GhTNL
         R7JxELGOYr3tMheQ0TvXn+Im3a0y927nB1mUK0lt/YIXBZ8hZ3+y21LzLUoveiqoRe00
         mZyW4kE4JaSfkztwTKDDh4XtQkOeS2236HpI+IF4oahTwV7yWrCxRne47bupJbsYDlsl
         4smCvhQvfrfJHBuDi5rPt9QjnVRKP7KdTyAfIExvyqyvS8cMx9Lwm6fyVONUm9GBl6ra
         tSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933243; x=1790538043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8AnhgWYPBDTyEtljyN9gDdKnSFvI32a3E+pDg291Dw4=;
        b=iWNs/4d8RAgyKSXE7oXgY6hlhm5E7PJhbDuDd007Khxvsn+o8U8ZZh9FE4Swgqk0fl
         TUB7Zy9JVW85EIpX2cTmuP38+8Og3EgJjbqrE6YbD9Noou2/wovnL6qZoYXVpYp2G1CB
         ecS5j1ftsh8slv088pQK9NzmwfbvHikyVWswbTwd6f3jJttJC7UHnXfCCV2ADUgZqkhm
         aCRX4Ix4ZRvkgefE/IuxqIETXDPPAE0eBzpRCyWN2j4gq1LvVg5HYap2tsouJp5MfyH4
         KLU+ATeyZRb/BFvI9eVjT/nt7Uk/1VwkLRhCQVZzt/DctNJ+jpsh0p+KOhAii+2HGxt6
         8Sfw==
X-Forwarded-Encrypted: i=1; AKwUvBz2pI9YTOiWBfStgToc8GMKndS8tUpIGXm4Mf8EUGBdWXR4PGvm4Ty0i8aRHVI1nppa2vZUGkc=@lists.linux.dev
X-Gm-Message-State: AFuF++kOEorhkEnI/X84McnHIUTQoUHqjMjPE1gJdAxMMEAi0nvdtzY8
	t2VrMrgt7sR6AcyCd8Oi4jBJdzXQ1ZIh259GE8QPZp7r+DgfxWbkykdiuCu1ubryep0=
X-Gm-Gg: AYBFou3NOrDcFCcHygZgWK0OZ6cidGvW/ZwDpQnvKzcaZ78xkZZag0nXn/nrJ0OCyeh
	pKWCVIbQsKNEdzpXSZ4Wak1qR1BOcNytI1tIVJfHvKWr7CrljYBCAfX+2oHENhBNwp2l0lBsqeq
	BQtYTv36AgW6AUr6wwlHCkSt4XwNa3uz4ZznH8yelbFaxj5m9ciBzYxHpCrZCUYOb73b1JKc8Xe
	92TigbPjZKMIL2VuC7f+1XyBOr9Bki1u5ZDIfHG/uNFjOHrQjchHjniJMXCMbDCgVie9x5h1l/q
	7QOG5petm/lVsnH+DfFPPK30FUszRgVaQyrT3cOr+eJBfXA6mxEcvVgvBfmOlZvv7Yno/6d4Uus
	sqJRrQilrWMl3AvQZ4R0JijjDBH6lHb+dSmRwsxkNLPUuYuPeZl5oRViNOITgP4UWdoSKh0igqV
	P6qnOhYSCknFw19k//MsmEBQbxiotkjDSpzlMsJaBGlkYdQAzto3i3tX5XYRhOHeB30G96xM8dW
	h3rpa83fJoiFt9i4q0Z1YgtMBOW4abATa077OjJiaP+Le2vXg1RLJSvSndd9gFTs/G48Xw343oj
	Ia1mGgaGdmUThYwC3f0=
X-Received: by 2002:a05:690e:b88:b0:671:1a19:2dc with SMTP id 956f58d0204a3-6717fc6196emr2697319d50.11.1789933242627;
        Sun, 20 Sep 2026 12:40:42 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672991445desm2616083d50.20.2026.09.20.12.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 38/46] KVM: VMX: Implement Caretaker VMX VMCS lifecycle and exit dispatch
Date: Sun, 20 Sep 2026 15:36:42 -0400
Message-ID: <20260920193650.3373435-39-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement Intel VMX Caretaker VMCS setup, exit decoding, and guest
entry/exit loop in arch/x86/kvm/vmx/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/vmx/caretaker.c         | 340 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/caretaker_vmenter.S |  12 +-
 arch/x86/kvm/vmx/vmx.c               |   2 +-
 arch/x86/kvm/vmx/vmx.h               |   1 +
 4 files changed, 347 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/caretaker.c

diff --git a/arch/x86/kvm/vmx/caretaker.c b/arch/x86/kvm/vmx/caretaker.c
new file mode 100644
index 000000000000..47b4743650e5
--- /dev/null
+++ b/arch/x86/kvm/vmx/caretaker.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel VMX Caretaker Standalone Execution Engine
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Runs the Intel VMX guest execution loop in an isolated, KHO-preserved memory
+ * page that remains alive and executing across kexec relocation and
+ * kernel handover.
+ */
+
+#include <linux/cleanup.h>
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kvm_host.h>
+#include <linux/objtool.h>
+#include <linux/oncore.h>
+
+#include <asm/apic.h>
+#include <asm/cpu_entry_area.h>
+#include <asm/desc.h>
+#include <asm/fixmap.h>
+#include <linux/pgtable.h>
+#include <linux/processor.h>
+#include <asm/segment.h>
+#include <asm/set_memory.h>
+#include <asm/virt.h>
+#include <asm/vmx.h>
+
+#include "../caretaker.h"
+#include "caretaker.h"
+#include "vmx.h"
+#include "vmx_ops.h"
+#include "x86.h"
+#include "x86_ops.h"
+
+static int vmx_caretaker_init_page(struct caretaker_vmx_page *cvp,
+				   struct kvm_vcpu *vcpu);
+STACK_FRAME_NON_STANDARD(vmx_caretaker_init_page);
+
+static int vmx_caretaker_init_page(struct caretaker_vmx_page *cvp,
+				   struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 basic_msr, misc_msr;
+	int ret;
+
+	if (!vmx->vmcs01.vmcs)
+		return -EINVAL;
+
+	ret = kvm_x86_caretaker_init_common_page(&cvp->common, vcpu, sizeof(*cvp));
+	if (ret)
+		return ret;
+	cvp->common.abi.vmcs_pa = virt_to_phys(vmx->vmcs01.vmcs);
+	cvp->vmxon_pa = virt_to_phys(cvp->vmxon_area);
+
+	memset(cvp->vmxon_area, 0, PAGE_SIZE);
+	basic_msr = native_rdmsrq(MSR_IA32_VMX_BASIC);
+	*(u32 *)cvp->vmxon_area = vmx_basic_vmcs_revision_id(basic_msr);
+
+	if (!rdmsrq_safe(MSR_IA32_VMX_MISC, &misc_msr))
+		cvp->timer_shift = vmx_misc_preemption_timer_rate(misc_msr);
+	else
+		cvp->timer_shift = VMX_PREEMPTION_TIMER_SHIFT;
+
+	cvp->ple_supported = cpu_has_vmx_ple();
+
+	vcpu_load(vcpu);
+
+	cvp->common.kernel_gs_base = vmx->msr_guest_kernel_gs_base;
+	kvm_msr_read(vcpu, MSR_STAR, &cvp->star);
+	kvm_msr_read(vcpu, MSR_LSTAR, &cvp->lstar);
+	kvm_msr_read(vcpu, MSR_SYSCALL_MASK, &cvp->fmask);
+
+	/* Save current guest control registers from KVM */
+	cvp->common.cr0 = kvm_read_cr0(vcpu);
+	cvp->common.cr3 = kvm_read_cr3(vcpu);
+	cvp->common.cr4 = kvm_read_cr4(vcpu);
+	cvp->common.efer = vcpu->arch.efer;
+
+	cvp->common.last_exit_rip = kvm_rip_read(vcpu);
+	cvp->common.last_exit_rsp = kvm_rsp_read(vcpu);
+	cvp->common.last_exit_rflags = kvm_get_rflags(vcpu);
+
+	if (kvm_host.efer & EFER_NX)
+		cvp->common.efer |= EFER_NX;
+
+	vcpu_put(vcpu);
+
+	if (vmx->loaded_vmcs)
+		loaded_vmcs_clear(vmx->loaded_vmcs);
+
+	return 0;
+}
+
+void vmx_caretaker_init(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct caretaker_vmx_page *cvp;
+	struct kvm_caretaker_arch_ser *abi;
+
+	cvp = kho_alloc_preserve(sizeof(*cvp));
+	if (IS_ERR(cvp)) {
+		pr_err("caretaker vmx: failed to allocate preserved page\n");
+		return;
+	}
+
+	if (vmx_caretaker_init_page(cvp, vcpu))
+		goto err_free;
+
+	abi = &cvp->common.abi;
+	if (vmx->vmcs01.vmcs &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->vmcs01.vmcs)))
+		goto err_free;
+	if (vmx->vmcs01.msr_bitmap &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->vmcs01.msr_bitmap)))
+		goto err_free;
+	if (vmx->pml_pg &&
+	    kvm_x86_caretaker_preserve_page(abi, vmx->pml_pg))
+		goto err_free;
+	if (vmx->ve_info &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->ve_info)))
+		goto err_free;
+
+	return;
+
+err_free:
+	kvm_x86_caretaker_unpreserve_pages(&cvp->common.abi);
+	vcpu->caretaker.cb = NULL;
+	kho_unpreserve_free(cvp);
+}
+
+static __cpu_preserved_text void vmx_caretaker_disarm_timer(void *page)
+{
+	u32 pin = (u32)vmx_vmread(PIN_BASED_VM_EXEC_CONTROL);
+
+	if (pin & PIN_BASED_VMX_PREEMPTION_TIMER) {
+		vmx_vmwrite(PIN_BASED_VM_EXEC_CONTROL,
+			    pin & ~PIN_BASED_VMX_PREEMPTION_TIMER);
+	}
+}
+
+static inline unsigned long vmx_caretaker_read_cr0(void)
+{
+	unsigned long mask = vmx_vmread(CR0_GUEST_HOST_MASK);
+
+	return (vmx_vmread(CR0_READ_SHADOW) & mask) |
+	       (vmx_vmread(GUEST_CR0) & ~mask);
+}
+
+static inline unsigned long vmx_caretaker_read_cr4(void)
+{
+	unsigned long mask = vmx_vmread(CR4_GUEST_HOST_MASK);
+
+	return (vmx_vmread(CR4_READ_SHADOW) & mask) |
+	       (vmx_vmread(GUEST_CR4) & ~mask);
+}
+
+static inline u64 vmx_caretaker_read_efer(void)
+{
+	u64 efer = vmx_vmread(GUEST_IA32_EFER);
+
+	if (!efer)
+		efer = native_rdmsrq(MSR_EFER);
+	if (vmx_vmread(VM_ENTRY_CONTROLS) & VM_ENTRY_IA32E_MODE)
+		efer |= EFER_LMA | EFER_LME;
+	return efer;
+}
+
+void __cpu_preserved_text
+vmx_caretaker_decode_exit(void *page,
+			  struct kvm_caretaker_exit *exit)
+{
+	struct caretaker_vmx_page *cvp = page;
+	u32 insn_len = (u32)vmx_vmread(VM_EXIT_INSTRUCTION_LEN);
+	u16 exit_reason = (u16)vmx_vmread(VM_EXIT_REASON);
+	u64 qual = vmx_vmread(EXIT_QUALIFICATION);
+	u64 rip = vmx_vmread(GUEST_RIP);
+
+	cvp->common.last_exit_rip = rip;
+	cvp->common.last_exit_rsp = vmx_vmread(GUEST_RSP);
+	cvp->common.last_exit_rflags = vmx_vmread(GUEST_RFLAGS);
+	cvp->common.cr3 = vmx_vmread(GUEST_CR3);
+	cvp->common.cr0 = vmx_caretaker_read_cr0();
+	cvp->common.cr4 = vmx_caretaker_read_cr4();
+
+	exit->rip = rip;
+	exit->insn_len = insn_len;
+	exit->raw_reason = exit_reason;
+	exit->type = KVM_CARETAKER_EXIT_ARCH;
+
+	switch (exit_reason) {
+	case EXIT_REASON_IO_INSTRUCTION: {
+		u16 port = (u16)(qual >> VMX_IO_PORT_SHIFT);
+
+		if (port >= COM1_PORT_BASE && port <= COM1_PORT_END) {
+			exit->type = KVM_CARETAKER_EXIT_CONSOLE;
+			exit->mmio_io.addr = port;
+			exit->mmio_io.is_write = !(qual & VMX_IO_DIRECTION_BIT);
+			exit->mmio_io.size = (u8)((qual & VMX_IO_SIZE_MASK) + 1);
+			exit->mmio_io.is_mmio = false;
+			exit->mmio_io.val_ptr = &cvp->common.rax;
+		}
+		break;
+	}
+	case EXIT_REASON_HLT:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		break;
+	case EXIT_REASON_PAUSE_INSTRUCTION:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		exit->insn_len = insn_len ? insn_len : PAUSE_INSN_LEN;
+		break;
+	case EXIT_REASON_CPUID:
+		exit->type = KVM_CARETAKER_EXIT_CPUID;
+		break;
+	case EXIT_REASON_VMCALL:
+		/*
+		 * Do not write a return value.  The Caretaker cannot run the
+		 * hypercall, and reporting success for something like
+		 * KVM_HC_SEND_IPI or a PV TLB flush is worse than not
+		 * answering at all.  CROSS_VCPU now stalls, so the guest
+		 * stays parked on the VMCALL with RAX untouched until the
+		 * incoming kernel services it.
+		 */
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		exit->insn_len = insn_len ? insn_len : VMCALL_INSN_LEN;
+		break;
+	case EXIT_REASON_MSR_READ:
+		exit->type = KVM_CARETAKER_EXIT_MSR;
+		exit->msr.msr = (u32)cvp->common.rcx;
+		exit->msr.is_write = false;
+		break;
+	case EXIT_REASON_MSR_WRITE:
+		exit->type = KVM_CARETAKER_EXIT_MSR;
+		exit->msr.msr = (u32)cvp->common.rcx;
+		exit->msr.is_write = true;
+		break;
+	case EXIT_REASON_RDTSC:
+		exit->type = KVM_CARETAKER_EXIT_RDTSC;
+		break;
+	case EXIT_REASON_EPT_VIOLATION:
+		exit->type = KVM_CARETAKER_EXIT_UNHANDLED;
+		break;
+	case EXIT_REASON_PREEMPTION_TIMER:
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		vmx_caretaker_disarm_timer(cvp);
+		break;
+	case EXIT_REASON_EOI_INDUCED:
+	case EXIT_REASON_APIC_WRITE:
+	case EXIT_REASON_APIC_ACCESS:
+	case EXIT_REASON_INTERRUPT_WINDOW:
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		exit->insn_len = 0;
+		break;
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+	case EXIT_REASON_EXCEPTION_NMI:
+	case EXIT_REASON_INIT_SIGNAL:
+	case EXIT_REASON_SIPI_SIGNAL:
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void __cpu_preserved_text
+vmx_caretaker_init_host_vmcs(struct caretaker_vmx_page *cvp)
+{
+	u64 fs_base = 0, gs_base = 0;
+	unsigned long pin, cpu_ctl;
+
+	phys_addr_t host_cr3 = cvp->common.host_cr3;
+
+	/* Configure Host Controls */
+	vmx_vmwrite(HOST_CR0, read_cr0());
+	vmx_vmwrite(HOST_CR4, __read_cr4());
+	if (!host_cr3) {
+		struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+
+		if (sctx && sctx->session_pgd_pa)
+			host_cr3 = sctx->session_pgd_pa;
+		else
+			host_cr3 = x86_caretaker_pgd_pa;
+	}
+	if (host_cr3)
+		vmx_vmwrite(HOST_CR3, host_cr3);
+	vmx_vmwrite(HOST_RSP, (unsigned long)&cvp->common.stack[CXP_STACK_SIZE]);
+	vmx_vmwrite(HOST_RIP, (unsigned long)&vmx_caretaker_exit_handler);
+
+	/* Configure Host Selectors */
+	vmx_vmwrite(HOST_CS_SELECTOR, __KERNEL_CS);
+	vmx_vmwrite(HOST_SS_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_DS_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_ES_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_FS_SELECTOR, 0);
+	vmx_vmwrite(HOST_GS_SELECTOR, 0);
+	vmx_vmwrite(HOST_TR_SELECTOR, GDT_ENTRY_TSS * 8);
+
+	/* Configure Host Bases */
+	fs_base = native_rdmsrq(MSR_FS_BASE);
+	gs_base = native_rdmsrq(MSR_GS_BASE);
+	vmx_vmwrite(HOST_FS_BASE, fs_base);
+	vmx_vmwrite(HOST_GS_BASE, gs_base);
+	vmx_vmwrite(HOST_TR_BASE, (unsigned long)&cvp->common.tss);
+	vmx_vmwrite(HOST_GDTR_BASE, (unsigned long)&cvp->common.gdt[0]);
+	vmx_vmwrite(HOST_IDTR_BASE, (unsigned long)&caretaker_x86_idt[0]);
+
+	/* Configure PIN and CPU execution controls */
+	pin = vmx_vmread(PIN_BASED_VM_EXEC_CONTROL);
+	pin |= (PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING);
+	pin &= ~(PIN_BASED_VMX_PREEMPTION_TIMER | PIN_BASED_POSTED_INTR);
+	vmx_vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin);
+
+	cpu_ctl = vmx_vmread(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_ctl &= ~(CPU_BASED_INTR_WINDOW_EXITING |
+		     CPU_BASED_NMI_WINDOW_EXITING);
+	cpu_ctl |= (CPU_BASED_HLT_EXITING |
+		    CPU_BASED_PAUSE_EXITING |
+		    CPU_BASED_MWAIT_EXITING |
+		    CPU_BASED_MONITOR_EXITING |
+		    CPU_BASED_UNCOND_IO_EXITING);
+
+	if (cvp && cvp->ple_supported &&
+	    (cpu_ctl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
+		unsigned long sec_ctl = vmx_vmread(SECONDARY_VM_EXEC_CONTROL);
+
+		sec_ctl |= SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+		vmx_vmwrite(SECONDARY_VM_EXEC_CONTROL, sec_ctl);
+		vmx_vmwrite(PLE_GAP, 4096);
+		vmx_vmwrite(PLE_WINDOW, 4096);
+	}
+	vmx_vmwrite(CPU_BASED_VM_EXEC_CONTROL, cpu_ctl);
+}
+
diff --git a/arch/x86/kvm/vmx/caretaker_vmenter.S b/arch/x86/kvm/vmx/caretaker_vmenter.S
index ff135cba854d..51781e3e61e2 100644
--- a/arch/x86/kvm/vmx/caretaker_vmenter.S
+++ b/arch/x86/kvm/vmx/caretaker_vmenter.S
@@ -26,8 +26,8 @@ SYM_TYPED_FUNC_START(vmx_caretaker_enter)
 	CARETAKER_PUSH_HOST_REGS
 	movq %rsp, CXP_STACK_ORIG(%rdi)
 
-	/* Switch to private preserved stack */
-	movq CXP_STACK_TOP(%rdi), %rsp
+	/* Switch to private preserved stack at top of caretaker_x86_page */
+	leaq PAGE_SIZE(%rdi), %rsp
 
 	/* Activate VMCS on this pCPU */
 	vmptrld CXP_VMCS_PA(%rdi)
@@ -60,11 +60,10 @@ SYM_TYPED_FUNC_START(vmx_caretaker_enter)
 	vmresume
 	vmlaunch
 
-	/* If both fail, record error and return */
+	/* If both fail, return error in %rax */
 	popq %rdi
 	mov $VMCS_VM_INSTRUCTION_ERROR, %eax
 	vmread %rax, %rax
-	movq %rax, CXP_LAST_EXIT_CODE(%rdi)
 	btsq $31, %rax
 	jmp .Lvmx_ret
 SYM_FUNC_END(vmx_caretaker_enter)
@@ -73,15 +72,14 @@ SYM_FUNC_START(vmx_caretaker_exit_handler)
 	ENDBR
 	/*
 	 * Hardware jumps here on VM-Exit with:
-	 * RSP = HOST_RSP (CXP_STACK_TOP)
+	 * RSP = HOST_RSP (top of 4 KB struct caretaker_x86_page)
 	 * CR3 = HOST_CR3
 	 */
 	pushq %rdi
 
-	/* Recompute CVP pointer from RSP: CVP = (RSP & PAGE_MASK) - CXP_STACK_OFFSET */
+	/* Recover CVP base from RSP: stack lives in the upper half of page 0 */
 	movq %rsp, %rdi
 	andq $PAGE_MASK, %rdi
-	subq $CXP_STACK_OFFSET, %rdi
 
 	/* Save guest GPRs into CVP */
 	CARETAKER_SAVE_GPRS %rdi
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 612ab07d4100..48b6e69f99bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -839,7 +839,7 @@ static void __loaded_vmcs_clear(void *arg)
 	loaded_vmcs->launched = 0;
 }
 
-static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
+void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 {
 	int cpu = loaded_vmcs->cpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index dc8517f15bc4..5cb64ae4c8ee 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -342,6 +342,7 @@ static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 }
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
+void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-- 
2.55.0.1082.g2b9226bbc0-goog

