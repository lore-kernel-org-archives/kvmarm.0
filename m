Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863AC1B6D06
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498742; cv=none; b=jW98p+/MyRPcso2klCgtTfJY/g+9VjpGB9sbFydrRAR2dUws/sjTBYF8x69BWtJnxKKlCKyP7YftF7LAJIFvlfFpumP5djHVfgJrRNsgmXs8Ljp82baAJi2dsCvqHGPhkhy1E0V/cp1v6pZEzuULb0wE/moNeTPe4HiYFB77G10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498742; c=relaxed/simple;
	bh=Axj9ASylM0oaMpSPEZroxhw8H/MRLAYh+XigJLXbiIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qMC8lS4V9RuXUVH6Bz17+9lV8wkBWnZNTkHHa3RV1ahxNCTIZfA2+D79SwYu3FlbzjpQ4MmIeuKcUaJHjpL3D743ol2AwfGZ4v11HRdRB+GMQuGTsSYNkZMAI9WQCyFdSDuLI6rlda5yMSPh+LwXSV9iT3k4lAsPYKgVpaRVT+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tijjSwrG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tijjSwrG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso16513325e9.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498739; x=1760103539; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bc6LimOXID+Bku1FEoRJ/EirmTeTKYklVJFEb8YK50Y=;
        b=tijjSwrGByeixqCIQuRGmU5uOVDGGFEkIT1bVPJ7Ozy7UCvSbd5eJp4C4oKOS7fLIj
         3Ht25csfMIZvHe+yi/b5JWCj3X6VPpOqfIkC5E9OSdc/RSN9RpSgeV+JZuB13g8Y4lIx
         sH1P2yuIjb4CyzPJ8o2nD9BOwrdQKq/1DqIrleBXI85r+wt9rQ0K0Lzacj0vUbhJcq1t
         1UiRpzoR/AwSjyYE4v2dZIzjYeDRW3tQekGPtAjF45tM822aTRLhBvhnkKOnu/1T/tCQ
         dXvsqZkv5UczpwATPf5JsCtSf1gfzntVg80wsez8Bnl2mvnhS7FQXOXV38+tvLjD/bII
         uQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498739; x=1760103539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc6LimOXID+Bku1FEoRJ/EirmTeTKYklVJFEb8YK50Y=;
        b=WukmKqxi0Oj2HMr7kzuKVV5QY4F8U2NmjW+SvOAbETZBxwxCZ4Rgsl/ZLOTTdWWp9e
         XIR2PmT4JZ79tbxXBKuzuckft6H8Np+gxLP6hpTeGISfadRed4oBrMgyEGi/zWxZ6893
         G5epBh67mxbuJEzGUIkMdvBJ+njJmn/f83n8LCJyDLeZ+3BI1I8hTKceWbCaIJYRDDO3
         8FhNPocCiTzBFuLnxm8U00hPtnH01J1N4cWakq5WRkY7y3kLEiS8jdzPVkZU3mT30Zei
         /SRs5kHlPE3InoA5sTeA4dIxotZh4jvKMnf9vMzIZ/bcoGehP5IwittDXaACwk6smf2Q
         QKPw==
X-Gm-Message-State: AOJu0Yzb1qMBE+NjZjTci689+yeRTXIV/XUts8qm2w7CoONwARKd9QTD
	b+j58SOdDJiMLihMy16NMabKCHIxgSSnVKFponxfDPm3JcGR4u/iDNnGnqDYvc5cSpaTFQtOGsY
	zt4PdypD2MUsN/XgYCP2RKQ==
X-Google-Smtp-Source: AGHT+IFA6VPDBbC1e+6gIWe9mwwubSc0dOt0/SMKjx4g1e9RJBwOm822bx7bReAGfXOd+prKSqJyKXuvGPwSOwjw
X-Received: from wmbjv25.prod.google.com ([2002:a05:600c:5719:b0:46e:2640:aa83])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc8:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-46e7110adfcmr22140975e9.12.1759498738728;
 Fri, 03 Oct 2025 06:38:58 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:37:59 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-3-vdonnefort@google.com>
Subject: [PATCH v7 02/28] ring-buffer: Store bpage pointers into subbuf_ids
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

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2c157cb86989..e5846f8f3c07 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -519,7 +519,7 @@ struct ring_buffer_per_cpu {
 	unsigned int			mapped;
 	unsigned int			user_mapped;	/* user space mapping */
 	struct mutex			mapping_lock;
-	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
+	struct buffer_page		**subbuf_ids;	/* ID to subbuf VA */
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_cpu_meta	*ring_meta;
 
@@ -7002,7 +7002,7 @@ static void rb_free_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
-				   unsigned long *subbuf_ids)
+				   struct buffer_page **subbuf_ids)
 {
 	struct trace_buffer_meta *meta = cpu_buffer->meta_page;
 	unsigned int nr_subbufs = cpu_buffer->nr_pages + 1;
@@ -7011,7 +7011,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 	int id = 0;
 
 	id = rb_page_id(cpu_buffer, cpu_buffer->reader_page, id);
-	subbuf_ids[id++] = (unsigned long)cpu_buffer->reader_page->page;
+	subbuf_ids[id++] = cpu_buffer->reader_page;
 	cnt++;
 
 	first_subbuf = subbuf = rb_set_head_page(cpu_buffer);
@@ -7021,7 +7021,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 		if (WARN_ON(id >= nr_subbufs))
 			break;
 
-		subbuf_ids[id] = (unsigned long)subbuf->page;
+		subbuf_ids[id] = subbuf;
 
 		rb_inc_page(&subbuf);
 		id++;
@@ -7030,7 +7030,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 
 	WARN_ON(cnt != nr_subbufs);
 
-	/* install subbuf ID to kern VA translation */
+	/* install subbuf ID to bpage translation */
 	cpu_buffer->subbuf_ids = subbuf_ids;
 
 	meta->meta_struct_len = sizeof(*meta);
@@ -7186,13 +7186,15 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
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
@@ -7219,7 +7221,8 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long flags, *subbuf_ids;
+	struct buffer_page **subbuf_ids;
+	unsigned long flags;
 	int err;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -7243,7 +7246,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	if (err)
 		return err;
 
-	/* subbuf_ids include the reader while nr_pages does not */
+	/* subbuf_ids includes the reader while nr_pages does not */
 	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
 	if (!subbuf_ids) {
 		rb_free_meta_page(cpu_buffer);
-- 
2.51.0.618.g983fd99d29-goog

