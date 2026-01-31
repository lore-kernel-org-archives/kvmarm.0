Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8264352F88
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866168; cv=none; b=RWFJz+1Q6YSwzFBTt60I/2qPN3IMQqPr9q1Fm2mOOuoJxY8rXlbwHuujrlXvvMGWQYgIdotyJNgsIqGLc0GGIzUfYKZLLEofIab7AoBBOf0rcMek0MS24BJ7d9/NXLQ/HeWKqwZBIkhFp9nld+C1QQn40HyoN98KzuiA3BLHrHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866168; c=relaxed/simple;
	bh=J6SAJzYzltNTUCnsv8TPw7gsi03jbsmfcwyTa4G30y4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DRn0hUTm2/+vlWhIfImNoDons77bdgUTdYnrdoanjbw8yi6xGqI8pZSfFx54fs1eKhFkAxMsj09iNWZgRTxRXeEZ9J/+KIBmV/T+/8WX8vauoOrye63Kg41NjTkpb0+8SyhMDV5HOj2tMaIyoAXUV7X709T7CMv5y2g97ZK0lmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pak3Yd5t; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pak3Yd5t"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee1fe7b24so26137125e9.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866165; x=1770470965; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uj+W/fw6jviNtcb7rjWbgliWocDtdFOtxpsoa7nbJ6s=;
        b=Pak3Yd5tOHtVi4wGIG286kSmg3wcHUGNpuJFC6sPWZ1yYccf+781DLhpHpbaaGChVl
         ew+Wn9WZHkJNTIfMpInsw+rwUCGW8RquTwQUqtuGvHZ+Ks8yvDW7VIj6cWmOx4ZgvDGa
         hWCUuPKTi9yY+iWZyd5NV+vZTi9L7B2HFSlUjpHWbEKLv1pq2Mzk0a8G+JvEm779PPHq
         oEQiYnXNZ76kk1+4UfBnKcYtm+HhTl3HZv1f8ZTtV2K88dtuLGoX7LcYTsbZLr2laWWp
         siYQDp13RQW7S3kWgMQU3P/bP4//rT7FfAcHUT48cFoWPvnV++mNDV5dAygeTzQBJoav
         nwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866165; x=1770470965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uj+W/fw6jviNtcb7rjWbgliWocDtdFOtxpsoa7nbJ6s=;
        b=O/bAbl7oGcn0vxdyKfBnQ8eXlFcaSW7C3mK9P7jKVnjO62xmPL8O1DLGqVz1F2y1zJ
         byzgaEJ3WFsU14a+hXZL+swwxudZXlzKhXYHsy6v5qWC1HCPgFK6u6kVunqo8fApDuao
         L2TcHchwqBQQYLDUqEcK+N/ppYgjRlrMOb6jeYpRjI8+yyxvsgWeVNzqNKYw8AdhsdTu
         tMBPvq1xJtanvnKk5qkHLMlwV3pNW4PzkVwXmcmdPsgnO+xmXnIxnT8fm+PXAzlL4myC
         J7QlYgIZzkDR8vDXaNgIaSMOqPsIHtpwvjbRztr1AJTOXcsvXWOajAx9Jt8Q7HF79qG9
         4eUw==
X-Gm-Message-State: AOJu0Yzo6hoNBjhgcOfF23EFwhiq7TkhTSeKt8F6tmpxL8IncpSIUJPP
	qensjPFoLd7zUek6Ge0en42X7LYaP5Ac9Jm5A2sW9s7yhv+FlhZZBkphrVEFj2qNGiloztSc6+g
	RXJuMHWMKGivRphiL2ATR0w==
X-Received: from wmju1.prod.google.com ([2002:a7b:cb01:0:b0:480:6b8b:a7ab])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b42:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-482db49728bmr62880405e9.32.1769866165397;
 Sat, 31 Jan 2026 05:29:25 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:22 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-5-vdonnefort@google.com>
