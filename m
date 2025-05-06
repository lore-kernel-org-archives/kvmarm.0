Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9070228B3F5
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550161; cv=none; b=JP2w3GxVxnyJpo3znTpJvE3vZeOzhPs+9FNPmIhbcFVuJWp8RiNR6wKcqYmIXwCWRTgy/329XSz4/Qr8489RQUB0567kw89/zwoh38xmIbqTHFJXXu8/PGnjaydgoqIFZ/JiTr1jBQzVrx2+h9LnQ4Rrw1CxZ4YYhdKd7YNY4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550161; c=relaxed/simple;
	bh=ALx/PW7FLHSIjTfXPexouR+n5HBrP9zgi0897V52lu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A+HPwA3COgZizzOGhBESUGY26/e1l3CLaeCjAhh66POucIgWNYaFktUCo4qP9KbI71X/2kCOl6n4jyF0PLfJz+dIic/DbKPp0WTXSshXKmLtFBTATk4364cQwHBKl9tAZQ4cNFsjrWQS32p1dP41Drph4C7G3BomBTtScFy/TRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C/sZC3E7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C/sZC3E7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d00017e9dso31817035e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550158; x=1747154958; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AhqBcSQ/v7yG7x6b74IrhoArAfr1M4atT8I+RiFMj5c=;
        b=C/sZC3E7LIl7vrKq/j7kHTOE9jaxmxSqMf+8PX59Syew0gr2hnSacMn71qVPdMv9bt
         JaBl0/GcV0g59wZm5ynwSIuDa+MtCnfKDoyW7zol/vc8WhYdQaCbdz8r5QyvdPppOtLp
         qQUv7aei9vxMYjfLam9e3Ivigwt2/bF+xjlzng8vlszC02pdziYfooGbVlP3zNFMvOEM
         cZSfPEHuQKIY5k/rzDMAHTo+Y3NGqAdt5Rj2HGMpMnzxiAPFHL8f6EVwa8ZovR0rMfrX
         FEEW+jVeFakLfrMXajoMrfIjAfdBj/WRKI2UdTQBJx0hGMUTwPmL0+N2AtS99WbFFyii
         3+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550158; x=1747154958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhqBcSQ/v7yG7x6b74IrhoArAfr1M4atT8I+RiFMj5c=;
        b=rDCqiFPYpxizeFPogjoZbU0dExIdPIOG3bASjf7zDevXLHzJ1Fes1PSGrh0m841NzL
         YQ6ICw4SyOLoQf5In33rdReP5H6NTbOTpWtlXRKZxXuCjDy6g6WZGHgN9Sj3MBuOkHmg
         /Yd31NbV9JUZOFHzhTrNXAupdHEs2AooTJUqsF4oS6Do979G7wrdR3Devjj565ESBs/G
         H/23rUCclGEGtUAHlEx3HG8d+l31MBJa/84mnb9OpUQ/ph+AXEXFtVz/6yMa9EJJHnBG
         /mdGGfleNounxEu/fNSfpS3+Js28EYeXYw8ocwd61AB0VHEtF6YKDxXJAUET1x772j1f
         sXdA==
X-Gm-Message-State: AOJu0Yy6TyCP+H6HBbk3bmz6zMbMJ+vGcrClwCKFUXYeUvDseOLP3EPi
	UF5GOF5gKmYPk6ntnOQSdIwH5yBAzRm/287SkKhW6sbUSeMztlNnUCoq4BHHqAGxz4IR+o/ZPmg
	G0FHLaoanjBzLClw4Jw==
X-Google-Smtp-Source: AGHT+IHVPnnFyhsuDgD/edqz8SzmkFgOGjzAl9qJEZTkau5UqBVfPHTuapj0/9ixNRRppMrePMhn5eJefdgB1SPd
X-Received: from wmbhh5.prod.google.com ([2002:a05:600c:5305:b0:43b:b74b:9350])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ec9:b0:43d:7588:6687 with SMTP id 5b1f17b1804b1-441d0fccd16mr32642725e9.12.1746550158258;
 Tue, 06 May 2025 09:49:18 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:17 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-22-vdonnefort@google.com>
