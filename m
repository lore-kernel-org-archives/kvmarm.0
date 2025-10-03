Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0611EE7DC
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498743; cv=none; b=cyWVKTQ+itqUzo+yFgrQuos9upOz0un0OaJMcelYEw69InE2JaPLKkxTz5zzLqGJuZ1H9Sczjjhkzs/J4L1dEQcPc37pV2srQbKeE2Jola95ESdChkjVqHdik5FmOUBRXzEtpsJW5vBvaxXs756lJ1vdQtyZ1ZUDx93vukk+sNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498743; c=relaxed/simple;
	bh=WhHiN3T6nqkqfrujmYbSQhQdZnFH6oQ7rARrajYrZ1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JsVv3FaybH7IIT7f6srnT0ECCi8ES2af5sCBykknkHTcxUQdzZeG8hKhOwO8xta8CWHpHhC/6lVgNbCGWRs7EBC7/TWWF0d/gRGMvd5s/pUbk/1oy1rIwGmVkkWhuUtzTY9LkmlHfbxPAruCm/IAPfyO/evNxg8yifZ1c3pr52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NTUv+F0l; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NTUv+F0l"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece14b9231so1080720f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498740; x=1760103540; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fvRjHOrL5GqcRwZMV7e30Iup6J04sIy9qb33M/pVPkA=;
        b=NTUv+F0lXSwOm1xcfi09yb1qsoh2ymMOwHJIAGZa4+KK5qczCBQ8eBWBHi7g+DQTGr
         p5JbOZSfvh3Vm9HW00yTWz7o1QCTWAjBizH68XHdnxJsLvHvNQScLvma2P9AWOgJCyqg
         XEcF5+5MGU3Qzh++d0oIdvdgeXl4fMc34vS86MRtKFtWwiRoEoe+Fh65fNWXlHIaftql
         Ffe2/6m7z5FM2gJmGZgc9AtoTEJiBOCXQoqlm6f1hJJOzIhb7hdZXOvBZ6YlGhh2fCoc
         9LruWu6F27JXnjSGWNqOkeHE5wNZX67+O376YkwrZS0EPm4tnvDuQsAZhJ93o5A2MJO7
         qCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498740; x=1760103540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fvRjHOrL5GqcRwZMV7e30Iup6J04sIy9qb33M/pVPkA=;
        b=rl4qglB2V7CPou6O0rrb9myQPWxISJceeufs93iuAO0Sp5tQvBSqdZnQUpimpcazhs
         KZ4eXDjP5Y3SYUkU3MQKuXnRz/MSs5iOncT97qjdbMk95rvEZtyVeFUMd86bzCfcIIJI
         fncRXAmUn7dzh/QinSKNAv2FGGMyXSaojH913GZL7hcjnsJt5c2SgOEBD34/mdBrK3Dt
         6LzHP4JDOfsA0IPM7SOalF63tgUlsnTJwWmS5wpT6fhPDBUS72YhB7fqVC8BqWBP7xGq
         5MrMqJBzp7/PZsa1ct/1yhxJT+lTv7TS8TLsD+VTTvodqSMr6jXplrkZ3fhLMoI80TGl
         KOkw==
X-Gm-Message-State: AOJu0Ywn7iymUX/of2WlCv0zveOBjcrPnCwboRrdUqTb7wbq/FYPrHNZ
	gU3cVt4g7CHobN3bwnZ0EFlZF37F3rWUBXcDXplSUQMir5TDHE4N/TFYaks3e+orK/3O1wO4o+K
	Xow0ihBkClS3oUmn1VfRuMw==
X-Google-Smtp-Source: AGHT+IGbkOg03wLg9dZFczP/mAzk3emwrjkmr3xY8+u9FbGlyq7Xfo51NqcihsSXoVsU1weViliK38kP5MB/pCSL
X-Received: from wmht10.prod.google.com ([2002:a05:600c:41ca:b0:46e:34af:fbab])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:354e:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-46e7115d49dmr24176875e9.36.1759498739629;
 Fri, 03 Oct 2025 06:38:59 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:00 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-4-vdonnefort@google.com>
