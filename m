Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BF74C08
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402839; cv=none; b=MHzbsiBhL4udj7Rset8wJpVAtih8kb34TANFwNG9/f/S6It1CZOjAty0KewhvC7Qfb1m5rk+j0kWwQZZa8vzQCdLMosSjV/2B/XfqBA4vNDOMDIRaLoCb5xmDGCI/V2dTe0oZVs1ES2qRZBKRyZ8jAe64pj8nAkPAwtemX1vE8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402839; c=relaxed/simple;
	bh=jW2FQ7nR3yq5w2QPtsWE3vTL5Z5sb0QhuRmmVZzGC8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IYbA5g3U2bT8b7Gg4OCHYcmEqQcXHsLomFkMzKwzBe9U6KKexEULQU9JHRtTMvrTtIwuegNqn5ImW4ljpzNcIVsw0PepCML5V+mwkLT+1PmNm+R0LiQ2HBwsPvwR/MnFe7K/M7ZnqdUeUMsZYDUkyLXoRtyDckSL0sw/HLBhUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DBsd+8SH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DBsd+8SH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so11614615e9.3
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402836; x=1748007636; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pTgve1xWELrcXmzWf6SXpdMIqoD+DsmzRfBMgyMmWFg=;
        b=DBsd+8SHwX4Gzkgp1OSpWm7YkBoxrFSOuMrbp0rlpbTiED/WfXMWjofTcASX15rPhV
         ueRkBYLMwjSYbPK80TiEqlf1vh2KnlPfLC0ksxGKlhlBuVJT6Jnt4Fb2KrTJc2Jsmd+Z
         Wnhp7FYrvoYmwagJS6jAZf3Xm9rYYnplvHeIyCpI3jAU6gzyNPnWMxBsFbmBAn1fvIuq
         Tc99P8dqzPs5nbHZS526M/sMm3BlhYVYmfNwaZX16z1j2PvzVwZRhRC964uVQt1Sc5Br
         8pj+4SBY8KE3k5ZN8pRdoNpWQLhaulEq/5zmZypoz6g2yuSEjzWCVipQ/XtvGBkRrYkw
         Smhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402836; x=1748007636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTgve1xWELrcXmzWf6SXpdMIqoD+DsmzRfBMgyMmWFg=;
        b=lplqluPojX+dIrnKL92qszFcF51Yy/ENX6RDYXhphfx5TAJkwPTaJdYPE3W6bATlFn
         SyYx2dctswhoFuBp/45StCiOQdvSgd1xYIp+TotcEUyv/nHYmY4xcSn53ekGoiKevStD
         0AwotMn1S2aqixbtAJM6bQSYrqGMDJvrYkg/Zf6rpJFViNNZrxuBoiqOuzbaXg02ZnMk
         v+jgWbj5eGb4ULktQeMU+USi63DfX/EWurpcEigqv51nKmu0/pClvg6NL4zjtJZe38ju
         1iYFoijAxGNzLam90CI0JPuhHmqAyNQxN+6oO3ySgeVjBqTSwmg7WUoDudH8QteB+1lf
         Ts9Q==
X-Gm-Message-State: AOJu0YwS6UXAHxYM6hJsd84Ce4Gln7GBTnOqwMKfzpv94c/Q51FAnlUy
	L5PqNGMlrpBzqOb7vQjmGFWUCNT3W2fSzpO+r9e7a3IGlpsNiW2SCqP42LzKvAlxIbhNQti4c96
	SeW/DulOwMAF+Ku4B2j25sA==
X-Google-Smtp-Source: AGHT+IFL0LVuDvqNNVcVOoiBdDx5TazIXVwWBCNVMeYAJMsyUHLfmYM0SukSyOsyeQgmX+rhBkYVWkj0+YJRRVQg
X-Received: from wmbfl14.prod.google.com ([2002:a05:600c:b8e:b0:43d:4ba5:b5d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:609a:b0:43c:fbba:41ba with SMTP id 5b1f17b1804b1-442fd6785acmr28243685e9.28.1747402836485;
 Fri, 16 May 2025 06:40:36 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:07 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-2-vdonnefort@google.com>
Subject: [PATCH v5 01/25] ring-buffer: Add page statistics to the meta-page
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
index 3f9bf562beea..06214588c05a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6016,6 +6016,8 @@ static void rb_update_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	meta->entries = local_read(&cpu_buffer->entries);
 	meta->overrun = local_read(&cpu_buffer->overrun);
 	meta->read = cpu_buffer->read;
+	meta->pages_lost = local_read(&cpu_buffer->pages_lost);
+	meta->pages_touched = local_read(&cpu_buffer->pages_touched);
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
 	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
-- 
2.49.0.1101.gccaa498523-goog

