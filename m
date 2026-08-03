Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4C3374185
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751876; cv=none; b=V7VrTTKBWujzxKPAJn4wwTyiEXMZABcOg025asbrgllWABpR3d3BWWRJ/uNFmqbCsyOsmsOuKJqY/FYBq2j1e6AtLOUjaBhE0jO3PLHcRGhTv6FeRkod8xcWHWyQpwjc0iPBdabQe9Bcr83Fins4L2Cw6SqlHKcMNCho4vLTfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751876; c=relaxed/simple;
	bh=EH2flhI4q65QNMRPu3+Y05QHJdBRR+KFgu2IAthf0cg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rKEvQTbIhxF2y/oVtIPqx5Y9/PMRxLlEXjUA+po9pNkaisvdY20Qpdf88nwpSaA1zZ+G2NcqQPCveNgioE35P5W3qAT7rykwmDABpsz6jjh4ZLz/GXUOBIM98jm6pw44a3iRQDE0UbO08V6vNXxSBGUJVZ9nIR3X616usKWVGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qJRwAV0Z; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qJRwAV0Z"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so12769465e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751873; x=1786356673; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pzBN8oLenEhtYK3k0GqK0Qcx+e9V+BXk82b1WTsle7I=;
        b=qJRwAV0ZM182NSZ18gZD2CP7iSQ9vT9mpKYq/M5fCg74ExKcqyk6GsPHCk+SFRjrlx
         CBg8XEoRBUXb+KtIyJGKQcR3d6psWq0MSZS22fJF8sc6VGVOnytuSM7KLyOU1PWdjEG3
         hEPA2b/gzrw/dutUY+bCFqf85ZsBhnC1/M3RUfydGOkjN53TWog/U9U23ndgMk2OqI40
         16GaSZb0Cnk1LT6ePyzgIPC7Bmq6cs8qqJUeHySssIMSuR5AG4iUdL5iswmsES0319NP
         /L0RsdTIe4HXYguNtiaD/9ISLhwgH7mXAms6AgIvGWT8oYCG42T/jsK1DhPcr7C56vrq
         Ge3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751873; x=1786356673;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pzBN8oLenEhtYK3k0GqK0Qcx+e9V+BXk82b1WTsle7I=;
        b=OBoKaLBsIsEFrv5j+9jV0jl8U8LUA5pD6yYi5EkYoyhQCDS7yHyf6J288NwWwEPI7e
         MYqIqeuEzZaG0qC1WJcDbhYocp0p76iKK2bmNdXFV/tSwm/XtN61lbrwu6ogFZJYw4fZ
         zi3dVoZdBdmTOatAk3OSkwIPn/4Zh3KyEAVjOvuW6zxNgXmLjKHrfiOTjlP60crZFjuq
         3wnOv8JE0mUOKnOSwadnqU1XOZLn0ZKLz5zGI+e5hPQdVzuy8rbTAA8ZjpHIEWZ7/8WH
         270EpVTOqwwcJUzq65B81NWypVnt6ExVVEBL6+Zs44YRt+18NdJUL5SCZ4auEcVY+E5N
         x3Xg==
X-Forwarded-Encrypted: i=1; AHgh+Rponfb16ku6qsoZkChXyIwVN0a2q7Mxe1Brxbo4ccDoRaIUbLnSHRvsDRHtmIiG3UJpbc3bp8o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYzM2ToXALDVlgiwazACFGQzzGOgFQ9dO89z5kOn1GiFtKr70s
	yU7Xj2jO4GghQ5uZ2Vt3ItfmIan1mNvGPWuCzz6W7WJQuGacoeiaKJJbto+BiCe9F3SeSVSMZ+n
	wHBNoV1gTw0FqfdSTp1RhqQ==
X-Received: from wmpe20.prod.google.com ([2002:a05:600c:4b94:b0:495:5762:2123])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e557:10b0:495:5890:8f6c with SMTP id 5b1f17b1804b1-4980c64b824mr137177625e9.7.1785751872686;
 Mon, 03 Aug 2026 03:11:12 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:59 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-16-vdonnefort@google.com>
Subject: [PATCH 15/20] KVM: arm64: Add pkvm_hyp_req infrastructure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM hypervisor depends on the host for a lot of operations like
memory allocation. Introduce a struct pkvm_hyp_req to enable the pKVM
hypervisor to request resources from the host.

