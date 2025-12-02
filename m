Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC830EF7D
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668200; cv=none; b=lQpfk/reVvLPzOFpf+CoVhy8M/7SQgGgCg66x8JVmHBVWfVVu8Wy4p6pIf7tiuJiZ2ujOOQ870zVWoj1nRFu0TuqZnhEGxmA39w1LeXoJj087JioO1KEJQ9aop/vNyLHM5Z8/ZiKeH3zzJxS+Bky7Iw8v9UoX5OAjoPA3Nz0whA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668200; c=relaxed/simple;
	bh=GEbDPswJObLVM5imaD3jz2zSO56cmYdUJUSIw1nA/RI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y2IN3jCkwoknlChCTLNhzT1/zbwAM2+kCO8Gr+kuMvdvONRz5UQVwAx6IE6qGgcCAwIOY8wDSCPym028Y4XExKOlK+f34ecLFE4svfXLVX0yaYQik6sCBQqdIh1+XdsmcZAX4lm/nVhpLUtNuYwVTBuXhwwoIplJ6zubm2DW1Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nw6F6Hwm; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nw6F6Hwm"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42e2973a812so2029622f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668197; x=1765272997; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bcApg1r9cceQ4UL6VhszcyvjDlQOmmlVckdEJQB7+XM=;
        b=nw6F6Hwmd7IMOSdPv8zL4bmxi9ufhOb09ZgKGgsAM+qXcJiCa81shN0E2rq6ni02HQ
         qPAEMIy4Rgn8KKF7s9fjxNH5HiGOy60s7NelnX8tZcYYHSG98E2SyXy6Q8R8c+iN0652
         K1dtHJlJ941jE0zcYaFXraVPXMPVa29ngXG9KPNlq0iwttcHhfPqw3IAqdjOA86jkocX
         6Obsgy3WQfb+nLsUPW3hkWDpOxk6r7gGx2tz8Jk8vk8g35a52gSwhShj/yhQqR7jbaJc
         xqjG41xQQALbld4ollqFIGmGe4BKSceZ/XtAx4IE0ApjCQUWxAnzWZP++hQgpQ2yEbgk
         aaHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668197; x=1765272997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcApg1r9cceQ4UL6VhszcyvjDlQOmmlVckdEJQB7+XM=;
        b=tfrS0RmZM1LsexJlXdoRZwQLUKVncyH+JMQymHSFv+q9W80a9unynx2Vr8e6JbX8BJ
         RUiPBvAW6Je8ViFFA+ASN+7OqN8niU8b+mfpGZIpH4O7u3zZcEKLVYbGqx7Fg6YocUb7
         766ZuBCkE2JrsZOhDTO/HJ8Vu6zFDa3VsDhqzdjFTZq7y4F+tkwunWDZL/WCGIIQ2vEQ
         6cK4qXLuPO+IBVhwk4JaajpOWfnFKb9yYrfzrvJBOCBBKentXgK+8xA5pzI/NHep8wX8
         b9bZrAdBnypCoDiiyOexrH5Gdw6Q9efI3jlNsbkMLalHaLjA0FFwStCtp+OnInzm2KvZ
         9JWw==
X-Gm-Message-State: AOJu0Yy/OYd+XraVxcgI8T/v1aQ5eS7v5u/jSA8DKdABLdah6T5+KuAm
	+zOrW4PYa9uFX2WLKLd7/bhsw3evIWOiQlk/iokU4guLKDMWrdR9GWdl7KBj/fBrNgdQeHNHl6n
	3QfRbqNuszlo3H8qf08Hv3g==
X-Google-Smtp-Source: AGHT+IH3TJvr2zAYSXNT15LqvRIVfjNU8KvCMY3SDV8a8EoKXObb9LHToW89bbL0XkNsfdv16z/uBGgWK/weaUkA
X-Received: from wrbdn6.prod.google.com ([2002:a05:6000:c06:b0:42b:349a:10fc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a87:b0:42b:3661:304e with SMTP id ffacd0b85a97d-42f6d5a0bf6mr1991537f8f.16.1764668196824;
 Tue, 02 Dec 2025 01:36:36 -0800 (PST)
Date: Tue,  2 Dec 2025 09:35:59 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-7-vdonnefort@google.com>
Subject: [PATCH v9 06/30] tracing: Add reset to trace remotes
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
2.52.0.107.ga0afd4fd5b-goog

