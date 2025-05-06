Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23088284662
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550123; cv=none; b=FYDtC0Tk0CxetgqzNxlpcfXbpeJuiw90qQD9lVLyN76N5T8QbbXgHXP/9OYYR5hYVSVP+A28FhNv8fYkUT0n2YGOGTb8PDrsupZKkcKkOd1hZ5NatRsrjEpegtqonKLbMl2Yg0EhQyiW0sYlBpcE/zVOCGoK128A+tMk9R00IYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550123; c=relaxed/simple;
	bh=uSA7aZY+z8hl8mgHtorRGMJ/O7R5BzUyjcDQRpVm1vw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQV0MFr37taGttwdfcoVAz21tQdAkKEaKld1ZOIxX39CK6tjPIqFrA1pPmi18IQUk6vvM/WF/VLu399S4ZeHPf5PY1kSIMcgY23uGybKjsVGZbAh8IUKsAFiwU0xILezFKuA2JBl7yMLRBs5fhIoMBHZxbZY9OdwnreWPGfGtKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nwp/E10r; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nwp/E10r"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43eed325461so32708975e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550119; x=1747154919; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLqX+U6KC5XuCkJn67ap9ma3ZxQvqhTg5Cu1cd+kgu8=;
        b=nwp/E10rRxUqwiCNY6H9jyif4+0kVRzV3zr5aWsVoxrk8+n4WxeEbDBnwvJpuxNxy7
         rEI1dCkxeVsZYuoZgnCmPpoB7hu1nofcQXKcv2eW9YFqWYVhawRxIT7oU4oKcLogMorW
         ZEuR+czIRYnvU00hdc9yAvnlH3m97hWj8M5XGLR/kCJcG1RPyGBIcoLASzKbXLP6xNXw
         XfNpt4cGPcINHRXaNadYGOGQHG6RxdEqrvL3DTxKfJSyYPZKqSYlnFeVcM89S3PQ9TTw
         /KSGIr/NsmBzsEKKyHjZJiaOuajPhv1Nxh9F1esCvjw1metly6GM4zfOHj+oOgu6xTQZ
         SZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550119; x=1747154919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DLqX+U6KC5XuCkJn67ap9ma3ZxQvqhTg5Cu1cd+kgu8=;
        b=tTA4humb3oSN8zqv4Q8rFx6Id84+Tw3juUb6QwXuZ0KPAGz6sc1tLIR1ercRhtcN7V
         1sJ8QRL7apkYa58nrs2XCnOhloBijJb0XpWgxBx146D4okI5W/11Azua3lfTsGcZbkeb
         4sPXM7c/1Tp3Q2ymzuIE3UU41OhSiwojk+hFNWCy8eM7tLUAQ0Hn/nO5vWXwb7MXsTS2
         DF8q0WmdMRR9/WWzQRPpeL9eb9rHhDO8nqn542ksQzzjO+9o1WFkAXJpbzcvykshXaDa
         Qgn9G74f59g8JozCNQB3j0Ic6pFeYoZxod/a60FuXmG7xY/WN+T0gi4cWasEEuYgob16
         GUHw==
X-Gm-Message-State: AOJu0YwBADM5s+L7mRIyZ0utHLLAER+nrNagR7sYGFnHAiJNu5qraTwA
	CX0cy2rAJQoo9WYQYslsmeICk0QsEvxzzbINyqemfRq68Gm67zFd5DV1YWI2Xc8BDBvs6kUzhtX
	49+iG8zRw/BbjQsjwdg==
X-Google-Smtp-Source: AGHT+IHL/sNCxNOHRhTS6oTIVa5sfoqWbd5ej9wKybTNG3/n2Z6yTk1YBNocQmTo2EsZ2HHkWXZm3cQp1zUyP4GR
X-Received: from wmben4.prod.google.com ([2002:a05:600c:8284:b0:440:60ac:3f40])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3d18:b0:440:94a2:95b8 with SMTP id 5b1f17b1804b1-441d050b1ecmr44941085e9.16.1746550119630;
 Tue, 06 May 2025 09:48:39 -0700 (PDT)
