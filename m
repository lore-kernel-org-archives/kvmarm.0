Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FD1B87F0
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402858; cv=none; b=UBgDt43l3QODcETPNnBVrX5cClXKC+ym2DaE9fN2LifctjkgVDbvpy1sRbutRqW5MO/ojSjS92jIlBmsCdY7zyrsx7+ru9tTaUUFK9DH4Q7gw2NY0FGFGY17g/gIWaMVEW8XJFnALpLBqHX8nEZPQGOLLWprxvd3AjEQe3VNBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402858; c=relaxed/simple;
	bh=1sRIM4t7jcUhYRyv8CHyqElGa6YyVZh6th4hT5qSx2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gy/BAoJDQ3EhZRsqbWEAuoRJx5bCsnNztvOhXf2pED/hps5WwepbO8OaNGViY94q6amYZ/1w8Lb4gnna76HbRZSnoyJmDAd0h3vWhBKspVPlhY6RTkly2JV2JYqE9d6ESHEghvzfJCF+WhKMuFMgQ/tIF0ZWx9f/Nnc8KGeFpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IdxO0Lr0; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdxO0Lr0"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a35ec8845cso436935f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402854; x=1748007654; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+Nw20DSdTIcZN3o9Ma7p5IjN10AXrHCqcE439vStIw=;
        b=IdxO0Lr0W+WeNqWmVUHJM2Uz1ldeV8+3AUkGL4SuEnDEbU+Kt5B6Zpi2w8Ewr7ZJ9N
         aWm/K6ToOxIEP3CGSxJXDubsQPQWpnnEu1lpjMwrI0S5XG3KUbfmR31fAnNGv1c3R1Z/
         viIWXyocTPJmskqCDgkUV64MFB162j5RpRFlfg2nGfOCOAjc5rTENklVpp2pGnotTZDs
         sXp0DRGbfwsWDkvpItO63rJkk2nUwUc6ULCatoUuWUKp8bAxkpvEJszy1jIcyBAhBPVE
         +5ZEU+v/9Jr/LA9JMIfmzdes/DggA4L1Bmk0Ph56IToZUdFVfXPO1lSm7fUMQdGGsXFc
         sOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402854; x=1748007654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+Nw20DSdTIcZN3o9Ma7p5IjN10AXrHCqcE439vStIw=;
        b=WSLZUjXwD2HiJbLkkpsyhb8KQZaluke+rPhCCAHP7DsmG81GsxIKntsEoR7vqIXArL
         Obb0Dk/E6tYLlNPtz/51Wtd5NsZTcG9k6AY8NfYHsnIyjwfvRZYbLaqx1gnwwcXEJO0Q
         ePGvBTEYSjplod2ILPXXlg1Tg+a+cPa/SUVzavZmLBETbnnyTWoQG8KxIWgl14RUBQmt
         JgqUdH0rsyBlzEBBgEsD5roSMpmCvCknTak85diEzCDGAIDyGsRcQ+tM8tzkEZHxjYm7
         x4vmWaPG0D72HwsozSHe//qSK7Zm/sj0ub/wfM9B6LH011N1si9OAQEYNYiQR9CKWF8W
         ERxg==
X-Gm-Message-State: AOJu0YxqBMqLH7F1A5GfYJz+qSvLd9yrHK7eBX0U5jL0gkuxCG5b5dlY
	p+SmdnPWdTs0OvJA9js2+eiYQx4uWw478YfEMdssAhs9HKsbt6hm24iPoAmaH21RkCRvCtN07Mo
	aVOHK/3FwPa67c3M6PMgRaw==
X-Google-Smtp-Source: AGHT+IEY8NcK/33QK+xFGxnq1iDdAfxxPy+vw5vKcoP9cMSaJcPykdwL2oWEJoNaEcgmJP48c+jVTxE9PTbI5tTB
X-Received: from wrbfr7.prod.google.com ([2002:a05:6000:2a87:b0:3a3:5fa8:1993])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64ee:0:b0:397:5de8:6937 with SMTP id ffacd0b85a97d-3a35c840cfcmr3182274f8f.41.1747402854624;
 Fri, 16 May 2025 06:40:54 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:17 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-12-vdonnefort@google.com>
Subject: [PATCH v5 11/25] tracing: Add a trace remote module for testing
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a module to help testing the tracefs support for trace remotes. This
module:

  * Use simple_ring_buffer to write into a ring-buffer.
  * Declare a single "selftest" event that can be triggered from
    user-space.
  * Register a "test" trace remote.

This is intended to be used by trace remote selftests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 407cb05cc8a0..2e27d9d1799e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1221,4 +1221,12 @@ config TRACE_REMOTE
 config SIMPLE_RING_BUFFER
 	bool
 
