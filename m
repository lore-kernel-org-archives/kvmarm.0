Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E01D354AE0
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866175; cv=none; b=Jmv4VCw5AdPMtpN+05Z+pEDwZtPSO92kEyrNFiuCQp+UvD61eB3Mo0yHksR/I7coBzaw2VSIQNlxS0xIonkrHK9w9z7GYEB1KkzaCfUY2ZA/LHCikEbcwgrUMNBAf/inpUkGwiC8rHqUC9WMnUA+IjIBcGUVRnwVpouW6D/B2cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866175; c=relaxed/simple;
	bh=bH9A+PcOeaBqOY1n6QII0dmbCLpPluQkaUgm1wPBKiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VDAcXCHQuq6SAgJiSupmtGlIJXjoKxp35hHia6JpK3EoOkbyHIvAODVMq9GrRaIhbAfhtVw6DaDvZZk22bWDn6XVmq6N0Sah/Y8fPWWKgJaImf8gfMFVqQSDLJ+bGNyv6UFbm5ww76Zjc/X3wl0Z/t2u4hbqbq9kisfo+Be0Oz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D1IDHU3J; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1IDHU3J"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8861544696so317597766b.3
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866172; x=1770470972; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmv9pvVDnZ4go9IGE3NPxdNq415YebjgteYn5xFgp+s=;
        b=D1IDHU3JIelpRZgiCIG2u0u19GrI3Qbe1+rdgENjoCVJDM+5QTOiU6RgcpHz+yrMo4
         URlM4LT3ExwEQ+7S1qXMmX4FalUY3DtinRP0/haoweNhd1LYkMd65sW1ZfZgntaHHWfz
         7PWH4UcvEYmGBWXduHlH8M49hnIqic/wURU46CrQ8pa8dJER92sHuUpsax42L8580wof
         akJG0+aR+8QzbNzIcdSNoKUxTUyzxTdmWQQNJHLTf8op9wip+Z9OchT0uuMBWY4bn+GS
         gEtgcPefkqph2POA6Yrjos+CICwrndYLFwcCuCkzV35TgwIc+GD2z2JT9uLnukNO6pqV
         XrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866172; x=1770470972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmv9pvVDnZ4go9IGE3NPxdNq415YebjgteYn5xFgp+s=;
        b=flBXyfHzWFBLjp2g0ZrDlQ/aorGBFi42xJAZKwrixN5f7tOIo/XVNkJjXTpF7uZv63
         /jrhtMZbDNck+PdEocXavdFIhEqb7GnNBd5egYWHA9+XcD7FVq9h8BgFesNGULnXxT1/
         YOg8EHLrC4zGkL2NNnDEjEs3ThJtBDVXmu4kLidyBUdpP+gZEzkQr58HegK4RG7CsP34
         FBCljH0cPhDD7Lwk7r1R+4KlpV+1Xrgtr2jyQRy/3LthZuMNJ3lUJAKxvpEqj9JYAh+o
         qfQFbkBf/U+myWFni97skEJEYFmE+qs72Cf5D3pRmmo/F2ChfxEpbt+l3hkSzGDgnxWB
         XQMw==
X-Gm-Message-State: AOJu0YwHrJ4hdLIob27Ao/v6yqC03xbnjkadgSPx6T/ogwjn84JQBe+S
	KcjY72DNKSi2rc6y1Cbu1/iFWiAzAzQ54f68Id8e80SpgE48Bn4fjaz4fisp2pwW35Uh9X4Yb1Z
	bZ9YPu0VliaoVeANARiA3CA==
X-Received: from ejpk1.prod.google.com ([2002:a17:906:66c1:b0:b84:4fbe:af3b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:2d1f:b0:b87:efa:8786 with SMTP id a640c23a62f3a-b8dff6f7d99mr386552866b.55.1769866171645;
 Sat, 31 Jan 2026 05:29:31 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:29 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-12-vdonnefort@google.com>
Subject: [PATCH v11 11/30] tracing: Add helpers to create trace remote events
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
2.53.0.rc1.225.gd81095ad13-goog

