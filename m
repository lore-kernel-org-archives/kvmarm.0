Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36EA3E8C4F
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073582; cv=none; b=gp9FrE9L3PCCXEWoyTFvykY/vcsdwqc8yaVjHFNHL6xxhGqxwESNzzvpn0YKTvkCLuvUH4tJ61K/7on/fpNTTgeZwAtveSCGGiC03gyaM8Ze24jV5HVqKRXTF5F4tRmtMc+fo2jS9WKVx+SlB3zfRlKloMElGauuJ701vBFZS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073582; c=relaxed/simple;
	bh=Jp/JRHhovKqXYlmtWvfEyNpyPkJYjfLK/98vY6yVHro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdSc97uo9q3UMiGZITGzTrWYJwpdS2J1i3+NTHmlT2zcWMvewF1a+prBtdQV72YeOJOaB0TlghXUF9IlwyhFlOxwOBHj4lN97cIlvC0K/v0sfS3IZUEZv9uM8f8YzJYFfEZuBMjXFuOSuKPydkGeHnD3c4F1dXvfXxB7Zls52bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oWKwq38y; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oWKwq38y"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b9410af72c3so518120666b.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073578; x=1773678378; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aYLWsoQ02WLCqnUt0cBCdmffcm851eUUlDHUboLm26o=;
        b=oWKwq38yH4snOzy8TGwEde0LbAPkUPAmYXqR8NH30tVZbvDbY1/mYRxsiAKGprhyXZ
         VC+0dvi4WkNycCXkqdl3N/xbwSIJ13nouEEjj66tgWBZj7Xs0ocQwy5WWnH/Xq5PV3tp
         vEhO/HgJKNk37FIB/vm3dQBgC63na1nOUQ0tRqS/tiMhGGE7n0l7RBSA0PYjiv4G5DxW
         +numfa1iRkQdVQ7rf9dbnp8fN6lBmQw79qubrBk0gpiG3FKmuabTat6g/z1RBl/yerpX
         0V1nqmFl4AITYS49wZQZWROpetxaQnRhPBPC6ai5NvVDF3XRmd2mUnNIPfX73V1yf1+5
         52eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073578; x=1773678378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYLWsoQ02WLCqnUt0cBCdmffcm851eUUlDHUboLm26o=;
        b=TDB3HvurmQygKQtIaLzta7XrvxTJRRRMlADvbCJPazsYb24cFlxhqJhdaYZfA95NfZ
         K8lxPNuQdjB+1iF+ACJwTj5J2Eau8MpP4neRs4Q6N6gkEF/TlasQ0pqB69HCP86y1mPa
         jT972yGm5HzpIEK92J+ok4UnB2QFH4TXyr5XDUmkDzZOu3uX4mK8MdQAbasUsiniiHAs
         AY2ACruFmk7MTDyTaH1LcHnNxUHqgoYSmbCIIJ0SoL3Im6Xc/7Bp/0uKvSKjvUf3Actb
         Kamj8F7xgeP1XsmDm0prA4uvKAtSRAwxmJHhJwrfWp+t/Dz/OXMXjvyLKDqvBP5tT5/4
         6HTA==
X-Gm-Message-State: AOJu0YzavjbbiFdWWxqfiWJGGnif89CQLP2J/cATEdJX1twJoIpC6uzT
	tO7VvW9IgSPbkiI9kyd19EYjFaNBc5WXaP07FUZiajC3mz4NhVqM/Z0ffedTjuG5uC6/BmRFfTP
	DGCjciycghcJr9ouGjHLKfA==
X-Received: from ejblr4.prod.google.com ([2002:a17:906:fb84:b0:b94:fb7:ac7c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9707:b0:b8a:f3c0:c09 with SMTP id a640c23a62f3a-b942dfc710cmr667325566b.59.1773073577740;
 Mon, 09 Mar 2026 09:26:17 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:03 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-18-vdonnefort@google.com>
Subject: [PATCH v14 17/30] tracing: load/unload page callbacks for simple_ring_buffer
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/simple_ring_buffer.h b/include/linux/simple_ring_buffer.h
index 2c4c0ae336bc..21aec556293e 100644
--- a/include/linux/simple_ring_buffer.h
+++ b/include/linux/simple_ring_buffer.h
@@ -54,4 +54,12 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer);
 
 int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer);
 
+int simple_ring_buffer_init_mm(struct simple_rb_per_cpu *cpu_buffer,
+			       struct simple_buffer_page *bpages,
+			       const struct ring_buffer_desc *desc,
+			       void *(*load_page)(unsigned long va),
+			       void (*unload_page)(void *va));
+
+void simple_ring_buffer_unload_mm(struct simple_rb_per_cpu *cpu_buffer,
+				  void (*unload_page)(void *));
 #endif
