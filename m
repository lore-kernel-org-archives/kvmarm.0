Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DC547C0F1
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933137; cv=none; b=m3f93nfPN++UlQlFPtcR0o487YL5cU/oQWeLvrj+DtOb94TcaYbnYC4nAjt0YhBK8IdjJ4c7lgGn4yP5wGyn1JVD4SNjc5/aqfFjlp+WeiVWXM31IFY2TDbqwtbny4QZdxQUdU0a01p99o9Eumwk+hdHOmTQtScH4LtyfVLAtFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933137; c=relaxed/simple;
	bh=H8Ud3e/pPl9zr4adgIP/MheGv9SP5nLWnOM77bgSanQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fez3q/MdPdX7G2/bDnJZaFM78XzAcpIMDMrmDmhvGcijTwGUdOX39/rDyJcAzeXUgT3lcQd6VkEKBZjGhiDoldBbcE/riP7snvBn24HXMSIDpCghcADPH4N3x1sbdI2L/D3vaECBeaX++zzlgqjqPFvjFyAOf0qSND+SZDIL+l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=JJSm9hQY; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="JJSm9hQY"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb93aee5eso2161177d50.1
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933133; x=1790537933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rDeGdYrWVI756mfccSr1N9qgsTDTSJtWXV7XY7RA7LI=;
        b=JJSm9hQYvMh26G7y+zttD1LJ2fS8/QBKOOEvivmesX1QcWh2N1BZQoz5jzPhDObJNr
         oZ5wQry4kjz+JuRtS8TAm7ipG6l5cYAoFszhQspkuT/TekU7pcjFQMfLoBfGVxCSQqvt
         H/J+NJjy+JnOkzS6WZIxoYitpXmuVz5dHMg8H2V8K5xRlhOQoEmclMdUWuSyFRcAkzZk
         3Au5bWQvcoqSGd6NdnaQFNiLKTnYQ5o7oAfDvTGfXOeFv7t45zgsSNoBtuazvqn3OHLD
         bGXutyaDy1njKqGMmUtEboMYxTZvCakoeT8MGUx8GyeH180IKKkzfGh4Chy62QduS1Z3
         mmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933133; x=1790537933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rDeGdYrWVI756mfccSr1N9qgsTDTSJtWXV7XY7RA7LI=;
        b=vXpqRg2FNTdwz5usVLbk/VY7l0ZUnKcbtCe//HFmPH5gCha3MbdaX3L2Pe4b4V2H0I
         +puPmcztyqc149Iy597fBFTJcCrTvqCjtMlDIoOIfVhQgBlkj2LGobaESHC1VE2ZCQ8x
         JiqCCodcpk9uTm6YaHAPsvQbArmuWhGtmqIfuX2WJ/8CPJveVfTbiFFZRMsoYrJ54JBb
         Z2vexft+BdVTFciYvRkFnXvG3ns81LSwOK9wG/Ob2J2fTdo8JODyluUb7bh1v7ff+XEm
         JfXpg9LyZ7FJgpMTC10hXs5xg4C1m5gupugygo3UOsJZWxvN6G2S23qushIxIwZXFcq4
         1Guw==
X-Forwarded-Encrypted: i=1; AKwUvBwpD3b8ig8AVTnVIAkBha6bHxl5KKTcjUNogfQmkTgYoPyG0xeWJoqCIhdnb9cxirPtxRb676I=@lists.linux.dev
X-Gm-Message-State: AFuF++lHJXX2MXzqxLgHzZU7lYGazPXhTiwHILwq9O3ZjRJshu6lkzmI
	KsQzo7g7gDlEEIHMWCwwKph5vsAe6ToH66/83e/oN8u/I4g5IyaT20HXqBzX5ScY1UU=
