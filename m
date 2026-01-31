Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC45354AE0
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866173; cv=none; b=msBhSIA2LLZTexuoK/dQ3thuJk/0MTxDX5dJmADNg1XHuM1ike3MFkScb+y/ICHgLlTLmZm9RVY9U4894nKWLkqlBvmJlzUYJfcDlSc/sgcVvQEZToA2B2r6OdMql9RYy+HMvaouQ1EvL+1jw1ZS6/3RRf+lmICtWUmOFLqOgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866173; c=relaxed/simple;
	bh=wMqFpMWKBFJX4WNiZXUaDZF9TfQWdfJVHz79lqJGwb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DbASxoseUOSI3D55gXwfG77s37C/+8xw4ScGp8NXoAotcCfT2I5amBLBeyWxj0xdpWQk4TPihR3oiKXYkSBjrZuPpPsieDLYwZU+ELuRE2QaPCm7AS9MUkNY+DFTHI9IiVxogm2B9NUwdd8MKF5tNtd0DL6Z0cCPLO7g8x2jJjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0JxKWy2F; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0JxKWy2F"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6582e841d15so2932065a12.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866169; x=1770470969; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EnUsHuSY31rm33Evz3AO9vawTajgwNWCLhwQDTSMr4=;
        b=0JxKWy2Fx0x60iktquSRf9Oz8ekpUo95sWG7GRTHyGKfkqhPRiuJG38Cm8mFc0KdTR
         +5691C94jVbCekQkfxxESkTlGbkslLG47LgGkOT/F+C7ukGLu19hpep+Tgn89Q3Eitg4
         Az3OygQy8jvYw9X8jgs/gY49oImvaWKzBQNN5tvE2afdl6j0UxpItRiobE+YMJ1Vr4dg
         Q+tnM4wa9ZhFxwEfaLJ9N6XYAsnvl6jy7blW8aUi4kMJ5eWOv8IcH+00w1xIOLovqLwP
         DHRLsktbIkDZRcl01NxaxMl+BRaXFYhA2JevMFKcynusZrICyJqyV0czvnRBRF/fTyKz
         DaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866169; x=1770470969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EnUsHuSY31rm33Evz3AO9vawTajgwNWCLhwQDTSMr4=;
        b=QjRKVZPV5aDhC9+Ee8H/IAY8d72HGPfLWOe7MkSbufPPq6/8XKON+gX8jmedMJRIcL
         PFh3jg039WHpSwLSUqDlyaWNbEUVBjEsrryddjYyiEUTHinQRh1qrXIeSn6TSDb5U+ud
         wupwx0bMfmpyWXeQrRBjL/JUqneSXcxuq4RSxcgeGWAQL9G0iicwZtqKFVUYy9JrA2AV
         ba/ZFXMehs3xrzc8mikwXEE1YseUSMKz9ReitS8bcJjUzoDRZzkmZO1PU6Q4L1mlC3ea
         37u9pEncD4SCXZUGtIZsZmxIDrGUE1tDflxX/6yJ9uGreuS0qCaGf0+exKavTGRk3ntL
         WRrQ==
X-Gm-Message-State: AOJu0YzO3Fnb98X9Wv+cLOA7d9IORQ/2q29kItfhzNjwtC3ndf6eNNWk
	yHPSTYhxHgoY5bJGT+xK2WjG5XQJozBiPhC5sOaawv0HOOrBpXHX3YdIh4JypSZ9IYL2zV5lPza
	ueINI8cJFP6Nz1DdNo6wfzQ==
X-Received: from edxz19.prod.google.com ([2002:aa7:cf93:0:b0:647:6be6:f4ec])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3587:b0:658:d405:9797 with SMTP id 4fb4d7f45d1cf-658de58b4f5mr3837419a12.16.1769866168670;
 Sat, 31 Jan 2026 05:29:28 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:26 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-9-vdonnefort@google.com>
Subject: [PATCH v11 08/30] tracing: Add init callback to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a .init call back so the trace remote callers can add entries to the
tracefs directory.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index 7fb5271a8c30..c4df3d98e5dc 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -3,11 +3,14 @@
 #ifndef _LINUX_TRACE_REMOTE_H
 #define _LINUX_TRACE_REMOTE_H
 
+#include <linux/dcache.h>
 #include <linux/ring_buffer.h>
 
 /**
  * struct trace_remote_callbacks - Callbacks used by Tracefs to control the remote
  *
+ * @init:		Called once the remote has been registered. Allows the
+ *			caller to extend the Tracefs remote directory
  * @load_trace_buffer:  Called before Tracefs accesses the trace buffer for the first
  *			time. Must return a &trace_buffer_desc
  *			(most likely filled with trace_remote_alloc_buffer())
@@ -23,6 +26,7 @@
  *			new reader-page from the @cpu ring-buffer.
  */
 struct trace_remote_callbacks {
+	int	(*init)(struct dentry *d, void *priv);
 	struct trace_buffer_desc *(*load_trace_buffer)(unsigned long size, void *priv);
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
 	int	(*enable_tracing)(bool enable, void *priv);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index e03fde73aac7..8a7662ff775f 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -863,6 +863,7 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
 {
 	struct trace_remote *remote;
+	int ret;
 
 	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
 	if (!remote)
@@ -880,7 +881,11 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
 		return -ENOMEM;
 	}
 
-	return 0;
+	ret = cbs->init ? cbs->init(remote->dentry, priv) : 0;
+	if (ret)
+		pr_err("Init failed for trace remote '%s' (%d)\n", name, ret);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_remote_register);
 
-- 
2.53.0.rc1.225.gd81095ad13-goog

