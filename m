Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5361F942E
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336770; cv=none; b=W7bn2d+KD1MR+Ros4DSanbbhhjy6NufyVQEY1E7EB8G7cVwTZDUCQbNtBhDvAY/Q6ZWFSuvgEGC8TGp24MbKBf0E+MJzqeBQkDqRrBRJjNa+1v2+4XLqWcnztF9SQ2CZ6+K4JXZwObupCkE4LCUV3V4W7ZLKyc/M7Sr/ciBZWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336770; c=relaxed/simple;
	bh=2zGrh6Bb4n7JJV94xdpbEofaJlW8JBXkmFVpd7d6OaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m0dX1nR4UpcPF33QYId60s67s7NfOQHGMRRrbUOAZMtwAsFlwFGTJe1rhZoysgeRwJcmnxyH+13OcHCsBAZcya9sNdk6k16F0GFQaJ6788lzk1PuyVF33oTpQknjc7lTWm271ok9zboGeqwzs5VbvmPYLfadKcN1XsrQ4SDe2s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X9x2jD1o; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9x2jD1o"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-386333ea577so3159879f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 03:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736336767; x=1736941567; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1lQEJoOrOtFhLM0V6NW85dekf5jRkM+x/j5FFakF4z0=;
        b=X9x2jD1oMhQK99gSCRZvGW05E6rRBBrf/rDhka69xwy2CG49k3lfYrrS+qo229Opxg
         xlvcG5AqbeRBcBhhfKdxWPJR/EjSu/oYzlrycSsT0qUM5A7INw3vcu2DYFnfmds7EfTn
         X9FQgh5U30EN+AyUNcXjVs6mfmmfzuqRhWZED9Cttq9R2gIkroN4Q+erI+6SVnon82JL
         wGNI6y0eNtZDHRA1RqoQT7GIi3vrtn36Yiw1j3JCQ1tFXimYNk0tTwAnV5ufiIZCqNLI
         kkFH/SGOrBrYyDSTJs0pEqzc4BeRjN4G0Tozo7sU6SNXoaoHAMWA9VnFRnU2hMaoC8E0
         EpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336767; x=1736941567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1lQEJoOrOtFhLM0V6NW85dekf5jRkM+x/j5FFakF4z0=;
        b=pQrydrPubK1WNthK10VjEIK8QgMNSaaTTJFroe5yUQC+hw8cJC7AQNzUUXkoqNBWOT
         B0YmBz2ZHq5IJCFgMSvZHIDLBhBdUtut4D9M1innUtasNJL8yz0FHZ7p82U1UV5nmM2O
         qi06eH//qbUxTMzaXI4wob3i4FxpbgFLQbAiPzMqlEL6PCVIDbcii+f1n78FM97RexvK
         5d2pixWX7AoVrTVDb6o6rU75QHYelISkFDbg0mmJmmmPJtOm3OtCiRTqSBMaY0fpbiN6
         zcyBlq3sUGEKsK5iznEP5LEVpj1iZnxHIOWvJkf79Oi8Z3W5gvT2AQ44InJld12g12Qx
         YR0A==
X-Gm-Message-State: AOJu0YxKTHKnLXT/eppznPwyAUvKpNfoNakDb89X6FAv5lH1k8m2UbJj
	dWTNydOtFSE2+b/HAto13qC5DaoMl2DLvOcwDdaoA2e1AnfWcxoYsLnpwuWI5wPl6EnqDKiPFBS
	Bg3MpLvHo+I2lUH0Xhg==
X-Google-Smtp-Source: AGHT+IH9nVUXukGdhao/KGMQEQ2ZZRu7hj12bJxObkGyvYkwyEhx99i/TvuPbWjySunFSoVAevMNDD+4C2F0t7to
X-Received: from wmbez12.prod.google.com ([2002:a05:600c:83cc:b0:436:7123:f80a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:47c5:0:b0:386:1cd3:8a09 with SMTP id ffacd0b85a97d-38a872d2addmr1799776f8f.1.1736336767575;
 Wed, 08 Jan 2025 03:46:07 -0800 (PST)
Date: Wed,  8 Jan 2025 11:45:27 +0000
In-Reply-To: <20250108114536.627715-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250108114536.627715-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250108114536.627715-4-vdonnefort@google.com>
Subject: [PATCH v2 03/12] ring-buffer: Expose buffer_data_page material
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
outside of ring_buffer.c, move to the header, struct buffer_data_page and
timestamp encoding functions into the publicly available ring_buffer.h.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 61e785adc011..a80057371da4 100644
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
index 3d5d32ecd3fa..0e5e9272debf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -152,23 +152,6 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
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
 
@@ -311,10 +294,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_online_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
 
-#define TS_SHIFT	27
-#define TS_MASK		((1ULL << TS_SHIFT) - 1)
-#define TS_DELTA_TEST	(~TS_MASK)
-
 static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 {
 	u64 ts;
@@ -333,12 +312,6 @@ static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 
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
@@ -397,14 +370,6 @@ static void free_buffer_page(struct buffer_page *bpage)
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
2.47.1.613.gc27f4b7a9f-goog

