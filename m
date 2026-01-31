Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6835C185
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866188; cv=none; b=AakV7Yzg3JE23sS1YxX/OqdOeSgCCi/y8UUAG4pA16yyma8J9oYkGer+ohdRoBUWYClnQISbqavGEvpwZvOrPvu4VrWmUtP16yybMokZqP3B7YQDLeBCzg6no9fGt65yg6SAyBnNfS3QkP/JAjRFKWfJ4viDoxxpCgAsvxESaqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866188; c=relaxed/simple;
	bh=5vbS5B+SSGp40e87Wx7aIvzuzpCX46BiZAhM0ki1lN0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RMZRQ8xhnE6RNNGpIByv73B/a4FylQhFLYRXhTXmxeMuiQEi9lHQzQB+zLWRbc7jqWwwpgHn7gtnWhNOFhsEsfi111G7LU4hf0drPf0LgXa4nQE3n48FRPcLUJPc2SzOzZwGteMdUQQkmKn20RqCDOU/satBbn1SErEdisxuBos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyUBO+Y1; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyUBO+Y1"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64d251b8c5dso2994309a12.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866184; x=1770470984; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vy1oYHc7CtN0iAjwxhYsnDem9gNnyq1Os5+rmoahwrA=;
        b=MyUBO+Y1NJ8KHv/GPCWmuDX5FfPcS+t0OHktPxjMWEy8mYaCpRS5Yvz1c5n16SI3dQ
         2GbBhD2jPG9an93DKROti4tWYAQKGoKGPtACwCRabeDkdaH1Q0Ve8u85et/JySy7aHYp
         ZCOVvizVjpZ0hZGjQvlvjwMRIwGPo8RnA9R6khgBUjcDkVrL8Bc4TuTG21dtyqX1PB9T
         FV0uXcmGeOq2R0GPFJscebW7X+wm2qXS4xqrnJBFadI1aTY3N/dyPtYAOZ3KS4S/0mMG
         g83HIbIGUxwPhzZisT//HvQwGTHn2gMYZv6gq4PdluRM3/e04f/7phrUFkgz3E+XLJ4D
         5t0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866184; x=1770470984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vy1oYHc7CtN0iAjwxhYsnDem9gNnyq1Os5+rmoahwrA=;
        b=Z5uvuYTPYYGq8LC7yBQSidSYdnvrF7U2ZctIeeKBBZW8yhQ+EzQMhzNx6cFmZ39II+
         KZ2nqo1XqxIpVBCfUGQWTp4a7av7hpWuJj3nn7fp2xLT1w3yBLJVNXFlHIkadseNsG8R
         ooincjqvoDhfFpV83lJoFmpNBNCp95HckqysTkEZFT8wYeDI251E7ZEx0F44xNHyEghM
         eXgWitU8zmMYzMgoPS38r2mR3ZDWMhBM+qzNd8eTTsxVpulepljHosxYXjtNeSsc3ipV
         UmegYEpGohbpufNL3d5fauVG2QbaxX4gebiGBmG/40myBszMOTp/SIYHhSjpbhal3DWV
         DKUw==
X-Gm-Message-State: AOJu0YxtVgWghmV7BNTObhsdjyGlxsJ3h0xUBByWKzIX2eQdvyHRf2F5
	h0VPbSkB3RN924goZe3Lu69GXTjOBln6EzHvSbB1SjompddkuI5HzmzOEV4fSrPfRAiFWD5ljWK
	KkC1GBTyg8fu2nMdidVCPNA==
