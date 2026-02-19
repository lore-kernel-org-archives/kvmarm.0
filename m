Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A09A29A312
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513409; cv=none; b=odE/Gex9qidm/yXgq0WgjtowBvh1+jIwHQ8pXf4OBpJtdr2nRQBZ6PtuNDnn5n8f4doR+/NDsVPabhD792TKHl9x5ulNtIJZ2Qu8ViwrqbN+v07tyvW8neNYWuhGdUHxvpqX9yItpvb3uFCc2WmvIroo7SNt7Yd62rkL5tKrNXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513409; c=relaxed/simple;
	bh=ij1ya0qswLtCo+UemYj5uB77/qiBCAqrBTXR/h5EixI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nJOt/wtO7F7+SjZd4seoy7XUNtSFKcp5bgOKs1jhMpDaBOWMKtlCLiBBzCfOMuDky7fFbWJMVVBSO/4uHEDYbzzs0soQRBF6mC69I+zPJWVrfPh1mwMf4Zk2VF1jqnMIAabZUvawyUfIlB5f1/DPGhpJtRw6eMnrBPPsb62zKP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vsJc8ma5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vsJc8ma5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so7354585e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513406; x=1772118206; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lE4iP4wDSleUxflg4etDt4Hq+rZM4+EU/ies9w/+nbE=;
        b=vsJc8ma5KQSfTuYH1pL1/0cq6l6TxFCRTiSNJGoeElafr4WM4oDh6C6Q2QGs47MzDh
         ISUjB8/IT92hjQ8hidUAAkBkfJ8KVMdgzVvd23I8eZyaDHwMzkH9ltKMc4KiE4+Xb0W6
         eE0fjXw3+BRDEJfwqWrTIiL9Tx8IcHnwBZ5PghlF64PGjzUXVXcxQsp3mqkZrXnG6Um+
         cAXsCWPLI383PXaY6PrVcBs2eEsSkeh4ukLsdpsAlpiA9XiExjumX3f3dt35IP5DLhLN
         jtHzSiOzQfV4ygtLlhS9wjT5UfvpgFJU/E5we9Wdgr9OZpQLxAmhztwqLSlYzCRRYncz
         vNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513406; x=1772118206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lE4iP4wDSleUxflg4etDt4Hq+rZM4+EU/ies9w/+nbE=;
        b=oAAjbROBfL++K5JpimMLUHmiqS6l5BiB1+Ln3n3PxkHJ844RD06SajbUalEHm9PbMl
         GzLQUwjWex5J+5BFQOpe2aMU/z1pc/1xhWn+G78Mewauvzc2wnQFM4GIFXieSjduBE4m
         tloHSkz3UarTgR3MrTBnfWLi1fzQEtqbDM0xv52PtAW+1pIyOC6FnbqrTAtLhZ1dsuzF
         CQuC68VD7BifB+v1NM+/GqOajVd/nRL7A3hf33yj/Rola+nbZGGLd6xYjEPB6XudZPPs
         R5DPL37dyvsHZblGontKA4+vsKshkHjXos4tksjKn2st24VU5G7OouNpoq4Q3S3UOqiy
         gNjg==
X-Gm-Message-State: AOJu0YzfxGBZxLLCjz3pzIQRZGFXm6hqOYShw/+ZLLzu00p6d6VwXHyB
	+mXvtm0vlf5e69r0nxDmUTKVnjS91ielvkyqyyMIE1LsSn7A/Z5vy2JJB/qehXhpHV+El7dbM/R
	Ig/4nnMeYooEgjBCssrLYVw==
X-Received: from wmbjj14.prod.google.com ([2002:a05:600c:6a0e:b0:483:80e5:6e03])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c095:b0:483:7f4e:fef4 with SMTP id 5b1f17b1804b1-4837f4f00dcmr251097995e9.25.1771513405688;
 Thu, 19 Feb 2026 07:03:25 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:44 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-8-vdonnefort@google.com>
