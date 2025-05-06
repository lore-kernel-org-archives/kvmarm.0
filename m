Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B567289817
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550134; cv=none; b=j//D1RtvX0nMy7KDXeYNs8vuMT3FusqM8hH3rUEIH+QX2ALqWpXe2Xs1ZInKEBjnwFxaR3tMm4LtYZmq9Pwb0Go0eK7FPzIE0+meaDrUcJlmwcFW5mVQE3uPmxi6e3jCm/E6NlJd++rt50zva4vjxk5ZX1pFj7TxwjG3uZwtL/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550134; c=relaxed/simple;
	bh=y8rcnohCNx6fnvmwXaaVmdXgnbol8xb6JsiUxsOpG8A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q0QIKKca1NVQ46A6eTTYOAojMWPcGXfPasMsNirlKancJPI2LbzzlDA4YXefp4x+RZyB+P8LWhRhTzt1uLjHjOsXsFi2vOO8yCrQ6TNt4kBfZxVxqfmkG3gZGjbEuLbsTrWCVt40hRpE7LcYloa9DNBZ/uKlvvP4lIEFXj8Bzhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mIsmTI7+; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mIsmTI7+"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-39131851046so1356211f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550131; x=1747154931; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UccoAy7t6DYOqtAFght6GRLYbDtLDUJp2RBCqm6XV8E=;
        b=mIsmTI7+pS9+6oCvkTNx6au5A/Y6LsnIqJHyaSqjF3xRh+3NyuJl6rFHDK0fldZ7xW
         cMK9pu90yumxD4kuayWEPNtkFoe8EboZbHPWwx6HSJlKIP/u7f/V9POTcs5XVdJEU2Ld
         /ge/kVMExdXn6QrBiRaGgD/tmGwWGHK4Dv1Qrk41nCk7NGpLs9EeLRHBDcb2fliQ7wTS
         eY2GD5qV35B/rbBc43u4mEUr/NHkPmNKiO52fMVtgfYYfSXZCwENzPO/zU8Lc3SfgXoV
         oVw4uAm0/xMjlNrl5naKhhNSYpqkaLyyF57i7iBMhuDggTkY1BlljNNi8EcXkl9wiERi
         4FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550131; x=1747154931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UccoAy7t6DYOqtAFght6GRLYbDtLDUJp2RBCqm6XV8E=;
        b=a4K9nscgg6VTOqi1znxJUGhYtz31K0LauV9kqrnUAVqmzKslqxdZkfStSp2fDPrX+x
         QpqfvUuop7xsu1wKkBkTNmpTMWWHzOUSsa9Ued/mMryQZVSapdm6oXmzYj1jI2ftJNGY
         NvsDj3/4obE4rx0qi1vJMaocE+X5BYBegLiVv/m24+LbOpoaWupu/bwFzruSN9RAlGtd
         dZryGlOxotIINeTDfykyEECzWmlDOF+vnrgzaSjxKO/iWEvmjVprdbrYoMrhDVWaSyQE
         YPcFlOsBdpx/qvB2zHgxlu3qZEpdpW0BhnVpY/J0TdUfFN/FRR7uLCCgMkSc9/CcbFpb
         EDLg==
X-Gm-Message-State: AOJu0Yz5xM+Bn5XBwn3iL+mlFwz1TdTjGJ/CYvSYMJ8ey9UpCTxKm2GZ
	blUQvLYV/LMLbOl7RCmdggsJ8A0UX3mfQkjaZTjqdJEv6gHpyfw1p8mMZxELYpYY6L1ZxOkXSCd
	qXMOKmdXkoiLPMYKqig==
X-Google-Smtp-Source: AGHT+IEM95jiwlSfZQ54wnNuqC2fl6D7aBnxwDMPr9V7cIV+4uN83c8dv1x96zRkvBxrXCRdBy2/bVIFl9Y7AHEs
X-Received: from wmbek12.prod.google.com ([2002:a05:600c:3ecc:b0:440:5e01:286b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2a6:b0:3a0:86b0:5f63 with SMTP id ffacd0b85a97d-3a0b49e5583mr173846f8f.34.1746550131142;
 Tue, 06 May 2025 09:48:51 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:03 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-8-vdonnefort@google.com>
Subject: [PATCH v4 07/24] tracing: Add helpers to create trace remote events
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
index 621c5dff0664..d00e85d2a633 100644
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
2.49.0.967.g6a0df3ecc3-goog

