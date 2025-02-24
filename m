Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8424EF71
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399349; cv=none; b=oFLELd0Ej0U6s8uHISnFdRn0lxR75uFQnbQqpdQ1gZVjbKnpHBVEOHeym4hRxRZAZdAPazu4fz/i1epxrthK6R0BRa5Qv9vsi5PQA9sJLKa9LvtFy//rFRAOIm+GpIXpNmPir8AxUr+/YHBEiGL1/s94h7h55yqXByk+PLUUHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399349; c=relaxed/simple;
	bh=wWP13hin3qw58zVsb7h8Al9yoi3OXQiJC7z71yVkc3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Incs7+qs6Vef8DoCjVjjvzH5IUyAWIGuuq+LMdTiCx97ez4e9hG2BdZYS7nrE5HM0Jvxc4cNvC51Ry1GDLi09+ADcEzkYeHepnN7WTy8Xn1lQxNgDzlfaWeyny/lCxgep+s+P3hDy11/tEr9KeMya9OLuY8Imbld+0CnV36VHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pI96LJd3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pI96LJd3"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399a5afc95so18203005e9.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399345; x=1741004145; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQnKgBjbhLrkQnSkRGlTGMRUQsY7Lj3HimnUr6EhSwI=;
        b=pI96LJd3RjBYqpOJCITdrv+r5C/hT78XhNp/NBmI9Jx/7WFtFso+/ysYRWKtMsc+zj
         CeZ7BLDxSjLoSDBddJT5YcfhvYk5HI4+dLjiZexsKoCkgSLCw0/9BlPLR6S/AuhF3uj1
         ZOkXFIH/IB5O+uVKbcQ5lgE0exLtuEvmBBhR8jX0pfWReNCDoKDyXgIE1DM9fT/5HbbM
         5kPe31Ms/6G2/e1riekENKj//UrkcQ3oHGXseYwkhL+qdC0k6uhk1/PrzAQ/M+Bk77yd
         aQ0lwpYA3CB8KbShgznRxhbPaWzftoacKz0Rt88ay9ZCRUBaNiAG8+SmK2eJymslh3OA
         amUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399345; x=1741004145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQnKgBjbhLrkQnSkRGlTGMRUQsY7Lj3HimnUr6EhSwI=;
        b=JwBETJUbWnmgn9HEIEZPWh8Rje3Urfvv/aKNJtNOABRwOXTEJ5ZTpS1Ho5Ei1uSiBy
         z7uPWLp9sUEhtawFF/ReRlHfxuEWU1+1fMf6MtpTGVgwjobmcqUwZfiiQuB2RVayGi09
         l+0SBwi6yewxc5zk+3o48CPbuxpLp4KKS7+CUoBVrj+tRepdsVNB/735Rq0Hrq4pKYlH
         mKJFeZYmLoa3e15Y+SnhkEQx8bqisGVbXf0UEs8P6CWV9FR0JTi0OOyRFh2ENZJ7TUcn
         BQ/4hIrJfbiNdmB58v2pTXeSVWJMIXuvDXt0A2HdB4MrsfkMOhUsui1mlz4e5M3bg84d
         wK9Q==
X-Gm-Message-State: AOJu0YzslnGaiuZozXp2MW0ullEcl/ikFn5iWKwHlkyyIMcKJcWPhhLx
	IYFxOmpD117XP39inJLNEX6HFDvu2X2yt+oAkAYHx9uk13wRmROE7ZU3YJd+yBGT8/SH41ZfACk
	EVAU2aGiONCR59sGZ8Q==
X-Google-Smtp-Source: AGHT+IGghJ9+3keDGR7fK+jRC01bAljLd67PjSrmcsbteVdOQh53h1FC3/LFWVU+Yt2UpUqgfV6D+Z6PjkYrPJg1
X-Received: from wmbep11.prod.google.com ([2002:a05:600c:840b:b0:439:8e38:3081])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:47c9:0:b0:38f:31fe:6d23 with SMTP id ffacd0b85a97d-38f6e967ed3mr10983617f8f.23.1740399344814;
 Mon, 24 Feb 2025 04:15:44 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:52 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-11-vdonnefort@google.com>
