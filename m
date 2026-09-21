Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501CE4FD7BB
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024449; cv=none; b=iHPONH44LUEDCtbVMjHEBXeMuNWwJ4sr0O9ie03rzPdqOHt/+8Ag6jIf85Ptgg78IHVvbpD6+Ae2M0Tu7UMVgtB7Jn7/mxsIzE2UjkTpg9Oe73Foayc83cEF1TNkh/PXgCJVW5K2lzfJAO39u4rkFsuwCrvFUhOEecwcmkKYIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024449; c=relaxed/simple;
	bh=bY+zymZ4S6th03MtLXdbQ77PAi7UZqKRfQa/vum4h1I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVEbQxrfVcrOHgRp/51gMS6K/GZU3ORT7muGiIOGvEYLP9P62QIvBiuLX2Q8c3WdMF4AkxxWGWEo1EjuDguhsz8v0bmWLDXCWGeOvZ/mqSO8Rr9ngmNLazzifDBJ7GLPJXvmToISXUQYXZzcrqykY4YimA6g6eg6wXNypCFlhK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=CisJeJNv; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="CisJeJNv"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aac92dbso2960533d50.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024445; x=1790629245; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GqeqlOCg1HclTeosM0Kb19hmyEop41lmxz51E1YFR5I=;
        b=CisJeJNvDo0fVjkDIKEgKeLJqxQa031BZMnDHsfPBkD0lcciJvSzGFEEI9FL5cHHlr
         XeB44xwjRzW7PvxHsxWidrAaMVAs4FHtnKbLjaWNkfAxPQojM5DZbl8A5qM2QuijkIsv
         uNaKSBMFexVj9645YRaWfsr5NazbbueP7Xhqr1tBuJxp9oL8lp9hrz69wOpkO1dPMDwn
         8YZZZcZ6pkoxz1HBWsB88koB2LYd1qlA2T67EbDJ45y0oqs14NfnVkzQvnBGo0+xcLSq
         9HHmCeiGLf0ZCYKcVd3fZVOqIB7x+AGgr/pI8Z6eUZjpVEBMsVcPPVaIkdNX+OikSXk+
         J42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024445; x=1790629245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GqeqlOCg1HclTeosM0Kb19hmyEop41lmxz51E1YFR5I=;
        b=AC8sPwatYwTfMKtkazrJw+YiL6l/snTO/IMCc5Myc1cRxwYJKWzN5dJfIduQo66Hal
         g5uU0QE3sOBXq3Fw8eQWREqO7jnXztP0Rzw0GvVtTnU+TdUUqA9TRxtTTuZoPNUs+NMC
         2DgEWEwBAfpPj7wlyM1S3QzWJjAIzfmsO6jZ43ZbNsZIuJ3es/9ydiLHeqZqfJzMw6yl
         d2mydcVHb+tsUgEiOb+EbIfcRnfGHc3ovNVr8DfwhYWSzNSAg5morUCXInZW1hCsBfH+
         dWVyh5X2gZWKEIDIN0z1q3G7gjkmRF9cC/WIjVKgMhmOnYAt/qM/ogMQPhk+1tr//6E6
         ad/A==
X-Forwarded-Encrypted: i=1; AKwUvBw9o4eXLwzxLu+S7WOWKCcx9wItj9JphdTIicCJtBuQraAVDNJ2CkB4ybtEM9XyqZr7yv9yvNQ=@lists.linux.dev
X-Gm-Message-State: AFuF++mqOgqujaFKaZtnfyMfD91EMW0vqgfy3G+/bmtjkbWUc4gpqwvp
	3cLHgYHfpzEL33d9ftxxfGD6y3+iPEZYuhr1T4fX4PLKVBkH5VfKQDf261HJnc1rWGw=
