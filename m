Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CAA4FECC2
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024453; cv=none; b=MzuHUYWwveU7Z6fa0hBltmU+MCDgLEFc2BQZM1PFcsNqAh0p3uaFrzgdsjKI/fcpCC2bueu8dArBwvz29L+n9aVeHC82hKExAYijxDGLxj8GnCQfc8E9bQZZt6hIc004Dpem7vhoeNyl7vwfe9amFadThgKP179dy8HJTnDQLDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024453; c=relaxed/simple;
	bh=SgpNP2aXYqqNHqB8m18nlPiiB4IzRW/48HyHRmO8h6w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHwiwFpBXtABXMwt7Drj210YsHIDtbRr5KuJ1jJ0cnFsk+HPlWi0AziM9kYaBkppn7JmZU7chd4FAwK+D55f2HS2jNBLbTB9gez5JFA4A5bRC1aYyprL3zX7LkOHl10UdaiIoyggk9Cl+K2FH6a/AmXNCLrcXKJ2fcs7X5w+IBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=bvRSxSw6; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="bvRSxSw6"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-86162c086f8so2622857b3.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024447; x=1790629247; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+AapHyPdj0IG1/8SeVa+6rawGDrQYdQ9Zai/HsEKlQY=;
        b=bvRSxSw6yxyzhVTT3EZ3HNcrlVoxEB5jmhCon8JtIlr1f0St3YppEECCaRxZmVQB/d
         1HPp2Wqpu7QL/PLnQ+MUMvm5/IosK/hxJI9YzuexpCpWvF+TzOozoZRtS65LAipP+ltN
         ncUpEhGgACXA3HMRDEjXQy//aXDtuU0ko+Mbyu65ZwkicFRinhi/VMV1q4BV2bJIZeLd
         ANj9RBonfWW/113q8WJmxSa7e6ho37uy5XH2vy5TvX9iEeT1OfHpZ1od9mcD+6p4PAHX
         jHNzId/4Rz3u9F7y97HdyVhg0WQ06jzB56/hOyOXjVg2bR0zhItVGkRbVPu5eJIyfJ6n
         ZxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024447; x=1790629247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+AapHyPdj0IG1/8SeVa+6rawGDrQYdQ9Zai/HsEKlQY=;
        b=1ocH7EWL+Vxw/XJVuwwHVGpcwM8oSVbJi0e45+3KL5maPMp9qgj/pINPdu1GzUgO17
         wdWI/al3Dsq8GxJNupVLsNAJ68BZElQM4na1WQ05JQzwaFk9EkWLxicd9okJI0z8scgT
         jY7fmAGLeQ8GqYpj4R19hMletB7hzO9orjrCqvKCNJ/ehVxMYRPwUAcCtzUZjbdOz5j6
         OGlvfdMzgWBRQIuo2dLJwleEnGsJ8sl09MQMTDaYhQxGZ/rBQZCRji4/CbXXJQ9X2bEL
         XOou8Y9ZgaUxZLBU+k5jmu9/led6QtTgR3xqFeHsh2dSuLT15ROCtJKlcWpEefsAFQHW
         n5XA==
X-Forwarded-Encrypted: i=1; AKwUvBz2k3M8Q8ksKNd3gDKAitGgzxBeP+Dr+gg6782i8LkRiIsB8P0L5rUnSquHP9ZtfWz4/+NnPXI=@lists.linux.dev
X-Gm-Message-State: AFuF++mJAmhkrZ7aAloPKfoyDCCue2G+WVAnpvJSoFp2vDckUEhvxMLJ
	31RDGI5iR76/A5mO9FlPNQMNliI6uv0UTyx4ZKmyWkw/3oQxNG/tBC3yQL+EdgF0eFM=
