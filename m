Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914FA1A5B8C
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402854; cv=none; b=U/3ZiTd0YU/3PdRrQ2lMvtD61uJa10958ZXL/ElboqwliKk7sMMFFp2oWMqZOh9/QOVpPRwkYdWsg5Lis0QF4iFsapr51zuyCquO+Elye1hJeAzsEZc5dMAyqts01ze+nQtSZHnENBS6cejuTz6Xeoj1uaoLjFcqt0A8+w7yus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402854; c=relaxed/simple;
	bh=wsH31ydPHtGC8nSyG5aiDWiL3F7qWOKzsCXUCTUDMoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BYCekHiXourYZNTviErm1CxxLxaiViaWa+NAvLjYYrXjFTIzg7Z7E4M70KxhWlUfiSDZTWTY1P57iNlc71Qh45kbdaVU3pH0QY9TydIb161dJBM6LVPhBkDeHkrer2NEHQgmUI9aLqTLyM6FdFelblO0cKwKV4iM08ZH+l43qXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dQem7QPA; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dQem7QPA"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a0b5d18cb7so1142160f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402851; x=1748007651; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sts3k8S/JL66rJ24fFiDhVPJbMR9OVDJbVTiN/eWqHU=;
        b=dQem7QPAVdbty+8w1U2xWsQpmV59E1AFk+GJfmPGDJ64BbfFU6S7FYYB9YAQ7CQsBJ
         ywaiwBMUI9hdSix//XfCSqUBek3BRgUIvTX59GYKO/as2cJKj6MO42Voyb+ayXYyaF1z
         ulfbX7mxmXfXqqH1Adh1kT6H1pv9lo5jMkxYJZfN/3EjqF7kQFM2QMYTYNfkKUk/8iTt
         FnSmuzBR6vzwoOk3IJLb1FCJewduBm1mvW++50kqcNI0MSTf1r/J1gESCFkUqPeYUGb6
         TTWFjs7mE7Uud/vQAX4Av2/iBD7ov2wATr+LrxRTxZAo6asyv7xI4cq2ck1ti8sfTP1a
         c0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402851; x=1748007651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sts3k8S/JL66rJ24fFiDhVPJbMR9OVDJbVTiN/eWqHU=;
        b=bv8EG8cafCNGsH+RJDoXpFq75KsCAaKEoTh3YQvIN4s4GXHez1U1fe9UGyXvo/9F0S
         PQcHgzlU6OcJ6ugfFGn/FGzPTkTTlOOy5q5l7HUGhPLnb/O48RTaG3+OI1ACh8SQOObi
         4Be+Oojb4ZnRv394QljHl4eTldKqq1KEF7hpg/RVeDZm8066hasAFLhZCCtqEafzNaZP
         rAQaLXingofl0Vf6Fm/TqptmT7oKvYA6bhzUDqlugP5C/wHHu8KszuOnAl4Sz3/KfG2+
         z2tOTxXgMH6vQdROTP85saUUpbmftCZaRNiWAn/RPst+3tS0Cwq3Fq8pnCpmC1+z5xgP
         GGJg==
X-Gm-Message-State: AOJu0Yw8b6y3pI8FT/2eAMQfKLS8pPRtzqCfl/YU4hk2B/xleMNqT9AJ
	gvkxPP+RB1LnGHp+KgzBFsNOlgVtMUZeZKLWzwLglX0XXQJ7dTEkWHy2QCu4rDNqxlr1VGHatsp
	l1WUk2IhzUxNPGni374ImVQ==
X-Google-Smtp-Source: AGHT+IGnqfA97BVbR/Mi8Ve40w0dtCeOsw/hPCYSNZEP3cEaZDO8G74lb40v8p70u0x6PTZ1uUBUClqeLpxaBluT
X-Received: from wrf23.prod.google.com ([2002:a05:6000:43d7:b0:3a2:78c:3f3c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f53:0:b0:39a:c467:a095 with SMTP id ffacd0b85a97d-3a35fe6777dmr2300705f8f.24.1747402851035;
 Fri, 16 May 2025 06:40:51 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:15 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-10-vdonnefort@google.com>
Subject: [PATCH v5 09/25] ring-buffer: Export buffer_data_page and macros
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
index 8f94ccf3f55e..91c69945a0fa 100644
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
2.49.0.1101.gccaa498523-goog