Subject: [PATCH v4 21/24] KVM: arm64: Add event support to the pKVM hyp and
 trace remote
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow the creation of hypervisor and trace remote events with a single
macro HYP_EVENT(). That macro expands in the kernel side to add all
the required declarations (based on REMOTE_EVENT()) as well as in the
hypervisor side to create the trace_<event>() function.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c40820a4b049..79019e11f529 100644
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
index 000000000000..0ef5a9eefcbe
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_define_hypevents.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef HYP_EVENT_FILE
+# undef __ARM64_KVM_HYPEVENTS_H_
+# define REMOTE_EVENT_INCLUDE_FILE arch/arm64/include/asm/kvm_hypevents.h
+#else
+# define REMOTE_EVENT_INCLUDE_FILE HYP_EVENT_FILE
+#endif
+
+#define REMOTE_EVENT_SECTION "_hyp_events"
+
+#define HE_STRUCT(__args)		__args
+#define HE_PRINTK(__args...)		__args
+#define he_field			re_field
+
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk) \
+	REMOTE_EVENT(__name, 0, RE_STRUCT(__struct), RE_PRINTK(__printk))
+
+#define HYP_EVENT_MULTI_READ
+
+#include <trace/define_remote_events.h>
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
new file mode 100644
index 000000000000..d6e033c96c52
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if !defined(__ARM64_KVM_HYPEVENTS_H_) || defined(HYP_EVENT_MULTI_READ)
+#define __ARM64_KVM_HYPEVENTS_H_
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/trace.h>
+#endif
+
+#endif
diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
index 9c30a479bc36..d6e0953a07d6 100644
--- a/arch/arm64/include/asm/kvm_hyptrace.h
+++ b/arch/arm64/include/asm/kvm_hyptrace.h
@@ -10,4 +10,17 @@ struct hyp_trace_desc {
 	struct trace_buffer_desc	trace_buffer_desc;
 
 };
+
+struct hyp_event_id {
+	unsigned short	id;
+	void		*data;
+};
+
+extern struct remote_event __hyp_events_start[];
+extern struct remote_event __hyp_events_end[];
+
+/* hyp_event section used by the hypervisor */
+extern struct hyp_event_id __hyp_event_ids_start[];
+extern struct hyp_event_id __hyp_event_ids_end[];
+
 #endif
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 9c5345f1ab66..7466630ecb10 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -135,6 +135,10 @@ KVM_NVHE_ALIAS(__hyp_data_start);
 KVM_NVHE_ALIAS(__hyp_data_end);
 KVM_NVHE_ALIAS(__hyp_rodata_start);
 KVM_NVHE_ALIAS(__hyp_rodata_end);
+#ifdef CONFIG_PKVM_TRACING
+KVM_NVHE_ALIAS(__hyp_event_ids_start);
+KVM_NVHE_ALIAS(__hyp_event_ids_end);
+#endif
 
 /* pKVM static key */
 KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7c770053f072..c9baff9d6f3a 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -13,12 +13,23 @@
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
 
+#ifdef CONFIG_PKVM_TRACING
+#define HYPERVISOR_EVENT_IDS 					\
+	. = ALIGN(PAGE_SIZE);					\
+	__hyp_event_ids_start = .;				\
+	*(HYP_SECTION_NAME(.event_ids))				\
+	__hyp_event_ids_end = .;
+#else
+#define HYPERVISOR_EVENT_IDS
+#endif
+
 #define HYPERVISOR_RODATA_SECTIONS				\
 	HYP_SECTION_NAME(.rodata) : {				\
 		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_start = .;				\
 		*(HYP_SECTION_NAME(.data..ro_after_init))	\
 		*(HYP_SECTION_NAME(.rodata))			\
+		HYPERVISOR_EVENT_IDS				\
 		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_end = .;				\
 	}
@@ -307,6 +318,13 @@ SECTIONS
 
 	HYPERVISOR_DATA_SECTION
 
