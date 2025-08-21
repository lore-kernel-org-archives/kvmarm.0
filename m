Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4BC2ECD35
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764082; cv=none; b=fxYvQpf8IbEWFZyUalnVIjCqL9j6Lw/Svh72Tn6Lp2MRDLHKmyiVdFSIUA1Kh7a7gjWFGzK/ELxXJVZLFQWJRiFzcsu2ihoEnQPdor+IySgyMNf/YW0qMRgFiNCLW4MP+ibDDm3JLS/zpVeTEpmXU4UgsxLqRm05Y2vBcglYA+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764082; c=relaxed/simple;
	bh=tUO2Q5kcwgj+BpbC4GHZDePvRqDVxj7pmPuQyegxsiM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZzBv+cqY1/fuCw2h0gqQSd/ihSj7bH1lt0STZkFlMG0oroyfUhPjFAWzoPaCeMTBDtNjO5e7NiCsXoZCVrFAGZmFc+ijz+Sh5A8EQ0bypEu85E32ZkholwL3OPISkAvcGMz/yveMBI01ApwJ7e/DSazo4ThKA/9do412QGt6DY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O/4Kxc1u; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O/4Kxc1u"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1ac1bf0dso4185085e9.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764078; x=1756368878; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFT6WngKMwHZUnIYZ6NFySqzw0d5WuAMHkLFTx3V41Q=;
        b=O/4Kxc1uq10MbaPKmEXtlE8bpP44rH/6thm0rPI9CD9zfYk1xbWqKWETUA4FNSukvI
         ACc/GNShzrkwBnyv4g0P07BP0Nnua667K+SaMMKdSxIo8E+wnZfCwfMp0+gAdDxYjaKC
         grDoIzsfJhv2N+HC68JUANiYCRwfAkktOnvn+hNQGUvmeLi6bC9O7i5hiYM2vS9HguQy
         uo6qQSY4awqIApAIbb6ZzdFZQRvGIOqqQ2n/YyF5/8ne7r8YeSzGnFgayw6tkFZdRTN0
         ToLSxhaqv8nc/SZTaJwTqQxuGnsJhwrZl5/MtZq8x3PBwWt9oKlWK+LDf3ofrpLOgePK
         OKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764078; x=1756368878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFT6WngKMwHZUnIYZ6NFySqzw0d5WuAMHkLFTx3V41Q=;
        b=OsU//ShImAYq4gjjL9QCS+Esgy9bejs42I0vU69OzaF87VEytKzttcPQbY54TLMh5g
         kHEeZKtJShFCMAeLZmpagIaRSU9JhEjvkvh6RJ1YZ8C+PcunYUlrGIbFq6ZhErF6/BAy
         T7csF7TbaQa32kIyfYtszCwfDv2v35DPSzKWdV+84E0HNjFcoRe3CD99pNagGYG6PKGZ
         QrU8EIwCgxv/7HaURM38wd0Y2pACDX3gUsDfoH6u3elZR5ELCP1LIXOb87ehX11WTowj
         Gv+eYb0+qyclC3a03B44s9PxLjzwj/FD6c2lrGOkkxlSfs0IY0qRZITJOA/NMms+Scu/
         4Kag==
X-Gm-Message-State: AOJu0YwZKx1b4oCpm+bfoH7LEQRkSLF+NgfKK/dP8iCqLH3xXu/R+i8n
	dXDsYQg10FqUl/GrF070vkFiv1f6TmY42TDCzxMotcLfuDTmG6GrWViokh3wzs52aFZzmdKDiqb
	AMWXisQKL7g0iw3xbPpzvkw==
X-Google-Smtp-Source: AGHT+IFAQlXPyTnG3JiChKe5DFLBDr2rP8AXh2IodHFt8ePrOH2SUaDoS3AE4kl8mvBz78HTv39+GgQn9/pGZ7FM
X-Received: from wmti5.prod.google.com ([2002:a05:600c:8b85:b0:458:715c:51a1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4710:b0:456:189e:223a with SMTP id 5b1f17b1804b1-45b4d9ea7c9mr10900275e9.10.1755764078269;
 Thu, 21 Aug 2025 01:14:38 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:14:01 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-14-vdonnefort@google.com>
Subject: [PATCH v6 13/24] tracing: load/unload page callbacks for simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add load/unload callback used for each admitted page in the ring-buffer.
This will be later useful for the pKVM hypervisor which uses a different
VA space and need to dynamically map/unmap the ring-buffer pages.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/simple_ring_buffer.h b/include/linux/simple_ring_buffer.h
index d6761dc2f404..e74707f10b93 100644
--- a/include/linux/simple_ring_buffer.h
+++ b/include/linux/simple_ring_buffer.h
@@ -47,4 +47,12 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable);
 int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer);
 int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer);
