Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761C4302CC0
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508337; cv=none; b=n8hNvMobpTdkR7qbHPmnK3CS53w8kjsWJuxzPYz8r/xm/DsgkLSc702X4ogc9gObBEe/orvjK2O5yqKmnt3SS9Zv8qqVXNguqwz80MKJbjUhfGQvmOrimVpqgLUrp9yUeZK3pUls/3pcf9Fr0cMGmNM9tfECqfNdKRKJ260ygxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508337; c=relaxed/simple;
	bh=jEEXGy35HUpQAP9zQUnxHJyKz/LFgG7vcsNpQLwnFy0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=chPH0zr4ptVnI8l63yLkwy4BhUBeFx/XemP8nHTisO1IRHmTrlCK1/3cBAG7T4UkDLfYqiSNmzq4pV+4wPTsxqRwI8KVBWDNffbll+qe/upDiONp76CwbBuRfd6PccJkVSdd2Kp74l8kX/pOVi02lz5l3S4Ov27Yykas1a+lsJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lhToP7Cr; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lhToP7Cr"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b726760acb7so83243766b.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508334; x=1763113134; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7u3zBILwoXGQwoYC0Xq9BW4AZq6+iJ2od8CaDzzVgvE=;
        b=lhToP7CrR0KiUtbANORir+pIP6iWAB3C958MzrLzelBCRn0rTOXBGx4imv7zj8nJQb
         Z5QSaYI0d4tLwLSEU+iEsOFLObLlwgmkNh2ObX4w3sSsGCG6tjbkoi8ObMCY/qNYA1Sg
         JcmmVI99ubqxEjhh6ZVV1ciWiOyv7QCwZ3nR/Q+lX27mClqoOHCRW/RgpZjMtNJpOBt6
         +aPIXUpwmxLqPOeL64c/H7njeDt0Ah1Qg6qT8JPk1VPTv822K0AFkDskEUf9xINSr//A
         LvYm1h2sczC7GohPJtILAheO7cC29xDL1oB7PlltMCOH29mc6J6N4byNa9STXjHWHHH6
         6Izg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508334; x=1763113134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7u3zBILwoXGQwoYC0Xq9BW4AZq6+iJ2od8CaDzzVgvE=;
        b=SFtQ7nSL0S9Vmg6YtujSsVUyvjDfAi0F6GfodzV8/64oScuLAWIousYuWUDNz3oYzk
         ppLU2ilLpGeesLIXYjAxedwQnfeD1Yq6C9vlVq9CvcVxkM9XBCyTVrMEmMbXqcSiWb8L
         J+3fs/ECJcW9CsuFEKkLAf1NShvwVylhMRy2RDevH7ZjX1mzph399PxmLRrvlHSFePZL
         0z+gCW92oT51ttzVWMQ9jczvT39g8Vpqiqg+GEz1IlwQagqDJObue6yljxhZOdOiv5QI
         A+xFHy/og8vjltr7B/y8Pc+h9bOTwNLIf6Orz0/WX66qXXPJslBSM5S37jQEl/S33qkV
         Oiwg==
X-Gm-Message-State: AOJu0YzwFFT7JfPu+RGOID1uC7vwAXaX5KZFB0zpQxC/9kUKYc3uQx5j
	DBjcWldH3bd0ptbLZuNyYe2LOxU7WBNBLvEBXwu19W05ObuaQXbBTYhWcU505wUDcHqsMGijvVN
	vYReY/jUxdaxFL60o9wmj8Q==
