Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1CB311589
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508342; cv=none; b=jdV7wXcMHDhcyigfxp8By6SqieEhT+8HCkvRjxtVvZJ6Tr3QcjDh4r2X39CVoK+qYpBcEgrOhMqx5cx7skgO/h2WVL4tgm/WQxWNw2tRVoy67EgtAXkjR848T2PIP9XJjYZTNxVkHHHS+K6OXWYmaVq8BWbdczd8HZhK+RPhTag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508342; c=relaxed/simple;
	bh=20KZ/x5nrqsEIirl5ZplFAB6PraCZm59OdztjlsBQWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nhj3Mb1m7bE1qGawJAThvbJ0ahw2oC/P487C/KaiNlWWrPOJ02Wua0p+Z3n1p5pofqhMKx6PM/PHj41VLYFwX0A6+mQN7JtkAc+KZOwnxj5XUvQ7rq9Bi0EFzpnmRfz0JDCaXEf24EpxaIZXu3OJHfV2o7gTUzQvLHBQitILHno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eV3LuCb4; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eV3LuCb4"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so347836f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508338; x=1763113138; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJcchofQoVMS00YA2MOITdHnNd8nQYavzgR4H5PvjU8=;
        b=eV3LuCb4AaOnfWx2T8DYLyiWRTScA2eNXHf8FSwn4v52xQQaIvbjK3lumjuKF5xEjS
         LiFmRSdvLjrwRS3Rsgbtf0mD8C7CdgEysTzRuCpP5WfHcQK7rtvNgM/Xg9gfqCYMMuP+
         wkIRBET2lz93luKLJu+s4nIxb4VvcsOBlNE+LvF1pnvyTdO+0bxHuznGa+kgwzsdVcMo
         gJg1gM0XVaJMNWNm33zqFZA4/Bgqg/udcpejqw9HhBamvCdp4qCWv2Bfb/pdDNAMhVko
         /OZ4mSKf6HWL63tbTuoqLFmaYbwyR/SZn/waBrCchT5Qs14Zyyu2irBVPVZ9RFa+1wtf
         01vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508338; x=1763113138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJcchofQoVMS00YA2MOITdHnNd8nQYavzgR4H5PvjU8=;
        b=lwyiiaWJi53+khuAtMxM+W1JcagLW3mveVF1Wv7p7jFm5MN/zcK/laCX6OJ++hbVSZ
         5huvf+gxmSys9LbMHzDVYbYCiNaAkXCHqUtIzKnbMB61JD+V6/rINxexVgzk1c0ivy15
         czGRPWGy7mp3TIZUPo7BLwcoJFy6VW1f9QhwKbBMdFnF3cppOfQKs75/pYLL7eiuUzY8
         BaGDBmHUlDeDTEoNinTuQLncdd7EeLP0zv5KWhBSjKqFZftxpo5aCpCCvNz9bD9138RM
         LmTTzP4sBIjfInxD8bYi1T6qqV68puFt5IKdTyuix1EKstAy2OntKeDBeGq/DR6mvhkt
         eZqQ==
X-Gm-Message-State: AOJu0YxmXoJiu8z+5GVzAXTnSZ+0hY1WegXQV2WlxkJdJn0tiq7F4IQ6
	vHOGUh5MblhFrpfTq5V1v9lugGD+TmU8d/K6ackx7BJwF5dd9LsaWPk7v49VqkPmS2xG517OXXU
	QYJlTjy8rQVQuCdfHtA2x1w==
X-Google-Smtp-Source: AGHT+IFZC5BqbrsKWQKCQ336VVxlGCY+mQ6LwsxcCpJ4Gtknluos4raBCaFp3StIQwp/OhM1qMb5B7Y9hxL0l4eT
X-Received: from wma14.prod.google.com ([2002:a05:600c:890e:b0:477:10f8:4597])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46ce:b0:45b:80ff:58f7 with SMTP id 5b1f17b1804b1-4776bcceb98mr20269535e9.36.1762508338137;
 Fri, 07 Nov 2025 01:38:58 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:22 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-11-vdonnefort@google.com>
Subject: [PATCH v8 10/28] tracing: Add events/ root files to trace remotes
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
index 4cc5da5cdc87..41975b92a960 100644
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
index 0131fa8e177a..4f2b67d1bfec 100644
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
2.51.2.1041.gc1ab5b90ca-goog

