Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740421638D
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498749; cv=none; b=ksw29+lHd7zHPhcQ27QyDHW+AqTMSbczuIfYwBgmZonqQ94bB8V9B4puiScijwLRJ35QbMQMfLwAYDSXkQgR9Xq9mBCn7BuOo4XqsHejoHgM2X6SmdoM59U3ZPDo/H+BNxO1f8VCNxxCcpwwOOQq7gjEYp6VB02N8VouzI11dGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498749; c=relaxed/simple;
	bh=LuttUe5CO5VAn3hELI/7s6eCl7Ml9SPGqKByWNdQ0S8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yb1Q2schHx7XOFYkBJBC5Rr5X6jTeKQ6Odr8vusCMASs7gQ6hVzK4Ht/jJJbtYfQAglc8AnC7LxAaPOudzVdRC/T/hp/7PI6FjtixFTYX8imFc/s7Xd6oP6Ej0nUJNJrmctwQGX43j8BtBEe7l0I0c/CFmRDm6ZZebrCxd2nYrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Crcuhvi0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Crcuhvi0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e46486972so8021645e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498745; x=1760103545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fs/M7Fqoy0zdu3rq0sxtnZW6IS3TOjHhsegHTeIPLQM=;
        b=Crcuhvi0OJSQlhCZARNLnMG0d7swSPgRzkL/lWqr/MjnpM9IFS1r3U+0lyYY7l03+u
         dThVYu70A4U3YUffw1iN/ru7kC/VIuF0XUhHDnAO9nOGQztr6i6nzH8dfOIDpMUl9F04
         zHDfWgzbt8W4HrY4aMQS7oJ9/9ve7UAmeyZBgFirHJ/OJtLfvUDLgz5vnHT0FpuxtIFy
         5H2gEWujSavyKfiw0tJ2Q6sNLGt0T9Ha63dM8S6QzNPM83E2u4Ig2D09X4mpAZNe6mDa
         /Hlxgx8rWjK8U2z84DDD9Lswg73WwomoUwRo3T28+IMhWkuPKgiIhQPc1/ELMVf9YP9w
         aXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498745; x=1760103545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fs/M7Fqoy0zdu3rq0sxtnZW6IS3TOjHhsegHTeIPLQM=;
        b=vwlpZYpPKupsAydlEMH3WvMvO58cD+5s/3gro71+6PJ5DTIpacIb6lxfUCd3DNwYpw
         Pl5+EBJ+xt+EyLQkfSjXwcyAZZIDcwhY/71eiiP499ZXgQkmR4j1HMYEbjPSkp0fBDKw
         ABNdSFRppdALO7+iisuVgMu4ikI9X2tktEbr+1o5lIvPoyKoW9IxGnTEWPHf/blbiuq8
         pZ0/+3gZR2HXmD/6ykxg3wW8P5YsAoaK1w9eP54M1Se6JMihps90fSsU/PhOqs7wNbpy
         /l/XgpCAUyoTx04VMTedF0WaxUo7T7Mx+TDOrWrVuP7syWs+7BJvaUBUuOe8hoPD9PfI
         4O6w==
X-Gm-Message-State: AOJu0YyFGvYOtAc/2Dsz2OIFm6mZ7a7N4kRbDTH/hqWZYmNnfkZzX33p
	6ULmymAdz1VXT7mVOShE66F5F8+wqLD6X69i2djLxIGA3pC7COkJpVrFSj5EUtXFIS2MRBrMqtD
	kGx9I44pTgy49lXFZQONqcA==
X-Google-Smtp-Source: AGHT+IGhMHN0dJUUicPDV7IwYD5dxjTKJb2FY9Dk+V7sxgd83geumTaXQTdlEwmEdvOKbgxCexNOxhanuhI6Kor0
X-Received: from wmbz10.prod.google.com ([2002:a05:600c:c08a:b0:46e:38cf:fbd6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34ce:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-46e711408b5mr20342175e9.18.1759498745183;
 Fri, 03 Oct 2025 06:39:05 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:05 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-9-vdonnefort@google.com>
Subject: [PATCH v7 08/28] tracing: Add init callback to trace remotes
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
index c011df20df95..55ba3fd9e002 100644
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
 
 void trace_remote_free_buffer(struct trace_buffer_desc *desc)
-- 
2.51.0.618.g983fd99d29-goog

