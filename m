Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D401DEFE7
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498752; cv=none; b=Su35z/3AyEwaHcIJmp5pYDflxA/vJqGViHvFvCZntKh9gLBpg27718yHbsBiZN4odUhdAC2n1BXCTtXQlQ/u1ujIDEENVUg//uYl3inFaRrOO2tvewNNI0sZ/0gvmcNJpE/nE3sYrQ47q4W4L6Jnsee3WYtfl94ZmRwfydFBOJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498752; c=relaxed/simple;
	bh=9/4IUKboS3yeSww6Pu1BgVsJcgcL3OjiuC5fyLEdPSs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eWVhT87Skn529Kdf0M2JolajrnrXHQdoD5axAZ5Z65IKnFWtU+//q/k9Lz1xUgpu7QDdhN57fb4AGuohVQlStd6X/cA+rXp2qTGPbTHuA/orOPnWZfO7648vlI32QbBfCXDlbN/DDoMOLKt4M8mfCRuHtssCxcUFnahg+zy6agE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s1llyGJN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s1llyGJN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e4fa584e7so10311205e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498747; x=1760103547; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlIvMmYTYW9xFXQL0KLrUt7g4tYarY39wioQ68L5ZKE=;
        b=s1llyGJNtqpOJtv46hji26+USBrPZ48Ow09mXis8yFpD4038giBmD7qQIW4CjG0Q+0
         LdjLG2h0xfnRWrHOU++qIJ11xj+TzL80zA6g9J+AJS82xE+Cah8jtJhKkHsytQruLGXG
         VZVK7dDtyJsClDYvrreii12CSBi7932UC772jo2HWH5+KqgAjwTHoAtjV7RhwzQH4/Mn
         tp7Arueid/n2H6stXnjgi0ljMrg8iqKmUBeNvJJGxjzylFLHKA0zPpm2fhLMnztcUjAo
         +QxJ1INjQgeBfE3evNLzj8uepQS3Dbb69T3QEhhNwNM14FNqvBVNxTIPb1tTuDcX6QFh
         Gmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498747; x=1760103547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlIvMmYTYW9xFXQL0KLrUt7g4tYarY39wioQ68L5ZKE=;
        b=MiLQ2cLXA60tTGP06kBuvy/AVPR0E/j7juicApPp8ttEMzvJLFcHONDICo5ed6z4sV
         /7zXtGbiYlc0qTpakBL0v9sy4X5MZiAAMpLCvKAixFaKVsiZgIYO0s1hBvVzsj59Tacd
         Nn+WIVfajmk9WKQPYw2ptnZKfDmNGNh0QvCd4aLfJBCoJMnrWzGOdEy+cdVfW0ClbrwI
         41zk8Uf7Xr/JtVoEASYhtOIncaRATcdsMXnhI8i5MAqeejDwEWmstB2agG3C/lsXNxve
         U7VAMXBJuzqHzB/rqBHOYH4ffa6VDIogfeqSLccSICQs8VqCh0N1VUccYEEzVx1RdqhV
         YBjQ==
X-Gm-Message-State: AOJu0YxQQpnH5QI4HedIW4m5m6DruHhB/oTkJiWwP8SnEVM4SiLVvAng
	Qy5hrBL9DzwkuzjnymG0ZIxlsg5eXuVrq/UGg3sZwmoX1cGr/ZI2BdiUlaYnt3cb9AkWwWKff4G
	UN8+ASCBxeOru9Ua8c2OnxA==
