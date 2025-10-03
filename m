Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE722B9B9
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498741; cv=none; b=FtYjWz6qWRqaDYMvXL8dFv25uV8gJ4FnaAUFxXjRY6M4ypfMYDjGx4GlNjONRGv+zksriyVVsTgVsOC3O4p9EnXSgAb6VOKWTbhJH+YylP9Rnm3tILGYMYFZRMVWGIcFrclIIfzKPXhdYn3gpdSsdsSOYA7j8OTvfu9CjEHC+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498741; c=relaxed/simple;
	bh=jCel6UdKVBBhusHDhXdBf4Elma0H22ACWTajZaCTXDg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aXA0+SeTjnqbEUERkKPl+C4QSOnIgvoZ2x0LMJ1vp36fT354OJVGEyh+mQoWCLPkvEOlNH4bA4UQWFynQPtNXb2AzMVLWmY4awWKcfnYFkQ1HWF3p8XdYoBDKxfI2+0eTQ9q8BaN2VNFFXJb+y3D69W7D2t2mn149q9A3ZR6ft0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WWslxQGg; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WWslxQGg"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b3afaf5defdso292594166b.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498737; x=1760103537; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5yvbWhTiB0g5MKRQJDvE9eSL8LzKl9DcqfgxeSAHNnQ=;
        b=WWslxQGgisGmewN3CzImzASuHKF2B40fqx/qdydu/jM6TSJ4fT8cHqt50Pf4FGlVMw
         qY1EjARb2h4IG8xTKNGZR4o1oilq3RpkuNwO9EyWIVMo12WsdJdC+gpoiHUpR6MYTbQg
         ZtVHKRD4tK1A2ECZjm577z/PgDeR3s8FcnJq9bjXkcad++0NPS0Vc2+0F0gfAQxcOrAO
         ksa5e2KFrscp3WmHbCEwEnpPxric78AJrJadQpr80wK5QxulXUnx2KZVvBfS/Ng1sjta
         P4pLJTGwhU70034HpPZUL+pVueCIS5oeFETJ13NktgQwNxAyg9Pgqjt4RVY6tLZj6rbj
         OYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498738; x=1760103538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yvbWhTiB0g5MKRQJDvE9eSL8LzKl9DcqfgxeSAHNnQ=;
        b=aE7+x/KrOL8Fa1bxN1QLleQb2nL3A/nXNEKZ9ExYIU/Q4UJ35FcY/XNCBTGM0f1Dt9
         nJpAITQMcruAcbPVRn3ELp3kRoriWe3Gusrlam7jI/BVU2EH3MfQsbmhlaFfMoDeoUGc
         fJIheX9x7/fWbe7eR00S82SeGji/PhrxfgWu8kCfkP2shIcq1xaJEJ5Kq41gqydW0e3n
         TZT2jHsgQxyX2UjUlPscBY3465rbTbYcfFHRvetcLyf5xlrdmmjLlPh3HipdPSBnxTVd
         EsjzBbbAA/G3KuQFbVKOe9FXsAEA/Y2DyRxbQNFaRnC56EW91+3iJ6iUi2wa5FRtmnhe
         Vxbg==
X-Gm-Message-State: AOJu0YyxZc8nFGzzSgXSt5lLSjxFUFSd36vV6IP/EK6yfwCmtJKQ40/A
	4dLhkwN3D7KQipRM6qYqehaoq9ndu5Jg7nZysXVAZH6oeDJhTaeaQFjuAYKenBrUE7wx7AT6+Kw
	r5dq7rNp1gNKsaEd904QsdQ==
X-Google-Smtp-Source: AGHT+IEDmCVx4kHhiREAX0skvRTb6ED4U7OtfqA8ZOw1gh/kLPh63qYxbg7uCqtcVIZm2PCNUon2JI3FP9RVn5iq
X-Received: from ejcsa18.prod.google.com ([2002:a17:907:6d12:b0:b3b:b79e:764])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:4789:b0:b04:1249:2b24 with SMTP id a640c23a62f3a-b49c3933062mr408664166b.37.1759498737576;
 Fri, 03 Oct 2025 06:38:57 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:37:58 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-2-vdonnefort@google.com>
Subject: [PATCH v7 01/28] ring-buffer: Add page statistics to the meta-page
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add two fields pages_touched and pages_lost to the ring-buffer
meta-page. Those fields are useful to get the number of used pages in
the ring-buffer.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/uapi/linux/trace_mmap.h b/include/uapi/linux/trace_mmap.h
index c102ef35d11e..e8185889a1c8 100644
--- a/include/uapi/linux/trace_mmap.h
+++ b/include/uapi/linux/trace_mmap.h
@@ -17,8 +17,8 @@
  * @entries:		Number of entries in the ring-buffer.
  * @overrun:		Number of entries lost in the ring-buffer.
  * @read:		Number of entries that have been read.
- * @Reserved1:		Internal use only.
- * @Reserved2:		Internal use only.
+ * @pages_lost:		Number of pages overwritten by the writer.
+ * @pages_touched:	Number of pages written by the writer.
  */
 struct trace_buffer_meta {
 	__u32		meta_page_size;
@@ -39,8 +39,8 @@ struct trace_buffer_meta {
 	__u64	overrun;
 	__u64	read;
 
-	__u64	Reserved1;
-	__u64	Reserved2;
+	__u64	pages_lost;
+	__u64	pages_touched;
 };
 
 #define TRACE_MMAP_IOCTL_GET_READER		_IO('R', 0x20)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 43460949ad3f..2c157cb86989 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6113,6 +6113,8 @@ static void rb_update_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	meta->entries = local_read(&cpu_buffer->entries);
 	meta->overrun = local_read(&cpu_buffer->overrun);
 	meta->read = cpu_buffer->read;
+	meta->pages_lost = local_read(&cpu_buffer->pages_lost);
+	meta->pages_touched = local_read(&cpu_buffer->pages_touched);
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
 	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
-- 
2.51.0.618.g983fd99d29-goog

