Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB89731813F
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508343; cv=none; b=q3PdQY12WYfGz7G4Mkp9GqU1hWxR2IyWHET7CvQoXbr26pEsj8MLv96d4mAxfbhGPYzPaHncRC3IfE6mdc8ArP7y6bhi8hcdr+YBUOFs0JVu8oDS8SBTXI+AXvKM8KheZGdp4rwLENhkmKBm6FYg/Pa0FDzFzrYZqj4EyOrqp+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508343; c=relaxed/simple;
	bh=KaCJU10/R6tpdvHO5Ka4YB+jCv0bw4x8NPwKQmRGSP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G9qNnTsq1fVfO1k+mNxbRuQDy9F9L7LhR+awhzTRc10vCCt4S4XTXGPaIMLHjtzFZB2XiqRJPP1Fd4qE35sMuAUHs7S+lJMsjSoLsQNDOAldj9Z2xXUAB/2wQmqmJg/u/xfC3znwcgLEGXTYtxXqONTD3xd3MpiAUIiQmmHftJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ptzy4dMg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ptzy4dMg"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4710d174c31so4297105e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508339; x=1763113139; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kZQXGkPHe9/U37tQNGKvI1ZfLYMo8CduBTar9VDjyVg=;
        b=Ptzy4dMgEoS9DazzqH87T0xhLikYZUeQJr3n1QkORJFGf2DBAy2ZwCYTsHNhCK1OEz
         TBH1g25MYW7PSd1d5qCEd7ftaVY6Bzm6bLE12k/nQmpiVM6/FVJbxOg9XPGcsWAGuHus
         inNEt1+j+RyqbC6Rt9kayg9NqAf0ZDWEYRt9VPDDLPKELEm7gE1ZvaAVUWsC0/ZC/Fkv
         2DnNrK4kES+IdtM7OFUjs8QLlhqX5oCfT1GlzNThjI0pq/vh1qGrOIyBKv2jZaK5qbww
         znfV597WtY4zBt6XLVhP7nXDSJ1y12v0W249Vkn++1y75vAE2ALF5hhg6auLVFo/gdU9
         nddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508339; x=1763113139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kZQXGkPHe9/U37tQNGKvI1ZfLYMo8CduBTar9VDjyVg=;
        b=rLo2a8zuezS+IdT7QlF6jYewnDkdYFqt9HBtbYyZCrXjMWgjPytGRwtO/i5wCUzLln
         QBYIGCgOXlySeN9uv+59httpNM0j7qyh3INvhtT8Vw4mnAqB9gvJXqPRHI0ppz2W1e00
         BvVKs6DTU9697UDy4sfpwdBqHyLnMTNw016ff74ZzFz7T3FR++mK+e+HyGGl2cFAG0OR
         ns2S8hhPwGkPRttUJoyrIS0n13h8FbAPogBxvuk2qroMcDImzyNYEYA9sVDB/CYejXTb
         l+u1BtcCQI1pEsYdZBx6gT8B2+VxOi419CbO7w3t5vsmx2xpsRkoY5kGjqq1aZysfiS6
         n1UQ==
X-Gm-Message-State: AOJu0Yy2jvOq85H5fW3+MbS4XqIzssrb6GDkyBiwQVM8FMLfW7jNzC1t
	V52nzqozoNVGT08VgjtLKvMBX1wrDG3tlEhvz8XI5aJFCe+dWEuv2l5oxVlCWBZ6oqnhCDRYnLb
	Y455K3LUssOjPPrOf3MK2WA==
X-Google-Smtp-Source: AGHT+IEgHqXeHwKXNC++2iV0+wfS/fik7pjpkk7m9+1zJmg2GRsFEpcM8FI8jOV3R+GhV8IJz514M5L5g+FvFVCF
X-Received: from wman13.prod.google.com ([2002:a05:600c:6c4d:b0:477:14b1:69d7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4592:b0:471:11a3:a6a9 with SMTP id 5b1f17b1804b1-4776bccacd0mr18890925e9.37.1762508339110;
 Fri, 07 Nov 2025 01:38:59 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:23 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-12-vdonnefort@google.com>
Subject: [PATCH v8 11/28] tracing: Add helpers to create trace remote events
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
2.51.2.1041.gc1ab5b90ca-goog

