Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721FB3346A0
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424279; cv=none; b=PZnUeZSoHTCAtWkJtpwnvKc4Wjs89ZWFMKVm5fX4odKN8HWO/8IjY5uGoB1EhRk0cHymPRa+6lEctE25FWwPCGKu4wQKk5G/65jDVkb7GtSBEMVnLxzD0gVT4+BrPVSS/0ZM7jD6rrdAllmx/v5ZO2fHV1uAVSn/510CnKwRg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424279; c=relaxed/simple;
	bh=1IMerFTPDsdaMH4sRfLZIFjJeFFrcEnNMSm0u7nOr9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vop/pGc+Q+m960urYPwimIqYtO/zmobx+vsMZJrD+k0bJe9FMcosn13LrSVSj5DSPKH4CBgqP62nIzSvEE4EfKbxb619uQal9+Z3OUPXZFc+MDMIthfjfQW3xgkI7Uv6UeWZRfVyj1jzMefIYgT9Gq+FyNkU/I5k37B/J1+xOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AEeFZKGB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEeFZKGB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-432c05971c6so3233200f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424276; x=1770029076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7YJRP+G3rcImUrxUFghhwl9H2MwKFHCz4aOODu5pyqY=;
        b=AEeFZKGBCXK8zn0cbvisBAC8cwW9ZdNjLYw/A/pPAASMbU3nkGT23TA40kskjM13ud
         UjT5oMGO/dUNJ3e10+8Pi8ZTaNrkkbMPavy3IPJnxV+zH8lL8AtM6xPo7qn44+meRzfl
         1RzFuqIof93AoyPl+TVH2l6hEItnHguAQP2vfFhT6/4z4ThHFUeg5ri8CkBJueXlNzpZ
         4qsLraveSHS9nlA+v5WBaC5O3QS7k1i7z3JnMvCvwfxQo0CBCzbW8xL8Bk5xmgxSTWUZ
         EPRmJ4I+bVEk6nsYh9mvrXsXiKb9F/qUgo+szkMvpxtXeW8cOcwzPP7gNvPwoOTEhQf1
         RUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424276; x=1770029076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YJRP+G3rcImUrxUFghhwl9H2MwKFHCz4aOODu5pyqY=;
        b=P/NHBy0mi3JMbnqpEZYUw7+RwKu5nAWTo2sIZgwMwXdRCm094fv3C0SC9KBiYSSqFS
         tcmKGED3+D8iC87A/IneMaOcT7U6udcL8FYHKIeMsXYXDK2q6JEWhMNj28FESoTDVqTH
         koSW1BdQPQksVwm9c4thzW6AmTKHknlmwuC1g0KaFE2ruDgn5SjzRQbF61OFHGHFaz7t
         mDNO6irpGMyz2nD7B4oZQE6DqeuQzX37uV2od8jEODHPkYZu9w00YUfZr0jlG8XzZ/YJ
         dV6k/OfdVwvCfVmSnI6QAIUtS3CGbpVbeJkNuPOHW6kiYrO2ss2UA87NPGxK4LtYxdvV
         1t9g==
X-Gm-Message-State: AOJu0YzC2lYvAiuDiv5fjv2rgRq/7n5wLKY7x3TnhGHEBrVkOeube00o
	Y8uE2i00NU63NdXmPkPtakmndzXRKGbEGQRClkSG1mBGHKoUi2T/Uql1bsyMiKL0HBLjAyFjsWO
	J1gL+YKbQK4RcQFdx+XjHJw==
X-Received: from wrbcm18.prod.google.com ([2002:a5d:5f52:0:b0:42f:bb9e:9b09])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1449:b0:435:9336:21f3 with SMTP id ffacd0b85a97d-435c9a9c00emr6590304f8f.10.1769424275822;
 Mon, 26 Jan 2026 02:44:35 -0800 (PST)
Date: Mon, 26 Jan 2026 10:43:59 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-11-vdonnefort@google.com>
Subject: [PATCH v10 10/30] tracing: Add events/ root files to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Just like for the kernel events directory, add 'enable', 'header_page'
and 'header_event' at the root of the trace remote events/ directory.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d08dd326309..e28cc02d1a70 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -639,7 +639,8 @@ int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq
 	trace_seq_printf(s, "\tfield: char data;\t"
 			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			 (unsigned int)offsetof(typeof(field), data),
-			 (unsigned int)buffer->subbuf_size,
+			 (unsigned int)(buffer ? buffer->subbuf_size :
+						 PAGE_SIZE - BUF_PAGE_HDR_SIZE),
 			 (unsigned int)is_signed_type(char));
 
 	return !trace_seq_has_overflowed(s);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 8527804f2d22..e54cc3e75dc5 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1078,10 +1078,145 @@ static int remote_event_callback(const char *name, umode_t *mode, void **data,
 	return 0;
 }
 
+static ssize_t remote_events_dir_enable_write(struct file *filp, const char __user *ubuf,
+					      size_t count, loff_t *ppos)
+{
+	struct trace_remote *remote = file_inode(filp)->i_private;
+	int i, ret;
+	u8 enable;
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
+static ssize_t remote_events_dir_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
+					     loff_t *ppos)
+{
+	struct trace_remote *remote = file_inode(filp)->i_private;
+	const char enabled_char[] = {'0', '1', 'X'};
+	char enabled_str[] = " \n";
+	int i, enabled = -1;
+
+	guard(mutex)(&remote->lock);
+
+	for (i = 0; i < remote->nr_events; i++) {
+		struct remote_event *evt = &remote->events[i];
+
+		if (enabled == -1) {
+			enabled = evt->enabled;
+		} else if (enabled != evt->enabled) {
+			enabled = 2;
+			break;
+		}
+	}
+
+	enabled_str[0] = enabled_char[enabled == -1 ? 0 : enabled];
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, enabled_str, 2);
+}
+
+static const struct file_operations remote_events_dir_enable_fops = {
+	.write = remote_events_dir_enable_write,
+	.read = remote_events_dir_enable_read,
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
+		*mode = TRACEFS_MODE_WRITE;
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
@@ -1097,7 +1232,8 @@ static int trace_remote_init_eventfs(const char *remote_name, struct trace_remot
 	bool eventfs_create = false;
 
 	if (!eventfs) {
-		eventfs = eventfs_create_events_dir("events", remote->dentry, NULL, 0, NULL);
+		eventfs = eventfs_create_events_dir("events", remote->dentry, dir_entries,
+						    ARRAY_SIZE(dir_entries), remote);
 		if (IS_ERR(eventfs))
 			return PTR_ERR(eventfs);
 
-- 
2.52.0.457.g6b5491de43-goog

