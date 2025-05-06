Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E46288CBB
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550131; cv=none; b=l4bcjliKvhw34tg8WIKrCOPj/Sel7BiKBKBte/H8ya4O8S1UY/EvgGfTK9319Y4YJSlprPY1xMrRW6YgvYshsd2Em3iduO5zS+CoB4VoDGL25e25XM+idbg+LZq8WN+qynJ3beXpiCVBRMsq9Avw+eMYCJYcp7X3Y7tfCdG3hE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550131; c=relaxed/simple;
	bh=MYgRvz6Sx6XRNJZnlWQMJpm/jYaActtsntX9XN7CSMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ns00QS93SEMdXJI5AZhpeUcF+8HEDBITSX5hVM7Ivesg90Lrr6FU3icl71+N7xmTzSAPz3FbnEsq3itGp1vFtCO9h/ENUZlDgwmoxqWbw0RS4d+aM3E0/VveM7lSYneL0Wtu545ofhI9ubRQFjkkzIKBpK5QPjMARMpAK2m+8Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7+eBdiQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7+eBdiQ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-441c96c1977so18403005e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550127; x=1747154927; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YryICoMD3Le6bQCsIDGRMpjRXwTPENAcpB4PnEyl+F4=;
        b=X7+eBdiQLETpY0lK/T2Hdkp/xduN7l1GcdeF1GZbzkcee27HcdAsOnGEt71wpffZdn
         FfI8Go9QHalb8AaJVf/PAHk6BWeMllobybCusxCRN2q55jvBv+cl0uVd8kyeZ3Cl0vas
         eHdSyQJMCl4z/VfgJMqiO8v7hNbQy2PFakjG6yxNVnC96BhUwk+qkL0CRBdU7GkIMTos
         dFaE4/FYLmTUuFPVGRQBmFvnZIkrnyob8onkPFxCg2jN+XzWt29l0wPX/rv5SyWteJhd
         hOc3/drTj12USG/4QeJO2rJ3MKeaGgDQjyf3NhCpnifM8k5IYD2jAoYBvE6MKUXTHRh/
         IDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550127; x=1747154927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YryICoMD3Le6bQCsIDGRMpjRXwTPENAcpB4PnEyl+F4=;
        b=qBHszj/eZWgc78aXcCjNP3U7oUWG9L4h1MgCLBzzqYL0XIsFZL+Vl/l+4byR7ilM+r
         0AUETbippLb0C2lGIhJv6cCPIi69Blv+C5vw24FFSBWfA/Ie+stwKA7ndJxRXBky4JuQ
         h6cNi99BGY5XaLbwPsQ4+cnbqKXRE4Nx8Qns7ljh/199OcmiBe4fbqYaNUwoGFg3AYit
         cNvbiDLBOvoB+Wp14cDLCfWMRqqpRZVCb1da2t7Y7/Zhdj3xfQq5w+rQqkujaZhnytfd
         yRqUCmIf8RpnYcBWgoPzhC5vXETfCAx0B3VSr+V004ksYg64XeRUSksTFgfQVcMvCbFZ
         Rcfw==
X-Gm-Message-State: AOJu0Yw+dbuVfb22aYUkxGEL49uBRWPRrgeSHsQLDx0PBBiK1oB3wnae
	igkMRF5fcsC8o6jUYuvq7t7sRYeEsfBFx8jgkktxafO58aFYZApgn8+2+2jHddveSXvSqD6kYva
	1JfUF2PkynFlGrm/oZw==
X-Google-Smtp-Source: AGHT+IH+ddNYS15Z8lrn1rWxjPsAUbPVyUBb7r/P4plGFUvU6oPhNz5dC44bqtmwnybLR29a9sStIThir7uekEgg
X-Received: from wmbhc5.prod.google.com ([2002:a05:600c:8705:b0:43d:9035:df36])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e1e:b0:43c:fe9f:ab90 with SMTP id 5b1f17b1804b1-441d054c860mr35273565e9.28.1746550127399;
 Tue, 06 May 2025 09:48:47 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:01 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-6-vdonnefort@google.com>
Subject: [PATCH v4 05/24] tracing: Add events to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

An event is predefined point in the writer code that allows to log
data. Following the same scheme as kernel events, add remote events,
described to user-space within the events/ tracefs directory found in
the corresponding trace remote.

