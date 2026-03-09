Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92B3E9597
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073571; cv=none; b=n5Y6DOaoI6hdcp4vxD05YQA/RL2FouLnKkSs/WKR+9XCedSsVg81ijH2bDdxNhPgP/1qZ8S68HHbSRHN+OwrI52KEdg1z+gtg2u2lQ3ZrYjB4x3omtGEMoo9/nyjShGDu98TZ7teP7IALaPKxpm/REi0X3NWrzGg4Ep6YnhJKdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073571; c=relaxed/simple;
	bh=nCoqfYLkFALSGqFmK5+OUBL2T+SjXlSRskeq0sqM6lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BzpsUK5sLT3S4R3U4nIlUstndKDEPQwz1zi+O+t1RSr4pMkmnxNhLJt2HRRiASooir+RjBWP2YPSV2QPrdkIeVWDO/D6VeHTsV0uUYsD+hlQggbc+H9bzpXrarrP6hNB/mAHCJiPjkPOIpJ7lfcTMzPZBLsinFLYVjXR0UMaOf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tOBCxMdZ; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tOBCxMdZ"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b94062e85f9so482983066b.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073568; x=1773678368; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/el005jPydhTNUS1hr5dgVCq32s5flSC0Li9+BCYSpc=;
        b=tOBCxMdZAJu7zYt1bh6NdfzKwDc1P1b1Wqs1EFe4sZGHV1ZyHDHDFFfGT8S0vIZgef
         7rvP8JZ7CWhtRLjDJynY97pvAJ6Z/c1v7e1/a6nU6yVHdzez+9jiFOdkosCEATFXx8uV
         +4hX0beeOGAKNO9+/QO4dsgXd1Vtb8aPWnc4ILYXB75dhmO4sHVoveIUxt2T4DI3NK1l
         +082k/fzODvztYR85zJMHGvhCsU1+JdkindcRPKiwMXg3GOMgRKyGFlk5Vz6nStuhru8
         ajvz3pOzBczeZYNHj+jyLT92LYd+VitI5ccZSxrRUWiZI6qmpdvrxRDDLyjPq4/CmL+U
         Q3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073568; x=1773678368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/el005jPydhTNUS1hr5dgVCq32s5flSC0Li9+BCYSpc=;
        b=ZCwE2KqWgtNht3qBfbPOjoReF2PaGArFF+82U3JDEYnZBX/Sonl11I9GxMKxPZQFmu
         xQBrNHz2o0YFvmuIUFcGeTcxeTGGu+izIPsuEOVPAbFQG8ZSUsRp6o7y/3nDo+TC2eiF
         k1WOXEq8d0YGksWZNikfXDpXz+LO1BIeO4esB9eKsPfczSqjQdhDX4KNkhTHEXrZI9he
         Rq57MFQVKzDOPku6UGG7bpbx6Zi2WqNIM9GbmuTF7fo8a3FjeFnGc219/oNWPLMocp/+
         RG4gkduduSAgO4LyblKvZlm9YVooHCKlNljrRZbjm3RZfMFcL63JKkmyvDXbk4mM7iD2
         EubQ==
X-Gm-Message-State: AOJu0Yz0L69gDGoyP7j/WmH0fHIVrMTNeO8MD/3gDJYuuEc5zoFT+UOY
	gnH3/kkWcoP8m3QAPi3mpxf3y3avCtQvdEfS9Id0EgnzDoe/iL5NimVdbuo8EhTrzQZexPXyB8Z
	rIvoBGW2sxSKaBS2Fxgpp5w==
X-Received: from ejzd4.prod.google.com ([2002:a17:906:c204:b0:b93:57d1:f5fe])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c13:b0:b96:ef71:49f1 with SMTP id a640c23a62f3a-b96ef715938mr293231166b.15.1773073568096;
 Mon, 09 Mar 2026 09:26:08 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:24:54 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-9-vdonnefort@google.com>
Subject: [PATCH v14 08/30] tracing: Add init callback to trace remotes
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
index 039ba71c3b3e..294d051dcef1 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -863,6 +863,7 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
 {
 	struct trace_remote *remote;
+	int ret;
 
 	remote = kzalloc_obj(*remote);
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
2.53.0.473.g4a7958ca14-goog

