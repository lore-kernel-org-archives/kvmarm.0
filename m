Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A562344D9A
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513414; cv=none; b=ne57ELWoSxiMW6mstI1tqWl4BYzZCVUUJTbByybSe3rpYHSUqIJ1dyWH2Dym7Un3Fl6HjIsS/QBz9q8UK91oMo+1wBL0vWJtfgsVw2V01f4dwZ8Aj4qUCVBZS46LAycjOJBbuj+Te0Y6+K1yjGul55WgCvZNA6dbUYpeogVbAgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513414; c=relaxed/simple;
	bh=FnlTSjCuLxM+ur+D2apSVIKUkmXQkDU6NIcVCSCQ7Sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e4xs9xV5SzHoUlOulslF28RPY4VzmJ63HghdorHiLsa8Y5CcvC6dSUKWzMBkc0XBzkn+zSDXFHrnhgyURoxWGGvePgrUrbBwPxrpMklttcxv6cqfQeiwec4cmZZM9Au0ez9m0B2I1R+6oklZW9Wk9KXE1D4n4dKlz5KJXnwQNJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nziblD0U; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nziblD0U"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483786a09b1so10733565e9.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513411; x=1772118211; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mn2h6vlbvaGJL2bTqXnVkXpgyiXn9lRqOIfc6OvhU2k=;
        b=nziblD0UAlROZnfdVzDjxdE0fkthbYO9RSx8w7+QJLBJ0ZfLzK1FcUNEljetGmpajB
         0We6KSV7I1EfUCkkszl17FeDu1RvklcKRlSEoz9vfof+HNBDE0okd+EbVHtcqF0IFmpi
         XS6oc7Fix2OmUWHQKwthkwWSM5hxnJ8vZ6L/DaHNDx+X/E+z7VevXvhUJuMuL3Ir2a7a
         4S+aTMo9I1chk25lz1sr24IgjSV7FMN7+5I3fvs7Hhmo8ZN4sG3Kt+np8r5OtZpaq1Ek
         +G6oMmBr56e9EgbITvTYcVjcc9mmXJUNS4JRqY/xtt+UMRoOAVnhKltjhhfz8orpHt51
         D7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513411; x=1772118211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mn2h6vlbvaGJL2bTqXnVkXpgyiXn9lRqOIfc6OvhU2k=;
        b=FaF5gC26NbF/aeD3aCDoL5LbD6hjd+z8i+HoiUKdId18iLoB5NwDFkKj4zrLS5WVfY
         izde9VF7YPIRqJMzyyjOjiC+rxIYZHLdza0nK2JPQbsZAvCKl1FYC7/gh0YR5gL1L23C
         XixYSKyE+mJ4YrmFsKVpR4ucE00FKENv6rINm4XBFHlV7a/p3nqw6JszY5aCfsXHnEuG
         tKXZdMITlPrKDpiIsMEPNX8c9VtEy29xcqHITdcOUmmLVzpyAwt+4PYgUQLD0xr7gwsQ
         9qgGhQrphBwbzSW2C0RAbzOsu/oHSyKfzL2f/5X1voIJCL6+yZqBM1Y+fh8V9Gzym8nV
         chqw==
X-Gm-Message-State: AOJu0YymMHilC90MrOCJggtz2RtPsNLeV0BDkk1uaudx9YgUQlVu3ggZ
	R91XJ1tHpQ5H8HzqAWb/WjGLZR+2WjOSRtlF5gpZ4ARoco/ROxN66BRgbfXbEFchk/tKtnyL6fv
	f7wy7hsYMDb8rVZCQj7BgXA==
X-Received: from wmaq5.prod.google.com ([2002:a05:600c:6c85:b0:480:6b43:8a18])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b26:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-48398a47222mr82552755e9.6.1771513410488;
 Thu, 19 Feb 2026 07:03:30 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:48 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-12-vdonnefort@google.com>
Subject: [PATCH v12 11/30] tracing: Add helpers to create trace remote events
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
2.53.0.335.g19a08e0c02-goog

