Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0568A3B8BBE
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807767; cv=none; b=mscOJyEVYZb3Pho8x94sCNXiMIB/eDtyf6Bt8kFsPWEYNwZuzgQXrfsbgO7nPuJbB6tqwR3cbxt9JwBA1jcWcS4EXMm+PrzCUMuvn16KwoTvRvyGfpdkc9hKMiQUzjj6/Wr6She2PXzhx0fruaTt3uowCRClqCrglnAkLwTs5qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807767; c=relaxed/simple;
	bh=JwsRGkcOcaoB6c3jYX0g+dDTHBJdqjZ8mV0DWOQIH+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vg57vhHawYBdWJ9Rxhn3YTlgZhkXKz8A6l6/UQ519HIUz68rQ9ZPwLozte++FNxZiGcbf+tGADmWgxHePcZ3FZRYm8jodlJjpHWjajytgjclkuwTMrsLCjqsaJd1SMZEsBOc10J2c5IYLu+Si03v9D5NHLEqHXXh4j0NoPu05Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s110l9EY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s110l9EY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836b7fbf4fso73339695e9.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807763; x=1773412563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ik5Gwulkcj6xpLazaW4U87LROZJemTRhzFJsU5ExpD4=;
        b=s110l9EYHwUKHbWeiBNFmP0I5Sm8aqO4mwp/tjzOXlVcuMFvtm0kGetWaEqLj/iQzx
         0+X2tekF5woa//XjKCPzHXJzx1s2cF2q1I4AzDUcdaq63cEw6P4FSFYzqMVdYXiudtTf
         5S4aa9ZcbFgFris1u/To7nalLKqtqElTop3nvZl9mHhSCTXMDpN9OfxX5GTsFl8JTcem
         hSqqYAL8q9j8YcfQVdLi36FMpZhLj9c31Z/jDyH/rqgY/ZhqGpKEhqIK/95YCZGTi4Ec
         36dtKoMVQyZAhKWvUkwqBF3mdhp2bRhD06IiPZJLUrmmdwdl/saJYWmjN5q8zUY+BefS
         J4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807763; x=1773412563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ik5Gwulkcj6xpLazaW4U87LROZJemTRhzFJsU5ExpD4=;
        b=qXr4AdfrIq82l5o9lkP1vIx0c2tMnt9shSzpbY5DvA4+1fUt31gjcZlOH6v4S1dm6K
         iEOpp/U7LPwVKnG4Siwx/Tm7VrH1iovrZrcaan07wRM+BMNDEhLXwI7SUW5NUHAj70eQ
         PkawZWz/ntTYa3F56BzjmFehMzmmqW19/Bjr6YiHww7YHEVprVAU+ynM3hn0fnusg5F8
         BsAYoNvUxjEy/Ij3/F+dF91vHGgApLFPCIT75TU651hGtTDu4dAG6nUthMHxuT0M/hRj
         SUtsE6Cg2h6DiqxB6uRAcxWdP0rwtaCGdYdfm1HYTBIEni37aFjUWQhFLbD2fO0lJWnq
         TctA==
X-Gm-Message-State: AOJu0YzftSAfW7uMC8++b7vHpSbqBdzpgmxynXUp6Ocgkunc2BCiMs15
	1QjIoQtQMIJedAhL0HiX32FjKgseYJE1DxPXaB2Sk+e+knCsW2rrIKu/Ui++LUCLDqw2XhUMwx7
	0aZksRm8UukQnMUunsnU3hA==
X-Received: from wmlu24.prod.google.com ([2002:a05:600c:2118:b0:47e:ddf0:fd00])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b0c:b0:480:3ad0:93bf with SMTP id 5b1f17b1804b1-48526979668mr36579565e9.24.1772807763338;
 Fri, 06 Mar 2026 06:36:03 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:15 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-12-vdonnefort@google.com>
Subject: [PATCH v13 11/32] tracing: Add helpers to create trace remote events
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
index 000000000000..676e803dc144
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
+#define REMOTE_PRINTK_COUNT_ARGS(__args...) \
+	__COUNT_ARGS(, ##__args, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0)
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
2.53.0.473.g4a7958ca14-goog

