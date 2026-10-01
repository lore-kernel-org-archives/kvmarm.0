Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CD521203
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865024; cv=none; b=OvRHh2FbvMANgnJ/fik3DvgaXblZYayfeaezRdYreI09IFKQY9VP0fKTIeBpSFfYUR1dKot+S16+VP1dgLKnJqWAQPNrtu4XKaizUyzjp6jm08U8lme00MQX6ZtbkJ+Bz0+GTlCvjctPrnCwC2wp1x9cWGm/k+G4M0eeeYSXv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865024; c=relaxed/simple;
	bh=p2F6aCNVv/Mbuln4S2BXzpo6jI+DdR+8VMpJe1ewD4I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dnjMX3bcUlWjXqjZ/m2vrZY+JcO/D9OyCFsItizOPiUX8z64PRKfDKm8+pQzTgCWCdo0FPz9+JA6OPH9COZU+mtvJlEPUi7KsXqgTkwBl3fu6aSqrK6UJP8kmOlSJfrduGpMoMcpyaB20uCzC8jy/GDKlDuM5pFCfElRpo0bPAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nZTmfg1o; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nZTmfg1o"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b02d63407so1222783f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790865017; x=1791469817; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IrBFhkITbSN8UWPGppEwnUycZpASHfPM0q0E2Ptifos=;
        b=nZTmfg1oEEgZS2BEPQZUtXusuUuOO7rEz6HDxEAc983NjbRS736QP9jHaZNXQpu/c9
         BdsDjNn3mKPl96+TpV1pAglzBE3NdPk2JnkUmRoS2RpjH/xof+zDbC5i5E67xz75s9Sj
         elIZqkrQd6WNWg1sW7dPjJ93kX0snPB/iCr5/3aMixR+/Hq5zmBRqgsRqTIUjV3Go90Z
         L9HbIOXR4u7uZ1yPpU/JCNLtv93OFFizID6F00PX92l71KcaG+Vgs5f42037/vLCAcfn
         SrGi2snheaso62eAzxt7MnIxi4Sz50UQDB3ggtag9cisNYDXu0ioFQhZgQIMqERHsXd0
         tmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790865017; x=1791469817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IrBFhkITbSN8UWPGppEwnUycZpASHfPM0q0E2Ptifos=;
        b=UPFfwurr2Uytq+FNt7hz787dTzhHbl8VbqyPnDvI0dKU8yOa4goRJuuyyfb+04iSow
         +jQeLi9fmW5VSIpCtEURnG2XFZIkMEBL6786hJ2+GZGKxWdCCbHADD20xQNvRoS+4/L9
         n9WiB9Af+gZ7BzB5LefJauE4bxIGmLPVSMgJWi+YbailxuPz/FDO6TMMdnD+0wOwL+vT
         HwusSrhYQO5bOZ5w/G75Arjm3QR2ugQm3nfnRW6+/MSvsNgQYo0csjJN1irAcwpOPGdE
         QIo1UzSU1nq1PIg6D6rLe/fvzXMKydkZO2ibwgbmWvpCzUxL7y5uV6nXFDotIP58j4+5
         T+oA==
X-Forwarded-Encrypted: i=1; AKwUvByOMl/7JTnEe8Fa/vJnQchGqLpgKN0koD0335tWa3WShZOOKLbCqLBrgN7dqoMfz9JEP9hokow=@lists.linux.dev
X-Gm-Message-State: AFq9FYLoXBzaGoMLY+EgZli6Vv4/EVg6VEWsUqMQVP4LhA8ArVfjS06T
	nxVVKZUx5ATij1xZMeHIThIXkGIqYe9Nyc7Alafd1ktKWtEISFBlJz5Eu18kGScDvcPkDELHhgo
	33lcP9ztojzJd67r+eqQG4A==