X-Gm-Gg: AYBFou0AwSiJ7HH+8+M/zkNifSIEkDk/gq3DhndmMHbOEYf4Yu/Eia06H4rICnrgdCz
	gz9RTNK8uHWjjnONm/BFR7ar65AUmwau9Wk9862bNzNehoOZcot+KkIYMyLT0Dt3KINVSXoG22B
	r+pEZTlwNeT+cy+lzPGBXaq33/PfKkAennFdcXkPcM9xUfgn1H+KZYDtzAQ7WbKaeMgsvzM1mA2
	w6iXpy2BY8nq9SjUgZDPs6sl0xn7teTEg/0vLzHUd9a5Ecu/kE7po69M+j5r5k/ceDgtsrovzTX
	7h4FggiKm+YJ0GicJIEI7uzty9fn+qa56IpdZSF71fwjjCAj8s8hBpe7x0bxZwS4dzUh8hO+gM4
	cWiWwb6ypN2X5aYnH8ZrTByhepBnXzmCxrZ/ny17Q3S/1NCDwrbNv8ymFM8HBT08hCIt2AlsOuM
	GrOJfzKRksWkdbWlkULLONxTw8YqP7vj3kg/BzkCgtR/RQOXVsXem+aVMf+fcXRuuBWzrUDEax5
	nhmJJD677yilp9Rye9mf4ucOMp+61Lrwp+vBTWVbFPfo0rPlA53jVkd9Exs1KF8UKm6RqoYSui5
	j76Wb4q/X1GsWEzaPX70JmjNeM9PpA==
X-Received: by 2002:a05:690e:140d:b0:667:770c:f88e with SMTP id 956f58d0204a3-6717fced827mr2735036d50.45.1789933133115;
        Sun, 20 Sep 2026 12:38:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299130a5dsm2571501d50.19.2026.09.20.12.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:52 -0700 (PDT)
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
Subject: [RFC PATCH 20/46] x86: liveupdate: Add physical CPU preservation context and page table support
Date: Sun, 20 Sep 2026 15:36:24 -0400
Message-ID: <20260920193650.3373435-21-pasha.tatashin@soleen.com>
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

Implement x86 physical CPU preservation context management, APIC wakeup,
and isolated transition page tables in arch/x86/kernel/cpu_preserve.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/cpu_preserve.h |   5 +-
 arch/x86/kernel/Makefile            |   7 +
 arch/x86/kernel/cpu_preserve.c      | 432 ++++++++++++++++++++++++++++
 4 files changed, 444 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu_preserve.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..c57b54b2b2b0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -71,6 +71,7 @@ config X86
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_HAS_PMD_SOFTLEAVES if X86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_LIVEUPDATE_CPU if LIVEUPDATE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_ATTACK_VECTORS	if CPU_MITIGATIONS
 	select ARCH_HAS_CACHE_LINE_SIZE
diff --git a/arch/x86/include/asm/cpu_preserve.h b/arch/x86/include/asm/cpu_preserve.h
index 969903eb70cb..83f72d39a44b 100644
--- a/arch/x86/include/asm/cpu_preserve.h
+++ b/arch/x86/include/asm/cpu_preserve.h
@@ -10,9 +10,12 @@
 
 #define ARCH_CPU_PRESERVED_STACK_ORDER	THREAD_SIZE_ORDER
 
-#ifdef CONFIG_CC_IS_GCC
+#if __has_attribute(indirect_branch) && __has_attribute(function_return)
 #define ARCH_CPU_PRESERVED_TEXT \
 	__attribute__((indirect_branch("keep"), function_return("keep")))
+#elif __has_attribute(indirect_branch)
+#define ARCH_CPU_PRESERVED_TEXT \
+	__attribute__((indirect_branch("keep")))
 #else
 #define ARCH_CPU_PRESERVED_TEXT
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 31f46fd00527..6e238444039d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -78,6 +78,13 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_ia32.o
 obj-$(CONFIG_IA32_EMULATION)	+= sys_ia32.o signal_32.o
+KASAN_SANITIZE_cpu_preserve.o := n
+KCSAN_SANITIZE_cpu_preserve.o := n
+UBSAN_SANITIZE_cpu_preserve.o := n
+KCOV_INSTRUMENT_cpu_preserve.o := n
+CFLAGS_REMOVE_cpu_preserve.o = $(CC_FLAGS_FTRACE)
+CFLAGS_cpu_preserve.o += -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+obj-$(CONFIG_LIVEUPDATE_CPU)	+= cpu_preserve.o preserve_cpu.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o
 obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