Date: Tue,  6 May 2025 17:47:57 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-2-vdonnefort@google.com>
Subject: [PATCH v4 01/24] ring-buffer: Introduce ring-buffer remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A ring-buffer remote is an entity outside of the kernel (most likely a
firmware or a hypervisor) capable of writing events in a ring-buffer
following the same format as the tracefs ring-buffer.

To setup the ring-buffer on the kernel side, a description of the pages
forming the ring-buffer (struct trace_buffer_desc) must be given.
Callbacks (swap_reader_page and reset) must also be provided.

It is expected from the remote to keep the meta-page updated.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 56e27263acf8..c0c7f8a0dcb3 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -248,4 +248,67 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
+
+#define meta_pages_lost(__meta) \
+	((__meta)->Reserved1)
+#define meta_pages_touched(__meta) \
+	((__meta)->Reserved2)
+
+struct ring_buffer_desc {
+	int		cpu;
+	unsigned int	nr_page_va; /* excludes the meta page */
+	unsigned long	meta_va;
+	unsigned long	page_va[];
+};
+
+struct trace_buffer_desc {
+	int		nr_cpus;
+	size_t		struct_len;
+	char		__data[]; /* list of ring_buffer_desc */
+};
+
+static inline struct ring_buffer_desc *__next_ring_buffer_desc(struct ring_buffer_desc *desc)
+{
+	size_t len = struct_size(desc, page_va, desc->nr_page_va);
+
+	return (struct ring_buffer_desc *)((void *)desc + len);
+}
+
+static inline struct ring_buffer_desc *__first_ring_buffer_desc(struct trace_buffer_desc *desc)
+{
+	return (struct ring_buffer_desc *)(&desc->__data[0]);
+}
+
+static inline size_t trace_buffer_desc_size(size_t buffer_size, unsigned int nr_cpus)
+{
+	unsigned int nr_pages = (PAGE_ALIGN(buffer_size) / PAGE_SIZE) + 1;
+	struct ring_buffer_desc *rbdesc;
+
+	return size_add(offsetof(struct trace_buffer_desc, __data),
+			size_mul(nr_cpus, struct_size(rbdesc, page_va, nr_pages)));
+}
+
+#define for_each_ring_buffer_desc(__pdesc, __cpu, __trace_pdesc)		\
+	for (__pdesc = __first_ring_buffer_desc(__trace_pdesc), __cpu = 0;	\
+	     __cpu < (__trace_pdesc)->nr_cpus;					\
+	     __cpu++, __pdesc = __next_ring_buffer_desc(__pdesc))
+
+struct ring_buffer_remote {
+	struct trace_buffer_desc	*desc;
+	int				(*swap_reader_page)(unsigned int cpu, void *priv);
+	int				(*reset)(unsigned int cpu, void *priv);
+	void				*priv;
+};
+
+int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu);
+
+struct trace_buffer *
+__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
+			   struct lock_class_key *key);
+
+#define ring_buffer_remote(remote)				\
+({								\
+	static struct lock_class_key __key;			\
+	__ring_buffer_alloc_remote(remote, &__key);		\
+})
 #endif /* _LINUX_RING_BUFFER_H */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c0f877d39a24..a96a0b231fee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -523,6 +523,8 @@ struct ring_buffer_per_cpu {
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_cpu_meta	*ring_meta;
 
+	struct ring_buffer_remote	*remote;
+
 	/* ring buffer pages to update, > 0 to add, < 0 to remove */
 	long				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
@@ -545,6 +547,8 @@ struct trace_buffer {
 
 	struct ring_buffer_per_cpu	**buffers;
 
+	struct ring_buffer_remote	*remote;
+
 	struct hlist_node		node;
 	u64				(*clock)(void);
 
@@ -2196,6 +2200,41 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	return -ENOMEM;
 }
 