Additionally, introduce a trace event to track the handling of these
requests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 37c5e22fac98..00ba99c85874 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -17,10 +17,11 @@
 #define ARM_EXCEPTION_IS_TRAP(x)  (ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_TRAP)
 #define ARM_SERROR_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_SERROR_BIT))
 
-#define ARM_EXCEPTION_IRQ	  0
-#define ARM_EXCEPTION_EL1_SERROR  1
-#define ARM_EXCEPTION_TRAP	  2
-#define ARM_EXCEPTION_IL	  3
+#define ARM_EXCEPTION_IRQ		0
+#define ARM_EXCEPTION_EL1_SERROR	1
+#define ARM_EXCEPTION_TRAP		2
+#define ARM_EXCEPTION_IL		3
+#define ARM_EXCEPTION_PKVM_HYP_REQ	4
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
@@ -28,6 +29,7 @@
 	{ARM_EXCEPTION_IRQ,		"IRQ"		},	\
 	{ARM_EXCEPTION_EL1_SERROR, 	"SERROR"	},	\
 	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
+	{ARM_EXCEPTION_PKVM_HYP_REQ,	"PKVM_HYP_REQ"	},	\
 	{ARM_EXCEPTION_HYP_GONE,	"HYP_GONE"	}
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..d01e6954d363 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -85,6 +85,15 @@ u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+enum pkvm_hyp_req_type {
+	PKVM_HYP_NO_REQ = 0,
+	__PKVM_HYP_REQ_TYPE_MAX,
+};
+
+struct pkvm_hyp_req {
+	u8 type;
+};
+
 struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
@@ -925,6 +934,9 @@ struct kvm_vcpu_arch {
 	/* Pages to top-up the pKVM/EL2 guest pool */
 	struct kvm_hyp_memcache pkvm_memcache;
 
+	/* To be read on ARM_EXCEPTION_PKVM_HYP_REQ */
+	struct pkvm_hyp_req pkvm_hyp_req;
+
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index c53869cb6be1..41813bb93b2e 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -22,6 +22,7 @@ int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
+int __pkvm_handle_vcpu_req(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
 void pkvm_ownership_selftest(void);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..d7f7bbe5db5c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -18,6 +18,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/debug-monitors.h>
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
@@ -464,6 +465,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
+	case ARM_EXCEPTION_PKVM_HYP_REQ:
+		return __pkvm_handle_vcpu_req(vcpu);
 	case ARM_EXCEPTION_HYP_GONE:
 		/*
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 4d41a16cd596..2dc67e8d1aaa 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -16,6 +16,9 @@
 
 #include "hyp_constants.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace_pkvm.h"
+
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
@@ -628,3 +631,20 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 
 	return !ret || ret == -EAGAIN;
 }
+
+static int pkvm_hyp_req_handle(struct pkvm_hyp_req *req, struct kvm_vcpu *vcpu)
+{
+	int ret = -EINVAL;
+
+	switch (req->type) {
+	}
+
+	trace_kvm_handle_pkvm_hyp_req(req, ret);
+
+	return ret;
+}
+
+int __pkvm_handle_vcpu_req(struct kvm_vcpu *vcpu)
+{
+	return pkvm_hyp_req_handle(&vcpu->arch.pkvm_hyp_req, vcpu) ?: 1;
+}
diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
new file mode 100644
index 000000000000..3966c111e3ad
--- /dev/null
+++ b/arch/arm64/kvm/trace_pkvm.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_PKVM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PKVM_ARM64_KVM_H
+
+#include <linux/tracepoint.h>
+#include <asm/kvm_pkvm.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+TRACE_DEFINE_ENUM(PKVM_HYP_NO_REQ);
+
+#define PKVM_HYP_REQ_TYPES \
+	{ PKVM_HYP_NO_REQ, "NO_REQ" }
+
+TRACE_EVENT(kvm_handle_pkvm_hyp_req,
+	TP_PROTO(struct pkvm_hyp_req *req, int ret),
+	TP_ARGS(req, ret),
+
+	TP_STRUCT__entry(
+		__field(u8,	type)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->type = req->type;
+		__entry->ret = ret;
+	),
+
+	TP_printk("type: %s ret: %d",
+		  __print_symbolic(__entry->type, PKVM_HYP_REQ_TYPES),
+		  __entry->ret)
+);
+
+#endif /* _TRACE_PKVM_ARM64_KVM_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace_pkvm
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.55.0.508.g3f0d502094-goog