+
+int __simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer,
+			      struct simple_buffer_page *bpages,
+			      const struct ring_buffer_desc *desc,
+			      void *(*load_page)(unsigned long va),
+			      void (*unload_page)(void *va));
+void __simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer,
+				 void (*unload_page)(void *));
 #endif
diff --git a/kernel/trace/simple_ring_buffer.c b/kernel/trace/simple_ring_buffer.c
index 3efdb895d77a..56b4701979ba 100644
--- a/kernel/trace/simple_ring_buffer.c
+++ b/kernel/trace/simple_ring_buffer.c
@@ -64,7 +64,7 @@ static void simple_bpage_reset(struct simple_buffer_page *bpage)
 	local_set(&bpage->page->commit, 0);
 }
 
-static void simple_bpage_init(struct simple_buffer_page *bpage, unsigned long page)
+static void simple_bpage_init(struct simple_buffer_page *bpage, void *page)
 {
 	INIT_LIST_HEAD(&bpage->list);
 	bpage->page = (struct buffer_data_page *)page;
@@ -290,10 +290,15 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer)
 	return 0;
 }
 
-int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
-			    const struct ring_buffer_desc *desc)
+int __simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer,
+			      struct simple_buffer_page *bpages,
+			      const struct ring_buffer_desc *desc,
+			      void *(*load_page)(unsigned long va),
+			      void (*unload_page)(void *va))
 {
 	struct simple_buffer_page *bpage = bpages;
+	int ret = 0;
+	void *page;
 	int i;
 
 	/* At least 1 reader page and one head */
@@ -302,15 +307,22 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 
 	memset(cpu_buffer, 0, sizeof(*cpu_buffer));
 
-	cpu_buffer->bpages = bpages;
+	cpu_buffer->meta = load_page(desc->meta_va);
+	if (!cpu_buffer->meta)
+		return -EINVAL;
 
-	cpu_buffer->meta = (void *)desc->meta_va;
 	memset(cpu_buffer->meta, 0, sizeof(*cpu_buffer->meta));
 	cpu_buffer->meta->meta_page_size = PAGE_SIZE;
 	cpu_buffer->meta->nr_subbufs = cpu_buffer->nr_pages;
 
 	/* The reader page is not part of the ring initially */
-	simple_bpage_init(bpage, desc->page_va[0]);
+	page = load_page(desc->page_va[0]);
+	if (!page) {
+		unload_page(cpu_buffer->meta);
+		return -EINVAL;
+	}
+
+	simple_bpage_init(bpage, page);
 	bpage->id = 0;
 
 	cpu_buffer->nr_pages = 1;
@@ -320,7 +332,13 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 	cpu_buffer->head_page = bpage + 1;
 
 	for (i = 1; i < desc->nr_page_va; i++) {
-		simple_bpage_init(++bpage, desc->page_va[i]);
+		page = load_page(desc->page_va[i]);
+		if (!page) {
+			ret = -EINVAL;
+			break;
+		}
+
+		simple_bpage_init(++bpage, page);
 
 		bpage->list.next = &(bpage + 1)->list;
 		bpage->list.prev = &(bpage - 1)->list;
@@ -329,6 +347,14 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 		cpu_buffer->nr_pages = i + 1;
 	}
 
+	if (ret) {
+		for (i--; i >= 0; i--)
+			unload_page((void *)desc->page_va[i]);
+		unload_page(cpu_buffer->meta);
+
+		return ret;
+	}
+
 	/* Close the ring */
 	bpage->list.next = &cpu_buffer->tail_page->list;
 	cpu_buffer->tail_page->list.prev = &bpage->list;
@@ -336,19 +362,46 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 	/* The last init'ed page points to the head page */
 	simple_bpage_set_head_link(bpage);
 
+	cpu_buffer->bpages = bpages;
+
 	return 0;
 }
 
-void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
+static void *__load_page(unsigned long page)
 {
+	return (void *)page;
+}
+
+static void __unload_page(void *page) { }
+
+int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
+			    const struct ring_buffer_desc *desc)
+{
+	return __simple_ring_buffer_init(cpu_buffer, bpages, desc, __load_page, __unload_page);
+}
+
+void __simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer,
+				 void (*unload_page)(void *))
+{
+	int p;
+
 	if (!simple_rb_loaded(cpu_buffer))
 		return;
 
 	simple_rb_enable_tracing(cpu_buffer, false);
 
+	unload_page(cpu_buffer->meta);
+	for (p = 0; p < cpu_buffer->nr_pages; p++)
+		unload_page(cpu_buffer->bpages[p].page);
+
 	cpu_buffer->bpages = 0;
 }
 
+void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
+{
+	return __simple_ring_buffer_unload(cpu_buffer, __unload_page);
+}
+
 int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable)
 {
 	if (!simple_rb_loaded(cpu_buffer))
-- 
2.51.0.rc2.233.g662b1ed5c5-goog

