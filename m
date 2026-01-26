Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524B3161B5
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424271; cv=none; b=kL/UDk6GmY0Ektu1hJsemDg3WlRm97GjvJjobccM73wgMtjhewXoHQfG0NaRQTb8cMOd2fHUKlvKx6rKB+1+TnF2HEYcZih3UAnYJbfippqwXKxYx98zZeyE4B6tS0ziJr8wV+lkK5uFHUxHIY4rHRUh1LuZaWQEBDwYsKcAlGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424271; c=relaxed/simple;
	bh=t7R+pvWqC6CiC8mrPebUWkZQhBfP+oPIAOX+3pC+A90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F6lUd5GInsTs7LjwKC/7qkm8rwJ8dgNIa+j9Wv2z52o9ByjoxsK0AvWJvywGjtUUr2PhktJhxbxxTMyk039nAqn8xH90Vf51GNRYahxjTgfFwEJWfsn7x1aVfzgqJpTEH71lLBCPihyB6DSoBN8gec495l1ZZdVqZAWWdDYv8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ibd2Y043; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ibd2Y043"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4801bceb317so47140775e9.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424267; x=1770029067; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ffA5SL3LC5b8XzI2Nz3h29Xpe+4f+LbMdzYhyUIPyHo=;
        b=Ibd2Y043hFe2mRaIAPd1V8MKz0Im1BPLChw4ziXRp9TqMjy38Qp1xM87+Z2kMcrDx1
         s3jKX92GreWInPlRnsfsL8i5XRDDURRG5pOYf7wi8uwQn4bxXS2pROXUQ75EZHUZIfvJ
         OTFF0d8Gz+iNntLA+dpfO+l6VtdfJmPb7+G6YM3UMYY56cyfvXVJvuKvTgF1Zn4PTnVs
         F2lCygLTKSKMCf1pkew/ovsUf8Ciu8kIOUCGaH8/aEN/ppbJ3mPmNaVookRA72B/FAZM
         rddNDeKcG1Pen3JCVPb+xtWZ/6/pQPNgG/YcO2ZW1QUNOXbY+M+pW1jEV4O5yTiyKkGa
         rXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424267; x=1770029067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffA5SL3LC5b8XzI2Nz3h29Xpe+4f+LbMdzYhyUIPyHo=;
        b=V1vlkC2C/cb/YBoqbhYknplzjeWqDuJxHAVaK/+cMs0rcJVGhYA8wVjCHMAgS0srRy
         Qq1FDZOr6ckEhk1cY78O26QuZe1dLSMcZR35lxgj6mH1GVgMO4hlskaJxh/KsdEAUV+o
         5lPWJm8c5a6XDY+3PK11PYT3PfDr9XMUW+uRqjfXJ+1ssZ9qFT4JZt7JkvrgYnXSfJHX
         re5thTLtFmOP0tMhwqYIf6b0P9D1kME8B+uHFzvlWOo8OiLhsIPconCYH4VwdwCr4L3O
         bBvj/cMPPbnHUw7guodayFUI7eCBosC5nzxrkfip086AN6k5mgOY5n1yQyoBNTu95xag
         dglg==
X-Gm-Message-State: AOJu0Yw7YsdiEdU/l3oO64M7CKgcrxwe2pEZiz4uCDqseAvdgJK2B5o7
	g0bl6j6B8cx4dRWc31PbxVyZmIMWcQb02UiRzqPe7+PFcb5NbiM905ZhkSr6uisYlC89+WIjryB
	T005fzppRnEpma36k/OyM3g==
X-Received: from wmbz12.prod.google.com ([2002:a05:600c:c08c:b0:480:4a03:7b6c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35c2:b0:47f:b737:5ce0 with SMTP id 5b1f17b1804b1-4805cf66771mr72717075e9.23.1769424266779;
 Mon, 26 Jan 2026 02:44:26 -0800 (PST)
Date: Mon, 26 Jan 2026 10:43:50 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-2-vdonnefort@google.com>
Subject: [PATCH v10 01/30] ring-buffer: Add page statistics to the meta-page
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
2.52.0.457.g6b5491de43-goog

