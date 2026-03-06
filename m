Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F036E3A0B34
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807761; cv=none; b=JbMIIsancvVDnFwn4ywRKPPgz3hi5nKNaWrmBuBM4AKBnyb/MHt6HyVzubFRdUIkmh5Fwdflpju+lGMBmsN/u5fZ1BAv2/XCMZRqpYdhswRCrMOpe6wQl0Ywz9ux4EYwLNex7GYKCuHQOrp3i52vNmc7spkokGWpbPyxixmxd8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807761; c=relaxed/simple;
	bh=CQB4OHKC6a/USHlkPZV7C6bsVAu6PnT5zM7PXiaR5YY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pTQ1G+5rXSeYSEW/nyEfdY/99hunFMyIuSe1D3GVYYV5pnnTYhxX76rtDyRIRzHyMzy90os9a6swXQZP41+iu4/ORODxrpkPqf2IqXKVzg5jjOr31AsErZDjhukAK2fm/yrX86UDAxc4ZjOUJjiYF7iiuLV8OR/S9eqhA4WfchQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGRjjum8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGRjjum8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836cf00787so96814635e9.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807758; x=1773412558; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFq1QzHqVSYqV3EhHbsp/w5T0l1q5txSHzBQrIlCqvk=;
        b=bGRjjum8XniW40hts62OSnCQjkqfl6GlN+MKmZAHPSjpD+Vk3ViwZhVphUqon4+viJ
         C3RXtVAgPn6BJ40B0JA6FWxsLabKGiEJgjwukiAx8ic9AkEIiwDQgK6PJEHNElvs0wgd
         jAVyN8AYZ99z59+f2zUu5xbQQQWnBr7fZhMBxhqzNGuqw3lvA71z6UWMloY6ES7MbICH
         nmBIq1FMya/9Upze9GU0ze280icBFs8PDAEO904vTz6Z4iICXEkAqEnWVBlyvMc67jIj
         aSxSUP006yY8CAqrPcaxIEeaz5sKlbIT67i9lJ4BfPuXkx120FDvWPItq9pha7vlpe7u
         TT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807758; x=1773412558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IFq1QzHqVSYqV3EhHbsp/w5T0l1q5txSHzBQrIlCqvk=;
        b=J+L0PqVTn/KvnnVau8+qdj/jlvuuJksCZflPAfkZeHBRZTsWJoJe2F6ToKanAsJkJ6
         QkGET3B1J7wXwZETX7vF4BKrQo/N63OQKyAehi/RcGeNoZLilRXkoxfCUq1bSt+MXNJ6
         cgp1AMVVA4onzyUY2Xbyc8VcLx0REt5ahBH0c+wrwwUNrf7v39eWUBJTiKi104wQ0Swt
         RuMwDMy1UlxAvzj6LGOSm71fN2ndY/QgmTfKzUf/6zcOie9zsWEnBnTjwIARyuP0m6/e
         paL3ttqFsfioUU3RgHj7gD0+YkLMarWDTV5LXxXyfnKulgNHj7PbiYlM0wTSQVm6gFXP
         +w3A==
X-Gm-Message-State: AOJu0YxTN4G8+gMUh1hxlAFrMvlQfUouQc+tK66gwrBSyAQWADQtYyd4
	+vHWAenCnYXICoZjE52I0lyqr4wNd8gs6Eu3cWtXV4+dgMmoI71yxOfiIEoxDva7b1lm7jdqPpP
	hvaCXvYhOjmWEPfCtWspK4g==
X-Received: from wmbf16.prod.google.com ([2002:a05:600c:5950:b0:47b:d5ad:dd7f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b2b:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-48526715213mr34206555e9.3.1772807758338;
 Fri, 06 Mar 2026 06:35:58 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:10 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-7-vdonnefort@google.com>
Subject: [PATCH v13 06/32] tracing: Add reset to trace remotes
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