+static struct ring_buffer_desc *ring_buffer_desc(struct trace_buffer_desc *trace_desc, int cpu)
+{
+	struct ring_buffer_desc *desc, *end;
+	size_t len;
+	int i;
+
+	if (!trace_desc)
+		return NULL;
+
+	if (cpu >= trace_desc->nr_cpus)
+		return NULL;
+
+	end = (struct ring_buffer_desc *)((void *)trace_desc + trace_desc->struct_len);
+	desc = __first_ring_buffer_desc(trace_desc);
+	len = struct_size(desc, page_va, desc->nr_page_va);
+	desc = (struct ring_buffer_desc *)((void *)desc + (len * cpu));
+
+	if (desc < end && desc->cpu == cpu)
+		return desc;
+
+	/* Missing CPUs, need to linear search */
+	for_each_ring_buffer_desc(desc, i, trace_desc) {
+		if (desc->cpu == cpu)
+			return desc;
+	}
+
+	return NULL;
+}
+
+static void *ring_buffer_desc_page(struct ring_buffer_desc *desc, int page_id)
+{
+	return page_id > desc->nr_page_va ? NULL : (void *)desc->page_va[page_id];
+}
+
+
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned long nr_pages)
 {
@@ -2256,6 +2295,30 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 
 	cpu_buffer->reader_page = bpage;
 
+	if (buffer->remote) {
+		struct ring_buffer_desc *desc = ring_buffer_desc(buffer->remote->desc, cpu);
+
+		if (!desc)
+			goto fail_free_reader;
+
+		cpu_buffer->remote = buffer->remote;
+		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)desc->meta_va;
+		cpu_buffer->subbuf_ids = desc->page_va;
+		cpu_buffer->nr_pages = desc->nr_page_va - 1;
+		atomic_inc(&cpu_buffer->record_disabled);
+		atomic_inc(&cpu_buffer->resize_disabled);
+
+		bpage->page = ring_buffer_desc_page(desc, cpu_buffer->meta_page->reader.id);
+		if (!bpage->page)
+			goto fail_free_reader;
+		/*
+		 * The meta-page can only describe which of the ring-buffer page
+		 * is the reader. There is no need to init the rest of the
+		 * ring-buffer.
+		 */
+		return cpu_buffer;
+	}
+
 	if (buffer->range_addr_start) {
 		/*
 		 * Range mapped buffers have the same restrictions as memory
@@ -2333,6 +2396,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	irq_work_sync(&cpu_buffer->irq_work.work);
 
+	/* remote ring-buffer. We do not own the data pages */
+	if (cpu_buffer->remote)
+		cpu_buffer->reader_page->page = NULL;
+
 	free_buffer_page(cpu_buffer->reader_page);
 
 	if (head) {
@@ -2355,7 +2422,8 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 					 int order, unsigned long start,
 					 unsigned long end,
 					 unsigned long scratch_size,
-					 struct lock_class_key *key)
+					 struct lock_class_key *key,
+					 struct ring_buffer_remote *remote)
 {
 	struct trace_buffer *buffer;
 	long nr_pages;
@@ -2383,6 +2451,11 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
+	if (remote) {
+		buffer->remote = remote;
+		/* The writer is remote. This ring-buffer is read-only */
+		atomic_inc(&buffer->record_disabled);
+	}
 
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
@@ -2502,7 +2575,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 					struct lock_class_key *key)
 {
 	/* Default buffer page size - one system page */
-	return alloc_buffer(size, flags, 0, 0, 0, 0, key);
+	return alloc_buffer(size, flags, 0, 0, 0, 0, key, NULL);
 
 }
 EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
@@ -2529,7 +2602,18 @@ struct trace_buffer *__ring_buffer_alloc_range(unsigned long size, unsigned flag
 					       struct lock_class_key *key)
 {
 	return alloc_buffer(size, flags, order, start, start + range_size,
-			    scratch_size, key);
+			    scratch_size, key, NULL);
+}
+
+/**
+ * __ring_buffer_alloc_remote - allocate a new ring_buffer from a remote
+ * @remote: Contains a description of the ring-buffer pages and remote callbacks.
+ * @key: ring buffer reader_lock_key.
+ */
+struct trace_buffer *__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
+						struct lock_class_key *key)
+{
+	return alloc_buffer(0, 0, 0, 0, 0, 0, key, remote);
 }
 
 void *ring_buffer_meta_scratch(struct trace_buffer *buffer, unsigned int *size)
