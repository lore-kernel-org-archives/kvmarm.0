Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743352F1FC4
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 13:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760101296; cv=none; b=roQwKRXjyzRi2iNKvMikMkoPGA9D3w10eLqw0GnnKvtMTI7IPRf6E30elHdWKetneyJ9GmLzPP0LG0A8ecQ8bw8Dnf8lge42WueaIRBJYyulQeEUSGAhWNJ0lmIG4nHfwFFsS6TeOj3Iu+Rm9+/QQMLy/q+zL7lZfEk8xVjQsYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760101296; c=relaxed/simple;
	bh=Ud3m4RcvptmRT5HTbIgsZTAMDWVmVsJjcHaVm7mqPrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnhuC3t1JJ36oJkQEQShSCCXRIixMSS/gPReCpEPCsLE7OH1dfznvubHHLqcLf49mQI1wvbG4hzY1gWz8LB1UkPhbJ1RUYORHlPbsApBN1d+NFwZVI+R5P2Hwn5/479i4/bluyY8pkdvcFmnZHq4Xz+rmdKwyKMGH3cUZn3q66U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WhW6rGEz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WhW6rGEz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760101292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M1gvCIcEq8VC5SpotzWbLSXdVVJG006i/zae5C+RMuI=;
	b=WhW6rGEzuSudpKcGt5u4iLEhcYJIeTlGs+ST7Tt438zcgw28PNcgzyzLT/sFEKb+ghpqw/
	ikD6UKImA54CaXU629ZRND+WyiUzGFWjAVD+QxyNTkTcWQtOcqyYVCqrwaJjweBn19LJ66
	7028z2QaYKJ2fzxmisfkA3OMB7/CyuQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-48y6eHKWOMKfuun5lt8URQ-1; Fri,
 10 Oct 2025 09:01:29 -0400
X-MC-Unique: 48y6eHKWOMKfuun5lt8URQ-1
X-Mimecast-MFC-AGG-ID: 48y6eHKWOMKfuun5lt8URQ_1760101288
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8ACAA19560AE;
	Fri, 10 Oct 2025 13:01:28 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B2481954128;
	Fri, 10 Oct 2025 13:01:24 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 2/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in non-uapi headers
Date: Fri, 10 Oct 2025 15:01:16 +0200
Message-ID: <20251010130116.828465-3-thuth@redhat.com>
In-Reply-To: <20251010130116.828465-1-thuth@redhat.com>
References: <20251010130116.828465-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thomas Huth <thuth@redhat.com>

While the GCC and Clang compilers already define __ASSEMBLER__
automatically when compiling assembly code, __ASSEMBLY__ is a
macro that only gets defined by the Makefiles in the kernel.
This can be very confusing when switching between userspace
and kernelspace coding, or when dealing with uapi headers that
rather should use __ASSEMBLER__ instead. So let's standardize now
on the __ASSEMBLER__ macro that is provided by the compilers.

