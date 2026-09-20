Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB87C471D16
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933097; cv=none; b=Sqm09BENr5hXIeWx8uWX/J7iFF5qi9+st7oEqnSf+HdTlu8wAl9A0QgqoQfN6UKloh4vBgX+okpr6KQNMsAzIEyv2C+TozTsnx+hp1V7jkz4gBMQGGIdGOiNg1DlAE8+UFQLwazGjjDDlRNDIflVmXLxBT0IXjDiIOUB426hGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933097; c=relaxed/simple;
	bh=02+Q42Ze6xEkQFVgi4gpBhdoirv+ojduq0xSuruKGDs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyOovtcF4vHYO2BcvSZ9gr2zGhuCZVkIHc/lE1qsMHWQC1ZlciODW58uZJgXADT63O+qPFbR/hsR0LPpwpuhM1uHllMQYV2kK6MjJKtG9DT2R1bu1jtN+PsAmpTetQZO/PoAi+LDWAVy8m0q8s9n3QkR8sKGro2a4HMOqwJYg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=LJbJR2nc; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="LJbJR2nc"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-89666ee9b3bso13449807b3.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933094; x=1790537894; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jYn4Ytq2YXSifYxA9CPS6d/oLI/kiEdGEMZqJLYvWho=;
        b=LJbJR2nc7DKJ9WJDK5jNAHyOEE/ptVVD8DOTU9wK9kZ27UrDG6/D300cf2P2eegVpu
         UDtME9LFycvAFMCfoTTpqwJZu0x9ns/TBsSHhZ7Qd/4dUvoBnlPsnCqFnAfKQqiC346y
         BIx+VdzLf1BLX8EqsEvfK0RXUa+5yIkm252r7bW3CocjGpCmymRw0vsfnc1uucsJJ44R
         i6dk222OWZ/w48vyI7dqTsQ5GBJuenUEwHT9jQc2e1Ecx1/EeYXf0IGThXt7Pt3hbqTo
         TkntFjdKtZiFbjXKmViIHR6e+L5UcvJSzDEhMOO3paY5Z2N9miAQv5r5NAzKqg+2vrH/
         Kt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933094; x=1790537894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jYn4Ytq2YXSifYxA9CPS6d/oLI/kiEdGEMZqJLYvWho=;
        b=TWWvsCntErzs+3Ni+8x3ZYO1D6Sig1oY71LVQ4zXKBsDNGOXlwFV610JRfrsW/j5AO
         p6W1UJ52f2rpv/nFIJJfu9W4VjgBWXoVwd9Lwp7eOZ5JhODt434imO/4TnseZAJI1US/
         SbHl5uk5+sIBvGW6pZzDHet8cVIKoKwV7KXpkQvOyVZ469XXfM14GhCwbWtAgTeTuAMB
         hmMheE6kOHT36ZyDQGe9//GnPvQkl3E5t5VOp+uKBMoNOe3MnVyofKU4GjPGYOETG49Y
         YvNg00dtiXFO2v0rra8Lr5M1ZU+UapIPYa39MRMq17G76iapsSJUfVKHVRVomLSpatTX
         TR2Q==
X-Forwarded-Encrypted: i=1; AKwUvBydJytMatzhySUH3FkUMkWDYEqNOahxi6lqopI5+LnsooVx3ZUQKDXELMhcDvgmu7d3CUJHHpc=@lists.linux.dev
X-Gm-Message-State: AFuF++lixi4dk16El+BvLXLp0UDimfA9JDiV2rnJOaGW98aD44WozXnF
	pzqEPLt15DZkoaM58dQcglmsLBaADAI5heXKwJFAT/8R8+opfu+gTaV94yy+DdYDHKI=
