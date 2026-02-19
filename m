Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E8E3431E7
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513410; cv=none; b=VM5GwbP+nUWz7XgOuyPv9nD4D2J2sYuA283JNO6QHR1c/jAvVYke1IVe7YSyTolcDIJMjW8IcnY0fu8sZ5wHl8664A2/VZQFj+ISHpMMigRaXqnflVydwIPaFMV/XIDt1KD5qITLaLVlAYjt8oOCVAUV41z6AeTImWMY6fIH9yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513410; c=relaxed/simple;
	bh=VoL8dKKWsuO5TLicfoNePNC5MtZdyCZna8S2hZwFS3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NIbyp7WYmVButgbFRZ+jPLXzVVJ6+tpcoLvsGPgOETQLULOqJqO1Yq/vlNKulw26HuOR4ChGqqgEUlL+dZc6ZLy2RAerMxPGbyLaEorNgm/OxThoiLgj99AAV9ZoJsPwYe4KF5HRT5iiIUIB8z986MDXICv3EPG9qsiuxrLYGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HsF1guvS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HsF1guvS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so12125585e9.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513407; x=1772118207; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jPS7WRrkBIoNMvCZPX+Css0sPZz9dHMI7aeVzVXuEDI=;
        b=HsF1guvSIR+MRk1N5pnoNsCG9WH9zI0oIwnInVgr5jb9wQveqPOq3HSwvPxIKonIZH
         2eJH+Wz3e001VRQYzjFJsMIYHBlGI7AhZidKq1Ntl/OAWE0mAQHJTGhYjlx1h5Gj11us
         rwPlR5udts9oHyR8oevvpBCxGeUtMJgvnENZVWG/3ImdpQDABEPxKIQsGp8OqZae5nCs
         pi4qdGqJKRH1/yNQWfIQLx6ojYKG5qbg3O30TpnejCm72t7qzZDfk/Df0LfLdKn0oywf
         /i9OtA/LXDdZntTzoDKLcZdfnRIMo7vCKYlSe7q7vK+Yn4IVfuqJFmQFSHLZ7fsqKJvS
         qhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513407; x=1772118207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jPS7WRrkBIoNMvCZPX+Css0sPZz9dHMI7aeVzVXuEDI=;
        b=PIO2THr3SDmn+wzsfx1k4GKv4y7CuXT9zXF/yOTTM2u6my0Tr4z92inBatkfARgEBW
         1f3KtZ9tef3De+N1FhbH6IC0gwpmSkX01CvDunVXEPy94xT+DIRlhJTZPouCyua8/cwm
         N7W5raZTSEtXSfYF95tYDins3VnPq2y7aRMbbKBWtGhSkK3kCsHfxoL3s45IMBXM7yKd
         8UyemPULv8IRVh15KaQpJerYAYPzEitGfFDGB0onhG4fcHWcH6bYwNzfD6GYbukVIODN
         7M0gBJicmyETLGNoImBo4s7l8ospiKzikakNhKH0NfYDkLrILxTmCKm/I5QTYlGjzLRU
         8S+w==
X-Gm-Message-State: AOJu0YzyJxNl9jABAuugv3yVRElbNLqEsmE6+jD2ajITQjSyG6BDNc5s
	rM62EILaMiIH4/PoUi61WpKeHgS0jJLQOPwqOaYCBtkaDGcENRF7+cPGzt5GNqWuEldAg+u5tST
	GG+rH/lu2PPQPtCtukDFIqA==
X-Received: from wmbdr17.prod.google.com ([2002:a05:600c:6091:b0:480:4a03:7b73])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154f:b0:483:3384:a873 with SMTP id 5b1f17b1804b1-48379c15d86mr301886815e9.36.1771513406508;
 Thu, 19 Feb 2026 07:03:26 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:45 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-9-vdonnefort@google.com>
Subject: [PATCH v12 08/30] tracing: Add init callback to trace remotes
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
index 10ca03dc192b..090c58b7d92b 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -3,10 +3,13 @@
 #ifndef _LINUX_TRACE_REMOTE_H
 #define _LINUX_TRACE_REMOTE_H
 
+#include <linux/dcache.h>
 #include <linux/ring_buffer.h>
 
 /**
  * struct trace_remote_callbacks - Callbacks used by Tracefs to control the remote
+ * @init:		Called once the remote has been registered. Allows the
+ *			caller to extend the Tracefs remote directory
  * @load_trace_buffer:  Called before Tracefs accesses the trace buffer for the first
  *			time. Must return a &trace_buffer_desc
  *			(most likely filled with trace_remote_alloc_buffer())
@@ -22,6 +25,7 @@
  *			new reader-page from the @cpu ring-buffer.
  */
 struct trace_remote_callbacks {
+	int	(*init)(struct dentry *d, void *priv);
 	struct trace_buffer_desc *(*load_trace_buffer)(unsigned long size, void *priv);
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
 	int	(*enable_tracing)(bool enable, void *priv);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 5147ebe3f0bb..4e2f9259c814 100644
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
2.53.0.335.g19a08e0c02-goog

