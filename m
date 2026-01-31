Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5527C349B0B
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866166; cv=none; b=eLM9RpNUOGdNOYBuS3pXOasFjOAq8OUTfVO7pUPYQX5FKNwaQQssTpcOo1/Osmq/yChEUx4uCmd0Orz73JQyJQOMY46PEQHpx07wZQaQCHMkUTo9UKrtvMw6YU5grUp8oon/qoqd815g1YmHNZY+xmnumrnp3TDH1t3PIdGkFGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866166; c=relaxed/simple;
	bh=YpT43noux36Qb8SPRAxAVRkhFfy4HwaeXM5l7XWGGkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qtfuCXEWkpOdR+C0ZhuJY+YyIpf5rWbrIcnxYAvjYFfWck/SkkwAXDccU51CqdiLJv3d2THTPsukmtiOHsSqlqfd1AhlR9yV+uOOceXEeIGcVmlIqdkhBzH+TFRLY4N4XIDCRZlhGUh8I0QAqegbrz3Yuu5Rp1fyD9DYRIi3SKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k5Yd3RAW; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k5Yd3RAW"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ee1fe7b24so26136995e9.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866163; x=1770470963; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AZUIc60w8aDIxM9yUNkpf1enaQr7Rd+FSbamqcyyReA=;
        b=k5Yd3RAWWXvABjOR2Oh1TFYai02g4PJupbCrFmk2M1Mibr6AAXA+rgVFXnf2kXG+ck
         /3fQ5e4wSl1veump/mXTBtx0POsxTykKp9l954TRN1AObpRwrR+q57SNMxNgdMg4tH/P
         BZSPoWM9lzOopLeEc0W33OFphSH4kbNDji1Q/57Zdt/BofH4KvAoSTN8l9PVFtR2tGYh
         g1CJuZYQ8pVEk6chgF6pbGFzsL7nzz2Bflxh5moZJozEras+5d1DuE2oigE+tRzIDIQW
         jGWJY9IgZLQ8VRWTNB9qOj7MHnpmxNfYDxRayfn+azb5PU2vi6A7hYaFMJC7nJazB/ww
         9V8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866163; x=1770470963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZUIc60w8aDIxM9yUNkpf1enaQr7Rd+FSbamqcyyReA=;
        b=TEOp5zBfwcvLtMlbebYkewPIkj91ue5RJJjw7FcPjKuh1mRXKI/xRCdOZbzKs3WBi6
         FTEH2cvgiNxReRHAnFaJhkMGSnkcU6Ru0Cm9uy6f/g2jbJRnfVLmNtXfQlwcPe7o9oxd
         3ZRWnoFDodjioyFfr0IBiiyByHtMNcfa+phoNAa1cL/x/T0LnLbhi6PZAkrQjWrhgu/7
         67fMdZfTHhfet6T+hH/vgDMJ3t+4h71Xhcz67wz+95Ab8vy9wHE1i0fnSv4ahsm0f+61
         JM1UIucxwYGiV9pseiBv6h7JvxAiSUHWGtpGK0KjBIqvPeI3lGzt6cIAybzmXfJhfsQr
         QzjA==
X-Gm-Message-State: AOJu0YxVT6GPLgZbs1qLSYOTOsbO0lxuDt0bdCZGgVs7Lpr29aJutLO+
	37+GZSkEI9mL/KlNQD6by2M4LUYhxWYOknGSyFLSquAX8lVkFg1/CuUdx9ZnOLsSRvkw28kFWm3
	WMwJBhHeYTZH8/GJfxGOTjQ==
X-Received: from wrfi9.prod.google.com ([2002:a5d:5849:0:b0:435:a2c9:8c02])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ec7:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-482db463c13mr79331465e9.16.1769866162768;
 Sat, 31 Jan 2026 05:29:22 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:19 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-2-vdonnefort@google.com>
Subject: [PATCH v11 01/30] ring-buffer: Add page statistics to the meta-page
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
index 630221b00838..1187d632dd5d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6131,6 +6131,8 @@ static void rb_update_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	meta->entries = local_read(&cpu_buffer->entries);
 	meta->overrun = local_read(&cpu_buffer->overrun);
 	meta->read = cpu_buffer->read;
+	meta->pages_lost = local_read(&cpu_buffer->pages_lost);
+	meta->pages_touched = local_read(&cpu_buffer->pages_touched);
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
 	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
-- 
2.53.0.rc1.225.gd81095ad13-goog