X-Gm-Gg: AYBFou1n6Wz6oYyXEj7DO2F5tH7jRpOL3YZeVyUum4ULPhQbRzeKZOWZocVtydYCSCN
	3BcwhN7MqxvOTchZB+HBQPCfGlc0RvM0aWtfodTgOKixM80vpqDjFh3yzNXaHybKLhu5Lt/QAIr
	H2W8/ys1gFIQBRfAqcBasJotQ6rAoKQOK7c83lXa6Myec7Lk1///95WqWRCR8x5QKnNMWu79sEf
	+ewnNuZB6jbLtJKyx4spx388O5li4D6fFqMCAqAJBSqXp31EN/eu+sLgJg2VKuBptBecKkFEL99
	G7OUp9kuNRZ/xXrgCBxnCpTpgGSMjj6SiFXKm1tHe7UpLt1nuafOgyZfPl7w1bGp6TAe4r+LO1R
	y3TEYd1f3WGDrKCTFX49/wRtydksLMFdJH8zJBSml+JnB+QV9Z0qcPT3mNgf9lpO5ejaQZ6MC1p
	PnE3JHj705jtc+kLYnZGnaAlqFYHnM4ihO47xbIpRltuJngo4Z7ruILlz0/TF1BHL6ZlC9EN9Yp
	72MDZeTRKQYEyVlLNN+FxJWwEeNX2ddh9ElmeRUCiyMZro6ngo3edi0d4xSKh2IT8HYey/Zmnfr
	A2ENLmqt3hRHdPgZDcM=
X-Received: by 2002:a81:8a82:0:b0:81f:e85b:f9da with SMTP id 00721157ae682-89738597570mr31205017b3.33.1789933093562;
        Sun, 20 Sep 2026 12:38:13 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47139db2sm18456977b3.26.2026.09.20.12.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 13/46] cpu_preserve: Add physical CPU preservation ABI and core API headers
Date: Sun, 20 Sep 2026 15:36:17 -0400
Message-ID: <20260920193650.3373435-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the KHO ABI structures for physical CPU preservation in
include/linux/kho/abi/cpu.h and the core kernel interfaces in
include/linux/cpu_preserve.h.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/cpu_preserve.h | 352 +++++++++++++++++++++++++++++++++++
 include/linux/kho/abi/cpu.h  | 112 +++++++++++
 2 files changed, 464 insertions(+)
 create mode 100644 include/linux/kho/abi/cpu.h

diff --git a/include/linux/cpu_preserve.h b/include/linux/cpu_preserve.h
index f653838c383d..94181952df1a 100644
--- a/include/linux/cpu_preserve.h
+++ b/include/linux/cpu_preserve.h
@@ -9,9 +9,75 @@
 #define _LINUX_CPU_PRESERVE_H
 
 #include <linux/compiler.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/kho/abi/cpu.h>
+#include <linux/list.h>
+#include <linux/smp.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_LIVEUPDATE_CPU
 
