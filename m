Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343BF342535
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513408; cv=none; b=CeQ0MiKiD6jI0jazC4I53gYWFLIgZ8hxMMpR/sSRbGQ7Mn8yOSGSxEkyl1z9+dYbL1qCWhRyOrHTSoQ9U4yQPwzZktafMa/lEaSnmnSBAF/+ltVxfeeKbi7S/Ec/lhCzL2QoOTUXh/AdFCpp/biSsHipZ8JkA0g+ARD9Qu4paYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513408; c=relaxed/simple;
	bh=Ia5GvWXuWKlkAsI1yDBlSrW60G/OSv3BnAiALWJuitM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G1b4YjlWvF78rpL5/hiKtH7e3MNYVzZVrUpQLtvUR6mhFk/h5BzNXAKouQHdhSJZD+wYUQMi2L4uhvrO3zQCU+ZVAc8vWoKD7LkyuRUTmM2NJU0lYP3bpHrCBGBeoqEJCNRoKzLlv81T1MViWdLnguUIgm0r4u+0U5ATHImVWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ymt5sKq7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ymt5sKq7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so10731655e9.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513404; x=1772118204; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrhhrmHzIsZI2KCLr8Q8iAPC9xtikp6+6Y5SdjRW0GY=;
        b=ymt5sKq7Gl9IEnHcOwvVYea8UMunlLn6/kVi6+wcXeH/ho/02zdyGw0DSFbHonQ91Z
         UReK5MsQ9gPtU4JmgRwy1DS9EM3pF3sp2GB0hwd/YEf8Auy0EYO8/lGiAjTYYre/MR6e
         280lU2NfkL1sc4npL7R94upC+/+g5ZIT75632KGDruf1sZxoSwkuelhLL//RhU/duMdd
         hM99cfgN2WpVCRyfNYa/seALdmB7WxIfoepLW4M5C2PueHIkXnZaLslIsKoXseZg2pv0
         hyIehT3swXyEt/toimPOhqQQjMbH+qhKO67FjZf/tMTUAx6RRTBNLSAF1IfhtKL3qyvs
         ssEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513404; x=1772118204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrhhrmHzIsZI2KCLr8Q8iAPC9xtikp6+6Y5SdjRW0GY=;
        b=Mrjo5jYJ9ct98z4XaqAn5gWm0sIBNvRpbI0hwRNk+elQxbRawchPD5dueyk9S/LW5V
         QbyIsgjRvwEN309xay/DRgFACbAIMd4OBHeWfqH0VuTYq6KIHe72t1wiFWB6CZ4bE44u
         jk6JQ7gM9ICYaAJAJAcRHHV3RipzCF9pYJ4lnI3EYr2FSwBRvVZDwnNrBMvmz9JuRHwR
         RZiK1PAN01ZxtfUQjQA1yp1LiNPR2Jj2W603VCRKtCzLEbb9pTupIEUc6o5yjKB1MOXo
         1nP21dgdiuWCRsZ19it6G9wkuRbd+4pTae+D/bZSCLvFULMYiOu2MpdHzQZZWB7Hm46N
         w4XA==
X-Gm-Message-State: AOJu0YyUjTnRGlFsCNYMN+P2SVom+w8YOWOmbc6VGCWncXAxAJANL96m
	u3sNTSDJD0Cj82Vd4B0OYpnxbnEzxWKBCjh5jIp6KWS6AcGsVxZU23ZtwGeFHRCQ4JJ67rV1kz5
	IPTBL+9cgBFVT2RH09YncQA==
X-Received: from wmbes20.prod.google.com ([2002:a05:600c:8114:b0:483:6fc1:fcdb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6443:10b0:483:8062:b43 with SMTP id 5b1f17b1804b1-48380620d3amr203528975e9.19.1771513404539;
 Thu, 19 Feb 2026 07:03:24 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:43 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-7-vdonnefort@google.com>
Subject: [PATCH v12 06/30] tracing: Add reset to trace remotes
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
index 7015280cc9d3..83593fb8b425 100644
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
2.53.0.335.g19a08e0c02-goog

