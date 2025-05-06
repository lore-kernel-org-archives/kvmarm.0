Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3604288CA8
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550128; cv=none; b=CFRsrBCyTbCd31DCfA6nLNYiMjQMzhNWbEnESzxDP2YRZQkfsNBcr6Ezad996WROxf8scOnhfh5LS1lpfYTLd5N+agbflKAimluvR/3C97j3LZkGvg3ZEGWie67YTzjn/7IEkAYOpnBFl7TR25XVSMtJiKxsnOUpP+AggccV5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550128; c=relaxed/simple;
	bh=l3cyRuYF81wunoJ7TifMvH83r4i55FQixMLbcy3lwME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ono2+NjSnqKyHdlLaC/EEg7RTlE/1vkCMe3dvHkNcR+PlVCWt1TKTxlFI3zGtmjBENrK9D5hX/mp6egH2rjIYCRBuBHa3gvvOYHxewPdZ/lhynF8H6898rMkaJ/gSppTDjkNuK8QY7UOrY8os7UtWihuQuCZZpsD9VhbylftX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yDcTddbN; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yDcTddbN"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3912d5f6689so2843178f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550125; x=1747154925; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ulR0t05oQC1aYq/PHkhH5FZiwJoFyTXIHcnk/CuN1Ys=;
        b=yDcTddbNmimDrTD3XNxhThHYLIx9JvRYrSN1rXRUQpX7hUpXsISVPPIFAoWfd/2E09
         UMtX4wE5cDZsEKg9Hwao0LI4nD7kZ96c1+Y63LKSqDFUaCURtzmfzG3XFVBzj2gd3aXC
         iVDMB6NrCgLsfBOMCjTJP+DwApubDTcQsNh0O7pzQ3wT064gH38IIpzp90j+Gno+ln8k
         p2zN868aImEqp4yEXc3bchb/TvR/JtwrdP62u5ftlIZnMpAgF2E9fCJ2akMR4up3gyMj
         K50Mel258tprEriTGkwmQJc3nhsrtUNXf3Vj+j60rU7GJbbSjp5YiH3QRNbuI4oz/Dwd
         I8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550125; x=1747154925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ulR0t05oQC1aYq/PHkhH5FZiwJoFyTXIHcnk/CuN1Ys=;
        b=AYvx/LMStmnsmcGrRxUItpLoDP4bA4JDRUrxMsUavG0WTcCi54oShnY0qPaN4N3oHa
         SIXaJqPQqvQ6X+KinfPPUKpz14gkUWXMm+UvMoBUFWrxPtllTV/hSD11JulEpyIuszpj
         NLnhEZSpC4Iz4icmmvqHW+Md8tBw3V7nSAnHUKi+j0y0h2KRcXwIVgwelD3j/FgIdC5f
         6hSDLerJmxABdB+BXcxakL5Ta+MsVc+GTjOH1VodZIXUjtW7vN8ZGY5Wp8/pxJhCiiVU
         egQXyi09G30nPDVDb0JASY5V6HK7w954+uosf8ghhlm7DjbP/ggJVBBMMIz0WL1DS+Iw
         RvYw==
X-Gm-Message-State: AOJu0YwRcts+WV3nLU4njr5I2rr/Ha3cWk6wya9yll7Th4/xI3Yape6K
	EosPYjau1/1YDFXlmNMB5JPCODo1el+MwF5B/lAUC3Au+btVd5DCp+lF7/ffqfBCfC7TkwhaOHP
	3xVImuyLU8hvbtBkyIQ==
X-Google-Smtp-Source: AGHT+IG1v09/s12usa8mhNe5u/61861N0/kCY4NkyY380pXa7lF6ETtkjTMmugXHCVnG7wZDISxXe9P8kKhSjb56
X-Received: from wrbbs23.prod.google.com ([2002:a05:6000:717:b0:3a0:90bc:bf72])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:47c7:0:b0:3a0:8352:775a with SMTP id ffacd0b85a97d-3a0b49b5e48mr195832f8f.34.1746550125284;
 Tue, 06 May 2025 09:48:45 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:00 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-5-vdonnefort@google.com>
Subject: [PATCH v4 04/24] tracing: Add init callback to trace remotes
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
index 2221705f65f4..6f4b921f6955 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -479,6 +479,7 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
 int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs, void *priv)
 {
 	struct trace_remote *remote;
+	int ret;
 
 	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
 	if (!remote)
@@ -495,7 +496,11 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
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
2.49.0.967.g6a0df3ecc3-goog

