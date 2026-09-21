Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5D5013A8
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024447; cv=none; b=cHti65tcNN1kQOWPEXrDZHvQgsRDypoyu1qgrDdikHZSrNyQF3Rr6WSZT8mEFe+1BvQfT5Kwtk/e1TbDpx9Ji/GLUWCMjnouaaqhVeF1osCkYTnq8dnM+Od2VM9F3azMGcwpwKfKk7gqoNNE1PTfLX9S22QPRUdpDzA6TyNYxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024447; c=relaxed/simple;
	bh=jNIfPpRT/i6OQboSDr2k2xQIDCBYNf9ia74ZJdEkxT0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdXuR2gzLeO/5aWBof4MYbXo4mA30fFjLnARKZesWdTnRb4oHSsiRFRYnF7yHJUojS+JWlXW08jJi52WEUOtZMAPYcIQEJP90zqPHntJFv9H7wffl5NddqpOZoVVQ9mBCe4KTZCgixzv5NAr53a98xLRlAavNEBwMb/YHx8smOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=GKVmYaSs; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="GKVmYaSs"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so30882227b3.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024443; x=1790629243; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LyT1gPJmowaA4BnBpSt/USFny02ugqagur5yRQ9/hu4=;
        b=GKVmYaSs078uMytH8ncKLX4R6adanbmI4kCxh2O6T7kGvtZJENpq1jKCMRHnlMgSmE
         liJmhlaluCx8gaXS1CDYBTS9WWIb6/F/goNI3Ym2zKPn9+9tSfkJ2/xZa+6bobcOlKVf
         6q/sF+uMxNPbrZOYTQCihlVsDmpyopXxfHCaVOB+zsoOnYlJYm3cNaf65fc1jwRP6SfY
         GIz1t7JF2vOoMm9EKEwyd8NKyOU1ecf7/xWRfvaIiN6+fuyKopx4Qh0ldoJrzM87Ls58
         yeJvA1vX9O756asp3JeEgxXjXx0The9bSMhVOxwFBFbAA9iDKNq9ABvGblIml65+lQh1
         4cCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024443; x=1790629243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LyT1gPJmowaA4BnBpSt/USFny02ugqagur5yRQ9/hu4=;
        b=OK+g1FUyGIxWb1k3cU7P7MO07kDU8Xr6kgSN4wkb+YNmBAvHrPkaIV1zvP3E6+u2sL
         hxl20EEURGIac3RgThAUFdQMSGlMvTkx3ZtOB06hkyHVvYciIDxRhpakpuprHNtLCHgI
         VysUCKtlSH9w9rt3hvippqLYldcSTf88zxaslVNZHNCF3eEz38AHkByNYgYi8XkiDubF
         n11VjXuwsh79WMO2sVQ6AWr/4KRB293HdME7M8PT9uUKt0PGbIRpGB1Bxz4I/8GMZ0TY
         d+cYHt2Lo6OzzBCBMQ2nxIxyeYgbE4sze8uJ5kTSzXpwwslxz7zEVW3iR9/C6rQmc3lm
         cgAw==
X-Forwarded-Encrypted: i=1; AKwUvBwzii//PjkxoHtoP6BRlAEB8K5FdHu5pJ+I83P21UTVVVBR7Uw+oV2pei8RiChELbTImsxxqgo=@lists.linux.dev
X-Gm-Message-State: AFuF++mOuh+HIhCBkBzcfaD82uZhzXjwSKQOVXgeomanFJfp7wNoH/pl
	S6xm7qDhoOtKvEP2x+47UJvWLUTvydOV5ZB5bDblauAm7S8FnIISAWoOlJfjY2u9DuA=
