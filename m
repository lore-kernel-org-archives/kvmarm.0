Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2471FBCAD
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336780; cv=none; b=OLcbKGThT6RUE7dELiE0RdUWWndtRkIfSHBfG6/3mnnQig2lwG5IULijTocZGvWaPtI3VaiHr4FrFhial1TBY7CManlT89qLaUFp38K97zmTyGltxNfP18GHI7cPhM2yDcxuFeSF5Y+Rw503BEVP81slIzfodpTWuaI6IVq55tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336780; c=relaxed/simple;
	bh=VygSxm/VrUGJnlaFXWBMoYbnd8xqCEVuHrmhrL+Eehc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AAD+1l+wGrhROFG2NDw7EGqNTXnKcwKMxXt1wgHJgmG2tC/cN+TFjD7ObP3995gkgqV/ojfAxiwGZ8HxZuVSZJ6H5GtAZH2uZ+zCR7HI55t7Eh5okR6qWKHCxjBY38OI5KIe2e6cdmyFNrb7jR28/YS4w4hbeK3jgyDB8k402H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAuov0EN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAuov0EN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43673af80a6so110664555e9.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 03:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736336776; x=1736941576; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mo1fCNpC+G+L/mBG+Ln2f4lhH5T+uHk1pbXwrgVS5IU=;
        b=UAuov0ENpJXeUxI4ZBqvioFm5Oq6v0jEit1p0Qpk+kC7conwnzVHQ5ngvmFKy209rx
         Cos0DV6u3H2bkRjRzDtOlZQimaCaP7co4OQXABkWDG0RGLCxKYxsHHS7FWIaew+m+cFk
         q8Loh7KYj8kGAMcbVBViFO0tsk/ZaC5FjfAPxmXm/2S0oN0zcThuR0tOP4LpxJFq+N1y
         rP/hHHxzoBdsg1Xfyc8noS+n7fe6YbRYtYOpa4GNCa5Ph7jza3t2KhoSV3Lk0nwaGPjf
         ZJIzW3wxYqlbe2SlP9kcEMm/crkJxiqf2eGXa9VLOZJp2FEx0UmrYmGQbXummLgKPH0p
         g7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336776; x=1736941576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mo1fCNpC+G+L/mBG+Ln2f4lhH5T+uHk1pbXwrgVS5IU=;
        b=pVBID835TnwaXcm5QLGSjZCPrZiz/aE3VJYn0qBdYJ34wu3V3smsfVx4XFyXSNtmQC
         ryZJrpIa2CYbSh4eWAWqSXZg/dijA9e8XiJ/+p/jC53EmpHgU4W0N0Kun5rMWzhYuMw4
         npicg47d4U3gpMNP8o+JeZ4t2HP6d+zOw4GWTZAEKCeW5BvKRQHz7VCNGyVFotbX4scw
         raLYLd/O9n2gIhYdDBUW66vZpgyetS2GAGCp12hreijOYOfiw1jBA0qI9+NmbsF3FuvU
         SkffEXDErpxmuwmlEMslVEsHiHkNYnraR/HadachMj0O7MgJf7bUnAvaZ591IJvE5pAw
         cEog==
X-Gm-Message-State: AOJu0YyCLYNulyiH6325tzHUBxnfxNBdx7VYoedgxTGWAiS+D6uZ0BaZ
	R1+yI0S1da2GkcAElKmOdAZMF1F5+H4gpAH1cERGQOTHS7vgbq1gwrOjzYUakg319lbkQPrJwLu
	hPtPeP4ySSB6Ax/4YXQ==
X-Google-Smtp-Source: AGHT+IEdiRjvYXc2J1asWc7gks9+UHtlwoN0N1NLn1tKc+ze9fmKR2CCb/y7RWIXdNqBH0lwPI+MBA1VbMTOcLqp
X-Received: from wmbfk10.prod.google.com ([2002:a05:600c:cca:b0:436:6fa7:621])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6c0b:b0:434:ff25:199f with SMTP id 5b1f17b1804b1-436e2707f07mr17319125e9.26.1736336776045;
 Wed, 08 Jan 2025 03:46:16 -0800 (PST)
Date: Wed,  8 Jan 2025 11:45:31 +0000
In-Reply-To: <20250108114536.627715-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250108114536.627715-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250108114536.627715-8-vdonnefort@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: Add hyp tracing to tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When running with KVM protected mode, the hypervisor is able to generate
events into tracefs compatible ring-buffers. Plug those ring-buffers to
tracefs. The interface is found in hyp/ and contains the same hierarchy
as any host instances easing the support by existing user-space tools.