This is a mostly mechanical patch (done with a simple "sed -i"
statement), except for the following files where comments with
mis-spelled macros were tweaked manually:

 arch/arm64/include/asm/stacktrace/frame.h
 arch/arm64/include/asm/kvm_ptrauth.h
 arch/arm64/include/asm/debug-monitors.h
 arch/arm64/include/asm/esr.h
 arch/arm64/include/asm/scs.h
 arch/arm64/include/asm/memory.h

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/include/asm/alternative-macros.h       |  8 ++++----
 arch/arm64/include/asm/alternative.h              |  4 ++--
 arch/arm64/include/asm/arch_gicv3.h               |  4 ++--
 arch/arm64/include/asm/asm-extable.h              |  6 +++---
 arch/arm64/include/asm/assembler.h                |  2 +-
 arch/arm64/include/asm/barrier.h                  |  4 ++--
 arch/arm64/include/asm/cache.h                    |  4 ++--
 arch/arm64/include/asm/cpucaps.h                  |  4 ++--
 arch/arm64/include/asm/cpufeature.h               |  4 ++--
 arch/arm64/include/asm/cputype.h                  |  4 ++--
 arch/arm64/include/asm/current.h                  |  4 ++--
 arch/arm64/include/asm/debug-monitors.h           |  4 ++--
 arch/arm64/include/asm/el2_setup.h                |  2 +-
 arch/arm64/include/asm/elf.h                      |  4 ++--
 arch/arm64/include/asm/esr.h                      |  4 ++--
 arch/arm64/include/asm/fixmap.h                   |  4 ++--
 arch/arm64/include/asm/fpsimd.h                   |  2 +-
 arch/arm64/include/asm/ftrace.h                   |  6 +++---
 arch/arm64/include/asm/gpr-num.h                  |  6 +++---
 arch/arm64/include/asm/hwcap.h                    |  2 +-
 arch/arm64/include/asm/image.h                    |  4 ++--
 arch/arm64/include/asm/insn.h                     |  4 ++--
 arch/arm64/include/asm/jump_label.h               |  4 ++--
 arch/arm64/include/asm/kasan.h                    |  2 +-
 arch/arm64/include/asm/kexec.h                    |  4 ++--
 arch/arm64/include/asm/kgdb.h                     |  4 ++--
 arch/arm64/include/asm/kvm_asm.h                  |  4 ++--
 arch/arm64/include/asm/kvm_mmu.h                  |  4 ++--
 arch/arm64/include/asm/kvm_mte.h                  |  4 ++--
 arch/arm64/include/asm/kvm_ptrauth.h              |  6 +++---
 arch/arm64/include/asm/linkage.h                  |  2 +-
 arch/arm64/include/asm/memory.h                   |  4 ++--
 arch/arm64/include/asm/mmu.h                      |  4 ++--
 arch/arm64/include/asm/mmu_context.h              |  4 ++--
 arch/arm64/include/asm/mte-kasan.h                |  4 ++--
 arch/arm64/include/asm/mte.h                      |  4 ++--
 arch/arm64/include/asm/page.h                     |  4 ++--
 arch/arm64/include/asm/pgtable-prot.h             |  4 ++--
 arch/arm64/include/asm/pgtable.h                  |  4 ++--
 arch/arm64/include/asm/proc-fns.h                 |  4 ++--
 arch/arm64/include/asm/processor.h                |  4 ++--
 arch/arm64/include/asm/ptrace.h                   |  4 ++--
 arch/arm64/include/asm/rsi_smc.h                  |  4 ++--
 arch/arm64/include/asm/rwonce.h                   |  4 ++--
 arch/arm64/include/asm/scs.h                      |  4 ++--
 arch/arm64/include/asm/sdei.h                     |  4 ++--
 arch/arm64/include/asm/smp.h                      |  4 ++--
 arch/arm64/include/asm/spectre.h                  |  4 ++--
 arch/arm64/include/asm/stacktrace/frame.h         |  4 ++--
 arch/arm64/include/asm/sysreg.h                   | 10 +++++-----
 arch/arm64/include/asm/system_misc.h              |  4 ++--
 arch/arm64/include/asm/thread_info.h              |  2 +-
 arch/arm64/include/asm/tlbflush.h                 |  2 +-
 arch/arm64/include/asm/vdso.h                     |  4 ++--
 arch/arm64/include/asm/vdso/compat_barrier.h      |  4 ++--
 arch/arm64/include/asm/vdso/compat_gettimeofday.h |  4 ++--
 arch/arm64/include/asm/vdso/getrandom.h           |  4 ++--
 arch/arm64/include/asm/vdso/gettimeofday.h        |  4 ++--
 arch/arm64/include/asm/vdso/processor.h           |  4 ++--
 arch/arm64/include/asm/vdso/vsyscall.h            |  4 ++--
 arch/arm64/include/asm/virt.h                     |  4 ++--
 tools/arch/arm64/include/asm/cputype.h            |  4 ++--
 tools/arch/arm64/include/asm/esr.h                |  4 ++--
 tools/arch/arm64/include/asm/gpr-num.h            |  6 +++---
 tools/arch/arm64/include/asm/sysreg.h             | 10 +++++-----
 tools/arch/arm64/include/uapi/asm/kvm.h           |  2 +-
 66 files changed, 136 insertions(+), 136 deletions(-)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index c8c77f9e36d60..8624166248528 100644
--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -19,7 +19,7 @@
 #error "cpucaps have overflown ARM64_CB_BIT"
 #endif
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/stringify.h>
 
@@ -207,7 +207,7 @@ alternative_endif
 #define _ALTERNATIVE_CFG(insn1, insn2, cap, cfg, ...)	\
 	alternative_insn insn1, insn2, cap, IS_ENABLED(cfg)
 
-#endif  /*  __ASSEMBLY__  */
+#endif  /*  __ASSEMBLER__  */
 
 /*
  * Usage: asm(ALTERNATIVE(oldinstr, newinstr, cpucap));
@@ -219,7 +219,7 @@ alternative_endif
 #define ALTERNATIVE(oldinstr, newinstr, ...)   \
 	_ALTERNATIVE_CFG(oldinstr, newinstr, __VA_ARGS__, 1)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -263,6 +263,6 @@ alternative_has_cap_unlikely(const unsigned long cpucap)
 	return true;
 }
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_ALTERNATIVE_MACROS_H */
diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 00d97b8a757f4..607a21e7dd9ce 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -4,7 +4,7 @@
 
 #include <asm/alternative-macros.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/init.h>
 #include <linux/types.h>
@@ -34,5 +34,5 @@ static inline void apply_alternatives_module(void *start, size_t length) { }
 void alt_cb_patch_nops(struct alt_instr *alt, __le32 *origptr,
 		       __le32 *updptr, int nr_inst);
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_ALTERNATIVE_H */
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 9e96f024b2f19..d20b03931a8d1 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -9,7 +9,7 @@
 
 #include <asm/sysreg.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/irqchip/arm-gic-common.h>
 #include <linux/stringify.h>
@@ -188,5 +188,5 @@ static inline bool gic_has_relaxed_pmr_sync(void)
 	return cpus_have_cap(ARM64_HAS_GIC_PRIO_RELAXED_SYNC);
 }
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_ARCH_GICV3_H */
diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index 292f2687a12e5..d67e2fdd1aee5 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -27,7 +27,7 @@
 /* Data fields for EX_TYPE_UACCESS_CPY */
 #define EX_DATA_UACCESS_WRITE	BIT(0)
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 #define __ASM_EXTABLE_RAW(insn, fixup, type, data)	\
 	.pushsection	__ex_table, "a";		\
@@ -77,7 +77,7 @@
 	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_UACCESS_CPY, \uaccess_is_write)
 	.endm
 
-#else /* __ASSEMBLY__ */
+#else /* __ASSEMBLER__ */
 
 #include <linux/stringify.h>
 
