Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED4B3019BB
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508333; cv=none; b=XmAogLAveRR24Rfcp/kc4oIsdk9TSh7DzsyXrlRkIYbzSd6cw6e8q1sdQ744zYtRbovSExlWDhRL29GnY0XCvT7oru4WUKu4Dp/wNyfI+aUhqv9nPQ1ebdW3Mumuwq9VNVoLx4XCVs0DWDdV7H24uoJAMCUHZG674WKEPNcTjH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508333; c=relaxed/simple;
	bh=sj8G0CUoartcPxXFAdQJrVtMlCMU5/QlpoX3U8XHqGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iOi5KTONBBstJKJUMKG/00Qa3P1atoOB0FLQq6MiPwAnVoFmHpf/CPDqLDc9/5WCiacoNb0SB28eHxvlY5dGIBfvIe8MsCvgZ40iHaMVlButgJDBfHzbMPu4T8sZcLk+fMUyWP24KxiZdzKY8tJrMMD3COhFklYrvuPpwt1p078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C+S88PTN; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C+S88PTN"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-471001b980eso4099855e9.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508330; x=1763113130; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dE9bbheCp9V2aFuRlDh4WDEP/Ei7sW5/5LGgdkpufdc=;
        b=C+S88PTN0f/6SSS2NUVi6o0c86cb7DQSxJMtbcERB3y8XYg5Td+pZyrlCRcdsSMEeR
         2RZrkE972mbjmBQxmC91mi2JcG0dE6GAX7ogHKLx2qKZWP1lmgUJj4q0Tj0O0NlQzNTC
         F8lgW/fltvrxzqT3He7PzLSQcQ2oRDupRYYllgpjR/B2t765oeqgKrC+d8DdQdWduS5V
         IvGyaRGvXhr+rSyYjisshvoPf/MC6BtUpSDwVnlSgbwSjrEHYAHG1uGpj01bw5u0Iooq
         UQ+RAEdnQpEsF/j8AmuLFjJeQv3ZLoFO6BOji7fhsLb91vMaR75nKhDcv19sbfQCTgh8
         S+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508330; x=1763113130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dE9bbheCp9V2aFuRlDh4WDEP/Ei7sW5/5LGgdkpufdc=;
        b=KyX08ilGyc+MIYfMacyjDN2sMkUCxrYe/DqUAVnAkon2XA+fbVf6ONUyhroWnWSy6g
         SJQiusiOpYZOQ16VTDOs+SK8c6gDosbFA18f1zuCILIUL/LmQ9QIeK784nslj8zcjkEg
         Tu6+C1R8lsgRzrN4mZZdZeAu2xdSB5kggdvftZMO2UJNRMHgwyEA7IGT4pfz9hKx/S4d
         Dv6gcRsPIHb9xZDjS+ollZR+hcAHTEPmma1zHlZlOTgAWnsGIZVfhae2pziKxrafNZmS
         IQZ7LBxpUor6fcuWHN50ACQk4NiIvZcO8d8EHLmeNTxEqKAqnrBTRmeBXbWmhVAaetdq
         L0uA==
X-Gm-Message-State: AOJu0YwSTpEVcR5Tt1W/9O2DKcs01l6SCnnZs5ibXoifWW/rAzVXvjPY
	KGl89fk3b97sNnj6j/pEfWZ7tWpTltLchZdRNTZVjrt3v1oSkmeEimdah+VUx2XjhuiNfwi5+6c
	s4mUdb5ptJ4fqRDdGWrD8+w==
X-Google-Smtp-Source: AGHT+IHJKQcuTuHVy5lW9/pddPtXEWrJkUHRKDzcCdWDYQlwal5t/VwhJiu80ev0kYlXjbKdm3HJXTGh6pg8IuqO
X-Received: from wmim9.prod.google.com ([2002:a7b:cb89:0:b0:46e:1f26:9212])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4512:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-4776bce1ae8mr18497205e9.25.1762508330429;
 Fri, 07 Nov 2025 01:38:50 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:14 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-3-vdonnefort@google.com>
Subject: [PATCH v8 02/28] ring-buffer: Store bpage pointers into subbuf_ids
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
index 6e912527e44f..80099a8b2495 100644
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
2.51.2.1041.gc1ab5b90ca-goog

