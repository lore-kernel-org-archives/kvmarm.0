Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C86342509
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513403; cv=none; b=PDAO/BTwINoMW6hQujJGW6mAXtMr2WYWidqLyGKsRyxLqSMH5xvOkYHaYgzViN4hZVVxE/inh30YlVBG7rWKO5Wm/ZPcATaY4tZyPQRxHkBWwCE6wPE4r/PjQkSWUkujQQ1f6D1Ppweslp1cV6b/9YdjifmaXXWD9QE5e7JacBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513403; c=relaxed/simple;
	bh=EoWxZ82AW5xJLupiOg+CFC0qrGUjxS6o93+2XTOyPJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NKZMb08jTSwrW7ojm3NZI8AZsUH/cmHb3Z6GdK57iBiLRpnBq1JDPVskril6kx6FBLjbUO6FcmkcQ1Inec+uQ0N9jJkkokyoG8g5Rk5BO2U4YoITVn4YjYPERmnmMwpL+c9M9AyFNuYp1bj0FwIqKbWMe7EGVQTH/nfWDtX1wDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vtopioe7; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vtopioe7"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8d78d3fabfso94548366b.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513400; x=1772118200; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=URJ3le00qFg4aOMtpOoA5s7sZJE+RppKHRUBLLdA0KU=;
        b=Vtopioe7Tco7MeIh+x3bZcdLCKY3CjPluqfOqpCKBEOThmB4zCJgkaVK6ePVtmwJKs
         0LRZrJ7vu8+5eiaPFCcSgj7BJFzxqsonQc4Nerbae5558ysBCk3nWiDYl495ktU0W1mm
         zC4I3kBTSL7dO8kbgd7qlp7p9lSV5T4WGHtmID7thM4K0zhXt87MYubOD47RnuTyEx22
         8TiJhaGiy1yUF9jXZ5rI9jcn0csKvnDf8NsMvMWler2a24AbWhKg/DEVN3p3tNI0owIQ
         7Jq6XSKDrMaRAE+klJo6HGGJdaFOhLMtcVc8IM2gp+Lur9YOrkjdJnb+GkckEYyWMVpy
         0D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513400; x=1772118200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URJ3le00qFg4aOMtpOoA5s7sZJE+RppKHRUBLLdA0KU=;
        b=U9JgT9AVrhUR/v+rhSTHmj7NGLhjfAcqMvwz/SF9PJnNM1EVjwwKlCZ96fAceFvKLj
         zYSJEjOAEJM4LbBCVlAIxJWaP4pMEcvtnPgYICeePtKJkxtt2he6Wmi9skHWr2sMn0nQ
         UcBtzh/wKAx0K2HDd5niEpDloQ0KTaOA8/Ua37XZ9RRC1qUnvFsXYzn323ZUhSVvSSe7
         kRGIya7pT5PXlv0DcSWmGffsbf9h+irfBzOhAW4Qa8RLo27i09xgGDEsHlUl20t3JKAS
         1OvvYIZYJDM8YuOhT66WqnVqTB0N4NjAyXHPK2nQ9K6XHBP37bXliSUhRR4KVAPKpnKB
         SWaw==
X-Gm-Message-State: AOJu0YwwTpxfOXS42hGJD9ci8Dx4MzsDmHr3n87W+S6vXoh5w5WPDauv
	8g5A+YiIZlvs2tmKSquonKtx0z6nISn8/PT6pOAugFG3oK67RNrA8JbZSNW7hG6GVEOOZiasYVY
	rqDYYzZpldyGwhLtUPmxO+g==
X-Received: from ejcm18.prod.google.com ([2002:a17:906:7d2:b0:b8f:8f61:e060])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:dc8c:b0:b7a:18ba:a63 with SMTP id a640c23a62f3a-b8fc3a3a05amr875259466b.19.1771513399894;
 Thu, 19 Feb 2026 07:03:19 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:39 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-3-vdonnefort@google.com>
Subject: [PATCH v12 02/30] ring-buffer: Store bpage pointers into subbuf_ids
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The subbuf_ids field allows to point to a specific page from the
ring-buffer based on its ID. As a preparation or the upcoming
ring-buffer remote support, point this array to the buffer_page instead
of the buffer_data_page.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 210c3811ba48..228c127b4489 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -555,7 +555,7 @@ struct ring_buffer_per_cpu {
 	unsigned int			mapped;
 	unsigned int			user_mapped;	/* user space mapping */
 	struct mutex			mapping_lock;
-	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
+	struct buffer_page		**subbuf_ids;	/* ID to subbuf VA */
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_cpu_meta	*ring_meta;
 
@@ -7031,7 +7031,7 @@ static void rb_free_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
-				   unsigned long *subbuf_ids)
+				   struct buffer_page **subbuf_ids)
 {
 	struct trace_buffer_meta *meta = cpu_buffer->meta_page;
 	unsigned int nr_subbufs = cpu_buffer->nr_pages + 1;
@@ -7040,7 +7040,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 	int id = 0;
 
 	id = rb_page_id(cpu_buffer, cpu_buffer->reader_page, id);
-	subbuf_ids[id++] = (unsigned long)cpu_buffer->reader_page->page;
+	subbuf_ids[id++] = cpu_buffer->reader_page;
 	cnt++;
 
 	first_subbuf = subbuf = rb_set_head_page(cpu_buffer);
@@ -7050,7 +7050,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 		if (WARN_ON(id >= nr_subbufs))
 			break;
 
-		subbuf_ids[id] = (unsigned long)subbuf->page;
+		subbuf_ids[id] = subbuf;
 
 		rb_inc_page(&subbuf);
 		id++;
@@ -7059,7 +7059,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 
 	WARN_ON(cnt != nr_subbufs);
 
-	/* install subbuf ID to kern VA translation */
+	/* install subbuf ID to bpage translation */
 	cpu_buffer->subbuf_ids = subbuf_ids;
 
 	meta->meta_struct_len = sizeof(*meta);
@@ -7215,13 +7215,15 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 	}
 
 	while (p < nr_pages) {
+		struct buffer_page *subbuf;
 		struct page *page;
 		int off = 0;
 
 		if (WARN_ON_ONCE(s >= nr_subbufs))
 			return -EINVAL;
 
-		page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
+		subbuf = cpu_buffer->subbuf_ids[s];
+		page = virt_to_page((void *)subbuf->page);
 
 		for (; off < (1 << (subbuf_order)); off++, page++) {
 			if (p >= nr_pages)
@@ -7248,7 +7250,8 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long flags, *subbuf_ids;
+	struct buffer_page **subbuf_ids;
+	unsigned long flags;
 	int err;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -7272,7 +7275,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	if (err)
 		return err;
 
-	/* subbuf_ids include the reader while nr_pages does not */
+	/* subbuf_ids includes the reader while nr_pages does not */
 	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
 	if (!subbuf_ids) {
 		rb_free_meta_page(cpu_buffer);
-- 
2.53.0.335.g19a08e0c02-goog