X-Gm-Gg: AYBFou3VF6Q+pRwoeZTM58YTGiJ9qnVuh6kFabvwD7k9WWH1ZFPxvg74QAlWpMIdjn9
	Ai4kn/IPfamNbSyXDLaBqrgOQPjti465f2ZQRTj5YUVkl/xqu3O3CY5rwXH3Zgviv+lATaPDoDb
	dQtPP+cAdBd419se1QySHtZsKSfqpzLR99ZFkKWeRcXOADynBoa5CXTdyz6Klu1sf4eE/lAVzBh
	17eughQdWlyG9TDGmREmv1FSZAlZFDYEi0aRL9A1y1WtcPtAo+KL1n9/ov/rJg665SZLnCREVSi
	sVDmEiDkWOQuAU2QbusVyus5Xrz1piRbBUPtOk+xObHdUdCnZIpn/D7+jnTe/T5Yul+85dN9tcQ
	X/nm/bImpFt2PEc5DSDepEmhtyqv5Y66dxjgsmuUYlxSbJWzNEHzzoJ7VnIGU4Ia250g0um72d7
	+p3pNx6iOr7hRGu+YDxKL0Mq2N1FUe81FPXhhXCP2wMpRdThqPsKwLkYfBywxQSbRiUu9km/oDZ
	Rdb8Gm3nki++9ydo+tr/pAN2gD/reMA6sRxZjW0H5U3+bwFb7ID/4quqXuhdBQ6l/wZ7PHkxlAH
	GdAD0JwVOR9BNO+pJ3EqMtYlstYXrg==
X-Received: by 2002:a05:690c:6b01:b0:8a1:17f0:a44a with SMTP id 00721157ae682-8a117f0b633mr11060827b3.46.1790024444982;
        Mon, 21 Sep 2026 14:00:44 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:43 -0700 (PDT)
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
Subject: [RFC PATCH 41/46] KVM: SVM: Implement Caretaker SVM VMCB lifecycle and exit dispatch
Date: Mon, 21 Sep 2026 17:00:29 -0400
Message-ID: <20260921210034.180424-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement AMD SVM Caretaker VMCB preservation, exit decoding, and
detach-time serialization in arch/x86/kvm/svm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/Makefile                |  23 +-
 arch/x86/kvm/svm/caretaker.c         | 467 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/caretaker_vmenter.S |   4 +-
 arch/x86/kvm/svm/svm.c               |  11 +-
 4 files changed, 500 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kvm/svm/caretaker.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b550a3fd0708..9213d274817e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -26,6 +26,7 @@ kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
 kvm-intel-$(CONFIG_KVM_INTEL_TDX)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
+kvm-amd-$(CONFIG_KVM_CARETAKER) += svm/caretaker.o svm/caretaker_vmenter.o
 
 kvm-amd-$(CONFIG_KVM_AMD_SEV)	+= svm/sev.o
 kvm-amd-$(CONFIG_KVM_HYPERV)	+= svm/hyperv.o
@@ -43,6 +44,26 @@ obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
 AFLAGS_svm/vmenter.o    := -iquote $(obj)
 $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
 
+AFLAGS_svm/caretaker_vmenter.o := -iquote $(obj)
+$(obj)/svm/caretaker_vmenter.o: $(obj)/kvm-asm-offsets.h
+
+KASAN_SANITIZE_caretaker.o := n
+KCSAN_SANITIZE_caretaker.o := n
+UBSAN_SANITIZE_caretaker.o := n
+KCOV_INSTRUMENT_caretaker.o := n
+KASAN_SANITIZE_svm/caretaker.o := n
+KCSAN_SANITIZE_svm/caretaker.o := n
+UBSAN_SANITIZE_svm/caretaker.o := n
+KCOV_INSTRUMENT_svm/caretaker.o := n
+KASAN_SANITIZE_vmx/caretaker.o := n
+KCSAN_SANITIZE_vmx/caretaker.o := n
+UBSAN_SANITIZE_vmx/caretaker.o := n
+KCOV_INSTRUMENT_vmx/caretaker.o := n
+CFLAGS_REMOVE_caretaker.o = $(CC_FLAGS_FTRACE)
+CFLAGS_caretaker.o += -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+CFLAGS_REMOVE_svm/caretaker.o = $(CC_FLAGS_FTRACE)
+CFLAGS_svm/caretaker.o := -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+
 AFLAGS_vmx/vmenter.o    := -iquote $(obj)
 $(obj)/vmx/vmenter.o: $(obj)/kvm-asm-offsets.h
 