@@ -132,6 +132,6 @@
 			    EX_DATA_REG(ADDR, addr)				\
 			  ")")
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_ASM_EXTABLE_H */
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 23be85d933485..b2d633081709f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -5,7 +5,7 @@
  * Copyright (C) 1996-2000 Russell King
  * Copyright (C) 2012 ARM Ltd.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #error "Only include this from assembly code"
 #endif
 
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index f5801b0ba9e9e..9495c4441a46b 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -7,7 +7,7 @@
 #ifndef __ASM_BARRIER_H
 #define __ASM_BARRIER_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/kasan-checks.h>
 
@@ -221,6 +221,6 @@ do {									\
 
 #include <asm-generic/barrier.h>
 
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* __ASM_BARRIER_H */
diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index 09963004ceea9..dd2c8586a725e 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -35,7 +35,7 @@
 #define ARCH_DMA_MINALIGN	(128)
 #define ARCH_KMALLOC_MINALIGN	(8)
 
-#if !defined(__ASSEMBLY__) && !defined(BUILD_VDSO)
+#if !defined(__ASSEMBLER__) && !defined(BUILD_VDSO)
 
 #include <linux/bitops.h>
 #include <linux/kasan-enabled.h>
@@ -135,6 +135,6 @@ static inline u32 __attribute_const__ read_cpuid_effective_cachetype(void)
 	return ctr;
 }
 
-#endif /* !defined(__ASSEMBLY__) && !defined(BUILD_VDSO) */
+#endif /* !defined(__ASSEMBLER__) && !defined(BUILD_VDSO) */
 
 #endif
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 9d769291a3067..2c8029472ad45 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -5,7 +5,7 @@
 
 #include <asm/cpucap-defs.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 /*
  * Check whether a cpucap is possible at compiletime.
@@ -77,6 +77,6 @@ cpucap_is_possible(const unsigned int cap)
 
 	return true;
 }
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e223cbf350e49..88f3d618605e0 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -19,7 +19,7 @@
 #define ARM64_SW_FEATURE_OVERRIDE_HVHE		4
 #define ARM64_SW_FEATURE_OVERRIDE_RODATA_OFF	8
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/bug.h>
 #include <linux/jump_label.h>
@@ -1078,6 +1078,6 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 9b00b75acbf29..024b4fa976a85 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -249,7 +249,7 @@
 #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
 #define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/sysreg.h>
 
@@ -328,6 +328,6 @@ static inline u32 __attribute_const__ read_cpuid_cachetype(void)
 {
 	return read_cpuid(CTR_EL0);
 }
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/current.h b/arch/arm64/include/asm/current.h
index 54ceae0874c7e..c92912eaf1868 100644
--- a/arch/arm64/include/asm/current.h
+++ b/arch/arm64/include/asm/current.h
@@ -4,7 +4,7 @@
 
 #include <linux/compiler.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 struct task_struct;
 
@@ -23,7 +23,7 @@ static __always_inline struct task_struct *get_current(void)
 
 #define current get_current()
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_CURRENT_H */
 
diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index f5e3ed2420ced..8d5f92418838d 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -48,7 +48,7 @@
 #define AARCH32_BREAK_THUMB2_LO	0xf7f0
 #define AARCH32_BREAK_THUMB2_HI	0xa000
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 struct task_struct;
 
 #define DBG_ARCH_ID_RESERVED	0	/* In case of ptrace ABI updates. */
@@ -88,5 +88,5 @@ static inline bool try_step_suspended_breakpoints(struct pt_regs *regs)
 
 bool try_handle_aarch32_break(struct pt_regs *regs);
 
-#endif	/* __ASSEMBLY */
+#endif	/* __ASSEMBLER__ */
 #endif	/* __ASM_DEBUG_MONITORS_H */
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b37da3ee85296..892761d3db45f 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -7,7 +7,7 @@
 #ifndef __ARM_KVM_INIT_H__
 #define __ARM_KVM_INIT_H__
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #error Assembly-only header
 #endif
 
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 3f93f4eef9530..d2779d604c7be 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -133,7 +133,7 @@
 #define ELF_ET_DYN_BASE		(2 * DEFAULT_MAP_WINDOW_64 / 3)
 #endif /* CONFIG_ARM64_FORCE_52BIT */
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <uapi/linux/elf.h>
 #include <linux/bug.h>
@@ -293,6 +293,6 @@ static inline int arch_check_elf(void *ehdr, bool has_interp,
 	return 0;
 }
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e1deed8244645..4975a92cbd17c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -431,7 +431,7 @@
 #define ESR_ELx_IT_GCSPOPCX		6
 #define ESR_ELx_IT_GCSPOPX		7
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <asm/types.h>
 
 static inline unsigned long esr_brk_comment(unsigned long esr)
@@ -534,6 +534,6 @@ static inline bool esr_iss_is_eretab(unsigned long esr)
 }
 
 const char *esr_get_class_string(unsigned long esr);
-#endif /* __ASSEMBLY */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_ESR_H */
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 635a43c4ec85b..65555284446e7 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -15,7 +15,7 @@
 #ifndef _ASM_ARM64_FIXMAP_H
 #define _ASM_ARM64_FIXMAP_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/kernel.h>
 #include <linux/math.h>
 #include <linux/sizes.h>
