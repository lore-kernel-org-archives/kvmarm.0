Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801FF15665C
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402845; cv=none; b=INiceM0X+bz/hj7lHqm3371Tvarc8eoRpdjzoeVKElkaLTGTDL5wuVpqhimeS18uhywe9pne/kgxtSlM8n17mkX7T7bfHV5Wepj6faIiZXZE+xf9OxuCJKPKF8/fNncM7j3mi67+7/BxWkE6NTIOEQG8tlcwIXgGT3NWz/U1U0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402845; c=relaxed/simple;
	bh=YFkzXccah27/yG/QJUAXKmAFqo/R3OMiygNwFMlOMH0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=psoRwaFaZfeA2HOsJd2+Yi2vDLUTFXKjrlQ6T/iJw23MSBql24upCB1SbiVr7kNZuxII+tPuNLMcfg3wDiA+gn9eZ1hlIBa1hutPoL4Zw653WD5cuJuLT7KGsK9kjE4rYvlAmc9VhrLCSHjWRJG5KdZwPtTdvq0DjOq2gS4nCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gMOsmKWE; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gMOsmKWE"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442cdf07ad9so12505015e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402842; x=1748007642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qN1qLB688cXUuZ/HXgT/LV4b04RQzcH3V2EM2BOQMbg=;
        b=gMOsmKWEP9AAdGIGybuwbzRAmaT/Df4rOMT1QMTSQSL5/Tikc/vkGrysC08Hogy2dn
         fzOFkaRGuiyvlMZZGZxFVk8bVSTCwrpDDkqAYAy5gBUcsaqM0JshIXGYnCEz/YgGExSo
         AqkT+Xnbo9+kvRyT5Aocjuo+YJSy90TTT4XnX85x/lsZAIAO2pQ4f7ga896DYKszWzPJ
         HFPGbfaosI8dxsDYH23pXKHE/3SoKhWVbua74B6vO2oi/F9BVW0U35LcaCZ6+bZ8d+H/
         s9eyZIYnsO0KQMg42VYP02N/uwZ0GSzhqm7yuYM6NH3QVFqj1s/mpCWpgn07rLvtP1hK
         rBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402842; x=1748007642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qN1qLB688cXUuZ/HXgT/LV4b04RQzcH3V2EM2BOQMbg=;
        b=aOA1mS3val/d/egSDunHyFJBoZQxUWsRBFccyPsUboQ0qRi2VLr5VrY0R3LXyAVcGb
         R23HbnSluJ18RqNwI/UTer4H5DeWEeTaypN+tgMTpdaUTFb5ljbhYvsTJIhjozEC1qA4
         7+LztxPetc7LK2GnwGzi9RBOTB1tBmJchg5laIdm3C9ZJF+0aDoXomsmRMLAOYinLIul
         jihYVGA7EjnUXA79W0SfXDEZBAsSHU6p/y6YjzGmW1bO9OSlWuQUEsrNuWPhaygICHn0
         HKkMfVluiAW731grJRI/58UTutLNKdUhtdn3mvCwLG8r8Yp66zGxoohoYnqc4UAI1oJT
         nb5A==
X-Gm-Message-State: AOJu0YzjXp+juybVmf2VU1/XdxCy9mtUH+BB7nmCPZ9zqKgRnqlM324R
	r8+8L8ypfiX9Tgo16xxgqOlTyVKfDE1j5XntaL72mgzZe+L7mjt0LCq8hBFvQsUAXPY6P+cVw4N
	90VVu+wUKhQDjnrhmim7+iw==
X-Google-Smtp-Source: AGHT+IFb0Ij3JAOsUyjNFzFS5ss/HuZjvc5vWhAsggz5dTMhe7SD0zTpYBX4PqyTUjGk2jMHuKx1WSKXkXFzSm0+
X-Received: from wmbbh10.prod.google.com ([2002:a05:600c:3d0a:b0:43e:9aac:5a49])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d28:b0:43d:ea:51d2 with SMTP id 5b1f17b1804b1-442fefee236mr24868925e9.14.1747402841965;
 Fri, 16 May 2025 06:40:41 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:10 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-5-vdonnefort@google.com>
Subject: [PATCH v5 04/25] tracing: Add reset to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

For standard trace instance, "trace" files allow to do non-consuming
read of the ring-buffers. This is however not applicable to ring-buffer
remotes due to the lack of support in the meta-page. Nonetheless this
file is still useful to reset a ring-buffer so let's add a write-only
version.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index de043a6f2fe0..1aa99da3c96a 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -11,6 +11,7 @@ struct trace_remote_callbacks {
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
 	int	(*enable_tracing)(bool enable, void *priv);
 	int	(*swap_reader_page)(unsigned int cpu, void *priv);
+	int	(*reset)(unsigned int cpu, void *priv);
 };
 
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 1a4786b7970c..18b2930186cc 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -63,6 +63,7 @@ static int trace_remote_load(struct trace_remote *remote)
 	rb_remote->desc = remote->trace_buffer_desc;
 	rb_remote->swap_reader_page = remote->cbs->swap_reader_page;
 	rb_remote->priv = remote->priv;
+	rb_remote->reset = remote->cbs->reset;
 	remote->trace_buffer = ring_buffer_remote(rb_remote);
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
@@ -370,6 +386,26 @@ static const struct file_operations trace_pipe_fops = {
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
@@ -400,7 +436,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
 			       &buffer_size_kb_fops) ||
 	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
-			       &trace_pipe_fops))
+			       &trace_pipe_fops) ||
+	    !trace_create_file("trace", 0200, remote_d, remote,
+			       &trace_fops))
 		goto err;
 
 	percpu_d = tracefs_create_dir("per_cpu", remote_d);
@@ -422,7 +460,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 		}
 
 		if (!trace_create_cpu_file("trace_pipe", TRACEFS_MODE_READ, cpu_d, remote, cpu,
-					   &trace_pipe_fops))
+					   &trace_pipe_fops) ||
+		    !trace_create_cpu_file("trace", 0200, cpu_d, remote, cpu,
+					   &trace_fops))
 			goto err;
 	}
 
-- 
2.49.0.1101.gccaa498523-goog

