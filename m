Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EA6248891
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498759; cv=none; b=KMJ9BBnwTWJDDpNpRxYGGaXRmROc7oeZoe3exMQest+kTnR7iA1M3lfrDLP5cWNGKeMJziq/gIueC/c9FlD2xjH8gdqeplgCylSAVzx8mJKNfd4qEN2Nhx97Sj03Zu/B0NAxefDzYSRXJRHpMC4+jT0n1lwTCClVtQ61U2yN+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498759; c=relaxed/simple;
	bh=3Gyq8aA8JN0nK+7FXBMD7LVv1KmJh45YjAAyxT/uPCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WYuDjFtEwhz+xrBNBRmfVSvwglpvwvzQPn7hn0q8AZzSrK/Obj1bKXDe7uRwRCezEVphe2JN7SWRaVRjupAdNH95Vl3QK2DryZZlQ0QKsimOMkhsPy1YVFXbHEk9wQRN7qY828sFpS18Fz5i7OjPVysnyZZdrKfccmCTe8Ivq5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NVdyX/f8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NVdyX/f8"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f44000639fso1382775f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498753; x=1760103553; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cusWrm7Pe7Vzh2zNqiDKt7LKbdzyFf6LREbhhod2FBw=;
        b=NVdyX/f8z1Uf8zorAGQCPo1Zfic8ya2azAf9+eCjzf7VsDSI9NmKsEsv28FCEIutOH
         amQBUcqAayZ9EngRMBtRCw7VJ1do9+nhdLIkzIT341bVaaA92d40o5UEd9ZLDS4uSsD9
         nLMrWbWezEpyl4XzzJKN9yzl+VCMNsApWbQ9F6Oj9Ss1R2H5zv1xczmTJ6Ozq0lnfa1B
         jE0B0QgiAxEhJsuG3YBuaivCHP/24g8ApRhq9/jkNPLkKneDqPlLKG0DBZAIoVKqOy1D
         YWjAPFcY7xGqrlCpmF/RYIX0SDkrof8sVBHG8esDt5gFFsETzKqX6BufFb1yeNayykXE
         8nNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498753; x=1760103553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cusWrm7Pe7Vzh2zNqiDKt7LKbdzyFf6LREbhhod2FBw=;
        b=gs/uScP7zT+44R90VOcwkt2EpR3A4cju3kdny+fpP76IQT/jYFmVJV6GKTXiYHbzRQ
         8u+TjxuhpD/6/61DX0CtZQm7+VOxjBpiH1oBlxWA8EDPcJOwtZWTiPRf6c1WtuhHM03y
         sRzVhMtL5p78Xw3NXdYv7PyCIITGTFqJm0yD4MXUjsMcHoTDCUuSy/vn6l535qgeU9WU
         OCdTgeYIRmHjYBJAN9E3Icy6kVS9xSK5zfNxR6pDnb9gTi6QayIpakQ7Rzk3m/gXF84L
         H9xIF2S3CzPooLNb8g6gsFrc/HZdmse2oWfGv0yUN/v+IUBclsNsxEKvGitFsDtbCHYM
         JBAQ==
X-Gm-Message-State: AOJu0YyDDiX3rzkuNfudTP9ycqPHSIyDfb1aRA1PhWiqd4aiNCuzAuy0
	aPguTZe6hg12OrNGRgscKa7SzPjxRgYCyNd29m1uA7c4nBqKQ+cyxuELRq3hLJjqIpuds7y+pop
	5rXWh6tVcqtjFRAlKgCguaw==
X-Google-Smtp-Source: AGHT+IF6GiKCqwKfjKEeuxZgNsXAZSGVRxvCwcB1YwHTIPjTMo5AijDWEtVQrQi9EZhBvqgSIyLZKQ4QheeyH+xU
X-Received: from wmby13.prod.google.com ([2002:a05:600c:c04d:b0:46e:3771:b9c9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a9:b0:404:ac77:6598 with SMTP id ffacd0b85a97d-4256713ac9dmr2185339f8f.11.1759498753278;
 Fri, 03 Oct 2025 06:39:13 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:14 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-18-vdonnefort@google.com>
Subject: [PATCH v7 17/28] tracing: load/unload page callbacks for simple_ring_buffer
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
index f324df2f875b..ecd0e988c699 100644
--- a/include/linux/simple_ring_buffer.h
+++ b/include/linux/simple_ring_buffer.h
@@ -110,4 +110,11 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer);
  */
 int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer);
 
+int __simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer,
+			      struct simple_buffer_page *bpages,
+			      const struct ring_buffer_desc *desc,
+			      void *(*load_page)(unsigned long va),
+			      void (*unload_page)(void *va));
+void __simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer,
+				 void (*unload_page)(void *));
 #endif
diff --git a/kernel/trace/simple_ring_buffer.c b/kernel/trace/simple_ring_buffer.c
index 20e3cd6071a2..c2ec6017c37c 100644
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
@@ -338,10 +338,15 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer)
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
 
 	/* At least 1 reader page and two pages in the ring-buffer */
@@ -350,15 +355,22 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 
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
@@ -368,7 +380,13 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
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
@@ -377,6 +395,14 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
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
@@ -384,19 +410,46 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
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
 	cpu_buffer->bpages = NULL;
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
2.51.0.618.g983fd99d29-goog

