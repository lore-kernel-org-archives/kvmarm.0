Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2F6344D81
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807759; cv=none; b=Jff5srSVKCeCWNZLnI12YFFnkNk+X5PhyGHSmi8sf1pDg/d+/LpurP+XYEUtcxJMlIU9hCZStw2Th9ykO7Gz250zKuLVlgvliaxR9/Oum16K//2XouVPYX2pmPpwHdyN8CQhri5NhTMyeDN+fUOJQBLiOnrcRNmVxSE13qoieb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807759; c=relaxed/simple;
	bh=D4gaKwLVIIsxcpxTwTQ6S3QUNIVaidgJpeYUAPhqmYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MtTzValgT6wMM0y3qbNfr+bnD4YVP22eS4PQe269Ac9JLl8icUwtYRYm1wGszzclkmmeGd4iqbwlBnQLA5OUqTJQqbaMXO4A80BFf1A6O8+rx5YR5U9l9fw9J99p42yk1ILPfni9nM1R6Afg8dC3HcI3gUgEz0V2L8BsuY6sKXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QBsU38Oi; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QBsU38Oi"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439d74ebf89so1273937f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807756; x=1773412556; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ScN1NtxqIf/BVWk6GfS8Edcv4lujSSl4suwU/Na612k=;
        b=QBsU38OilQIUs4bJUbvY2ojhi/rcDW5ciRb9fsqPR6XK0dHXX7+T18q14N+ErhygL2
         cnQMCl6/jMkuu2Ik+ivStdwXQpv83GYO1MCm8sJyBmHd5cwoZDk/MGp1FRd/P3OnCfHw
         YMdiqJRzWHnkBhHp7N+b36DbGBzmcZ/xt8qxl06UhmhstAD8uOnWNAwOcq5ka336RIMb
         HMkOUl31nvWOa5ribPZRUQpE1J/4GsVv7R2LCx2V8JjOdQJwF5yUA9GUNPZtDNKokrCx
         nbrjP3837vKQo9i9DiIFYi7LUVoTBJpxFOhTO0ntvT0ePJSpSlr19OkDJeWdssk9wdBl
         sGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807756; x=1773412556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ScN1NtxqIf/BVWk6GfS8Edcv4lujSSl4suwU/Na612k=;
        b=vwRgNdEr552LXb6yXrkmL2FtxSAeNUw+AzvzeOVmGeIzKpTHYqYWmw5fB0W5XabsrT
         0t6AXeBOGmfQzVO9TX0yxUFrCWiy2Xl+gEQVwVXRBO2o3sz9a5D98i8x1v1C6s8aWNUi
         mc7jqFpk+EObscFMXRZsKKRHFBl7pibuo1xC/8uqkuELdGhStIu3h0fk9EQj97unswRB
         iSY+zzFNvHrbBHOZPqaAK8pJ2cIZqPqIz7nFR35psPKQTgTnwUUr9ZOr7a9ZSF8woWti
         s17qGl9hFekNZzmMbpQ7GBzE7dUBsIwuEX54wgD3KJfI6i1LUDNIrRX+fliFAK+pxOQK
         zJdA==
X-Gm-Message-State: AOJu0YxjpXquwNW3J6nUiHDQLLjX+vBFcYQE0fQcDCvfUkCnP5Uf4nYL
	0ta/V2tBDWYIQmiGJt7kBaz8wEM8m59rL8vVjnF0NUW63Wd7Ve64JY2t0h3TIRqv4L0wyWQuIo7
	cxX8rZFKDjTKANTxzYf9c8w==
X-Received: from wmcu23.prod.google.com ([2002:a7b:c057:0:b0:483:2758:404d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b5b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-48526927a4dmr39013355e9.15.1772807756248;
 Fri, 06 Mar 2026 06:35:56 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:08 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-5-vdonnefort@google.com>
Subject: [PATCH v13 04/32] ring-buffer: Add non-consuming read for ring-buffer remotes
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
index da0cd8e82105..115435f2e8b9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5388,10 +5388,51 @@ static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -5544,7 +5585,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 static struct buffer_page *
 __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *new_reader, *prev_reader;
+	struct buffer_page *new_reader, *prev_reader, *prev_head, *new_head, *last;
 
 	if (!rb_read_remote_meta_page(cpu_buffer))
 		return NULL;
@@ -5568,10 +5609,32 @@ __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 
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
@@ -6155,7 +6218,7 @@ ring_buffer_read_start(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	iter = kzalloc_obj(*iter, flags);
-- 
2.53.0.473.g4a7958ca14-goog