Remote events are expected to be described during the trace remote
registration.

Add also a .enable_event callback for trace_remote to toggle the event
logging, if supported.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index 82d26d97a536..4cf8efa83578 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -5,6 +5,7 @@
 
 #include <linux/dcache.h>
 #include <linux/ring_buffer.h>
+#include <linux/trace_remote_event.h>
 
 struct trace_remote_callbacks {
 	int	(*init)(struct dentry *d, void *priv);
@@ -14,9 +15,11 @@ struct trace_remote_callbacks {
 	int	(*enable_tracing)(bool enable, void *priv);
 	int	(*swap_reader_page)(unsigned int cpu, void *priv);
 	int	(*reset)(unsigned int cpu, void *priv);
+	int	(*enable_event)(unsigned short id, bool enable, void *priv);
 };
 
-int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);
+int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv,
+			  struct remote_event *events, size_t nr_events);
 int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
 			      const struct cpumask *cpumask);
 void trace_remote_free_buffer(struct trace_buffer_desc *desc);
diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
new file mode 100644
index 000000000000..621c5dff0664
--- /dev/null
+++ b/include/linux/trace_remote_event.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_TRACE_REMOTE_EVENTS_H
+#define _LINUX_TRACE_REMOTE_EVENTS_H
+
+struct trace_remote;
+struct trace_event_fields;
+
+struct remote_event_hdr {
+	unsigned short	id;
+};
+
+#define REMOTE_EVENT_NAME_MAX 29
+struct remote_event {
+	char				name[REMOTE_EVENT_NAME_MAX];
+	unsigned short			id;
+	bool				enabled;
+	struct trace_remote		*remote;
+	struct trace_event_fields	*fields;
+	char				*print_fmt;
+	void				(*print)(void *evt, struct trace_seq *seq);
+};
+#endif
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 6f4b921f6955..00ef80da043b 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -24,6 +24,7 @@ struct trace_remote_iterator {
 	struct delayed_work		poll_work;
 	unsigned long			lost_events;
 	u64				ts;
+	struct remote_event_hdr		*evt;
 	int				cpu;
 	int				evt_cpu;
 };
@@ -33,6 +34,10 @@ struct trace_remote {
 	void				*priv;
 	struct trace_buffer		*trace_buffer;
 	struct trace_buffer_desc	*trace_buffer_desc;
+	struct dentry			*dentry;
+	struct eventfs_inode		*eventfs;
+	struct remote_event		*events;
+	unsigned long			nr_events;
 	unsigned long			trace_buffer_size;
 	struct ring_buffer_remote	rb_remote;
 	struct mutex			lock;
@@ -152,7 +157,8 @@ static void trace_remote_reset(struct trace_remote *remote, int cpu)
 static ssize_t
 tracing_on_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	struct trace_remote *remote = filp->private_data;
+	struct seq_file *seq = filp->private_data;
+	struct trace_remote *remote = seq->private;
 	unsigned long val;
 	int ret;
 
@@ -181,7 +187,8 @@ DEFINE_SHOW_STORE_ATTRIBUTE(tracing_on);
 static ssize_t buffer_size_kb_write(struct file *filp, const char __user *ubuf, size_t cnt,
 				    loff_t *ppos)
 {
-	struct trace_remote *remote = filp->private_data;
+	struct seq_file *seq = filp->private_data;
+	struct trace_remote *remote = seq->private;
 	unsigned long val;
 	int ret;
 
@@ -262,16 +269,19 @@ static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remo
 static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
 {
 	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
+	struct ring_buffer_event *rb_evt;
 	int cpu = iter->cpu;
 
 	if (cpu != RING_BUFFER_ALL_CPUS) {
 		if (ring_buffer_empty_cpu(trace_buffer, cpu))
 			return false;
 
-		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
+		rb_evt = ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events);
+		if (!rb_evt)
 			return false;
 
 		iter->evt_cpu = cpu;
+		iter->evt = (struct remote_event_hdr *)&rb_evt->array[1];
 		return true;
 	}
 
@@ -283,7 +293,8 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
 		if (ring_buffer_empty_cpu(trace_buffer, cpu))
 			continue;
 
-		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
+		rb_evt = ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events);
+		if (!rb_evt)
 			continue;
 
 		if (ts >= iter->ts)
@@ -291,14 +302,18 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
 
 		iter->ts = ts;
 		iter->evt_cpu = cpu;
+		iter->evt = (struct remote_event_hdr *)&rb_evt->array[1];
 		iter->lost_events = lost_events;
 	}
 
 	return iter->ts != U64_MAX;
 }
 
