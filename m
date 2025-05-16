Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5013AD3F
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402843; cv=none; b=pArwWJrS6Fe8c9FcUgH8Wrpl8hzgQt4/4wntO8HUvvk92ZiXpAxgHaxK1qDJYEmkz669vnjbqNM0yqQ+fYZ94LZPMm6jUQJjyZQpnh+JJ4FfMVKfIYL9i3dlHGPPArFBF75Pk8GK9avBDFsvbDbykaUtmaoST+3hOMvB9TV1zd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402843; c=relaxed/simple;
	bh=KncsJyyQ8ko421nxTwM8woRrtuLDNMKmDtD7zgBP9tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YQWqszG7FgPkeVgvi/vGNp72kxXM219u3dr4M6TShqCxsyy0G32Pas4BVIgM0wLA+V2CPvP4jrQYf1K04DoD/9fCFQ4lx7Bf3L2ZyLS4LaoFcinhCt9glfB3gWDoPykVACgRxU4bO4aIfpLlSF+Imo1VKjGclM28RP4kEMFDcqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DhI/FDtE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DhI/FDtE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d0a037f97so11888325e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402840; x=1748007640; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C70EDEoij6PuAkbvC4Y/bVpxLNRDwLTUQqFDIbnxURc=;
        b=DhI/FDtEnS9Y3SzFfCWLkxzVlO3Bo1HUi4Bx1EUcdVXRLL0QMa4Kd+r0Vjd6NyRRY9
         VjH9rUcPjVcpfJKENOSYClYeqtHOHLJfGwQcYT23McE+5Xh+aWMYSc+n6qj9q9vbOeJz
         Pi7nXv8Z1VTVulYT/4d2ypieYN28D3LqgrUlbrhFzfcw4IF/SUMLdtExM+ki2FytGOCE
         vC2JZXX5WAJIeq1wH5OuIzf05FIJJGHPKpvfsoHWlgP4AI5f4hq3RPodkGef4z1cZxW9
         r0lePAKHwiPWDYCH4wwGhxnOv4dcjyTXj9ulyMKTT0nDQD49w/nSx2mDex7HX2GBe0/g
         Wqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402840; x=1748007640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C70EDEoij6PuAkbvC4Y/bVpxLNRDwLTUQqFDIbnxURc=;
        b=G0DH6eTDS5a9oXMhM0LJ6SaEXnuUsIWd4BAUXsoFmI/eNw3oAu8vpFkHc4xRZk09Ys
         3d2uKRSDCaHeNYSTgeKNCveLtX8uqdjP0GrKXicZX8NdWgRq417JXaiyiLyOlhl6PSpr
         wiYB5twW60I2ulG84vUhBoUZ1MyIfIjQ8xee6rFMtbfxIG/FwgzdkWgcouPq3WcpP+TI
         ZCg9b6GdQoT1LVp9LvfdAHKpgYHgh7Wqjcu/OA0SoV/CL4Y5P+neSEMCxvUfK1JrWYvt
         yO8ezjvNcmAzbq4uDOnxrZXe85aaQFiwLwmx4BRZqBmvQDxdPi3tgMs3d/qesch/OToL
         1gDA==
X-Gm-Message-State: AOJu0Yx2HmplEXoHQ7XC/U/vmT72rxAxyNqPz/zZVkaSRywBU/shDfhE
	8+k3NXzRwgUGbK+E/5ijDUfS/E9zsHBIRcEXYMmbjHLwwGKvSGGoCMiMsfNvsxekhxpQb15Hg2O
	fVTQ8q5C390HNhNJ4HX9xcA==
