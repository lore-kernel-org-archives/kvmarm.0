Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDAA18FDBD
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402850; cv=none; b=BlXKinWYd2k87zdS/I1Fxaj1dWPqsq1cw42WLMTIEwyxFmzw7VH522g6UxN5Q+IF1ExuZodsbEzG0fMTrHg4a50rEV9DBkdiybKLkYhb1MH/aal4WY/SV1OIJOEtup6MQyvNvP23UAg+XbLAuAk1ypDqhMpi/UG/RS4QKMO1r8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402850; c=relaxed/simple;
	bh=KH25AJTJC+5nYO4msKcbQW9YOSJcLDaN3X5UGto+bf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wpnn7o0VK57WZrt/u1WHCByPODUh/5mccFzYunsVqvNLS6UDm+3Un8RXUVEYpblPAR5FMqwNtvQCcqtI0LXGvyx6zynbUeK/RaWGDXeDdMjILsDPbwv4iuL/nrlNgmU730BiKbKeC9PvRboDY6tHxMw+MiVaFKe5c13tWZ7SCZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2tolVOqm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2tolVOqm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so15990255e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402847; x=1748007647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbxz6VgsYQpmquuEf48m6ENRRnMX9gVzHugVlK3Ks6k=;
        b=2tolVOqmKwNXnY7YsW7+t3fFiVQ/MBKXz7tiKTAWR39dYsd5To3i7DMnfGFpSVaBy6
         YhXOUgTY0Sn6IBmnvV1k1kumjMR35Ig7fZisPaVTG6M8UNYFCwurd6onO97Qau0/yDuA
         6GQWUge+1I6mIsM/bT0CNCDN1OnWC2p62st7v+0vBvUZ+S1ef2RdeyY7QqkNIN2QFTzm
         2esC9nQZw07MY8LTTqqfDLJ+T2Qf51NknU0UvuNpmV2mkAhvWZXyEvAAeWNqkc6KoCKw
         j4FMIdtfOf7N7NebfVGaH7uW5KHE+oT4Rssu8P+eCrMkwyRlPCPff8xiuqaAhTaJ1QBM
         9+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402847; x=1748007647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vbxz6VgsYQpmquuEf48m6ENRRnMX9gVzHugVlK3Ks6k=;
        b=kkMVjfnr1iDo1SRFeV3jUQDbHe7zmiPq8tE9xF3EOdCTML9IeV2sKxBX0/p2/MMM2e
         jq7jlkfrGPShYRyLMm1cIlOC+V9bZsY2RGhs8gEkyCytNVLxDiHZ/SgUyeCBBCkGi3fi
         FZa04SlYg179K9I1WNf4HaNjCOT3ClzATq1kJssURwTagGVbw2G6jSKGO4Wm54dugVSG
         fQCo+VUjmOePgVSOG+TftudTaVIbbToph0UXeBaYUTfN5juYlXe5t0MUu/0NnhOsv5wy
         rGObFTxwB2BpVekht2H06raS366iD+ypsE1L/jrN9WW7I61tz4QWUY/cwsTTlOsmNxp3
         UMlg==
X-Gm-Message-State: AOJu0Yw+t//cvn2RakVXI7e3d5v7wZVUWUqKCP1o+cIomAn29s8sqdMG
	1tCLVKpxyEyhDrXPGuesNj3s3DLAeCt529JledVCLYDVPKdeZxXS0JQtcuu4rPNBQfhpYFE3RMh
	7Lffsj/Vk8nv62C2+Ab+Cig==
