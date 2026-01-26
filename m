Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073E0331A48
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424273; cv=none; b=NSlgYevHArQDOHfIc8luoFGKoD1WicWU5UlB0RDXEfmM785U1qmxBpiVdO3K8EO6tk97N8VXjhJ4hjVrVXwYgdVmqinGxa8mWYvV+4dbWCyph8SmGmkvM2y2bp0puj17h2E5guB/1xBbAJpZ5UxF36/zeuwzrOBwVA5hGnjhMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424273; c=relaxed/simple;
	bh=8F58iQMB4tBPv70sAm1v5E47V6FBgfk4KenF4H6rNnM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uCjGHwRq68HvS6IQdD4zGEWA9ytOg1cttqrZbMyfNjtQVK+0GAMxO0HppvXPzxGcejUBL7zcbAUgI7G9qagcKlGCn4wI0UidLaiBsGLr9UnvEg0odvkKvEXvAi/RBJRRZNzF1CmmNEvvq4nmMaBLusd2XK+9K4M5cuoTWNcr2L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lopugtHL; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lopugtHL"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b870d3327baso336326066b.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424270; x=1770029070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7OmHJweSyCaZn58+xoi2Pzi5D+f/3kb8/kFIARNGu9Y=;
        b=lopugtHLXSviLbTEDFHWugT0DwwhrFgDumIZwMjZGKAi5vQef+8+GlH2MEPoUkSKyn
         buL/KY27awENSy2zselx86GgWzUAVifJs8dlunRKbaNg2pz5yhtnUjvpfZYI7JbvlksS
         c3ydVPMFyHJbsWhWo/nIO/ZUxq/13y5ZQN3B13MUt5+6NZ2sM0GKsy2x/yEsXRvaDebG
         i5IPgh7JsUZxv0fMdulFPBS+jnQYQmm0efV/fK1vNqHtA1WxIRaGEa6TMLy32Ln1Qyy9
         Vdjo0DrzYHiIQt1KjlEF09uefthlDBxb7O3Gdi05/E3o97Tzz3I/vY5cp6GDfl1FoTO+
         pVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424270; x=1770029070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7OmHJweSyCaZn58+xoi2Pzi5D+f/3kb8/kFIARNGu9Y=;
        b=rx61g707teX/Tmv7NgXnhft+dnp58azTlmI3PTjfD5Q/Y77zjoVP7d4wTIUstKMrdk
         CdY07buzgB5uVe8CsQMH6aNJOWVtYgviajQq0dheIoN+ZNWZkjFMLbgq7SIleSjBE0lB
         Tt8N2P5Sis3n4Zvq86Wc09ykUf+c54lgLwlKm5XNb7p6H8hsRVgzjqU0q6oeGbTcPMvi
         uZPIDsoClmYqssLl2LDdeC2WKF0o/TDUOxiBh4yR6qNscO+Nn3gv4RyPSgC75IsjXHi2
         bYoI9kYxw1ozdenvypNq9W8Tm9yggw2f415nkiYoZdP9c9dxY6DZygb7kllzwMW6qcPa
         U8Yg==
X-Gm-Message-State: AOJu0YwmWAqWvcDb4xsNuQYB+k6KmqT7YIF/VeQx3Rylf3LAWUXQd15+
	1bocOqb0LQgQXV9u6v4aF317kHkqK+Ef60p4WhKy2/VCdvUFDz8m3b60o7hzOf2SqL2hOzRWJFt
	Kk1BfUFDhCmD2nV2tPLDtBQ==
X-Received: from ejbgc18.prod.google.com ([2002:a17:906:c8d2:b0:b88:4972:40aa])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c10:b0:b73:4d06:bc8 with SMTP id a640c23a62f3a-b8d4f796f90mr289787966b.53.1769424270027;
 Mon, 26 Jan 2026 02:44:30 -0800 (PST)
Date: Mon, 26 Jan 2026 10:43:53 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-5-vdonnefort@google.com>
Subject: [PATCH v10 04/30] ring-buffer: Add non-consuming read for ring-buffer remotes
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
2.52.0.457.g6b5491de43-goog

