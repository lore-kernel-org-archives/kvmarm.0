Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85599272E43
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764071; cv=none; b=CwDcJAfg9ljZQvhH1x0gsX7GuNWOxGbNm6Ice77n0D+VXBo6+9jBRb6Ztec/WpdW2qnR+Zb2AERGEqSSTYRor6sY4YtnMhw86NmyBvbTGCFRfyCYeIeJzrOlyjwVkxRnGEi++RkO8GwVv1DO5PWe+tAUGpl9ZkPUSN861eBzPms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764071; c=relaxed/simple;
	bh=MJnXwlr6sqtBLAgWRkDhxOXeIwiyUFY3sKB4i+iHGHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LIH0WYKDy9uLmksUFFRwxdmYjmXjXoRM2WjHILsyvsDAZzaaDYdtw8lhBEXgkgPf+YfWLvemG1fLh4h1hTTEHbmBn4YD/cKOvNcCUdjIUBvkhCeM8W7E9rVJh4/8nca0z6WX23/32ijoj4EtvI+C5jn3bErVaRvI+z/Xr3gUMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KaZfSrnX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KaZfSrnX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9e4117542so367748f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764068; x=1756368868; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UeiQbqfd+7HFGphDDhTnjWkKTWOQraz9qW3YNATpZfI=;
        b=KaZfSrnXr3by1GiGu9ElzEru8c3gTBzaZhZJWBhAzUn9LOSWL1jrw184YkdjZn8uq2
         tHpfwLYRkVpztV20QUS7sYAwUtU8v8ETyhTvay4yhVuwpW3pN9GlxAjIpnK1+ywG907F
         RMqz3p/zriQBKzqrqce3INcEYCmAz6ELl5tJqIIkGoZvTdxzxqclf59OZ520eM5oyxZd
         bEg9FaB2iElKR5X5526JqsKXH1iSM4rsDyOEdAP9++lgSo3r3tJAOj+DIMNHLLGV6frZ
         s3ZG2Pr7tdRj49QdiTNvBw2iiERr3cRkJXMmsiI1bbYubq2Y05e3HpTFwizy3fS3oaug
         +2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764068; x=1756368868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UeiQbqfd+7HFGphDDhTnjWkKTWOQraz9qW3YNATpZfI=;
        b=EfYDBmzv3I5j01MHjmPZMizp5dbRybuRyh+gjTnqRA29qYZi8On5gkyetd0e/Abinm
         oDU4cdNCt3wLWDVQqQgAqNyrbPmPClc++VDSTXB9RO7M6mvPNr1FkqggRqNdmCkWCGi2
         mGu6Xb9WMxiIhOTJ9BXbyUBrkPedqHUVaNcSwun8iKRM0eK0KSJN56A92hy+hmHVRDz3
         44ubn7fVQq5EkkBnVPSFgl+rDRt9XZ+SmKsU4IF+MZ/0eX+yvfCks5316Shf+H+Dj8jJ
         3qdl7HaFokGUxspf/WqYM2FqsWieYrvYv702WPS6yAnkqMNEnskkm6iDQwXSo69vMYnu
         CVNQ==
X-Gm-Message-State: AOJu0YztUk9/yLggD6IzoRakQ3TtW22CyRWIAR+OEn7Rm64q+eci/uzP
	iC8TW4QCOjnycPpv1z7jJb4LG9YCH5x9AWQMMYEg8M6PNtPNCzVcN9Zn1HV7NxSbHi2AVNJy2eI
	7SgGBNK+sVPeqoPXWf82HMQ==
X-Google-Smtp-Source: AGHT+IGPZ/UWfrK0SR54G2w2/hGND79Jxl9Aw93toJ+uqNkdy6qzcC80bA5lVYDqpW5CNdXw1Cx3m0UW7vJbU9iY
X-Received: from wmqc21.prod.google.com ([2002:a05:600c:a55:b0:459:dbaa:93aa])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f86:b0:3b5:e714:9c1e with SMTP id ffacd0b85a97d-3c494fc5dbemr1259176f8f.12.1755764067796;
 Thu, 21 Aug 2025 01:14:27 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:13:53 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-6-vdonnefort@google.com>
Subject: [PATCH v6 05/24] tracing: Add init callback to trace remotes
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
index 1aa99da3c96a..82d26d97a536 100644
--- a/include/linux/trace_remote.h
+++ b/include/linux/trace_remote.h
@@ -3,9 +3,11 @@
 #ifndef _LINUX_TRACE_REMOTE_H
 #define _LINUX_TRACE_REMOTE_H
 
+#include <linux/dcache.h>
 #include <linux/ring_buffer.h>
 
 struct trace_remote_callbacks {
+	int	(*init)(struct dentry *d, void *priv);
 	struct trace_buffer_desc *
 		(*load_trace_buffer)(unsigned long size, void *priv);
 	void	(*unload_trace_buffer)(struct trace_buffer_desc *desc, void *priv);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 18b2930186cc..8f8eb1f1e889 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -482,6 +482,7 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
 {
 	struct trace_remote *remote;
+	int ret;
 
 	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
 	if (!remote)
@@ -498,7 +499,11 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
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
2.51.0.rc2.233.g662b1ed5c5-goog