@@ -117,5 +117,5 @@ extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t pr
 
 #include <asm-generic/fixmap.h>
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 #endif /* _ASM_ARM64_FIXMAP_H */
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b8cf0ea43cc05..1d2e33559bd52 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -12,7 +12,7 @@
 #include <asm/sigcontext.h>
 #include <asm/sysreg.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/bitmap.h>
 #include <linux/build_bug.h>
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index ba7cf7fec5e97..1621c84f44b32 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -37,7 +37,7 @@
  */
 #define ARCH_FTRACE_SHIFT_STACK_TRACER 1
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/compat.h>
 
 extern void _mcount(unsigned long);
@@ -217,9 +217,9 @@ static inline bool arch_syscall_match_sym_name(const char *sym,
 	 */
 	return !strcmp(sym + 8, name);
 }
-#endif /* ifndef __ASSEMBLY__ */
+#endif /* ifndef __ASSEMBLER__ */
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
diff --git a/arch/arm64/include/asm/gpr-num.h b/arch/arm64/include/asm/gpr-num.h
index 05da4a7c5788f..a114e4f8209b0 100644
--- a/arch/arm64/include/asm/gpr-num.h
+++ b/arch/arm64/include/asm/gpr-num.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_GPR_NUM_H
 #define __ASM_GPR_NUM_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
 	.equ	.L__gpr_num_x\num, \num
@@ -11,7 +11,7 @@
 	.equ	.L__gpr_num_xzr, 31
 	.equ	.L__gpr_num_wzr, 31
 
-#else /* __ASSEMBLY__ */
+#else /* __ASSEMBLER__ */
 
 #define __DEFINE_ASM_GPR_NUMS					\
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
@@ -21,6 +21,6 @@
 "	.equ	.L__gpr_num_xzr, 31\n"				\
 "	.equ	.L__gpr_num_wzr, 31\n"
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_GPR_NUM_H */
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 6d567265467cc..1f63814ae6c4e 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -46,7 +46,7 @@
 #define COMPAT_HWCAP2_SB	(1 << 5)
 #define COMPAT_HWCAP2_SSBS	(1 << 6)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/log2.h>
 
 /*
diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index c09cf942dc92e..9ba85173f8576 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -20,7 +20,7 @@
 #define ARM64_IMAGE_FLAG_PAGE_SIZE_64K		3
 #define ARM64_IMAGE_FLAG_PHYS_BASE		1
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #define arm64_image_flag_field(flags, field) \
 				(((flags) >> field##_SHIFT) & field##_MASK)
@@ -54,6 +54,6 @@ struct arm64_image_header {
 	__le32 res5;
 };
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_IMAGE_H */
diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 18c7811774d30..e1d30ba99d016 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -12,7 +12,7 @@
 
 #include <asm/insn-def.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 enum aarch64_insn_hint_cr_op {
 	AARCH64_INSN_HINT_NOP	= 0x0 << 5,
@@ -730,6 +730,6 @@ u32 aarch32_insn_mcr_extract_crm(u32 insn);
 typedef bool (pstate_check_t)(unsigned long);
 extern pstate_check_t * const aarch32_opcode_cond_checks[16];
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif	/* __ASM_INSN_H */
diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
index 424ed421cd979..0cb211d3607d3 100644
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_JUMP_LABEL_H
 #define __ASM_JUMP_LABEL_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 #include <asm/insn.h>
@@ -58,5 +58,5 @@ static __always_inline bool arch_static_branch_jump(struct static_key * const ke
 	return true;
 }
 
-#endif  /* __ASSEMBLY__ */
+#endif  /* __ASSEMBLER__ */
 #endif	/* __ASM_JUMP_LABEL_H */
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index e1b57c13f8a41..b167e9d3da910 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/linkage.h>
 #include <asm/memory.h>
diff --git a/arch/arm64/include/asm/kexec.h b/arch/arm64/include/asm/kexec.h
index 4d9cc7a76d9ca..892e5bebda957 100644
--- a/arch/arm64/include/asm/kexec.h
+++ b/arch/arm64/include/asm/kexec.h
@@ -25,7 +25,7 @@
 
 #define KEXEC_ARCH KEXEC_ARCH_AARCH64
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /**
  * crash_setup_regs() - save registers for the panic kernel
@@ -130,6 +130,6 @@ extern int load_other_segments(struct kimage *image,
 		char *cmdline);
 #endif
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kgdb.h b/arch/arm64/include/asm/kgdb.h
index 3184f5d1e3ae4..67ef1c5532ae8 100644
--- a/arch/arm64/include/asm/kgdb.h
+++ b/arch/arm64/include/asm/kgdb.h
@@ -14,7 +14,7 @@
 #include <linux/ptrace.h>
 #include <asm/debug-monitors.h>
 
-#ifndef	__ASSEMBLY__
+#ifndef	__ASSEMBLER__
 
 static inline void arch_kgdb_breakpoint(void)
 {
@@ -36,7 +36,7 @@ static inline int kgdb_single_step_handler(struct pt_regs *regs,
 }
 #endif
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 /*
  * gdb remote procotol (well most versions of it) expects the following
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9da54d4ee49ee..4b34f7b7ed2fc 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -46,7 +46,7 @@
 
 #define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/mm.h>
 
@@ -303,7 +303,7 @@ void kvm_compute_final_ctr_el0(struct alt_instr *alt,
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
 	u64 elr_phys, u64 par, uintptr_t vcpu, u64 far, u64 hpfar);
 
-#else /* __ASSEMBLY__ */
+#else /* __ASSEMBLER__ */
 
 .macro get_host_ctxt reg, tmp
 	adr_this_cpu \reg, kvm_host_data, \tmp
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4069f2ce6423..2dc5e6e742bb0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -49,7 +49,7 @@
  * mappings, and none of this applies in that case.
  */
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 #include <asm/alternative.h>
 