X-Gm-Gg: AYBFou2wCH67RZ0j5nFR7fozFuZXNRgNkVIGDV+Ro7RceCSMJF7N/Rt/F1P7Png0anM
	HUNNYLMEhyPEuLR1jc8k0L3E+5t6bayUzdC171X+f711m8vs4OkogOKdxyY5WcuiR0zDy13gSAj
	iCD/8zHVw/v08uuuwT67B2NqQKe38EDzDM2fqds8ervheIK8hsyF3gICcDLQH3eE98GFD0Z1s65
	p9uCPWlWMACHHaoUezvsZ5tBGUH25Wg0XHVFjxZ9+p75ddRZSyRPEfnoaLAdPHLF/nCuJIEm0jG
	e7po9hvLSsd+a4Z8/7WsmXcRX5AP7Rw6ODfSqOcWucTqRyIp4B+8uf7xQ/w42IC8ukiWD7P9GGh
	d2GsbqHyN57pARco/ykTLFao28CxBitMJ0cOKcbQSujUdZIwqXJkkzfs0M7SukDHVWRkY5WWDeY
	A1vgIflIqKbb9Jw2StG6ZDiXB/9gqHVzi42mbd6sv9ewbAaO4+SuZ/SLdT/OQyu1HwzTLAOaxf6
	HG3hGGLQ5tjkO6+63N9/AvubG3uFJmFgY/q0xYFMDGFiifp987skrT36UyHX9F/yDLopRcvMaxC
	OZvmYGD5BBKBGWln6tE=
X-Received: by 2002:a05:690c:6606:b0:85b:f1ba:b111 with SMTP id 00721157ae682-89735d833a0mr60441177b3.26.1790024441836;
        Mon, 21 Sep 2026 14:00:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:41 -0700 (PDT)
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
Subject: [RFC PATCH 40/46] KVM: SVM: Add Caretaker SVM assembly guest entry/exit routine
Date: Mon, 21 Sep 2026 17:00:28 -0400
Message-ID: <20260921210034.180424-2-pasha.tatashin@soleen.com>
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

Add arch/x86/kvm/svm/caretaker_vmenter.S and caretaker.h for standalone
AMD SVM VMRUN world switch on preserved physical cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/svm/caretaker.h         | 63 +++++++++++++++++++
 arch/x86/kvm/svm/caretaker_vmenter.S | 91 ++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 arch/x86/kvm/svm/caretaker.h
 create mode 100644 arch/x86/kvm/svm/caretaker_vmenter.S

