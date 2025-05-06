Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA3289E31
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550143; cv=none; b=sv/nsnTjhHDy4p9JimjtpjlJ+Y5t5TnLJkEtvy0cgsUUPf6xsbopXl/y4YzNcRl5r3TyFab8TJIpe6ztbxFCB2P58XehR72yYsrh7ybARnxjRuqi9vQMzunqixzZ33MQCRhFSjGLHpYKAKCo3YhUVHen9WLQCvgE9DI+2TQPHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550143; c=relaxed/simple;
	bh=TjaTEjsg0+DXvyUXwwBtev0LdVcHX9+wqh45SuZo7+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhddExnKquRd6Smb+zNZjQNQKVRz8GkwpHafXD2Q26FmRcCH9T750o4oBH0XceFWIIDOf9ai6lfqe9i16mCV7irqulm3E7govtWn+D0EZPwO2vScG8lpnMeBe5Kt/cPNXf6wmepTcQx+03dMO/uLGxgcpX45tMA3PekoIYxopxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ft8NI+kS; arc=none smtp.client-ip=209.85.208.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ft8NI+kS"
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-30bfae51e79so26685651fa.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550139; x=1747154939; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Jp1lLJLaGjaKoXy64OEgzLoF8SWUPuFbMZNzmgUGvY=;
        b=ft8NI+kSaIpHDGaJUWpCJSHz54GqTbNgvMPGgxbRjv26bpojEKY3x2AYVhup0RC6eF
         9A5aDQubU4xGdA/+TJsR5Lrt0O1D8tKpgfp6htnBca1bU008JvZVqaIgeIi5sK7wJvl0
         68YKqWTjJ164R6DkqOV94AM97Aw8uS6TVZKMi6lpHcY4tHk1iZMVdtgzIS2RqNlh69Da
         33yQ2b4jGN8plcIUFUgshkTgQy/SnV43P30TGEWF3tU4U149C05kpSBEtTF8GJVwcH5N
         qWLYSl0VrGc5FuzHmXwcbXgpIqeVCIazPJr2h4FXZ6vr4X4er356MCbfnqod1GOKXZ75
         bpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550139; x=1747154939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Jp1lLJLaGjaKoXy64OEgzLoF8SWUPuFbMZNzmgUGvY=;
        b=ZxdxbcVtuGa4dDXY41L/DRkOA5AUIJi1XXYckkXLbNsYcnAS1vHkY6oDyypEG1Xs/M
         50BGrZnLh6DCUnACA/LKsFuMLnahINRvKXqfEfUtRg5zngi53cFzOwNHFurmrglIAks+
         XLiwcPX0UZ9lx3CA7tEf2CO3j3ApVt/mUSi+hwQBc86oWV9KEoeW8UTJD56EScQDU/R7
         7Y5nHeVEeq92NcTP/Yj3jt4DMcFF33NMKJoNsCijTTcM8uoeOYJ6bXdudTF27VgLf4tx
         urFi/mtYCGKdeb9nDfHgeNdbPY23dxY/wV6+N2Oq4hcIoywUf/VZ4rpf2JKGO1yTX9YA
         T6tg==
X-Gm-Message-State: AOJu0YyxMhEFKht8sDRBqs9W4m6aeLUYGLpO5zQSUI9CYfYuVxxknWIA
	rBIWrMbxD1p5VOYz4ffkebqoQPCMCPeXpRw9G06f9nsPOy87vrrbjfTwIsw8zzJGFSRfESloULT
	PkvfsjvV0k05KuJUpAw==
X-Google-Smtp-Source: AGHT+IGiXAgVMRbfLIS8SOyIvtLGncb5XoCWTw3YHC2KCY3kpynNJbuNPStX2fauF3TpS7pG9j8sT4PCVtP6V84+
X-Received: from wmbdq15.prod.google.com ([2002:a05:600c:64cf:b0:441:d228:3918])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:1c:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-441c4933d05mr112672305e9.31.1746550129253;
 Tue, 06 May 2025 09:48:49 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:02 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-7-vdonnefort@google.com>
Subject: [PATCH v4 06/24] tracing: Add events/ root files to trace remotes
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
index a96a0b231fee..cff1e700d4b7 100644
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
index 00ef80da043b..5c9f2b07941f 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -707,10 +707,118 @@ static int remote_event_callback(const char *name, umode_t *mode, void **data,
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
@@ -726,7 +834,8 @@ static int trace_remote_init_eventfs(const char *remote_name, struct trace_remot
 	bool eventfs_create = false;
 
 	if (!eventfs) {
-		eventfs = eventfs_create_events_dir("events", remote->dentry, NULL, 0, NULL);
+		eventfs = eventfs_create_events_dir("events", remote->dentry, dir_entries,
+						    ARRAY_SIZE(dir_entries), remote);
 		if (IS_ERR(eventfs))
 			return PTR_ERR(eventfs);
 
-- 
2.49.0.967.g6a0df3ecc3-goog

