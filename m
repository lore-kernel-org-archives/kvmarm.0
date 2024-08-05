Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0785415ECCF
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879223; cv=none; b=VU3ZMtP/4s58srqBgZHbGkPRrDA4KTSObnebkcTDA8hIT8YWo8bVHo4m/d5r7pyClM1iGXJ+EwH9141i8d46BewRjapWOyrBuwrCIp6xPMU5f3pYUTbjmcO4CnKOt1p+zfOZ7CNyczTvvjlszmKDsloV337Dls9ej4K41nB1ckY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879223; c=relaxed/simple;
	bh=Xp3OlcpIJhbJjFeMx2CCe7/zsFkGL9ZV/bcp0wc8TVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J9nqRXCf/gPdWT8CljzNT8N8WMiPB0SDhzgGW8z4CedBH0VWcdTXlo41AfBhG65EiDt7o8cskFscggNQ4NSXiBqEJDqyW0QLG3c/qMwkgW/j7XhmB9+LU4dTUkD96YtHbX/tSjgqddlTgPmBClC6wc2WjcGHy2dw5073/wGPtHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1X9JcbF; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1X9JcbF"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-672bea19dd3so244640277b3.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879220; x=1723484020; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3SZGVHYkMVHLlYtKdrbHfchL8o1QJqk4XAVSUIgMnw8=;
        b=F1X9JcbFI5dH+uC+5kmIEfjmpX600PeaCZur7dwgsSqZhEeM4SKizivlz6Dq/ap5BL
         /24qgSPJHewCUUmnJ+hq7lVHx8NC/TuJNMyfbKXlZQrF2csFHoE5LTyJXKys5dUUo9+T
         N2kAPiU6tsn/ZvFq/oYEeJI7JH/LAVkvsDMWvlreMjnpV/WRL7zYDPVIgc4m2opR3gBv
         z3IQnBj/oTbDmKGJMoTu4StKLhztm+vJk3IiwwWtWhQIv+tFiw5f1qpT7pB+pWNYzmXY
         ZylusIYizoLrpAPJbMizMiBLPYUcz6PZtwlVSFX4PNdISgmcWPKTGsqcg6vjPH90zx+S
         NxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879220; x=1723484020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SZGVHYkMVHLlYtKdrbHfchL8o1QJqk4XAVSUIgMnw8=;
        b=XTScoOK7LSUtsU1YmrPiyZ6VZHJxuwFqBVremznyDcNMnCl32Qgg2xfUq67eSpNuuE
         I6nFvIMGnMJFMZr6u8Pus140wyl3MhAR6jfE/ycSLPbmgn2Dk6CHRPJJmhpJkFrlrenM
         8eHmfz/lgNMmKRelLl8YF4blwkm6CTNhD+kmbt04ePFqS5s5vtefb7DCTdLFxgsccQO7
         fhTE0V8sB77Te17luMnAY8YXqcXqUHchm93wUtXRs5YFKv6OpcKbUmYSedYQfV1VX18/
         dHKRQfPhycXSF5lL9VoNkWy5Klov3ko2yznMV/0cFTIA8XSElogtE4JzZJNMO7DmlXvh
         iAcw==
X-Gm-Message-State: AOJu0YySj7ftoi3segOchemhxhUfUMkO5DbfipBVa5Geq3dv0oIPQmeM
	BkydnFy4tbyGIjwRJKGIKUyWLMVFBGLxILJ4GEMi3bttrutmPPr99SgZUosiMSaUh9FVx3BOZv3
	4Kpm1wltO+/Er1IlA1A==
X-Google-Smtp-Source: AGHT+IG8KZDp4o1tG93JT+9t3ne+jd4UbvIhb7VM71T/QmHMz9MrBKia1IOJEEUYMm3TylaxL95IRwDh+sha/Nx1
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:6902:1894:b0:e0b:a3a2:56a with SMTP
 id 3f1490d57ef6-e0bde211a6dmr54001276.3.1722879220031; Mon, 05 Aug 2024
 10:33:40 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:26 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-4-vdonnefort@google.com>
Subject: [RFC PATCH 03/11] ring-buffer: Expose buffer_data_page material
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allowing the write of ring-buffer compliant pages
outside of ring_buffer.c, move to the header, struct buffer_data_page and
timestamp encoding functions into the publicly available ring_buffer.h.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d3ea2b40437c..cb2a266d1f2e 100644
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
 
@@ -20,6 +22,8 @@ struct ring_buffer_event {
 	u32		array[];
 };
 
+#define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
+
 /**
  * enum ring_buffer_type - internal ring buffer types
  *
@@ -61,11 +65,50 @@ enum ring_buffer_type {
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
+/* Max payload is BUF_PAGE_SIZE - header (8bytes) */
+#define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
+
+#define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
+
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
index a07c22254cfd..6b00b9a68b7a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -135,23 +135,6 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
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
 
@@ -294,10 +277,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_online_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
 
-#define TS_SHIFT	27
-#define TS_MASK		((1ULL << TS_SHIFT) - 1)
-#define TS_DELTA_TEST	(~TS_MASK)
-
 static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 {
 	u64 ts;
@@ -316,12 +295,6 @@ static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 
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
@@ -377,14 +350,6 @@ static void free_buffer_page(struct buffer_page *bpage)
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
2.46.0.rc2.264.g509ed76dc8-goog