Subject: [PATCH v12 07/30] tracing: Add non-consuming read to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow reading the trace file for trace remotes. This performs a
non-consuming read of the trace buffer.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b4cdd355ebb3..9e36701011f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3856,7 +3856,7 @@ static int s_show(struct seq_file *m, void *v)
  * Should be used after trace_array_get(), trace_types_lock
  * ensures that i_cdev was already initialized.
  */
-static inline int tracing_get_cpu(struct inode *inode)
+int tracing_get_cpu(struct inode *inode)
 {
 	if (inode->i_cdev) /* See trace_create_cpu_file() */
 		return (long)inode->i_cdev - 1;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d6af4405b341..fbbd0b2ee76f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -695,6 +695,7 @@ struct dentry *trace_create_cpu_file(const char *name,
 				     void *data,
 				     long cpu,
 				     const struct file_operations *fops);
+int tracing_get_cpu(struct inode *inode);
 
 
 /**
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 83593fb8b425..5147ebe3f0bb 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -18,14 +18,23 @@
 #define TRACEFS_MODE_WRITE	0640
 #define TRACEFS_MODE_READ	0440
 
+enum tri_type {
+	TRI_CONSUMING,
+	TRI_NONCONSUMING,
+};
+
 struct trace_remote_iterator {
 	struct trace_remote		*remote;
 	struct trace_seq		seq;
 	struct delayed_work		poll_work;
 	unsigned long			lost_events;
 	u64				ts;
+	struct ring_buffer_iter		*rb_iter;
+	struct ring_buffer_iter		**rb_iters;
 	int				cpu;
 	int				evt_cpu;
+	loff_t				pos;
+	enum tri_type			type;
 };
 
 struct trace_remote {
@@ -36,6 +45,8 @@ struct trace_remote {
 	unsigned long			trace_buffer_size;
 	struct ring_buffer_remote	rb_remote;
 	struct mutex			lock;
+	struct rw_semaphore		reader_lock;
+	struct rw_semaphore		*pcpu_reader_locks;
 	unsigned int			nr_readers;
 	unsigned int			poll_ms;
 	bool				tracing_on;
@@ -230,6 +241,20 @@ static int trace_remote_get(struct trace_remote *remote, int cpu)
 	if (ret)
 		return ret;
 
+	if (cpu != RING_BUFFER_ALL_CPUS && !remote->pcpu_reader_locks) {
+		int lock_cpu;
+
+		remote->pcpu_reader_locks = kcalloc(nr_cpu_ids, sizeof(*remote->pcpu_reader_locks),
+						    GFP_KERNEL);
+		if (!remote->pcpu_reader_locks) {
+			trace_remote_try_unload(remote);
+			return -ENOMEM;
+		}
+
+		for_each_possible_cpu(lock_cpu)
+			init_rwsem(&remote->pcpu_reader_locks[lock_cpu]);
+	}
+
 	remote->nr_readers++;
 
 	return 0;
@@ -244,6 +269,9 @@ static void trace_remote_put(struct trace_remote *remote)
 	if (remote->nr_readers)
 		return;
 
+	kfree(remote->pcpu_reader_locks);
+	remote->pcpu_reader_locks = NULL;
+
 	trace_remote_try_unload(remote);
 }
 
@@ -258,13 +286,55 @@ static void __poll_remote(struct work_struct *work)
 			      msecs_to_jiffies(iter->remote->poll_ms));
 }
 
-static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remote, int cpu)
+static void __free_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
+{
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		ring_buffer_read_finish(iter->rb_iter);
+		return;
+	}
+
+	for_each_possible_cpu(cpu) {
+		if (iter->rb_iters[cpu])
+			ring_buffer_read_finish(iter->rb_iters[cpu]);
+	}
+
+	kfree(iter->rb_iters);
+}
+
+static int __alloc_ring_buffer_iter(struct trace_remote_iterator *iter, int cpu)
+{
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		iter->rb_iter = ring_buffer_read_start(iter->remote->trace_buffer, cpu, GFP_KERNEL);
+
+		return iter->rb_iter ? 0 : -ENOMEM;
+	}
+
+	iter->rb_iters = kcalloc(nr_cpu_ids, sizeof(*iter->rb_iters), GFP_KERNEL);
+	if (!iter->rb_iters)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		iter->rb_iters[cpu] = ring_buffer_read_start(iter->remote->trace_buffer, cpu,
+							     GFP_KERNEL);
+		if (!iter->rb_iters[cpu]) {
+			__free_ring_buffer_iter(iter, RING_BUFFER_ALL_CPUS);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static struct trace_remote_iterator
+*trace_remote_iter(struct trace_remote *remote, int cpu, enum tri_type type)
 {
 	struct trace_remote_iterator *iter = NULL;
 	int ret;
 
 	lockdep_assert_held(&remote->lock);
 
+	if (type == TRI_NONCONSUMING && !trace_remote_loaded(remote))
+		return NULL;
 
 	ret = trace_remote_get(remote, cpu);
 	if (ret)
@@ -279,9 +349,21 @@ static struct trace_remote_iterator *trace_remote_iter(struct trace_remote *remo
 	if (iter) {
 		iter->remote = remote;
 		iter->cpu = cpu;
+		iter->type = type;
 		trace_seq_init(&iter->seq);
-		INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
-		schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(remote->poll_ms));
+
+		switch (type) {
+		case TRI_CONSUMING:
+			INIT_DELAYED_WORK(&iter->poll_work, __poll_remote);
+			schedule_delayed_work(&iter->poll_work, msecs_to_jiffies(remote->poll_ms));
+			break;
+		case TRI_NONCONSUMING:
+			ret = __alloc_ring_buffer_iter(iter, cpu);
+			break;
+		}
+
+		if (ret)
+			goto err;
 
 		return iter;
 	}
@@ -305,10 +387,100 @@ static void trace_remote_iter_free(struct trace_remote_iterator *iter)
 
 	lockdep_assert_held(&remote->lock);
 
+	switch (iter->type) {
+	case TRI_CONSUMING:
+		cancel_delayed_work_sync(&iter->poll_work);
+		break;
+	case TRI_NONCONSUMING:
+		__free_ring_buffer_iter(iter, iter->cpu);
+		break;
+	}
+
 	kfree(iter);
 	trace_remote_put(remote);
 }
 
+static void trace_remote_iter_read_start(struct trace_remote_iterator *iter)
+{
+	struct trace_remote *remote = iter->remote;
+	int cpu = iter->cpu;
+
+	/* Acquire global reader lock */
+	if (cpu == RING_BUFFER_ALL_CPUS && iter->type == TRI_CONSUMING)
+		down_write(&remote->reader_lock);
+	else
+		down_read(&remote->reader_lock);
+
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		return;
+
+	/*
+	 * No need for the remote lock here, iter holds a reference on
+	 * remote->nr_readers
+	 */
+
+	/* Get the per-CPU one */
+	if (WARN_ON_ONCE(!remote->pcpu_reader_locks))
+		return;
+
+	if (iter->type == TRI_CONSUMING)
+		down_write(&remote->pcpu_reader_locks[cpu]);
+	else
+		down_read(&remote->pcpu_reader_locks[cpu]);
+}
+
+static void trace_remote_iter_read_finished(struct trace_remote_iterator *iter)
+{
+	struct trace_remote *remote = iter->remote;
+	int cpu = iter->cpu;
+
+	/* Release per-CPU reader lock */
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		/*
+		 * No need for the remote lock here, iter holds a reference on
+		 * remote->nr_readers
+		 */
+		if (iter->type == TRI_CONSUMING)
+			up_write(&remote->pcpu_reader_locks[cpu]);
+		else
+			up_read(&remote->pcpu_reader_locks[cpu]);
+	}
+
+	/* Release global reader lock */
+	if (cpu == RING_BUFFER_ALL_CPUS && iter->type == TRI_CONSUMING)
+		up_write(&remote->reader_lock);
+	else
+		up_read(&remote->reader_lock);
+}
+
+static struct ring_buffer_iter *__get_rb_iter(struct trace_remote_iterator *iter, int cpu)
+{
+	return iter->cpu != RING_BUFFER_ALL_CPUS ? iter->rb_iter : iter->rb_iters[cpu];
+}
+
+static struct ring_buffer_event *
+__peek_event(struct trace_remote_iterator *iter, int cpu, u64 *ts, unsigned long *lost_events)
+{
+	struct ring_buffer_event *rb_evt;
+	struct ring_buffer_iter *rb_iter;
+
+	switch (iter->type) {
+	case TRI_CONSUMING:
+		return ring_buffer_peek(iter->remote->trace_buffer, cpu, ts, lost_events);
+	case TRI_NONCONSUMING:
+		rb_iter = __get_rb_iter(iter, cpu);
+		rb_evt = ring_buffer_iter_peek(rb_iter, ts);
+		if (!rb_evt)
+			return NULL;
+
+		*lost_events = ring_buffer_iter_dropped(rb_iter);
+
+		return rb_evt;
+	}
+
+	return NULL;
+}
+
 static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
 {
 	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
@@ -318,7 +490,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
 		if (ring_buffer_empty_cpu(trace_buffer, cpu))
 			return false;
 
-		if (!ring_buffer_peek(trace_buffer, cpu, &iter->ts, &iter->lost_events))
+		if (!__peek_event(iter, cpu, &iter->ts, &iter->lost_events))
 			return false;
 
 		iter->evt_cpu = cpu;
@@ -333,7 +505,7 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
 		if (ring_buffer_empty_cpu(trace_buffer, cpu))
 			continue;
 
-		if (!ring_buffer_peek(trace_buffer, cpu, &ts, &lost_events))
+		if (!__peek_event(iter, cpu, &ts, &lost_events))
 			continue;
 
 		if (ts >= iter->ts)
@@ -347,6 +519,20 @@ static bool trace_remote_iter_read_event(struct trace_remote_iterator *iter)
 	return iter->ts != U64_MAX;
 }
 