Subject: [PATCH 10/11] KVM: arm64: Add support for hyp events
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Following the introduction of hyp tracing for pKVM, add the ability to
describe and emit events into the hypervisor ring-buffers.

Hypervisor events are declared into kvm_hypevents.h and can be called
with trace_<event_name>() in a similar fashion to the kernel tracefs
events.

hyp_enter and hyp_exit events are provided as an example.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 74f10847a55e..afeb983ca97b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -93,6 +93,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_enable_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/include/asm/kvm_define_hypevents.h
new file mode 100644
index 000000000000..cda7dc27dba7
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_define_hypevents.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/trace_events.h>
+
+#include <asm/kvm_hyptrace.h>
+#include <asm/kvm_hypevents_defs.h>
+
+#ifndef HYP_EVENT_FILE
+# undef __ARM64_KVM_HYPEVENTS_H_
+# define  __HYP_EVENT_FILE <asm/kvm_hypevents.h>
+#else
+# define __HYP_EVENT_FILE __stringify(HYP_EVENT_FILE)
+#endif
+
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)		\
+	HYP_EVENT_FORMAT(__name, __struct);					\
+	static void hyp_event_trace_##__name(struct ht_iterator *iter)		\
+	{									\
+		struct trace_hyp_format_##__name __maybe_unused *__entry =	\
+			(struct trace_hyp_format_##__name *)iter->ent;		\
+		trace_seq_puts(&iter->seq, #__name);				\
+		trace_seq_putc(&iter->seq, ' ');				\
+		trace_seq_printf(&iter->seq, __printk);				\
+		trace_seq_putc(&iter->seq, '\n');				\
+	}
+#define HYP_EVENT_MULTI_READ
+#include __HYP_EVENT_FILE
+
+#undef he_field
+#define he_field(_type, _item)						\
+	{								\
+		.type = #_type, .name = #_item,				\
+		.size = sizeof(_type), .align = __alignof__(_type),	\
+		.is_signed = is_signed_type(_type),			\
+	},
+#undef HYP_EVENT
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)		\
+	static struct trace_event_fields hyp_event_fields_##__name[] = {	\
+		__struct							\
+		{}								\
+	};
+#include __HYP_EVENT_FILE
+
+#undef HYP_EVENT
+#undef HE_PRINTK
+#define __entry REC
+#define HE_PRINTK(fmt, args...) "\"" fmt "\", " __stringify(args)
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)	\
+	static char hyp_event_print_fmt_##__name[] = __printk;		\
+	static bool hyp_event_enabled_##__name;				\
+	struct hyp_event __section("_hyp_events."#__name)		\
+	hyp_event_##__name = {						\
+		.name		= #__name,				\
+		.enabled	= &hyp_event_enabled_##__name,		\
+		.fields		= hyp_event_fields_##__name,		\
+		.print_fmt	= hyp_event_print_fmt_##__name,		\
+		.trace_func	= hyp_event_trace_##__name,		\
+	}
+#include __HYP_EVENT_FILE
+
+#undef HYP_EVENT_MULTI_READ
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
new file mode 100644
index 000000000000..0b98a87a1250
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if !defined(__ARM64_KVM_HYPEVENTS_H_) || defined(HYP_EVENT_MULTI_READ)
+#define __ARM64_KVM_HYPEVENTS_H_
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/trace.h>
+#endif
+
+/*
+ * Hypervisor events definitions.
+ */
+
+HYP_EVENT(hyp_enter,
+	HE_PROTO(void),
+	HE_STRUCT(
+	),
+	HE_ASSIGN(
+	),
+	HE_PRINTK(" ")
+);
+
+HYP_EVENT(hyp_exit,
+	HE_PROTO(void),
+	HE_STRUCT(
+	),
+	HE_ASSIGN(
+	),
+	HE_PRINTK(" ")
+);
+#endif
diff --git a/arch/arm64/include/asm/kvm_hypevents_defs.h b/arch/arm64/include/asm/kvm_hypevents_defs.h
new file mode 100644
index 000000000000..473bf4363d82
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hypevents_defs.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ARM64_KVM_HYPEVENTS_DEFS_H
+#define __ARM64_KVM_HYPEVENTS_DEFS_H
+
+struct hyp_event_id {
+	unsigned short id;
+	void *data;
+};
+
+#define HYP_EVENT_NAME_MAX 32
+
+struct hyp_event {
+	char				name[HYP_EVENT_NAME_MAX];
+	bool				*enabled;
+	char				*print_fmt;
+	struct trace_event_fields	*fields;
+	void (*trace_func)(struct ht_iterator *iter);
+	int				id;
+};
+
+struct hyp_entry_hdr {
+	unsigned short id;
+};
+
+/*
+ * Hyp events definitions common to the hyp and the host
+ */
+#define HYP_EVENT_FORMAT(__name, __struct)		\
+	struct __packed trace_hyp_format_##__name {	\
+		struct hyp_entry_hdr hdr;		\
+		__struct				\
+	}
+
+#define HE_PROTO(args...)	args
+#define HE_STRUCT(args...)	args
+#define HE_ASSIGN(args...)	args
+#define HE_PRINTK(args...)	args
+
+#define he_field(type, item)	type item;
+#endif
diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
index 7da6a248c7fa..7b66bd06537f 100644
--- a/arch/arm64/include/asm/kvm_hyptrace.h
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -4,6 +4,22 @@
 #include <asm/kvm_hyp.h>
 
 #include <linux/ring_buffer.h>