+static struct remote_event *trace_remote_find_event(struct trace_remote *remote, unsigned short id);
+
 static int trace_remote_iter_print(struct trace_remote_iterator *iter)
 {
+	struct remote_event *evt;
 	unsigned long usecs_rem;
 	u64 ts = iter->ts;
 
@@ -312,6 +327,12 @@ static int trace_remote_iter_print(struct trace_remote_iterator *iter)
 	trace_seq_printf(&iter->seq, "[%03d]\t%5llu.%06lu: ", iter->evt_cpu,
 			 ts, usecs_rem);
 
+	evt = trace_remote_find_event(iter->remote, iter->evt->id);
+	if (!evt)
+		trace_seq_printf(&iter->seq, "UNKNOWN id=%d\n", iter->evt->id);
+	else
+		evt->print(iter->evt, &iter->seq);
+
 	return trace_seq_has_overflowed(&iter->seq) ? -EOVERFLOW : 0;
 }
 
@@ -463,6 +484,8 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 			goto err;
 	}
 
+	remote->dentry = remote_d;
+
 	return 0;
 
 err:
@@ -476,7 +499,11 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 	return -ENOMEM;
 }
 
-int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
+static int trace_remote_register_events(const char *remote_name, struct trace_remote *remote,
+					struct remote_event *events, size_t nr_events);
+
+int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv,
+			  struct remote_event *events, size_t nr_events)
 {
 	struct trace_remote *remote;
 	int ret;
@@ -496,6 +523,13 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
 		return -ENOMEM;
 	}
 
+	ret = trace_remote_register_events(name, remote, events, nr_events);
+	if (ret) {
+		pr_err("Failed to register events for trace remote '%s' (%d)\n",
+		       name, ret);
+		return ret;
+	}
+
 	ret = cbs->init ? cbs->init(remote->dentry, priv) : 0;
 	if (ret)
 		pr_err("Init failed for trace remote '%s' (%d)\n", name, ret);
@@ -558,3 +592,220 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
 	trace_remote_free_buffer(desc);
 	return -ENOMEM;
 }