X-Received: from wrio15.prod.google.com ([2002:a5d:648f:0:b0:48b:175:52cf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2007:b0:487:baa:aa6b with SMTP id ffacd0b85a97d-48b02541506mr8294054f8f.43.1790865013573;
 Thu, 01 Oct 2026 07:30:13 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:30:00 +0100
In-Reply-To: <20261001143000.3371786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001143000.3371786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001143000.3371786-5-vdonnefort@google.com>
Subject: [PATCH v5 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Create an event to allow developers to log pretty much anything into the
hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
tracing has the function trace_printk().

  #include <asm/kvm_hypevents.h>

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

To not waste tracing buffer data, use a dynamic size. Each argument is 8
bytes.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
 arch/arm64/include/asm/kvm_hyptrace.h         |  9 +++
 arch/arm64/kernel/image-vars.h                |  1 +
 arch/arm64/kernel/vmlinux.lds.S               |  8 +++
 .../kvm/hyp/include/nvhe/define_events.h      |  2 -
 arch/arm64/kvm/hyp/include/nvhe/trace.h       | 66 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
 arch/arm64/kvm/hyp_trace.c                    | 61 +++++++++++++++++
 8 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 5f6e6789d121..3396deb1a1f8 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -58,4 +58,18 @@ HYP_EVENT(selftest,
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
index de133b735f72..16e8d60abba9 100644
--- a/arch/arm64/include/asm/kvm_hyptrace.h
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -23,4 +23,13 @@ extern struct remote_event __hyp_events_end[];
 extern struct hyp_event_id __hyp_event_ids_start[];
 extern struct hyp_event_id __hyp_event_ids_end[];
 
+#define HYP_STRING_FMT_MAX_SIZE 127
+
+struct hyp_string_fmt {
+	const char	fmt[HYP_STRING_FMT_MAX_SIZE];
+	u8		nr_args;
+};
+
+extern const struct hyp_string_fmt __hyp_string_fmts_start[];
+extern const struct hyp_string_fmt __hyp_string_fmts_end[];
 #endif
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 14beb7b9d304..ef9875a95f95 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -143,6 +143,7 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
 #ifdef CONFIG_NVHE_EL2_TRACING
 KVM_NVHE_ALIAS(__hyp_event_ids_start);
 KVM_NVHE_ALIAS(__hyp_event_ids_end);
+KVM_NVHE_ALIAS(__hyp_string_fmts_start);
 #endif
 
 /* pKVM static key */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d72020976..69ef676e659d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -214,6 +214,14 @@ SECTIONS
 
 	HYPERVISOR_RODATA_SECTIONS
 
+#ifdef CONFIG_NVHE_EL2_TRACING
+	.rodata.hyp_string_fmts : {
+		__hyp_string_fmts_start = .;
+		*(_hyp_string_fmts)
+		__hyp_string_fmts_end = .;
+	}
+#endif
+
 	.got : { *(.got) }
 	/*
 	 * Make sure that the .got.plt is either completely empty or it
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
index 8813ff250f8e..d38e0fb284f8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -46,6 +46,70 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
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
+static __always_inline void __trace_hyp_printk(const struct hyp_string_fmt *fmt, int nr_args, ...)
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
+#define trace_hyp_printk(__fmt, __args...)						\
+do {											\
+	static const struct hyp_string_fmt __used __section("_hyp_string_fmts")		\
+	__hyp_str_fmt  = {								\
+		.fmt		= __fmt,						\
+		.nr_args	= COUNT_ARGS(__args),					\
+	};										\
+	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
+	/* __TO_U64 prepends a comma if there are arguments */				\
+	__trace_hyp_printk(&__hyp_str_fmt, COUNT_ARGS(__args) __TO_U64(__args));	\
+} while (0)
+
 int __tracing_load(unsigned long desc_va, size_t desc_size);
 void __tracing_unload(void);
 int __tracing_enable(bool enable);
@@ -58,6 +122,8 @@ static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
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
index 8faaec899f92..c61488d16f4c 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -402,6 +402,9 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
+struct remote_event_format_hyp_printk;
+static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq);
+
 #include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
@@ -421,6 +424,61 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
 	return strs[min(reason, HYP_REASON_UNKNOWN)];
 }
 
+static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
+{
+	const struct hyp_string_fmt *hyp_str_fmt;
+	const char *fmt;
+
+	trace_seq_putc(seq, ' ');
+
+	if (entry->fmt_id >= (__hyp_string_fmts_end - __hyp_string_fmts_start)) {
+		trace_seq_printf(seq, "Unknown hyp_string_fmt ID %u\n", entry->fmt_id);
+		return;
+	}
+
+	hyp_str_fmt = &__hyp_string_fmts_start[entry->fmt_id];
+	fmt = hyp_str_fmt->fmt;
+
+	switch (hyp_str_fmt->nr_args) {
+	case 0:
+		trace_seq_puts(seq, fmt);
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
+	if (trace_seq_used(seq) && seq->buffer[trace_seq_used(seq) - 1] != '\n')
+		trace_seq_putc(seq, '\n');
+}
+
 static void __init hyp_trace_init_events(void)
 {
 	struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
@@ -430,6 +488,9 @@ static void __init hyp_trace_init_events(void)
 	/* Events on both sides hypervisor are sorted */
 	for (; event < __hyp_events_end; event++, hyp_event_id++, id++)
 		event->id = hyp_event_id->id = id;
+
+	WARN(__hyp_string_fmts_end - __hyp_string_fmts_start > U16_MAX + 1,
+	     "Too many trace_hyp_printk() callsites\n");
 }
 
 int __init kvm_hyp_trace_init(void)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