+#include <linux/trace_seq.h>
+#include <linux/workqueue.h>
+
+struct ht_iterator {
+	struct trace_buffer	*trace_buffer;
+	int			cpu;
+	struct hyp_entry_hdr	*ent;
+	unsigned long		lost_events;
+	int			ent_cpu;
+	size_t			ent_size;
+	u64			ts;
+	void			*spare;
+	size_t			copy_leftover;
+	struct trace_seq        seq;
+	struct delayed_work     poll_work;
+};
 
 /*
  * Host donations to the hypervisor to store the struct hyp_buffer_page.
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index ef3a69cc398e..3b8bf8ded48c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -137,6 +137,10 @@ KVM_NVHE_ALIAS(__hyp_bss_start);
 KVM_NVHE_ALIAS(__hyp_bss_end);
 KVM_NVHE_ALIAS(__hyp_rodata_start);
 KVM_NVHE_ALIAS(__hyp_rodata_end);
+#ifdef CONFIG_TRACING
+KVM_NVHE_ALIAS(__hyp_event_ids_start);
+KVM_NVHE_ALIAS(__hyp_event_ids_end);
+#endif
 
 /* pKVM static key */
 KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e73326bd3ff7..14e52049c4e5 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -13,12 +13,23 @@
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
 
+#ifdef CONFIG_TRACING
+#define HYPERVISOR_EVENT_IDS 					\
+	. = ALIGN(PAGE_SIZE);					\
+	__hyp_event_ids_start = .;				\
+	*(HYP_SECTION_NAME(.event_ids))				\
+	__hyp_event_ids_end = .;
+#else
+#define HYPERVISOR_EVENT_IDS
+#endif
+
 #define HYPERVISOR_DATA_SECTIONS				\
 	HYP_SECTION_NAME(.rodata) : {				\
 		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_start = .;				\
 		*(HYP_SECTION_NAME(.data..ro_after_init))	\
 		*(HYP_SECTION_NAME(.rodata))			\
+		HYPERVISOR_EVENT_IDS				\
 		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_end = .;				\
 	}
