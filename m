Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8027D21CFE0
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498751; cv=none; b=czE6lgsF5Ca+EWoyodz0IUgrGEBpVCC6pbENsVLsuPIpUmvXP74oLEqir5x/nJ6QhoMt2MBVBxe2CgdKzJdz2dX8bDEzuqxJXcf9JA49rfAorO1U0lczoMwSZuI3zN2LMyS63j1vxFeRibjDQuLNa/wPrJftfSyzFIr9+fvI7DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498751; c=relaxed/simple;
	bh=QUPYfbDskoW1V0zL8PrtXLcVNc0Rj9seLNH5bvzhzHg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oT1TNFsVxf2gXTw7b7yx+BVOm3zQv9tUqFNMQbBJU7jBW7rfAjMiV7NqBgGYez6uSi76VE07KPnw937L6FloT37bYuJnfT/Il5aS0FfJgiHtqEG3jFDJocQheqptOMAH4eVG557jOZnq+OlSj+T42SPKa2AZzSUdpZdEOiPIMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k2SgY4n8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k2SgY4n8"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42557bdbe50so1788789f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498746; x=1760103546; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNuzwqo0SryxPVWfT4A633RiduwyoKQb5duSwc7WjqM=;
        b=k2SgY4n88bxIYH63S7UkoaxDVqL/DnsvLREUaNdQx3ghdi1j58pmWP9nLOnDok/Rc0
         bZgkx6cMoAZAGowsrL7XTm9i2UAJqLUtpN66iYnmrLp10OlkhGbNCB/jerGuJ5Lq3Xio
         7MwAyZQVOgz7v8UrDmd7M+DgSGJDLXgeVRWtXEl1OXxgc4e261UOOn98Z1TcSEMtQ3FQ
         0OzQy620mCrpqP5EID1Np5mdbF1ziiA7b/VuU+8ONaq0ASCK4HVh08PcESw4T7/iTTvx
         V7watJU/piM9bBaQsjltpQuODyfS8cjQ5J+HRWEJfimGeKBduD39KGbG2niSH3fUvIdV
         OorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498746; x=1760103546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNuzwqo0SryxPVWfT4A633RiduwyoKQb5duSwc7WjqM=;
        b=bxzoCEWNH6Imz+bvjCayqc+nMsU7LgKkdeMc5+C9OXZq9tRGZv5Tpdj6uU+ciNl7By
         DdYNlkQlfj7PdJHKjXhpDo4nvn4lDJ9BJSfYmDc7KOVcb4XeQ73791fUU4TJh1zOL5VJ
         fyuU8NMwHOznvctGTg+8GJIof5mNh2pOxfME/gKiuPl1clQCxvi4RqDLT7TH+IsN3NLD
         k9N4LyTcQNc2kwpDEhK8lDjsLvItj/OmBMpzO3pOaGulu9/5Dd0DIUxJnttfc4Oj6t7N
         CLWX+rkyWuymMwCKp6+9deuULZEyStFmLuYjKzKS/3i24tGyrnS0PNEAyXe81VSiFPa1
         jovg==
X-Gm-Message-State: AOJu0Yyb7k1IOSGVHjq0iCqmdT1BLb7kE0OOhor/rKR2pNlYhx98qSzK
	DXXCI4llkTaCCPP/UV5GXuwLv4yShwppWvswhxhr/7fSZ+ZC+zHKi5REfTPDcsRGndFs1pPMEtm
	sI7K3RLxO6inSsRa/TJLdFA==
X-Google-Smtp-Source: AGHT+IHdLlzmFSd/8uLT/n+RQpFrBV4OeFRePRaDs9j8FRUA3U3c+FD2rubzZ09J18jdk0ft6f5Qd0MP++kgD1NG
X-Received: from wmrk19.prod.google.com ([2002:a05:600c:b53:b0:46e:5ad6:9013])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:11:b0:46e:6d12:ee2a with SMTP id 5b1f17b1804b1-46e6d12f14dmr30146875e9.16.1759498746709;
 Fri, 03 Oct 2025 06:39:06 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:07 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-11-vdonnefort@google.com>
Subject: [PATCH v7 10/28] tracing: Add events/ root files to trace remotes
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
index eb556e691b5e..a26a6f537f87 100644
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
index 9504d9c04bef..1bc9c9a5197f 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1075,10 +1075,145 @@ static int remote_event_callback(const char *name, umode_t *mode, void **data,
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
@@ -1094,7 +1229,8 @@ static int trace_remote_init_eventfs(const char *remote_name, struct trace_remot
 	bool eventfs_create = false;
 
 	if (!eventfs) {
-		eventfs = eventfs_create_events_dir("events", remote->dentry, NULL, 0, NULL);
+		eventfs = eventfs_create_events_dir("events", remote->dentry, dir_entries,
+						    ARRAY_SIZE(dir_entries), remote);
 		if (IS_ERR(eventfs))
 			return PTR_ERR(eventfs);
 
-- 
2.51.0.618.g983fd99d29-goog

