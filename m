Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282472EBDDC
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764080; cv=none; b=NN5R8W0w9qDhyhqT9cKoSMWPDrgBgPLOzp3Sil7Bi6lRoF8mt4GBq3mTldfRvU921EUZa9rsU+fwkdoWKQVbqBkcqOEG/8E/DlR1W78rffzuNfPyGPuUdW2dhMXI202u2ZhBptQSL9dC1Td3o78rbJsHTg3J12t5Zgms0mXeLeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764080; c=relaxed/simple;
	bh=//1C5R4DthAxGm8JMNjmAFCgr8hZt+T9yu21+eu5nDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CnJtbstohIHcRncDSBTBXUhJtimB0kK/njRpROibIaU2h7/cu70J3JOPxHjV/C0DmWEpSaozlOFiEbZIci/BxavuXA7+PMiL3b4kDNwlNEw8wNHr+zrpGrMogKzLQLiNMDBG/Id+B8toHMHOG1SL1sP+6iCrFM1ziE87Qbp5kbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=peMEnHGW; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="peMEnHGW"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9edf41d07so365827f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764077; x=1756368877; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XIkumAY+Qa+CLy3aOczQdeniGlNqiyL93/I+4NSc/RU=;
        b=peMEnHGWfqrOR4QabICJhcxv5f1joyHeTu4vaY8+bYCuJn3Te3A2toOtpo9V5aiOAO
         A6e3CP4Nt7CrHk2gLro1lOA2T2pwHWzc9JcGd60vKFqvSTVUtNBLOF89rlbmLcrK2Xi9
         X1gohKSX7ezhb88+7oKExggeuCSBkbfiW3bhyb6CnZP309VFDfYQ1MMo4c4qjmTY71/C
         8QRFT9LxMwu5I+7IER6y8ciZoTp04aw0Z1P35i0FGZMO+tFZMHoxZJ6ARwiODtznUPtm
         9th6Fst2uHYDjNI4jh48G2Xcwy8vd6VzqVxNSGkT/pSAQp0YqlQxFG6oOph5s3+XNhHx
         hsdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764077; x=1756368877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIkumAY+Qa+CLy3aOczQdeniGlNqiyL93/I+4NSc/RU=;
        b=BmwT6mrCFVJl1UNlkfzYfjkooVaqqNd5rZkZ5FRxD+7H9Z4Mv9DZJKMpwArldfM61y
         8JdFg/dLX8oJMfca1Pd5Nv2pTJGInXF1aLjq2qfC4h4GSXUfwVwzeC1xDsvYSa2xfdsK
         CdCQezKepM8++6MtwMYUA5AeIq5mUQkR7uZ6VW7qDR99M60Xfzq7mJaLpg4mWCrB75Wh
         /K77vzic77EP9jxxdJssIspxGAu0St32bubFr8ctAydHnV5DCs+oIt+e8l4HQLt4DHrj
         DOQMRDDV2BcXXhYW6ldZGMZY99JTY0qz3vnN2W1goOYcWYPHNjfKDxMIEATpaMBoDMGq
         1h7w==
X-Gm-Message-State: AOJu0YwMPYNKV+7sIrpGrDkLi9DG6jUhcDGNMlPLI9uP6WRXaAuXtFTw
	YNJNNOoGeIuoZbSbS4YI8HsDzx3xJ3H6XLWDo0zA69XJ0IblHnBaO6ow7TBkV9af0d9R8SATehy
	COpFJnHkVrboX9xcVCDZLtQ==
X-Google-Smtp-Source: AGHT+IE2B3XpASX09u97oWLtmj7+DKYyjygPNdcC74JBMjS5y3LNop0tkSYmf/aQQm/kgIZulSB2bKIgmPvhviGD
X-Received: from wmbex21.prod.google.com ([2002:a05:600c:8315:b0:459:d8e5:aead])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c04:b0:3b7:8338:d219 with SMTP id ffacd0b85a97d-3c49405d778mr1324920f8f.3.1755764076780;
 Thu, 21 Aug 2025 01:14:36 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:13:59 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-12-vdonnefort@google.com>
Subject: [PATCH v6 11/24] tracing: Add a trace remote module for testing
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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
index 918afcc1fcaf..52131d89993c 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1244,4 +1244,12 @@ config TRACE_REMOTE
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
index 03d7d80a9436..53534447e70b 100644
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
2.51.0.rc2.233.g662b1ed5c5-goog

