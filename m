Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6D30CDAF
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668199; cv=none; b=p6GFgMnXgSD1d0JeWdRXk9PJF0LfrEWFPrVI+9LOe1ilp7umClvOVF2zd9K4/F+pu2LiJ0qHeX6zrg/42SdcKsiIIVr2vFAuY3ANeGz5kQsK8xSdtZsEwNF+gWNJSruqyADkvuqr/k5TWKjPOcXarPttUUvCBs9wXntpohOTyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668199; c=relaxed/simple;
	bh=PtWYiH8saqexDEpmRjV19ewUZ69yRmTChA7YYVOtf/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u4wNzcFlCsbEtKFFxV6SXQ+S/rrOXml1zRcsLWVfET4mrlNdCm/C7zhj6aIMNcyaEH86deRLVsr71pk+REFG74YNxuedY8nRI9KzFdtjB69Hm5auNqu57BNzGu2qzOrrqByEEVJ7B0aMmgzFeO52qVGXFBSYF+PsPnTz1Iarbeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LnLTlYwv; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LnLTlYwv"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47921784b97so12622325e9.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668195; x=1765272995; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xgVcXzxjwiHK0jo3jp1K8krlLpwRuC7G9oe0EqIapTM=;
        b=LnLTlYwvfzqrPjvqgE/OGCtyYzAFA5XQiEV7SvyK1LZQHoG4ieAcWVCZXFSlee0mxu
         /wEP6zWarYZNgl65bMouG/CSPY99UP+XszYRZvo0bBDRsHw5xW1t+k26XO1+ktdOQEEJ
         K2C5q51Zepc73tNEvIWZ0QRsa8NjvIpKNUmDdDoAixbuMuV+Z0ItEZeDVasNsc43kBaW
         feYDsWPsV+6NCsUFSI2CqfcjsYCHcoQf/XDYMOanHzH8JmKFtzgovImBs5LMZJCIdHtO
         K7yIzss5rGXRNW8ODcpuXROwJJ2rYM9pjU4z+/c/sP/e8Vf1vLREiJjy/yjAJLhhci4W
         BmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668195; x=1765272995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgVcXzxjwiHK0jo3jp1K8krlLpwRuC7G9oe0EqIapTM=;
        b=qSquaO3O7dn67gZ7G2BTpUaMNCXhw5N+Dzhuox2g+nZWNVXgYhTo9W+H82xCMf0P3H
         nFmP086EYrAk1fy7Ew1q2/BTmgcPIP4QPXOzYsr0H1k+WIWT2CAiB0YqaUgYaWMqfRjD
         sRIjt41mgcxFLIyW5IYsdHRIWFJBMnVs2MmDYfy+7mFZZFMzD/crh3Zcd6JkcsVwGuZx
         SoC724dw67C3QAdktcwLL1cb44a9Om2ZnkaYlnU0lXruZygZE3xeHQnKLCn+IL8S2gs1
         ffVO4ROOnr5o0/bqMmM8ejkq9cmmgkOEn6A0XWpaX5lKF9SMNf8D+H6TEHqOaRFqlWlQ
         0mQA==
X-Gm-Message-State: AOJu0YwL9KAL0PGzMvMC3b7D6VebexdWRg6FIv3KN09UL3g7JpE9XSSb
	1clxBFi/VAG7vWeXpSG22coZg48fnt9SipRBK5wU/Z22gvEQYP+NrAYE2nRLYsmeMeEc6IePZF3
	/KVNTsdkW8+slI0LIpHjpJQ==
X-Google-Smtp-Source: AGHT+IEu207gaGMJHyy95P6c4K6JucISTG8ogw17B3GECjaYrJvWcyo40mLGbbNp+eHJ7H8zLDN9f4RmmBI43GeL
X-Received: from wmpj37.prod.google.com ([2002:a05:600c:48a5:b0:477:7e23:fadf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ed2:b0:477:9e10:3e63 with SMTP id 5b1f17b1804b1-477c1164cebmr389313505e9.35.1764668194578;
 Tue, 02 Dec 2025 01:36:34 -0800 (PST)
Date: Tue,  2 Dec 2025 09:35:56 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-4-vdonnefort@google.com>
Subject: [PATCH v9 03/30] ring-buffer: Introduce ring-buffer remotes
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
index aeff2ce6231a..9c6c8e206e04 100644
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
2.52.0.107.ga0afd4fd5b-goog

