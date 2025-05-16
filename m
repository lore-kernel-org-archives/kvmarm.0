Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB0169397
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402847; cv=none; b=tynHYcUI3eUpTs4HgLYg79N6Z21biHcXhSCpCn3LoCwhwNy9yy78djH5k8ild57qCvLiz/MG5lm5/Gk7c1LTSRRjlYnKp8w4wv6qnvRsTs2ahVKmc3kr7XIyoX6eOEc2860qig++166h5e/eTt/m/75RPze+SvcMcEUwcbawrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402847; c=relaxed/simple;
	bh=iUMASGgC/AejzotR/KEheUz4s55s7PNH7xGym6+pco0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N28R9pyJB6uUmKzPSXObsgjzQJgKz6dCMGS67JFXQpY0r45C3PF+4Qb7xCyHWf+2b+N/MGEcVgK/IsF1rbs+iM3BEIhzdpHw8mlYtsLlQV+waU/77y7enAcy1XGjtT1uTOdz8/O43QqxEyIKsY6s30SChKsHI0iOKmGL/qIEzcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kfu0/zMM; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kfu0/zMM"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442fda1cba7so4195485e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402844; x=1748007644; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3t+9Hbrx3b4pdy+1CD6jYpc+HxoCZtIYl3kVPAq1eqM=;
        b=Kfu0/zMM3dFXollJAN6nSi7ZGCJEv1KipQE20DT13DkC4kWqn241B+uZjL2cm5DeTx
         n2WUfTsWFt5pV75UuG1S/RPRwVwOBoTLm/nfvmNF54f7s75T9910MRPDQHLLj2HMFlhj
         cvk+krH+egPa7GAD4dggozNjQZZthejAB/IWHb38xRKmo2wMyDg35SxnwUAO+6R9T6or
         7JQgh8PQV+Gs2gHA+ZdBZw6SEZfmvOeUMjsDqZ7iANGtE+HGyz858Dz7pQ2KXvj1lqil
         n449wfMibd0fG259L/Vun8Rghh10hdiWRZRXnFyDp6CTAI9SdQtGRJSbvJ9fE2zUdPkH
         001Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402844; x=1748007644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3t+9Hbrx3b4pdy+1CD6jYpc+HxoCZtIYl3kVPAq1eqM=;
        b=M3Te+oUUEAbzZ0FZrp+W7CUQY9fyKeih9ATYZJ2D8eIuxxYA90v2Qqpjs6lF0nZlFr
         kY4fwTtRykRwYf1yd9wEUfCBKqMFoqdIKpLfybbSKOnTEx3e4VJ715gBBoNbf/ux7MEM
         Pk6Mkc04SAAsCzbMGrkB2MV/rxAm5SkAuzNtYdvelrOb7Xcy9O9cu5Xt8h8EZFIJtvGH
         QmOTOuw2p8E88W2Nk590XO+inrXbbcJ3KQi7MGqwNkwFw3xYMpqWc9Q6sYI9Z6cXHhm6
         vi8FWLPrbQRRs1Of/K4P5fgTCUy/suP5HXKjQYvnpUha/oDFVlG6E6LT+wUo6Imdf+0u
         c4Ig==
X-Gm-Message-State: AOJu0YzrhY+6ADAdinB1I3cQuk2NtAtbLNzS5KYvbiEvZHgiCaPWeKc/
	oMRIYyCrUiGpufoHb+ofHiQ73vyA3tziqXeJ6ujUWGatLDwSu5iLnpPj7B0tQr2dDTM9YT46C5Z
	KWLUNVswwqcL+fben34YWzA==
X-Google-Smtp-Source: AGHT+IHBk0uTFQehW6fZF3OCY0h82+X4e1sass1zittKFrmN//RLeJcEgCwGWBGBCezpJMkuQurUbPrGR+5L4tEP
X-Received: from wmbei9.prod.google.com ([2002:a05:600c:3f09:b0:441:b607:4ec0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:64c5:b0:43c:ea1a:720a with SMTP id 5b1f17b1804b1-442fefdad81mr26193435e9.1.1747402843791;
 Fri, 16 May 2025 06:40:43 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:11 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-6-vdonnefort@google.com>
Subject: [PATCH v5 05/25] tracing: Add init callback to trace remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
2.49.0.1101.gccaa498523-goog

