Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DD0332EDA
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424278; cv=none; b=I3kIlHeowR3QNCXiyQE8nCur9nXyEJAcL1Nkk+9v5dDoSU9DkI6E8Tn9+rcu+EsgTVjdxtbmCwVCTfc0USQU289Yt1+8+n3cxzY6WrcusQ+0dphoLh8BirCKXUFQisa/5LRvV3NPSR1OgpP3B2YPchKb8p/J8ztIRGtI99kaR78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424278; c=relaxed/simple;
	bh=iaQ0yA4R1YMjqmjGhIBLQinGbFMCowT55FHzF+/yiYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1RwJl9hruuj7nX/kBE0l/LHA0DiluM6yks7TeWb77AR3eqWiB7JXdiFKqa4DYCrLLtQCFy+tnh9K4Ypg1J+2K9WPQ1DLpgiBRGSCO0kbviedEovZhbFK322r+8io+yzznBMQPX9lz5OAiIo+sHdy2jUTzEz0Buh2zden5JRg6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GcPJsFJl; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GcPJsFJl"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-480600391e2so7882745e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424274; x=1770029074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L2udmx+4SJHsFMJWVRdW8n/HMzlAkQIzlTSPPm28eNE=;
        b=GcPJsFJlcG7jlUCZ9K+nMns8idHfoZDzMD+fLgcXyi0oL8UUJAQB0M8l7/+6qncXy1
         Q1dwtRYUwbHCY5X5lBzKHylX2TBWIvKeAa8jqgZXFoB4fa6bHRewWXtM2YZawUUfI2b8
         oy5Ii8sNvUWyyemBMCkYsWWZnFxh1R9NHip6nJjhLUg8D1OLuHJQmlZto9oIOMOtVfsH
         wV87CtIytuc6aEbRvUEOOY6vM7+puI/JTIwHkiZ0yx+QO+Yc2bmRIwl55VO+MwzigsPF
         eOOv9BWaqt7ZvefjgiojIWtjE0Zr7NtozBaiENxkp0l6Y70LG0aweGQH0bHs3hFeFRaB
         1PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424274; x=1770029074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2udmx+4SJHsFMJWVRdW8n/HMzlAkQIzlTSPPm28eNE=;
        b=ZJaHs9YQTbdee9UsUvkenb4Dyr8klGBYNbVQ1VWSDg/jjALtCCma1MDYC7myr2ip0h
         0VKIkzJ0bPvmHgFPsMiXNQ4LrscQFtfZ9C28Wg1Uvx9OzgZlSAHe4Aon3CQsySRyv12a
         Jil0kmZy1jRUzFK1ofkQ1atvhzMdHoIo9XNBnRcgY+Mz1TJaj+mM8sBGrp9mqGWV2k5E
         BIjdE1QVljy+hRZ38IqJJOO1v7akvSLqOAlloR/AqlQ91IxVAApYkUrCMLFL6N1UrITX
         GLXRBHRCaU6cG/he8kgLKIsFyvt/TJIje81i/MGmaEz/zsaBKl7A9SGB7RuUNQS1ODPz
         ku1A==
X-Gm-Message-State: AOJu0YxafPdf2c9JoZ9YhM+3IJCWHt4b/M5v1ed2QvuzZsE5tJWs7a3E
	2cm+vPJvNlkWrv8g7GaoURQunxidCJPCjGL6SZpBojBaOC0/xYxUzPyRZ98xo2jbNCNxrO3Ui3d
	D2MVp82LQAHTqk5PHr4/02Q==
X-Received: from wmpk39.prod.google.com ([2002:a05:600c:827:b0:480:4a03:7b7b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:500d:b0:477:7f4a:44b0 with SMTP id 5b1f17b1804b1-4805d06c44emr66099755e9.33.1769424273803;
 Mon, 26 Jan 2026 02:44:33 -0800 (PST)
Date: Mon, 26 Jan 2026 10:43:57 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-9-vdonnefort@google.com>
Subject: [PATCH v10 08/30] tracing: Add init callback to trace remotes
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
2.52.0.457.g6b5491de43-goog