@@ -396,5 +396,5 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
 static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
 #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_mte.h b/arch/arm64/include/asm/kvm_mte.h
index de002636eb1fb..3171963ad25ce 100644
--- a/arch/arm64/include/asm/kvm_mte.h
+++ b/arch/arm64/include/asm/kvm_mte.h
@@ -5,7 +5,7 @@
 #ifndef __ASM_KVM_MTE_H
 #define __ASM_KVM_MTE_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 #include <asm/sysreg.h>
 
@@ -62,5 +62,5 @@ alternative_else_nop_endif
 .endm
 
 #endif /* CONFIG_ARM64_MTE */
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_KVM_MTE_H */
diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index 6199c9f7ec6ed..e50987b32483b 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_KVM_PTRAUTH_H
 #define __ASM_KVM_PTRAUTH_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 #include <asm/sysreg.h>
 
@@ -100,7 +100,7 @@ alternative_else_nop_endif
 .endm
 #endif /* CONFIG_ARM64_PTR_AUTH */
 
-#else  /* !__ASSEMBLY */
+#else  /* !__ASSEMBLER__ */
 
 #define __ptrauth_save_key(ctxt, key)					\
 	do {								\
@@ -120,5 +120,5 @@ alternative_else_nop_endif
 		__ptrauth_save_key(ctxt, APGA);				\
 	} while(0)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_KVM_PTRAUTH_H */
diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index d3acd9c875091..40bd17add5397 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_LINKAGE_H
 #define __ASM_LINKAGE_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 #include <asm/assembler.h>
 #endif
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index f1505c4acb389..433513f590a3b 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -207,7 +207,7 @@
  */
 #define TRAMP_SWAPPER_OFFSET	(2 * PAGE_SIZE)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/bitops.h>
 #include <linux/compiler.h>
@@ -422,7 +422,7 @@ static inline unsigned long virt_to_pfn(const void *kaddr)
 })
 
 void dump_mem_limit(void);
-#endif /* !ASSEMBLY */
+#endif /* !__ASSEMBLER__ */
 
 /*
  * Given that the GIC architecture permits ITS implementations that can only be
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 78a4dbf75e602..137a173df1ff8 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -12,7 +12,7 @@
 #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/refcount.h>
 #include <asm/cpufeature.h>
@@ -112,5 +112,5 @@ void kpti_install_ng_mappings(void);
 static inline void kpti_install_ng_mappings(void) {}
 #endif
 
-#endif	/* !__ASSEMBLY__ */
+#endif	/* !__ASSEMBLER__ */
 #endif
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 0dbe3b29049b7..b4b361a4ec62c 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_MMU_CONTEXT_H
 #define __ASM_MMU_CONTEXT_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/compiler.h>
 #include <linux/sched.h>
