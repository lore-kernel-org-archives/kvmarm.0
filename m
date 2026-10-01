Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B73CC315
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 08:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844594; cv=none; b=ikShHFc4EqTKYnttLcZhm6lXEdWLrxat7o0o7CDDZvEJPaNSu2fbAAKFtOF4JEXzCiz5KhvFLBTWyIrb+ED1kkXUPJEmidXli1zLc+VG/ow5JhuX/NNdUkePHk4PnIzzdExJsxQVNXAZ6CIjeAgsaAmqV5XD74TM4QffCb84FN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844594; c=relaxed/simple;
	bh=e1uYW/j38Aux7cT/JGRZ7kJukrpEtmSyKswU1m/wJ38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oN9grGtwe2lyK2nZtpddHzSRL353mwSD1P8VPH6cZF7IX/CGlxB8zxF/1iTO+cC1xf5ni8v4IvxROIGhokQchIQslDmcDxrhMJhZHau6L1H12QpVqukd/qbGhzxK2pieLGfhygT8+j2kG0wD+f2yFREFVWUa4PBxeTSKNZhrpPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PXfrgNYB; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PXfrgNYB"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6ae551724a0so481685a12.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 01:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790844590; x=1791449390; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CoEuXCUHMThE7b0HEAeKA32nViaypVkNSYDvFKph1Uw=;
        b=PXfrgNYBeO6RWndrbZIRqHER3WW1enW6oHdEbumdMQ+aAddHrkKnTacfpezpbVjVZS
         Ag+zQmMORD8qavWLhw3M1UJ/sq1ExEAUZfstIjgxE6esuEPXGSOysQyN1VHVVUG8S1h/
         KP6jFRzFliOE1P78V6qCcbzB06FPqqacwmF5+cf9e0i74tZ1nFN/OEJF+a/A10pXDA7L
         xYlsKg0Wj0V+W2FwGoBw77W455XxlL0J9Ht5UOLdZiELaz8jBHho6u466/U9HAmP8gUI
         JDW387nqWxZZJjqSQX3NK1LaPPndG9BGB8ePKCE3oleB0wgTafc5hpLFB4xxYng+nuvE
         KMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790844590; x=1791449390;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CoEuXCUHMThE7b0HEAeKA32nViaypVkNSYDvFKph1Uw=;
        b=HxTRvroRrFGduIfjiUuDQxiuu3hc6S8EYnqPzZXaVfhSyYivZkYMvwKlHNcraOSujB
         EwanXv8OsdOg3D/ZNlZSrjmnMtE22r/VV4ORZJzm5ZfT8G0LqPNrMMT53hR1RgztJciP
         trA4vV9yJwOK4KsnfJYHSzwbLCFJHMK9HavEP9QwEXsaKfxZVk+7w0BdTyJExdOksbke
         8e/XSROWTY+hzLoo/p4ClUICojNVWfgOIjF7hN1bOSMx08EeST2trYCZa438uohBDDY2
         b3wKeI9im0hV5cdPMV8wRaPdxSA6zZ6mPVP5gqg+AFoyyu3/G9eqh+jLjQvCnY0TIOAv
         P4ig==
X-Forwarded-Encrypted: i=1; AKwUvBxnhIqczOhtDfZThKpi1Q0n4GZIiWKmXhChZjKBoY/NjiygX6euHHDigHMvNkFjuHEmj3321As=@lists.linux.dev
X-Gm-Message-State: AFq9FYIpPRK2C6wC7XRqq9Bi4dey+ZVtqISEGW5rf4SEo6WxtyUsyTyu
	g8MhOydEFQ20Ei1vtzlHefdzMZiAk3DZ3rJ21A+uc6QeBWUxGg5p41ZBxjDydppDK3yEKu4GeYY
	rK4WImuh+Bf460T+jWtWIfw==
X-Received: from edbdc21.prod.google.com ([2002:a05:6402:3115:b0:6ae:197e:353e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4003:b0:6ac:72da:dd98 with SMTP id 4fb4d7f45d1cf-6ae198f206fmr3222244a12.15.1790844590380;
 Thu, 01 Oct 2026 01:49:50 -0700 (PDT)
Date: Thu,  1 Oct 2026 09:49:07 +0100
In-Reply-To: <20261001084909.2937943-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001084909.2937943-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001084909.2937943-4-vdonnefort@google.com>
Subject: [PATCH v4 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"

The current REMOTE_EVENT() takes as a __printk argument a string format
and a list of arguments, such as RE_PRINTK("foo=%d bar=%d", foo, bar).
Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
function. This intends to support the creation of a "printk" event for
the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
a dynamic print format.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_remote_events.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

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
2.56.0.rc1.315.gc6ed9934b7-goog

