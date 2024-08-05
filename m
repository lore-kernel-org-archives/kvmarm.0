Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6CA15EFC4
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879240; cv=none; b=iw7FDrqM3cO9Y0T9CiEsUQ33MGY5oxcgS4lvYoKTU4FO90AgeMM10QV2TqHO1EpPrSIinkp4TauzkmBxym+G8uUOGVpue5k7Q8s9cMKwQfeb2xF4VNLPYcgZO74oVOxElzKsZqzvIUdcjniiMWS4KtUvoQBrpifNXWnDNMuYsi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879240; c=relaxed/simple;
	bh=IN3B2V880/ZJW7u3jVyTnliSJdGi4G6toeJ5dks8Glk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vj645XnW4mNFTXKVLpbi1+ch3WQUaqEYIIzgGYRWuJDLUdXKs9ai3G3PiYd27aK0Euj0nvWXykyfX+dEymG2ugqgJFR6fks8yj/iKc0NjiO9uDKMLv8PgfC4wzNP16E48jmxitq+pbOFoU+JueOAtmkuWNR0EmbNX6B3/reBwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AR5vgXzk; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AR5vgXzk"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664bc570740so98705537b3.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879237; x=1723484037; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGFlb+WnpacNcfc/xmCY38qZBbNiI25zr5BPjHDlzXY=;
        b=AR5vgXzk02gX+8/Jycyn37wQ+6X6Xr3aQdYzmmSTRbZ0703k4dRuwJtvpTKkIQfQy3
         YZNHTqx2OGvFviqTd2xtWaEB/TOEWvz/E39cmpCuGV7S+bh2pKBjGTPIFnmQ/lsWWVzK
         0aFOB65o+uhdLIVA8FwZ70Y+zCrvSRZDMyW7fFw/HDeWOTHAbd+VZapy/64CKgw/xUQb
         Gjx+noQM1OOP6MK3Zpdqjy655ExgZ8ADXLazBzZpg4/k0qrz+/KclkruX2m9sj4NtQM4
         TidvvD2Ywtrs6sp/xMxLLyv554EYkK/Nm7TsrDsAmiJgV8DOX0Rx2wh8W6W1zAxWw8eu
         6Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879237; x=1723484037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGFlb+WnpacNcfc/xmCY38qZBbNiI25zr5BPjHDlzXY=;
        b=fZ8MIe3eruTFV0zmsOGCahwCVGJrna9ysTzB+EeFmN6xvRfUf158r/4FJv01BcSbtC
         q8P6OnCbijCpaZ5IdiFMtd4J86Et0anLZC9cuNFbap+8x9iWNF9Zb7DRXcIFsK7/lcN/
         lfsjcY5uRfWTuqjmhUOAGcwjMWVTIPCyAkILo30cOxV4YhAQZ8wlS9A8O4jwYQ+dqKWI
         HYAZrNR0XISmFPLq8MhLrLN31OpWIt0fo/MT4HWdd6eZdl8TCuoO1ioseVz7ngSHaoTf
         WF1pJbA0uAU6/TCJ/Z8MIRETzSCBEetStjItWD0LGmUXjGUDOoyEezF8Lpi10zbzznRz
         enkg==
X-Gm-Message-State: AOJu0YyKUItAxvUNakm9LohsmL91qcQ7+TJEwPvUaNouPHyillTdhMt/
	c0Nd5mKmo/bQiNN+fTCrYeLLMktX3FiLfPTAmJhu1Dc7rNurg5A00yvgqIY1PVkxhMAz6C50KEK
	0H/IH98dcYgET8zSD2w==
X-Google-Smtp-Source: AGHT+IHzyz3epavmZJ83Ld+YuJpUJCJAUpPhRQQz3c1gncg3uWH2Hut7VZtzV0YMkPg3OJ6KJwWvz4CX/ZB8jhu2
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a5b:391:0:b0:e0b:df3f:7def with SMTP id
 3f1490d57ef6-e0bdf3f80c1mr46138276.2.1722879237281; Mon, 05 Aug 2024 10:33:57
 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:33 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-11-vdonnefort@google.com>
