Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFCB3451B2
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513414; cv=none; b=YJkXpRUHmhSJn+E9X3cNqEY3+LKYpY0ILkKXvvJUer8WBx9MMRbSdnEZik7GTEndTEmlcSpd/vvbsN8Q2xP31Xhzh0mPCej9R3z0WxmjSpXrO0ms2IarrEQJawwtpP4GEZMcilTkH6kCOeEw7PXTuJcwpSmbJwhHOK5+vi9Kreo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513414; c=relaxed/simple;
	bh=PXpJDqJ0XKLx8AEYlCoqKcNyiX2KW5l+gr+E3jTZCo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sxG7VWZcFjGocjFb6HvnMfUhfjFQpcBDzLZrEu7Z6B71bTOW8UD2h57bg6JPsMuHPM7Q+Pqm0b6n3MZigxXBwY7jPlKIeLdfRO6SK4u9foMFujmeczu2YDdAZv/GJZ+5E+75LLUhMnHTm5GAzUiN2/lqcfqmlXw44BKrTiK0WZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PjK8/5I2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PjK8/5I2"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48071615686so11156675e9.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513411; x=1772118211; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o0tMse5C0cVtD+YfhWwQcdctiKYpi7dPFiIDpWgHDos=;
        b=PjK8/5I23ABG6WDyht61mCx5ZpVMXAf2Wqi0xB4Y84WGAt5U77ovE9co78VNunXgTs
         vgLDVKUMrAiWz2ZQ3/hSh5Cggm+JwNUm89w1C1LSPLj27yfBJie/4jO9qA5YswwHdMQE
         Yp8qKnkB8uFdn/pQtjFU75kwTYwS+c9kLe6gf2o19mvvHdr/0p0sqQ11hZfKu1/etrSY
         k+E2oXinAkAwXHPyf2pJQR2UjezJsewVRvtiDpNtIP8fW2d/uUzWIHoqXnyu4N3TTG2c
         iRDug7h0I9DpANecr4E6nDre0/MzlYELOls/ywm2YB+4JT55ih07tnsLXvJSmZ41q6h+
         h6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513411; x=1772118211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o0tMse5C0cVtD+YfhWwQcdctiKYpi7dPFiIDpWgHDos=;
        b=lRVtRQfFNKWtmNVJA0QBAD0Kj4MSyj5ugF42jQGRvvgjvMmckmrUYYTazS6Tzm3gTt
         iXiMpo/a6eM08/wSaFqz7Ka9yhJbRWVGmFH0+6ekLEb3FuqOFyuLoXOvEYwPdSr6Xv0X
         VBz5Qc9h6uTmAL1xw2xWaxZoe6cYS376aeh2v5Ce+T0unibSfwQy2VBBlqAM70vUijhs
         4+DQgwBAYV2sWEGWtKYCrF4sth/OoVlkdm8QfkngYH3DhNczxQsAfNzLoiHjmy1RD2C0
         tN7UXo7c44Cfwp0H1pVVHxcHHzXHIzBkacXEmnqataaObPfB0drrtMJ3eE/H1acJXTqi
         Obfg==
X-Gm-Message-State: AOJu0YycUqghB7cvA9Lw9KVyIWgrD0W7OAhdsGMBM4NoGqVxRQ8ABQi5
	2bo3jxFEke+Gr3Hm6uXOmvXmJLLt+he8zokIhiwxSSyqIAijp91mupBJ9RD6yoXJhGvOgMo2GFK
	8HoLzNHZvmdrbQDTaAFNEhQ==
X-Received: from wmg8.prod.google.com ([2002:a05:600c:22c8:b0:47e:dc0c:276f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6290:b0:47e:e952:86ca with SMTP id 5b1f17b1804b1-48398a4287fmr89687085e9.2.1771513411495;
 Thu, 19 Feb 2026 07:03:31 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:49 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-13-vdonnefort@google.com>
Subject: [PATCH v12 12/30] ring-buffer: Export buffer_data_page and macros
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allowing the writing of ring-buffer compliant pages
outside of ring_buffer.c, move buffer_data_page and timestamps encoding
macros into the publicly available ring_buffer_types.h.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer_types.h b/include/linux/ring_buffer_types.h
new file mode 100644
index 000000000000..54577021a49d
--- /dev/null
+++ b/include/linux/ring_buffer_types.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_RING_BUFFER_TYPES_H
+#define _LINUX_RING_BUFFER_TYPES_H
+
+#include <asm/local.h>
+
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
+#endif
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 190a90816f02..e0cdf53fa643 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
  */
+#include <linux/ring_buffer_types.h>
 #include <linux/sched/isolation.h>
 #include <linux/trace_recursion.h>
 #include <linux/trace_events.h>
@@ -157,23 +158,6 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
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
 
@@ -316,10 +300,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_online_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
 
-#define TS_SHIFT	27
-#define TS_MASK		((1ULL << TS_SHIFT) - 1)
-#define TS_DELTA_TEST	(~TS_MASK)
-
 static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 {
 	u64 ts;
@@ -338,12 +318,6 @@ static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 
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
@@ -437,14 +411,6 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
 	return dpage;
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
2.53.0.335.g19a08e0c02-goog