Subject: [PATCH v11 04/30] ring-buffer: Add non-consuming read for ring-buffer remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hopefully, the remote will only swap pages on the kernel instruction (via
the swap_reader_page() callback). This means we know at what point the
ring-buffer geometry has changed. It is therefore possible to rearrange
the kernel view of that ring-buffer to allow non-consuming read.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 00754339733d..2d08dd326309 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5365,10 +5365,51 @@ static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	return rb_num_of_entries(cpu_buffer);
 }
 
+static void rb_update_remote_head(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *next, *orig;
+	int retry = 3;
+
+	orig = next = cpu_buffer->head_page;
+	rb_inc_page(&next);
+
+	/* Run after the writer */
+	while (cpu_buffer->head_page->page->time_stamp > next->page->time_stamp) {
+		rb_inc_page(&next);
+
+		rb_list_head_clear(cpu_buffer->head_page->list.prev);
+		rb_inc_page(&cpu_buffer->head_page);
+		rb_set_list_to_head(cpu_buffer->head_page->list.prev);
+
+		if (cpu_buffer->head_page == orig) {
+			if (WARN_ON_ONCE(!(--retry)))
+				return;
+		}
+	}
+
+	orig = cpu_buffer->commit_page = cpu_buffer->head_page;
+	retry = 3;
+
+	while (cpu_buffer->commit_page->page->time_stamp < next->page->time_stamp) {
+		rb_inc_page(&next);
+		rb_inc_page(&cpu_buffer->commit_page);
+
+		if (cpu_buffer->commit_page == orig) {
+			if (WARN_ON_ONCE(!(--retry)))
+				return;
+		}
+	}
+}
+
 static void rb_iter_reset(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 
+	if (cpu_buffer->remote) {
+		rb_read_remote_meta_page(cpu_buffer);
+		rb_update_remote_head(cpu_buffer);
+	}
+
 	/* Iterator usage is expected to have record disabled */
 	iter->head_page = cpu_buffer->reader_page;
 	iter->head = cpu_buffer->reader_page->read;
@@ -5521,7 +5562,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 static struct buffer_page *
 __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *new_reader, *prev_reader;
+	struct buffer_page *new_reader, *prev_reader, *prev_head, *new_head, *last;
 
 	if (!rb_read_remote_meta_page(cpu_buffer))
 		return NULL;
@@ -5545,10 +5586,32 @@ __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 
 	WARN_ON_ONCE(prev_reader == new_reader);
 
-	cpu_buffer->reader_page->page = new_reader->page;
-	cpu_buffer->reader_page->id = new_reader->id;
-	cpu_buffer->reader_page->read = 0;
-	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	prev_head = new_reader;  /* New reader was also the previous head */
+	new_head = prev_head;
+	rb_inc_page(&new_head);
+	last = prev_head;
+	rb_dec_page(&last);
+
+	/* Clear the old HEAD flag */
+	rb_list_head_clear(cpu_buffer->head_page->list.prev);
+
+	prev_reader->list.next = prev_head->list.next;
+	prev_reader->list.prev = prev_head->list.prev;
+
+	/* Swap prev_reader with new_reader */
+	last->list.next = &prev_reader->list;
+	new_head->list.prev = &prev_reader->list;
+
+	new_reader->list.prev = &new_reader->list;
+	new_reader->list.next = &new_head->list;
+
+	/* Reactivate the HEAD flag */
+	rb_set_list_to_head(&last->list);
+
+	cpu_buffer->head_page = new_head;
+	cpu_buffer->reader_page = new_reader;
+	cpu_buffer->pages = &new_head->list;
+	cpu_buffer->read_stamp = new_reader->page->time_stamp;
 	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
 
 	return rb_page_size(cpu_buffer->reader_page) ? cpu_buffer->reader_page : NULL;
@@ -6132,7 +6195,7 @@ ring_buffer_read_start(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
-- 
2.53.0.rc1.225.gd81095ad13-goog

