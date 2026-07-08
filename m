Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD393793A6
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497477; cv=none; b=hgwhgTxgl4Hh4I9H1D0Pym7Dap13syqqxr9E9cwWMxkzXD8QVKoDOgzr/6FVZddHx1oLSEyHup4QxOB7hKo+vdtO0G1EQoFjseu8fWbi8UkM9qqEr2Gjj1Bf0Sw6N/AN7zwLYB7dJ7WZTNHRXqSEZ+ftjiYW9+8TFyDF9wLt9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497477; c=relaxed/simple;
	bh=zYcgXAtFyi7y2ox//UY/MqvXscvFIEFI9Jms7Sc5x4Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQOfqsDI2/e4yawn/AQUFbzOxv8sZJlaaHdwFgJtBwOoVrh8D+0SmI/tEOO7zdG1xeC4PwIKa1kcyzxrUea7PSg3EoeXACYCAUhuJXO54aFXXLrRBgpKjBXQsvU8YtJAYaVDYh9w4ppfc08Yr/ZCWk5H4n84ARDpBDuy/lh17DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ILxYnovf; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ILxYnovf"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46fd6d94a8dso202540f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783497468; x=1784102268; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ccb4pWEq/KNyIZlIKmdo4wf78KzfKUcZlEq/qiAL4MQ=;
        b=ILxYnovf5nQIAHrw3yU/Tph1LXGZV7C09oCwMp3RS4II5eTbfShzMbJ1kfQqbm+APw
         GFRPhuk+niEL5rY2wzHuNtcIfyXOGBuvyd183JI0mKF4xRt1Ow/b3xI8wep9dy63HczV
         cLIjLVshybIGDs9bbTgaBZjARmbe4noUxP1qcnvr2kci2wuzi/wZw9+jgEHZjbzEzUyN
         euBGs5rbrLFot+70FjOfDe6/vO2ArUt4wxeJAuBC6ccDnLZ/OLaCIM8F9spkv8cR8WeF
         w7yCSy7cxeIy87t4lZhezY3LKmtaAIYBAvfm/IAoFshVZrlzoa2X93wHAOb7ceN6iMnz
         tKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497468; x=1784102268;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ccb4pWEq/KNyIZlIKmdo4wf78KzfKUcZlEq/qiAL4MQ=;
        b=WKv04bbmqGeRbcT50LvlbYoOJUN3aMKiBxXqIs4CYlvXyK0kreCN47wgdi42wMcTTc
         Q6mTJ4+YtlCE3GahcwHIZnXA+1G3rbkUA9B6qqq82w8ojbMFxz1a5EmqNOVINcXkzYGN
         B9SCFIxUVVPHsD7Wt1p8F2aj2aZiNU2mj/OfMrze0uVcLGHAjVDAINLkD8t/aVgO7o9G
         H9lOpAMqLec986F3W33BElPIZwGOyh4T9A1ucqiMDvoZy60XjRfFhxYKU/i7MXLFSASX
         C5LAyutsiLmUTwaY7xeq/AK2rzFBApkOctSTxMvFhlXsuuIBfI3JcQGN4Aoo3R58Syoj
         txYg==
X-Forwarded-Encrypted: i=1; AHgh+Rrw0caHXFJ+wIHufONw7lAc0xiDaEDF3XDpMZYGE0JlIJ/0XEgTc7kEo5ptwOaR5QfxEIrEAsU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxquH4eXFrPt2m6zuzD6x3/8eHH1hmlHNLAMpqXhocwP6futpeh
	dxHjpWuo+c07ZWe1DovfESvu96hXz35zhJu6nBBrHsgvecX+VaiRFC5+pnniNccIwOiZHBJouBM
	k3jymiIZ3bPhjxEfxLorfIQ==