+#include <asm/cpu_preserve.h>
+#include <asm/page.h>
+
+#define CPU_PRESERVED_STACK_ORDER	ARCH_CPU_PRESERVED_STACK_ORDER
+#define CPU_PRESERVED_STACK_SIZE	((size_t)PAGE_SIZE << CPU_PRESERVED_STACK_ORDER)
+#define CPU_PRESERVED_STACK_HEADROOM	256
+#define CPU_PRESERVED_STACK_MAGIC	0x435055505354414bULL	/* "CPUPSTAK" */
+
+/**
+ * struct cpu_preserved_stack_context - Context header at base of preserved CPU stack
+ * @magic:            Validation signature (%CPU_PRESERVED_STACK_MAGIC).
+ * @cpu:              Logical CPU identifier of the preserved physical core.
+ * @reserved:         Must be zero.
+ * @workload_context: Opaque owning workload or session context.
+ * @session_pgd_pa:   Session root page table physical address, or 0.
+ *
+ * This structure lives at the base of a preserved CPU's dedicated stack and is
+ * accessed by the preserved CPU during parking and workload execution. It is
+ * private to the preserved CPU execution context of the kernel that allocated it.
+ */
+struct cpu_preserved_stack_context {
+	u64 magic;
+	u32 cpu;
+	u32 reserved;
+	u64 workload_context;
+	u64 session_pgd_pa;
+};
+
+static_assert(sizeof(struct cpu_preserved_stack_context) == 32);
+static_assert(offsetof(struct cpu_preserved_stack_context, magic) == 0,
+	      "magic must lead: the struct is found by masking the stack pointer");
+
+/**
+ * cpu_preserved_get_stack_context - Return the context block at the base of the preserved stack
+ *
+ * Masks the current stack pointer to %CPU_PRESERVED_STACK_SIZE alignment and
+ * validates %CPU_PRESERVED_STACK_MAGIC.
+ *
+ * Return: Pointer to &struct cpu_preserved_stack_context if executing on a
+ *         preserved CPU stack, or %NULL otherwise.
+ */
+static inline struct cpu_preserved_stack_context *
+cpu_preserved_get_stack_context(void)
+{
+	struct cpu_preserved_stack_context *sctx;
+	unsigned long sp;
+
+#if defined(CONFIG_X86_64)
+	asm volatile("mov %%rsp, %0" : "=r"(sp));
+#elif defined(CONFIG_ARM64)
+	asm volatile("mov %0, sp" : "=r"(sp));
+#else
+	return NULL;
+#endif
+	sctx = (struct cpu_preserved_stack_context *)(sp & ~(CPU_PRESERVED_STACK_SIZE - 1));
+	if (sctx && sctx->magic == CPU_PRESERVED_STACK_MAGIC)
+		return sctx;
+	return NULL;
+}
+
 /*
  * __cpu_preserved_text: Code executed by preserved physical CPUs during live
  * update kexec handover in orphan mode.
@@ -36,12 +102,298 @@
 
 extern char __cpu_preserved_text_start[], __cpu_preserved_text_end[];
 extern char __cpu_preserved_data_start[], __cpu_preserved_data_end[];
+bool cpu_is_preserved(int cpu);
+bool cpu_preserved_should_exit(int cpu);
+void cpu_preserved_set_dead(int cpu);
+void cpu_preserved_park(int cpu);
+void cpu_preserved_park_loop(int cpu);
+const struct cpumask *cpu_get_preserved_mask(void);
+phys_addr_t cpu_preserved_get_pgd(int cpu);
+int cpu_preserved_attach_workload(int cpu,
+				  void (*entry_fn)(void *data), void *data);
+int cpu_preserved_detach_workload(int cpu);
+void cpu_preserved_set_workload_context(int cpu, void *ctx, phys_addr_t pgd_pa);
+
+/**
+ * cpu_preserved_report_dead - Park preserved CPU when reporting dead in hotplug
+ *
+ * Invoked by cpuhp_ap_report_dead() after CPU hotplug offline synchronization
+ * is complete. If the calling CPU is marked for preservation across live update,
+ * transition it into the preserved parking loop instead of powering down.
+ */
+static inline void cpu_preserved_report_dead(void)
+{
+	if (cpu_is_preserved(raw_smp_processor_id()))
+		cpu_preserved_park(raw_smp_processor_id());
+}
+
+/*
+ * Architecture-specific hooks for CPU preservation.
+ */
+
+/**
+ * arch_cpu_preserved_kick - Signal or wake up a preserved physical CPU
+ * @cpu: Logical CPU identifier.
+ *
+ * Architecture backend hook to wake up the specified preserved CPU from its
+ * low-power parking state (e.g. via IPI, NMI, or SGI).
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_kick(int cpu);
+
+/**
+ * arch_cpu_preserved_park_wait - Architecture low-power wait in parking loop
+ *
+ * Architecture backend hook to execute a low-power wait instruction
+ * (e.g., cpu_relax/pause, wfe) while parked.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_park_wait(void);
+
+/**
+ * arch_cpu_preserved_park_init - Architecture setup upon entering park loop
+ * @cpu: Logical CPU identifier.
+ *
+ * Architecture backend hook to configure the physical core (e.g., disable
+ * or mask local interrupts) upon entering the park loop.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_park_init(int cpu);
+
+/**
+ * arch_cpu_preserved_early_init - Arch early-boot init for incoming preserved CPUs
+ *
+ * Called during early boot in the incoming kernel when preserved physical CPUs
+ * are adopted from KHO metadata.
+ */
+void arch_cpu_preserved_early_init(void);
+
+/**
+ * arch_cpu_preserved_park_finish - Architecture cleanup on park loop exit
+ * @cpu: Logical CPU identifier.
+ *
+ * Architecture backend hook to execute cleanup or CPU powerdown sequence
+ * when the park loop exits.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_park_finish(int cpu);
+
+/**
+ * arch_cpu_preserved_park_on_stack - Switch stack and enter park loop
+ * @cpu: Logical CPU identifier.
+ * @stack_top: Top address of the preserved stack.
+ *
+ * Architecture backend hook to switch to the preserved execution stack
+ * and invoke cpu_preserved_park_loop().
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_park_on_stack(int cpu, unsigned long stack_top);
+
+/**
+ * arch_cpu_preserved_dcache_clean - Clean data cache for address range
+ * @start: Starting virtual address.
+ * @end: Ending virtual address.
+ *
+ * Architecture backend hook to flush/clean data caches to PoC for memory
+ * preservation across live update.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_dcache_clean(unsigned long start, unsigned long end);
+
+/**
+ * arch_cpu_preserved_dcache_inval - Invalidate/clean data cache for range
+ * @start: Starting virtual address.
+ * @end: Ending virtual address.
+ *
+ * Architecture backend hook to clean/invalidate data caches across live
+ * update transitions.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_dcache_inval(unsigned long start, unsigned long end);
+
+/**
+ * arch_cpu_preserved_wait_dead - Wait for CPU to reach dead state
+ * @cpu: Logical CPU identifier.
+ *
+ * Architecture backend hook to wait for a CPU to be fully stopped.
+ *
+ * Executed in normal text context during CPU teardown.
+ */
+void arch_cpu_preserved_wait_dead(int cpu);
+
+struct page;
+
+/**
+ * arch_cpu_preserved_setup_buffer - Map preserved execution buffer outside Scratch
+ * @text_page: Head page of allocated preserved text memory.
+ * @text_nr_pages: Number of pages in the preserved text buffer.
+ * @data_page: Head page of allocated preserved data memory.
+ * @data_nr_pages: Number of pages in the preserved data buffer.
+ *
+ * Architecture backend hook to remap kernel page table entries for
+ * __cpu_preserved_text and __cpu_preserved_data to the newly allocated
+ * pages outside Scratch memory.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int arch_cpu_preserved_setup_buffer(struct page *text_page,
+				    unsigned int text_nr_pages,
+				    struct page *data_page,
+				    unsigned int data_nr_pages);
+
+/**
+ * struct cpu_preserved_as - In-memory address space handle for a preserved CPU
+ * @node:        Entry on the global list of preserved address spaces.
+ * @pgd:         Root page table virtual address in host direct map.
+ * @pgd_pa:      Physical address of @pgd, as loaded into CR3 / TTBR1.
+ * @is_incoming: This address space was built by the previous kernel.
+ * @ser:         Preserved serialization descriptor holding page table physical addresses.
+ */
+struct cpu_preserved_as {
+	struct list_head		node;
+	void				*pgd;
+	phys_addr_t			pgd_pa;
+	bool				is_incoming;
+	struct cpu_preserved_as_ser	*ser;
+};
+
+struct cpu_preserved_as *cpu_preserved_as_create(void);
+void cpu_preserved_as_destroy(struct cpu_preserved_as *as);
+struct cpu_preserved_as *cpu_preserved_as_adopt(struct cpu_preserved_as_ser *ser);
+int cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
+			 unsigned long va, size_t size, pgprot_t prot);
 
 #else /* !CONFIG_LIVEUPDATE_CPU */
 
 #define __cpu_preserved_text
 #define __cpu_preserved_data
 