X-Gm-Gg: AYBFou2jT13HM3Yqrntiy1DKsaDBgm7D7pEr3oBT435E/swpEwaGAxFJzh7/YOZ0VPe
	+jNk89LWQiV5V1CHoIkNrK/rg7n9WaZky0NRQqqGN9y4FXY4UrlTXeFG0CddK1/+574D3UAi0vP
	nEfvL508nxSwrKLp4URa1cnVUAt3491Z4UWxcMy0qk4kmXwE1Pg4zaHrM8aHj0fdbpQYiR/n2py
	t7wrpNM/Hto+mgbFWKk/QNDnO92IZqGqqx2LzseVXghxHkG/f7x5jT4QNgzo1KXrGoy1LpqEN/t
	o1fCjciYxxjFC7BFmu+UGd9yXPOoKcXNAHnv2emaT2F5ptvViKRt2ZWHqzmaEfBP9Fp8rXFT1Nc
	tSFGkE5DZM3mOBr2omsha7fAiaZEw6hGpjMGTNS3d/DAEWDUFRcYsGzSpnQcIf+TaQHerr0x87c
	/MJ20OteNX786P6MbgHUXvpv78AHRoc7gwQAhjxe+A/8YgMBPETeOXGcM83YoU2cmFQBRpwbO99
	J5ZOrIAjM+VaU+190VTHjiK4XaiJcdHE/l13nGwkuW5LS6G2DWMaA5wcun7vA4eFnSEWr0OYT81
	ubWkiLCg7iBskUs8Y1o=
X-Received: by 2002:a05:690c:e21c:20b0:88f:3bb:8715 with SMTP id 00721157ae682-8a1f9dfc896mr3076587b3.33.1790024446939;
        Mon, 21 Sep 2026 14:00:46 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:46 -0700 (PDT)
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
Subject: [RFC PATCH 42/46] KVM: arm64: Add Caretaker arm64 KHO ABI and runtime context headers
Date: Mon, 21 Sep 2026 17:00:30 -0400
Message-ID: <20260921210034.180424-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define struct kvm_caretaker_arch_ser (256B), ARM64 Caretaker runtime
context structures, and EL2 exception vector interfaces.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/include/asm/caretaker.h |  56 ++++++
 arch/arm64/kernel/cpu_preserve.c   | 309 +++++++++++++++++++++++++++++
 arch/arm64/kvm/caretaker.h         | 130 ++++++++++++
 include/linux/kho/abi/kvm_arm64.h  |  32 +++
 4 files changed, 527 insertions(+)
 create mode 100644 arch/arm64/include/asm/caretaker.h
 create mode 100644 arch/arm64/kvm/caretaker.h

diff --git a/arch/arm64/include/asm/caretaker.h b/arch/arm64/include/asm/caretaker.h
new file mode 100644
index 000000000000..7683534a28f8
--- /dev/null
+++ b/arch/arm64/include/asm/caretaker.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __ASM_ARM64_CARETAKER_H
+#define __ASM_ARM64_CARETAKER_H
+
+#include <linux/types.h>
+#include <linux/cpu_preserve.h>
+#include <asm/arch_timer.h>
+#include <asm/cputype.h>
+#include <asm/pgtable-types.h>
+#include <asm/sysreg.h>
+
+#ifdef CONFIG_LIVEUPDATE_CPU
+extern phys_addr_t arm64_caretaker_pgd_pa;
+#else
+#define arm64_caretaker_pgd_pa 0ULL
+#endif
+
+extern char caretaker_hyp_vector[];
+
+extern bool arm64_caretaker_has_ptrauth;
+
+static inline int arm64_caretaker_get_pcpu(void)
+{
+	u64 mpidr = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
+	int cpu = arch_cpu_preserved_mpidr_to_cpu(mpidr);
+
+	if (cpu >= 0)
+		return cpu;
+	return (int)MPIDR_AFFINITY_LEVEL(mpidr, 0);
+}
+
+#ifdef CONFIG_LIVEUPDATE_CPU
+void gicv3_caretaker_clear_active_priorities(void);
+void gicv3_caretaker_enable_sgi(void);
+void gicv3_caretaker_clear_sgi(void);
+void gicv3_caretaker_kick_cpu(int cpu);
+int gicv3_caretaker_get_redist_region(int idx, phys_addr_t *pa,
+				      unsigned long *va, size_t *size);
+#else
+static inline void gicv3_caretaker_clear_active_priorities(void) {}
+static inline void gicv3_caretaker_enable_sgi(void) {}
+static inline void gicv3_caretaker_clear_sgi(void) {}
+static inline void gicv3_caretaker_kick_cpu(int cpu) {}
+static inline int gicv3_caretaker_get_redist_region(int idx, phys_addr_t *pa,
+						    unsigned long *va,
+						    size_t *size)
+{
+	return -ENOENT;
+}
+#endif
+
+#endif /* __ASM_ARM64_CARETAKER_H */
diff --git a/arch/arm64/kernel/cpu_preserve.c b/arch/arm64/kernel/cpu_preserve.c
index 15de1ca09062..21e12ba6c788 100644
--- a/arch/arm64/kernel/cpu_preserve.c
+++ b/arch/arm64/kernel/cpu_preserve.c
@@ -7,16 +7,23 @@
  */
 #include <linux/arm-smccc.h>
 #include <linux/cpu_preserve.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/cpu.h>