@@ -50,7 +71,7 @@ AFLAGS_vmx/caretaker_vmenter.o := -iquote $(obj)
 $(obj)/vmx/caretaker_vmenter.o: $(obj)/kvm-asm-offsets.h
 
 CFLAGS_REMOVE_vmx/caretaker.o = $(CC_FLAGS_FTRACE)
-CFLAGS_vmx/caretaker.o := -fno-stack-protector
+CFLAGS_vmx/caretaker.o := -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
 
 
 $(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
diff --git a/arch/x86/kvm/svm/caretaker.c b/arch/x86/kvm/svm/caretaker.c
new file mode 100644
index 000000000000..cb30e336f014
--- /dev/null
+++ b/arch/x86/kvm/svm/caretaker.c
@@ -0,0 +1,467 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD SVM Caretaker Standalone Execution Engine
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Runs the AMD SVM guest VMRUN loop in an isolated, KHO-preserved memory
+ * page that remains alive and executing across kexec relocation and
+ * kernel handover.
+ */
+
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/kexec_handover.h>
+#include <linux/kvm_host.h>
+#include <linux/objtool.h>
+#include <linux/oncore.h>
+
+#include <asm/apic.h>
+#include <asm/cpu_entry_area.h>
+#include <asm/desc.h>
+#include <linux/pgtable.h>
+#include <linux/processor.h>
+#include <asm/set_memory.h>
+#include <asm/svm.h>
+#include <asm/tlbflush.h>
+
+#include "../caretaker.h"
+#include "caretaker.h"
+#include "mmu.h"
+#include "svm.h"
+#include "svm_ops.h"
+
+static int svm_caretaker_init_page(struct caretaker_svm_page *csp, struct kvm_vcpu *vcpu);
+STACK_FRAME_NON_STANDARD(svm_caretaker_init_page);
+
+static int svm_caretaker_init_page(struct caretaker_svm_page *csp, struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	if (is_guest_mode(vcpu) || is_sev_guest(vcpu) ||
+	    kvm_vcpu_apicv_activated(vcpu))
+		return -EOPNOTSUPP;
+
+	ret = kvm_x86_caretaker_init_common_page(&csp->common, vcpu, sizeof(*csp));
+	if (ret)
+		return ret;
+
+	if (svm->vmcb01.ptr)
+		csp->vmcb = *svm->vmcb01.ptr;
+	csp->vmcb_pa = virt_to_phys(&csp->vmcb);
+	csp->hsave_pa = virt_to_phys(csp->hsave_area);
+
+	if (svm->msrpm)
+		memcpy(csp->msrpm, svm->msrpm, MSRPM_SIZE);
+	else
+		memset(csp->msrpm, 0xff, MSRPM_SIZE);
+	memset(csp->iopm, 0xff, IOPM_SIZE);
+	csp->vmcb.control.msrpm_base_pa = virt_to_phys(csp->msrpm);
+	csp->vmcb.control.iopm_base_pa = virt_to_phys(csp->iopm);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_MSR_PROT);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_IOIO_PROT);
+
+	/* Enable HLT/CPUID/VMMCALL intercepts handled by standalone loop */
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_HLT);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_PAUSE);
+	csp->vmcb.control.pause_filter_count = 4096;
+	csp->vmcb.control.pause_filter_thresh = 128;
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_RDTSC);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_VMMCALL);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_CPUID);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_MONITOR);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_MWAIT);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_NMI);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_INTR);
+	vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_INIT);
+
+	/*
+	 * Clear interrupt-window intercepts and virtual IRQ injection state
+	 * left behind in vmcb01 if vcpu_enter_guest() was aborted while
+	 * KVM had an active interrupt window open (matching VMX clearing
+	 * CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING).
+	 */
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_VINTR);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_IRET);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_STGI);
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_CR8_WRITE);
+
+	/* Clear VMCB clean bits and flush TLB for execution on Caretaker CPU */
+	csp->vmcb.control.clean = 0;
+	csp->vmcb.control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+	csp->vmcb.control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
+	csp->vmcb.control.int_ctl |= V_INTR_MASKING_MASK;
+	if (csp->vmcb.control.int_ctl & V_GIF_ENABLE_MASK)
+		csp->vmcb.control.int_ctl |= V_GIF_MASK;
+	csp->vmcb.control.int_vector = 0;
+	csp->vmcb.control.int_state = 0;
+	csp->vmcb.control.event_inj = 0;
+	csp->vmcb.control.exit_int_info = 0;
+	if (csp->vmcb.control.asid == 0)
+		csp->vmcb.control.asid = 1;
+	csp->vmcb.save.rflags = kvm_get_rflags(vcpu);
+	csp->vmcb.save.rax = csp->common.rax;
+	csp->vmcb.save.rsp = kvm_rsp_read(vcpu);
+	csp->vmcb.save.rip = kvm_rip_read(vcpu);
+	csp->common.cr3 = csp->vmcb.save.cr3;
+	csp->common.cr0 = csp->vmcb.save.cr0;
+	csp->common.cr4 = csp->vmcb.save.cr4;
+	csp->common.efer = csp->vmcb.save.efer;
+	csp->common.last_exit_rsp = csp->vmcb.save.rsp;
+	csp->common.last_exit_rip = csp->vmcb.save.rip;
+	csp->common.last_exit_rflags = csp->vmcb.save.rflags;
+
+	return 0;
+}
+
+void svm_caretaker_init(struct kvm_vcpu *vcpu)
+{
+	struct caretaker_svm_page *csp;
+
+	csp = kho_alloc_preserve(sizeof(*csp));
+	if (IS_ERR(csp)) {
+		pr_err("caretaker svm: failed to allocate preserved page\n");
+		return;
+	}
+
+	if (svm_caretaker_init_page(csp, vcpu)) {
+		kvm_x86_caretaker_unpreserve_pages(&csp->common.abi);
+		vcpu->caretaker.cb = NULL;
+		kho_unpreserve_free(csp);
+	}
+}
+
+static __cpu_preserved_text void
+svm_caretaker_seg_to_kvm(struct kvm_segment *var, const struct vmcb_seg *s, int seg)
+{
+	var->base = s->base;
+	var->limit = s->limit;
+	var->selector = s->selector;
+	var->type = s->attrib & SVM_SELECTOR_TYPE_MASK;
+	var->s = (s->attrib >> SVM_SELECTOR_S_SHIFT) & 1;
+	var->dpl = (s->attrib >> SVM_SELECTOR_DPL_SHIFT) & 3;
+	var->present = (s->attrib >> SVM_SELECTOR_P_SHIFT) & 1;
+	var->avl = (s->attrib >> SVM_SELECTOR_AVL_SHIFT) & 1;
+	var->l = (s->attrib >> SVM_SELECTOR_L_SHIFT) & 1;
+	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
+	var->g = s->limit > 0xfffff;
+	var->unusable = !var->present;
+	if (seg == VCPU_SREG_TR)
+		var->type |= 0x2;
+}
+
+static __cpu_preserved_text void
+svm_caretaker_detach_serialize(void *page, struct kvm_vcpu_arch_ser *state)
+{
+	struct caretaker_svm_page *csp = page;
+	struct vmcb_save_area *save = &csp->vmcb.save;
+
+	csp->common.cr0 = save->cr0;
+	csp->common.cr3 = save->cr3;
+	csp->common.cr4 = save->cr4;
+	csp->common.efer = save->efer;
+	csp->common.last_exit_rip = save->rip;
+	csp->common.last_exit_rsp = save->rsp;
+	csp->common.last_exit_rflags = save->rflags;
+
+	kvm_x86_caretaker_detach_serialize_common(&csp->common, state);
+
+	state->sregs.cr2 = save->cr2;
+	svm_caretaker_seg_to_kvm(&state->sregs.cs, &save->cs, VCPU_SREG_CS);
+	svm_caretaker_seg_to_kvm(&state->sregs.ds, &save->ds, VCPU_SREG_DS);
+	svm_caretaker_seg_to_kvm(&state->sregs.es, &save->es, VCPU_SREG_ES);
+	svm_caretaker_seg_to_kvm(&state->sregs.fs, &save->fs, VCPU_SREG_FS);
+	svm_caretaker_seg_to_kvm(&state->sregs.gs, &save->gs, VCPU_SREG_GS);
+	svm_caretaker_seg_to_kvm(&state->sregs.ss, &save->ss, VCPU_SREG_SS);
+	svm_caretaker_seg_to_kvm(&state->sregs.tr, &save->tr, VCPU_SREG_TR);
+	svm_caretaker_seg_to_kvm(&state->sregs.ldt, &save->ldtr, VCPU_SREG_LDTR);
+	state->sregs.gdt.base = save->gdtr.base;
+	state->sregs.gdt.limit = save->gdtr.limit;
+	state->sregs.idt.base = save->idtr.base;
+	state->sregs.idt.limit = save->idtr.limit;
+
+	kvm_x86_caretaker_update_msr(state, MSR_STAR, save->star);
+	kvm_x86_caretaker_update_msr(state, MSR_LSTAR, save->lstar);
+	kvm_x86_caretaker_update_msr(state, MSR_CSTAR, save->cstar);
+	kvm_x86_caretaker_update_msr(state, MSR_SYSCALL_MASK, save->sfmask);
+	kvm_x86_caretaker_update_msr(state, MSR_KERNEL_GS_BASE, save->kernel_gs_base);
+	kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_CS, save->sysenter_cs);
+	kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_ESP, save->sysenter_esp);
+	kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_EIP, save->sysenter_eip);
+}
+
+static void svm_caretaker_sync_vcpu(struct kvm_vcpu *vcpu, void *vcpu_data)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, raw_smp_processor_id());
+
+	if (sd && sd->save_area_pa)
+		wrmsrq(MSR_VM_HSAVE_PA, sd->save_area_pa);
+
+	kvm_x86_caretaker_sync_vcpu_common(vcpu);
+
+	if (svm->vmcb) {
+		if (!svm->vmcb->control.next_rip && svm->vmcb->control.insn_len)
+			svm->vmcb->control.next_rip = kvm_rip_read(vcpu) +
+						      svm->vmcb->control.insn_len;
+		if (!svm->vmcb->control.next_rip) {
+			switch (svm->vmcb->control.exit_code) {
+			case SVM_EXIT_CPUID:
+			case SVM_EXIT_MSR:
+			case SVM_EXIT_PAUSE:
+				svm->vmcb->control.next_rip = kvm_rip_read(vcpu) + 2;
+				break;
+			case SVM_EXIT_HLT:
+				svm->vmcb->control.next_rip = kvm_rip_read(vcpu) + 1;
+				break;
+			case SVM_EXIT_VMMCALL:
+			case SVM_EXIT_XSETBV:
+			case SVM_EXIT_INVLPGA:
+				svm->vmcb->control.next_rip = kvm_rip_read(vcpu) + 3;
+				break;
+			default:
+				break;
+			}
+		}
+
+		svm->vmcb->control.clean = 0;
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		svm->vmcb->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
+		svm->vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+		if (vgif)
+			svm_set_gif(svm, true);
+		svm_clr_intercept(svm, INTERCEPT_VINTR);
+		svm->vmcb->control.int_state = 0;
+		svm->nmi_masked = false;
+		svm->awaiting_iret_completion = false;
+		svm_set_intercept(svm, INTERCEPT_INTR);
+		svm_set_intercept(svm, INTERCEPT_NMI);
+		svm_set_intercept(svm, INTERCEPT_INIT);
+		svm_clr_intercept(svm, INTERCEPT_RDTSC);
+		svm_clr_intercept(svm, INTERCEPT_PAUSE);
+		svm_recalc_intercepts(vcpu);
+		svm->vmcb->control.event_inj = 0;
+		svm->vmcb->control.exit_int_info = 0;
+	}
+}
+
+void __cpu_preserved_text
+svm_caretaker_decode_exit(void *page,
+			  struct kvm_caretaker_exit *exit)
+{
+	struct caretaker_svm_page *csp = page;
+	u64 exit_code = csp->vmcb.control.exit_code;
+	u64 info1 = csp->vmcb.control.exit_info_1;
+	u64 info2 = csp->vmcb.control.exit_info_2;
+	struct vmcb *vmcb = &csp->vmcb;
+	u64 rip = vmcb->save.rip;
+	u32 insn_len;
+
+	if (vmcb->control.next_rip && vmcb->control.next_rip > rip)
+		insn_len = vmcb->control.next_rip - rip;
+	else
+		insn_len = vmcb->control.insn_len;
+
+	csp->common.last_exit_rip = rip;
+	csp->common.last_exit_rsp = vmcb->save.rsp;
+	csp->common.last_exit_rflags = vmcb->save.rflags;
+	csp->common.cr3 = vmcb->save.cr3;
+	csp->common.cr0 = vmcb->save.cr0;
+	csp->common.cr4 = vmcb->save.cr4;
+	csp->common.efer = vmcb->save.efer;
+	vmcb->control.exit_int_info = 0;
+
+	exit->rip = rip;
+	exit->insn_len = insn_len;
+	exit->raw_reason = exit_code;
+	exit->type = KVM_CARETAKER_EXIT_ARCH;
+
+	switch (exit_code) {
+	case SVM_EXIT_IOIO: {
+		u16 port = (u16)(info1 >> 16);
+
+		if (!exit->insn_len && info2 > rip)
+			exit->insn_len = (u32)(info2 - rip);
+
+		if (port >= COM1_PORT_BASE && port <= COM1_PORT_END) {
+			exit->type = KVM_CARETAKER_EXIT_CONSOLE;
+			exit->mmio_io.addr = port;
+			exit->mmio_io.is_write = !(info1 & SVM_IOIO_TYPE_MASK);
+			exit->mmio_io.size = (u8)((info1 & SVM_IOIO_SIZE_MASK) >>
+						  SVM_IOIO_SIZE_SHIFT);
+			exit->mmio_io.is_mmio = false;
+			exit->mmio_io.val_ptr = &csp->common.rax;
+		}
+		break;
+	}
+	case SVM_EXIT_HLT:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		if (!exit->insn_len)
+			exit->insn_len = 1;
+		break;
+	case SVM_EXIT_PAUSE:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		if (!exit->insn_len)
+			exit->insn_len = 2;
+		break;
+	case SVM_EXIT_CPUID:
+		exit->type = KVM_CARETAKER_EXIT_CPUID;
+		if (!exit->insn_len)
+			exit->insn_len = 2;
+		break;
+	case SVM_EXIT_MSR:
+		exit->type = KVM_CARETAKER_EXIT_MSR;
+		exit->msr.msr = (u32)csp->common.rcx;
+		exit->msr.is_write = (info1 != 0);
+		if (!exit->insn_len)
+			exit->insn_len = 2;
+		break;
+	case SVM_EXIT_INVD:
+	case SVM_EXIT_WBINVD:
+		exit->type = KVM_CARETAKER_EXIT_INSN_STEP;
+		if (!exit->insn_len)
+			exit->insn_len = 2;
+		break;
+	case SVM_EXIT_NPF:
+		exit->type = KVM_CARETAKER_EXIT_UNHANDLED;
+		break;
+	case SVM_EXIT_INTR:
+		kvm_x86_caretaker_disarm_timer();
+		asm volatile("sti\n\tnop\n\tpause\n\tcli" : : : "memory");
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		break;
+	case SVM_EXIT_NMI:
+	case SVM_EXIT_INIT:
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		break;
+	case SVM_EXIT_VINTR:
+	case SVM_EXIT_WRITE_CR8:
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		exit->insn_len = 0;
+		break;
+	case SVM_EXIT_VMMCALL:
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		if (!exit->insn_len)
+			exit->insn_len = 3;
+		break;
+	case SVM_EXIT_RDTSC:
+		exit->type = KVM_CARETAKER_EXIT_RDTSC;
+		if (!exit->insn_len)
+			exit->insn_len = 2;
+		break;
+	default:
+		/*
+		 * Everything not decoded above keeps KVM_CARETAKER_EXIT_ARCH
+		 * and stalls in kvm_x86_caretaker_handle_exit().
+		 *
+		 * XSETBV and RDTSCP used to be decoded here and are
+		 * deliberately not any more.  INSN_STEP means "the instruction
+		 * had no architectural effect worth emulating", which holds
+		 * for INVD and WBINVD on a coherent, guest_memfd-backed VM but
+		 * not for these: stepping XSETBV leaves XCR0 unchanged while
+		 * the guest believes it changed.  RDTSCP is the same story via
+		 * KVM_CARETAKER_EXIT_RDTSC, which writes only RAX and RDX and
+		 * would leave a stale RCX instead of IA32_TSC_AUX.
+		 */
+		break;
+	}
+}
+
+static __cpu_preserved_text void
+svm_caretaker_advance_rip(void *page, u64 rip)
+{
+	struct caretaker_svm_page *csp = page;
+
+	csp->vmcb.save.rax = csp->common.rax;
+	csp->vmcb.save.rip = rip;
+	csp->common.last_exit_rip = rip;
+	csp->common.last_exit_rsp = csp->vmcb.save.rsp;
+}
+
+static __cpu_preserved_text void
+svm_caretaker_arm_timer(void *page, u64 deadline_ticks)
+{
+	struct caretaker_svm_page *csp = page;
+
+	if (deadline_ticks) {
+		vmcb_set_intercept(&csp->vmcb.control, INTERCEPT_INTR);
+		kvm_x86_caretaker_arm_timer(deadline_ticks);
+	} else {
+		vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_INTR);
+	}
+}
+
+static __cpu_preserved_text void
+svm_caretaker_disarm_timer(void *page)
+{
+	struct caretaker_svm_page *csp = page;
+
+	kvm_x86_caretaker_disarm_timer();
+	vmcb_clr_intercept(&csp->vmcb.control, INTERCEPT_INTR);
+	asm volatile("sti\n\tnop\n\tpause\n\tcli" : : : "memory");
+}
+
+static __cpu_preserved_text void
+svm_caretaker_pre_enter(void *page)
+{
+	struct caretaker_svm_page *csp = page;
+	u64 efer;
+
+	csp->orig_hsave_pa = native_rdmsrq(MSR_VM_HSAVE_PA);
+
+	/* Ensure EFER_SVME is enabled and HSAVE is configured */
+	efer = native_rdmsrq(MSR_EFER);
+	csp->orig_efer = efer;
+	native_wrmsrq(MSR_EFER, efer | EFER_SVME);
+	native_wrmsrq(MSR_VM_HSAVE_PA, csp->hsave_pa);
+}
+
+static __cpu_preserved_text void
+svm_caretaker_post_exit(void *page)
+{
+	struct caretaker_svm_page *csp = page;
+
+	native_wrmsrq(MSR_VM_HSAVE_PA, csp->orig_hsave_pa);
+	asm volatile("1: stgi\n\t"
+		     "2:\n\t"
+		     _ASM_EXTABLE(1b, 2b)
+		     : : : "memory");
+	if (!(csp->orig_efer & EFER_SVME))
+		native_wrmsrq(MSR_EFER, native_rdmsrq(MSR_EFER) & ~EFER_SVME);
+}
+
+static const struct kvm_x86_caretaker_runtime_ops svm_caretaker_runtime_ops __cpu_preserved_data = {
+	.detach_serialize = svm_caretaker_detach_serialize,
+	.common = {
+		.enter_guest = svm_caretaker_enter,
+		.decode_exit = svm_caretaker_decode_exit,
+		.handle_arch_exit = kvm_x86_caretaker_handle_exit,
+		.advance_rip = svm_caretaker_advance_rip,
+		.arm_timer = svm_caretaker_arm_timer,
+		.disarm_timer = svm_caretaker_disarm_timer,
+		.pre_run = svm_caretaker_pre_enter,
+		.post_run = svm_caretaker_post_exit,
+	},
+};
+
+static const struct kvm_x86_caretaker_ops svm_caretaker_ops = {
+	.name = "svm",
+	.init = svm_caretaker_init,
+	.sync_vcpu = svm_caretaker_sync_vcpu,
+	.runtime = &svm_caretaker_runtime_ops,
+};
+
+void svm_caretaker_register(void)
+{
+	kvm_x86_caretaker_register_ops(&svm_caretaker_ops);
+}
+
+void svm_caretaker_unregister(void)
+{
+	kvm_x86_caretaker_unregister_ops(&svm_caretaker_ops);
+}
diff --git a/arch/x86/kvm/svm/caretaker_vmenter.S b/arch/x86/kvm/svm/caretaker_vmenter.S
index e0276a34403e..10303268844e 100644
--- a/arch/x86/kvm/svm/caretaker_vmenter.S
+++ b/arch/x86/kvm/svm/caretaker_vmenter.S
@@ -27,7 +27,7 @@ SYM_TYPED_FUNC_START(svm_caretaker_enter)
 	sti
 
 	/* 0. Save host VMCB state (FS, GS, TR, LDTR) to host save area */
