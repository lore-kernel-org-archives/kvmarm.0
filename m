Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2AF1FDE39
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498766; cv=none; b=fYvUqzzRTWq6Iw44VQEHC0/H2LbaznWjZR7Emp+p40Pw7JVAuBYwHTym5rhN+vRsSrvwcV4N6qL87zxtsT/EZse2+0al+T5OjMOE7ylfGPesmw3MxG8cY5AwY/FTYPaR5MZMXOYjxVb8rv98f6PB5Vs7O4vRFvP8+XW91r1VvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498766; c=relaxed/simple;
	bh=l6PMwVLOHepg5l9uIxnW/ICyzU/c1ZpmTcLy250cgHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LhyBF58dN7jCz4ygH5WCsENT0wVejbC7hNu3Nk9l/DGoJT+Xyrq6qzBM7HfeuknEZmmEatcpLAsQLu1QjaO+DBBUMsDgV94mTjfIx4unpABc12UYwxiMOkz56vAN0QmKo2Cbp+DM/cKuaamG28UmqnjTQf4cdnA++lu3zbLqZ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jed2BiVR; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jed2BiVR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so1399649f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498760; x=1760103560; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NBH7mX8hqUWuMd8ft0BAB55Akh3ZIkAjzkYag/eDdtI=;
        b=jed2BiVR3NPFp8dw/JEyNuUu8TIP7VgvFL5llRo6X5I9nFNkhRMG/CPAyal98ib0Ke
         jU2nOPoDHBczKLplTIB0aa7DEJF3YFUdcYfcRTTKxIHtL0zD12/Bs8nfj3x24oL85+eh
         at8kjKip7BhuaYbfuB/WWVp2ZKB3+Oap/EB7N9Lx6eIxbC0em5E1EaKlzaPMe+Sn20s7
         GZ5v53MJwy8NsapHiJBvgme6GAzHmIwsoTL1CK1NRtdmagHywr163lNF2nCP+uffUCmI
         Np+ast/u9wJ3mHISqIa4SiB3VxEC17yPMoRTkkZhe2ashAGAKOFnmXeLnv0AAKwAAnih
         neDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498760; x=1760103560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBH7mX8hqUWuMd8ft0BAB55Akh3ZIkAjzkYag/eDdtI=;
        b=RRD3+BAPFgPZd+zOxOD+Y6JFWvlwZUY6o/6isqNMRANSdERktbZD0BVLg9i7VmehMH
         MkFapG7hpfzDr9X2BMHuZtriRFr3Ky14+e1MAcPdzum4Rz+DIp/clR4IO2I6oZHQ3Fga
         tCTRhU8ilhklzuqyEneATAK6cz8RewqYnCqaTORXLqcf6Shm4Z8M0iZap4z8El4eI4fl
         DF7UDGjSrfPx8kVTASYyYAIIPnxNRNv1u/bCuWFsfflk3FN7COaEwAQhuy6scwTLVvHQ
         ZSBEE534Jyk2SoUEfHuMHxL3OeIsW6fSKge8q4lCyAnig22MVZb81t3uQZXflc5a8xTY
         pwVw==
X-Gm-Message-State: AOJu0YzEdsqgdPMGD5v2jHwQd2ME6hxXHk2GlYl+sEp5Zp8BBCM9QdQX
	Cm/Rvj2bmkD+J+YUqoHxPH38l3IJn13ep3dg2B058P4OciXXWHnKgOXh9e3JNpfR+xTCr5eJhHV
	gwJnBsUoIlh7HbD+RIog74A==
X-Google-Smtp-Source: AGHT+IH/PJgRLPULsUjcfYURSxxv3/VeyYFrYwGc8MO8Sqvzd3hkzkzqfAS/t0Jovus1S0w8fOfR71dCwBB56+qE
X-Received: from wmoo17.prod.google.com ([2002:a05:600d:111:b0:46e:54f3:6f51])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:25ef:b0:3ee:1563:a78b with SMTP id ffacd0b85a97d-4256714be13mr2090567f8f.20.1759498760357;
 Fri, 03 Oct 2025 06:39:20 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:22 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-26-vdonnefort@google.com>
Subject: [PATCH v7 25/28] KVM: arm64: Add event support to the pKVM hyp and
 trace remote
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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
index 714b0b5ec5ac..c1dbf0d317db 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -134,6 +134,10 @@ KVM_NVHE_ALIAS(__hyp_data_start);
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
index ad6133b89e7a..0e201a3c8de5 100644
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
index 0d2732f0d406..f7b286e92853 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -1,21 +1,52 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
 #define __ARM64_KVM_HYP_NVHE_TRACE_H
+
+#include <linux/trace_remote_event.h>
+
 #include <asm/kvm_hyptrace.h>
 
+#define HE_PROTO(__args...)	__args
+
 #ifdef CONFIG_PKVM_TRACING
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
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
@@ -24,5 +55,6 @@ static inline void __pkvm_unload_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
 static inline int __pkvm_reset_tracing(unsigned int cpu) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
+static inline int __pkvm_enable_event(unsigned short id, bool enable)  { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index e640f12808f7..09bb8dfa7ca2 100644
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
index a7c5e9fc27a0..aebed41f7de7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -622,6 +622,14 @@ static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -667,6 +675,7 @@ static const hcall_t host_hcall[] = {
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
index 1062b4310f8c..73539f5b5e42 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -307,7 +307,7 @@ static int hyp_trace_reset(unsigned int cpu, void *priv)
 
 static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
 {
-	return 0;
+	return kvm_call_hyp_nvhe(__pkvm_enable_event, id, enable);
 }
 
 static int hyp_trace_clock_show(struct seq_file *m, void *v)
@@ -334,10 +334,27 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
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
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index 1bc9c9a5197f..dc6bc387ebca 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1037,7 +1037,7 @@ static int remote_event_format_show(struct seq_file *s, void *unused)
 	while (field->name) {
 		seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%u;\tsigned:%d;\n",
 			   field->type, field->name, offset, field->size,
-			   !field->is_signed);
+			   field->is_signed);
 		offset += field->size;
 		field++;
 	}
@@ -1068,7 +1068,7 @@ static int remote_event_callback(const char *name, umode_t *mode, void **data,
 
 	if (!strcmp(name, "format")) {
 		*mode = TRACEFS_MODE_READ;
-		*fops = &remote_event_id_fops;
+		*fops = &remote_event_format_fops;
 		return 1;
 	}
 
-- 
2.51.0.618.g983fd99d29-goog