+static inline bool cpu_is_preserved(int cpu) { return false; }
+static inline bool cpu_preserved_should_exit(int cpu) { return true; }
+static inline void cpu_preserved_park(int cpu) {}
+static inline void cpu_preserved_set_dead(int cpu) {}
+static inline void cpu_preserved_report_dead(void) {}
+static inline const struct cpumask *cpu_get_preserved_mask(void)
+{
+	return cpu_none_mask;
+}
+
+static inline int cpu_preserved_attach_workload(int cpu,
+						void (*entry_fn)(void *data),
+						void *data)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int cpu_preserved_detach_workload(int cpu)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void cpu_preserved_set_workload_context(int cpu, void *ctx,
+						      phys_addr_t pgd_pa) {}
+static inline void arch_cpu_preserved_kick(int cpu) {}
+static inline void arch_cpu_preserved_park_wait(void) {}
+static inline void arch_cpu_preserved_park_init(int cpu) {}
+static inline void arch_cpu_preserved_early_init(void) {}
+static inline void arch_cpu_preserved_park_finish(int cpu) {}
+static inline void arch_cpu_preserved_dcache_clean(unsigned long start,
+						   unsigned long end) {}
+static inline void arch_cpu_preserved_dcache_inval(unsigned long start,
+						   unsigned long end) {}
+static inline void arch_cpu_preserved_wait_dead(int cpu) {}
+static inline phys_addr_t cpu_preserved_get_pgd(int cpu) { return 0; }
+static inline int arch_cpu_preserved_setup_buffer(struct page *text_page,
+						  unsigned int text_nr_pages,
+						  struct page *data_page,
+						  unsigned int data_nr_pages)
+{
+	return 0;
+}
+
+static inline int cpu_preserved_map_range(phys_addr_t pa, unsigned long va,
+					  size_t size, pgprot_t prot) { return 0; }
+static inline int cpu_preserved_map_buffer(void *va, size_t size) { return 0; }
+static inline int arch_cpu_preserved_mpidr_to_cpu(u64 mpidr) { return -EINVAL; }
+static inline bool arch_cpu_preserved_is_active(void) { return false; }
+static inline void arch_cpu_preserved_switch_pgd(phys_addr_t pgd_pa) {}
+static inline struct cpu_preserved_stack_context *
+cpu_preserved_get_stack_context(void)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_LIVEUPDATE_CPU */
 