+static void trace_remote_iter_move(struct trace_remote_iterator *iter)
+{
+	struct trace_buffer *trace_buffer = iter->remote->trace_buffer;
+
+	switch (iter->type) {
+	case TRI_CONSUMING:
+		ring_buffer_consume(trace_buffer, iter->evt_cpu, NULL, NULL);
+		break;
+	case TRI_NONCONSUMING:
+		ring_buffer_iter_advance(__get_rb_iter(iter, iter->evt_cpu));
+		break;
+	}
+}
+
 static int trace_remote_iter_print_event(struct trace_remote_iterator *iter)
 {
 	unsigned long usecs_rem;
@@ -369,13 +555,14 @@ static int trace_pipe_open(struct inode *inode, struct file *filp)
 {
 	struct trace_remote *remote = inode->i_private;
 	struct trace_remote_iterator *iter;
-	int cpu = RING_BUFFER_ALL_CPUS;
-
-	if (inode->i_cdev)
-		cpu = (long)inode->i_cdev - 1;
+	int cpu = tracing_get_cpu(inode);
 
 	guard(mutex)(&remote->lock);
-	iter = trace_remote_iter(remote, cpu);
+
+	iter = trace_remote_iter(remote, cpu, TRI_CONSUMING);
+	if (IS_ERR(iter))
+		return PTR_ERR(iter);
+
 	filp->private_data = iter;
 
 	return IS_ERR(iter) ? PTR_ERR(iter) : 0;
@@ -410,6 +597,8 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
+	trace_remote_iter_read_start(iter);
+
 	while (trace_remote_iter_read_event(iter)) {
 		int prev_len = iter->seq.seq.len;
 
@@ -418,9 +607,11 @@ static ssize_t trace_pipe_read(struct file *filp, char __user *ubuf, size_t cnt,
 			break;
 		}
 
-		ring_buffer_consume(trace_buffer, iter->evt_cpu, NULL, NULL);
+		trace_remote_iter_move(iter);
 	}
 
+	trace_remote_iter_read_finished(iter);
+
 	goto copy_to_user;
 }
 
@@ -430,14 +621,127 @@ static const struct file_operations trace_pipe_fops = {
 	.release	= trace_pipe_release,
 };
 
+static void *trace_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct trace_remote_iterator *iter = m->private;
+
+	++*pos;
+
+	if (!iter || !trace_remote_iter_read_event(iter))
+		return NULL;
+
+	trace_remote_iter_move(iter);
+	iter->pos++;
+
+	return iter;
+}
+
+static void *trace_start(struct seq_file *m, loff_t *pos)
+{
+	struct trace_remote_iterator *iter = m->private;
+	loff_t i;
+
+	if (!iter)
+		return NULL;
+
+	trace_remote_iter_read_start(iter);
+
+	if (!*pos) {
+		iter->pos = -1;
+		return trace_next(m, NULL, &i);
+	}
+
+	i = iter->pos;
+	while (i < *pos) {
+		iter = trace_next(m, NULL, &i);
+		if (!iter)
+			return NULL;
+	}
+
+	return iter;
+}
+
+static int trace_show(struct seq_file *m, void *v)
+{
+	struct trace_remote_iterator *iter = v;
+
+	trace_seq_init(&iter->seq);
+
+	if (trace_remote_iter_print_event(iter)) {
+		seq_printf(m, "[EVENT %d PRINT TOO BIG]\n", iter->evt->id);
+		return 0;
+	}
+
+	return trace_print_seq(m, &iter->seq);
+}
+
+static void trace_stop(struct seq_file *m, void *v)
+{
+	struct trace_remote_iterator *iter = m->private;
+
+	if (iter)
+		trace_remote_iter_read_finished(iter);
+}
+
+static const struct seq_operations trace_sops = {
+	.start		= trace_start,
+	.next		= trace_next,
+	.show		= trace_show,
+	.stop		= trace_stop,
+};
+
+static int trace_open(struct inode *inode, struct file *filp)
+{
+	struct trace_remote *remote = inode->i_private;
+	struct trace_remote_iterator *iter = NULL;
+	int cpu = tracing_get_cpu(inode);
+	int ret;
+
+	if (!(filp->f_mode & FMODE_READ))
+		return 0;
+
+	guard(mutex)(&remote->lock);
+
+	iter = trace_remote_iter(remote, cpu, TRI_NONCONSUMING);
+	if (IS_ERR(iter))
+		return PTR_ERR(iter);
+
+	ret = seq_open(filp, &trace_sops);
+	if (ret) {
+		trace_remote_iter_free(iter);
+		return ret;
+	}
+
+	((struct seq_file *)filp->private_data)->private = (void *)iter;
+
+	return 0;
+}
+
+static int trace_release(struct inode *inode, struct file *filp)
+{
+	struct trace_remote_iterator *iter;
+
+	if (!(filp->f_mode & FMODE_READ))
+		return 0;
+
+	iter = ((struct seq_file *)filp->private_data)->private;
+	seq_release(inode, filp);
+
+	if (!iter)
+		return 0;
+
+	guard(mutex)(&iter->remote->lock);
+
+	trace_remote_iter_free(iter);
+
+	return 0;
+}
+
 static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	struct inode *inode = file_inode(filp);
 	struct trace_remote *remote = inode->i_private;
-	int cpu = RING_BUFFER_ALL_CPUS;
-
-	if (inode->i_cdev)
-		cpu = (long)inode->i_cdev - 1;
+	int cpu = tracing_get_cpu(inode);
 
 	guard(mutex)(&remote->lock);
 
@@ -447,7 +751,11 @@ static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cn
 }
 
 static const struct file_operations trace_fops = {
+	.open		= trace_open,
 	.write		= trace_write,
+	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.release	= trace_release,
 };
 
 static int trace_remote_init_tracefs(const char *name, struct trace_remote *remote)
@@ -565,6 +873,7 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
 	remote->trace_buffer_size = 7 << 10;
 	remote->poll_ms = 100;
 	mutex_init(&remote->lock);
+	init_rwsem(&remote->reader_lock);
 
 	if (trace_remote_init_tracefs(name, remote)) {
 		kfree(remote);
-- 
2.53.0.335.g19a08e0c02-goog

