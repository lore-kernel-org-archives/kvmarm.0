Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACD33C278C
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073564; cv=none; b=hLg0k+6mQdbQkLWB9CYiAffmcsUgJkXlbCnpCDluex1aD459+pXa1R0dchMyAtJT1pxz4eeim+2u6UIMrtMYtqy9T8VSunWP+fCZYV35QRMqzM0KGKAnmurQlim9J2oadtaNXELTvqckNwZDbG8tEPAmLIQFq5hk4KDEkeCMwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073564; c=relaxed/simple;
	bh=nIPFmzqx2PgFsl5ulyTbEA9D1hoahr/PTdGwgGFM0/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y26Dc9I0Vs7LpWl3pttMAEhBh+vZ4i4mTK5hdg4zF5xGOjjgRtyKZCq3bni4xl8cNjp4TFTjUSPq5ieC/C/BiFAVlz2I/9gHusOOwrjiAATr3IOhPPRxMhAc/r+moqlyAMqugDYr8sNaPHRlfBVIuZtWJe1zrOmwWvfp+fKby0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLEIJDS0; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLEIJDS0"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661aff85c3eso5334202a12.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073561; x=1773678361; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tqn5G0/qxFsd1rBMaP6ON3DnSHbXMjD+lZjYLddNIoQ=;
        b=fLEIJDS0WRZjJ2Ps0vjLibLVAPofu3Jiu13BxmLPEVjty8YGC3cg9I7QuegR1Hg1fF
         aKR4p7YPDfrJKPkdnqhifc1Fz9TELOCPy0muKkCDoWS5papUR5+q/aTbnl7sal0mI6Ai
         HZJNY8bUxBBIb8L8O1rjDvs+D7/rqryG8tS12kMFL/bhGTu3bNgsAfV70e4Pvs+F/XcA
         e1gc1i8LEmZ+9nzhFRheGSXLogPoLqv7+XLQ0aR4Nt/qVRnwstrw7HOVfojJGbGBJIFz
         /0ARGFIpdvZcp58ixfSsIgr/M0/jrY55PlXvEi1AEV09ZXSLvowArnJ/2UFZQlcSyUEy
         FFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073561; x=1773678361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tqn5G0/qxFsd1rBMaP6ON3DnSHbXMjD+lZjYLddNIoQ=;
        b=nY06XYx232sI6FHK4//iXr6mpPs0rjW5I0HpSZ7XFrJD3j9vVnmlSh7NBPFd77Gt2l
         Kw0SjBka+dvnmB5RsBn5nDwxBehigcr1XP6FCc4rrsstYgGaZybs9kedMxgcdrjX8vUx
         XDk4YmIDXOhqLg+iNsMi58DtlKhTkS3+T6TrN+nyAYkhX/yzNOIV6oSvBlsd07j6bMAc
         IJYRuwGvqdVwqxiytIcrEDEaRVdLCeyuASUpaOKXeFIWL7NK0Op5l7HW7T24zJGiOnOg
         9L7mcZyRvXGojOQ1rXu6hXpUyrm2P1g8QawGpR5erifCuTGJ90+e6M5BH3aHM9GFELHx
         /0aw==
X-Gm-Message-State: AOJu0Ywtjb8mqTDH4rs03HtdrdqOMud6Q/o8BgH9zyaFcVv7jaGtrC1q
	kKNo4j46heipHarQvS9Dw5MEEi9lgNpksLsLl97MD/vZKqumyi2NqtL9CCVxfC6Dv42Y3VBR5fp
	BDicsTRhJT7yAuJna/muSWA==
X-Received: from edro9.prod.google.com ([2002:aa7:d3c9:0:b0:660:ed52:a77c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:430c:b0:662:ac7e:aabe with SMTP id 4fb4d7f45d1cf-662ac7ead72mr637065a12.15.1773073561283;
 Mon, 09 Mar 2026 09:26:01 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:24:47 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-2-vdonnefort@google.com>
Subject: [PATCH v14 01/30] ring-buffer: Add page statistics to the meta-page
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
index 17d0ea0cc3e6..82b4df579670 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6154,6 +6154,8 @@ static void rb_update_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 	meta->entries = local_read(&cpu_buffer->entries);
 	meta->overrun = local_read(&cpu_buffer->overrun);
 	meta->read = cpu_buffer->read;
+	meta->pages_lost = local_read(&cpu_buffer->pages_lost);
+	meta->pages_touched = local_read(&cpu_buffer->pages_touched);
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
 	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
-- 
2.53.0.473.g4a7958ca14-goog