+#include <linux/kvm_host.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/psci.h>
 #include <linux/sched/mm.h>
 #include <uapi/linux/psci.h>
 
 #include <asm/barrier.h>
 #include <linux/cacheflush.h>
+#include <asm/caretaker.h>
 #include <asm/cpu_ops.h>
 #include <asm/daifflags.h>
 #include <asm/kernel-pgtable.h>
@@ -27,9 +34,40 @@
 #include <asm/trans_pgd.h>
 #include <asm/virt.h>
 
+#define CARETAKER_RWP_TIMEOUT_COUNT	1000000
+#define CARETAKER_SGI_MASK		GENMASK(15, 0)
+#define CARETAKER_HYP_TIMER_PPI		26
+#define CARETAKER_HYP_VIRT_TIMER_PPI	30
+#define GICR_INT_PRIORITY(intid)	(GICR_IPRIORITYR0 + (intid))
+#define CARETAKER_MAX_RDIST_REGIONS	8
+
+#define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
+	(MPIDR_AFFINITY_LEVEL(cluster_id, level) \
+		<< ICC_SGI1R_AFFINITY_## level ##_SHIFT)
+#define MPIDR_TO_SGI_CLUSTER_ID(mpidr)	((mpidr) & ~0xFUL)
+#define MPIDR_RS(mpidr)			(((mpidr) & 0xf0ULL) >> 4)
+#define MPIDR_TO_SGI_RS(mpidr)		(MPIDR_RS(mpidr) << ICC_SGI1R_RS_SHIFT)
+
+struct caretaker_rdist_region {
+	phys_addr_t	pa;
+	void __iomem	*va;
+	size_t		size;
+};
+
+struct caretaker_gic_state {
+	void __iomem			*cpu_rdist[NR_CPUS];
+	struct caretaker_rdist_region	regions[CARETAKER_MAX_RDIST_REGIONS];
+	int				nr_regions;
+};
+
 static enum arm_smccc_conduit arm64_psci_conduit __cpu_preserved_data;
 phys_addr_t arm64_caretaker_pgd_pa __cpu_preserved_data;
 static u64 arm64_cpu_mpidr[NR_CPUS] __cpu_preserved_data;
+static struct caretaker_gic_state caretaker_gic __cpu_preserved_data;
+__cpu_preserved_data bool arm64_caretaker_has_ptrauth;
+EXPORT_SYMBOL_GPL(arm64_caretaker_has_ptrauth);
+
+static void arm64_caretaker_gic_init(void);
 
 /*
  * Signal or wake up a preserved physical CPU via SEV.
@@ -38,6 +76,7 @@ void __cpu_preserved_text arch_cpu_preserved_kick(int cpu)
 {
 	dsb(ishst);
 	sev();
+	gicv3_caretaker_kick_cpu(cpu);
 	isb();
 }
 
@@ -61,6 +100,261 @@ int __cpu_preserved_text arch_cpu_preserved_mpidr_to_cpu(u64 mpidr)
 }
 EXPORT_SYMBOL_GPL(arch_cpu_preserved_mpidr_to_cpu);
 
+__cpu_preserved_text static void __iomem *gicv3_get_rdist_for_cpu(int cpu)
+{
+	if (cpu < 0) {
+		u64 mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
+
+		cpu = arch_cpu_preserved_mpidr_to_cpu(mpidr);
+	}
+	if (cpu >= 0 && cpu < ARRAY_SIZE(caretaker_gic.cpu_rdist))
+		return caretaker_gic.cpu_rdist[cpu];
+	return NULL;
+}
+
+__cpu_preserved_text static inline void
+gicv3_caretaker_wait_for_rwp(void __iomem *base, u32 bit)
+{
+	int count = CARETAKER_RWP_TIMEOUT_COUNT;
+
+	while (count-- > 0) {
+		if (!(readl_relaxed(base + GICR_CTLR) & bit))
+			return;
+		cpu_relax();
+	}
+}
+
+__cpu_preserved_text void gicv3_caretaker_clear_active_priorities(void)
+{
+	u32 ctlr = read_sysreg_s(SYS_ICC_CTLR_EL1);
+	u32 pribits = ((ctlr & ICC_CTLR_EL1_PRI_BITS_MASK) >>
+		       ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
+
+	switch (pribits) {
+	case 8:
+	case 7:
+		write_sysreg_s(0, SYS_ICC_AP1R3_EL1);
+		write_sysreg_s(0, SYS_ICC_AP1R2_EL1);
+		fallthrough;
+	case 6:
+		write_sysreg_s(0, SYS_ICC_AP1R1_EL1);
+		fallthrough;
+	case 5:
+	case 4:
+	default:
+		write_sysreg_s(0, SYS_ICC_AP1R0_EL1);
+		break;
+	}
+	isb();
+}
+EXPORT_SYMBOL_GPL(gicv3_caretaker_clear_active_priorities);
+
+__cpu_preserved_text void gicv3_caretaker_enable_sgi(void)
+{
+	void __iomem *ptr = gicv3_get_rdist_for_cpu(-1);
+
+	if (ptr) {
+		void __iomem *rbase = ptr + SZ_64K;
+
+		writel_relaxed(~0U, rbase + GICR_IGROUPR0);
+		writel_relaxed(0, rbase + GICR_IGRPMODR0);
+		writeb_relaxed(0x00, rbase + GICR_INT_PRIORITY(0));
+		writeb_relaxed(0x00, rbase + GICR_INT_PRIORITY(CARETAKER_HYP_TIMER_PPI));
+		writeb_relaxed(0x00, rbase + GICR_INT_PRIORITY(CARETAKER_HYP_VIRT_TIMER_PPI));
+		writel_relaxed(CARETAKER_SGI_MASK |
+			       BIT(CARETAKER_HYP_TIMER_PPI) |
+			       BIT(CARETAKER_HYP_VIRT_TIMER_PPI),
+			       rbase + GICR_ISENABLER0);
+		writel_relaxed(~0U, rbase + GICR_ICACTIVER0);
+		gicv3_caretaker_wait_for_rwp(ptr, GICR_CTLR_RWP);
+	}
+
+	write_sysreg_s(0, SYS_ICC_BPR1_EL1);
+	gicv3_caretaker_clear_active_priorities();
+}
+EXPORT_SYMBOL_GPL(gicv3_caretaker_enable_sgi);
+
+__cpu_preserved_text void gicv3_caretaker_clear_sgi(void)
+{
+	void __iomem *ptr = gicv3_get_rdist_for_cpu(-1);
+
+	if (ptr) {
+		void __iomem *rbase = ptr + SZ_64K;
+
+		writel_relaxed(~0U, rbase + GICR_ICPENDR0);
+		writel_relaxed(~0U, rbase + GICR_ICACTIVER0);
+		gicv3_caretaker_wait_for_rwp(ptr, GICR_CTLR_RWP);
+	}
+}
+EXPORT_SYMBOL_GPL(gicv3_caretaker_clear_sgi);
+
+__cpu_preserved_text void gicv3_caretaker_kick_cpu(int cpu)
+{
+	u64 mpidr, cluster_id, sgi1r;
+	void __iomem *ptr;
+	u16 tlist;
+
+	if (cpu < 0 || cpu >= ARRAY_SIZE(arm64_cpu_mpidr))
+		return;
+
+	cpu = array_index_nospec(cpu, ARRAY_SIZE(arm64_cpu_mpidr));
+	mpidr = arm64_cpu_mpidr[cpu];
+	if ((mpidr & MPIDR_HWID_BITMASK) == (read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK))
+		return;
+
+	ptr = gicv3_get_rdist_for_cpu(cpu);
+	if (ptr) {
+		void __iomem *sgi_base = ptr + SZ_64K;
+		u32 val = readl_relaxed(ptr + GICR_WAKER);
+
+		if (val & GICR_WAKER_ProcessorSleep) {
+			int count = CARETAKER_RWP_TIMEOUT_COUNT;
+
+			val &= ~GICR_WAKER_ProcessorSleep;
+			writel_relaxed(val, ptr + GICR_WAKER);
+			while (count-- > 0) {
+				val = readl_relaxed(ptr + GICR_WAKER);
+				if (!(val & GICR_WAKER_ChildrenAsleep))
+					break;
+				cpu_relax();
+			}
+		}
+
+		writel_relaxed(~0U, sgi_base + GICR_IGROUPR0);
+		writel_relaxed(0, sgi_base + GICR_IGRPMODR0);
+		writel_relaxed(0, sgi_base + GICR_INT_PRIORITY(0));
+		writel_relaxed(0, sgi_base + GICR_INT_PRIORITY(4));
+		writel_relaxed(0, sgi_base + GICR_INT_PRIORITY(8));
+		writel_relaxed(0, sgi_base + GICR_INT_PRIORITY(12));
+		writel_relaxed(CARETAKER_SGI_MASK | BIT(CARETAKER_HYP_TIMER_PPI),
+			       sgi_base + GICR_ISENABLER0);
+		gicv3_caretaker_wait_for_rwp(ptr, GICR_CTLR_RWP);
+	}
+
+	cluster_id = MPIDR_TO_SGI_CLUSTER_ID(mpidr);
+	tlist = 1 << (mpidr & 0xf);
+
+	dsb(ishst);
+	sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3) |
+		 MPIDR_TO_SGI_AFFINITY(cluster_id, 2) |
+		 (0ULL << ICC_SGI1R_SGI_ID_SHIFT) |
+		 MPIDR_TO_SGI_AFFINITY(cluster_id, 1) |
+		 MPIDR_TO_SGI_RS(cluster_id) |
+		 ((u64)tlist << ICC_SGI1R_TARGET_LIST_SHIFT));
+	write_sysreg_s(sgi1r, SYS_ICC_SGI1R_EL1);
+	isb();
+}
+EXPORT_SYMBOL_GPL(gicv3_caretaker_kick_cpu);
+
+static void arm64_add_gicr_region(phys_addr_t pa, size_t size, u64 stride)
+{
+	void __iomem *va, *ptr;
+	size_t map_size;
+	int i;
+
+	for (i = 0; i < caretaker_gic.nr_regions; i++)
+		if (caretaker_gic.regions[i].pa == pa)
+			return;
+
+	if (caretaker_gic.nr_regions >= ARRAY_SIZE(caretaker_gic.regions))
+		return;
+
+	map_size = max_t(size_t, size, nr_cpu_ids * (stride ? : SZ_128K));
+	va = ioremap(pa, map_size);
+	if (!va)
+		return;
+
+	i = caretaker_gic.nr_regions++;
+	caretaker_gic.regions[i].pa = pa;
+	caretaker_gic.regions[i].va = va;
+	caretaker_gic.regions[i].size = map_size;
+
+	ptr = va;
+	do {
+		u64 typer = readq_relaxed(ptr + GICR_TYPER);
+		u32 aff = typer >> 32;
+		int cpu;
+		bool last = !!(typer & GICR_TYPER_LAST);
+
+		for_each_possible_cpu(cpu) {
+			u64 mpidr = cpu_logical_map(cpu);
+			u32 cpu_aff = (MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24) |
+				      (MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16) |
+				      (MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8) |
+				      MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			if (aff == cpu_aff)
+				caretaker_gic.cpu_rdist[cpu] = ptr;
+		}
+
+		if (stride) {
+			ptr += stride;
+		} else {
+			ptr += SZ_64K * 2;
+			if (typer & GICR_TYPER_VLPIS)
+				ptr += SZ_64K * 2;
+		}
+		if (last)
+			break;
+	} while ((ptr - va) < map_size);
+
+	cpu_preserved_clean(&caretaker_gic);
+}
+
+static void arm64_discover_gicr_res(struct resource *res)
+{
+	for (; res; res = res->sibling) {
+		if (res->name && !strcmp(res->name, "GICR"))
+			arm64_add_gicr_region(res->start, resource_size(res), 0);
+		if (res->child)
+			arm64_discover_gicr_res(res->child);
+	}
+}
+
+static void arm64_caretaker_gic_init(void)
+{
+	struct device_node *node;
+
+	if (caretaker_gic.nr_regions > 0 || arch_cpu_preserved_is_active())
+		return;
+
+	node = of_find_compatible_node(NULL, NULL, "arm,gic-v3");
+	if (node) {
+		u32 nr_redist_regions = 1;
+		u64 stride = 0;
+		int i;
+
+		of_property_read_u32(node, "#redistributor-regions",
+				     &nr_redist_regions);
+		of_property_read_u64(node, "redistributor-stride", &stride);
+		for (i = 0; i < nr_redist_regions; i++) {
+			struct resource res;
+
+			if (of_address_to_resource(node, 1 + i, &res) == 0)
+				arm64_add_gicr_region(res.start,
+						      resource_size(&res),
+						      stride);
+		}
+		of_node_put(node);
+	}
+
+	if (caretaker_gic.nr_regions == 0)
+		arm64_discover_gicr_res(&iomem_resource);
+}
+
+int gicv3_caretaker_get_redist_region(int idx, phys_addr_t *pa,
+				      unsigned long *va, size_t *size)
+{
+	arm64_caretaker_gic_init();
+	if (idx < 0 || idx >= caretaker_gic.nr_regions)
+		return -ENOENT;
+
+	*pa = caretaker_gic.regions[idx].pa;
+	*va = (unsigned long)caretaker_gic.regions[idx].va;
+	*size = caretaker_gic.regions[idx].size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gicv3_caretaker_get_redist_region);
+
 bool __cpu_preserved_text arch_cpu_preserved_is_active(void)
 {
 	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
@@ -240,6 +534,7 @@ int arch_cpu_preserved_setup_buffer(struct page *text_page,
 	for (i = 0; i < nr_cpu_ids; i++)
 		arm64_cpu_mpidr[i] = cpu_logical_map(i);
 	cpu_preserved_clean(&arm64_cpu_mpidr);
+	arm64_caretaker_gic_init();
 
 	return 0;
 }
@@ -260,11 +555,18 @@ void __cpu_preserved_text arch_cpu_preserved_park_init(int cpu)
 	local_daif_mask();
 	cpu_preserved_inval(&arm64_psci_conduit);
 	cpu_preserved_inval(&arm64_cpu_mpidr);
+	cpu_preserved_inval(&caretaker_gic);
 	if (!pgd_pa) {
 		cpu_preserved_inval(&arm64_caretaker_pgd_pa);
 		pgd_pa = READ_ONCE(arm64_caretaker_pgd_pa);
 	}
 
+#if IS_ENABLED(CONFIG_KVM_CARETAKER)
+	write_sysreg((unsigned long)caretaker_hyp_vector, vbar_el1);
+	write_sysreg_s((unsigned long)caretaker_hyp_vector, SYS_VBAR_EL2);
+	isb();
+#endif
+
 	write_sysreg(0, ttbr0_el1);
 	if (pgd_pa)
 		write_sysreg(pgd_pa, ttbr1_el1);
@@ -272,6 +574,8 @@ void __cpu_preserved_text arch_cpu_preserved_park_init(int cpu)
 	arm64_flush_host_tlb_local();
 
 	write_sysreg_s(0xff, SYS_ICC_PMR_EL1);
+	isb();
+
 	write_sysreg_s(1, SYS_ICC_IGRPEN1_EL1);
 	isb();
 }
@@ -283,12 +587,17 @@ void arch_cpu_preserved_early_init(void)
 	for (c = 0; c < ARRAY_SIZE(arm64_cpu_mpidr); c++)
 		arm64_cpu_mpidr[c] = cpu_logical_map(c);
 	cpu_preserved_clean(&arm64_cpu_mpidr);
+	arm64_caretaker_gic_init();
 
 	cpu_preserved_inval(&arm64_psci_conduit);
 	if (arm64_psci_conduit == SMCCC_CONDUIT_NONE) {
 		arm64_psci_conduit = arm_smccc_1_1_get_conduit();
 		cpu_preserved_clean(&arm64_psci_conduit);
 	}
+
+	arm64_caretaker_has_ptrauth = IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
+				      system_has_full_ptr_auth();
+	cpu_preserved_clean(&arm64_caretaker_has_ptrauth);
 }
 EXPORT_SYMBOL_GPL(arch_cpu_preserved_early_init);
 
diff --git a/arch/arm64/kvm/caretaker.h b/arch/arm64/kvm/caretaker.h
new file mode 100644
index 000000000000..97271a49f5a8
--- /dev/null
+++ b/arch/arm64/kvm/caretaker.h
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Header for ARM64 KVM Caretaker execution engine and helpers.
+ */
+#ifndef __ARCH_ARM64_KVM_CARETAKER_H
+#define __ARCH_ARM64_KVM_CARETAKER_H
+
+#define CAP_FAULT_ESR		0x00
+#define CAP_FAULT_FAR		0x08
+#define CAP_FAULT_HPFAR		0x10
+#define CAP_CTXT_OFFSET		0x20
+
+/* Special INTID range (1020-1023) reserved by GIC architecture */
+#define GIC_SPECIAL_INTID_START	1020
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/sizes.h>
+#include <linux/oncore.h>
+#include <linux/kvm_host.h>
+#include <linux/kho/abi/kvm_arm64.h>
+#include <linux/kvm_caretaker.h>
+#include <linux/irqchip/arm-gic-v3.h>
+#include <asm/esr.h>
+
+/* Default priority for software-injected SGIs */
+#define GIC_DEFAULT_SGI_PRIO		0xa0ULL
+
+/* System register opcodes for SGI generation */
+#define ESR_ELx_SYS64_ISS_SYS_ICC_SGI1R_EL1 \
+	(ESR_ELx_SYS64_ISS_SYS_VAL(3, 0, 5, 12, 11) | ESR_ELx_SYS64_ISS_DIR_WRITE)
+#define ESR_ELx_SYS64_ISS_SYS_ICC_ASGI1R_EL1 \
+	(ESR_ELx_SYS64_ISS_SYS_VAL(3, 0, 6, 12, 11) | ESR_ELx_SYS64_ISS_DIR_WRITE)
+#define ESR_ELx_SYS64_ISS_SYS_ICC_SGI0R_EL1 \
+	(ESR_ELx_SYS64_ISS_SYS_VAL(3, 0, 7, 12, 11) | ESR_ELx_SYS64_ISS_DIR_WRITE)
+
+/**
+ * struct caretaker_arm64_context - Preserved ARM64 vCPU architectural context
+ * @fault:            Guest fault syndrome registers from VM exits.
+ * @ctxt:             CPU registers, FP/SIMD, and system registers.
+ * @hcr_el2:          Hypervisor Configuration Register.
+ * @mdcr_el2:         Monitor Debug Configuration Register.
+ * @cflags:           vCPU execution flags.
+ * @vtcr_el2:         Stage-2 translation control register.
+ * @vttbr_el2:        Stage-2 translation table base register.
+ * @vgic_initialized: Whether VGICv3 virtual CPU interface is active.
+ * @vgic_v3:          VGICv3 virtual CPU interface registers.
+ */
+struct caretaker_arm64_context {
+	struct kvm_vcpu_fault_info fault;
+	struct kvm_cpu_context ctxt;
+
+	u64 hcr_el2;
+	u64 mdcr_el2;
+	u64 cflags;
+
+	u64 vtcr_el2;
+	u64 vttbr_el2;
+
+	bool vgic_initialized;
+	struct vgic_v3_cpu_if vgic_v3;
+
+	u64 cntv_cval_el0;
+	u64 cntv_ctl_el0;
+	u64 cntvoff_el2;
+	u16 pending_sgis;
+};
+
+struct caretaker_arm64_page;
+
+struct arm64_caretaker_ptrauth_keys {
+	u64 apia_lo, apia_hi;
+	u64 apib_lo, apib_hi;
+	u64 apda_lo, apda_hi;
+	u64 apdb_lo, apdb_hi;
+	u64 apga_lo, apga_hi;
+};
+
+/**
+ * struct caretaker_arm64_page - Old-text-private ARM64 Caretaker execution page
+ *
+ * Invariant: Only the embedded @abi prefix (struct kvm_caretaker_arch_ser,
+ * offset 0) is part of the KHO handover ABI and may be dereferenced
+ * by the incoming kernel.  All remaining fields are private to preserved
+ * Caretaker text executing on the isolated core.
+ */
+struct caretaker_arm64_page {
+	struct kvm_caretaker_arch_ser abi;
+	struct kvm_caretaker_vcpu vcpu;
+	struct caretaker_arm64_context ctx;
+	struct caretaker_arm64_page *next_vcpu;
+	struct kvm_vcpu_arch_ser *arch_state;
+	u64 last_ret;
+	struct arm64_caretaker_ptrauth_keys ptrauth_keys;
+};
+
+static_assert(offsetof(struct caretaker_arm64_page, abi) == 0);
+static_assert(offsetof(struct caretaker_arm64_page, abi.cb) == 0);
+
+u64 caretaker_guest_enter(struct caretaker_arm64_context *ctx);
+void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
+					      struct kvm_vcpu_ser *ser);
+void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_ser *ser);
+void arm64_caretaker_handle_invalid(u64 elr, u64 esr, u64 far);
+
+#ifdef CONFIG_KVM_CARETAKER
+int arm64_kvm_caretaker_preserve(struct kvm_vcpu *vcpu,
+				 struct kvm_vcpu_ser *ser);
+void arm64_kvm_caretaker_unpreserve(struct kvm_vcpu_ser *ser);
+void arm64_kvm_caretaker_finish(struct kvm_vcpu_ser *ser);
+#else
+static inline int arm64_kvm_caretaker_preserve(struct kvm_vcpu *vcpu,
+					       struct kvm_vcpu_ser *ser)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void arm64_kvm_caretaker_unpreserve(struct kvm_vcpu_ser *ser) {}
+static inline void arm64_kvm_caretaker_finish(struct kvm_vcpu_ser *ser) {}
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ARCH_ARM64_KVM_CARETAKER_H */
diff --git a/include/linux/kho/abi/kvm_arm64.h b/include/linux/kho/abi/kvm_arm64.h
index dc121224a177..4aee91dd41b3 100644
--- a/include/linux/kho/abi/kvm_arm64.h
+++ b/include/linux/kho/abi/kvm_arm64.h
@@ -56,6 +56,38 @@ struct kvm_vcpu_arch_ser {
 static_assert(offsetof(struct kvm_vcpu_arch_ser, sysregs) % sizeof(u64) == 0,
 	      "sysregs must be 64-bit aligned");
 
+/**
+ * struct kvm_caretaker_arch_ser - ARM64-specific Caretaker control block ABI
+ * @cb:               Common Caretaker control block header (must be at offset 0).
+ * @vgic_initialized: Non-zero if @vgic_* fields hold live VGICv3 CPU interface state.
+ * @cflags:           KVM vCPU architectural flags.
+ * @cntvoff_el2:      Guest virtual counter offset active during Caretaker execution.
+ * @hcr_el2:          Hypervisor Configuration Register active during Caretaker execution.
+ * @mdcr_el2:         Monitor Debug Configuration Register active during Caretaker execution.
+ * @used_lrs:         Number of active VGICv3 List Registers.
+ * @vgic_hcr:         VGICv3 Hypervisor Control Register.
+ * @vgic_vmcr:        VGICv3 Virtual Machine Control Register.
+ * @reserved:         Must be zero.
+ * @vgic_ap0r:        VGICv3 Active Priorities Group 0 Registers.
+ * @vgic_ap1r:        VGICv3 Active Priorities Group 1 Registers.
+ * @vgic_lr:          VGICv3 List Registers.
+ */
+struct kvm_caretaker_arch_ser {
+	struct kvm_caretaker_cb_ser cb;
+	u32 vgic_initialized;
+	u32 cflags;
+	u64 cntvoff_el2;
+	u64 hcr_el2;
+	u64 mdcr_el2;
+	u32 used_lrs;
+	u32 vgic_hcr;
+	u32 vgic_vmcr;
+	u32 reserved;
+	u32 vgic_ap0r[4];
+	u32 vgic_ap1r[4];
+	u64 vgic_lr[16];
+} __packed;
+
 #endif /* CONFIG_ARM64 */
 
 #endif /* _LINUX_KHO_ABI_KVM_ARM64_H */
-- 
2.55.0.1082.g2b9226bbc0-goog