@@ -201,6 +212,13 @@ SECTIONS
 	ASSERT(SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18,
 	       "Unexpected GOT/PLT entries detected!")
 
+#ifdef CONFIG_TRACING
+	.rodata.hyp_events : {
+		__hyp_events_start = .;
+		*(SORT(_hyp_events.*))
+		__hyp_events_end = .;
+	}
+#endif
 	/* code sections that are never executed via the kernel mapping */
 	.rodata.text : {
 		TRAMP_TEXT
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 865971bb8905..f9e208273031 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,7 +29,7 @@ kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
-kvm-$(CONFIG_TRACING) += hyp_trace.o
+kvm-$(CONFIG_TRACING) += hyp_events.o hyp_trace.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f3951d36b9c1..2f1b869efc80 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2644,6 +2644,8 @@ static int __init init_hyp_mode(void)
 
 	kvm_hyp_init_symbols();
 
+	hyp_trace_init_events();
+
 	if (is_protected_kvm_enabled()) {
 		if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) &&
 		    cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH))
diff --git a/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
new file mode 100644
index 000000000000..4b69d33e4f2d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <asm/kvm_hypevents.h>
+
+#include <linux/arm-smccc.h>
+
+#undef arm_smccc_1_1_smc
+#define arm_smccc_1_1_smc(...)					\
+	do {							\
+		trace_hyp_exit();				\
+		__arm_smccc_1_1(SMCCC_SMC_INST, __VA_ARGS__);	\
+		trace_hyp_enter();				\
+	} while (0)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/define_events.h b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
new file mode 100644
index 000000000000..2298b49cb355
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/define_events.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef HYP_EVENT_FILE
+# define __HYP_EVENT_FILE <asm/kvm_hypevents.h>
+#else
+# define __HYP_EVENT_FILE __stringify(HYP_EVENT_FILE)
+#endif
+
+#undef HYP_EVENT
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)	\
+	atomic_t __ro_after_init __name##_enabled = ATOMIC_INIT(0);	\
+	struct hyp_event_id hyp_event_id_##__name			\
+	__section(".hyp.event_ids."#__name) = {				\
+		.data = (void *)&__name##_enabled,			\
+	}
+
+#define HYP_EVENT_MULTI_READ
+#include __HYP_EVENT_FILE
+#undef HYP_EVENT_MULTI_READ
+
+#undef HYP_EVENT
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 28bbb54b7a0b..1bf9c5e61aee 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -2,6 +2,7 @@
 #ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
 #define __ARM64_KVM_HYP_NVHE_TRACE_H
 #include <asm/kvm_hyptrace.h>