-	movq CXP_HSAVE_PA(%rdi), %rax
+	movq CSP_HSAVE_PA_OFFSET(%rdi), %rax
 	testq %rax, %rax
 	jz 10f
 	vmsave %rax
@@ -69,7 +69,7 @@ SYM_TYPED_FUNC_START(svm_caretaker_enter)
 	movq %rbx, CXP_REG_RAX(%rdi)
 
 	/* 5a. Restore host VMCB state (FS, GS, TR, LDTR) from HSAVE */
-	movq CXP_HSAVE_PA(%rdi), %rax
+	movq CSP_HSAVE_PA_OFFSET(%rdi), %rax
 	testq %rax, %rax
 	jz 40f
 	vmload %rax
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7d59d301e1e5..ca6b0d1e80fe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -54,6 +54,7 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "caretaker.h"
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
@@ -973,6 +974,8 @@ static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
+	svm_caretaker_unregister();
+
 	avic_hardware_unsetup();
 
 	sev_hardware_unsetup();
@@ -1117,7 +1120,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_RDPMC);
 }
 
-static void svm_recalc_intercepts(struct kvm_vcpu *vcpu)
+void svm_recalc_intercepts(struct kvm_vcpu *vcpu)
 {
 	svm_recalc_instruction_intercepts(vcpu);
 	svm_recalc_msr_intercepts(vcpu);
@@ -4344,6 +4347,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	bool nmi_l1_to_l2 = svm->nmi_l1_to_l2;
 	bool soft_int_injected = svm->soft_int_injected;
 
+	svm->vmcb->control.exit_int_info = 0;
 	svm->nmi_l1_to_l2 = false;
 	svm->soft_int_injected = false;
 
@@ -4396,7 +4400,8 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
-		kvm_queue_interrupt(vcpu, vector, false);
+		if (kvm_get_rflags(vcpu) & X86_EFLAGS_IF)
+			kvm_queue_interrupt(vcpu, vector, false);
 		break;
 	case SVM_EXITINTINFO_TYPE_SOFT:
 		kvm_queue_interrupt(vcpu, vector, true);
@@ -5762,6 +5767,8 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
+	svm_caretaker_register();
+
 	return 0;
 
 err:
-- 
2.55.0.1082.g2b9226bbc0-goog

