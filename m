Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC2311941
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668207; cv=none; b=WgsQP8T/uF/HQpQl8x2/JQ5dHIQkkl+xtBfP3Aob27nr5u8VRb/h5hSllD+aPA6HfH7o3AnINCHrJKFUGg6kp847hsgxGwBn4d2s1Uq9LPVIRXnip+QvlrhjsMZ/YrPqJnqJuM/ovq8WJo5Ld3x489hL5J+xd4K8LgyxbHahWAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668207; c=relaxed/simple;
	bh=oaRdTc+CudMCRIjCToZjk2dqfieeoQukCK4lffombqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fqKdyor3ur1DSqGm/8Q3kTtKjQcurIeG08g4y6+OD5USZ9s8IN7Xqt205DE3MAUVQwWuSvmkd9jQWm0Xzvw78DU/gjYst6bgaETGaCJcfK3ce5hsmDb3Cg8nvu+qcyZXxS7zMvhz0yVLn+PSatxqUVk39OfmIXlwF9jAdila39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wrXRfTsX; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wrXRfTsX"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779393221aso28967145e9.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668203; x=1765273003; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtoQQKvZqv4xwY++1uskqrXtrGNBBDBwX6nETm2Mts=;
        b=wrXRfTsXwsafK5IytHDC8z641g0MiIp6AzuXODSdjiScDlWcqKcDGPxIr98uqfpf0W
         F6K72r0n8VpvYQEkkvgBqHL/e7un5bM4rgkY7drXCQfwf6zLzh364wV+Ef1PlQqJUIhU
         3ixjWvT2ebKN+2shgALkO8erSIcs76gQM8YAQq7Kv4qS23S/KkK0t5GNpV+BgVK4gsk0
         WnG86/hiMw8UNq1uhAxegirtlgQw/zTtHGdtsobJagNE75x0hWbJF1cQa0lY9Ugrb1pW
         SymyHOxxnrNUSIIK2Nr8YsgxDYSMqFlNjzY0WaZUwBj+nLYLwBXevMNxFqZRuZFU2ipz
         pL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668203; x=1765273003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtoQQKvZqv4xwY++1uskqrXtrGNBBDBwX6nETm2Mts=;
        b=tFMZO7GlZdkkugDBWb0z6XxoTwAwJKED8Pk3VyRB2g0MKNQCDeomjbo8L6VCB4CxTe
         9XHAqgFtLIEydI4WACUA8xlXGD7tTMuRjCO2Bo8sCfRVCYW2otjIZxAfJ7tQ4hk7qolj
         oVOHWkAu80F+dI4TG8Tcs1att+IAzfi3fLpbomhPYZ3kXWUhr/sBvnAh/B1IHhH5QnLU
         BXSCHWlqeZ6Dcxnon65TXXmmSt/YUmS1K48rW9x2gq6r6ozaa/xuWtMUe1pvnOCucKpR
         hupoSMDkVm3afO53nKcz+R1z+BYnPNosDTGzK5rhMm6VZz7HilWbNWnpaUCUhJXqDIHw
         fB6A==
X-Gm-Message-State: AOJu0YzYNu8JfGC3GuiGubDBgrzqOdAAwrd4uAmU3sPbTiIyUqtnNfxp
	izFtf5TRVgOzZ7DuJh8L9TAeZOmEv8ry8NE/2jDTkJrUWfn/ggMGdX3jSU4sV9rDezSJPQnkEiW
	F+YkKJ13YOAt/5m65nGiH5Q==
X-Google-Smtp-Source: AGHT+IGUcFqotkZnIoQBBM1OMHuVXqQ+7PlebBHwvLOhTIEZw+4qCWorheTb8bRwyZqPz9VQr+j6/1h9iGZ0AV13
X-Received: from wrmr16.prod.google.com ([2002:adf:e690:0:b0:427:8af:f179])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a08:b0:477:7b16:5fa6 with SMTP id 5b1f17b1804b1-477c0162e8emr419428785e9.3.1764668203047;
 Tue, 02 Dec 2025 01:36:43 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:05 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-13-vdonnefort@google.com>
Subject: [PATCH v9 12/30] ring-buffer: Export buffer_data_page and macros
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
index 9f28e7b3058c..7a1a8d5f3a25 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
  */
+#include <linux/ring_buffer_types.h>
 #include <linux/trace_recursion.h>
 #include <linux/trace_events.h>
 #include <linux/ring_buffer.h>
@@ -156,23 +157,6 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
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
 
@@ -315,10 +299,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_online_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
 
-#define TS_SHIFT	27
-#define TS_MASK		((1ULL << TS_SHIFT) - 1)
-#define TS_DELTA_TEST	(~TS_MASK)
-
 static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 {
 	u64 ts;
@@ -337,12 +317,6 @@ static u64 rb_event_time_stamp(struct ring_buffer_event *event)
 
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
@@ -401,14 +375,6 @@ static void free_buffer_page(struct buffer_page *bpage)
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
2.52.0.107.ga0afd4fd5b-goog

