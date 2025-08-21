Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28EA2EA734
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764075; cv=none; b=t9958Vl3mxWM4/nEXW7wB1bgFscfHc7SeaVb3rjSvdLrvIQJwfOZvSpMIwizgXfl5i3VWlvRLjTDnUG5UfPn+5yZ1zjRwgNXBGUMFHetKwsuWwxyTiqxKpU0RVkoYhz0rhkbPihgdlHdEkbg13jobWtZv7LfsAqcK2oJXGtmM3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764075; c=relaxed/simple;
	bh=P/7XvxR4AvpjrdbDgKKXlLWIX5BZ4WYCJ7N32BrK4/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fREQrn9pOBTcX4Lxz1P1gnEzWE1U5ercNyqfrr6UeugTrs+n3VV3yhCzBNPXlpXuYmuskC5vQ0h8t3VSenRhcI0G1IVUt/sJc1dVxMAl1wf8KdLG8oAEHD4Gcu12+LNQvIBELIhfOb6YI8shc+oeF4HZk59yrG8IS1eLMRyPym8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tr8salHY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tr8salHY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so3718095e9.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764072; x=1756368872; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4iWuJzzxP4gVw/2ZCfCXIAaNe6s3pd3DhFDuZCx99Fg=;
        b=tr8salHY788FVb4/31fQes6uWl0Jh2UG1+DngmybMvuOe8JDKWbfms5AHdsNx11Hw3
         UuAyjdXS7XlkZIKAOSvNtnaT0bBQX09mrDF4r2LL2gSiqZJVutiM1318hNl+HSLEoeKi
         ynYrg2CXzRQ6dUSB642kMPkDznqa1PhJLz4n3IA6MNlgk+PgH1MOC9BD1k7I1bnVWZsZ
         VIs0JABdzDeRFNMZULmSnefFPzQQS/5XjeGMC5yYj9Xs4mc9404PK8nEnABaM5x+cOqc
         3otJOT5xEUqdNVRFrD7SRnahDOklJpN8FDRzYOoEcnA9piyj+i8sXsqt+rZ0P+RQ5eiv
         gglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764072; x=1756368872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4iWuJzzxP4gVw/2ZCfCXIAaNe6s3pd3DhFDuZCx99Fg=;
        b=srCfbnZhE/Xq9K2n4sfssMJ4enO5N69/V83k/VlOJCPO+NjNuMMGR/6dofNacW/jXC
         j3UKH/jQ39r95dXwqAsO9fTl3Lhv/BPbqtMG4eaqSN1/eXQvvz4PYhTFKZAS+t3JsNnq
         3Xn1HORhuG8uOyU/Prnw7xy1C6iG3N+BqeoxFFMjUTOSym/fAkH6exVF4hvhwp6/faAo
         vEjk+523MclTjtjfgYra4XbaPypUc0zciYoo3cSbkiBuErqwEGU6oq+LDttkSBu+XJk5
         Q6g83iBKq6Ae/c1fpKzq+Pw90NYruDe2AahqyLsIOyOsUeInkGIt8+qjkzW3x1JD3Ytw
         rFyA==
X-Gm-Message-State: AOJu0YxfLtXzYW1kaHT7vjvbSekdKCg++IIG2E9K4U67nNqoJ0yFU03W
	Ov3Btj56zcuR5eBY1yUZamkSq3f6Y+URPGwBk8uo30z4QEVYBT1yaijxfijbqPCysrw8WrVyEwe
	k6Qg1ujet/Bd26KXLW7i3bA==
X-Google-Smtp-Source: AGHT+IG4Q8cp6jOORVXZXkfWOgrpfZ0eZv6m/uotMvvZvAtj714DTAyhspN3LAAa+n5V+47jBjIVsqxX1AfiCyxk
X-Received: from wmbhj7.prod.google.com ([2002:a05:600c:5287:b0:456:111e:4717])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1390:b0:456:161c:3d77 with SMTP id 5b1f17b1804b1-45b4d7f786cmr15535985e9.16.1755764072496;
 Thu, 21 Aug 2025 01:14:32 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:13:56 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-9-vdonnefort@google.com>
Subject: [PATCH v6 08/24] tracing: Add helpers to create trace remote events
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
2.51.0.rc2.233.g662b1ed5c5-goog