+#ifdef CONFIG_PKVM_TRACING
+	.data.hyp_events : {
+		__hyp_events_start = .;
+		*(SORT(_hyp_events.*))
+		__hyp_events_end = .;
+	}
+#endif
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
 	 * cache lines to be invalidated, discarding up to a Cache Writeback
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
index 0d2732f0d406..09abbc8113ca 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -1,21 +1,51 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
 #define __ARM64_KVM_HYP_NVHE_TRACE_H
+
+#include <linux/trace_remote_event.h>
+
 #include <asm/kvm_hyptrace.h>
 
 #ifdef CONFIG_PKVM_TRACING
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
+#define HE_PROTO(__args...)	__args
+#define HE_ASSIGN(__args...)	__args
+#define HE_STRUCT		RE_STRUCT
+#define he_field		re_field
+
+#define HYP_EVENT(__name, __proto, __struct, __assign, __printk)		\
+	REMOTE_EVENT_FORMAT(__name, __struct);					\
+	extern atomic_t __name##_enabled;					\
+	extern struct hyp_event_id hyp_event_id_##__name;			\
+	static __always_inline void trace_##__name(__proto)			\
+	{									\
+		struct remote_event_format_##__name *__entry;			\
+		size_t length = sizeof(*__entry);				\
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
+
 void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
 void __pkvm_unload_tracing(void);
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
@@ -24,5 +54,6 @@ static inline void __pkvm_unload_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
 static inline int __pkvm_reset_tracing(unsigned int cpu) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
+static inline int __pkvm_enable_event(unsigned short id, bool enable)  { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 6d92f58aea7e..1467c9f28558 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,7 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o trace.o ../../../../../kernel/trace/simple_ring_buffer.o
+hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o trace.o ../../../../../kernel/trace/simple_ring_buffer.o events.o
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
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 65260bfd33ac..3d36be6d94ca 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -619,6 +619,14 @@ static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -664,6 +672,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_enable_tracing),
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
+	HANDLE_FUNC(__pkvm_enable_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index d724f6d69302..a68411bf4bef 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -16,6 +16,12 @@ SECTIONS {
 	HYP_SECTION(.text)
 	HYP_SECTION(.data..ro_after_init)
 	HYP_SECTION(.rodata)
+#ifdef CONFIG_PKVM_TRACING
+	. = ALIGN(PAGE_SIZE);
+	BEGIN_HYP_SECTION(.event_ids)
+		*(SORT(.hyp.event_ids.*))
+	END_HYP_SECTION
+#endif
 
 	/*
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index c7ad36212a7d..1a4313362aa0 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -306,7 +306,7 @@ static int hyp_trace_reset(unsigned int cpu, void *priv)
 
 static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
 {
-	return 0;
+	return kvm_call_hyp_nvhe(__pkvm_enable_event, id, enable);
 }
 
 static int hyp_trace_clock_show(struct seq_file *m, void *v)
@@ -333,10 +333,27 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 	.enable_event		= hyp_trace_enable_event,
 };
 
+#include <asm/kvm_define_hypevents.h>
+
+static void hyp_trace_init_events(void)
+{
+	struct hyp_event_id *hyp_event_id = __hyp_event_ids_start;
+	struct remote_event *event = __hyp_events_start;
+	int id = 0;
+
+	/* Events on both sides hypervisor are sorted */
+	for (; (unsigned long)event < (unsigned long)__hyp_events_end;
+		event++, hyp_event_id++, id++)
+		event->id = hyp_event_id->id = id;
+}
+
 int hyp_trace_init(void)
 {
 	if (!is_protected_kvm_enabled())
 		return 0;
 
-	return trace_remote_register("hypervisor", &trace_remote_callbacks, &trace_buffer, NULL, 0);
+	hyp_trace_init_events();
+
+	return trace_remote_register("hypervisor", &trace_remote_callbacks, &trace_buffer,
+				     __hyp_events_start, __hyp_events_end - __hyp_events_start);
 }
-- 
2.49.0.967.g6a0df3ecc3-goog

