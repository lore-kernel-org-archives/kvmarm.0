Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073FF35B657
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866189; cv=none; b=lX+UCOcpQhVYQs4jz0VZ1oy54ViqhrdqtNS5m+37jyRNhsxLRcikarzPUrRSYLCTG5j+M/ZgR5Odf7qz0OI0k5gHIRwznvYKmab7xz0htIq5k1v1MVr3W2QjCrNJClibSMwrUD9OpkIrJEOFmilv7EEtudlHsKC1aa95+PS4oKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866189; c=relaxed/simple;
	bh=eiztNk9V9XLgxaU9V8P/ZDojwGXQJZ05Pi8JyM4gudw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iXmih1I2KlaFqCoLQdHucze7fS4JClR0Gabg0Ilbn5VjRX67hlNJnPIIKDDdHu9i7R9s5xogURtCNQV86mqWVh8qRv8gsJ4KAYq5+jVp9dDSYEsZc6uJMY/yqev40KEzrefyxS6BcBlv21L2gokodzBbM8SlNTfZRfl9yQFb3Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ax8cefdB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ax8cefdB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48070c21420so22790745e9.0
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866183; x=1770470983; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PZYjwWiOCxpTt30ZNbaITSBX6aRcC/J92BrjAxtHnOo=;
        b=ax8cefdBOGDOxCVOZDwjM1OYWZFnwdMOFLBBqG5lCG79s58Vhhx7j/gQiv1yMZoHyU
         ceHWen4qQhp1/eOz0d2G/YugP68VkPyy98RPymxRYjHMWC6AzFX4r2muzCvya+onXm8K
         cPybsy2ZN7VRkr8Ih7bu95CYdfcHdmUMPtJ6liMp37fkkdC1YTaISotXNKF3vY/penj3
         DPmgOxxv5hFvp5ak4ozOmWqXYqNp6qw4MZJoxhmrbbcCAPl4dg32uw7PfFSO0qnB/tfY
         DwBvq9QC0WSoS2m1LLJbBSHO8MxohndaU9emNyj40180UkUdijeI3GTt4vhjt2g2F6k4
         MNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866183; x=1770470983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PZYjwWiOCxpTt30ZNbaITSBX6aRcC/J92BrjAxtHnOo=;
        b=NrRrXA0lx19NxLnq85LxP/gSW/22dyQnqEiX7g5rYFA0oFySR9zWmo7uZTppput9zU
         my2316+40yD9zvqnQz8pu6tf3kCrjDj+Yh9w5XQhxPZOF49lGYAO6pawNt9psoviO45z
         ImMH6JYJNitbH23kq2Y9q0YllBNtvExPbGoCg9vfcPiwJiWZbx9llckJQgcghhmyu1Qy
         U9Y5FHkRByAhsB40NsKbFrXuXPxJG7c3aUVszKznJJBbybICrUy0ql7NNfaqz+6dXcFp
         6Ga8yeMBitVLWGigldEezKR74YyTCS4Gxu9SxEOosPcZlRAotYJF3lDzzWImuFCJ74m5
         ZzqA==
X-Gm-Message-State: AOJu0Yz/jdtwNg16IToiVshd7UVCRDQk+nj3MCP/+PnRPECEKrUXE6FV
	Swe62nkZjr1QGzoS79745m3rYMRVw4ej2Y3JSJMPoshwDttWl6cerIe6Xu+l8XNr7qcvIKp2xPs
	dJgKjU58+6W5PW1cWYxy/IQ==
