Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC78B289823
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550136; cv=none; b=ekmwLNRfeeaRkcZNusZbp9jx1u2QkD2vtC/wOIBps8aZp6Vv0Pbk9yrxOphMb9Ivt9lbLvOooek/6Y4seK+1jFHr8xNZZ8F2WK5GIkXFz7S6nbRnRKgydNrs0HZpkabWngCgJTXv9AlqaFL5d5mkDv2e7xO6LWmoiS3AJJyY96o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550136; c=relaxed/simple;
	bh=P5fqf7GLSzb7bwzSSyJnj5fukWX4Yfbn+JGf94Z5P6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EqjG4KkTpKCrpmRmptmUHCZ6whX2cThvruwpSt7YbiTnHbWkslyQJrIJ2Gvbi+ELSYEBhWunC0V+JjKzfVEWoANdRR/U0PaiINlojqNS6L8YFR7UxcGaectFo9+ooiEmDLICxjtgT5QWrcHjXw9ga73tsm0IWw2RbGCXTn3B6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQ0+dgR/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQ0+dgR/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43eed325461so32709915e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550133; x=1747154933; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0lEPcVl31Ep+ZkAHQCvo9hIAtaxt0RYlv/tYPLRXN4=;
        b=kQ0+dgR/lr7dUW8IfuLTtHnLgwQdiH4eqNza3rPVlsblJwj/8O7VtThBAPITTl+iGK
         1NAszv7v2Z9DTkRd6/qPpCYkhusEtypm0S6v7fFU4SthAPb237EKI/TFduBCt3n7iI54
         BN7l0mZ8kJnr2xeKoVnMdN/Pv/MXQXg4xhuRk7yCzmbSvetC1mbWNttWEiFqx8KqlEtB
         JCc2Rh55vd3H1S9MGJ/4/Q7hp840uXeduj82ivAQPIU1ToK/Ik8JJD6ESMsUpMTEJ5Ba
         H4Gc8dk+HfsuBEnr+ioVKHHnQ2qXH9rc4I9hRyOM8cyf21Rjoh8adX5S7/9v0Chj/7OF
         nhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550133; x=1747154933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0lEPcVl31Ep+ZkAHQCvo9hIAtaxt0RYlv/tYPLRXN4=;
        b=p0KePQ8WnBOYmXW+XQakDjg25nTnKX4pMWBwGNgppQUOq5q9wLRsNtEXIB8ueBs7g6
         UgPRZdyZfEFU/pcqy2hb8CtCAEQu14zxVuH2gEbQ/YDVuqUpyW1zRkYNu2XhAqeUL3+Q
         cZczwcDKFvuhRoToDoVt5c8yVqf43SlnZgbSCNa73Z+FK/RgIUZeiwtR1/TmdXtMLBGo
         M/WKnVEZo/1cK+wlv/5LBmgA3eq0dzS6qOLo5y3GKOfjBj9VtI7qJ3JhU+DbINjZtSSV
         XFKbbSFpchP0sCZBhnJwUZy8fCmLV0Qj3AevBSOlJoJb0GRgYBNU6r+ADQgZAbTGDn3B
         QpUQ==
X-Gm-Message-State: AOJu0Yzx8U5nYKzukoCLD6sguK/gXwUZArpF2BepRNHXOgh6YB5PgWTs
	7HzUOMrkmAi0HVS7QKURodI6jXExuVJjxx7eWZ4TSLW/tfK7lBdYC/r2LuQyZZzBk9NeFVQrBR9
	2TUpZu0VQpPi6mXHL2w==
