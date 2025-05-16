Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF53B1865EB
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402850; cv=none; b=Hb44wrdkFn/fZNvN6X3X0/FSo/2hlkdKK0R6GV0a2WvZqNxkMyxCgHe0RCpe2Jv4w+0Coutnm8pE3pJuNelfTdtswEXN7AYfGf+iC3Rtihex/V0oOfrBjZHkvjf/fBwGzSlLrMObjpFLJ4fMVd7GFBDwWw2lo6TNeXpS9HdhIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402850; c=relaxed/simple;
	bh=8qJZV3+ZkXxu1Ov0qz/NZaE9j4jydlI4dUJR64D3PD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jj51Yyb3fAXMnkz/rkpl60BFgJ+gGobJF6ZcgF1MOInBwmz4tRCsO0C+IBUljg59VLejJPnCtCTXFasrb6pGR6mmIT4UhdZo7jG0sAlgji5vrTdwzJHBsWlfd90Sak/So3vm0y7BzngZlVNqpnCdQg19AQyaEClC6egnd6xYLZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQSH920g; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQSH920g"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442dc6f0138so11996975e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402845; x=1748007645; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Alhd1W3Kd/eK3C9Fu9OEpIXq/xKEu6wETWMfOKYZC2A=;
        b=aQSH920gdEU+KBHg6TmSfWz6SLADX+wEZS0Q+fiZT7BTLiMkfsCU0x0YThhCM+0fh7
         PlPRRhVEn7kmqto3m1g8Tz2WZGnKLPpKxgNLE7iEntzYO14wjkHTQbnevsQPmLhGdhJl
         kyJznFenMAgSNzXFVqxlRdDEsaS7/3iddSXTfg3eoWzjlaL+YaycZPjtnBHJeGJ2leDS
         mkuqO/PTHX8agMkrKt6FGo7yKZU87sWysNvNwjITrGoBKQPk8qf5urDD62rVEM2nGAFk
         ygS91Tm5kCpqXK8BuOrwR9piPZch4cK775ftet3jNtaqGT0SjvKul4KXevewB92AGYGY
         rGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402845; x=1748007645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Alhd1W3Kd/eK3C9Fu9OEpIXq/xKEu6wETWMfOKYZC2A=;
        b=t2qwfZJxzSS+D0d5GRS3sJVTxlQQER5/9K44bldoV1/EbZ6alu7RrhaxsWge1mnCDr
         VmkrViWJiOx7I8Z3r91sevhT+914mB7ATwiOhCc8oduyYUMwTO/TI+J+JaRRpgyX+M5t
         Sr4NUQoXTlU5S1C+94CKJmRUc9BBZPoCxDzhp3OAG2B4feQ+jxhMJCxuq0oj2GjFGmZE
         he+5xn7h8YdXISDkUCuYk9qa4TAtAfw1UBscpprz85wK3yiDCfIs3UVIrgCfTpZLWW5E
         xHk9NU8bTu2QmEvfGMpGvx5lPmKmDxtGnca2LADWhs+w/oU1GJCwhD1SUVK87vDMg4pg
         8eng==
X-Gm-Message-State: AOJu0Yxy8hiiERjvuZ1VHoSYlMa/0ZZPP+gChJXh93De/Olz226Vr77v
	ylapMike+5aB3Toeq5ZAYlATjRg1PQlFpzt1RwLAHKmVin6DECTbxVi5sxrhfTtABXnciQME2iF
	NgkBpvRpJfbC3Fsf40aHSVg==
X-Google-Smtp-Source: AGHT+IFhNHo0ydqJuPVgATBenFrGTC+GqOt0z8DxeRNNdPw1ZT2vOvpfvNoQsPri9IneILIqajKlMRA+BNfe1zBW
X-Received: from wmbhc7.prod.google.com ([2002:a05:600c:8707:b0:440:5e10:a5a6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3490:b0:43c:ec4c:25b1 with SMTP id 5b1f17b1804b1-442fd66f0damr28595235e9.23.1747402845515;
 Fri, 16 May 2025 06:40:45 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:12 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-7-vdonnefort@google.com>
Subject: [PATCH v5 06/25] tracing: Add events to trace remotes
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
index 000000000000..a4449008a075
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
+#define REMOTE_EVENT_NAME_MAX 30
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
index 8f8eb1f1e889..822cdd76e334 100644
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
@@ -155,7 +160,8 @@ static void trace_remote_reset(struct trace_remote *remote, int cpu)
 static ssize_t
 tracing_on_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	struct trace_remote *remote = filp->private_data;
+	struct seq_file *seq = filp->private_data;
+	struct trace_remote *remote = seq->private;
 	unsigned long val;
 	int ret;
 
@@ -184,7 +190,8 @@ DEFINE_SHOW_STORE_ATTRIBUTE(tracing_on);
 static ssize_t buffer_size_kb_write(struct file *filp, const char __user *ubuf, size_t cnt,
 				    loff_t *ppos)
 {
-	struct trace_remote *remote = filp->private_data;
+	struct seq_file *seq = filp->private_data;
+	struct trace_remote *remote = seq->private;
 	unsigned long val;
 	int ret;
 
@@ -265,16 +272,19 @@ static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remo
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
 
@@ -286,7 +296,8 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
 		if (ring_buffer_empty_cpu(trace_buffer, cpu))
 			continue;
 
-		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
+		rb_evt = ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events);
+		if (!rb_evt)
 			continue;
 
 		if (ts >= iter->ts)
@@ -294,14 +305,18 @@ static bool trace_remote_iter_next(struct trace_remote_iterator *iter)
 
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
 
@@ -315,6 +330,12 @@ static int trace_remote_iter_print(struct trace_remote_iterator *iter)
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
 
@@ -466,6 +487,8 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 			goto err;
 	}
 
+	remote->dentry = remote_d;
+
 	return 0;
 
 err:
@@ -479,7 +502,11 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
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
@@ -499,6 +526,13 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
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
@@ -561,3 +595,220 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t size,
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
+		seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%u;\tsigned:%d;\n",
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
2.49.0.1101.gccaa498523-goog