This currently doesn't provide any event support which will come later.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b503..865971bb8905 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,6 +29,8 @@ kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
+kvm-$(CONFIG_TRACING) += hyp_trace.o
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..cef933eb1cd4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -25,6 +25,7 @@
 
 #define CREATE_TRACE_POINTS
 #include "trace_arm.h"
+#include "hyp_trace.h"
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
@@ -2316,6 +2317,9 @@ static int __init init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	err = hyp_trace_init_tracefs();
+	if (err)
+		kvm_err("Failed to initialize Hyp tracing\n");
 out:
 	if (err)
 		hyp_cpu_pm_exit();
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b257a3b4bfc5..5c4a797a701f 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -3,11 +3,15 @@
 #include <linux/kbuild.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/trace.h>
 
 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
 	DEFINE(PKVM_HYP_VM_SIZE,	sizeof(struct pkvm_hyp_vm));
 	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
+#ifdef CONFIG_TRACING
+	DEFINE(STRUCT_HYP_BUFFER_PAGE_SIZE,	sizeof(struct hyp_buffer_page));
+#endif
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
new file mode 100644
index 000000000000..be5bc602abc4
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -0,0 +1,663 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/percpu-defs.h>
+#include <linux/tracefs.h>
+
+#include <asm/kvm_host.h>
+#include <asm/kvm_hyptrace.h>
+
+#include "hyp_constants.h"
+#include "hyp_trace.h"
+
+#define RB_POLL_MS 100
+
+#define TRACEFS_DIR "hypervisor"
+#define TRACEFS_MODE_WRITE 0640
+#define TRACEFS_MODE_READ 0440
+
+static struct hyp_trace_buffer {
+	struct hyp_trace_desc		*desc;
+	struct ring_buffer_remote	remote;
+	struct trace_buffer		*trace_buffer;
+	size_t				desc_size;
+	bool				tracing_on;
+	int				nr_readers;
+	struct mutex			lock;
+} hyp_trace_buffer = {
+	.lock		= __MUTEX_INITIALIZER(hyp_trace_buffer.lock),
+};
+
+static size_t hyp_trace_buffer_size = 7 << 10;
+
+/* Number of pages the ring-buffer requires to accommodate for size */
+#define NR_PAGES(size) \
+	((PAGE_ALIGN(size) >> PAGE_SHIFT) + 1)
+
+static inline bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *hyp_buffer)
+{
+	return !!hyp_buffer->trace_buffer;
+}
+
+static inline bool hyp_trace_buffer_used(struct hyp_trace_buffer *hyp_buffer)
+{
+	return hyp_buffer->nr_readers || hyp_buffer->tracing_on ||
+		!ring_buffer_empty(hyp_buffer->trace_buffer);
+}
+
+static int
+bpage_backing_alloc(struct hyp_buffer_pages_backing *bpage_backing, size_t size)
+{
+	size_t backing_size;
+	void *start;
+
+	backing_size = PAGE_ALIGN(STRUCT_HYP_BUFFER_PAGE_SIZE * NR_PAGES(size) *
+				  num_possible_cpus());
+
+	start = alloc_pages_exact(backing_size, GFP_KERNEL_ACCOUNT);
+	if (!start)
+		return -ENOMEM;
+
+	bpage_backing->start = (unsigned long)start;
+	bpage_backing->size = backing_size;
+
+	return 0;
+}
+
+static void
+bpage_backing_free(struct hyp_buffer_pages_backing *bpage_backing)
+{
+	free_pages_exact((void *)bpage_backing->start, bpage_backing->size);
+}
+
+static int __get_reader_page(int cpu)
+{
+	return kvm_call_hyp_nvhe(__pkvm_swap_reader_tracing, cpu);
+}
+
+static void hyp_trace_free_pages(struct hyp_trace_desc *desc)
+{
+	struct rb_page_desc *rb_desc;
+	int cpu, id;
+
+	for_each_rb_page_desc(rb_desc, cpu, &desc->page_desc) {
+		free_page(rb_desc->meta_va);
+		for (id = 0; id < rb_desc->nr_page_va; id++)
+			free_page(rb_desc->page_va[id]);
+	}
+}
+
+static int hyp_trace_alloc_pages(struct hyp_trace_desc *desc, size_t size)
+{
+	int err = 0, cpu, id, nr_pages = NR_PAGES(size);
+	struct trace_page_desc *trace_desc;
+	struct rb_page_desc *rb_desc;
+
+	trace_desc = &desc->page_desc;
+	trace_desc->nr_cpus = 0;
+
+	rb_desc = (struct rb_page_desc *)&trace_desc->__data[0];
+
+	for_each_possible_cpu(cpu) {
+		rb_desc->cpu = cpu;
+		rb_desc->nr_page_va = 0;
+		rb_desc->meta_va = (unsigned long)page_to_virt(alloc_page(GFP_KERNEL));
+		if (!rb_desc->meta_va) {
+			err = -ENOMEM;
+			break;
+		}
+		for (id = 0; id < nr_pages; id++) {
+			rb_desc->page_va[id] = (unsigned long)page_to_virt(alloc_page(GFP_KERNEL));
+			if (!rb_desc->page_va[id]) {
+				err = -ENOMEM;
+				break;
+			}
+			rb_desc->nr_page_va++;
+		}
+		trace_desc->nr_cpus++;
+		rb_desc = __next_rb_page_desc(rb_desc);
+	}
+
+	if (err) {
+		hyp_trace_free_pages(desc);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __load_page(unsigned long va)
+{
+	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, virt_to_pfn((void *)va), 1);
+}
+
+static void __teardown_page(unsigned long va)
+{
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, virt_to_pfn((void *)va), 1));
+}
+
+static void hyp_trace_teardown_pages(struct hyp_trace_desc *desc,
+				     int last_cpu)
+{
+	struct rb_page_desc *rb_desc;
+	int cpu, id;
+
+	for_each_rb_page_desc(rb_desc, cpu, &desc->page_desc) {
+		if (cpu > last_cpu)
+			break;
+		__teardown_page(rb_desc->meta_va);
+		for (id = 0; id < rb_desc->nr_page_va; id++)
+			__teardown_page(rb_desc->page_va[id]);
+	}
+}
+
+static int hyp_trace_load_pages(struct hyp_trace_desc *desc)
+{
+	int last_loaded_cpu = 0, cpu, id, err = -EINVAL;
+	struct rb_page_desc *rb_desc;
+
+	for_each_rb_page_desc(rb_desc, cpu, &desc->page_desc) {
+		err = __load_page(rb_desc->meta_va);
+		if (err)
+			break;
+
+		for (id = 0; id < rb_desc->nr_page_va; id++) {
+			err = __load_page(rb_desc->page_va[id]);
+			if (err)
+				break;
+		}
+
+		if (!err)
+			continue;
+
+		for (id--; id >= 0; id--)
+			__teardown_page(rb_desc->page_va[id]);
+
+		last_loaded_cpu = cpu - 1;
+
+		break;
+	}
+
+	if (!err)
+		return 0;
+
+	hyp_trace_teardown_pages(desc, last_loaded_cpu);
+
+	return err;
+}
+
+static int hyp_trace_buffer_load(struct hyp_trace_buffer *hyp_buffer, size_t size)
+{
+	int ret, nr_pages = NR_PAGES(size);
+	struct rb_page_desc *rbdesc;
+	struct hyp_trace_desc *desc;
+	size_t desc_size;
+
+	if (hyp_trace_buffer_loaded(hyp_buffer))
+		return 0;
+
+	desc_size = size_add(offsetof(struct hyp_trace_desc, page_desc),
+			     offsetof(struct trace_page_desc, __data));
+	desc_size = size_add(desc_size,
+			     size_mul(num_possible_cpus(),
+				      struct_size(rbdesc, page_va, nr_pages)));
+	if (desc_size == SIZE_MAX)
+		return -E2BIG;
+
+	/*
+	 * The hypervisor will unmap the descriptor from the host to protect the
+	 * reading. Page granularity for the allocation ensures no other
+	 * useful data will be unmapped.
+	 */
+	desc_size = PAGE_ALIGN(desc_size);
+
+	desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	ret = hyp_trace_alloc_pages(desc, size);
+	if (ret)
+		goto err_free_desc;
+
+	ret = bpage_backing_alloc(&desc->backing, size);
+	if (ret)
+		goto err_free_pages;
+
+	ret = hyp_trace_load_pages(desc);
+	if (ret)
+		goto err_free_backing;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_load_tracing, (unsigned long)desc, desc_size);
+	if (ret)
+		goto err_teardown_pages;
+
+	hyp_buffer->remote.pdesc = &desc->page_desc;
+	hyp_buffer->remote.get_reader_page = __get_reader_page;
+	hyp_buffer->trace_buffer = ring_buffer_remote(&hyp_buffer->remote);
+	if (!hyp_buffer->trace_buffer) {
+		ret = -ENOMEM;
+		goto err_teardown_tracing;
+	}
+
+	hyp_buffer->desc = desc;
+	hyp_buffer->desc_size = desc_size;
+
+	return 0;
+
+err_teardown_tracing:
+	kvm_call_hyp_nvhe(__pkvm_teardown_tracing);
+err_teardown_pages:
+	hyp_trace_teardown_pages(desc, INT_MAX);
+err_free_backing:
+	bpage_backing_free(&desc->backing);
+err_free_pages:
+	hyp_trace_free_pages(desc);
+err_free_desc:
+	free_pages_exact(desc, desc_size);
+
+	return ret;
+}
+
+static void hyp_trace_buffer_teardown(struct hyp_trace_buffer *hyp_buffer)
+{
+	struct hyp_trace_desc *desc = hyp_buffer->desc;
+	size_t desc_size = hyp_buffer->desc_size;
+
+	if (!hyp_trace_buffer_loaded(hyp_buffer))
+		return;
+
+	if (hyp_trace_buffer_used(hyp_buffer))
+		return;
+
+	if (kvm_call_hyp_nvhe(__pkvm_teardown_tracing))
+		return;
+
+	ring_buffer_free(hyp_buffer->trace_buffer);
+	hyp_trace_teardown_pages(desc, INT_MAX);
+	bpage_backing_free(&desc->backing);
+	hyp_trace_free_pages(desc);
+	free_pages_exact(desc, desc_size);
+	hyp_buffer->trace_buffer = NULL;
+}
+
+static int hyp_trace_start(void)
+{
+	struct hyp_trace_buffer *hyp_buffer = &hyp_trace_buffer;
+	int ret = 0;
+
+	mutex_lock(&hyp_buffer->lock);
+
+	if (hyp_buffer->tracing_on)
+		goto out;
+
+	ret = hyp_trace_buffer_load(hyp_buffer, hyp_trace_buffer_size);
+	if (ret)
+		goto out;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_enable_tracing, true);
+	if (ret) {
+		hyp_trace_buffer_teardown(hyp_buffer);
+		goto out;
+	}
+
+	hyp_buffer->tracing_on = true;
+
+out:
+	mutex_unlock(&hyp_buffer->lock);
+
+	return ret;
+}
+
+static void hyp_trace_stop(void)
+{
+	struct hyp_trace_buffer *hyp_buffer = &hyp_trace_buffer;
+	int ret;
+
+	mutex_lock(&hyp_buffer->lock);
+
+	if (!hyp_buffer->tracing_on)
+		goto end;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_enable_tracing, false);
+	if (!ret) {
+		ring_buffer_poll_remote(hyp_buffer->trace_buffer,
+					RING_BUFFER_ALL_CPUS);
+		hyp_buffer->tracing_on = false;
+		hyp_trace_buffer_teardown(hyp_buffer);
+	}
+
+end:
+	mutex_unlock(&hyp_buffer->lock);
+}
+
+static ssize_t hyp_tracing_on(struct file *filp, const char __user *ubuf,
+			      size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val)
+		ret = hyp_trace_start();
+	else
+		hyp_trace_stop();
+
+	return ret ? ret : cnt;
+}
+
+static ssize_t hyp_tracing_on_read(struct file *filp, char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[3];
+	int r;
+
+	mutex_lock(&hyp_trace_buffer.lock);
+	r = sprintf(buf, "%d\n", hyp_trace_buffer.tracing_on);
+	mutex_unlock(&hyp_trace_buffer.lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static const struct file_operations hyp_tracing_on_fops = {
+	.write	= hyp_tracing_on,
+	.read	= hyp_tracing_on_read,
+};
+
+static ssize_t hyp_buffer_size(struct file *filp, const char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	if (!val)
+		return -EINVAL;
+
+	mutex_lock(&hyp_trace_buffer.lock);
+	hyp_trace_buffer_size = val << 10; /* KB to B */
+	mutex_unlock(&hyp_trace_buffer.lock);
+
+	return cnt;
+}
+
+static ssize_t hyp_buffer_size_read(struct file *filp, char __user *ubuf,
+				    size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	mutex_lock(&hyp_trace_buffer.lock);
+	r = sprintf(buf, "%lu (%s)\n", hyp_trace_buffer_size >> 10,
+		    hyp_trace_buffer_loaded(&hyp_trace_buffer) ?
+			"loaded" : "unloaded");
+	mutex_unlock(&hyp_trace_buffer.lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static const struct file_operations hyp_buffer_size_fops = {
+	.write	= hyp_buffer_size,
+	.read	= hyp_buffer_size_read,
+};
+
+static void ht_print_trace_time(struct ht_iterator *iter)
+{
+	unsigned long usecs_rem;
+	u64 ts_ns = iter->ts;
+
+	do_div(ts_ns, 1000);
+	usecs_rem = do_div(ts_ns, USEC_PER_SEC);
+
+	trace_seq_printf(&iter->seq, "%5lu.%06lu: ",
+			 (unsigned long)ts_ns, usecs_rem);
+}
+
+static void ht_print_trace_cpu(struct ht_iterator *iter)
+{
+	trace_seq_printf(&iter->seq, "[%03d]\t", iter->ent_cpu);
+}
+
+static int ht_print_trace_fmt(struct ht_iterator *iter)
+{
+	if (iter->lost_events)
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->ent_cpu, iter->lost_events);
+
+	ht_print_trace_cpu(iter);
+	ht_print_trace_time(iter);
+
+	return trace_seq_has_overflowed(&iter->seq) ? -EOVERFLOW : 0;
+};
+
+static struct ring_buffer_event *__ht_next_pipe_event(struct ht_iterator *iter)
+{
+	struct ring_buffer_event *evt = NULL;
+	int cpu = iter->cpu;
+
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		if (ring_buffer_empty_cpu(iter->trace_buffer, cpu))
+			return NULL;
+
+		iter->ent_cpu = cpu;
+
+		return ring_buffer_peek(iter->trace_buffer, cpu, &iter->ts,
+					&iter->lost_events);
+	}
+
+	iter->ts = LLONG_MAX;
+	for_each_possible_cpu(cpu) {
+		struct ring_buffer_event *_evt;
+		unsigned long lost_events;
+		u64 ts;
+
+		if (ring_buffer_empty_cpu(iter->trace_buffer, cpu))
+			continue;
+
+		_evt = ring_buffer_peek(iter->trace_buffer, cpu, &ts,
+					&lost_events);
+		if (!_evt)
+			continue;
+
+		if (ts >= iter->ts)
+			continue;
+
+		iter->ts = ts;
+		iter->ent_cpu = cpu;
+		iter->lost_events = lost_events;
+		evt = _evt;
+	}
+
+	return evt;
+}
+
+static void *ht_next_pipe_event(struct ht_iterator *iter)
+{
+	struct ring_buffer_event *event;
+
+	event = __ht_next_pipe_event(iter);
+	if (!event)
+		return NULL;
+
+	iter->ent = (struct hyp_entry_hdr *)&event->array[1];
+	iter->ent_size = event->array[0];
+
+	return iter;
+}
+
+static ssize_t
+hyp_trace_pipe_read(struct file *file, char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	struct ht_iterator *iter = (struct ht_iterator *)file->private_data;
+	int ret;
+
+copy_to_user:
+	ret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	if (ret != -EBUSY)
+		return ret;
+
+	trace_seq_init(&iter->seq);
+
+	ret = ring_buffer_wait(iter->trace_buffer, iter->cpu, 0, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	while (ht_next_pipe_event(iter)) {
+		int prev_len = iter->seq.seq.len;
+
+		if (ht_print_trace_fmt(iter)) {
+			iter->seq.seq.len = prev_len;
+			break;
+		}
+
+		ring_buffer_consume(iter->trace_buffer, iter->ent_cpu, NULL,
+				    NULL);
+	}
+
+	goto copy_to_user;
+}
+
+static void __poll_remote(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ht_iterator *iter;
+
+	iter = container_of(dwork, struct ht_iterator, poll_work);
+
+	ring_buffer_poll_remote(iter->trace_buffer, iter->cpu);
+
+	schedule_delayed_work((struct delayed_work *)work,
+			      msecs_to_jiffies(RB_POLL_MS));
+}
+
+static int hyp_trace_pipe_open(struct inode *inode, struct file *file)
+{
+	struct hyp_trace_buffer *hyp_buffer = &hyp_trace_buffer;
+	int cpu = (s64)inode->i_private;
+	struct ht_iterator *iter = NULL;
+	int ret;
+
+	mutex_lock(&hyp_buffer->lock);
+
+	if (hyp_buffer->nr_readers == INT_MAX) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = hyp_trace_buffer_load(hyp_buffer, hyp_trace_buffer_size);
+	if (ret)
+		goto unlock;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	iter->trace_buffer = hyp_buffer->trace_buffer;
+	iter->cpu = cpu;
+	trace_seq_init(&iter->seq);
+	file->private_data = iter;
+
+	ret = ring_buffer_poll_remote(hyp_buffer->trace_buffer, cpu);
+	if (ret)
+		goto unlock;
+
+	INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
+	schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(RB_POLL_MS));
+
+	hyp_buffer->nr_readers++;
+
+unlock:
+	if (ret) {
+		hyp_trace_buffer_teardown(hyp_buffer);
+		kfree(iter);
+	}
+
+	mutex_unlock(&hyp_buffer->lock);
+
+	return ret;
+}
+
+static int hyp_trace_pipe_release(struct inode *inode, struct file *file)
+{
+	struct hyp_trace_buffer *hyp_buffer = &hyp_trace_buffer;
+	struct ht_iterator *iter = file->private_data;
+
+	cancel_delayed_work_sync(&iter->poll_work);
+
+	mutex_lock(&hyp_buffer->lock);
+
+	WARN_ON(--hyp_buffer->nr_readers < 0);
+
+	hyp_trace_buffer_teardown(hyp_buffer);
+
+	mutex_unlock(&hyp_buffer->lock);
+
+	kfree(iter);
+
+	return 0;
+}
+
+static const struct file_operations hyp_trace_pipe_fops = {
+	.open           = hyp_trace_pipe_open,
+	.read           = hyp_trace_pipe_read,
+	.release        = hyp_trace_pipe_release,
+};
+
+int hyp_trace_init_tracefs(void)
+{
+	struct dentry *root, *per_cpu_root;
+	char per_cpu_name[16];
+	long cpu;
+
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	root = tracefs_create_dir(TRACEFS_DIR, NULL);
+	if (!root) {
+		pr_err("Failed to create tracefs "TRACEFS_DIR"/\n");
+		return -ENODEV;
+	}
+
+	tracefs_create_file("tracing_on", TRACEFS_MODE_WRITE, root, NULL,
+			    &hyp_tracing_on_fops);
+
+	tracefs_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, root, NULL,
+			    &hyp_buffer_size_fops);
+
+	tracefs_create_file("trace_pipe", TRACEFS_MODE_WRITE, root,
+			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_pipe_fops);
+
+	per_cpu_root = tracefs_create_dir("per_cpu", root);
+	if (!per_cpu_root) {
+		pr_err("Failed to create tracefs folder "TRACEFS_DIR"/per_cpu/\n");
+		return -ENODEV;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct dentry *per_cpu_dir;
+
+		snprintf(per_cpu_name, sizeof(per_cpu_name), "cpu%ld", cpu);
+		per_cpu_dir = tracefs_create_dir(per_cpu_name, per_cpu_root);
+		if (!per_cpu_dir) {
+			pr_warn("Failed to create tracefs "TRACEFS_DIR"/per_cpu/cpu%ld\n",
+				cpu);
+			continue;
+		}
+
+		tracefs_create_file("trace_pipe", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_pipe_fops);
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp_trace.h b/arch/arm64/kvm/hyp_trace.h
new file mode 100644
index 000000000000..14fc06c625a6
--- /dev/null
+++ b/arch/arm64/kvm/hyp_trace.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ARM64_KVM_HYP_TRACE_H__
+#define __ARM64_KVM_HYP_TRACE_H__
+
+#include <linux/trace_seq.h>
+#include <linux/workqueue.h>
+
+struct ht_iterator {
+	struct trace_buffer	*trace_buffer;
+	int			cpu;
+	struct hyp_entry_hdr	*ent;
+	unsigned long		lost_events;
+	int			ent_cpu;
+	size_t			ent_size;
+	u64			ts;
+	void			*spare;
+	size_t			copy_leftover;
+	struct trace_seq	seq;
+	struct delayed_work	poll_work;
+};
+
+#ifdef CONFIG_TRACING
+int hyp_trace_init_tracefs(void);
+#else
+static inline int hyp_trace_init_tracefs(void) { return 0; }
+#endif
+#endif
-- 
2.47.1.613.gc27f4b7a9f-goog