+/*
+ * Object-granular wrappers around the arch dcache hooks.
+ *
+ * Every preserved-memory handshake flushes or invalidates a whole object, so
+ * spell that out once instead of open-coding (addr, addr + size) at each call
+ * site: the size can then never drift from the object it is supposed to cover.
+ *
+ * @p is a pointer to the object.  For a statically sized array, pass &array so
+ * that sizeof(*(p)) is the size of the whole array rather than of one element.
+ * Use the _sz() forms for flexible-array structures and for raw page buffers,
+ * where the length is not derivable from the type.
+ */
+#define cpu_preserved_clean_sz(p, sz)					\
+	arch_cpu_preserved_dcache_clean((unsigned long)(p),		\
+					(unsigned long)(p) + (sz))
+#define cpu_preserved_inval_sz(p, sz)					\
+	arch_cpu_preserved_dcache_inval((unsigned long)(p),		\
+					(unsigned long)(p) + (sz))
+#define cpu_preserved_clean(p)		cpu_preserved_clean_sz(p, sizeof(*(p)))
+#define cpu_preserved_inval(p)		cpu_preserved_inval_sz(p, sizeof(*(p)))
+
+/**
+ * cpu_preserved_memset - Compiler-barrier-safe byte fill for preserved runtime code
+ * @s: Destination buffer.
+ * @c: Byte value to fill.
+ * @n: Number of bytes to fill.
+ *
+ * Uses WRITE_ONCE() per byte so the compiler's loop-idiom pass cannot replace
+ * the loop with a call to the unmapped host kernel memset() inside
+ * __cpu_preserved_text.
+ *
+ * Return: @s.
+ */
+static inline void *cpu_preserved_memset(void *s, int c, size_t n)
+{
+	unsigned char *p = s;
+
+	while (n--)
+		WRITE_ONCE(*p++, (unsigned char)c);
+	return s;
+}
+
+/**
+ * cpu_preserved_memcpy - Compiler-barrier-safe byte copy for preserved runtime code
+ * @dest: Destination buffer.
+ * @src:  Source buffer.
+ * @n:    Number of bytes to copy.
+ *
+ * Uses READ_ONCE()/WRITE_ONCE() per byte so the compiler's loop-idiom pass
+ * cannot replace the loop with a call to the unmapped host kernel memcpy()
+ * inside __cpu_preserved_text.
+ *
+ * Return: @dest.
+ */
+static inline void *cpu_preserved_memcpy(void *dest, const void *src, size_t n)
+{
+	const unsigned char *s = src;
+	unsigned char *d = dest;
+
+	while (n--)
+		WRITE_ONCE(*d++, READ_ONCE(*s++));
+	return dest;
+}
+
 #endif /* _LINUX_CPU_PRESERVE_H */