Subject: [RFC PATCH 10/11] KVM: arm64: Add support for hyp events
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Following the introduction of hyp tracing for pKVM, add the ability to
describe and emit events into the hypervisor ring-buffers.

Hypervisor events are declared into kvm_hypevents.h and can be called
with trace_<event_name>() in a similar fashion to the kernel tracefs
events.

hyp_enter and hyp_exit events are provided as an example.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d549d7d491c3..1a576ef28b7f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -83,6 +83,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_enable_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/include/asm/kvm_define_hypevents.h
new file mode 100644
index 000000000000..efa2c2cb3ef2
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_define_hypevents.h
@@ -0,0 +1,60 @@
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
+	struct hyp_event __section("_hyp_events") hyp_event_##__name = {\
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
index b371776da0fe..b4fca6986546 100644
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
index 8f5422ed1b75..e60754cdbf33 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -134,6 +134,10 @@ KVM_NVHE_ALIAS(__hyp_bss_start);
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
index 55a8e310ea12..96986c1f852c 100644
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
@@ -200,6 +211,13 @@ SECTIONS
 	ASSERT(SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18,
 	       "Unexpected GOT/PLT entries detected!")
 
+#ifdef CONFIG_TRACING
+	.rodata.hyp_events : {
+		__hyp_events_start = .;
+		*(_hyp_events)
+		__hyp_events_end = .;
+	}
+#endif
 	/* code sections that are never executed via the kernel mapping */
 	.rodata.text : {
 		TRAMP_TEXT
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 414a298a61f7..5b34c6a261c0 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,7 +25,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 
-kvm-$(CONFIG_TRACING) += hyp_trace.o
+kvm-$(CONFIG_TRACING) += hyp_events.o hyp_trace.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2242862e3223..fdee8f669def 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2661,6 +2661,8 @@ static int __init init_hyp_mode(void)
 
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
index 000000000000..3947c1e47ef4
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
+	__section(".hyp.event_ids") = {					\
+		.data = (void *)&__name##_enabled,			\
+	}
+
+#define HYP_EVENT_MULTI_READ
+#include __HYP_EVENT_FILE
+#undef HYP_EVENT_MULTI_READ
+
+#undef HYP_EVENT
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 29e0c7a6c867..d947ac2ebdf8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -2,6 +2,7 @@
 #ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
 #define __ARM64_KVM_HYP_NVHE_TRACE_H
 #include <asm/kvm_hyptrace.h>
+#include <asm/kvm_hypevents_defs.h>
 
 /* Internal struct that needs export for hyp-constants.c */
 struct hyp_buffer_page {
@@ -15,18 +16,40 @@ struct hyp_buffer_page {
 #ifdef CONFIG_TRACING
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)		\
+	HYP_EVENT_FORMAT(__name, __struct);					\
+	extern atomic_t __name##_enabled;					\
+	extern unsigned short hyp_event_id_##__name;				\
+	static inline void trace_##__name(__proto)				\
+	{									\
+		size_t length = sizeof(struct trace_hyp_format_##__name);	\
+		struct trace_hyp_format_##__name *__entry;			\
+										\
+		if (!atomic_read(&__name##_enabled))				\
+			return;							\
+		__entry = tracing_reserve_entry(length);			\
+		if (!__entry)							\
+			return;							\
+		__entry->hdr.id = hyp_event_id_##__name;			\
+		__assign							\
+		tracing_commit_entry();						\
+	}
 
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
 void __pkvm_teardown_tracing(void);
 int __pkvm_enable_tracing(bool enable);
 int __pkvm_swap_reader_tracing(int cpu);
+int __pkvm_enable_event(unsigned short id, bool enable);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)      \
+	static inline void trace_##__name(__proto) {}
 
 static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __pkvm_teardown_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(int cpu) { return -ENODEV; }
+static inline int __pkvm_enable_event(unsigned short id, bool enable)  { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1a5367c13407..20a36dd3a7d0 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_TRACING) += clock.o trace.o
+hyp-obj-$(CONFIG_TRACING) += clock.o events.o trace.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
new file mode 100644
index 000000000000..ad214f3f698c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/events.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
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
index e715c157c2c4..d17ef3771e6a 100644
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
index d3d01c02d35c..f6119dbdcce1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -11,6 +11,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
@@ -403,6 +404,14 @@ static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -439,6 +448,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_teardown_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
+	HANDLE_FUNC(__pkvm_enable_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
@@ -479,7 +489,9 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 
 static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 {
+	trace_hyp_exit();
 	__kvm_hyp_host_forward_smc(host_ctxt);
+	trace_hyp_enter();
 }
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
@@ -503,6 +515,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
+	trace_hyp_enter();
+
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
@@ -522,4 +536,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	default:
 		BUG();
 	}
+
+	trace_hyp_exit();
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index f4562f417d3f..9d0ce68f1ced 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -16,6 +16,10 @@ SECTIONS {
 	HYP_SECTION(.text)
 	HYP_SECTION(.data..ro_after_init)
 	HYP_SECTION(.rodata)
+#ifdef CONFIG_TRACING
+	. = ALIGN(PAGE_SIZE);
+	HYP_SECTION(.event_ids)
+#endif
 
 	/*
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index dfe8fe0f7eaf..1315fb6df3a3 100644
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
index 6af179c6356d..572313a5a448 100644
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
@@ -328,10 +328,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
index 000000000000..5ea468b5671f
--- /dev/null
+++ b/arch/arm64/kvm/hyp_events.c
@@ -0,0 +1,164 @@
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
+	parent = tracefs_create_dir("hyp", parent);
+	if (!parent) {
+		pr_err("Failed to create tracefs folder for hyp events\n");
+		return;
+	}
+
+	for (; (unsigned long)event < (unsigned long)__hyp_events_end; event++) {
+		struct dentry *event_dir = tracefs_create_dir(event->name, parent);
+
+		if (!event_dir) {
+			pr_err("Failed to create events/hyp/%s\n", event->name);
+			continue;
+		}
+
+		tracefs_create_file("enable", 0700, event_dir, (void *)event,
+				    &hyp_event_fops);
+		tracefs_create_file("id", 0400, event_dir, (void *)event,
+				    &hyp_event_id_fops);
+	}
+}
+
+struct hyp_event *hyp_trace_find_event(int id)
+{
+	struct hyp_event *event = __hyp_events_start + id;
+
+	if ((unsigned long)event > (unsigned long)__hyp_events_end)
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
+	for (; (unsigned long)event < (unsigned long)__hyp_events_end;
+		event++, hyp_event_id++, id++) {
+
+		/*
+		 * Both the host and the hypervisor relies on the same hyp event
+		 * declarations from kvm_hypevents.h. We have then a 1:1
+		 * mapping.
+		 */
+		event->id = hyp_event_id->id = id;
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 36c120aeabc0..d3a14ac8b3dd 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -7,10 +7,12 @@
 #include <linux/arm-smccc.h>
 #include <linux/list.h>
 #include <linux/percpu-defs.h>
+#include <linux/trace_events.h>
 #include <linux/tracefs.h>
 
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyptrace.h>
+#include <asm/kvm_hypevents_defs.h>
 
 #include "hyp_constants.h"
 #include "hyp_trace.h"
@@ -460,6 +462,8 @@ static void ht_print_trace_cpu(struct ht_iterator *iter)
 
 static int ht_print_trace_fmt(struct ht_iterator *iter)
 {
+	struct hyp_event *e;
+
 	if (iter->lost_events)
 		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
 				 iter->ent_cpu, iter->lost_events);
@@ -467,6 +471,12 @@ static int ht_print_trace_fmt(struct ht_iterator *iter)
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
 
@@ -807,5 +817,7 @@ int hyp_trace_init_tracefs(void)
 				    (void *)cpu, &hyp_trace_pipe_fops);
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
2.46.0.rc2.264.g509ed76dc8-goog