Subject: [PATCH v7 03/28] ring-buffer: Introduce ring-buffer remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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
index 876358cfe1b1..41193c5b0d28 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -250,4 +250,62 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
+
+struct ring_buffer_desc {
+	int		cpu;
+	unsigned int	nr_page_va; /* excludes the meta page */
+	unsigned long	meta_va;
+	unsigned long	page_va[] __counted_by(nr_page_va);
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
+	unsigned int nr_pages = max(DIV_ROUND_UP(buffer_size, PAGE_SIZE), 2UL) + 1;
+	struct ring_buffer_desc *rbdesc;
+
+	return size_add(offsetof(struct trace_buffer_desc, __data),
+			size_mul(nr_cpus, struct_size(rbdesc, page_va, nr_pages)));
+}
+
+#define for_each_ring_buffer_desc(__pdesc, __cpu, __trace_pdesc)		\
+	for (__pdesc = __first_ring_buffer_desc(__trace_pdesc), __cpu = 0;	\
+	     (__cpu) < (__trace_pdesc)->nr_cpus;				\
+	     (__cpu)++, __pdesc = __next_ring_buffer_desc(__pdesc))
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
+#define ring_buffer_alloc_remote(remote)			\
+({								\
+	static struct lock_class_key __key;			\
+	__ring_buffer_alloc_remote(remote, &__key);		\
+})
 #endif /* _LINUX_RING_BUFFER_H */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e5846f8f3c07..54f3f47b392b 100644
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
 
@@ -2197,6 +2201,40 @@ static void rb_meta_buffer_update(struct ring_buffer_per_cpu *cpu_buffer,
 	}
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
 static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		long nr_pages, struct list_head *pages)
 {
@@ -2204,6 +2242,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct ring_buffer_cpu_meta *meta = NULL;
 	struct buffer_page *bpage, *tmp;
 	bool user_thread = current->mm != NULL;
+	struct ring_buffer_desc *desc = NULL;
 	gfp_t mflags;
 	long i;
 
@@ -2240,6 +2279,12 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	if (buffer->range_addr_start)
 		meta = rb_range_meta(buffer, nr_pages, cpu_buffer->cpu);
 
+	if (buffer->remote) {
+		desc = ring_buffer_desc(buffer->remote->desc, cpu_buffer->cpu);
+		if (!desc || WARN_ON(desc->nr_page_va != (nr_pages + 1)))
+			return -EINVAL;
+	}
+
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 
@@ -2266,6 +2311,16 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 				rb_meta_buffer_update(cpu_buffer, bpage);
 			bpage->range = 1;
 			bpage->id = i + 1;
+		} else if (desc) {
+			void *p = ring_buffer_desc_page(desc, i + 1);
+
+			if (WARN_ON(!p))
+				goto free_pages;
+
+			bpage->page = p;
+			bpage->range = 1; /* bpage->page can't be freed */
+			bpage->id = i + 1;
+			cpu_buffer->subbuf_ids[i + 1] = bpage;
 		} else {
 			page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
 						mflags | __GFP_COMP | __GFP_ZERO,
@@ -2369,6 +2424,30 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 		if (cpu_buffer->ring_meta->head_buffer)
 			rb_meta_buffer_update(cpu_buffer, bpage);
 		bpage->range = 1;
+	} else if (buffer->remote) {
+		struct ring_buffer_desc *desc = ring_buffer_desc(buffer->remote->desc, cpu);
+
+		if (!desc)
+			goto fail_free_reader;
+
+		cpu_buffer->remote = buffer->remote;
+		cpu_buffer->meta_page = (struct trace_buffer_meta *)(void *)desc->meta_va;
+		cpu_buffer->nr_pages = nr_pages;
+		cpu_buffer->subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1,
+						 sizeof(*cpu_buffer->subbuf_ids), GFP_KERNEL);
+		if (!cpu_buffer->subbuf_ids)
+			goto fail_free_reader;
+
+		/* Remote buffers are read-only and immutable */
+		atomic_inc(&cpu_buffer->record_disabled);
+		atomic_inc(&cpu_buffer->resize_disabled);
+
+		bpage->page = ring_buffer_desc_page(desc, cpu_buffer->meta_page->reader.id);
+		if (!bpage->page)
+			goto fail_free_reader;
+
+		bpage->range = 1;
+		cpu_buffer->subbuf_ids[0] = bpage;
 	} else {
 		page = alloc_pages_node(cpu_to_node(cpu),
 					GFP_KERNEL | __GFP_COMP | __GFP_ZERO,
@@ -2431,6 +2510,9 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	irq_work_sync(&cpu_buffer->irq_work.work);
 
+	if (cpu_buffer->remote)
+		kfree(cpu_buffer->subbuf_ids);
+
 	free_buffer_page(cpu_buffer->reader_page);
 
 	if (head) {
@@ -2453,7 +2535,8 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 					 int order, unsigned long start,
 					 unsigned long end,
 					 unsigned long scratch_size,
-					 struct lock_class_key *key)
+					 struct lock_class_key *key,
+					 struct ring_buffer_remote *remote)
 {
 	struct trace_buffer *buffer __free(kfree) = NULL;
 	long nr_pages;
@@ -2493,6 +2576,8 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 	if (!buffer->buffers)
 		goto fail_free_cpumask;
 
+	cpu = raw_smp_processor_id();
+
 	/* If start/end are specified, then that overrides size */
 	if (start && end) {
 		unsigned long buffers_start;
@@ -2548,6 +2633,15 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 		buffer->range_addr_end = end;
 
 		rb_range_meta_init(buffer, nr_pages, scratch_size);
+	} else if (remote) {
+		struct ring_buffer_desc *desc = ring_buffer_desc(remote->desc, cpu);
+
+		buffer->remote = remote;
+		/* The writer is remote. This ring-buffer is read-only */
+		atomic_inc(&buffer->record_disabled);
+		nr_pages = desc->nr_page_va - 1;
+		if (nr_pages < 2)
+			goto fail_free_buffers;
 	} else {
 
 		/* need at least two pages */
@@ -2556,7 +2650,6 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 			nr_pages = 2;
 	}
 
-	cpu = raw_smp_processor_id();
 	cpumask_set_cpu(cpu, buffer->cpumask);
 	buffer->buffers[cpu] = rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
 	if (!buffer->buffers[cpu])
@@ -2598,7 +2691,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 					struct lock_class_key *key)
 {
 	/* Default buffer page size - one system page */
-	return alloc_buffer(size, flags, 0, 0, 0, 0, key);
+	return alloc_buffer(size, flags, 0, 0, 0, 0, key, NULL);
 
 }
 EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
@@ -2625,7 +2718,18 @@ struct trace_buffer *__ring_buffer_alloc_range(unsigned long size, unsigned flag
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
@@ -5233,6 +5337,16 @@ unsigned long ring_buffer_overruns(struct trace_buffer *buffer)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overruns);
 
+static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	local_set(&cpu_buffer->entries, READ_ONCE(cpu_buffer->meta_page->entries));
+	local_set(&cpu_buffer->overrun, READ_ONCE(cpu_buffer->meta_page->overrun));
+	local_set(&cpu_buffer->pages_touched, READ_ONCE(cpu_buffer->meta_page->pages_touched));
+	local_set(&cpu_buffer->pages_lost, READ_ONCE(cpu_buffer->meta_page->pages_lost));
+
+	return rb_num_of_entries(cpu_buffer);
+}
+
 static void rb_iter_reset(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
@@ -5387,7 +5501,43 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 }
 
 static struct buffer_page *
-rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+__rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *new_reader, *prev_reader;
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
+	prev_reader = cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
+
+	WARN_ON_ONCE(cpu_buffer->remote->swap_reader_page(cpu_buffer->cpu,
+							  cpu_buffer->remote->priv));
+	/* nr_pages doesn't include the reader page */
+	if (WARN_ON_ONCE(cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages))
+		return NULL;
+
+	new_reader = cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
+
+	WARN_ON_ONCE(prev_reader == new_reader);
+
+	cpu_buffer->reader_page->page = new_reader->page;
+	cpu_buffer->reader_page->id = new_reader->id;
+	cpu_buffer->reader_page->read = 0;
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
+
+	return rb_page_size(cpu_buffer->reader_page) ? cpu_buffer->reader_page : NULL;
+}
+
+static struct buffer_page *
+__rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
@@ -5557,6 +5707,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -5957,7 +6114,7 @@ ring_buffer_read_start(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
@@ -6125,6 +6282,23 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -6355,6 +6529,48 @@ bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
+int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (cpu != RING_BUFFER_ALL_CPUS) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -EINVAL;
+
+		cpu_buffer = buffer->buffers[cpu];
+
+		guard(raw_spinlock)(&cpu_buffer->reader_lock);
+		if (rb_read_remote_meta_page(cpu_buffer))
+			rb_wakeups(buffer, cpu_buffer);
+
+		return 0;
+	}
+
+	cpus_read_lock();
+
+	/*
+	 * Make sure all the ring buffers are up to date before we start reading
+	 * them.
+	 */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		guard(raw_spinlock)(&cpu_buffer->reader_lock);
+		rb_read_remote_meta_page(cpu_buffer);
+	}
+
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		if (rb_num_of_entries(cpu_buffer))
+			rb_wakeups(buffer, cpu_buffer);
+	}
+
+	cpus_read_unlock();
+
+	return 0;
+}
+
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
@@ -6600,6 +6816,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	bool force_memcpy;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return -1;
@@ -6637,6 +6854,8 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
+	force_memcpy = cpu_buffer->mapped || cpu_buffer->remote;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -6646,7 +6865,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    cpu_buffer->mapped) {
+	    force_memcpy) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -7225,7 +7444,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	unsigned long flags;
 	int err;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
 		return -EINVAL;
 
 	cpu_buffer = buffer->buffers[cpu];
-- 
2.51.0.618.g983fd99d29-goog