X-Google-Smtp-Source: AGHT+IHsx8P5Vs9M8mnwbrakrOPGXjbApzSto+nkAQM4Qfn3U+7Iz7dieUnzsV71vFzwGuJGfn1Qycvc9bWbG44R
X-Received: from wmcq5.prod.google.com ([2002:a05:600c:c105:b0:46e:32e6:eb8f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b61:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-46e71157894mr21943305e9.36.1759498747404;
 Fri, 03 Oct 2025 06:39:07 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:08 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-12-vdonnefort@google.com>
Subject: [PATCH v7 11/28] tracing: Add helpers to create trace remote events
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Declaring remote events can be cumbersome let's add a set of macros to
simplify developers life. The declaration of a remote event is very
similar to kernel's events:

 REMOTE_EVENT(name, id,
     RE_STRUCT(
        re_field(u64 foo)
     ),
     RE_PRINTK("foo=%llu", __entry->foo)
 )

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
index a4449008a075..c8ae1e1f5e72 100644
--- a/include/linux/trace_remote_event.h
+++ b/include/linux/trace_remote_event.h
@@ -5,6 +5,7 @@
 
 struct trace_remote;
 struct trace_event_fields;
+struct trace_seq;
 
 struct remote_event_hdr {
 	unsigned short	id;
@@ -20,4 +21,13 @@ struct remote_event {
 	char				*print_fmt;
 	void				(*print)(void *evt, struct trace_seq *seq);
 };
+
+#define RE_STRUCT(__args...) __args
+#define re_field(__type, __field) __type __field;
+
+#define REMOTE_EVENT_FORMAT(__name, __struct)	\
+	struct remote_event_format_##__name {	\
+		struct remote_event_hdr hdr;	\
+		__struct			\
+	}
 #endif
diff --git a/include/trace/define_remote_events.h b/include/trace/define_remote_events.h
new file mode 100644
index 000000000000..03c9f5515c5a
--- /dev/null
+++ b/include/trace/define_remote_events.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/trace_events.h>
+#include <linux/trace_remote_event.h>
+#include <linux/trace_seq.h>
+#include <linux/stringify.h>
+
+#define REMOTE_EVENT_INCLUDE(__file) __stringify(../../__file)
+
+#ifdef REMOTE_EVENT_SECTION
+# define __REMOTE_EVENT_SECTION(__name) __used __section(REMOTE_EVENT_SECTION"."#__name)
+#else
+# define __REMOTE_EVENT_SECTION(__name)
+#endif
+
+#define __REMOTE_PRINTK_COUNT_ARGS(_0, _1, _2, _n, __args...) _n
+#define REMOTE_PRINTK_COUNT_ARGS(__args...) __REMOTE_PRINTK_COUNT_ARGS(, ##__args, 2, 1, 0)
+
+#define __remote_printk0()								\
+	trace_seq_putc(seq, '\n')
+
+#define __remote_printk1(__fmt)								\
+	trace_seq_puts(seq, " " __fmt "\n")						\
+
+#define __remote_printk2(__fmt, __args...)						\
+do {											\
+	trace_seq_putc(seq, ' ');							\
+	trace_seq_printf(seq, __fmt, __args);						\
+	trace_seq_putc(seq, '\n');							\
+} while (0)
+
+/* Apply the appropriate trace_seq sequence according to the number of arguments */
+#define remote_printk(__args...)							\
+	CONCATENATE(__remote_printk, REMOTE_PRINTK_COUNT_ARGS(__args))(__args)
+
+#define RE_PRINTK(__args...) __args
+
+#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
+	REMOTE_EVENT_FORMAT(__name, __struct);						\
+	static void remote_event_print_##__name(void *evt, struct trace_seq *seq)	\
+	{										\
+		struct remote_event_format_##__name __maybe_unused *__entry = evt;	\
+		trace_seq_puts(seq, #__name);						\
+		remote_printk(__printk);						\
+	}
+#include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
+
+#undef REMOTE_EVENT
+#undef RE_PRINTK
+#undef re_field
+#define re_field(__type, __field)							\
+	{										\
+		.type = #__type, .name = #__field,					\
+		.size = sizeof(__type), .align = __alignof__(__type),			\
+		.is_signed = is_signed_type(__type),					\
+	},
+#define __entry REC
+#define RE_PRINTK(__fmt, __args...) "\"" __fmt "\", " __stringify(__args)
+#define REMOTE_EVENT(__name, __id, __struct, __printk)					\
+	static struct trace_event_fields remote_event_fields_##__name[] = {		\
+		__struct								\
+		{}									\
+	};										\
+	static char remote_event_print_fmt_##__name[] = __printk;			\
+	static struct remote_event __REMOTE_EVENT_SECTION(__name)			\
+	remote_event_##__name = {							\
+		.name		= #__name,						\
+		.id		= __id,							\
+		.fields		= remote_event_fields_##__name,				\
+		.print_fmt	= remote_event_print_fmt_##__name,			\
+		.print		= remote_event_print_##__name,				\
+	}
+#include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
-- 
2.51.0.618.g983fd99d29-goog