diff --git a/arch/x86/kernel/cpu_preserve.c b/arch/x86/kernel/cpu_preserve.c
new file mode 100644
index 000000000000..15327bf469db
--- /dev/null
+++ b/arch/x86/kernel/cpu_preserve.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Architecture specific CPU preservation support for x86.
+ */
+#include <linux/cpu_preserve.h>
+#include <linux/kexec_handover.h>
+#include <linux/mm.h>
+#include <linux/nospec.h>
+#include <linux/objtool.h>
+#include <linux/sched/mm.h>
+
+#include <asm/apic.h>
+#include <linux/cacheflush.h>
+#include <linux/cpufeature.h>
+#include <asm/desc.h>
+#include <asm/fixmap.h>
+#include <asm/msr.h>
+#include <linux/pgtable.h>
+#include <asm/set_memory.h>
+#include <linux/smp.h>
+#include <asm/tlbflush.h>
+#include <asm/trapnr.h>
+#include <asm/init.h>
+
+static u32 x86_preserved_apicid[NR_CPUS] __cpu_preserved_data = {
+	[0 ... NR_CPUS - 1] = BAD_APICID,
+};
+
+static bool x86_preserved_x2apic __cpu_preserved_data;
+
+/*
+ * Signal or wake up a preserved physical CPU via APIC ICR NMI.
+ */
+void __cpu_preserved_text arch_cpu_preserved_kick(int cpu)
+{
+	u32 apicid;
+	u64 val;
+
+	if ((unsigned int)cpu >= NR_CPUS || !cpu_is_preserved(cpu))
+		return;
+
+	cpu = array_index_nospec(cpu, NR_CPUS);
+	apicid = x86_preserved_apicid[cpu];
+	if (apicid == BAD_APICID)
+		return;
+
+	val = ((u64)apicid << 32) | APIC_DM_NMI;
+	native_wrmsrq(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+}
+
+/*
+ * Low-power wait in parking loop.
+ */
+void __cpu_preserved_text arch_cpu_preserved_park_wait(void)
+{
+	cpu_relax();
+}
+
+static gate_desc x86_preserved_idt[IDT_ENTRIES] __cpu_preserved_data __aligned(PAGE_SIZE);
+static struct desc_ptr x86_preserved_idt_desc __cpu_preserved_data;
+
+static struct desc_struct x86_preserved_gdt[GDT_ENTRIES] __cpu_preserved_data __aligned(PAGE_SIZE);
+static struct desc_ptr x86_preserved_gdt_desc __cpu_preserved_data;
+static bool x86_preserved_has_svm __cpu_preserved_data;
+
+/*
+ * Initialize the preserved IDT with stub handlers.
+ *
+ * Vectors 0..31 are x86 architecture exceptions/traps:
+ * - Exceptions with error codes (#DF, #TS, #NP, #SS, #GP, #PF, #AC, #CP, #VC,
+ *   and #SX / vector 30) push an 8-byte error code onto the stack before the
+ *   IRET frame. They must use iret_err_handler (x86_preserved_iret_err_stub)
+ *   to pop the error code before iretq.
+ * - Other exceptions push no error code and return directly via iret_handler
+ *   (x86_preserved_iret_stub).
+ *
+ * Vectors >= FIRST_EXTERNAL_VECTOR (32) are device and IPI interrupts:
+ * - External interrupts push no error code but require an APIC EOI before
+ *   returning, handled by eoi_handler (x86_preserved_apic_eoi_stub), so the
+ *   Local APIC does not block subsequent interrupts.
+ */
+static void init_preserved_idt(void)
+{
+	unsigned long iret_err_handler = (unsigned long)&x86_preserved_iret_err_stub;
+	unsigned long eoi_handler = (unsigned long)&x86_preserved_apic_eoi_stub;
+	unsigned long iret_handler = (unsigned long)&x86_preserved_iret_stub;
+	int v;
+
+	for (v = 0; v < IDT_ENTRIES; v++) {
+		bool has_err = (v == X86_TRAP_DF ||
+				(v >= X86_TRAP_TS && v <= X86_TRAP_PF) ||
+				v == X86_TRAP_AC || v == X86_TRAP_CP ||
+				v == X86_TRAP_VC || v == 30); /* 30: #SX */
+		unsigned long handler = (v >= FIRST_EXTERNAL_VECTOR) ? eoi_handler :
+			(has_err ? iret_err_handler : iret_handler);
+
+		pack_gate(&x86_preserved_idt[v], GATE_INTERRUPT, handler, 0,
+			  0, __KERNEL_CS);
+	}
+	x86_preserved_idt_desc.size = sizeof(x86_preserved_idt) - 1;
+	x86_preserved_idt_desc.address = (unsigned long)&x86_preserved_idt[0];
+	cpu_preserved_clean(&x86_preserved_idt);
+	cpu_preserved_clean(&x86_preserved_idt_desc);
+}
+
+static void init_preserved_gdt(void)
+{
+	struct desc_struct *gdt;
+	int i;
+
+	gdt = get_current_gdt_rw();
+	for (i = 0; i < GDT_ENTRIES; i++)
+		x86_preserved_gdt[i] = gdt[i];
+	x86_preserved_gdt_desc.size = GDT_SIZE - 1;
+	x86_preserved_gdt_desc.address = (unsigned long)&x86_preserved_gdt[0];
+	cpu_preserved_clean(&x86_preserved_gdt);
+	cpu_preserved_clean(&x86_preserved_gdt_desc);
+}
+
+void __cpu_preserved_text arch_cpu_preserved_load_desc(void)
+{
+	native_load_gdt(&x86_preserved_gdt_desc);
+	native_load_idt(&x86_preserved_idt_desc);
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_load_desc);
+
+/*
+ * Disables local interrupts on the physical core and loads preserved IDT and GDT.
+ */
+void __cpu_preserved_text arch_cpu_preserved_park_init(int cpu)
+{
+	u32 spiv;
+
+	local_irq_disable();
+	arch_cpu_preserved_load_desc();
+
+	if (cpu >= 0 && cpu < CONFIG_NR_CPUS && x86_preserved_x2apic) {
+		x86_preserved_apicid[cpu] =
+			(u32)native_rdmsrq(APIC_BASE_MSR + (APIC_ID >> 4));
+		cpu_preserved_clean(&x86_preserved_apicid[cpu]);
+	}
+
+	spiv = (u32)native_rdmsrq(APIC_BASE_MSR + (APIC_SPIV >> 4));
+	if (!(spiv & APIC_SPIV_APIC_ENABLED)) {
+		spiv |= APIC_SPIV_APIC_ENABLED;
+		native_wrmsrq(APIC_BASE_MSR + (APIC_SPIV >> 4), spiv);
+	}
+}
+
+void arch_cpu_preserved_early_init(void)
+{
+	int i;
+
+	x86_preserved_has_svm = boot_cpu_has(X86_FEATURE_SVM);
+	x86_preserved_x2apic = x2apic_mode != 0;
+	cpu_preserved_clean(&x86_preserved_x2apic);
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		u32 apicid = cpu_physical_id(i);
+
+		if (apicid == BAD_APICID)
+			apicid = cpuid_to_apicid[i];
+		x86_preserved_apicid[i] = apicid;
+	}
+	cpu_preserved_clean(&x86_preserved_apicid);
+
+	init_preserved_idt();
+	init_preserved_gdt();
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_early_init);
+
+/*
+ * Disable hardware virtualization on physical core so INIT is recognized.
+ */
+static void __cpu_preserved_text arch_cpu_preserved_virt_teardown(void)
+{
+	if (__read_cr4() & X86_CR4_VMXE) {
+		asm volatile("1: vmxoff\n\t"
+			     "2:\n\t"
+			     _ASM_EXTABLE(1b, 2b)
+			     : : : "memory", "cc");
+		asm volatile("mov %0, %%cr4" : : "r" (__read_cr4() & ~X86_CR4_VMXE) : "memory");
+	}
+
+	if (x86_preserved_has_svm) {
+		u64 efer = native_rdmsrq(MSR_EFER);
+
+		if (efer & EFER_SVME) {
+			asm volatile("stgi" : : : "memory");
+			native_wrmsrq(MSR_EFER, efer & ~EFER_SVME);
+		}
+	}
+}
+
+/*
+ * Architecture cleanup on park loop exit.
+ */
+void __cpu_preserved_text arch_cpu_preserved_park_finish(int cpu __maybe_unused)
+{
+	arch_cpu_preserved_load_desc();
+	arch_cpu_preserved_virt_teardown();
+}
+
+phys_addr_t __cpu_preserved_data x86_caretaker_pgd_pa;
+EXPORT_SYMBOL_GPL(x86_caretaker_pgd_pa);
+
+bool __cpu_preserved_text arch_cpu_preserved_is_active(void)
+{
+	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+	unsigned long cr3 = __read_cr3();
+
+	if (sctx && sctx->session_pgd_pa && cr3 == sctx->session_pgd_pa)
+		return true;
+
+	if (x86_caretaker_pgd_pa)
+		return cr3 == x86_caretaker_pgd_pa;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_is_active);
+
+void __cpu_preserved_text arch_cpu_preserved_switch_pgd(phys_addr_t pgd_pa)
+{
+	if (pgd_pa && __read_cr3() != pgd_pa)
+		write_cr3(pgd_pa);
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_switch_pgd);
+
+asmlinkage void arch_cpu_preserved_call_on_stack(int cpu, unsigned long stack,
+						 void (*fn)(int cpu));
+
+static void __cpu_preserved_text arch_cpu_preserved_park_worker(int cpu)
+{
+	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+	phys_addr_t pgd_pa = 0;
+
+	arch_cpu_preserved_park_init(cpu);
+
+	if (sctx && sctx->session_pgd_pa)
+		pgd_pa = sctx->session_pgd_pa;
+	else
+		pgd_pa = cpu_preserved_get_pgd(cpu);
+
+	if (!pgd_pa)
+		pgd_pa = x86_caretaker_pgd_pa;
+
+	if (pgd_pa)
+		write_cr3(pgd_pa);
+
+	cpu_preserved_park_loop(cpu);
+
+	arch_cpu_preserved_park_finish(cpu);
+	native_irq_disable();
+	cpu_preserved_set_dead(cpu);
+	while (1) {
+		native_irq_disable();
+		asm volatile("hlt");
+	}
+}
+STACK_FRAME_NON_STANDARD(arch_cpu_preserved_park_worker);
+
+static void arch_cpu_preserved_set_max_perf(void)
+{
+	u64 cap;
+
+	/* Intel HWP (Speed Shift): autonomously request maximum performance */
+	if (boot_cpu_has(X86_FEATURE_HWP) &&
+	    !rdmsrq_safe(MSR_HWP_CAPABILITIES, &cap)) {
+		u8 highest = HWP_HIGHEST_PERF(cap);
+
+		if (highest) {
+			wrmsrq_safe(MSR_HWP_REQUEST, HWP_MIN_PERF(highest) |
+				    HWP_MAX_PERF(highest) |
+				    HWP_DESIRED_PERF(highest));
+		}
+	}
+
+	/* Intel Energy Performance Bias: hint for maximum performance */
+	if (boot_cpu_has(X86_FEATURE_EPB))
+		wrmsrq_safe(MSR_IA32_ENERGY_PERF_BIAS, ENERGY_PERF_BIAS_PERFORMANCE);
+
+	/* AMD CPPC: request maximum performance ratio and zero energy preference */
+	if (boot_cpu_has(X86_FEATURE_CPPC)) {
+		wrmsrq_safe(MSR_AMD_CPPC_REQ, AMD_CPPC_MAX_PERF_MASK |
+			    AMD_CPPC_MIN_PERF_MASK | AMD_CPPC_DES_PERF_MASK);
+	}
+}
+
+/*
+ * Switch stack and enter park loop.
+ */
+void arch_cpu_preserved_park_on_stack(int cpu, unsigned long stack_top)
+{
+	if (cpu >= 0 && cpu < CONFIG_NR_CPUS) {
+		if (x86_preserved_x2apic)
+			x86_preserved_apicid[cpu] =
+				(u32)native_rdmsrq(APIC_BASE_MSR + (APIC_ID >> 4));
+		else
+			x86_preserved_apicid[cpu] = cpu_physical_id(cpu);
+		cpu_preserved_clean(&x86_preserved_apicid[cpu]);
+	}
+	arch_cpu_preserved_set_max_perf();
+	arch_cpu_preserved_call_on_stack(cpu, stack_top, arch_cpu_preserved_park_worker);
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_park_on_stack);
+
+/*
+ * Clean data cache for address range. x86 has hardware coherent caches,
+ * so a memory barrier suffices without calling unpreserved external routines.
+ */
+void __cpu_preserved_text arch_cpu_preserved_dcache_clean(unsigned long start, unsigned long end)
+{
+	/* Memory barrier to serialize cache operations on x86 */
+	mb();
+}
+
+/*
+ * Invalidate data cache for address range.
+ */
+void __cpu_preserved_text arch_cpu_preserved_dcache_inval(unsigned long start, unsigned long end)
+{
+	/* Memory barrier to serialize cache operations on x86 */
+	mb();
+}
+
+/**
+ * arch_cpu_preserved_as_map - Populate an isolated page table on x86
+ * @as: Address space to map into.
+ * @pa: Physical address of the range.
+ * @va: Virtual address the range must appear at.
+ * @size: Size of the range in bytes.
+ * @prot: Protection to apply.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int arch_cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
+			      unsigned long va, size_t size, pgprot_t prot)
+{
+	unsigned long offset = va & ~PAGE_MASK;
+	size_t page_size = PAGE_ALIGN(offset + size);
+	unsigned long page_va = va & PAGE_MASK;
+	phys_addr_t page_pa = (pa & PAGE_MASK);
+	struct x86_mapping_info info = {
+		.alloc_pgt_page = cpu_preserved_as_alloc_page,
+		.context = as,
+		.page_flag = pgprot_val(prot),
+		.offset = page_va - page_pa,
+		.force_pte = true,
+	};
+
+	return kernel_ident_mapping_init(&info, as->pgd, page_pa,
+					 page_pa + page_size);
+}
+
+/*
+ * A preserved CPU only ever enters one of these address spaces by loading
+ * CR3, which flushes everything that is not global, and nothing in them is
+ * mapped global.
+ */
+void arch_cpu_preserved_as_flush_tlb(void)
+{
+}
+
+void arch_cpu_preserved_set_transition_as(struct cpu_preserved_as *as)
+{
+	x86_caretaker_pgd_pa = as ? as->pgd_pa : 0;
+}
+
+int arch_cpu_preserved_setup_buffer(struct page *text_page,
+				    unsigned int text_nr_pages,
+				    struct page *data_page,
+				    unsigned int data_nr_pages)
+{
+	unsigned long text_start = (unsigned long)__cpu_preserved_text_start;
+	unsigned long data_start = (unsigned long)__cpu_preserved_data_start;
+	unsigned int i;
+	int ret;
+
+	if (!x2apic_enabled()) {
+		pr_warn("cpu_preserve: x2APIC is required\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* Split kernel large pages into 4K PTEs */
+	ret = set_memory_4k(text_start, text_nr_pages);
+	if (ret)
+		return ret;
+
+	ret = set_memory_4k(data_start, data_nr_pages);
+	if (ret)
+		return ret;
+
+	/* Remap init_mm kernel mappings to point to allocated buffer pages */
+	for (i = 0; i < text_nr_pages; i++) {
+		unsigned int level;
+		pte_t *pte = lookup_address(text_start + i * PAGE_SIZE, &level);
+
+		if (pte && level == PG_LEVEL_4K) {
+			phys_addr_t pa = page_to_phys(text_page) + i * PAGE_SIZE;
+
+			set_pte(pte, pfn_pte(PHYS_PFN(pa), pte_pgprot(*pte)));
+		}
+	}
+
+	for (i = 0; i < data_nr_pages; i++) {
+		unsigned int level;
+		pte_t *pte = lookup_address(data_start + i * PAGE_SIZE, &level);
+
+		if (pte && level == PG_LEVEL_4K) {
+			phys_addr_t pa = page_to_phys(data_page) + i * PAGE_SIZE;
+
+			set_pte(pte, pfn_pte(PHYS_PFN(pa), pte_pgprot(*pte)));
+		}
+	}
+
+	flush_tlb_all();
+
+	/* Ensure preserved GDT, IDT, and arch flags are initialized */
+	arch_cpu_preserved_early_init();
+	init_preserved_idt();
+	init_preserved_gdt();
+	cpu_preserved_clean(&x86_preserved_has_svm);
+
+	return 0;
+}
+
+void arch_cpu_preserved_wait_dead(int cpu)
+{
+}
-- 
2.55.0.1082.g2b9226bbc0-goog