@@ -330,6 +330,6 @@ static inline void deactivate_mm(struct task_struct *tsk,
 
 #include <asm-generic/mmu_context.h>
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* !__ASM_MMU_CONTEXT_H */
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 0f9b08e8fb8db..3521392719189 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -9,7 +9,7 @@
 #include <asm/cputype.h>
 #include <asm/mte-def.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -259,6 +259,6 @@ static inline int mte_enable_kernel_store_only(void)
 
 #endif /* CONFIG_ARM64_MTE */
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_MTE_KASAN_H  */
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 3b5069f4683d8..6d4a78b9dc3e6 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -8,7 +8,7 @@
 #include <asm/compiler.h>
 #include <asm/mte-def.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/bitfield.h>
 #include <linux/kasan-enabled.h>
@@ -282,5 +282,5 @@ static inline void mte_check_tfsr_exit(void)
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_MTE_H  */
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 2312e6ee595fd..0370a1534abc0 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -10,7 +10,7 @@
 
 #include <asm/page-def.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/personality.h> /* for READ_IMPLIES_EXEC */
 #include <linux/types.h> /* for gfp_t */
@@ -45,7 +45,7 @@ int pfn_is_map_memory(unsigned long pfn);
 
 #include <asm/memory.h>
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #define VM_DATA_DEFAULT_FLAGS	(VM_DATA_FLAGS_TSK_EXEC | VM_MTE_ALLOWED)
 
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 85dceb1c66f45..28460c826298b 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -62,7 +62,7 @@
 #define _PAGE_READONLY_EXEC	(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN)
 #define _PAGE_EXECONLY		(_PAGE_DEFAULT | PTE_RDONLY | PTE_NG | PTE_PXN)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/cpufeature.h>
 #include <asm/pgtable-types.h>
@@ -127,7 +127,7 @@ static inline bool __pure lpa2_is_enabled(void)
 #define PAGE_READONLY_EXEC	__pgprot(_PAGE_READONLY_EXEC)
 #define PAGE_EXECONLY		__pgprot(_PAGE_EXECONLY)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #define pte_pi_index(pte) ( \
 	((pte & BIT(PTE_PI_IDX_3)) >> (PTE_PI_IDX_3 - 3)) | \
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa89c2e67ebc8..26bb1421e63f2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -30,7 +30,7 @@
 
 #define vmemmap			((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/cmpxchg.h>
 #include <asm/fixmap.h>
@@ -1948,6 +1948,6 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/include/asm/proc-fns.h b/arch/arm64/include/asm/proc-fns.h
index 0d5d1f0525eb3..ab78a78821a2d 100644
--- a/arch/arm64/include/asm/proc-fns.h
+++ b/arch/arm64/include/asm/proc-fns.h
@@ -9,7 +9,7 @@
 #ifndef __ASM_PROCFNS_H
 #define __ASM_PROCFNS_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/page.h>
 
@@ -21,5 +21,5 @@ extern u64 cpu_do_resume(phys_addr_t ptr, u64 idmap_ttbr);
 
 #include <asm/memory.h>
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_PROCFNS_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 61d62bfd5a7bf..5acce7962228e 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -25,7 +25,7 @@
 
 #define MTE_CTRL_STORE_ONLY		(1UL << 19)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/build_bug.h>
 #include <linux/cache.h>
@@ -437,5 +437,5 @@ int set_tsc_mode(unsigned int val);
 #define GET_TSC_CTL(adr)        get_tsc_mode((adr))
 #define SET_TSC_CTL(val)        set_tsc_mode((val))
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 65b053a24d824..39582511ad72f 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -94,7 +94,7 @@
  */
 #define NO_SYSCALL (-1)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/bug.h>
 #include <linux/types.h>
 
@@ -361,5 +361,5 @@ static inline void procedure_link_pointer_set(struct pt_regs *regs,
 
 extern unsigned long profile_pc(struct pt_regs *regs);
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
index 6cb070eca9e9b..e19253f96c940 100644
--- a/arch/arm64/include/asm/rsi_smc.h
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -122,7 +122,7 @@
  */
 #define SMC_RSI_ATTESTATION_TOKEN_CONTINUE	SMC_RSI_FID(0x195)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 struct realm_config {
 	union {
@@ -142,7 +142,7 @@ struct realm_config {
 	 */
 } __aligned(0x1000);
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 /*
  * Read configuration for the current Realm.
diff --git a/arch/arm64/include/asm/rwonce.h b/arch/arm64/include/asm/rwonce.h
index 97d9256d33c97..78beceec10cda 100644
--- a/arch/arm64/include/asm/rwonce.h
+++ b/arch/arm64/include/asm/rwonce.h
@@ -5,7 +5,7 @@
 #ifndef __ASM_RWONCE_H
 #define __ASM_RWONCE_H
 
-#if defined(CONFIG_LTO) && !defined(__ASSEMBLY__)
+#if defined(CONFIG_LTO) && !defined(__ASSEMBLER__)
 
 #include <linux/compiler_types.h>
 #include <asm/alternative-macros.h>
@@ -62,7 +62,7 @@
 })
 
 #endif	/* !BUILD_VDSO */
-#endif	/* CONFIG_LTO && !__ASSEMBLY__ */
+#endif	/* CONFIG_LTO && !__ASSEMBLER__ */
 
 #include <asm-generic/rwonce.h>
 
diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
index a76f9b387a269..d31b128f683f6 100644
--- a/arch/arm64/include/asm/scs.h
+++ b/arch/arm64/include/asm/scs.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_SCS_H
 #define _ASM_SCS_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 #include <asm/asm-offsets.h>
 #include <asm/sysreg.h>
@@ -55,6 +55,6 @@ enum {
 
 int __pi_scs_patch(const u8 eh_frame[], int size);
 
-#endif /* __ASSEMBLY __ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_SCS_H */
diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
index 484cb6972e99a..b2248bd3cb58f 100644
--- a/arch/arm64/include/asm/sdei.h
+++ b/arch/arm64/include/asm/sdei.h
@@ -9,7 +9,7 @@
 
 #define SDEI_STACK_SIZE		IRQ_STACK_SIZE
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/linkage.h>
 #include <linux/preempt.h>
@@ -49,5 +49,5 @@ unsigned long do_sdei_event(struct pt_regs *regs,
 unsigned long sdei_arch_get_entry_point(int conduit);
 #define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif	/* __ASM_SDEI_H */
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index d48ef6d5abcc7..10ea4f5430690 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -23,7 +23,7 @@
 #define CPU_STUCK_REASON_52_BIT_VA	(UL(1) << CPU_STUCK_REASON_SHIFT)
 #define CPU_STUCK_REASON_NO_GRAN	(UL(2) << CPU_STUCK_REASON_SHIFT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/threads.h>
 #include <linux/cpumask.h>
@@ -155,6 +155,6 @@ bool cpus_are_stuck_in_kernel(void);
 extern void crash_smp_send_stop(void);
 extern bool smp_crash_stop_failed(void);
 
-#endif /* ifndef __ASSEMBLY__ */
+#endif /* ifndef __ASSEMBLER__ */
 
 #endif /* ifndef __ASM_SMP_H */
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index 8fef126260901..0527c53b0ec56 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -12,7 +12,7 @@
 #define BP_HARDEN_EL2_SLOTS 4
 #define __BP_HARDEN_HYP_VECS_SZ	((BP_HARDEN_EL2_SLOTS - 1) * SZ_2K)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/smp.h>
 #include <asm/percpu.h>
 
@@ -118,5 +118,5 @@ void spectre_bhb_patch_wa3(struct alt_instr *alt,
 void spectre_bhb_patch_clearbhb(struct alt_instr *alt,
 				__le32 *origptr, __le32 *updptr, int nr_inst);
 
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 #endif	/* __ASM_SPECTRE_H */
diff --git a/arch/arm64/include/asm/stacktrace/frame.h b/arch/arm64/include/asm/stacktrace/frame.h
index 0ee0f6ba0fd86..796797b8db7e5 100644
--- a/arch/arm64/include/asm/stacktrace/frame.h
+++ b/arch/arm64/include/asm/stacktrace/frame.h
@@ -25,7 +25,7 @@
 #define FRAME_META_TYPE_FINAL		1
 #define FRAME_META_TYPE_PT_REGS		2
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 /* 
  * A standard AAPCS64 frame record.
  */
@@ -43,6 +43,6 @@ struct frame_record_meta {
 	struct frame_record record;
 	u64 type;
 };
-#endif /* __ASSEMBLY */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_STACKTRACE_FRAME_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6455db1b54fd2..9c9a96643412d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -52,7 +52,7 @@
 
 #ifndef CONFIG_BROKEN_GAS_INST
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 // The space separator is omitted so that __emit_inst(x) can be parsed as
 // either an assembler directive or an assembler macro argument.
 #define __emit_inst(x)			.inst(x)
@@ -71,11 +71,11 @@
 					 (((x) >> 24) & 0x000000ff))
 #endif	/* CONFIG_CPU_BIG_ENDIAN */
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 #define __emit_inst(x)			.long __INSTR_BSWAP(x)
-#else  /* __ASSEMBLY__ */
+#else  /* __ASSEMBLER__ */
 #define __emit_inst(x)			".long " __stringify(__INSTR_BSWAP(x)) "\n\t"
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* CONFIG_BROKEN_GAS_INST */
 
@@ -1131,7 +1131,7 @@
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 	.macro	mrs_s, rt, sreg
 	 __emit_inst(0xd5200000|(\sreg)|(.L__gpr_num_\rt))
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 344b1c1a4bbb6..d316a804eb388 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -7,7 +7,7 @@
 #ifndef __ASM_SYSTEM_MISC_H
 #define __ASM_SYSTEM_MISC_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/compiler.h>
 #include <linux/linkage.h>
@@ -28,6 +28,6 @@ void arm64_notify_die(const char *str, struct pt_regs *regs,
 struct mm_struct;
 extern void __show_regs(struct pt_regs *);
 
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index f241b8601ebd9..a803b887b0b47 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -10,7 +10,7 @@
 
 #include <linux/compiler.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 struct task_struct;
 
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 18a5dc0c9a540..ef61b68df3476 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_TLBFLUSH_H
 #define __ASM_TLBFLUSH_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/bitfield.h>
 #include <linux/mm_types.h>
diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
index 61679070f595c..232b469690882 100644
--- a/arch/arm64/include/asm/vdso.h
+++ b/arch/arm64/include/asm/vdso.h
@@ -7,7 +7,7 @@
 
 #define __VDSO_PAGES    4
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <generated/vdso-offsets.h>
 
@@ -19,6 +19,6 @@
 extern char vdso_start[], vdso_end[];
 extern char vdso32_start[], vdso32_end[];
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_VDSO_H */
diff --git a/arch/arm64/include/asm/vdso/compat_barrier.h b/arch/arm64/include/asm/vdso/compat_barrier.h
index 6d75e03d38274..d7ebe7ceefa00 100644
--- a/arch/arm64/include/asm/vdso/compat_barrier.h
+++ b/arch/arm64/include/asm/vdso/compat_barrier.h
@@ -5,7 +5,7 @@
 #ifndef __COMPAT_BARRIER_H
 #define __COMPAT_BARRIER_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 /*
  * Warning: This code is meant to be used from the compat vDSO only.
  */
@@ -31,6 +31,6 @@
 #define smp_rmb()	aarch32_smp_rmb()
 #define smp_wmb()	aarch32_smp_wmb()
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __COMPAT_BARRIER_H */
diff --git a/arch/arm64/include/asm/vdso/compat_gettimeofday.h b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
index 7d1a116549b1b..0d513f924321f 100644
--- a/arch/arm64/include/asm/vdso/compat_gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
@@ -5,7 +5,7 @@
 #ifndef __ASM_VDSO_COMPAT_GETTIMEOFDAY_H
 #define __ASM_VDSO_COMPAT_GETTIMEOFDAY_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/barrier.h>
 #include <asm/unistd_compat_32.h>
@@ -161,6 +161,6 @@ static inline bool vdso_clocksource_ok(const struct vdso_clock *vc)
 }
 #define vdso_clocksource_ok	vdso_clocksource_ok
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_VDSO_COMPAT_GETTIMEOFDAY_H */
diff --git a/arch/arm64/include/asm/vdso/getrandom.h b/arch/arm64/include/asm/vdso/getrandom.h
index a2197da1951b0..da1d58bbfabe8 100644
--- a/arch/arm64/include/asm/vdso/getrandom.h
+++ b/arch/arm64/include/asm/vdso/getrandom.h
@@ -3,7 +3,7 @@
 #ifndef __ASM_VDSO_GETRANDOM_H
 #define __ASM_VDSO_GETRANDOM_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/unistd.h>
 #include <asm/vdso/vsyscall.h>
@@ -33,6 +33,6 @@ static __always_inline ssize_t getrandom_syscall(void *_buffer, size_t _len, uns
 	return ret;
 }
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_VDSO_GETRANDOM_H */
diff --git a/arch/arm64/include/asm/vdso/gettimeofday.h b/arch/arm64/include/asm/vdso/gettimeofday.h
index c59e84105b43c..3658a757e255d 100644
--- a/arch/arm64/include/asm/vdso/gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/gettimeofday.h
@@ -7,7 +7,7 @@
 
 #ifdef __aarch64__
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/alternative.h>
 #include <asm/arch_timer.h>
@@ -96,7 +96,7 @@ static __always_inline const struct vdso_time_data *__arch_get_vdso_u_time_data(
 #define __arch_get_vdso_u_time_data __arch_get_vdso_u_time_data
 #endif /* IS_ENABLED(CONFIG_CC_IS_GCC) && IS_ENABLED(CONFIG_PAGE_SIZE_64KB) */
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #else /* !__aarch64__ */
 
diff --git a/arch/arm64/include/asm/vdso/processor.h b/arch/arm64/include/asm/vdso/processor.h
index ff830b766ad2d..7abb0cc81cd6e 100644
--- a/arch/arm64/include/asm/vdso/processor.h
+++ b/arch/arm64/include/asm/vdso/processor.h
@@ -5,13 +5,13 @@
 #ifndef __ASM_VDSO_PROCESSOR_H
 #define __ASM_VDSO_PROCESSOR_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
 }
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_VDSO_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 417aae5763a86..3f3c8eb74e2e3 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_VDSO_VSYSCALL_H
 #define __ASM_VDSO_VSYSCALL_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <vdso/datapage.h>
 
@@ -22,6 +22,6 @@ void __arch_update_vdso_clock(struct vdso_clock *vc)
 /* The asm-generic header needs to be included after the definitions above */
 #include <asm-generic/vdso/vsyscall.h>
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_VDSO_VSYSCALL_H */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index aa280f356b96a..530af9620fdba 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -56,7 +56,7 @@
  */
 #define BOOT_CPU_FLAG_E2H	BIT_ULL(32)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/ptrace.h>
 #include <asm/sections.h>
@@ -161,6 +161,6 @@ static inline bool is_hyp_nvhe(void)
 	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
 }
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
index 139d5e87dc959..b35d954d50c3f 100644
--- a/tools/arch/arm64/include/asm/cputype.h
+++ b/tools/arch/arm64/include/asm/cputype.h
@@ -245,7 +245,7 @@
 #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
 #define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm/sysreg.h>
 
@@ -338,6 +338,6 @@ static inline u32 __attribute_const__ read_cpuid_cachetype(void)
 {
 	return read_cpuid(CTR_EL0);
 }
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/tools/arch/arm64/include/asm/esr.h b/tools/arch/arm64/include/asm/esr.h
index bd592ca815711..bbfbd1497a2f8 100644
--- a/tools/arch/arm64/include/asm/esr.h
+++ b/tools/arch/arm64/include/asm/esr.h
@@ -385,7 +385,7 @@
 #define ESR_ELx_MOPS_ISS_SRCREG(esr)	(((esr) & (UL(0x1f) << 5)) >> 5)
 #define ESR_ELx_MOPS_ISS_SIZEREG(esr)	(((esr) & (UL(0x1f) << 0)) >> 0)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <asm/types.h>
 
 static inline unsigned long esr_brk_comment(unsigned long esr)
@@ -450,6 +450,6 @@ static inline bool esr_iss_is_eretab(unsigned long esr)
 }
 
 const char *esr_get_class_string(unsigned long esr);
-#endif /* __ASSEMBLY */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_ESR_H */
diff --git a/tools/arch/arm64/include/asm/gpr-num.h b/tools/arch/arm64/include/asm/gpr-num.h
index 05da4a7c5788f..a114e4f8209b0 100644
--- a/tools/arch/arm64/include/asm/gpr-num.h
+++ b/tools/arch/arm64/include/asm/gpr-num.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_GPR_NUM_H
 #define __ASM_GPR_NUM_H
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
 	.equ	.L__gpr_num_x\num, \num
@@ -11,7 +11,7 @@
 	.equ	.L__gpr_num_xzr, 31
 	.equ	.L__gpr_num_wzr, 31
 
-#else /* __ASSEMBLY__ */
+#else /* __ASSEMBLER__ */
 
 #define __DEFINE_ASM_GPR_NUMS					\
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
@@ -21,6 +21,6 @@
 "	.equ	.L__gpr_num_xzr, 31\n"				\
 "	.equ	.L__gpr_num_wzr, 31\n"
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_GPR_NUM_H */
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 65f2759ea27a3..10c457d468e82 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -51,7 +51,7 @@
 
 #ifndef CONFIG_BROKEN_GAS_INST
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 // The space separator is omitted so that __emit_inst(x) can be parsed as
 // either an assembler directive or an assembler macro argument.
 #define __emit_inst(x)			.inst(x)
@@ -70,11 +70,11 @@
 					 (((x) >> 24) & 0x000000ff))
 #endif	/* CONFIG_CPU_BIG_ENDIAN */
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 #define __emit_inst(x)			.long __INSTR_BSWAP(x)
-#else  /* __ASSEMBLY__ */
+#else  /* __ASSEMBLER__ */
 #define __emit_inst(x)			".long " __stringify(__INSTR_BSWAP(x)) "\n\t"
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* CONFIG_BROKEN_GAS_INST */
 
@@ -1080,7 +1080,7 @@
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 
 	.macro	mrs_s, rt, sreg
 	 __emit_inst(0xd5200000|(\sreg)|(.L__gpr_num_\rt))
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c7..a792a599b9d68 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -31,7 +31,7 @@
 #define KVM_SPSR_FIQ	4
 #define KVM_NR_SPSR	5
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
-- 
2.51.0