X-Received: from wmla8.prod.google.com ([2002:a05:600d:2388:b0:488:9c2a:aec4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a011:b0:492:5551:19c6 with SMTP id 5b1f17b1804b1-493e6831730mr12782805e9.7.1783497468229;
 Wed, 08 Jul 2026 00:57:48 -0700 (PDT)
Date: Wed,  8 Jul 2026 08:54:35 +0100
In-Reply-To: <20260708075435.47419-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708075435.47419-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708075435.47419-5-vdonnefort@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	linux-trace-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Create an event to allow developers to log pretty much anything into the
hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
tracing has the function trace_printk().

  trace_hyp_printk("foobar");
  trace_hyp_printk("foo=%d", foo);
  trace_hyp_printk("foo=%d bar=0x%016llx", foo, bar);

To ensure writing into the tracing buffer is fast, store the string
format into a kernel-accessible ELF section. The hypervisor only has to
write into the event the string ID, which is the delta between the
hyp_string_fmt and the start of the ELF section.

The string format is parsed by the kernel. It is therefore not possible
to dereference hypervisor pointers and the format specifier %s is not
supported. Also the %p specifiers will fail to find the hypervisor
function.

To not waste tracing buffer data, use a dynamic size. Each
argument is 8 bytes and the in-kernel printing function can simply know
how many of them there are by looking at the event length.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 743c49bd878f..8465b523cb1d 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -57,4 +57,18 @@ HYP_EVENT(selftest,
 	),
 	RE_PRINTK("id=%llu", __entry->id)
 );
+
+/*
+ * trace_hyp_printk() has too many specificities to be declared with HYP_EVENT().
+ * However, we can use a REMOTE_EVENT macro to automatically do the declaration
+ * for the kernel side.
+ */
+REMOTE_EVENT_CUSTOM_PRINTK(hyp_printk,
+	0, /* id will be overwritten during hyp event init */
+	RE_STRUCT(
+		re_field(u16, fmt_id)
+		re_field(u64, args[])
+	),
+	__hyp_trace_printk(evt, seq)
+);
 #endif
diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
index de133b735f72..46097105fdd8 100644
--- a/arch/arm64/include/asm/kvm_hyptrace.h
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -23,4 +23,12 @@ extern struct remote_event __hyp_events_end[];
 extern struct hyp_event_id __hyp_event_ids_start[];
 extern struct hyp_event_id __hyp_event_ids_end[];
 
+#define HYP_STRING_FMT_MAX_SIZE 128
+
+struct hyp_string_fmt {
+	const char	fmt[HYP_STRING_FMT_MAX_SIZE];
+};
+
+extern struct hyp_string_fmt __hyp_string_fmts_start[];
+extern struct hyp_string_fmt __hyp_string_fmts_end[];
 #endif
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d4c7d45ae6bc..ec03621d7a81 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -141,6 +141,7 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
 #ifdef CONFIG_NVHE_EL2_TRACING
 KVM_NVHE_ALIAS(__hyp_event_ids_start);
 KVM_NVHE_ALIAS(__hyp_event_ids_end);
+KVM_NVHE_ALIAS(__hyp_string_fmts_start);
 #endif
 
 /* pKVM static key */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d72020976..7f9b6c7dfe70 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -324,6 +324,10 @@ SECTIONS
 		__hyp_events_start = .;
 		*(SORT(_hyp_events.*))
 		__hyp_events_end = .;
+
+		__hyp_string_fmts_start = .;
+		*(_hyp_string_fmts)
+		__hyp_string_fmts_end = .;
 	}
 #endif
 	/*
diff --git a/arch/arm64/kvm/hyp/include/nvhe/define_events.h b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
index 776d4c6cb702..370e8c2d39fe 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/define_events.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
@@ -10,5 +10,3 @@
 #define HYP_EVENT_MULTI_READ
 #include <asm/kvm_hypevents.h>
 #undef HYP_EVENT_MULTI_READ
-
-#undef HYP_EVENT
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 8813ff250f8e..3d0b5c634bb3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -46,6 +46,69 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
+/*
+ * The trace_hyp_printk boilerplate is too fiddly to be declared with
+ * HYP_EVENT():
+ *
+ * The string format is stored into a kernel-accessible ELF section. The
+ * hypervisor only writes the format ID.
+ *
+ * The function has a variadic prototype. We have no easy way to know each
+ * argument width so they must all cast to u64.
+ */
+#define REMOTE_EVENT_CUSTOM_PRINTK(...)
+
+#define __TO_U64_0()
+#define __TO_U64_1(x)			, (u64)(x)
+#define __TO_U64_2(x, ...)		, (u64)(x) __TO_U64_1(__VA_ARGS__)
+#define __TO_U64_3(x, ...)		, (u64)(x) __TO_U64_2(__VA_ARGS__)
+#define __TO_U64_4(x, ...)		, (u64)(x) __TO_U64_3(__VA_ARGS__)
+#define __TO_U64_5(x, ...)		, (u64)(x) __TO_U64_4(__VA_ARGS__)
+#define __TO_U64_6(x, ...)		, (u64)(x) __TO_U64_5(__VA_ARGS__)
+#define __TO_U64_7(x, ...)		, (u64)(x) __TO_U64_6(__VA_ARGS__)
+#define __TO_U64_8(x, ...)		, (u64)(x) __TO_U64_7(__VA_ARGS__)
+
+#define __TO_U64_X(N, ...)		CONCATENATE(__TO_U64_, N)(__VA_ARGS__)
+#define __TO_U64(...)			__TO_U64_X(COUNT_ARGS(__VA_ARGS__), ##__VA_ARGS__)
+
+REMOTE_EVENT_FORMAT(hyp_printk, HE_STRUCT(he_field(u16, fmt_id) he_field(u64, args[])));
+extern struct hyp_event_id hyp_event_id_hyp_printk;
+
+static __always_inline void __trace_hyp_printk(struct hyp_string_fmt *fmt, int nr_args, ...)
+{
+	struct remote_event_format_hyp_printk *entry;
+	va_list va;
+	int i;
+
+	if (!atomic_read(&hyp_event_id_hyp_printk.enabled))
+		return;
+
+	entry = tracing_reserve_entry(struct_size(entry, args, nr_args));
+	if (!entry)
+		return;
+
+	entry->hdr.id = hyp_event_id_hyp_printk.id;
+	entry->fmt_id = fmt - __hyp_string_fmts_start;
+
+	va_start(va, nr_args);
+	for (i = 0; i < nr_args; i++)
+		entry->args[i] = va_arg(va, u64);
+	va_end(va);
+
+	tracing_commit_entry();
+}
+
+
+#define trace_hyp_printk(__fmt, __args...)						\
+do {											\
+	static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt = {	\
+		.fmt = __fmt								\
+	};										\
+	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
+	/* __TO_U64 prepends a comma if there are arguments */				\
+	__trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));			\
+} while (0)
+
 int __tracing_load(unsigned long desc_va, size_t desc_size);
 void __tracing_unload(void);
 int __tracing_enable(bool enable);
