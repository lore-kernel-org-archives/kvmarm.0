Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ED21F8EFA
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336770; cv=none; b=smi4ZS5+glvqa1PZImggtbt16ZgpOBBTqnMOnQQVrmAfy2xjHB5yKporrDZq1pqfHwzvTiW73oUffTQJM1R2xV73qHN/VIMnPd9aGP52AEpl3hakZfDWYJc4xGchWN+D5sg8FcwSgIP3VVPDgQKKx1Nxq/UyhgmXY2CaYOoyFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336770; c=relaxed/simple;
	bh=5mbMYaccSA1ZbyVOpbLJymusLwn2ulxm0EHIL7N36QI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uvRPsTBNcgwjcxiUNYf8kCZBxdf3HaAjU905rtvTgC0FTBYY538GZ44rTBf+9sIbQ3xxvooPMFYDGNZ8/bH+4t5W8uGxRB1DM5VaPNeQS05+stCKh0tF5r2i6x0eofyM+FUvke1AZ5MlgWVccniZjZFvVVFkwYq/1p0Wds6n0Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E0qiHZ1a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E0qiHZ1a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361eb83f46so120497315e9.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 03:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736336765; x=1736941565; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zyRp1b919r89Eg225SDZas+7Mb8iYzQz9Y+QnWrVQaI=;
        b=E0qiHZ1a9I97hcaiWrmFWdAZTDmkdx9gSxABmiVABM1jhizBI/et+Qgs+x4Qw8JTrT
         sc49LNQPh0pWqzIl7sHOvMfDT10VuMvGsXyTH4wS3hEMxnhiN8qNGymL8kTOo6tMujcB
         2UJtoHgA0B0eA1Eev1uakOIjZl2bNh+LKF9vD9gbw1RQORtaEG27wtW1SVqO+vdlHUru
         5kMuUUZrgteK7J6r+gvK4BZ0ztbcn6ExAjBgc7AncxqmmngGe2zN4iPVsL5Ak3UCNHCG
         8AcuEC4w/vmge9UvlzecyvqIfHesN4AwPJrG7CGk08elTx4BSqiIc5I//c+05WpNDmnX
         BjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336765; x=1736941565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyRp1b919r89Eg225SDZas+7Mb8iYzQz9Y+QnWrVQaI=;
        b=WVSbnzr8Ry9w33ovOQe8hX3gOMuD1wIGSweQ2d6X1mOjtwLp7HnxPeigT0Q87HWsA1
         IyNPwrKCBhZ0QZcerA6NRuVIrRx592iG2NQmxaqw0hqJmW+uqrLFY/UWt8PL2f0SjJiV
         7mlL5wU8sOoUQKvofJz9nNDRTxlpIUGBmlrUb3IMtY6TOFGLfPZhW9seTAMZgZrlQa3g
         x2IltbSLvB1w8epTFIcGc+htOtxYxu8Rpef41aO6a00ePmpMG1KgzhKvtRL4n4xdQc5o
         JR3v9yDI2RdNF44/9bHs2xdbvk/Ytqn/6DHDfGdprQAB5UdXWQvxW1ZtnQrCLmOnkUB1
         b15Q==
X-Gm-Message-State: AOJu0YzUvlgt+risGSZzXL4crHH0bYbC/eP4JDaB3XXzSYUgig3CBwSn
	qO8mjMEsUPARbAwjj6FYn9A/CXpzvrrKp0/i5CZfJ+lM9pHhNjHVY9+0crpVfwIsWDPUm9ru/iY
	ObhnObROBPsbxmuWF9Q==
