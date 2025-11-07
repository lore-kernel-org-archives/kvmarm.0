Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950B304BD3
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508339; cv=none; b=oTuJ545tUscEnvazUIGMLc/topuCXaI2LIV3dKGRpsp2a3e/xn0ldV+/4YJ19aGWJWVw2kbzr5cEKcCmH3/XWo62EJfOs0s/y00XiqQgPh9lCnrqXhHSQyn8zMpSpGJ+LT3WffUy7yPmiodHpRl5QGwRxl6U1dsNJnjP5QYi9O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508339; c=relaxed/simple;
	bh=pJYarinG64QGYNoerysou4U26mZrLZEoLM99oNZSxKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D/LxBy/UkAjOWOAamrlbJqtfZoMwkAqkqbXlLJpQ8wxdBJAs/6HR7V79hCMttjvayRgNS9S7VKdwOMJTWAw/b8lwYldYqe/3K8x84SM2hXRcnd76ej5+4qB8pu6THtWgGRfA9mKzbm9KqLCBz6vbE6VgSsY7eYyuqvZRtsHYzXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fuGpJn9m; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fuGpJn9m"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so6031555e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508336; x=1763113136; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=suZEunh3pTtEBOLilYte+fuuSjgEk7HCDOkHWJLiaf8=;
        b=fuGpJn9mCeOpKDGXHzRpFNIVncDAKEzJwUNU9JgBqZU+OaWoVSoapDs7ELNR+FA2Xh
         6DF1W8WlzCKso78NByygMYc4M+Qn/syFkiiNoGH9jTHyObTfa7SETRf4Dk1zQa49izy5
         BX90fEZMf4+IqC2cF00BCmByIE+63EZwVujNurFMHcAmVtMzEMC+xMyDef1SureymF6c
         CEESl5AzEiczvVqbF1OWykY/U51OpNdybXjZYVJkAwh2+mEgzS77w8D7bHjqSBq/tQUz
         g/eU8rX1/ncx9v4ES9eM8PMgssFa/1wc24xFZF7ruoGT+RT9zFjZ+aEyunrNmACUUDck
         q6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508336; x=1763113136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=suZEunh3pTtEBOLilYte+fuuSjgEk7HCDOkHWJLiaf8=;
        b=ZLjGQb4N7boq6ot375A/0qoeJLfJxZH2sNw17nK5eGKgMIjZQzLMzUCf/QKywztNnJ
         xinTUMED6NRk5jXK2jXjaSYWzV3wKYVoEa6q2RmNV8epySqmGNUhJrj/IEFUk8iYGrbU
         5O1XHTCCD3SdZLE0jPFfblFkhR+CBnLPbFRxdHiHdVKGscXLxmp9u/+PWRkeJef/r4J7
         blc5uNfQBOLpXpABj5/RXpgai5tQGFhvKY5yJ+KHVfE/gjtuUN0cNXYdgxqIN/pacaeD
         GoEVOIGREGpZhZkHqS6H0FcxtuLJcxh69muUdrcPLOxFw+JAGpMVOOnkTcpeL1I3YKgp
         6ZMg==
X-Gm-Message-State: AOJu0YzXQH3k6Dzyw25zISPxwXVyFh3MLDvE40xRhlKRIKEVQeMkOcwM
	448qT8GPwOp0tNQG0nPN4bh0V+coqIEMTXa1S/lzSLOt3SC7Nsb6TdRDItoHXovNqwCnsQKOGES
	+IJtAeSXb4rQUuNEH3PI0Qw==
X-Google-Smtp-Source: AGHT+IFHffzR9bK7OBL/WwnulG3E8M/4OTfY/jrO+spwvfaNmVGfgI9sjXyGDvIOLNbKB7bUdo0nTOhEXUw06yoY
X-Received: from wmtf12.prod.google.com ([2002:a05:600c:8b4c:b0:475:c1fc:f10a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b38:b0:475:da13:256b with SMTP id 5b1f17b1804b1-4776bcca1ddmr18536495e9.38.1762508335761;
 Fri, 07 Nov 2025 01:38:55 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:20 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-9-vdonnefort@google.com>
Subject: [PATCH v8 08/28] tracing: Add init callback to trace remotes
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

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote.h b/include/linux/trace_remote.h
index 55754ef78104..15a579633123 100644
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
index a744bbf48e88..924e3f3ec6d2 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -837,6 +837,7 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
 {
 	struct trace_remote *remote;
+	int ret;
 
 	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
 	if (!remote)
@@ -854,7 +855,11 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
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
2.51.2.1041.gc1ab5b90ca-goog

