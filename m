Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496D23AD
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498754; cv=none; b=h47h0mJft3+++S7lWUYqbgobPpG6SvGO55dJp340WxsHDmJRKLNXUY/FZPd27Fpc5+dXXaLjR2lIXuSwNBF98pBcr051ChwNkg3SRyGht9XUsPEXdHhrCHMXCOpM6hbIK05BDbET6P0o6jq9TBn4jRFEMArX8cRR5K4OClj7x0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498754; c=relaxed/simple;
	bh=gsWglG1nPzv9SNVjHtG/HI84T+0OhpOoLwao0n82xTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q5AqQ8P77NMOdvoM6t2hwvv/5h9k+aqo8rqHTVPB3HFUa6Fkb2MPaJ5mt7fG1QgzsYr2whvI2jc2RrZLhJAR0n/Dw7HPX/8pcQ2PumlzSbvnKxo7HnnIdFEqoyfALdWymgLF4DKVGbs/WQ4bovMWEAHfuWVO7LTpZpOcOsIoM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BMTwOQ5+; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BMTwOQ5+"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so1399532f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498748; x=1760103548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ykRZt4psK54fzec+OCYqwqliJC1dewmuT/merLHMNBI=;
        b=BMTwOQ5+TBgTaXVTmN+suea8qQ/6rWWExuMqZDJi+B5lAmay5NIdNnikVxgpVVt49p
         KKkdZx31OnnL/JsyXzcTioZicWHg9d7XEcB8OK90NuJ0YqBKpEKbwnG7lbKWFCM4FaUE
         mjoqUqhaUl/ZlUJFVtn3EqQTuoMv+QrzmCX3qNLcfBR0iQM5qr1QJTFrHw0rOQAFdgKb
         bJVQj+ulkNL8WPTE2PMLckPWn/q3TWJPhj09H0N8NltnBrWojwGLbJcHa3dgtBPH8qTl
         bXbdyQb6hQQMNIK3aZNj+QODm/M4g+Gjm5fy/7eALtJit3C2adHOCJPx+ESobiUHLjQE
         wiXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498748; x=1760103548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykRZt4psK54fzec+OCYqwqliJC1dewmuT/merLHMNBI=;
        b=Togzfs0GxuTG3STiGCtKzhndpg63/q0ziahlM+IwfPFm31zIfvzJHjMV7eaEB/SHKc
         eYcwjUaaxk0TWUWzsW7asV+Wn1mH5hC+skA8/D20SFqIqHp0a4A+2Mqki5xuLrhXlosl
         s+KhOqM3dpP4UWXzF4bg8JJ03Xz+cN5qBMW+XiC4gnXQqSc+V27uzegQG/X03LqB86l1
         izcRsz4vYg/qRe6jdp8JBpHuTkHGBzXfAmpigEbdHrlrgiFjwcU9mfHzPGyv+SQ1ud6T
         qg9pTIcyuFs1X0ygqfEmU30F1hCPvOoEbojunUJbvR4JygQ6eFkXpWktnLmk7YNeMhZw
         FFUQ==
X-Gm-Message-State: AOJu0YyVHWKT02FBxlURz1GWIc4PugHiqltfSgexcUbMbcjPqrlEEK0X
	lxZ+QTn+nxmb+WaU55CqPTPSjCZxlkcLHDa+cDokkiPTg4Q1ZBWF+6kwMn8Zn3SRJyKG+Tubaaa
	dK8v1HBBBlizjf6HzFCEuwQ==
X-Google-Smtp-Source: AGHT+IHeEJIiFICQ+unjZAp8uVzxbLqoVsWl8IqXt+7TMHnizGTo35OB5M9RkcuE2jC1IdoxNGX9ssBAd8G8PduC
X-Received: from wmaw22.prod.google.com ([2002:a05:600c:6d56:b0:45d:e232:8a3d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:348b:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46e71109e9bmr21805095e9.9.1759498748266;
 Fri, 03 Oct 2025 06:39:08 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:09 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-13-vdonnefort@google.com>
Subject: [PATCH v7 12/28] ring-buffer: Export buffer_data_page and macros
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
index a26a6f537f87..06aae6a2a308 100644
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
2.51.0.618.g983fd99d29-goog