X-Google-Smtp-Source: AGHT+IFrv/j3q8RT2YmTYmxY5EliLMTn/cyoEexGt6L7pk9I8GTztmU5jp18sECFHD0IUbtfNV4Ah4hc1ydphf5Y
X-Received: from wmbem20.prod.google.com ([2002:a05:600c:8214:b0:442:cd17:732c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a0d:b0:440:54ef:dfdc with SMTP id 5b1f17b1804b1-442fefefd08mr20094825e9.8.1747402840062;
 Fri, 16 May 2025 06:40:40 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:09 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-4-vdonnefort@google.com>
Subject: [PATCH v5 03/25] tracing: Introduce trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A trace remote relies on ring-buffer remotes to read and control
compatible tracing buffers, written by entity such as firmware or
hypervisor.

Add a Tracefs directory remotes/ that contains all instances of trace
remotes. Each instance follows the same hierarchy as any other to ease
the support by existing user-space tools.

This currently does not provide any event support, which will come
later.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
new file mode 100644
index 000000000000..de043a6f2fe0
--- /dev/null
+++ b/include/linux/trace_remote.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_TRACE_REMOTE_H
+#define _LINUX_TRACE_REMOTE_H
+
+#include <linux/ring_buffer.h>
+
+struct trace_remote_callbacks {
+	struct trace_buffer_desc *
+		(*load_trace_buffer)(unsigned long size, void *priv);
+	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
+	int	(*enable_tracing)(bool enable, void *priv);
+	int	(*swap_reader_page)(unsigned int cpu, void *priv);
+};
+
+int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);
+int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
+			      const struct cpumask *cpumask);
+void trace_remote_free_buffer(struct trace_buffer_desc *desc);
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a3f35c7d83b6..2fcc86c7fe7e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1215,4 +1215,7 @@ config HIST_TRIGGERS_DEBUG
 
 source "kernel/trace/rv/Kconfig"
 
+config TRACE_REMOTE
+	bool
+
 endif # FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 057cd975d014..b8204ae93744 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -110,4 +110,5 @@ obj-$(CONFIG_FPROBE_EVENTS) += trace_fprobe.o
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 obj-$(CONFIG_RV) += rv/
 
+obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b8db27fb6ef..52c89462a73c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8842,7 +8842,7 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 	return tr->percpu_dir;
 }
 
-static struct dentry *
+struct dentry *
 trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
 		      void *data, long cpu, const struct file_operations *fops)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 79be1995db44..f357e7e1ae71 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -670,6 +670,12 @@ struct dentry *trace_create_file(const char *name,
 				 struct dentry *parent,
 				 void *data,
 				 const struct file_operations *fops);
