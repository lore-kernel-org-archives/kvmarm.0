Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12D32652B0
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513402; cv=none; b=K++nGEZfSa581dBLdZbjkUKKpLgEulq8MaCdT2tLJRh7F2pGhDKvF+ImAVe0amV13D7skafhycVVq+f2OYKg2WxsmNdwahfeC7sW3E84NdJcjXQVVnVGymIjOj6iTNQsMuGMqNIqRkYoyqLJo2WzzT3dLxKlxuehIWZwXEeQ/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513402; c=relaxed/simple;
	bh=Xwcoq3amzym2QZ4JWBd3zgJ7/gqtSgsDTexNVGIVTFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t0i+hTiFgAc9dKOi3QOU9n2fzr099mcLno9Ptiqk+5lVxNdQg7jjNLdaFwFgmk4YOAv6cjToLaM99Do66DuDThvugbQe97stJaGdp17dXWsyj431wzUFor98CxAIB/YgNSjiRB0Rzup9HtPtHME/lpm4hnTfjqRPIev47P+FwBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IiJypXK1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IiJypXK1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836cd6dfe6so9385065e9.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513399; x=1772118199; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9ZYrkp01SZudmPJIGgaD1hH5p56foVqTFoUkti6vZ0=;
        b=IiJypXK1QEpYbrHjo/OglU2a3dcTroNxV+BmUgs9nLBD8u549Jcx9LJWLh11DuE4h2
         UtDrf3b+NpPrR/5qD2lf3V8uj54YJCt7ZnHC53B5ghpNeRASMFpBjrlf6Glp2jmgGxvs
         TfoxzL0hO4Z5WkCXC/PxuZBS8sXCaJaA68dbczzRWtCNzKn01bWopTvI6/HSzQHyf1tN
         YSsmmmoaXF+bHU9D3uA66/b7G1RicIltf9bwGzBfJaEOZPM+TWtKERI/nj2GC0toiHtF
         pvxl7Fuw1YAHKs/Li8vkgXiGPgFt3KG20WJOdi/ZfdokVyCDDlLccWHMh5i21CxU8yl+
         Pmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513399; x=1772118199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9ZYrkp01SZudmPJIGgaD1hH5p56foVqTFoUkti6vZ0=;
        b=RxGMIMIVyU1dXKZy20fS4R/KIsFQczmL/TyYOQvb+WFdkxtf3vLbqS5rMrBfG0iW//
         NHmq9V3q/mn0sH+3yfGFMxCGQJMOQyN3RdB8UV/sFPB1XnDd2muSRzhDdS8grl5lMKGt
         FxjztFvquLOvS747lebjZmxkl+9r3IR2tpKOs9hJQDy3hrezwknpju9b9RqB98Y81V2Y
         NuO4ASRBSf0bLnIEIXr2ubkrbDkuMv4cf3AKrCqlqi50gtLII60DrCxEUDW9AhBx/pbH
         SO6VPqutY8iU26OO7NbcsxpQSQTBv+LI82NyiIT6pmmPLmWUJY7J1YraJpbCemvp/zcL
         XUQQ==
X-Gm-Message-State: AOJu0Yx8IcQznBg46VNKQprsqYZfhQsh2+xKzVHXJDwrWPRvl1vbGLTf
	tbbEmTh8d+8svYcC3eROQHedOUZZZxQU5tz6CrYI5aSuQ6xwJZ7pWUqOiSfgY1kXl34zzHOOX9k
	8Ka/86c5VxJ4kZKyEz1gvRQ==
X-Received: from wmbib4.prod.google.com ([2002:a05:600c:a144:b0:480:6c91:3efb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34d4:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-48379c1fab5mr301474605e9.28.1771513398866;
 Thu, 19 Feb 2026 07:03:18 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:38 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-2-vdonnefort@google.com>
Subject: [PATCH v12 01/30] ring-buffer: Add page statistics to the meta-page
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
index d33103408955..210c3811ba48 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6149,6 +6149,8 @@ static void rb_update_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	meta->entries = local_read(&cpu_buffer->entries);
 	meta->overrun = local_read(&cpu_buffer->overrun);
 	meta->read = cpu_buffer->read;
+	meta->pages_lost = local_read(&cpu_buffer->pages_lost);
+	meta->pages_touched = local_read(&cpu_buffer->pages_touched);
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
 	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
-- 
2.53.0.335.g19a08e0c02-goog

