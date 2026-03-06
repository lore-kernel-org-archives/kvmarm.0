Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83B13B7B70
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807763; cv=none; b=hwgKYJWLNQ7tcfLbv0nhHws6nOso9jcVJz8k/DFNK25vCeFsjkLFMH1DG5x5fAabKUTDw+AAYeXrfwFnevdseMb8Tmp+meQsMYIxehJTCRMp+tD3hmNdLVhir5V5qLZL4miRmhmfzk6haQA9xkJ7ujTaULXQYplPEb/se8/SVuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807763; c=relaxed/simple;
	bh=nCoqfYLkFALSGqFmK5+OUBL2T+SjXlSRskeq0sqM6lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CijCnzu8cVdAA5Xd7XhAOz+5JAf2oltPswLXNkml0Yoz7/frwDD8jXxQFSoKIIx96+qu+5KRGgO/W/OOQc52r9v4dbS0JUvti1Bt558Fgsp/36mEnuNCJq0dB/xjbJjyZ1hz/wkZBn8jk+TsgvSaKbZiNT1AwkVVD+SrTYsK8JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kjgo6BiS; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjgo6BiS"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439ae2cba40so4760903f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807760; x=1773412560; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/el005jPydhTNUS1hr5dgVCq32s5flSC0Li9+BCYSpc=;
        b=kjgo6BiSntqVI9s+BX/5Vy6dq0nw1VAjubMV4AA9dGpmHKFcO8zQnz1QuM1GUrE0TW
         P70CVthiesgyEAYb88RMJQ41VFV4dqy0be2f7OsXtnIxjOS3YMTFvX1i5W1twvRT/qBF
         JrvPpbWBlq0WNXT28onPWw4q6mGx5tK/tttJ+MyiV60QY6DTyRL/VJvsSpSJFMZ8KQpG
         4gEmrx2oTTgVKGZRUxpV4Usvrbgw3hqybX6/vraS7KpjYf+5Q/SiC+SOQncb6t6JIjH5
         vxRrKJAFNSYi34dKrnVGAwjeAiHfR0aKfILHb0T0he8lkpX/FB2JjNut7/dINJi05e4y
         2FeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807760; x=1773412560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/el005jPydhTNUS1hr5dgVCq32s5flSC0Li9+BCYSpc=;
        b=CZyXb+DW/qky4q9OfKtYZuwyn7THKELpievNx/er9uAVBILO4bWHiCf753B7hupZLq
         F5TOZWlzkL9UVJ6GgaFUikYWr6asF+rGQJd/jHhpmgMTKVqd2EJQMzSc8kQTBfDpGbYu
         q7Zvle1JjFaHWeYYN9dFBzgrYxhW7Mrk5p7HknXIzw7oi6Hfid7olYGKTHyMf764oEK7
         DdhwxGVyeqz9KGnCj+KVU3XKZZtCEe04LzE3nQXj0dYQcWhpHNe3wEjGIiGWPYs04YL7
         3JpOXmYvfVxiEUNtUjDVG034db/ZGZCbd4sohKGWM/ytBob+VyHz50HfoZdiQa+1j5/c
         TCig==
X-Gm-Message-State: AOJu0Yz2tFv4WnGG0vB6knHlDho5ZX2m+ED90lixW3BXGCCuDNCKiAMA
	m6TRg1s9dvwiRyM0Txe03ppMpiq3vPMGxMO3kb5dY5QQ1ndR2qbtTMuVqs7YN9RfcfKSPn/U1zu
	9TVtUg6K4MFglLgkUdGWQ/A==
X-Received: from wrph18.prod.google.com ([2002:adf:f4d2:0:b0:439:cb0d:43ff])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40dc:b0:439:c9d0:5fc2 with SMTP id ffacd0b85a97d-439da891b2cmr4112557f8f.39.1772807759879;
 Fri, 06 Mar 2026 06:35:59 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:12 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-9-vdonnefort@google.com>
Subject: [PATCH v13 08/32] tracing: Add init callback to trace remotes
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