X-Google-Smtp-Source: AGHT+IGq1vAJ+GKWhJtsv/JkxJGIe/fYEg66JYCRx2JA9lFVNOYu2CXLapcz44nyPnWBPM6MV8fK/V35DhKZhEiX
X-Received: from wmbfp20.prod.google.com ([2002:a05:600c:6994:b0:43c:f5b8:aad0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a4c:b0:43c:f8fc:f69a with SMTP id 5b1f17b1804b1-441d04f45b7mr38855715e9.4.1746550133269;
 Tue, 06 May 2025 09:48:53 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:04 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-9-vdonnefort@google.com>
Subject: [PATCH v4 08/24] ring-buffer: Expose buffer_data_page material
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allowing the write of ring-buffer compliant pages
outside of ring_buffer.c, move buffer_data_page and timestamps
encoding functions into the publicly available ring_buffer.h.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index c0c7f8a0dcb3..c26fba4a643c 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -3,8 +3,10 @@
 #define _LINUX_RING_BUFFER_H
 
 #include <linux/mm.h>
-#include <linux/seq_file.h>
 #include <linux/poll.h>
+#include <linux/seq_file.h>
+
+#include <asm/local.h>
 
 #include <uapi/linux/trace_mmap.h>
 
@@ -61,11 +63,46 @@ enum ring_buffer_type {
 	RINGBUF_TYPE_TIME_STAMP,
 };
 
+#define TS_SHIFT        27
+#define TS_MASK         ((1ULL << TS_SHIFT) - 1)
+#define TS_DELTA_TEST   (~TS_MASK)
+
+/*
+ * We need to fit the time_stamp delta into 27 bits.
+ */
+static inline bool test_time_stamp(u64 delta)
+{
+	return !!(delta & TS_DELTA_TEST);
+}
+
 unsigned ring_buffer_event_length(struct ring_buffer_event *event);
 void *ring_buffer_event_data(struct ring_buffer_event *event);
 u64 ring_buffer_event_time_stamp(struct trace_buffer *buffer,
 				 struct ring_buffer_event *event);
 
+#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
+
+#define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
+#define RB_ALIGNMENT		4U
+#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+#define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
+
+#ifndef CONFIG_HAVE_64BIT_ALIGNED_ACCESS
+# define RB_FORCE_8BYTE_ALIGNMENT	0
+# define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
+#else
+# define RB_FORCE_8BYTE_ALIGNMENT	1
+# define RB_ARCH_ALIGNMENT		8U
+#endif
+
+#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
+
+struct buffer_data_page {
+	u64		 time_stamp;	/* page time stamp */
+	local_t		 commit;	/* write committed index */
+	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
+};
+
 /*
  * ring_buffer_discard_commit will remove an event that has not
  *   been committed yet. If this is used, then ring_buffer_unlock_commit
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cff1e700d4b7..e99e8d4ab615 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -156,23 +156,6 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 /* Used for individual buffers (after the counter) */
 #define RB_BUFFER_OFF		(1 << 20)
 
-#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
-
-#define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
-#define RB_ALIGNMENT		4U
-#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
-#define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
-
-#ifndef CONFIG_HAVE_64BIT_ALIGNED_ACCESS
-# define RB_FORCE_8BYTE_ALIGNMENT	0
-# define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
-#else
-# define RB_FORCE_8BYTE_ALIGNMENT	1
-# define RB_ARCH_ALIGNMENT		8U
-#endif
-
-#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
-
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
@@ -315,10 +298,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_online_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
 
-#define TS_SHIFT	27
-#define TS_MASK		((1ULL << TS_SHIFT) - 1)
-#define TS_DELTA_TEST	(~TS_MASK)
-
 static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 {
 	u64 ts;
@@ -337,12 +316,6 @@ static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 
 #define RB_MISSED_MASK		(3 << 30)
 
-struct buffer_data_page {
-	u64		 time_stamp;	/* page time stamp */
-	local_t		 commit;	/* write committed index */
-	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
-};
-
 struct buffer_data_read_page {
 	unsigned		order;	/* order of the page */
 	struct buffer_data_page	*data;	/* actual data, stored in this page */
@@ -401,14 +374,6 @@ static void free_buffer_page(struct buffer_page *bpage)
 	kfree(bpage);
 }
 
-/*
- * We need to fit the time_stamp delta into 27 bits.
- */
-static inline bool test_time_stamp(u64 delta)
-{
-	return !!(delta & TS_DELTA_TEST);
-}
-
 struct rb_irq_work {
 	struct irq_work			work;
 	wait_queue_head_t		waiters;
-- 
2.49.0.967.g6a0df3ecc3-goog

