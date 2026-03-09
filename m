Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5A13BD63E
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073569; cv=none; b=QQs/nBYOlSzXq2LS0CCINXK/IKm+feEQVwxe+GHxYj+Wv5r3U8E4VLf77mbHTb4kbE7Jt5RK9iwCH7gRekhmENMR5XMEbZUHyuCs6VfQ/HE4LLY+WLjXgLY51FS1fKVUzdVL5JDVXonhy7xkAzHdRNYCYaOU98ZldIjso90Vhvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073569; c=relaxed/simple;
	bh=CQB4OHKC6a/USHlkPZV7C6bsVAu6PnT5zM7PXiaR5YY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kRiYgyToRWrMPmK8zOodPWpTVOWAix2iv7W9XY0A7APtveyUcAspnAekexsM0ll2hebSDSn3j3fGqFpo1gno6sEEvJwFFg2QocnvX7buptqLxu8ATcyqIMBzanZQU48aSjAeuEM6l/2sev5+pcxSADITrH66KdsvV5NRZapsi4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1U72FKY6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1U72FKY6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4852fbfc379so23849715e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073566; x=1773678366; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFq1QzHqVSYqV3EhHbsp/w5T0l1q5txSHzBQrIlCqvk=;
        b=1U72FKY6Fd/64orBVO3k5H2HYquCf4rlyyTTodLahpaeRNmnu+yKa5mdkn6uk4Lz1h
         tSNw6V0ClkNl+TzdYoY8cuLGn2yNwKh3x7waiL3bV/ZUj7mVBRFw0PacDQs7nnnfpBTj
         vMzGKqTngaovt/tF7ysmDTaH5Aq29/1sWfUuX+9D/GjfOmUQ624hZ99ZGOjTWSkd0ZeT
         H476BCoyGNP6n/SWkr2zHaw/v5PEeMl6SBEhY2KnKQPNMHXDFG48G3e8GNfx/EkCnnoN
         9L+hL6Pjv6aZgqB1CordIVcuqIwejb0pou6bTl5Nj3CgklAcJYEtr4SSc2qMRaQ+VWNA
         OmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073566; x=1773678366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IFq1QzHqVSYqV3EhHbsp/w5T0l1q5txSHzBQrIlCqvk=;
        b=h9UYHxkj26RwyyIdeNJIEi3BPEUarqiJNWL4eRCZ16QMMc776F8rwQ7SyyITt50PHn
         z0BWx0GSUbEKhTX0fs+2kLlcVRbB1vvvYNFhYwls+eA4WXuKmYAct2azPReeeiy2TWWg
         DvxR8F1IMff6WSD+Wqpx8t+Ui3tLnxnZmKPW+qn79Cl5YILxTfrWXdEZfU7873jIbZG6
         Ln4/L7+J6MvAHy9KK6/uzH1T7X8FqXdLPaKfGZjHm4uypueP1TfHo00oHal28/nHJjls
         kp6ngLylEv7KoWz+qIIWxPUOQ1rMoiULbWmsrfzwUUzDbUWFGOjbq7otXMMAtCHzSrSi
         V5GQ==
X-Gm-Message-State: AOJu0Yxbjyv9953MSbxPwmm3n0kQYcVom/Ru66kCtVxsg5VGgc5tq8gy
	Fz3NHXrebLlsUtT8dBTCsbNUqpV+AzOraQz6YAL8rbLh8B4o+7ADcZ3Ciu2C/eoz7H6oDL0ArHc
	SzVbaZx+0kzF8zl2MavmSiw==
X-Received: from wmpj41.prod.google.com ([2002:a05:600c:48a9:b0:485:3a2f:2f7e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:64ce:b0:485:3ca4:4ef4 with SMTP id 5b1f17b1804b1-4853ca451d9mr48932985e9.9.1773073566106;
 Mon, 09 Mar 2026 09:26:06 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:24:52 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-7-vdonnefort@google.com>
Subject: [PATCH v14 06/30] tracing: Add reset to trace remotes
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index 65b7e7b8267c..10ca03dc192b 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -17,6 +17,8 @@
  *			remote to allow writing.
  * @swap_reader_page:	Called when Tracefs consumes a new page from a
  *			ring-buffer. It is expected from the remote to isolate a
+ * @reset:		Called on `echo 0 > trace`. It is expected from the
+ *			remote to reset all ring-buffer pages.
  *			new reader-page from the @cpu ring-buffer.
  */
 struct trace_remote_callbacks {
@@ -24,6 +26,7 @@ struct trace_remote_callbacks {
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
 	int	(*enable_tracing)(bool enable, void *priv);
 	int	(*swap_reader_page)(unsigned int cpu, void *priv);
+	int	(*reset)(unsigned int cpu, void *priv);
 };
 
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 8b06f730376e..a7b94736dd38 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -63,6 +63,7 @@ static int trace_remote_load(struct trace_remote *remote)
 	rb_remote->desc = desc;
 	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
 	rb_remote->priv = remote->priv;
+	rb_remote->reset = remote->cbs->reset;
 	remote->trace_buffer = ring_buffer_alloc_remote(rb_remote);
 	if (!remote->trace_buffer) {
 		remote->cbs->unload_trace_buffer(desc, remote->priv);
@@ -138,6 +139,21 @@ static int trace_remote_disable_tracing(struct trace_remote *remote)
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
@@ -414,6 +430,26 @@ static const struct file_operations trace_pipe_fops = {
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
 	struct dentry *remote_d, *percpu_d, *d;
@@ -452,6 +488,10 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 	if (!d)
 		goto err;
 
+	d = trace_create_file("trace", TRACEFS_MODE_WRITE, remote_d, remote, &trace_fops);
+	if (!d)
+		goto err;
+
 	percpu_d = tracefs_create_dir("per_cpu", remote_d);
 	if (!percpu_d) {
 		pr_err("Failed to create tracefs dir "TRACEFS_DIR"%s/per_cpu/\n", name);
@@ -474,6 +514,11 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 					  &trace_pipe_fops);
 		if (!d)
 			goto err;
+
+		d = trace_create_cpu_file("trace", TRACEFS_MODE_WRITE, cpu_d, remote, cpu,
+					  &trace_fops);
+		if (!d)
+			goto err;
 	}
 
 	return 0;
-- 
2.53.0.473.g4a7958ca14-goog