@@ -58,6 +121,8 @@ static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
 #define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
 	static inline void trace_##__name(__proto) {}
+#define REMOTE_EVENT_CUSTOM_PRINTK(...)
+#define trace_hyp_printk(fmt, args...) do { } while (0)
 
 static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __tracing_unload(void) { }
diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
index add9383aadb5..12223d2e3618 100644
--- a/arch/arm64/kvm/hyp/nvhe/events.c
+++ b/arch/arm64/kvm/hyp/nvhe/events.c
@@ -9,6 +9,12 @@
 
 #include <nvhe/define_events.h>
 
+/*
+ * The hyp_printk event is not declared with HYP_EVENT in kvm_hypevents.h,
+ * so we manually add the boilerplate here.
+ */
+HYP_EVENT(hyp_printk, 0, 0, 0, 0);
+
 int __tracing_enable_event(unsigned short id, bool enable)
 {
 	struct hyp_event_id *event_id = &__hyp_event_ids_start[id];
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 0c7349fe006a..f39a2451c1bc 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -391,6 +391,9 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
+struct remote_event_format_hyp_printk;
+static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq);
+
 #include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
@@ -409,6 +412,61 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
 	return strs[min(reason, HYP_REASON_UNKNOWN)];
 }
 
+static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
+{
+	const char *fmt = (const char *)(&__hyp_string_fmts_start[entry->fmt_id]);
+	struct ring_buffer_event *evt = (void *)entry - RB_EVNT_HDR_SIZE;
+	int nr_args;
+
+	trace_seq_putc(seq, ' ');
+
+	if ((void *)fmt >= (void *)__hyp_string_fmts_end) {
+		trace_seq_printf(seq, "Unknown hyp_string_fmt ID %d\n", entry->fmt_id);
+		return;
+	}
+
+	nr_args = (ring_buffer_event_length(evt) -
+		   offsetof(struct remote_event_format_hyp_printk, args)) / sizeof(entry->args[0]);
+	switch (nr_args) {
+	case 0:
+		trace_seq_printf(seq, fmt);
+		break;
+	case 1:
+		trace_seq_printf(seq, fmt, entry->args[0]);
+		break;
+	case 2:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1]);
+		break;
+	case 3:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2]);
+		break;
+	case 4:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
+				 entry->args[3]);
+		break;
+	case 5:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
+				 entry->args[3], entry->args[4]);
+		break;
+	case 6:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
+				 entry->args[3], entry->args[4], entry->args[5]);
+		break;
+	case 7:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1], entry->args[2],
+				 entry->args[3], entry->args[4], entry->args[5], entry->args[6]);
+		break;
+	default:
+		trace_seq_printf(seq, fmt, entry->args[0], entry->args[1],
+				 entry->args[2], entry->args[3], entry->args[4], entry->args[5],
+				 entry->args[6], entry->args[7]);
+		break;
+	}
+
+	if (seq->buffer[trace_seq_used(seq) - 1] != '\n')
+		trace_seq_putc(seq, '\n');
+}
+
 static void __init hyp_trace_init_events(void)
 {
 	struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
@@ -418,6 +476,9 @@ static void __init hyp_trace_init_events(void)
 	/* Events on both sides hypervisor are sorted */
 	for (; event < __hyp_events_end; event++, hyp_event_id++, id++)
 		event->id = hyp_event_id->id = id;
+
+	WARN(__hyp_string_fmts_end - __hyp_string_fmts_start > U16_MAX + 1,
+	     "Too many trace_hyp_printk() callsites\n");
 }
 
 int __init kvm_hyp_trace_init(void)
-- 
2.55.0.795.g602f6c329a-goog

