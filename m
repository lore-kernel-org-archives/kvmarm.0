Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC662EA46E
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764075; cv=none; b=BLGr/yBL526fcqwsKxnKQX1QD85WrdR6I59qTGEXULYC0Qd6PtgC2AgO+FXvFeHWPqRy721XWyW/ck6XCoaFYjkjgf/B/kLrmAThqInPiWOjbgppMzC0Sjh/iaW84SqfHjyqYCo4hSzLefYhdg6X0pBvVJFlpehHGkO4+M7pumI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764075; c=relaxed/simple;
	bh=yNjrtYzdqxSOJA8JMtlyFP25XGNSVeq6WWnFHimuLUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R92UEegXEH62dY9VFGE9+vdJF20n0iNPCnHYur58mwErl75f4Sc1QjUiT3Sa5mqFoT3nXRar9pOSqwCXxzkpcIAfdvglv2/CXGpPjOCriBlkSTL1JROznMMg9+rwrxZpMIh/guBHmivV0tNR+x6XItbaj/qnXkRU+xKbxlminYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOvucHkk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOvucHkk"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so2866085e9.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764071; x=1756368871; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7jqXM3IQFmwL7/KyPBrOmBEtNR7claVQSXPHpFSy3Pw=;
        b=eOvucHkkKMlpEidZOnUiF63cLfllI62S4L7CCAQd9j9rTVzqdLZ+aSC1GfWcyJGjMB
         RjyWsOUOYBSRfwkiCTn849gUw4PC28kcKzh7mFHHcLDenMRn+zfYB8mhaTi27fzvOh5B
         9AmU+kD6FrzsRJomK220HQ9EtAoXmgbyOkiRwoWgbNLRABq4RCstvAeFSMFeFSnDrlP2
         8/r5OssEOkwUaLrAT++ADdBMb/NR2g0h0JjmK6Y3gOZqk5qd+Z9n8O3dSvJptorfFAT/
         7Xe/DIlSYE43+iPK19gfx2cMjiZH04oYfyA5wiyD0wMu/Q6zDa8qQo+y3/pnWIIBK+FW
         F6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764071; x=1756368871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jqXM3IQFmwL7/KyPBrOmBEtNR7claVQSXPHpFSy3Pw=;
        b=T/0cakt6C0j6bMh3Z8icXgmklzIUeGef1eNLJGe0BNeWHpBKaJtZBiOMahkDbLSVqa
         GFispsEiqmWJSMns2R0znN21egg7xdynMTNRH7X5W9C+/imLUINOS+8UShi2qeTBl2GD
         BijPEfra9zy86/Sdq0ZjOz0NuapEaHZkP6gkUx1h1lS3u7dzu+SWGSgOEi9zzmaJuun1
         5CAAzkzjSfB/aJ09LtxGRfv7N0CK+8/rd9IVe0WPRMsfeCOM1QqjoaiNvJ1RAWfJ0Var
         Gh9v/silnj/LMvubPi76Hu7aQd56r+sZdADk4jYREb+fMRFJjBvx5OrIyT6RhhzlKZb0
         Xvkg==
X-Gm-Message-State: AOJu0YwxjXInWyg8XefpfohiWKjXtQS/jLiSBroYCx007jfXUCAA5gAn
	o8BehtFPRfIyrarQI+lhXQ0ri99TtXmSV3gp5NSNrKrugWzJxFckOoNpk79RSs0uTbmDpv+sue2
	3NGD559y3MC+MSYbtJvkPag==
X-Google-Smtp-Source: AGHT+IE+BeKNnnBgP2hFtel0lnCMgkmekl+cgM70ekcw14+86Zb79b7FW6ixmJANsDqQXBnK6UuwhPfLQJtGZ17a
X-Received: from wmti5.prod.google.com ([2002:a05:600c:8b85:b0:458:715c:51a1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19cb:b0:456:1e5a:8879 with SMTP id 5b1f17b1804b1-45b4d7da9b7mr13059725e9.9.1755764071698;
 Thu, 21 Aug 2025 01:14:31 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:13:55 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-8-vdonnefort@google.com>
Subject: [PATCH v6 07/24] tracing: Add events/ root files to trace remotes
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
index 8044cb23ef88..17f77653b926 100644
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
2.51.0.rc2.233.g662b1ed5c5-goog

