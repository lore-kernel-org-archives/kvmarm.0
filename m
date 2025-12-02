Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3130F819
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668204; cv=none; b=KKh8kYO4al5MKc8JTcmLNSOGAtFjM+EAFXh/kd8zVs5RSeZbil6t3zdj/cMeP2hvlF+cgpZL+cwaJvaut2TdX4pU9h/GQ6UF8dnSIY/jgB3PUSZo5QaMjvlKtjwg9nt8qt1ATNWLAaRJ+SU9zkVZyG4/3olELEuaAhdq4G7L984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668204; c=relaxed/simple;
	bh=6jZsAkpWSXcdA16GVH9yGV6F9gS3swQXbA0rH3VNSe0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AiAwOqVOzp7hrZPjdFrJbQofNv1aQeDbP3YxjupdD+v6Ml99cCelm44won18Hw2mLQg7OoGIgydMxQSc2SZi+QjxhKa4mnba1bLUNPtCu64TUbSY8dgMnmVgD+IFjRwzlYBvHDRTbvtqZXptsHp/kPWk/IFPasVyOaIwufiwMRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FGzsz5Ea; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FGzsz5Ea"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42e2e2389aeso1153375f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668199; x=1765272999; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C6hDRr7zZJlL6+0BwYS6BtC3S7766siHfVTQT4bpz1c=;
        b=FGzsz5Eaep9wGyhJkx38K+Hqc8EInRa9qNjKABtvmbzddHt071kfwY/hp77e6G7Z8L
         FjWSN4LSzygU0MKIWgaTdwjkvXFVM8cmtm7nfVmU7V7Nd/Yaaz2pcaJ/ndfqnDGT++Ud
         yeyRKq8Y8GJYTdw4tDYD+hxf9Gni5pOWoNLdLXUn67+d3e/iBtDIvMbiyuUFIAjYEOKf
         3MRfjt58uSvsQq+sybxFpYtNpH72ru9GQqa2o/I7bIrXvzy1++VWU/OymUZRtW3r78SM
         HtRkElDrAcHxrxLNbsdX4+B8gfXrFlXESyjM6XqZK2sSzVzy/sGfUaUgxoWR5E7kIEjX
         bK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668199; x=1765272999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6hDRr7zZJlL6+0BwYS6BtC3S7766siHfVTQT4bpz1c=;
        b=Hjngu0g5Tglvt6sLt/fK+oPQbhbs0NTHpBa1C0cUTdQ/5L2ZX8jHRpczN3WZWOP1ss
         wYlFdmQfkcKIbk16T/geFp3PYBGywgCoPMpaWDagE+ir+4MpDnfg66diKppbl1SB1+PC
         XOMAgTY6f9XHWhRsdHIrIni7ccVwdQzp/ksWvENBUe4dBUkoxvwQZShNssUxvNaUVYK+
         gYTyguPvGV+Gg0L7wC/Qu/o8uv8Mk8B9lg+WzFvWPh9YvUfEdJGVhE1n8tx7tBm1MNmq
         uTwEwUjP0mczwV9Q0TPzB64DxZDoIg9Gd+CqW+yoS/2H9Rql0pKs8pLMxatW7etBfkvW
         IzZA==
X-Gm-Message-State: AOJu0YwrSH1iZMlFVQYCcg58rHqtnWE/Ae4f5xJwIXbmIqdYF+BPdENf
	+c4alyG8BMW8u7XphjvKqr8u7X35pfhSQs0fJtGdpILpVbkb7SvI3a4FhqWBe6fPgWie0SgwC2r
	f6/5J4DVWY7t+G9DvWOpgPA==
X-Google-Smtp-Source: AGHT+IHwrvFhNppyviCL1Q1Q07XxwsMfPqHOqtUBea8U605YaGsdf4CkpCYK7lF/ypH0eslN4jrChDse/98GJevE
X-Received: from wrqf1.prod.google.com ([2002:adf:f8c1:0:b0:42c:c2d6:2a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5c89:0:b0:42b:3ee9:4775 with SMTP id ffacd0b85a97d-42cc1abe271mr45304466f8f.11.1764668198810;
 Tue, 02 Dec 2025 01:36:38 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:01 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-9-vdonnefort@google.com>
Subject: [PATCH v9 08/30] tracing: Add init callback to trace remotes
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
2.52.0.107.ga0afd4fd5b-goog

