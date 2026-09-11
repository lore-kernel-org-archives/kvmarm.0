Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B6489886
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134688; cv=none; b=GOAYR2Vg3epp+TjGQUrP7U+vyfDtX2apu3hjOCmy/hnhs2Twu2+GF3CUyMu/KRT8P3/faLsl5cvnXgrDBTYKSE9GZuFrHTMhaRLmCfsyEOXno7rbGc7Lz1kGIktyENgh+2VaJTByHfNI5ql55KDMzx+Nw+qa+i+QQ17rXXxaHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134688; c=relaxed/simple;
	bh=2kWRrbEYZpYX5eAcAlproxiqoCUv6QvvtruJH82qzyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SKpBGL8xhk2d5n0MiDv/rm3A6QXbiFz8UU+hPIMLEOprh4vUObiYN0RTE97/TmdP1FVY0UvmJkwwQDWJtEmUQs3CDdvBRCYoJn6lXGKrR+Vd2nmkcM2BEl2jBUAi37B59ylHBNNdVtQsTR8OmZj5BvRY83ulR2B51RDn4guGjMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kr3wjyYM; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kr3wjyYM"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955e865174so4645825e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134681; x=1789739481; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vymh7WtkCS2L1vZH6F2vEzmi/F3C/O1M/vjWHAIX6fs=;
        b=Kr3wjyYMFr+oiUvY0J96vriqYUGcUBYAhBRv6H9F0AaHS+6vmvptCh0fijdKFArXm3
         gNq4n9BKstm2OYX8U12/ywiOhGL77x+wltDviVdusgrBmeoNx+CCa9zu7vpR5suMG+qG
         b2yI8EqoPu82A8Tnv9X/VC5+vxZnFyXZsYIpd9Z/DpowayPYhtVM3D00+i4dODAj4ket
         GNa/6SHEJEwasuXBUgOg2HPLiQsOO5Wt0ZJgtLAUaZzTWtqbiyMPMJ9WvG8bU6dxLE9/
         kP2mwza8qUQd7YZKWyQYKiG4t9E+f5fZdyWM4h6J3vleQr6EJPDmXG6TfixSnJYfZVNs
         IYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134681; x=1789739481;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vymh7WtkCS2L1vZH6F2vEzmi/F3C/O1M/vjWHAIX6fs=;
        b=nYPRyOe0w8hqJvYvGzNa5NTqgowy5mJmBexzBcLs+zxCBjGZ4qQ34FOgHlD5og1JFT
         /lF6eSoDe37y0rVAe/GO+Kewvt6HAcO8u1DUXmCZ3uAlmK7BjMXi7UlORJhGlsTpfwd6
         Ka/EHEGYEezZ+WJ4KE/XQ2E2raz3Vzv/jvV1nQ8/1gW0GjRfFFgfabJ1Lyrii9LxXrCQ
         GydgnGK9MkK2i2zvR/p6AD6McfKHQH1IiqVOh32/Q6TSMIawFFnyRhQZSYHVZt4YfH0F
         T3C0xYUWZvNMh6QtPJqPyE+dv8VvptMRqHHIOr4Ttern0p2wlvpDgFQkEyKvbOJ3Maf9
         eC2w==
X-Forwarded-Encrypted: i=1; AKwUvBynydZGTsoq/hI3Yh/xYrySBT20L3I/TlmiTRi5Gs5X2Ddu4ZKfTdOFfQj+HnuIHSosEtKvl4M=@lists.linux.dev
X-Gm-Message-State: AFuF++lP1JpqziM5IafW1YunRu/xuyshUJGXdBsVt/2VUIFcFdr0qw0h
	bGr7OnSSkBDVKNdVX0t9EN6GErmfl2+MUFV3ZMPprwNMCf11dwYbhl8WFdy0EZ8y9I5GvPxFAID
	Trbapnz6fDQLjHiiM5bbXaQ==
X-Received: from wmon22.prod.google.com ([2002:a05:600c:4656:b0:498:88df:a3b0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37c4:b0:49d:93c:d903 with SMTP id 5b1f17b1804b1-49e619e0e8fmr50487405e9.20.1789134680903;
 Fri, 11 Sep 2026 06:51:20 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:47 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-17-vdonnefort@google.com>
Subject: [PATCH v2 16/22] KVM: arm64: Add pkvm_hyp_req infrastructure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM hypervisor depends on the host for a lot of operations like
memory allocation. Introduce a struct pkvm_hyp_req to enable the pKVM
hypervisor to request resources from the host.

Additionally, introduce a trace event to track the handling of these
requests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 10 ++++---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++
 arch/arm64/include/asm/kvm_pkvm.h |  1 +
 arch/arm64/kvm/handle_exit.c      |  3 +++
 arch/arm64/kvm/pkvm.c             | 20 ++++++++++++++
 arch/arm64/kvm/trace_pkvm.h       | 43 +++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kvm/trace_pkvm.h

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 95dd62e5601b..ec59f0fe9374 100644
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
index 27fe0cd5b2d7..ea76c0f3120e 100644
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
@@ -929,6 +938,9 @@ struct kvm_vcpu_arch {
 	/* Pages to top-up the pKVM/EL2 guest pool */
 	struct kvm_hyp_memcache pkvm_memcache;
 
+	/* To be read on ARM_EXCEPTION_PKVM_HYP_REQ */
+	struct pkvm_hyp_req pkvm_hyp_req;
+
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ff8e93efcd7a..7240dcc4f395 100644
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
index db37678dcb05..90500b204e16 100644
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
index ae434f806455..02ad686d7661 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -16,6 +16,9 @@
 
 #include "hyp_constants.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace_pkvm.h"
+
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
@@ -632,3 +635,20 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 
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
2.55.0.1007.g17ff1f9808-goog

