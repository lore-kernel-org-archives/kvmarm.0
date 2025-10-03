Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F51F1306
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498744; cv=none; b=iNTPxR2FLv11YKdhVoFeCTy+aSHEtQiX4784FkYN0UCEPceKcQM9v1XbGerGhUsFxz3IY5GCW0Ru79El9fwpdfE6bGb6VcTvx2zYNH1Uknbg3g0eWVvDK16tV4ZVKTkY3MWjCONyK98l5MBQzniUyrKmGZ1f8OwJB+c6t+hb/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498744; c=relaxed/simple;
	bh=XRylxRegtzNDYd9BgfEEjeSNPLRLZezIsWEeEyVhZYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p66+ZvsebQOs3b0PS6B02fIuU5zzYNKeHinPh6ioseCBvjq8gKQU+IjAe8/TdGjiYvxUjTW9xcdp9PBjvFNl8GMwBPdSlpcye/YZ6EVIgLMsQaL/pnK9RgD5R0FBZPz2Wq22okq2HBCK6AWEBuNo9XE1k8BhWdjb/IST1a89HRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTs9sqj1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTs9sqj1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso8885355e9.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498741; x=1760103541; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeES3oT5PyEYk0S7oFEzISO9wFmxktxYre//FfeIR3c=;
        b=tTs9sqj1SW/9+m2gd4nIBLdtBzBxjz4VfP2X+cke+GC67vF/kjqkifIBHPuVBVEy41
         OeOz9Wwq/TDjdIJQE+FbHmvchh+pQL587xdfv9RI8tRgST5XxQxlc/g10Ux8pDcR6nAY
         pgZTcQDIGOVLcGOJr8Ss11dQvL9m9KfxcCZ3rfP+rLAoqz4yFOkTwqp0MDDaHjQWux/f
         8799gZd6zLONiuLW+R97pM7q65Zc+83Ov1uFIrvH7zVpeTcE32/kJNTT0N89lqqBCmZJ
         ymsg/wtTcGfAj+pOcP8QGg0Bbl0+uk24tw7y97T5xAc5EbiXwpnlCdV2VFxeV49gn5lx
         DnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498741; x=1760103541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OeES3oT5PyEYk0S7oFEzISO9wFmxktxYre//FfeIR3c=;
        b=Y3x/ydzCo79HW1gWibNV1quDcG/0tlnrGjlCDTa5CroJf/oC2/jIE3H037NC6oB7Ko
         oCnWPJVl4OIf7JditAuucEHOS71tQrxpBj65dC/7h3y39EwZZ8xZgJEmaj9sk853ENpL
         a1CZrYaGpeSjj+klu1xwoeBURO3cRZajk0fv6so8wVChIICj6PU9RWz6iNJLE3XSe4Yn
         b9SSRYYXsB/mZf+CXKumGlBdTPG5dlXhrbe1hDMT/cUQ+KpolLBUxg8w94gCV0PBVGFl
         BbSkVL+cwxAohD4238aX47jPCu1zRdpGszKWPMIiFG5FlQP4vmQywqW/plBx6j8Umc4u
         Kedg==
X-Gm-Message-State: AOJu0Yz/InSEFz7FBPTW90cnjrP6rZ22Wu8EylEDcoqnPKDgANo5WD0W
	77pDSPavo4PLxC+nRcyyY2DYTa/+mzbfeoHkKNWwyu3KlAFJH60pIj3lmI+DnaG/pjAV7i2pfqn
	LGp3yTKp+6IRFr1Wpx1hEgw==
X-Google-Smtp-Source: AGHT+IGobet5rQpznC+XIhmKIJiRNYXHbeaHBHQTmrC1zAJ4pbkMbv8NZ8mLtntgHPeO+O/7sVs17qI0/PPoX2Bh
X-Received: from wmoo17.prod.google.com ([2002:a05:600d:111:b0:46e:1bcf:3f8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8185:b0:468:7a5a:1494 with SMTP id 5b1f17b1804b1-46e710f6c7amr19128115e9.1.1759498740786;
 Fri, 03 Oct 2025 06:39:00 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:01 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-5-vdonnefort@google.com>
Subject: [PATCH v7 04/28] ring-buffer: Add non-consuming read for ring-buffer remotes
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
index 54f3f47b392b..eb556e691b5e 100644
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
2.51.0.618.g983fd99d29-goog