X-Google-Smtp-Source: AGHT+IEWs6z+aMdfnt/Nqv3/4XuvEER4z+Swr38ZCWgw9ZBInJe9N03F0hUkQVLXcRXpp3jXiSL7a/+YBquu8pJE
X-Received: from wmbfl14.prod.google.com ([2002:a05:600c:b8e:b0:43d:4ba5:b5d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6748:b0:441:b698:3431 with SMTP id 5b1f17b1804b1-442fd67205fmr30489785e9.28.1747402847441;
 Fri, 16 May 2025 06:40:47 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:13 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-8-vdonnefort@google.com>
Subject: [PATCH v5 07/25] tracing: Add events/ root files to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Just like for the kernel events directory, add 'enable', 'header_page'
and 'header_event' at the root of the trace remote events/ directory.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2aa7f77bdba0..8f94ccf3f55e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -604,7 +604,8 @@ int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq
 	trace_seq_printf(s, "\tfield: char data;\t"
 			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			 (unsigned int)offsetof(typeof(field), data),
-			 (unsigned int)buffer->subbuf_size,
+			 (unsigned int)(buffer ? buffer->subbuf_size :
+						 PAGE_SIZE - BUF_PAGE_HDR_SIZE),
 			 (unsigned int)is_signed_type(char));
 
 	return !trace_seq_has_overflowed(s);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 822cdd76e334..5065b162c8ef 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -710,10 +710,118 @@ static int remote_event_callback(const char *name, umode_t *mode, void **data,
 	return 0;
 }
 
+static ssize_t remote_events_dir_enable_write(struct file *filp, const char __user *ubuf,
+					      size_t count, loff_t *ppos)
+{
+	struct trace_remote *remote = file_inode(filp)->i_private;
+	u8 enable;
+	int i, ret;
+
+	ret = kstrtou8_from_user(ubuf, count, 10, &enable);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&remote->lock);
+
+	for (i = 0; i < remote->nr_events; i++) {
+		struct remote_event *evt = &remote->events[i];
+
+		trace_remote_enable_event(remote, evt, enable);
+	}
+
+	return count;
+}
+
+static const struct file_operations remote_events_dir_enable_fops = {
+	.write = remote_events_dir_enable_write,
+};
+
+static ssize_t
+remote_events_dir_header_page_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_seq *s;
+	int ret;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	ring_buffer_print_page_header(NULL, s);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, trace_seq_used(s));
+	kfree(s);
+
+	return ret;
+}
+
+static const struct file_operations remote_events_dir_header_page_fops = {
+	.read = remote_events_dir_header_page_read,
+};
+
+static ssize_t
+remote_events_dir_header_event_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_seq *s;
+	int ret;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	ring_buffer_print_entry_header(s);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, trace_seq_used(s));
+	kfree(s);
+
+	return ret;
+}
+
+static const struct file_operations remote_events_dir_header_event_fops = {
+	.read = remote_events_dir_header_event_read,
+};
+
+static int remote_events_dir_callback(const char *name, umode_t *mode, void **data,
+				      const struct file_operations **fops)
+{
+	if (!strcmp(name, "enable")) {
+		*mode = 0200;
+		*fops = &remote_events_dir_enable_fops;
+		return 1;
+	}
+
+	if (!strcmp(name, "header_page")) {
+		*mode = TRACEFS_MODE_READ;
+		*fops = &remote_events_dir_header_page_fops;
+		return 1;
+	}
+
+	if (!strcmp(name, "header_event")) {
+		*mode = TRACEFS_MODE_READ;
+		*fops = &remote_events_dir_header_event_fops;
+		return 1;
+	}
+
+	return 0;
+}
+
 static int trace_remote_init_eventfs(const char *remote_name, struct trace_remote *remote,
 				     struct remote_event *evt)
 {
 	struct eventfs_inode *eventfs = remote->eventfs;
+	static struct eventfs_entry dir_entries[] = {
+		{
+			.name		= "enable",
+			.callback	= remote_events_dir_callback,
+		}, {
+			.name		= "header_page",
+			.callback	= remote_events_dir_callback,
+		}, {
+			.name		= "header_event",
+			.callback	= remote_events_dir_callback,
+		}
+	};
 	static struct eventfs_entry entries[] = {
 		{
 			.name		= "enable",
@@ -729,7 +837,8 @@ static int trace_remote_init_eventfs(const char *remote_name, struct trace_remot
 	bool eventfs_create = false;
 
 	if (!eventfs) {
-		eventfs = eventfs_create_events_dir("events", remote->dentry, NULL, 0, NULL);
+		eventfs = eventfs_create_events_dir("events", remote->dentry, dir_entries,
+						    ARRAY_SIZE(dir_entries), remote);
 		if (IS_ERR(eventfs))
 			return PTR_ERR(eventfs);
 
-- 
2.49.0.1101.gccaa498523-goog