X-Google-Smtp-Source: AGHT+IHtyiylCLtdV3rwvkxH8A5nRxm3SJDRbjJynJozyfFCy9jTqaHXSi/8hkT+ucFxrR0bbzrgoMXbuRUZESX/
X-Received: from wmbea9.prod.google.com ([2002:a05:600c:6749:b0:436:164a:763e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:c5ca:0:b0:436:e3e6:b725 with SMTP id 5b1f17b1804b1-436e3e6b799mr13864645e9.6.1736336765569;
 Wed, 08 Jan 2025 03:46:05 -0800 (PST)
Date: Wed,  8 Jan 2025 11:45:26 +0000
In-Reply-To: <20250108114536.627715-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250108114536.627715-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250108114536.627715-3-vdonnefort@google.com>
Subject: [PATCH v2 02/12] ring-buffer: Introducing ring-buffer remote
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
(struct trace_page_desc) is necessary. A callback (get_reader_page) must
also be provided. It is called whenever it is done reading the previous
reader page.

It is expected from the remote to keep the meta-page updated.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 17fbb7855295..61e785adc011 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -248,4 +248,58 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
+
+#define meta_pages_lost(__meta) \
+	((__meta)->Reserved1)
+#define meta_pages_touched(__meta) \
+	((__meta)->Reserved2)
+
+struct rb_page_desc {
+	int		cpu;
+	int		nr_page_va; /* exclude the meta page */
+	unsigned long	meta_va;
+	unsigned long	page_va[];
+};
+
+struct trace_page_desc {
+	int		nr_cpus;
+	char		__data[]; /* list of rb_page_desc */
+};
+
+static inline
+struct rb_page_desc *__next_rb_page_desc(struct rb_page_desc *pdesc)
+{
+	size_t len = struct_size(pdesc, page_va, pdesc->nr_page_va);
+
+	return (struct rb_page_desc *)((void *)pdesc + len);
+}
+
+static inline
+struct rb_page_desc *__first_rb_page_desc(struct trace_page_desc *trace_pdesc)
+{
+	return (struct rb_page_desc *)(&trace_pdesc->__data[0]);
+}
+
+#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)		\
+	for (__pdesc = __first_rb_page_desc(__trace_pdesc), __cpu = 0;	\
+	     __cpu < (__trace_pdesc)->nr_cpus;				\
+	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
+
+struct ring_buffer_remote {
+	struct trace_page_desc	*pdesc;
+	int			(*get_reader_page)(int cpu);
+	int			(*reset)(int cpu);
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
index 479bbbcbf61b..3d5d32ecd3fa 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -519,6 +519,8 @@ struct ring_buffer_per_cpu {
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_meta		*ring_meta;
 
+	struct ring_buffer_remote	*remote;
+
 	/* ring buffer pages to update, > 0 to add, < 0 to remove */
 	long				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
@@ -541,6 +543,8 @@ struct trace_buffer {
 
 	struct ring_buffer_per_cpu	**buffers;
 
+	struct ring_buffer_remote	*remote;
+
 	struct hlist_node		node;
 	u64				(*clock)(void);
 
@@ -2132,6 +2136,42 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	return -ENOMEM;
 }
 
+static struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc,
+					 int cpu)
+{
+	struct rb_page_desc *pdesc;
+	size_t len;
+	int i;
+
+	if (!trace_pdesc)
+		return NULL;
+
+	if (cpu >= trace_pdesc->nr_cpus)
+		return NULL;
+
+	pdesc = __first_rb_page_desc(trace_pdesc);
+	len = struct_size(pdesc, page_va, pdesc->nr_page_va);
+	pdesc += len * cpu;
+
+	if (pdesc->cpu == cpu)
+		return pdesc;
+
+	/* Missing CPUs, need to linear search */
+
+	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
+		if (pdesc->cpu == cpu)
+			return pdesc;
+	}
+
+	return NULL;
+}
+
+static void *rb_page_desc_page(struct rb_page_desc *pdesc, int page_id)
+{
+	return page_id > pdesc->nr_page_va ? NULL : (void *)pdesc->page_va[page_id];
+}
+
+
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned long nr_pages)
 {
@@ -2192,6 +2232,31 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 
 	cpu_buffer->reader_page = bpage;
 
+	if (buffer->remote) {
+		struct rb_page_desc *pdesc = rb_page_desc(buffer->remote->pdesc, cpu);
+
+		if (!pdesc)
+			goto fail_free_reader;
+
+		cpu_buffer->remote = buffer->remote;
+		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)pdesc->meta_va;
+		cpu_buffer->subbuf_ids = pdesc->page_va;
+		cpu_buffer->nr_pages = pdesc->nr_page_va - 1;
+		atomic_inc(&cpu_buffer->record_disabled);
+		atomic_inc(&cpu_buffer->resize_disabled);
+
+		bpage->page = rb_page_desc_page(pdesc,
+						cpu_buffer->meta_page->reader.id);
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
@@ -2269,6 +2334,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	irq_work_sync(&cpu_buffer->irq_work.work);
 
+	/* remote ring-buffer. We do not own the data pages */
+	if (cpu_buffer->remote)
+		cpu_buffer->reader_page->page = NULL;
+
 	free_buffer_page(cpu_buffer->reader_page);
 
 	if (head) {
@@ -2290,7 +2359,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 					 int order, unsigned long start,
 					 unsigned long end,
-					 struct lock_class_key *key)
+					 struct lock_class_key *key,
+					 struct ring_buffer_remote *remote)
 {
 	struct trace_buffer *buffer;
 	long nr_pages;
@@ -2318,6 +2388,11 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
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
@@ -2424,7 +2499,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 					struct lock_class_key *key)
 {
 	/* Default buffer page size - one system page */
-	return alloc_buffer(size, flags, 0, 0, 0,key);
+	return alloc_buffer(size, flags, 0, 0, 0, key, NULL);
 
 }
 EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
@@ -2448,7 +2523,17 @@ struct trace_buffer *__ring_buffer_alloc_range(unsigned long size, unsigned flag
 					       unsigned long range_size,
 					       struct lock_class_key *key)
 {
-	return alloc_buffer(size, flags, order, start, start + range_size, key);
+	return alloc_buffer(size, flags, order, start, start + range_size, key, NULL);
+}
+
+/**
+ * __ring_buffer_alloc_remote
+ *
+ */
+struct trace_buffer *__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
+						struct lock_class_key *key)
+{
+	return alloc_buffer(0, 0, 0, 0, 0, key, remote);
 }
 
 /**
@@ -5197,8 +5282,54 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
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
+	if (cpu_buffer->reader_page->read < rb_page_size(cpu_buffer->reader_page))
+		return cpu_buffer->reader_page;
+
+	prev_reader = cpu_buffer->meta_page->reader.id;
+
+	WARN_ON(cpu_buffer->remote->get_reader_page(cpu_buffer->cpu));
+	/* nr_pages doesn't include the reader page */
+	if (cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	cpu_buffer->reader_page->page =
+		(void *)cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
+	cpu_buffer->reader_page->read = 0;
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
+
+	WARN_ON(prev_reader == cpu_buffer->meta_page->reader.id);
+
+	return cpu_buffer->reader_page;
+}
+
+static struct buffer_page *
+__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
@@ -5369,6 +5500,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -5773,7 +5911,7 @@ ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
@@ -5943,6 +6081,22 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *page;
 
+	if (cpu_buffer->remote) {
+		if (!cpu_buffer->remote->reset)
+			return;
+
+		cpu_buffer->remote->reset(cpu_buffer->cpu);
+		rb_read_remote_meta_page(cpu_buffer);
+
+		/* Read related values, not covered by the meta-page */
+		local_set(&cpu_buffer->pages_read, 0);
+		cpu_buffer->read = 0;
+		cpu_buffer->read_bytes = 0;
+		cpu_buffer->last_overrun = 0;
+
+		return;
+	}
+
 	rb_head_page_deactivate(cpu_buffer);
 
 	cpu_buffer->head_page
@@ -6190,6 +6344,49 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
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
@@ -6441,6 +6638,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	bool force_memcpy;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -6478,6 +6676,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
+	force_memcpy = cpu_buffer->mapped || cpu_buffer->remote;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -6487,7 +6687,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    cpu_buffer->mapped) {
+	    force_memcpy) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -7067,7 +7267,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	unsigned long flags, *subbuf_ids;
 	int err = 0;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
-- 
2.47.1.613.gc27f4b7a9f-goog