X-Google-Smtp-Source: AGHT+IHgDkuNncZlaLiNpLMu3aTitmPuR0CM9YTcGFIKOu+7HlV3Qva/fuAcZvKIOdIctQ4yRTHRz1pClFG3h2kI
X-Received: from ejcqo8.prod.google.com ([2002:a17:907:8748:b0:b72:41e4:751a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e28:b0:b72:b495:828c with SMTP id a640c23a62f3a-b72c090e60amr266298966b.30.1762508333943;
 Fri, 07 Nov 2025 01:38:53 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:18 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-7-vdonnefort@google.com>
Subject: [PATCH v8 06/28] tracing: Add reset to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow to reset the trace remote buffer by writing to the Tracefs "trace"
file. This is similar to the regular Tracefs interface.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index feb3433c2128..55754ef78104 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -18,6 +18,8 @@
  *			remote to allow writing.
  * @swap_reader_page:	Called when Tracefs consumes a new page from a
  *			ring-buffer. It is expected from the remote to isolate a
+ * @reset:		Called on `echo 0 > trace`. It is expected from the
+ *			remote to reset all ring-buffer pages.
  *			new reader-page from the @cpu ring-buffer.
  */
 struct trace_remote_callbacks {
@@ -25,6 +27,7 @@ struct trace_remote_callbacks {
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
 	int	(*enable_tracing)(bool enable, void *priv);
 	int	(*swap_reader_page)(unsigned int cpu, void *priv);
+	int	(*reset)(unsigned int cpu, void *priv);
 };
 
 /**
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 3d80ff98fd90..49c4ae127533 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -63,6 +63,7 @@ static int trace_remote_load(struct trace_remote *remote)
 	rb_remote->desc = remote->trace_buffer_desc;
 	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
 	rb_remote->priv = remote->priv;
+	rb_remote->reset = remote->cbs->reset;
 	remote->trace_buffer = ring_buffer_alloc_remote(rb_remote);
 	if (!remote->trace_buffer) {
 		remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
@@ -136,6 +137,21 @@ static int trace_remote_disable_tracing(struct trace_remote *remote)
 	return 0;
 }
 
+static void trace_remote_reset(struct trace_remote *remote, int cpu)
+{
+	lockdep_assert_held(&remote->lock);
+
+	if (!trace_remote_loaded(remote))
+		return;
+
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		ring_buffer_reset(remote->trace_buffer);
+	else
+		ring_buffer_reset_cpu(remote->trace_buffer, cpu);
+
+	trace_remote_try_unload(remote);
+}
+
 static ssize_t
 tracing_on_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
 {
@@ -410,6 +426,26 @@ static const struct file_operations trace_pipe_fops = {
 	.release	= trace_pipe_release,
 };
 
+static ssize_t trace_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct inode *inode = file_inode(filp);
+	struct trace_remote *remote = inode->i_private;
+	int cpu = RING_BUFFER_ALL_CPUS;
+
+	if (inode->i_cdev)
+		cpu = (long)inode->i_cdev - 1;
+
+	guard(mutex)(&remote->lock);
+
+	trace_remote_reset(remote, cpu);
+
+	return cnt;
+}
+
+static const struct file_operations trace_fops = {
+	.write		= trace_write,
+};
+
 static int trace_remote_init_tracefs(const char *name, struct trace_remote *remote)
 {
 	struct dentry *remote_d, *percpu_d;
@@ -440,7 +476,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
 			       &buffer_size_kb_fops) ||
 	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
-			       &trace_pipe_fops))
+			       &trace_pipe_fops) ||
+	    !trace_create_file("trace", TRACEFS_MODE_WRITE, remote_d, remote,
+			       &trace_fops))
 		goto err;
 
 	percpu_d = tracefs_create_dir("per_cpu", remote_d);
@@ -462,7 +500,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 		}
 
 		if (!trace_create_cpu_file("trace_pipe", TRACEFS_MODE_READ, cpu_d, remote, cpu,
-					   &trace_pipe_fops))
+					   &trace_pipe_fops) ||
+		    !trace_create_cpu_file("trace", TRACEFS_MODE_WRITE, cpu_d, remote, cpu,
+					   &trace_fops))
 			goto err;
 	}
 
-- 
2.51.2.1041.gc1ab5b90ca-goog