X-Received: from edqd7.prod.google.com ([2002:a50:fb07:0:b0:655:47ed:274d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:27cd:b0:658:b46c:ef7f with SMTP id 4fb4d7f45d1cf-658de55896fmr3610330a12.8.1769866184185;
 Sat, 31 Jan 2026 05:29:44 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:42 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-25-vdonnefort@google.com>
Subject: [PATCH v11 24/30] KVM: arm64: Add trace remote for the nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In both protected and nVHE mode, the hypervisor is capable of writing
events into tracefs compatible ring-buffers. Create a trace remote so
the kernel can read those buffers.

This currently doesn't provide any event support which will come later.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index c7f50492f2cf..aad0228f24db 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -76,6 +76,7 @@ if NVHE_EL2_DEBUG
 config NVHE_EL2_TRACING
 	bool
 	depends on TRACING
+	select TRACE_REMOTE
 	default y
 
 config PKVM_DISABLE_STAGE2_ON_PANIC
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3ebc0570345c..59612d2f277c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -30,6 +30,8 @@ kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
+kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index be1fd6c5f74c..f7f222ecaf88 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -24,6 +24,7 @@
 
 #define CREATE_TRACE_POINTS
 #include "trace_arm.h"
+#include "hyp_trace.h"
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
@@ -2361,6 +2362,10 @@ static int __init init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	err = kvm_hyp_trace_init();
+	if (err)
+		kvm_err("Failed to initialize Hyp tracing\n");
+
 out:
 	if (err)
 		hyp_cpu_pm_exit();
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
new file mode 100644
index 000000000000..2866effe28ec
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/trace_remote.h>
+#include <linux/simple_ring_buffer.h>
+
+#include <asm/kvm_host.h>
+#include <asm/kvm_hyptrace.h>
+#include <asm/kvm_mmu.h>
+
+#include "hyp_trace.h"
+
+/* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */
+static struct hyp_trace_buffer {
+	struct hyp_trace_desc	*desc;
+	size_t			desc_size;
+} trace_buffer;
+
+static int __map_hyp(void *start, size_t size)
+{
+	if (is_protected_kvm_enabled())
+		return 0;
+
+	return create_hyp_mappings(start, start + size, PAGE_HYP);
+}
+
+static int __share_page(unsigned long va)
+{
+	return kvm_share_hyp((void *)va, (void *)va + 1);
+}
+
+static void __unshare_page(unsigned long va)
+{
+	kvm_unshare_hyp((void *)va, (void *)va + 1);
+}
+
+static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
+{
+	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
+	size_t backing_size;
+	void *start;
+
+	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
+				  num_possible_cpus());
+
+	start = alloc_pages_exact(backing_size, GFP_KERNEL_ACCOUNT);
+	if (!start)
+		return -ENOMEM;
+
+	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
+	trace_buffer->desc->bpages_backing_size = backing_size;
+
+	return __map_hyp(start, backing_size);
+}
+
+static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
+{
+	free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
+			 trace_buffer->desc->bpages_backing_size);
+}
+
+static void hyp_trace_buffer_unshare_hyp(struct hyp_trace_buffer *trace_buffer, int last_cpu)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu, p;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, &trace_buffer->desc->trace_buffer_desc) {
+		if (cpu > last_cpu)
+			break;
+
+		__share_page(rb_desc->meta_va);
+		for (p = 0; p < rb_desc->nr_page_va; p++)
+			__unshare_page(rb_desc->page_va[p]);
+	}
+}
+
+static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu, p, ret = 0;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, &trace_buffer->desc->trace_buffer_desc) {
+		ret = __share_page(rb_desc->meta_va);
+		if (ret)
+			break;
+
+		for (p = 0; p < rb_desc->nr_page_va; p++) {
+			ret = __share_page(rb_desc->page_va[p]);
+			if (ret)
+				break;
+		}
+
+		if (ret) {
+			for (p--; p >= 0; p--)
+				__unshare_page(rb_desc->page_va[p]);
+			break;
+		}
+	}
+
+	if (ret)
+		hyp_trace_buffer_unshare_hyp(trace_buffer, cpu--);
+
+	return ret;
+}
+
+static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
+{
+	struct hyp_trace_buffer *trace_buffer = priv;
+	struct hyp_trace_desc *desc;
+	size_t desc_size;
+	int ret;
+
+	if (WARN_ON(trace_buffer->desc))
+		return ERR_PTR(-EINVAL);
+
+	desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	if (desc_size == SIZE_MAX)
+		return ERR_PTR(-E2BIG);
+
+	desc_size = PAGE_ALIGN(desc_size);
+	desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __map_hyp(desc, desc_size);
+	if (ret)
+		goto err_free_desc;
+
+	trace_buffer->desc = desc;
+
+	ret = hyp_trace_buffer_alloc_bpages_backing(trace_buffer, size);
+	if (ret)
+		goto err_free_desc;
+
+	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
+					cpu_possible_mask);
+	if (ret)
+		goto err_free_backing;
+
+	ret = hyp_trace_buffer_share_hyp(trace_buffer);
+	if (ret)
+		goto err_free_buffer;
+
+	ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
+	if (ret)
+		goto err_unload_pages;
+
+	return &desc->trace_buffer_desc;
+
+err_unload_pages:
+	hyp_trace_buffer_unshare_hyp(trace_buffer, INT_MAX);
+
+err_free_buffer:
+	trace_remote_free_buffer(&desc->trace_buffer_desc);
+
+err_free_backing:
+	hyp_trace_buffer_free_bpages_backing(trace_buffer);
+
+err_free_desc:
+	free_pages_exact(desc, desc_size);
+	trace_buffer->desc = NULL;
+
+	return ERR_PTR(ret);
+}
+
+static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
+{
+	struct hyp_trace_buffer *trace_buffer = priv;
+
+	if (WARN_ON(desc != &trace_buffer->desc->trace_buffer_desc))
+		return;
+
+	kvm_call_hyp_nvhe(__tracing_unload);
+	hyp_trace_buffer_unshare_hyp(trace_buffer, INT_MAX);
+	trace_remote_free_buffer(desc);
+	hyp_trace_buffer_free_bpages_backing(trace_buffer);
+	free_pages_exact(trace_buffer->desc, trace_buffer->desc_size);
+	trace_buffer->desc = NULL;
+}
+
+static int hyp_trace_enable_tracing(bool enable, void *priv)
+{
+	return kvm_call_hyp_nvhe(__tracing_enable, enable);
+}
+
+static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
+{
+	return kvm_call_hyp_nvhe(__tracing_swap_reader, cpu);
+}
+
+static int hyp_trace_reset(unsigned int cpu, void *priv)
+{
+	return 0;
+}
+
+static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
+{
+	return 0;
+}
+
+static struct trace_remote_callbacks trace_remote_callbacks = {
+	.load_trace_buffer	= hyp_trace_load,
+	.unload_trace_buffer	= hyp_trace_unload,
+	.enable_tracing		= hyp_trace_enable_tracing,
+	.swap_reader_page	= hyp_trace_swap_reader_page,
+	.reset			= hyp_trace_reset,
+	.enable_event		= hyp_trace_enable_event,
+};
+
+int __init kvm_hyp_trace_init(void)
+{
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
+	return trace_remote_register("hypervisor", &trace_remote_callbacks, &trace_buffer, NULL, 0);
+}
diff --git a/arch/arm64/kvm/hyp_trace.h b/arch/arm64/kvm/hyp_trace.h
new file mode 100644
index 000000000000..c991b1ec65f1
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ARM64_KVM_HYP_TRACE_H__
+#define __ARM64_KVM_HYP_TRACE_H__
+
+#ifdef CONFIG_NVHE_EL2_TRACING
+int kvm_hyp_trace_init(void);
+#else
+static inline int kvm_hyp_trace_init(void) { return 0; }
+#endif
+#endif
-- 
2.53.0.rc1.225.gd81095ad13-goog

