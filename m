Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890BD183063
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047055; cv=none; b=X2Yg5B/WhFWpO11GarTzmNW+VGBYYM9pndOXxA+/tFIO0yUXLvXov9q5Slmqpvvl11IF6j44rRQzRUxYT1/dM+etBRWpTiM6RK87ShIYjgfnOSOeDeEP4Xd0+kkY9fVkYNSMfOnnwVRPa66zNInmqj6gcM8DMrL0F5MGtnn1xv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047055; c=relaxed/simple;
	bh=2o7ABM3QhyafkTSh35kuX9UtTd+ZQf5InDvS+wtHIQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tisIqK8v0uzymSamrmJ0XYAlFzUMxr90cSaj5AzBhpwcCK/1ip/KE3DI05ZQrNFIObTIs0QM/aDsGNjymBpunDprSRsLrwmVS8ndvl48Nt2vvwRphNaKO60TVWmqhu4Xus6OXQafRxutwsdBGa008GPEZu6Qpp57znvOMTFz/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMtDGyjQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMtDGyjQ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1ceef1b984so14788962276.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047051; x=1726651851; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2kp1u04jgRsPeEEJGo1+VXzlnKmMlFIctyiIU3pgM0=;
        b=eMtDGyjQLeWms/948S+YBqYWyb3MZOirELUmLMq2yIoKlgZZ5cNPTOVHe+PO3h009D
         TEkhEzmNOyHDIz6epazoYDmw48x1bXnm6gyKR3fRVpZkrDdGyFIxHDMzj/Xhxxo3tLVY
         FU5kNV8S+XiCrJ6zXK3Qy+05waduybZIpqurz+DLeHIsMhBtQjK3boyp6Ckgm+6vSJy8
         1rUvnerFkg7NwldDGHRy7GEpWTk3tOzHALWtUn8y7E440mFNl51/tSv7TfrCNX9rRI0s
         tJT07YO5VU6gfXx1W17JgBryFZ8/knIr1bBAR4M0PFbS7+vV5M/HzNG8rwIXZjCmB40b
         v6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047051; x=1726651851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c2kp1u04jgRsPeEEJGo1+VXzlnKmMlFIctyiIU3pgM0=;
        b=qbmWrYRdflO9szUEQoRy4jDO/LCSQ4FSdhvacgmLnUeG3HMNKABK7e0AvUW4WDTGCx
         8d8XZx3gCJKQZPAKeaQ1MCB1JS0e3JjkIxec7dcoEDDf0pQh5eILe6Bh2LhUKL3HuRPF
         CwghzkliFtZ7+rGLam8uxv07W+bz6fxMdJkTnMk1bgeEnuVsfTPFCzUELMk1/RK1JJ/A
         N3t3Cb9oIvzIW4y5PLrre2THWVY8+zMKBERc7qXmuBdhHQIC0sEN6spk5K0C8WTNbZ96
         Zq8EOkyU4YnzMMPNb7I+h3LJz945HKxKj+ayBKOS1Ut9V9svY2n8WMdrGVrGSG4svLZI
         p0Kg==
X-Gm-Message-State: AOJu0YzLoKHgB0ApL2vTEgPANhIth6tVBW8FOonG9jgEmYgayka4TWA+
	5t9TS2PnldExbmheLm2XdVqIE7wGWlTHLvGgwm8xxNqZty8Erfz8N19DAlOyJGVcg9ACZ8BYmSV
	TyitNz7V4gHwNPPQ8JA==
X-Google-Smtp-Source: AGHT+IEhqc1SMdUsPQ3IEawL8ztptY4mrG6e3VVp1AMINnDH97yStPwv2AAW/lFC8PFwC3knWmJU0TLT0HWYBPsS
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:6902:4e7:b0:e11:5b8c:f9c with SMTP
 id 3f1490d57ef6-e1d346b227bmr92087276.0.1726047051548; Wed, 11 Sep 2024
 02:30:51 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:19 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-4-vdonnefort@google.com>
Subject: [PATCH 03/13] ring-buffer: Expose buffer_data_page material
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allowing the write of ring-buffer compliant pages
outside of ring_buffer.c, move to the header, struct buffer_data_page and
timestamp encoding functions into the publicly available ring_buffer.h.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d78a33b3c96e..5e4e770f55cb 100644
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
index b05b7a95e3f1..009ea4477327 100644
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
2.46.0.598.g6f2099f65c-goog