+struct dentry *trace_create_cpu_file(const char *name,
+				     umode_t mode,
+				     struct dentry *parent,
+				     void *data,
+				     long cpu,
+				     const struct file_operations *fops);
 
 int tracing_init_dentry(void);
 
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
new file mode 100644
index 000000000000..1a4786b7970c
--- /dev/null
+++ b/kernel/trace/trace_remote.c
@@ -0,0 +1,518 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 - Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/kstrtox.h>
+#include <linux/lockdep.h>
+#include <linux/mutex.h>
+#include <linux/tracefs.h>
+#include <linux/trace_remote.h>
+#include <linux/trace_seq.h>
+#include <linux/types.h>
+
+#include "trace.h"
+
+#define TRACEFS_DIR		"remotes"
+#define TRACEFS_MODE_WRITE	0640
+#define TRACEFS_MODE_READ	0440
+
+struct trace_remote_iterator {
+	struct trace_remote		*remote;
+	struct trace_seq		seq;
+	struct delayed_work		poll_work;
+	unsigned long			lost_events;
+	u64				ts;
+	int				cpu;
+	int				evt_cpu;
+};
+
+struct trace_remote {
+	struct trace_remote_callbacks	*cbs;
+	void				*priv;
+	struct trace_buffer		*trace_buffer;
+	struct trace_buffer_desc	*trace_buffer_desc;
+	unsigned long			trace_buffer_size;
+	struct ring_buffer_remote	rb_remote;
+	struct mutex			lock;
+	unsigned int			nr_readers;
+	unsigned int			poll_ms;
+	bool				tracing_on;
+};
+
+static bool trace_remote_loaded(struct trace_remote *remote)
+{
+	return remote->trace_buffer;
+}
+
+static int trace_remote_load(struct trace_remote *remote)
+{
+	struct ring_buffer_remote *rb_remote = &remote->rb_remote;
+
+	lockdep_assert_held(&remote->lock);
+
+	if (trace_remote_loaded(remote))
+		return 0;
+
+	remote->trace_buffer_desc = remote->cbs->load_trace_buffer(remote->trace_buffer_size,
+								   remote->priv);
+	if (IS_ERR(remote->trace_buffer_desc))
+		return PTR_ERR(remote->trace_buffer_desc);
+
+	rb_remote->desc = remote->trace_buffer_desc;
+	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
+	rb_remote->priv = remote->priv;
+	remote->trace_buffer = ring_buffer_remote(rb_remote);
+	if (!remote->trace_buffer) {
+		remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void trace_remote_try_unload(struct trace_remote *remote)
+{
+	lockdep_assert_held(&remote->lock);
+
+	if (!trace_remote_loaded(remote))
+		return;
+
+	/* The buffer is being read or writable */
+	if (remote->nr_readers || remote->tracing_on)
+		return;
+
+	/* The buffer has readable data */
+	if (!ring_buffer_empty(remote->trace_buffer))
+		return;
+
+	ring_buffer_free(remote->trace_buffer);
+	remote->trace_buffer = NULL;
+	remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
+}
+
+static int trace_remote_enable_tracing(struct trace_remote *remote)
+{
+	int ret;
+
+	lockdep_assert_held(&remote->lock);
+
+	if (remote->tracing_on)
+		return 0;
+
+	ret = trace_remote_load(remote);
+	if (ret)
+		return ret;
+
+	ret = remote->cbs->enable_tracing(true, remote->priv);
+	if (ret) {
+		trace_remote_try_unload(remote);
+		return ret;
+	}
+
+	remote->tracing_on = true;
+
+	return 0;
+}
+
+static int trace_remote_disable_tracing(struct trace_remote *remote)
+{
+	int ret;
+
+	lockdep_assert_held(&remote->lock);
+
+	if (!remote->tracing_on)
+		return 0;
+
+	ret = remote->cbs->enable_tracing(false, remote->priv);
+	if (ret)
+		return ret;
+
+	ring_buffer_poll_remote(remote->trace_buffer, RING_BUFFER_ALL_CPUS);
+	remote->tracing_on = false;
+	trace_remote_try_unload(remote);
+
+	return 0;
+}
+
+static ssize_t
+tracing_on_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_remote *remote = filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&remote->lock);
+
+	ret = val ? trace_remote_enable_tracing(remote) : trace_remote_disable_tracing(remote);
+	if (ret)
+		return ret;
+
+	return cnt;
+}
+static int tracing_on_show(struct seq_file *s, void *unused)
+{
+	struct trace_remote *remote = s->private;
+
+	seq_printf(s, "%d\n", remote->tracing_on);
+
+	return 0;
+}
+DEFINE_SHOW_STORE_ATTRIBUTE(tracing_on);
+
+static ssize_t buffer_size_kb_write(struct file *filp, const char __user *ubuf, size_t cnt,
+				    loff_t *ppos)
+{
+	struct trace_remote *remote = filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	/* KiB to Bytes */
+	if (!val || check_shl_overflow(val, 10, &val))
+		return -EINVAL;
+
+	guard(mutex)(&remote->lock);
+
+	remote->trace_buffer_size = val;
+
+	return cnt;
+}
+
+static int buffer_size_kb_show(struct seq_file *s, void *unused)
+{
+	struct trace_remote *remote = s->private;
+
+	seq_printf(s, "%lu (%s)\n", remote->trace_buffer_size >> 10,
+		   trace_remote_loaded(remote) ? "loaded" : "unloaded");
+
+	return 0;
+}
+DEFINE_SHOW_STORE_ATTRIBUTE(buffer_size_kb);
+
+static void __poll_remote(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct trace_remote_iterator *iter;
+
+	iter = container_of(dwork, struct trace_remote_iterator, poll_work);
+	ring_buffer_poll_remote(iter->remote->trace_buffer, iter->cpu);
+	schedule_delayed_work((struct delayed_work *)work,
+			      msecs_to_jiffies(iter->remote->poll_ms));
+}
+
+static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remote, int cpu)
+{
+	struct trace_remote_iterator *iter;
+	int ret;
+
+	if (remote->nr_readers == ULONG_MAX)
+		return ERR_PTR(-EBUSY);
+
+	ret = trace_remote_load(remote);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Test the CPU */
+	ret = ring_buffer_poll_remote(remote->trace_buffer, cpu);
+	if (ret)
+		goto err;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (iter) {
+		remote->nr_readers++;
+
+		iter->remote = remote;
+		iter->cpu = cpu;
+		trace_seq_init(&iter->seq);
+		INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
+		schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(remote->poll_ms));
+
+		return iter;
+	}
+	ret = -ENOMEM;
+
+err:
+	trace_remote_try_unload(remote);
+
+	return ERR_PTR(ret);
+}
+
+static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
+{
+	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
+	int cpu = iter->cpu;
+
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		if (ring_buffer_empty_cpu(trace_buffer, cpu))
+			return false;
+
+		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
+			return false;
+
+		iter->evt_cpu = cpu;
+		return true;
+	}
+
+	iter->ts = U64_MAX;
+	for_each_possible_cpu(cpu) {
+		unsigned long lost_events;
+		u64 ts;
+
+		if (ring_buffer_empty_cpu(trace_buffer, cpu))
+			continue;
+
+		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
+			continue;
+
+		if (ts >= iter->ts)
+			continue;
+
+		iter->ts = ts;
+		iter->evt_cpu = cpu;
+		iter->lost_events = lost_events;
+	}
+
+	return iter->ts != U64_MAX;
+}
+
+static int trace_remote_iter_print(struct trace_remote_iterator *iter)
+{
+	unsigned long usecs_rem;
+	u64 ts = iter->ts;
+
+	if (iter->lost_events)
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->evt_cpu, iter->lost_events);
+
+	do_div(ts, 1000);
+	usecs_rem = do_div(ts, USEC_PER_SEC);
+
+	trace_seq_printf(&iter->seq, "[%03d]\t%5llu.%06lu: ", iter->evt_cpu,
+			 ts, usecs_rem);
+
+	return trace_seq_has_overflowed(&iter->seq) ? -EOVERFLOW : 0;
+}
+
+static int trace_pipe_open(struct inode *inode, struct file *filp)
+{
+	struct trace_remote *remote = inode->i_private;
+	struct trace_remote_iterator *iter;
+	int cpu = RING_BUFFER_ALL_CPUS;
+
+	if (inode->i_cdev)
+		cpu = (long)inode->i_cdev - 1;
+
+	guard(mutex)(&remote->lock);
+	iter = trace_remote_iter(remote, cpu);
+	filp->private_data = iter;
+
+	return IS_ERR(iter) ? PTR_ERR(iter) : 0;
+}
+
+static int trace_pipe_release(struct inode *inode, struct file *filp)
+{
+	struct trace_remote_iterator *iter = filp->private_data;
+	struct trace_remote *remote = iter->remote;
+
+	guard(mutex)(&remote->lock);
+
+	cancel_delayed_work_sync(&iter->poll_work);
+	remote->nr_readers--;
+	trace_remote_try_unload(remote);
+	kfree(iter);
+
+	return 0;
+}
+
+static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_remote_iterator *iter = filp->private_data;
+	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
+	int ret;
+
+copy_to_user:
+	ret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	if (ret != -EBUSY)
+		return ret;
+
+	trace_seq_init(&iter->seq);
+
+	ret = ring_buffer_wait(trace_buffer, iter->cpu, 0, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	while (trace_remote_iter_next(iter)) {
+		int prev_len = iter->seq.seq.len;
+
+		if (trace_remote_iter_print(iter)) {
+			iter->seq.seq.len = prev_len;
+			break;
+		}
+
+		ring_buffer_consume(trace_buffer, iter->evt_cpu, NULL, NULL);
+	}
+
+	goto copy_to_user;
+}
+
+static const struct file_operations trace_pipe_fops = {
+	.open		= trace_pipe_open,
+	.read		= trace_pipe_read,
+	.release	= trace_pipe_release,
+};
+
+static int trace_remote_init_tracefs(const char *name, struct trace_remote *remote)
+{
+	struct dentry *remote_d, *percpu_d;
+	static struct dentry *root;
+	static DEFINE_MUTEX(lock);
+	bool root_inited = false;
+	int cpu;
+
+	guard(mutex)(&lock);
+
+	if (!root) {
+		root = tracefs_create_dir(TRACEFS_DIR, NULL);
+		if (!root) {
+			pr_err("Failed to create tracefs dir "TRACEFS_DIR"\n");
+			goto err;
+		}
+		root_inited = true;
+	}
+
+	remote_d = tracefs_create_dir(name, root);
+	if (!remote_d) {
+		pr_err("Failed to create tracefs dir "TRACEFS_DIR"%s/\n", name);
+		goto err;
+	}
+
+	if (!trace_create_file("tracing_on", TRACEFS_MODE_WRITE, remote_d, remote,
+			       &tracing_on_fops) ||
+	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
+			       &buffer_size_kb_fops) ||
+	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
+			       &trace_pipe_fops))
+		goto err;
+
+	percpu_d = tracefs_create_dir("per_cpu", remote_d);
+	if (!percpu_d) {
+		pr_err("Failed to create tracefs dir "TRACEFS_DIR"%s/per_cpu/\n", name);
+		goto err;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct dentry *cpu_d;
+		char cpu_name[16];
+
+		snprintf(cpu_name, sizeof(cpu_name), "cpu%d", cpu);
+		cpu_d = tracefs_create_dir(cpu_name, percpu_d);
+		if (!cpu_d) {
+			pr_err("Failed to create tracefs dir "TRACEFS_DIR"%s/percpu/cpu%d\n",
+			       name, cpu);
+			goto err;
+		}
+
+		if (!trace_create_cpu_file("trace_pipe", TRACEFS_MODE_READ, cpu_d, remote, cpu,
+					   &trace_pipe_fops))
+			goto err;
+	}
+
+	return 0;
+
+err:
+	if (root_inited) {
+		tracefs_remove(root);
+		root = NULL;
+	} else {
+		tracefs_remove(remote_d);
+	}
+
+	return -ENOMEM;
+}
+
+int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
+{
+	struct trace_remote *remote;
+
+	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
+	if (!remote)
+		return -ENOMEM;
+
+	remote->cbs = cbs;
+	remote->priv = priv;
+	remote->trace_buffer_size = 7 << 10;
+	remote->poll_ms = 100;
+	mutex_init(&remote->lock);
+
+	if (trace_remote_init_tracefs(name, remote)) {
+		kfree(remote);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void trace_remote_free_buffer(struct trace_buffer_desc *desc)
+{
+	struct ring_buffer_desc *rb_desc;
+	int cpu;
+
+	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
+		unsigned int id;
+
+		free_page(rb_desc->meta_va);
+
+		for (id = 0; id < rb_desc->nr_page_va; id++)
+			free_page(rb_desc->page_va[id]);
+	}
+}
+
+int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
+			      const struct cpumask *cpumask)
+{
+	int nr_pages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
+	struct ring_buffer_desc *rb_desc;
+	int cpu;
+
+	desc->nr_cpus = 0;
+	desc->struct_len = offsetof(struct trace_buffer_desc, __data);
+
+	rb_desc = (struct ring_buffer_desc *)&desc->__data[0];
+
+	for_each_cpu(cpu, cpumask) {
+		unsigned int id;
+
+		rb_desc->cpu = cpu;
+		rb_desc->nr_page_va = 0;
+		rb_desc->meta_va = (unsigned long)__get_free_page(GFP_KERNEL);
+		if (!rb_desc->meta_va)
+			goto err;
+
+		for (id = 0; id < nr_pages; id++) {
+			rb_desc->page_va[id] = (unsigned long)__get_free_page(GFP_KERNEL);
+			if (!rb_desc->page_va[id])
+				goto err;
+
+			rb_desc->nr_page_va++;
+		}
+		desc->nr_cpus++;
+		desc->struct_len += offsetof(struct ring_buffer_desc, page_va);
+		desc->struct_len += sizeof(rb_desc->page_va[0]) * rb_desc->nr_page_va;
+		rb_desc = __next_ring_buffer_desc(rb_desc);
+	}
+
+	return 0;
+
+err:
+	trace_remote_free_buffer(desc);
+	return -ENOMEM;
+}
-- 
2.49.0.1101.gccaa498523-goog