+#include <asm/kvm_hypevents_defs.h>
 
 /* Internal struct exported for hyp-constants.c */
 struct hyp_buffer_page {
@@ -15,6 +16,24 @@ struct hyp_buffer_page {
 #ifdef CONFIG_TRACING
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)		\
+	HYP_EVENT_FORMAT(__name, __struct);					\
+	extern atomic_t __name##_enabled;					\
+	extern struct hyp_event_id hyp_event_id_##__name;			\
+	static __always_inline void trace_##__name(__proto)			\
+	{									\
+		size_t length = sizeof(struct trace_hyp_format_##__name);	\
+		struct trace_hyp_format_##__name *__entry;			\
+										\
+		if (!atomic_read(&__name##_enabled))				\
+			return;							\
+		__entry = tracing_reserve_entry(length);			\
+		if (!__entry)							\
+			return;							\
+		__entry->hdr.id = hyp_event_id_##__name.id;			\
+		__assign							\
+		tracing_commit_entry();						\
+	}
 
 void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
@@ -22,9 +41,12 @@ void __pkvm_teardown_tracing(void);
 int __pkvm_enable_tracing(bool enable);
 int __pkvm_reset_tracing(unsigned int cpu);
 int __pkvm_swap_reader_tracing(unsigned int cpu);
+int __pkvm_enable_event(unsigned short id, bool enable);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
+	static inline void trace_##__name(__proto) {}
 
 static inline
 void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
@@ -33,5 +55,6 @@ static inline void __pkvm_teardown_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
 static inline int __pkvm_reset_tracing(unsigned int cpu) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
+static inline int __pkvm_enable_event(unsigned short id, bool enable)  { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 40f243c44cf5..fc11e47a1e90 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,7 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_TRACING) += clock.o trace.o
+hyp-obj-$(CONFIG_TRACING) += clock.o events.o trace.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
new file mode 100644
index 000000000000..5905b42cb0d0
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/events.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <nvhe/mm.h>
+#include <nvhe/trace.h>
+
+#include <nvhe/define_events.h>
+
+extern struct hyp_event_id __hyp_event_ids_start[];
+extern struct hyp_event_id __hyp_event_ids_end[];
+
+int __pkvm_enable_event(unsigned short id, bool enable)
+{
+	struct hyp_event_id *event_id = __hyp_event_ids_start;
+	atomic_t *enable_key;
+
+	for (; (unsigned long)event_id < (unsigned long)__hyp_event_ids_end;
+	     event_id++) {
+		if (event_id->id != id)
+			continue;
+
+		enable_key = (atomic_t *)event_id->data;
+		enable_key = hyp_fixmap_map(__hyp_pa(enable_key));
+
+		atomic_set(enable_key, enable);
+
+		hyp_fixmap_unmap();
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e433dfab882a..6c740f8dcf82 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -26,10 +26,10 @@
  * the duration and are therefore serialised.
  */
 
-#include <linux/arm-smccc.h>
 #include <linux/arm_ffa.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e2419c97c57d..96dde58f4984 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
@@ -619,6 +620,14 @@ static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_swap_reader_tracing(cpu);
 }
 
+static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned short, id, host_ctxt, 1);
+	DECLARE_REG(bool, enable, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_enable_event(id, enable);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -664,6 +673,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_enable_tracing),
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
+	HANDLE_FUNC(__pkvm_enable_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
@@ -704,7 +714,9 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 
 static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 {
+	trace_hyp_exit();
 	__kvm_hyp_host_forward_smc(host_ctxt);
+	trace_hyp_enter();
 }
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
@@ -728,6 +740,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
+	trace_hyp_enter();
+
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
@@ -742,4 +756,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	default:
 		BUG();
 	}
+
+	trace_hyp_exit();
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index f4562f417d3f..2f9262057bac 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -16,6 +16,12 @@ SECTIONS {
 	HYP_SECTION(.text)
 	HYP_SECTION(.data..ro_after_init)
 	HYP_SECTION(.rodata)
+#ifdef CONFIG_TRACING
+	. = ALIGN(PAGE_SIZE);
+	BEGIN_HYP_SECTION(.event_ids)
+		*(SORT(.hyp.event_ids.*))
+	END_HYP_SECTION
+#endif
 
 	/*
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 9c2ce1e0e99a..00bc2ab94d59 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -6,11 +6,12 @@
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/memory.h>
 #include <nvhe/trap_handler.h>
 
@@ -153,6 +154,7 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(u64, power_state, host_ctxt, 1);
 	DECLARE_REG(unsigned long, pc, host_ctxt, 2);
 	DECLARE_REG(unsigned long, r0, host_ctxt, 3);
+	int ret;
 
 	struct psci_boot_args *boot_args;
 	struct kvm_nvhe_init_params *init_params;
@@ -171,9 +173,11 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	 * Will either return if shallow sleep state, or wake up into the entry
 	 * point if it is a deep sleep state.
 	 */
-	return psci_call(func_id, power_state,
-			 __hyp_pa(&kvm_hyp_cpu_resume),
-			 __hyp_pa(init_params));
+	ret = psci_call(func_id, power_state,
+			__hyp_pa(&kvm_hyp_cpu_resume),
+			__hyp_pa(init_params));
+
+	return ret;
 }
 
 static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
@@ -205,6 +209,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	struct psci_boot_args *boot_args;
 	struct kvm_cpu_context *host_ctxt;
 
+	trace_hyp_enter();
 	host_ctxt = host_data_ptr(host_ctxt);
 
 	if (is_cpu_on)
@@ -218,6 +223,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	if (is_cpu_on)
 		release_boot_args(boot_args);
 
+	trace_hyp_exit();
 	__host_enter(host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef0261..bbe035acda89 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -7,7 +7,6 @@
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -21,6 +20,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
@@ -349,10 +349,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		trace_hyp_exit();
+
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
+		trace_hyp_enter();
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp_events.c b/arch/arm64/kvm/hyp_events.c
new file mode 100644
index 000000000000..ec56a63f3451
--- /dev/null
+++ b/arch/arm64/kvm/hyp_events.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
+ */
+
+#include <linux/tracefs.h>
+
+#include <asm/kvm_host.h>
+#include <asm/kvm_define_hypevents.h>
+#include <asm/setup.h>
+
+#include "hyp_trace.h"
+
+extern struct hyp_event __hyp_events_start[];
+extern struct hyp_event __hyp_events_end[];
+
+/* hyp_event section used by the hypervisor */
+extern struct hyp_event_id __hyp_event_ids_start[];
+extern struct hyp_event_id __hyp_event_ids_end[];
+
+static ssize_t
+hyp_event_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct seq_file *seq_file = (struct seq_file *)filp->private_data;
+	struct hyp_event *evt = (struct hyp_event *)seq_file->private;
+	unsigned short id = evt->id;
+	bool enabling;
+	int ret;
+	char c;
+
+	if (!cnt || cnt > 2)
+		return -EINVAL;
+
+	if (get_user(c, ubuf))
+		return -EFAULT;
+
+	switch (c) {
+	case '1':
+		enabling = true;
+		break;
+	case '0':
+		enabling = false;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (enabling != *evt->enabled) {
+		ret = kvm_call_hyp_nvhe(__pkvm_enable_event, id, enabling);
+		if (ret)
+			return ret;
+	}
+
+	*evt->enabled = enabling;
+
+	return cnt;
+}
+
+static int hyp_event_show(struct seq_file *m, void *v)
+{
+	struct hyp_event *evt = (struct hyp_event *)m->private;
+
+	seq_printf(m, "%d\n", *evt->enabled);
+
+	return 0;
+}
+
+static int hyp_event_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hyp_event_show, inode->i_private);
+}
+
+static const struct file_operations hyp_event_fops = {
+	.open		= hyp_event_open,
+	.write		= hyp_event_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int hyp_event_id_show(struct seq_file *m, void *v)
+{
+	struct hyp_event *evt = (struct hyp_event *)m->private;
+
+	seq_printf(m, "%d\n", evt->id);
+
+	return 0;
+}
+
+static int hyp_event_id_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hyp_event_id_show, inode->i_private);
+}
+
+static const struct file_operations hyp_event_id_fops = {
+	.open = hyp_event_id_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+void hyp_trace_init_event_tracefs(struct dentry *parent)
+{
+	struct hyp_event *event = __hyp_events_start;
+
+	parent = tracefs_create_dir("events", parent);
+	if (!parent) {
+		pr_err("Failed to create tracefs folder for hyp events\n");
+		return;
+	}
+
+	parent = tracefs_create_dir("hypervisor", parent);
+	if (!parent) {
+		pr_err("Failed to create tracefs folder for hyp events\n");
+		return;
+	}
+
+	for (; (unsigned long)event < (unsigned long)__hyp_events_end; event++) {
+		struct dentry *event_dir = tracefs_create_dir(event->name, parent);
+
+		if (!event_dir) {
+			pr_err("Failed to create events/hypervisor/%s\n",
+			       event->name);
+			continue;
+		}
+
+		tracefs_create_file("enable", 0640, event_dir, (void *)event,
+				    &hyp_event_fops);
+		tracefs_create_file("id", 0440, event_dir, (void *)event,
+				    &hyp_event_id_fops);
+	}
+}
+
+struct hyp_event *hyp_trace_find_event(int id)
+{
+	struct hyp_event *event = __hyp_events_start + id;
+
+	if ((unsigned long)event >= (unsigned long)__hyp_events_end)
+		return NULL;
+
+	return event;
+}
+
+/*
+ * Register hyp events and write their id into the hyp section _hyp_event_ids.
+ */
+int hyp_trace_init_events(void)
+{
+	struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
+	struct hyp_event *event = __hyp_events_start;
+	int id = 0;
+
+	/* Events on both sides hypervisor are sorted */
+	for (; (unsigned long)event < (unsigned long)__hyp_events_end;
+		event++, hyp_event_id++, id++)
+		event->id = hyp_event_id->id = id;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 03a6813cbe66..cb63af69c38d 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -6,10 +6,12 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/percpu-defs.h>
+#include <linux/trace_events.h>
 #include <linux/tracefs.h>
 
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyptrace.h>
+#include <asm/kvm_hypevents_defs.h>
 
 #include "hyp_constants.h"
 #include "hyp_trace.h"
@@ -567,6 +569,8 @@ static void ht_print_trace_cpu(struct ht_iterator *iter)
 
 static int ht_print_trace_fmt(struct ht_iterator *iter)
 {
+	struct hyp_event *e;
+
 	if (iter->lost_events)
 		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
 				 iter->ent_cpu, iter->lost_events);
@@ -574,6 +578,12 @@ static int ht_print_trace_fmt(struct ht_iterator *iter)
 	ht_print_trace_cpu(iter);
 	ht_print_trace_time(iter);
 
+	e = hyp_trace_find_event(iter->ent->id);
+	if (e)
+		e->trace_func(iter);
+	else
+		trace_seq_printf(&iter->seq, "Unknown event id %d\n", iter->ent->id);
+
 	return trace_seq_has_overflowed(&iter->seq) ? -EOVERFLOW : 0;
 };
 
@@ -939,5 +949,7 @@ int hyp_trace_init_tracefs(void)
 				    (void *)cpu, &hyp_trace_fops);
 	}
 
+	hyp_trace_init_event_tracefs(root);
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp_trace.h b/arch/arm64/kvm/hyp_trace.h
index 14fc06c625a6..3ac648415bf9 100644
--- a/arch/arm64/kvm/hyp_trace.h
+++ b/arch/arm64/kvm/hyp_trace.h
@@ -3,26 +3,13 @@
 #ifndef __ARM64_KVM_HYP_TRACE_H__
 #define __ARM64_KVM_HYP_TRACE_H__
 
-#include <linux/trace_seq.h>
-#include <linux/workqueue.h>
-
-struct ht_iterator {
-	struct trace_buffer	*trace_buffer;
-	int			cpu;
-	struct hyp_entry_hdr	*ent;
-	unsigned long		lost_events;
-	int			ent_cpu;
-	size_t			ent_size;
-	u64			ts;
-	void			*spare;
-	size_t			copy_leftover;
-	struct trace_seq	seq;
-	struct delayed_work	poll_work;
-};
-
 #ifdef CONFIG_TRACING
 int hyp_trace_init_tracefs(void);
+int hyp_trace_init_events(void);
+struct hyp_event *hyp_trace_find_event(int id);
+void hyp_trace_init_event_tracefs(struct dentry *parent);
 #else
 static inline int hyp_trace_init_tracefs(void) { return 0; }
+static inline int hyp_trace_init_events(void) { return 0; }
 #endif
 #endif
-- 
2.48.1.601.g30ceb7b040-goog

