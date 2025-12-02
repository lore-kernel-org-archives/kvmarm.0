Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E9C30BF6E
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668197; cv=none; b=EqRMBN72+2NCUIBKO+Yo2MtYFKRQ800Gn68oGmkcRmHYxp1xmcFh1PTlNVvbrVXW4244h2fjaWwcEhhoZkLfvJBJaagkOmC2jVCAfMp5JyG+gWRa/9+mk2OeWzkE2B3urZTD0nhYnERlX5wEWaYzfSl1RXtLnJR46hlChlO+G1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668197; c=relaxed/simple;
	bh=aQGInIrpJpA9FnPWwTp9VkPt/Pn8+5NuCILdhnrWbUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W+ga5e90iZCqR+WoB/nlQzeKSEnP6pdvt+9cT9RaJroMZ6iLGSkqQMys/6DY/Va7IuVzgFd+o2XYdqLdFaFtwQRtWTHPVz95gsqhiFIgVPLFoeuZfduy0TcigUXhiAaZ0oAehLfBUyDED1iMW1jQOeTQl5K1zLKkINCfSiQkgxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NkTjSMz5; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NkTjSMz5"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42e2d6d13d1so1486694f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668194; x=1765272994; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NaTp/V/0VQ5wl0NsKdZIsTivJaVp4Jv+4QO5H0MFmfw=;
        b=NkTjSMz5kQGLa846IpE/CtbBAsa13VwPwhAuNVcHDpvK3UY0YfGXvqBW//7OTuBZk3
         ELVLVxkqL4O/pc/OD8rbBmv3bEqIQcGi07F8Cj88MhL/W+7n8BdIc8KxwGzAeZcTxvKW
         ZOT5++IgI3iL7seSWYL1gSYPu1EBt+byEidf9QFtl9IHirSAWs18344wnxTEPppsWb6m
         f1LCfFocztpW4rNMP0p9Ra5c96STYXWkVA4GoyEWjQJe9bUNZQBb2oJQXPHbgtHZfPql
         mXXvoA+5e1sZ4+tbfqq2u8y+0A1rYX8ncsVFLAIsGZdLTmH8+aR28J43IP5NidyTS9y6
         Q17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668194; x=1765272994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NaTp/V/0VQ5wl0NsKdZIsTivJaVp4Jv+4QO5H0MFmfw=;
        b=OCSI5R192txZqf91pGMq8eR3EXDAQPYO6FGHxVsUY71D8eC1xGa7xueuzvEaKVKpmH
         ngB68uFRs26mgjHvjWUqUbmUdUQM/FQWiKU9JuaAtErxizNWZFH3E2TYgmVRg5CBr7hZ
         xYhiW0i1cAi1eTAp+Yvyfp968LrZE1kiJQ+/6Y4LyAxnCbRUMs7MBjVVKtnvMu0Vktq3
         aLBuIugS0qG8mpFOWAJuN6bdBKOa1p39wnnA/6RK9r1M/R9Menh16S3Anib+739JD/ll
         nwyjHPO1Cvtk9jMcCoQz2EUlwoF9s3WngeSmPBtW0LoCkvoukD2hYK+c2tfnVHH3RY4A
         ykkg==
X-Gm-Message-State: AOJu0YxqZ356wU8SVILb4vXfBM2vu9t8EzaqNMBsxJfKUi3+pexotmri
	oCwLelqoXenHzbZagUcoFTHilcqtBFr6gSAjtRdOE1KxVD9hS52Iw913RSNtDZoo5NKchQv5rFT
	zGt5YGAeO6lkzK8lCUm7/Cw==
X-Google-Smtp-Source: AGHT+IEO0w7C8+uzCJhGJFqeafT3tVd3XPzAjaD/lM28eUt2wOIl7EbpNMo+Y4PRXxdjJMuNc5RxsiVPK9HaRiCy
X-Received: from wruh15.prod.google.com ([2002:a5d:688f:0:b0:42b:3951:1b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5c89:0:b0:42b:5448:7b11 with SMTP id ffacd0b85a97d-42cc1cf3abdmr45886784f8f.33.1764668193695;
 Tue, 02 Dec 2025 01:36:33 -0800 (PST)
Date: Tue,  2 Dec 2025 09:35:55 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-3-vdonnefort@google.com>
Subject: [PATCH v9 02/30] ring-buffer: Store bpage pointers into subbuf_ids
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
index 048dde717b94..aeff2ce6231a 100644
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
2.52.0.107.ga0afd4fd5b-goog

