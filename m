Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E9D302143
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508335; cv=none; b=PKauypCaB9f6VZFJeM7N7QjlvWbroNJYKxsd0+ys8+1RrVskaQarjPFpHIcfU6AGSlPaT1K/ZY+BhK1xaprsFbD1b1pOPaUSSM93D3b9zf4h2gJsAph1IJ/U3JI24dnUn35CKwdxeeRn4Q5ceDk3psPMsFYhBUy8rHpJNDZqUAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508335; c=relaxed/simple;
	bh=1WHmcQZ+TEgkiwwnjfRneGhCfqlOJBiAqdvzrgfqRfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EzpShFIc0f8j5VBzJakvwoc64z9I0+Um4K41xJyZgr6gayaSAGZzcYQU1QnIppch2wknASuoEeFwJOoRBGRvh4SMk+wWM+NAWruK/W51y9HkWKr1IaLBzd0YDuJ1pIAjioxYxTluiW0MWHVn3SfqY+xrov8xV4DrOfJjSYx4qis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uvsFKc1M; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uvsFKc1M"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47769a0a13bso5373465e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508332; x=1763113132; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C27VVD3vAqywTmo/NjVnuVPbtNW3I4H1LRWKbq+VenU=;
        b=uvsFKc1MUy8RJjz0KLLIrR8SVUB0Txat8H80hpR2vnpl3pnJIAXVdh9gjo8qNeyG4y
         ouaWhb3qf4wVAbmEK0dARmCIEvvazOxg6TPYtjibPQ2N4obKvFzLeVYs+MzbeL9bhPPJ
         vTCNYyeCcNhlg969zDjkISLqkZgpPRzipCmvJTNtvng7czl10BMFEhet4qaid58IguFO
         4/0Bj3Wq/ysY5ZXoTdLApi9lYSovM+Pac1J303yEVSSTxlqd35L2If07sCnUlelTqvNB
         KCJK6wliZ/LJXCsEyRz1viixPGAhQO3Ud7KlnrssVMkGNjO3YqbX8uijv9ChDtsnGcbB
         dvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508332; x=1763113132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C27VVD3vAqywTmo/NjVnuVPbtNW3I4H1LRWKbq+VenU=;
        b=fn4623nWJ/YqTGKihiqt1f1tozPFbWOH6vCOe+H63O+mbJ9t/EtrHekO7byogyntgO
         /gcDOtPZvUIeVuB4TGSgUjxk5eSkMukB9CM5kzUkVxSjr47FyYl3jXRJO4rNaMVh9qf6
         WhoKalnmIdouFtG2ugmy/soqC07tB5PDyw6PQ7tyeV3wzd0XbL5qv0LEmmZRJetbO6F5
         eLR/OMmflk/bjIdV/rpAuhaff8vlxXrmymdsim7N9LqAXMJ9DjqncRyhxruXxE6ECXq7
         tZRMzKWuvOe0kyc9mW2ZnJcQ2daTPVtOLhOGXp046IjyuXi7UWpLLvK8zAs4CXJ3eiDS
         ut5A==
X-Gm-Message-State: AOJu0Yx5s3d3YSte/4MGyCxQCn5ZbvE0xW+2KEGi35JmzAM3cVKAMx5Q
	ETHD90wXB6lpyNr8vu+j+HvvGILGRxEJRmiXb16vtkR4TTu+gpjl4mVjBth1a0kzpyidiCH/jS/
	8FEOnYHawduPbVojg7g/9BQ==
X-Google-Smtp-Source: AGHT+IGiQlhEUR6uXQZBOgfev2nnadl/wwtET3p/vSwvp4472FXmHSv/qhH8vVord0fI+bybrIdYpQbMBbA3Mg27
X-Received: from wmbg24.prod.google.com ([2002:a05:600c:a418:b0:46e:5603:f679])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f08:b0:46e:46c7:b79a with SMTP id 5b1f17b1804b1-4776bc871e1mr20848605e9.2.1762508332036;
 Fri, 07 Nov 2025 01:38:52 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:16 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-5-vdonnefort@google.com>
Subject: [PATCH v8 04/28] ring-buffer: Add non-consuming read for ring-buffer remotes
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
index 1d300189f261..4cc5da5cdc87 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5347,10 +5347,51 @@ static bool rb_read_remote_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -5503,7 +5544,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 static struct buffer_page *
 __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *new_reader, *prev_reader;
+	struct buffer_page *new_reader, *prev_reader, *prev_head, *new_head, *last;
 
 	if (!rb_read_remote_meta_page(cpu_buffer))
 		return NULL;
@@ -5527,10 +5568,32 @@ __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 
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
@@ -6114,7 +6177,7 @@ ring_buffer_read_start(struct trace_buffer *buffer, int cpu, gfp_t flags)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask) || buffer->remote)
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	iter = kzalloc(sizeof(*iter), flags);
-- 
2.51.2.1041.gc1ab5b90ca-goog

