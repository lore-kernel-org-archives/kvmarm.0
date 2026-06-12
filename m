Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAA837475C
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274179; cv=none; b=Zi20bbIDl1M52MDiBdxHbt/NVtMqPirAatv6uf69JW/uaaj7somP27VnVz+2TUfmL3QGL+hDnVdZ0LF7aNX/m38H12cZzWQeWp5D70BjDgo7txFP+C16csBwAGb4SeoK1nJcSn3M29Z5Q1YIAmxrTPxHhKmFUCgvwxr1KYdRH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274179; c=relaxed/simple;
	bh=/CMlu5F3BPJhOi5iLNcGJTySGgn+lLjut381rzs4x0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=my9zQ4ZZqHYHw/IJiTKvS0N2Ca6jEiEfBg091BdNsE38hMDCN8BC3EJYuVAXs1Uz0tMCYT68vEWmvYvZiZTrcKjoSl3RZOpgB9UpjjM+UfeNwqT47DZgbfo/Vw+Tc7e+h/G+6rxoT0xUWVnB6Knaj0HdSl9dfY47Rt9muKBgNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hsJhdImv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hsJhdImv"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490a767b782so7665525e9.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781274177; x=1781878977; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p20ew6e403t+YJXmbrP6YhcLac/7S4zk6VacatBVdC4=;
        b=hsJhdImvmFt0PjckzxLZ0emM1SVB0XclwP+eeenPHJhbs2J2pwm7+ZGreON9QbodeN
         DjYX8F6PI97IbAeUkHca7GVw8V0ePyAMVGf5MhuEm/FQHeSDg9n6Bhypec4wfDpbQxJ4
         oD8R4Po0QCqJiUIGlLYe8SL+164bg69VgcZFLswdDa4VketPrbA/v4nOuWlq7X1OAs2d
         LMaBvJZ9jr8r1uuCqYKJI5M+N1fU3/GbFsqoCJzSI+NwuACIeRRklQg98iWgpmF7aIMe
         S/+Nqg2CFQovEEBBrz1N+dKERNp1eo158xJDeLBEW8xDdQLfgfC3pIMoM2JxMKC8fcC4
         OSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781274177; x=1781878977;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p20ew6e403t+YJXmbrP6YhcLac/7S4zk6VacatBVdC4=;
        b=syABSec2/Wjr3gA01bmSEx0xaSM8uu7lzG1vBJEl7c32oL28UHtxOZN0NEbRp1afvB
         Wu/b05AvG1ogzPauEHo/aJaxTsdnVLYFU50Iaaxngd18E0TldJjJJRakMPFgmcOOivOi
         Vf0//sUiS0/LQxKJ4ucNvEOclRaAWJkgpdEztpXEJ/fexUifEZg7bTzBFBtTWSwK55yE
         /z2DX/Xzh5XQUND8D8CxpCI3Ylmfxw752b8TJQGR0Z+q8Je5EhRyDPtfOme7C4snH3/U
         LTI0O6EjR6HIC/U1PdJOzdLeBcokcALyWRoNHFZKctVgRpffMqZBbT6bsnP/pVKaGnjb
         ypbg==
X-Forwarded-Encrypted: i=1; AFNElJ8QZFIwfwUCFSCSCj3tGdXwsweg9uVHbiMg2jtl30qETqukhgrv62HyC60cOLB01zfEtiqF++c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6JPO1ibELsx9uoZtcRnmqxhADGvYuRCzCR8s4aH1bX3u6KE6c
	5B84/6YxeB7n/Bon8Z8pECJrFV7EgFhk22QU+mrImOoT6+PkMqbYNJcj9j+axIRtPUM2dxelImd
	ao+J9mlJ3EfegIpLgLre59Q==
X-Received: from wmxb6-n1.prod.google.com ([2002:a05:600d:8446:10b0:490:b2ca:ed1a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6452:20b0:490:3f7a:108b with SMTP id 5b1f17b1804b1-490ec4fb540mr30673625e9.16.1781274176923;
 Fri, 12 Jun 2026 07:22:56 -0700 (PDT)
Date: Fri, 12 Jun 2026 15:22:44 +0100
In-Reply-To: <20260612142245.1015744-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612142245.1015744-4-vdonnefort@google.com>
Subject: [PATCH v1 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, qerret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The current REMOTE_EVENT() takes as a __printk argument a string format
and a list of arguments, such as RE_STRUCT("foo=%d bar=%d", foo, bar).
Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
function. This intends to support the creation of a "printk" event for
the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
a dynamic print format.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/trace/define_remote_events.h b/include/trace/define_remote_events.h
index 676e803dc144..4f4d58e37b84 100644
--- a/include/trace/define_remote_events.h
+++ b/include/trace/define_remote_events.h
@@ -35,17 +35,26 @@ do {											\
 
 #define RE_PRINTK(__args...) __args
 
-#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
-	REMOTE_EVENT_FORMAT(__name, __struct);						\
+#define REMOTE_EVENT_PRINT_FUNC(__name, __printk)					\
 	static void remote_event_print_##__name(void *evt, struct trace_seq *seq)	\
 	{										\
 		struct remote_event_format_##__name __maybe_unused *__entry = evt;	\
 		trace_seq_puts(seq, #__name);						\
-		remote_printk(__printk);						\
+		__printk;								\
 	}
+
+#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
+	REMOTE_EVENT_FORMAT(__name, __struct);						\
+	REMOTE_EVENT_PRINT_FUNC(__name, remote_printk(__printk))
+
+#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)			\
+	REMOTE_EVENT_FORMAT(__name, __struct);						\
+	REMOTE_EVENT_PRINT_FUNC(__name, __printk)
+
 #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
 
 #undef REMOTE_EVENT
+#undef REMOTE_EVENT_CUSTOM_PRINTK
 #undef RE_PRINTK
 #undef re_field
 #define re_field(__type, __field)							\
@@ -70,4 +79,8 @@ do {											\
 		.print_fmt	= remote_event_print_fmt_##__name,			\
 		.print		= remote_event_print_##__name,				\
 	}
+
+#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)			\
+	REMOTE_EVENT(__name, __id, RE_STRUCT(__struct), "Unknown")
+
 #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
-- 
2.54.0.1136.gdb2ca164c4-goog