@@ -5278,8 +5362,56 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 	}
 }
 
+static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	local_set(&cpu_buffer->entries, READ_ONCE(cpu_buffer->meta_page->entries));
+	local_set(&cpu_buffer->overrun, READ_ONCE(cpu_buffer->meta_page->overrun));
+	local_set(&cpu_buffer->pages_touched, READ_ONCE(meta_pages_touched(cpu_buffer->meta_page)));
+	local_set(&cpu_buffer->pages_lost, READ_ONCE(meta_pages_lost(cpu_buffer->meta_page)));
+	/*
+	 * No need to get the "read" field, it can be tracked here as any
+	 * reader will have to go through a rign_buffer_per_cpu.
+	 */
+
+	return rb_num_of_entries(cpu_buffer);
+}
+
 static struct buffer_page *
-rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+__rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	u32 prev_reader;
+
+	if (!rb_read_remote_meta_page(cpu_buffer))
+		return NULL;
+
+	/* More to read on the reader page */
+	if (cpu_buffer->reader_page->read < rb_page_size(cpu_buffer->reader_page)) {
+		if (!cpu_buffer->reader_page->read)
+			cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+		return cpu_buffer->reader_page;
+	}
+
+	prev_reader = cpu_buffer->meta_page->reader.id;
+
+	WARN_ON(cpu_buffer->remote->swap_reader_page(cpu_buffer->cpu, cpu_buffer->remote->priv));
+	/* nr_pages doesn't include the reader page */
+	if (WARN_ON(cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages))
+		return NULL;
+
+	cpu_buffer->reader_page->page =
+		(void *)cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
+	cpu_buffer->reader_page->id = cpu_buffer->meta_page->reader.id;
+	cpu_buffer->reader_page->read = 0;
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
+
+	WARN_ON(prev_reader == cpu_buffer->meta_page->reader.id);
+
+	return rb_page_size(cpu_buffer->reader_page) ? cpu_buffer->reader_page : NULL;
+}
+
+static struct buffer_page *
+__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
@@ -5450,6 +5582,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	return reader;
 }
 
+static struct buffer_page *
+rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->remote ? __rb_get_reader_page_from_remote(cpu_buffer) :
+				    __rb_get_reader_page(cpu_buffer);
+}
+
 static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct ring_buffer_event *event;
@@ -5854,7 +5993,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
@@ -6024,6 +6163,23 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *page;
 
+	if (cpu_buffer->remote) {
+		if (!cpu_buffer->remote->reset)
+			return;
+
+		cpu_buffer->remote->reset(cpu_buffer->cpu, cpu_buffer->remote->priv);
+		rb_read_remote_meta_page(cpu_buffer);
+
+		/* Read related values, not covered by the meta-page */
+		local_set(&cpu_buffer->pages_read, 0);
+		cpu_buffer->read = 0;
+		cpu_buffer->read_bytes = 0;
+		cpu_buffer->last_overrun = 0;
+		cpu_buffer->reader_page->read = 0;
+
+		return;
+	}
+
 	rb_head_page_deactivate(cpu_buffer);
 
 	cpu_buffer->head_page
@@ -6259,6 +6415,49 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
+int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -EINVAL;
+
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		if (rb_read_remote_meta_page(cpu_buffer))
+			rb_wakeups(buffer, cpu_buffer);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+		return 0;
+	}
+
+	/*
+	 * Make sure all the ring buffers are up to date before we start reading
+	 * them.
+	 */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		rb_read_remote_meta_page(buffer->buffers[cpu]);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	}
+
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		if (rb_num_of_entries(cpu_buffer))
+			rb_wakeups(buffer, buffer->buffers[cpu]);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
@@ -6510,6 +6709,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	bool force_memcpy;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -6547,6 +6747,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
+	force_memcpy = cpu_buffer->mapped || cpu_buffer->remote;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -6556,7 +6758,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    cpu_buffer->mapped) {
+	    force_memcpy) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -7138,7 +7340,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	unsigned long flags, *subbuf_ids;
 	int err = 0;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
-- 
2.49.0.967.g6a0df3ecc3-goog