diff --git a/arch/x86/kvm/svm/caretaker.h b/arch/x86/kvm/svm/caretaker.h
new file mode 100644
index 000000000000..54a0673cb1ea
--- /dev/null
+++ b/arch/x86/kvm/svm/caretaker.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __SVM_CARETAKER_H
+#define __SVM_CARETAKER_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/kvm_host.h>
+#include <linux/oncore.h>
+#include "svm.h"
+#endif
+
+#include "../caretaker.h"
+
+#define CSP_VMCB_OFFSET		0x1000
+#define CSP_HSAVE_PA_OFFSET	0x3000
+#define CSP_VMCB_PA_OFFSET	0x3010
+#define VMCB_RAX_OFFSET		0x5f8
+
+#ifndef __ASSEMBLY__
+
+struct caretaker_svm_page {
+	struct caretaker_x86_page common;
+
+	/* Page 1 (4KB): Preserved VMCB */
+	struct vmcb vmcb __aligned(PAGE_SIZE);
+
+	/* Page 2 (4KB): Preserved HSAVE area */
+	u8 hsave_area[PAGE_SIZE] __aligned(PAGE_SIZE);
+	u64 hsave_pa;
+	u64 orig_hsave_pa;
+	u64 vmcb_pa;
+	u64 orig_efer;
+
+	/* Preserved MSR and I/O permission bitmaps referenced by VMCB */
+	u8 msrpm[MSRPM_SIZE] __aligned(PAGE_SIZE);
+	u8 iopm[IOPM_SIZE] __aligned(PAGE_SIZE);
+} __aligned(PAGE_SIZE);
+
+static_assert(offsetof(struct caretaker_svm_page, vmcb) == CSP_VMCB_OFFSET);
+static_assert(offsetof(struct caretaker_svm_page, hsave_pa) == CSP_HSAVE_PA_OFFSET);
+static_assert(offsetof(struct caretaker_svm_page, vmcb_pa) == CSP_VMCB_PA_OFFSET);
+
+void svm_recalc_intercepts(struct kvm_vcpu *vcpu);
+
+#ifdef CONFIG_KVM_CARETAKER
+int svm_caretaker_enter(void *page);
+void svm_caretaker_decode_exit(void *page, struct kvm_caretaker_exit *exit);
+void svm_caretaker_register(void);
+void svm_caretaker_unregister(void);
+void svm_caretaker_init(struct kvm_vcpu *vcpu);
+#else
+static inline void svm_caretaker_register(void) {}
+static inline void svm_caretaker_unregister(void) {}
+static inline void svm_caretaker_init(struct kvm_vcpu *vcpu) {}
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __SVM_CARETAKER_H */
diff --git a/arch/x86/kvm/svm/caretaker_vmenter.S b/arch/x86/kvm/svm/caretaker_vmenter.S
new file mode 100644
index 000000000000..e0276a34403e
--- /dev/null
+++ b/arch/x86/kvm/svm/caretaker_vmenter.S
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/linkage.h>
+#include <linux/cfi_types.h>
+#include <asm/asm.h>
+#include <asm/bitsperlong.h>
+#include <asm/nospec-branch.h>
+#include "caretaker.h"
+#include "../caretaker_asm.h"
+
+.section .text.cpu_preserved, "ax"
+
+/**
+ * svm_caretaker_enter - Low-level transition to SVM guest mode and back
+ * @csp: Pointer to struct caretaker_svm_page (%rdi)
+ */
+SYM_TYPED_FUNC_START(svm_caretaker_enter)
+	ENDBR
+	CARETAKER_PUSH_HOST_REGS
+	movq %cr3, %rax
+	pushq %rax                  /* saved_cr3 */
+
+	clgi
+	sti
+
+	/* 0. Save host VMCB state (FS, GS, TR, LDTR) to host save area */
+	movq CXP_HSAVE_PA(%rdi), %rax
+	testq %rax, %rax
+	jz 10f
+	vmsave %rax
+10:
+
+	/* 1. Sync guest RAX to VMCB and load guest state (FS, GS, TR, LDTR) */
+	leaq CSP_VMCB_OFFSET(%rdi), %rax
+	movq CXP_REG_RAX(%rdi), %rbx
+	movq %rbx, VMCB_RAX_OFFSET(%rax)
+	movq CSP_VMCB_PA_OFFSET(%rdi), %rax
+	vmload %rax
+
+	/* 2. Restore guest GPRs */
+	CARETAKER_RESTORE_GPRS_NO_RAX %rdi
+
+	/* 3. Run guest */
+	pushq %rdi
+	movq CXP_REG_RDI(%rdi), %rdi
+	movq (%rsp), %rax
+	movq CSP_VMCB_PA_OFFSET(%rax), %rax
+	CARETAKER_CLEAR_CPU_BUFFERS
+	vmrun %rax
+	cli
+
+	/* 4. Guest exited: Save guest GPRs */
+	xchgq %rdi, (%rsp)          /* rdi = csp, stack = guest rdi */
+	popq CXP_REG_RDI(%rdi)
+
+	CARETAKER_SAVE_GPRS_NO_RAX %rdi
+
+	/* Stuff Return Stack Buffer to prevent guest RSB poisoning */
+	CARETAKER_FILL_RETURN_BUFFER %rax
+
+	/* 5. Save guest state to VMCB */
+	movq CSP_VMCB_PA_OFFSET(%rdi), %rax
+	vmsave %rax
+	leaq CSP_VMCB_OFFSET(%rdi), %rax
+	movq VMCB_RAX_OFFSET(%rax), %rbx      /* save.rax */
+	movq %rbx, CXP_REG_RAX(%rdi)
+
+	/* 5a. Restore host VMCB state (FS, GS, TR, LDTR) from HSAVE */
+	movq CXP_HSAVE_PA(%rdi), %rax
+	testq %rax, %rax
+	jz 40f
+	vmload %rax
+40:
+
+	/* 5b. Restore host CR3 if clobbered */
+	popq %rbx                   /* saved_cr3 */
+	movq %cr3, %rcx
+	cmpq %rbx, %rcx
+	je 50f
+	movq %rbx, %cr3
+50:
+	stgi
+
+	/* 6. Restore host callee-saved registers & return to C */
+	CARETAKER_POP_HOST_REGS
+	xorq %rax, %rax
+	ret
+SYM_FUNC_END(svm_caretaker_enter)
-- 
2.55.0.1082.g2b9226bbc0-goog