diff --git a/include/linux/kho/abi/cpu.h b/include/linux/kho/abi/cpu.h
new file mode 100644
index 000000000000..5926be37f7a0
--- /dev/null
+++ b/include/linux/kho/abi/cpu.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_CPU_H
+#define _LINUX_KHO_ABI_CPU_H
+
+#include <linux/build_bug.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <uapi/linux/liveupdate.h>
+
+/**
+ * DOC: CPU Preservation Live Update ABI
+ *
+ * Physical CPU preservation uses the ABI defined below to serialize
+ * and restore the state of preserved CPUs across a live update kexec
+ * reboot using the LUO.
+ *
+ * Preserved CPUs are isolated from host scheduling and remain active
+ * in a parking loop or running workload across the live update reboot.
+ * This ABI provides the contract for communicating preserved core metadata
+ * and per-file descriptor state to the incoming kernel.
+ *
+ * The state is serialized into packed structures
+ * (struct cpu_preserved_global_ser and struct cpu_preserved_file_ser) which
+ * are handed over to the next kernel via the KHO mechanism.
+ *
+ * This interface is a contract. Any modification to the structure
+ * fields, compatible strings, or the layout of the `__packed`
+ * serialization structures defined here constitutes a breaking change.
+ * Such changes require incrementing the version number in the
+ * CPU_PRESERVED_LUO_FLB_COMPATIBLE or CPU_PRESERVED_LUO_FH_COMPATIBLE
+ * compatibility strings to prevent a new kernel from misinterpreting
+ * data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is
+ * incremented; however, backward/forward compatibility is only
+ * guaranteed for kernels supporting the same ABI version.
+ */
+
+/* The compatibility string for preserved CPU FLB */
+#define CPU_PRESERVED_LUO_FLB_COMPATIBLE	"cpu_flb_v1"
+
+/* The compatibility string for preserved CPU file handler */
+#define CPU_PRESERVED_LUO_FH_COMPATIBLE		"cpu_fh_v1"
+
+enum cpu_preserved_workload {
+	CPU_PRESERVED_PARKED = 1,
+	CPU_PRESERVED_WORKLOAD = 2,
+	CPU_PRESERVED_EXITING = 3,
+	CPU_PRESERVED_DEAD = 4,
+};
+
+/**
+ * struct cpu_preserved_pcpu_ser - Per-CPU mailbox in preserved memory
+ * @workload: Preserved workload state (enum cpu_preserved_workload).
+ */
+struct cpu_preserved_pcpu_ser {
+	u32 workload;
+} __packed;
+
+/**
+ * struct cpu_preserved_global_ser - Global FLB serialization header
+ * @nr_cpu_words:       Number of u64 words in @cpu_preserved_bitmap.
+ * @reserved:           Must be zero.
+ * @text_runtime_pa:    Physical address of preserved CPU runtime text.
+ * @text_runtime_size:  Size of preserved CPU runtime text in bytes.
+ * @data_runtime_pa:    Physical address of preserved CPU runtime data.
+ * @data_runtime_size:  Size of preserved CPU runtime data in bytes.
+ * @pcpus_runtime:      Preservation pointer to struct cpu_preserved_pcpu_ser array.
+ * @transition_as:      Preservation pointer to transition struct cpu_preserved_as_ser.
+ * @cpu_preserved_bitmap: Bitmap of physical CPUs preserved across live update.
+ *
+ * The preserved-CPU bitmap is serialized as an explicitly sized array of u64
+ * rather than as a cpumask_t: sizeof(cpumask_t) depends on NR_CPUS, so
+ * embedding one would make the offset of every subsequent field depend on the
+ * .config of the kernel that wrote it.
+ */
+struct cpu_preserved_global_ser {
+	u32 nr_cpu_words;
+	u32 reserved;
+	u64 text_runtime_pa;
+	u64 text_runtime_size;
+	u64 data_runtime_pa;
+	u64 data_runtime_size;
+	DECLARE_KHOSER_PTR(pcpus_runtime, struct cpu_preserved_pcpu_ser *);
+	DECLARE_KHOSER_PTR(transition_as, struct cpu_preserved_as_ser *);
+	u64 cpu_preserved_bitmap[];
+} __packed;
+
+static_assert(offsetof(struct cpu_preserved_global_ser,
+		       cpu_preserved_bitmap) % sizeof(u64) == 0,
+	      "cpu_preserved_bitmap must be 64-bit aligned");
+
+/**
+ * struct cpu_preserved_file_ser - Per-file serialized state for preserved CPU fd
+ * @cpu:      Logical CPU identifier.
+ * @reserved: Must be zero.
+ * @stack_pa: Physical address of this CPU's preserved stack.
+ * @oncore:   Preservation pointer to on-core session serialized metadata.
+ */
+struct cpu_preserved_file_ser {
+	u32 cpu;
+	u32 reserved;
+	u64 stack_pa;
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_CPU_H */
-- 
2.55.0.1082.g2b9226bbc0-goog