+
+static int
+trace_remote_enable_event(struct trace_remote *remote, struct remote_event *evt, bool enable)
+{
+	int ret;
+
+	lockdep_assert_held(&remote->lock);
+
+	if (evt->enabled == enable)
+		return 0;
+
+	ret = remote->cbs->enable_event(evt->id, enable, remote->priv);
+	if (ret)
+		return ret;
+
+	evt->enabled = enable;
+
+	return 0;
+}
+
+static int remote_event_enable_show(struct seq_file *s, void *unused)
+{
+	struct remote_event *evt = s->private;
+
+	seq_printf(s, "%d\n", evt->enabled);
+
+	return 0;
+}
+
+static ssize_t remote_event_enable_write(struct file *filp, const char __user *ubuf,
+					 size_t count, loff_t *ppos)
+{
+	struct seq_file *seq = filp->private_data;
+	struct remote_event *evt = seq->private;
+	struct trace_remote *remote = evt->remote;
+	u8 enable;
+	int ret;
+
+	ret = kstrtou8_from_user(ubuf, count, 10, &enable);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&remote->lock);
+
+	ret = trace_remote_enable_event(remote, evt, enable);
+	if (ret)
+		return ret;
+
+	return count;
+}
+DEFINE_SHOW_STORE_ATTRIBUTE(remote_event_enable);
+
+static int remote_event_id_show(struct seq_file *s, void *unused)
+{
+	struct remote_event *evt = s->private;
+
+	seq_printf(s, "%d\n", evt->id);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(remote_event_id);
+
+static int remote_event_format_show(struct seq_file *s, void *unused)
+{
+	size_t offset = sizeof(struct remote_event_hdr);
+	struct remote_event *evt = s->private;
+	struct trace_event_fields *field;
+
+	seq_printf(s, "name: %s\n", evt->name);
+	seq_printf(s, "ID: %d\n", evt->id);
+	seq_puts(s,
+		 "format:\n\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n\n");
+
+	field = &evt->fields[0];
+	while (field->name) {
+		seq_printf(s, "\tfield:%s %s;\toffset:%lu;\tsize:%u;\tsigned:%d;\n",
+			   field->type, field->name, offset, field->size,
+			   !field->is_signed);
+		offset += field->size;
+		field++;
+	}
+
+	if (field != &evt->fields[0])
+		seq_puts(s, "\n");
+
+	seq_printf(s, "print fmt: %s\n", evt->print_fmt);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(remote_event_format);
+
+static int remote_event_callback(const char *name, umode_t *mode, void **data,
+				 const struct file_operations **fops)
+{
+	if (!strcmp(name, "enable")) {
+		*mode = TRACEFS_MODE_WRITE;
+		*fops = &remote_event_enable_fops;
+		return 1;
+	}
+
+	if (!strcmp(name, "id")) {
+		*mode = TRACEFS_MODE_READ;
+		*fops = &remote_event_id_fops;
+		return 1;
+	}
+
+	if (!strcmp(name, "format")) {
+		*mode = TRACEFS_MODE_READ;
+		*fops = &remote_event_id_fops;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int trace_remote_init_eventfs(const char *remote_name, struct trace_remote *remote,
+				     struct remote_event *evt)
+{
+	struct eventfs_inode *eventfs = remote->eventfs;
+	static struct eventfs_entry entries[] = {
+		{
+			.name		= "enable",
+			.callback	= remote_event_callback,
+		}, {
+			.name		= "id",
+			.callback	= remote_event_callback,
+		}, {
+			.name		= "format",
+			.callback	= remote_event_callback,
+		}
+	};
+	bool eventfs_create = false;
+
+	if (!eventfs) {
+		eventfs = eventfs_create_events_dir("events", remote->dentry, NULL, 0, NULL);
+		if (IS_ERR(eventfs))
+			return PTR_ERR(eventfs);
+
+		/*
+		 * Create similar hierarchy as local events even if a single system is supported at
+		 * the moment
+		 */
+		eventfs = eventfs_create_dir(remote_name, eventfs, NULL, 0, NULL);
+		if (IS_ERR(eventfs))
+			return PTR_ERR(eventfs);
+
+		remote->eventfs = eventfs;
+		eventfs_create = true;
+	}
+
+	eventfs = eventfs_create_dir(evt->name, eventfs, entries, ARRAY_SIZE(entries), evt);
+	if (IS_ERR(eventfs)) {
+		if (eventfs_create) {
+			eventfs_remove_events_dir(remote->eventfs);
+			remote->eventfs = NULL;
+		}
+		return PTR_ERR(eventfs);
+	}
+
+	return 0;
+}
+
+static int trace_remote_attach_events(struct trace_remote *remote, struct remote_event *events,
+				      size_t nr_events)
+{
+	int i;
+
+	for (i = 0; i < nr_events; i++) {
+		struct remote_event *evt = &events[i];
+
+		if (evt->remote)
+			return -EEXIST;
+
+		evt->remote = remote;
+
+		/* We need events to be sorted for efficient lookup */
+		if (i && evt->id <= events[i - 1].id)
+			return -EINVAL;
+	}
+
+	remote->events = events;
+	remote->nr_events = nr_events;
+
+	return 0;
+}
+
+static int trace_remote_register_events(const char *remote_name, struct trace_remote *remote,
+					struct remote_event *events, size_t nr_events)
+{
+	int i, ret;
+
+	ret = trace_remote_attach_events(remote, events, nr_events);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_events; i++) {
+		struct remote_event *evt = &events[i];
+
+		ret = trace_remote_init_eventfs(remote_name, remote, evt);
+		if (ret)
+			pr_warn("Failed to init eventfs for event '%s' (%d)",
+				evt->name, ret);
+	}
+
+	return 0;
+}
+
+static int __cmp_events(const void *id, const void *evt)
+{
+	return (long)id - ((struct remote_event *)evt)->id;
+}
+
+static struct remote_event *trace_remote_find_event(struct trace_remote *remote, unsigned short id)
+{
+	return bsearch((const void *)(unsigned long)id, remote->events, remote->nr_events,
+		       sizeof(*remote->events), __cmp_events);
+}
-- 
2.49.0.967.g6a0df3ecc3-goog

