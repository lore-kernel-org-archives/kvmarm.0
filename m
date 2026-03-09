Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021FB3E8C5F
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073568; cv=none; b=R2A1AVCT/VWL01OkOymx1Dm3KwPClEQXmF5uu1eJSDwViUib1Oc/AN0yK7Ztyh9YQl1y82EPu6aV9GyaBTbOLg9KIbwhEk5r+XXJdREvabSm3QO9YvmmOD9uXqvDCl2FcmVWoBakTV9YQWmY0zATxTOOK1ikvImiVlKCY1F0AG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073568; c=relaxed/simple;
	bh=p5SQvu/UVANqQL8BXgDJUXlqRTupygiIt9VwpYvywMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sregzHmWpADrlmbVWxXEaWLOjXA7fLC2WGM/uid0DQulC0HYw/8qkqc9X7WjmUNSGYUlszw0tnxEclocqiYexznhMN8ROCzaJ2/AO7aaliEHPx6uSJpoIaUhdPF+7M8ExIodUGbZXGG1PsM92sj+quoTTDFoeCMUU/ZbqwAc5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zNwbytgs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zNwbytgs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4852d27f473so13299715e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073564; x=1773678364; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7sVpz3MVsXj7CM/t7DtIsR+dSxsITBD3+AtJrGnMJ8=;
        b=zNwbytgsA5V1PqpV6ty0BfVZJpzMD7FETQDtP+xbszLK/Y7x3v1ZnOZpUEocNHVQxE
         m4+YTaupkEzr0CBmLjpBfWPsqiWZib65dV6WxQfq/hkrEJSAM1sdeRRvc8ro+fKdrpGp
         qGzbzM4zrR1bTJM3uL1XYVzUxgtxnWCZDEUEBSXbbFhkl6tf3DklD/z8ySKl15pu+1fm
         Lp0thvynU89qFiPTiFv8xRzKw4TZPHYaynSJbOgvz73C9GdFMCLxIXassA9uZRiR/vZP
         Qzzm2cefrv0eZcb9YBOlv4jXgM5WJoa7OQMTTV7gJrxeelkfYHCB5Hh1SlRZMiTyxCl6
         UUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073564; x=1773678364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7sVpz3MVsXj7CM/t7DtIsR+dSxsITBD3+AtJrGnMJ8=;
        b=DP2CuLzLkugbfN878bU2PhaG8U0FdLR2NY20kBytKiWSHEhDad6KLoWRu/PFDOHadT
         XHbBAt05KHhDq0mXCo6dz3MoyA+SxjYSAJceHmL/6DNTWoKmv1EoFjs26eDBGyueq3fI
         IUBICMPA3soNyG2YvsalCdzIHJc5R27DH7FOW//r3sA7umsLNcQFBlXcstm4/hHhgmFU
         TEt7tuDoF0MwRDsg5lASpIg2R1Tt6qvW6y+0ptNNqkwve62aBcmn4nTaMrex35n28OQm
         zuuoC9jKymH0ZprJjDMqF2qmbzkMbr/9/oy9gMiPscaRsetLIJ3akL0BcvxeVKkPulNb
         Ylxg==
X-Gm-Message-State: AOJu0YzRCs1XBanw6XihnmfU6VA8sl1pzdSlpFRuK3/PQ4Z/1qJojUZs
	DPvXc/Q+Rpr1x9fPqGS+VTLm5sPWlyUyPU95dOWKqon8rh+uAMUe1ApyK1FQN34IjSZAD21jEC4
	BPprmdC9REHso2RbyaUcWSA==
X-Received: from wmj24.prod.google.com ([2002:a05:600c:258:b0:485:3890:399c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b0c:b0:485:17a7:b9c7 with SMTP id 5b1f17b1804b1-48526923b61mr193565395e9.10.1773073564338;
 Mon, 09 Mar 2026 09:26:04 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:24:50 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-5-vdonnefort@google.com>
Subject: [PATCH v14 04/30] ring-buffer: Add non-consuming read for ring-buffer remotes
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
index 88218377fa29..fb39dd43e00b 100644
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

