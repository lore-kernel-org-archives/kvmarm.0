Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5FC3E9F84
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073575; cv=none; b=VCwqDnvvxT3cXjo2rd8Auv9jXYqNtEeF2xt6GzFDDWOMtXE4Iq1gNXFlb2Av92Khqd8bEOSDZmtavc/jpCAlMvr0DMm5I5rgBiGyVvk4KJICOE6gItbOL9c0WLyBXf5KATV8IYTqnX3kaCz/P6g1ndcGzJi4RVw4JHV0ZxXGEF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073575; c=relaxed/simple;
	bh=JwsRGkcOcaoB6c3jYX0g+dDTHBJdqjZ8mV0DWOQIH+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cb5Hg0bsCSxGC93KqL1EXi5MGZFEZ1cGfmeAiEoyapZMP2maR+zcbsjrPfvvtybr0ARSumw/uGYq2r05U1RZyCykwCl9V6eJtkL+3RPBcplQNY/qGnhnQrY34K3XIlWYGzKMkRDwj7h1MctFork3M02rb3qJGAi3fmc0WZU/91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i2smJAU+; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i2smJAU+"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-660af6dee06so8490105a12.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073571; x=1773678371; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ik5Gwulkcj6xpLazaW4U87LROZJemTRhzFJsU5ExpD4=;
        b=i2smJAU+qu/h6JWX3n61JUN7dQlXtInVE8cupVo9hFj0J6dBKIkifnPhBA6OvT3Jeq
         X9NEBUW4+cI8bSeap6B1+6mcZZx8B38DT0hN1UHB/U/H+wbFpEKP5B7UlCoBCidsDUPL
         KYMoSQoPUxgRHqI62KmcjqtRI+hrXYBlJGQ5LuI1p9rPDK6LuYRqFbRsVqj81A15sOjD
         rBaiyo4TE2QRtetv/qkPHhvFVP7J7fKR5IlQAudFM4uAW2iNp60PffiOnc46274B1SAB
         +rN6tnlRsVwrUvzMTROizRLz8Zqwu9kByuppCX0WzbrKKxVtePUP7CYPR625FihGJ+Fy
         0ldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073571; x=1773678371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ik5Gwulkcj6xpLazaW4U87LROZJemTRhzFJsU5ExpD4=;
        b=nmoItMVNVZF9apKW6eA0vZOw+dMObfjtFdF91k7dAzlXetpr0/COviXA/GDH4aGyMr
         8p+eJTs8d7hr4o02MCr76uKzieYnjq3YZutDfpZ3wqL8y/xhr/oCFDmMp/aAXlmkdXz2
         ERYa/NX4G9QZToHul0+QEw6r5mXWp2SuCdJBDPiXPc8Ug3POEOqGqf7F7xncpXtdmFPk
         AjETc2V7POM8YZQurWQlvpddW4la+LNIOw3r6tpYg29fMVos7vE39r3lKwf8VApRX8Cm
         mZoYXm9ZqWasD2fMrRf98KR0mdXWAmjSKQdu0IVOHBbwxSxRsMAOf2pWm9jvHGrBtTi9
         5Whg==
X-Gm-Message-State: AOJu0Ywz8KbSMjBeLcxEU9Oz70ivJuxnPWcCOYYCtGBVqSHw/T3/x54S
	bbSO3bXT8+YqfobNCwDnkhU3zGBgoJr5UDugGcqjDbGo+Dy25Dc2kbvktxB1HeOMwBhZwAEExcS
	k4YE5B9Dee66CsZim50z5xw==
X-Received: from edxu25.prod.google.com ([2002:a05:6402:659:b0:661:2fe8:17bd])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1466:b0:661:7b69:b45 with SMTP id 4fb4d7f45d1cf-6619d4d4fc4mr6921428a12.13.1773073570997;
 Mon, 09 Mar 2026 09:26:10 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:24:57 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-12-vdonnefort@google.com>
Subject: [PATCH v14 11/30] tracing: Add helpers to create trace remote events
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

