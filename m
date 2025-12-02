Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818A1310631
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668207; cv=none; b=hYMqHSEcL7KusR0jz+6tazFc4bheSL0zSfmvt+5YIonCIwS1n+UDDW/W5xtlopS8w6LnsBRLCp47U0OBAYF5C8j3PGuarOOIC3Cx1WjlYhyuE+zrYo21BPL8tAq1UMFpxLKhPuezvU42Y8P4m4DEkfvPAT93TakkOajpgqj1uvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668207; c=relaxed/simple;
	bh=FLqzu6rYowlPEBLBt/92KqHCJdyNEXHFEtMdme6o3jQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+HV9Nt7hCTXNm3zy+kiikXxA7GOWODCUCFbTA8I/UmAS+zIGfXxEvQ+I99bHOPbzXZOFvefhh/bxNAkpbC2IE9lLWTrZ4PHIKpHRHCQpGKiitepVnhMJHj7FmfSAm2rtBCVEy+fsfQ06BRMt02aEIGi2QuGEJzsKaj1XzJY0bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQ56vPoW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQ56vPoW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so40303335e9.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668202; x=1765273002; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh3auc+pwpGG6pY6qlM3mQFQvqq/vgrDFfWJnokLoGs=;
        b=FQ56vPoW7jVtgi1/SY4t1GjHYu31sVpJdbwM1IjPjMfNJ5Ti+pIOoTDxkodjWzViWx
         LpVOx25UHrWW8vgR4wy9U+/AQoE0Bv5Gr8r1rCdlXOKIEZsCH5eMvKoE8f3Yczx2wyEn
         w/i29A83hD5gqzSJNhOOBmuXb04B7H5IC7CXYZOwPP4BenQT0f68O1yDw2oynsPq/4Bh
         sMo2eDrvkPVuEb4YojAwBa8jIzUHw9forJCaa9o3XdiGFi/oxDdoY8YRERxO9opR4pmV
         4C5CdHXYDMZBVJ9YEYfaO1lDm7q0nAL6Cmoow9D4Jt1nWI+fQrPqvtusjk/JBYC2JPTc
         u3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668202; x=1765273002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh3auc+pwpGG6pY6qlM3mQFQvqq/vgrDFfWJnokLoGs=;
        b=ve0+dQjl/BpD0xYLDWkG6ZjnpXgJZk01gqUODe8u150fIH51eWmJknWISu67HhnYMP
         KrRd7O7Tsof6oVIoLCHsLfwQwC25PqHz8yLfFxrMRqUvi8RSAxikwSV8tROYUEcM04RO
         J8fJ93pMxljLrUhSBxZzKmjqw7CvFlFxTuZFhlSkWbCGjWPF35Isn4lWndbsjFxBR+q/
         ibFTS90L9IEKGYaqF6RWdg4nDrrEJP7zna26YUUvXFOyR46kCSvPumhmSq/Glv68QHeG
         3VYFGQ4MFnuo6PO+TCoAiFwKELIE0H030n/H2+/g7TPAoHtwmMvd6N/WTU3W4oA2HiHm
         8THw==
X-Gm-Message-State: AOJu0YxZt7JByhUZkr0ziHoYhaAXZ2JyoQ+EMleI3Kg2unQMsA9eV+ro
	Vf/fPeA0gOB4vQ77OMVgaKZkKKTceAjWkxS79/5kc0jYiFmwUMwJ5atYstPhy20BCzWnZX/PDX/
	vieNXBOEhh27eYhC3mWLeMw==
X-Google-Smtp-Source: AGHT+IFqBsvcBJuV4v0n5u+KzV41J5YHctyL7Ce2G+Ae/Dhvi2SbVwxd6NXS8EBe3veCYrnWLAw0MkMNjnYhy3if
X-Received: from wmpy10.prod.google.com ([2002:a05:600c:340a:b0:477:9feb:9bcf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba4:b0:477:95a0:fe95 with SMTP id 5b1f17b1804b1-477c1123ae7mr557272945e9.24.1764668201908;
 Tue, 02 Dec 2025 01:36:41 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:04 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-12-vdonnefort@google.com>
Subject: [PATCH v9 11/30] tracing: Add helpers to create trace remote events
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
2.52.0.107.ga0afd4fd5b-goog