diff --git a/kernel/trace/simple_ring_buffer.c b/kernel/trace/simple_ring_buffer.c
index 15df9781411b..02af2297ae5a 100644
--- a/kernel/trace/simple_ring_buffer.c
+++ b/kernel/trace/simple_ring_buffer.c
@@ -71,7 +71,7 @@ static void simple_bpage_reset(struct simple_buffer_page *bpage)
 	local_set(&bpage->page->commit, 0);
 }
 
-static void simple_bpage_init(struct simple_buffer_page *bpage, unsigned long page)
+static void simple_bpage_init(struct simple_buffer_page *bpage, void *page)
 {
 	INIT_LIST_HEAD(&bpage->link);
 	bpage->page = (struct buffer_data_page *)page;
@@ -372,18 +372,15 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer)
 }
 EXPORT_SYMBOL_GPL(simple_ring_buffer_reset);
 
-/**
- * simple_ring_buffer_init - Init @cpu_buffer based on @desc
- * @cpu_buffer:	A simple_rb_per_cpu buffer to init, allocated by the caller.
- * @bpages:	Array of simple_buffer_pages, with as many elements as @desc->nr_page_va
- * @desc:	A ring_buffer_desc
- *
- * Returns 0 on success or -EINVAL if the content of @desc is invalid
- */
-int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
-			    const struct ring_buffer_desc *desc)
+int simple_ring_buffer_init_mm(struct simple_rb_per_cpu *cpu_buffer,
+			       struct simple_buffer_page *bpages,
+			       const struct ring_buffer_desc *desc,
+			       void *(*load_page)(unsigned long va),
+			       void (*unload_page)(void *va))
 {
 	struct simple_buffer_page *bpage = bpages;
+	int ret = 0;
+	void *page;
 	int i;
 
 	/* At least 1 reader page and two pages in the ring-buffer */
@@ -392,15 +389,22 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 
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
@@ -410,7 +414,13 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
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
 
 		bpage->link.next = &(bpage + 1)->link;
 		bpage->link.prev = &(bpage - 1)->link;
@@ -419,6 +429,14 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
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
 	bpage->link.next = &cpu_buffer->tail_page->link;
 	cpu_buffer->tail_page->link.prev = &bpage->link;
@@ -426,23 +444,58 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 	/* The last init'ed page points to the head page */
 	simple_bpage_set_head_link(bpage);
 
+	cpu_buffer->bpages = bpages;
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(simple_ring_buffer_init);
+
+static void *__load_page(unsigned long page)
+{
+	return (void *)page;
+}
+
+static void __unload_page(void *page) { }
 
 /**
- * simple_ring_buffer_unload - Prepare @cpu_buffer for deletion
- * @cpu_buffer:	A simple_rb_per_cpu that will be deleted.
+ * simple_ring_buffer_init - Init @cpu_buffer based on @desc
+ * @cpu_buffer:	A simple_rb_per_cpu buffer to init, allocated by the caller.
+ * @bpages:	Array of simple_buffer_pages, with as many elements as @desc->nr_page_va
+ * @desc:	A ring_buffer_desc
+ *
+ * Returns 0 on success or -EINVAL if the content of @desc is invalid
  */
-void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
+int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_buffer_page *bpages,
+			    const struct ring_buffer_desc *desc)
+{
+	return simple_ring_buffer_init_mm(cpu_buffer, bpages, desc, __load_page, __unload_page);
+}
+EXPORT_SYMBOL_GPL(simple_ring_buffer_init);
+
+void simple_ring_buffer_unload_mm(struct simple_rb_per_cpu *cpu_buffer,
+				  void (*unload_page)(void *))
 {
+	int p;
+
 	if (!simple_rb_loaded(cpu_buffer))
 		return;
 
 	simple_rb_enable_tracing(cpu_buffer, false);
 
+	unload_page(cpu_buffer->meta);
+	for (p = 0; p < cpu_buffer->nr_pages; p++)
+		unload_page(cpu_buffer->bpages[p].page);
+
 	cpu_buffer->bpages = NULL;
 }
+
+/**
+ * simple_ring_buffer_unload - Prepare @cpu_buffer for deletion
+ * @cpu_buffer:	A simple_rb_per_cpu that will be deleted.
+ */
+void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
+{
+	return simple_ring_buffer_unload_mm(cpu_buffer, __unload_page);
+}
 EXPORT_SYMBOL_GPL(simple_ring_buffer_unload);
 
 /**
-- 
2.53.0.473.g4a7958ca14-goog