X-Received: from wmsm42.prod.google.com ([2002:a05:600c:3b2a:b0:47e:d9ed:20f0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e91:b0:47f:1332:e5f with SMTP id 5b1f17b1804b1-480829b5cfamr135738605e9.12.1769866183064;
 Sat, 31 Jan 2026 05:29:43 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:41 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-24-vdonnefort@google.com>
Subject: [PATCH v11 23/30] KVM: arm64: Add tracing capability for the
 nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

There is currently no way to inspect or log what's happening at EL2
when the nVHE or pKVM hypervisor is used. With the growing set of
features for pKVM, the need for tooling is more pressing. And tracefs,
by its reliability, versatility and support for user-space is fit for
purpose.

Add support to write into a tracefs compatible ring-buffer. There's no
way the hypervisor could log events directly into the host tracefs
ring-buffers. So instead let's use our own, where the hypervisor is the
writer and the host the reader.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ce516d8187b1..c3a7fc939f42 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___tracing_load,
+	__KVM_HOST_SMCCC_FUNC___tracing_unload,
+	__KVM_HOST_SMCCC_FUNC___tracing_enable,
+	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
new file mode 100644
index 000000000000..9c30a479bc36
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYPTRACE_H_
+#define __ARM64_KVM_HYPTRACE_H_
+
+#include <linux/ring_buffer.h>
+
+struct hyp_trace_desc {
+	unsigned long			bpages_backing_start;
+	size_t				bpages_backing_size;
+	struct trace_buffer_desc	trace_buffer_desc;
+
+};
+#endif
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6498dec00fe9..c7f50492f2cf 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -73,6 +73,11 @@ config NVHE_EL2_DEBUG
 
 if NVHE_EL2_DEBUG
 
+config NVHE_EL2_TRACING
+	bool
+	depends on TRACING
+	default y
+
 config PKVM_DISABLE_STAGE2_ON_PANIC
 	bool "Disable the host stage-2 on panic"
 	default n
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
new file mode 100644
index 000000000000..7da8788ce527
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
+#define __ARM64_KVM_HYP_NVHE_TRACE_H
+#include <asm/kvm_hyptrace.h>
+
+#ifdef CONFIG_NVHE_EL2_TRACING
+void *tracing_reserve_entry(unsigned long length);
+void tracing_commit_entry(void);
+
+int __tracing_load(unsigned long desc_va, size_t desc_size);
+void __tracing_unload(void);
+int __tracing_enable(bool enable);
+int __tracing_swap_reader(unsigned int cpu);
+#else
+static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
+static inline void tracing_commit_entry(void) { }
+
+static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
+static inline void __tracing_unload(void) { }
+static inline int __tracing_enable(bool enable) { return -ENODEV; }
+static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
+#endif
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8dc95257c291..f1840628d2d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -29,9 +29,12 @@ hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o
+hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o
 hyp-obj-y += $(lib-objs)
 
+# Path to simple_ring_buffer.c
+CFLAGS_trace.nvhe.o += -I$(objtree)/kernel/trace/
+
 ##
 ## Build rules for compiling nVHE hyp code
 ## Output of this folder is `kvm_nvhe.o`, a partially linked object
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5559b622ea57..eddbf5df5d13 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -18,6 +18,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/trace.h>
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -587,6 +588,33 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
+	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
+}
+
+static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
+{
+	__tracing_unload();
+}
+
+static void handle___tracing_enable(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(bool, enable, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __tracing_enable(enable);
+}
+
+static void handle___tracing_swap_reader(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __tracing_swap_reader(cpu);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -628,6 +656,10 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__tracing_load),
+	HANDLE_FUNC(__tracing_unload),
+	HANDLE_FUNC(__tracing_enable),
+	HANDLE_FUNC(__tracing_swap_reader),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
new file mode 100644
index 000000000000..282cba70ce9b
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <nvhe/clock.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+#include <nvhe/trace.h>
+
+#include <asm/percpu.h>
+#include <asm/kvm_mmu.h>
+#include <asm/local.h>
+
+#include "simple_ring_buffer.c"
+
+static DEFINE_PER_CPU(struct simple_rb_per_cpu, __simple_rbs);
+
+static struct hyp_trace_buffer {
+	struct simple_rb_per_cpu __percpu	*simple_rbs;
+	void					*bpages_backing_start;
+	size_t					bpages_backing_size;
+	hyp_spinlock_t				lock;
+} trace_buffer = {
+	.simple_rbs = &__simple_rbs,
+	.lock = __HYP_SPIN_LOCK_UNLOCKED,
+};
+
+static bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *trace_buffer)
+{
+	return trace_buffer->bpages_backing_size > 0;
+}
+
+void *tracing_reserve_entry(unsigned long length)
+{
+	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), length,
+					  trace_clock());
+}
+
+void tracing_commit_entry(void)
+{
+	simple_ring_buffer_commit(this_cpu_ptr(trace_buffer.simple_rbs));
+}
+
+static int __admit_host_mem(void *start, u64 size)
+{
+	if (!PAGE_ALIGNED(start) || !PAGE_ALIGNED(size) || !size)
+		return -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	return __pkvm_host_donate_hyp(hyp_virt_to_pfn(start), size >> PAGE_SHIFT);
+}
+
+static void __release_host_mem(void *start, u64 size)
+{
+	if (!is_protected_kvm_enabled())
+		return;
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(start), size >> PAGE_SHIFT));
+}
+
+static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *trace_buffer,
+					       struct hyp_trace_desc *desc)
+{
+	void *start = (void *)kern_hyp_va(desc->bpages_backing_start);
+	size_t size = desc->bpages_backing_size;
+	int ret;
+
+	ret = __admit_host_mem(start, size);
+	if (ret)
+		return ret;
+
+	memset(start, 0, size);
+
+	trace_buffer->bpages_backing_start = start;
+	trace_buffer->bpages_backing_size = size;
+
+	return 0;
+}
+
+static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace_buffer)
+{
+	void *start = trace_buffer->bpages_backing_start;
+	size_t size = trace_buffer->bpages_backing_size;
+
+	if (!size)
+		return;
+
+	memset(start, 0, size);
+
+	__release_host_mem(start, size);
+
+	trace_buffer->bpages_backing_start = 0;
+	trace_buffer->bpages_backing_size = 0;
+}
+
+static void *__pin_shared_page(unsigned long kern_va)
+{
+	void *va = kern_hyp_va((void *)kern_va);
+
+	if (!is_protected_kvm_enabled())
+		return va;
+
+	return hyp_pin_shared_mem(va, va + PAGE_SIZE) ? NULL : va;
+}
+
+static void __unpin_shared_page(void *va)
+{
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_unpin_shared_mem(va, va + PAGE_SIZE);
+}
+
+static void hyp_trace_buffer_unload(struct hyp_trace_buffer *trace_buffer)
+{
+	int cpu;
+
+	hyp_assert_lock_held(&trace_buffer->lock);
+
+	if (!hyp_trace_buffer_loaded(trace_buffer))
+		return;
+
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
+		simple_ring_buffer_unload_mm(per_cpu_ptr(trace_buffer->simple_rbs, cpu),
+					     __unpin_shared_page);
+
+	hyp_trace_buffer_unload_bpage_backing(trace_buffer);
+}
+
+static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
+				 struct hyp_trace_desc *desc)
+{
+	struct simple_buffer_page *bpages;
+	struct ring_buffer_desc *rb_desc;
+	int ret, cpu;
+
+	hyp_assert_lock_held(&trace_buffer->lock);
+
+	if (hyp_trace_buffer_loaded(trace_buffer))
+		return -EINVAL;
+
+	ret = hyp_trace_buffer_load_bpage_backing(trace_buffer, desc);
+	if (ret)
+		return ret;
+
+	bpages = trace_buffer->bpages_backing_start;
+	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
+		ret = simple_ring_buffer_init_mm(per_cpu_ptr(trace_buffer->simple_rbs, cpu),
+						 bpages, rb_desc, __pin_shared_page,
+						__unpin_shared_page);
+		if (ret)
+			break;
+
+		bpages += rb_desc->nr_page_va;
+	}
+
+	if (ret)
+		hyp_trace_buffer_unload(trace_buffer);
+
+	return ret;
+}
+
+static bool hyp_trace_desc_validate(struct hyp_trace_desc *desc, size_t desc_size)
+{
+	struct ring_buffer_desc *rb_desc;
+	unsigned int cpu;
+	size_t nr_bpages;
+	void *desc_end;
+
+	/*
+	 * Both desc_size and bpages_backing_size are untrusted host-provided
+	 * values. We rely on __pkvm_host_donate_hyp() to enforce their validity.
+	 */
+	desc_end = (void *)desc + desc_size;
+	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
+
+	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
+		/* Can we read nr_page_va? */
+		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
+			return false;
+
+		/* Overflow desc? */
+		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
+			return false;
+
+		/* Overflow bpages backing memory? */
+		if (nr_bpages < rb_desc->nr_page_va)
+			return false;
+
+		if (cpu >= hyp_nr_cpus)
+			return false;
+
+		if (cpu != rb_desc->cpu)
+			return false;
+
+		nr_bpages -= rb_desc->nr_page_va;
+	}
+
+	return true;
+}
+
+int __tracing_load(unsigned long desc_hva, size_t desc_size)
+{
+	struct hyp_trace_desc *desc = (struct hyp_trace_desc *)kern_hyp_va(desc_hva);
+	int ret;
+
+	ret = __admit_host_mem(desc, desc_size);
+	if (ret)
+		return ret;
+
+	if (!hyp_trace_desc_validate(desc, desc_size))
+		goto err_release_desc;
+
+	hyp_spin_lock(&trace_buffer.lock);
+
+	ret = hyp_trace_buffer_load(&trace_buffer, desc);
+
+	hyp_spin_unlock(&trace_buffer.lock);
+
+err_release_desc:
+	__release_host_mem(desc, desc_size);
+	return ret;
+}
+
+void __tracing_unload(void)
+{
+	hyp_spin_lock(&trace_buffer.lock);
+	hyp_trace_buffer_unload(&trace_buffer);
+	hyp_spin_unlock(&trace_buffer.lock);
+}
+
+int __tracing_enable(bool enable)
+{
+	int cpu, ret = enable ? -EINVAL : 0;
+
+	hyp_spin_lock(&trace_buffer.lock);
+
+	if (!hyp_trace_buffer_loaded(&trace_buffer))
+		goto unlock;
+
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
+		simple_ring_buffer_enable_tracing(per_cpu_ptr(trace_buffer.simple_rbs, cpu),
+						  enable);
+
+	ret = 0;
+
+unlock:
+	hyp_spin_unlock(&trace_buffer.lock);
+
+	return ret;
+}
+
+int __tracing_swap_reader(unsigned int cpu)
+{
+	int ret = -ENODEV;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_buffer.lock);
+
+	if (hyp_trace_buffer_loaded(&trace_buffer))
+		ret = simple_ring_buffer_swap_reader_page(
+				per_cpu_ptr(trace_buffer.simple_rbs, cpu));
+
+	hyp_spin_unlock(&trace_buffer.lock);
+
+	return ret;
+}
-- 
2.53.0.rc1.225.gd81095ad13-goog