+config TRACE_REMOTE_TEST
+	tristate "Test module for remote tracing"
+	select TRACE_REMOTE
+	select SIMPLE_RING_BUFFER
+	help
+	  This trace remote includes a ring-buffer writer implementation using
+	  "simple_ring_buffer". This is solely intending for testing.
+
 endif # FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index cece10b1f97c..8f5e194eba71 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -112,4 +112,6 @@ obj-$(CONFIG_RV) += rv/
 
 obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
 obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
+obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
+
 libftrace-y := ftrace.o
diff --git a/kernel/trace/remote_test.c b/kernel/trace/remote_test.c
new file mode 100644
index 000000000000..f8506d95ef3a
--- /dev/null
+++ b/kernel/trace/remote_test.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 - Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/module.h>
+#include <linux/simple_ring_buffer.h>
+#include <linux/trace_remote.h>
+#include <linux/tracefs.h>
+#include <linux/types.h>
+
+#define REMOTE_EVENT_INCLUDE_FILE kernel/trace/remote_test_events.h
+#include <trace/define_remote_events.h>
+
+static DEFINE_PER_CPU(struct simple_rb_per_cpu *, simple_rbs);
+static struct trace_buffer_desc *remote_test_buffer_desc;
+
+/*
+ * The trace_remote lock already serializes accesses from the trace_remote_callbacks.
+ * However write_event can still race with load/unload.
+ */
+static DEFINE_MUTEX(simple_rbs_lock);
+
+static int remote_test_load_simple_rb(int cpu, struct ring_buffer_desc *rb_desc)
+{
+	struct simple_rb_per_cpu *cpu_buffer;
+	struct simple_buffer_page *bpages;
+	int ret = -ENOMEM;
+
+	cpu_buffer = kzalloc(sizeof(*cpu_buffer), GFP_KERNEL);
+	if (!cpu_buffer)
+		return ret;
+
+	bpages = kmalloc_array(rb_desc->nr_page_va, sizeof(*bpages), GFP_KERNEL);
+	if (!bpages)
+		goto err_free_cpu_buffer;
+
+	ret = simple_ring_buffer_init(cpu_buffer, bpages, rb_desc);
+	if (ret)
+		goto err_free_bpages;
+
+	guard(mutex)(&simple_rbs_lock);
+
+	*per_cpu_ptr(&simple_rbs, cpu) = cpu_buffer;
+
+	return 0;
+
+err_free_bpages:
+	kfree(bpages);
+
+err_free_cpu_buffer:
+	kfree(cpu_buffer);
+
+	return ret;
+}
+
+static void remote_test_unload_simple_rb(int cpu)
+{
+	struct simple_rb_per_cpu *cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
+	struct simple_buffer_page *bpages;
+
+	if (!cpu_buffer)
+		return;
+
+	guard(mutex)(&simple_rbs_lock);
+
+	bpages = cpu_buffer->bpages;
+	simple_ring_buffer_unload(cpu_buffer);
+	kfree(bpages);
+	kfree(cpu_buffer);
+	*per_cpu_ptr(&simple_rbs, cpu) = NULL;
+}
+
+static struct trace_buffer_desc *remote_test_load(unsigned long size, void *unused)
+{
+	struct ring_buffer_desc *rb_desc;
+	struct trace_buffer_desc *desc;
+	size_t desc_size;
+	int cpu, ret;
+
+	if (WARN_ON(remote_test_buffer_desc))
+		return ERR_PTR(-EINVAL);
+
+	cpus_read_lock();
+
+	desc_size = trace_buffer_desc_size(size, num_online_cpus());
+	if (desc_size == SIZE_MAX) {
+		ret = -E2BIG;
+		goto err_unlock_cpus;
+	}
+
+	desc = kmalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto err_unlock_cpus;
+	}
+
+	ret = trace_remote_alloc_buffer(desc, size, cpu_online_mask);
+	if (ret)
+		goto err_free_desc;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
+		ret = remote_test_load_simple_rb(rb_desc->cpu, rb_desc);
+		if (ret)
+			goto err;
+	}
+
+	remote_test_buffer_desc = desc;
+
+	cpus_read_unlock();
+
+	return remote_test_buffer_desc;
+
+err:
+	for_each_ring_buffer_desc(rb_desc, cpu, remote_test_buffer_desc)
+		remote_test_unload_simple_rb(rb_desc->cpu);
+	trace_remote_free_buffer(remote_test_buffer_desc);
+
+err_free_desc:
+	kfree(desc);
+
+err_unlock_cpus:
+	cpus_read_unlock();
+
+	return ERR_PTR(ret);
+}
+
+static void remote_test_unload(struct trace_buffer_desc *desc, void *unused)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu;
+
+	if (WARN_ON(desc != remote_test_buffer_desc))
+		return;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, desc)
+		remote_test_unload_simple_rb(rb_desc->cpu);
+
+	remote_test_buffer_desc = NULL;
+	trace_remote_free_buffer(desc);
+}
+
+static int remote_test_enable_tracing(bool enable, void *unused)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu;
+
+	if (!remote_test_buffer_desc)
+		return -ENODEV;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, remote_test_buffer_desc)
+		WARN_ON(simple_ring_buffer_enable_tracing(*per_cpu_ptr(&simple_rbs, rb_desc->cpu),
+							  enable));
+	return 0;
+}
+
+static int remote_test_swap_reader_page(unsigned int cpu, void *unused)
+{
+	struct simple_rb_per_cpu *cpu_buffer;
+
+	if (cpu >= NR_CPUS)
+		return -EINVAL;
+
+	cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
+	if (!cpu_buffer)
+		return -EINVAL;
+
+	return simple_ring_buffer_swap_reader_page(cpu_buffer);
+}
+
+static int remote_test_reset(unsigned int cpu, void *unused)
+{
+	struct simple_rb_per_cpu *cpu_buffer;
+
+	if (cpu >= NR_CPUS)
+		return -EINVAL;
+
+	cpu_buffer = *per_cpu_ptr(&simple_rbs, cpu);
+	if (!cpu_buffer)
+		return -EINVAL;
+
+	return simple_ring_buffer_reset(cpu_buffer);
+}
+
+static int remote_test_enable_event(unsigned short id, bool enable, void *unused)
+{
+	if (id != REMOTE_TEST_EVENT_ID)
+		return -EINVAL;
+
+	/*
+	 * Let's just use the struct remote_event enabled field that is turned on and off by
+	 * trace_remote. This is a bit racy but good enough for a simple test module.
+	 */
+	return 0;
+}
+
+static ssize_t
+write_event_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *pos)
+{
+	struct remote_event_format_selftest *evt_test;
+	struct simple_rb_per_cpu *cpu_buffer;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&simple_rbs_lock);
+
+	if (!remote_event_selftest.enabled)
+		return cnt;
+
+	cpu_buffer = *this_cpu_ptr(&simple_rbs);
+	if (!cpu_buffer)
+		return -ENODEV;
+
+	evt_test = simple_ring_buffer_reserve(cpu_buffer,
+					      sizeof(struct remote_event_format_selftest),
+					      trace_clock_global());
+	if (!evt_test)
+		return -ENODEV;
+
+	evt_test->hdr.id = REMOTE_TEST_EVENT_ID;
+	evt_test->id = val;
+
+	simple_ring_buffer_commit(cpu_buffer);
+
+	return cnt;
+}
+
+static const struct file_operations write_event_fops = {
+	.write	= write_event_write,
+};
+
+static int remote_test_init_tracefs(struct dentry *d, void *unused)
+{
+	return tracefs_create_file("write_event", 0200, d, NULL, &write_event_fops) ?
+		0 : -ENOMEM;
+}
+
+static struct trace_remote_callbacks trace_remote_callbacks = {
+	.init			= remote_test_init_tracefs,
+	.load_trace_buffer	= remote_test_load,
+	.unload_trace_buffer	= remote_test_unload,
+	.enable_tracing		= remote_test_enable_tracing,
+	.swap_reader_page	= remote_test_swap_reader_page,
+	.reset			= remote_test_reset,
+	.enable_event		= remote_test_enable_event,
+};
+
+static int __init remote_test_init(void)
+{
+	return trace_remote_register("test", &trace_remote_callbacks, NULL,
+				     &remote_event_selftest, 1);
+}
+
+module_init(remote_test_init);
+
+MODULE_DESCRIPTION("Test module for the trace remote interface");
+MODULE_AUTHOR("Vincent Donnefort");
+MODULE_LICENSE("GPL");
diff --git a/kernel/trace/remote_test_events.h b/kernel/trace/remote_test_events.h
new file mode 100644
index 000000000000..bb68aac4a25c
--- /dev/null
+++ b/kernel/trace/remote_test_events.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#define REMOTE_TEST_EVENT_ID 1
+
+REMOTE_EVENT(selftest, REMOTE_TEST_EVENT_ID,
+	RE_STRUCT(
+		re_field(u64, id)
+	),
+	RE_PRINTK("id=%lld", __entry->id)
+);
-- 
2.49.0.1101.gccaa498523-goog

