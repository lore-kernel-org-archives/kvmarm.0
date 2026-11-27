Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757868;
	b=W45zu7w+Y8EgTyO96Sxmmpm52XIqVi56cl0rsAiIfFr+zJJmKum5mrNZ3n2inTOALVfW
	 239ti5WBGgvalobfBLPbQvQrIcIDxxqrMHILrowGQSwfpflQIjkYrnMlybuZvNsK3mvqc
	 OMCxyvlniQfAF9FyWPmmGJle0B5Np2IhCo9XOHT8xnMMf0eiheYQ/Pte52n9Mnzu4TBK4
	 wKMYfpF1r4YmxWMJXNSg5mqA9JUpnF2p6a0d+RBX5RVcCsK3d022oE7YCSPmuR1dd0fym
	 ADrmN8z3H7CBslY+LW1J2KLSTC9WE5aMiPsJzCVObjD3yPdvtV8Z9nuo2wlaN4OEYrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757868;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=LncpIWG6iTepcF/WKfjkr7sRjr1uPyZNvnirgUbb4J0=;
	b=gYYeeOMIY+1VtOxCtsE2xqz33cMFCrPay40/0U7DJpgRwu5zfdxFqDrMlxy8AL20pD8j
	 W9JnSvjTmpkeh+vdUuKIIuCbKkndQMlGzJlKGrS1lr4tZco0nQxE8BP9IO1o4/6E6n0Dy
	 fu9YTYbBaTmAW7yLLQwci2Jtk4r7xqeHUblPvkoICUnvtsz0Zn3x4+2G0ayx87cdObo1R
	 SLnKeryaPopTqGT3MuPZxtqMbBmhrhqehCTSrUF9GItJab4iiRS3zRgU+B4Jw5KQT0Lwp
	 Y2GE136dO6Da3EtR6+V5wQXFTj3nKLEJ4QglPxMkALv9nY3gaGZuIXdPuPfzM7H+xrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EKulkZta;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195F3606A327
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 195F3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EKulkZta
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757867; x=1827293867;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Q8c8VlFPRQHMx0oQxdd88FZY+/L6JFZnz3WaEVSHBC4=;
  b=EKulkZtapyuAQgIDR5MoTDnQ+TwVAsv1GDSeTN7HGC/MnGAwygB7GXMs
   0XkaZkDTxp2xbl6o/5uakwRgvfQGdEdRuOcv+znrnpFhOWujR0IbWoHh2
   XHfL/dpf001YFTzj65e3Gu/JgA0H2z8R07jPTUtqWcy8G/3fR4zlZ7dVA
   r+CZFHBMLOH1EMy8Zrn1Ik9WPsqMJAN9Rqq1S6CDQC94iqVwAP/N5Nv5A
   P0ICxU6uRg0Bl+szBFVrQfP8rsU+8hHlzTDGHkR4GhR0LjrXxWEfwwREW
   za2b9AbhWQs61y14r3gSRGkZezF/VIVMzMmnOg+OboJloR8QEZIolUX+z
   Q==;
X-CSE-ConnectionGUID: ZU40R4F2QYKDEK8p9cAG3A==
X-CSE-MsgGUID: NyWCcW7nQESNlmTq31R5Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="249505963"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="249505963"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:46 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id A6C111C1C702
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:46 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 5D7AA14003E0
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:46 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id EBED640262B;
	Fri, 27 Nov 2026 05:37:38 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Fri, 27 Nov 2026 14:36:34 +0900
Subject: [PATCH v4 5/5] arm64: Add workaround to replace WFE with NOP for
 FUJITSU-MONAKA Erratum E#030004
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-monaka-fix-for-upstream-v4-5-3395c415bbe4@fujitsu.com>
References: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
In-Reply-To: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=8485;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=Q8c8VlFPRQHMx0oQxdd88FZY+/L6JFZnz3WaEVSHBC4=;
 b=7ohupvYzWh/aKgkXhbtT6oYS0fqFTYylJomYHNhrUB3GRp+uywsHnGmypBxxw1AtwZYl1KwCG
 fYQQjA5ZfSgAVWWRFAvO0I3Gk3Aib0PlmAkT9jFKrmgKZkCAcPxgIsJ
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

This option adds a workaround for FUJITSU-MONAKA erratum E#030004.

On affected CPUs, if a wake-up event generated by clearing the
global exclusive monitor or by a SEV instruction arrives in the
same cycle as a WFE instruction commits, the CPU may fail to
advance the program counter and re-execute the same WFE
instruction. If no further wake-up event occurs, the CPU may
remain waiting indefinitely (for example, in spinlock code).
This may cause a system hang before the generic timer event stream
is enabled. WFI, WFIT, and WFET instructions are not affected.

After the event stream is enabled (shortly after the secondary CPU
bring-up), event stream could wake up affected cores.
However, in order to prevent the condition during secondary CPU
bring-up, the workaround replaces all WFE instructions in host kernel
code with NOP using the boot alternative framework before the secondary
CPU bring-up on the MONAKA CPU.

Note that there is no need to take care of WFE usage in Host EL0 and
VHE Guest since if event stream is enabled in Host EL2, the event
reaches to every ELx & world. This effectively means FUJITSU-MONAKA
does not guarantee disabling event stream
(clocksource.arm_arch_timer.evtstrm=0) nor running nVHE guests
(kvm-arm.mode=nvhe/protected), although these configurations
are not rejected by this patch.

This only affects FUJITSU-MONAKA CPUs.

Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>

---
Changes in v4:
 - Remove assisted-by: LLM tag as I understand it is not needed.
   No code change
Changes in v3:
 - New patch
 - Note that wfe instruction used in nVHE spinlock code is
   not updated since nVHE is out of scope of this patch as the
   above commit message explains
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/assembler.h          |  4 ++++
 arch/arm64/include/asm/barrier.h            |  3 ++-
 arch/arm64/include/asm/cmpxchg.h            |  4 ++--
 arch/arm64/include/asm/cpucaps.h            |  2 ++
 arch/arm64/kernel/cpu_errata.c              | 18 ++++++++++++++++++
 arch/arm64/tools/cpucaps                    |  1 +
 8 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index e6bbc54208b1..8cf25857c617 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -405,6 +405,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | MONAKA GICv3/v4 | E#030003        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA          | E#030004        | FUJITSU_ERRATUM_030004      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2f195da6dd1c..6fa2d728eff8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1420,6 +1420,28 @@ config FUJITSU_ERRATUM_030002
 
 	  If unsure, say Y.
 
+config FUJITSU_ERRATUM_030004
+	bool "FUJITSU-MONAKA erratum E#030004: CPU may hang when executing WFE"
+	default y
+	help
+	  This option adds a workaround for FUJITSU-MONAKA erratum E#030004.
+	  On affected CPUs, if a wake-up event generated by clearing the
+	  global exclusive monitor or by a SEV instruction arrives in the
+	  same cycle as a WFE instruction commits, the CPU may fail to
+	  advance the program counter and re-execute the same WFE
+	  instruction. If no further wake-up event occurs, the CPU may
+	  remain waiting indefinitely (for example, in spinlock code).
+	  This may cause a system hang before the generic timer event stream
+	  is enabled. WFI, WFIT, and WFET instructions are not affected.
+
+	  The workaround replaces host WFE instructions in arm64 code with
+	  NOP using the boot alternative framework before the secondary
+	  CPU bring-up on the MONAKA CPU.
+
+	  The workaround only affects the FUJITSU-MONAKA.
+
+	  If unsure, say Y.
+
 config HISILICON_ERRATUM_161600802
 	bool "Hip07 161600802: Erroneous redistributor VLPI base"
 	default y
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 020670814bda..a83db010a88e 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -69,6 +69,10 @@
 9990:
 	.endm
 
+	.macro	wfe
+alternative_insn "hint #2", nop, ARM64_WORKAROUND_FUJITSU_030004
+	.endm
+
 /*
  * RAS Error Synchronization barrier
  */
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 9495c4441a46..28598d441c10 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -17,7 +17,8 @@
 #define nops(n)		asm volatile(__nops(n))
 
 #define sev()		asm volatile("sev" : : : "memory")
-#define wfe()		asm volatile("wfe" : : : "memory")
+#define ARM64_WFE_INSN	ALTERNATIVE("wfe", "nop", ARM64_WORKAROUND_FUJITSU_030004)
+#define wfe()		asm volatile(ARM64_WFE_INSN : : : "memory")
 #define wfet(val)	asm volatile("msr s0_3_c1_c0_0, %0"	\
 				     : : "r" (val) : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
index 6cf3cd6873f5..afedf2788469 100644
--- a/arch/arm64/include/asm/cmpxchg.h
+++ b/arch/arm64/include/asm/cmpxchg.h
@@ -218,11 +218,11 @@ static inline void __cmpwait_case_##sz(volatile void *ptr,		\
 									\
 	asm volatile(							\
 	"	sevl\n"							\
-	"	wfe\n"							\
+	ARM64_WFE_INSN "\n"						\
 	"	ldxr" #sfx "\t%" #w "[tmp], %[v]\n"			\
 	"	eor	%" #w "[tmp], %" #w "[tmp], %" #w "[val]\n"	\
 	"	cbnz	%" #w "[tmp], 1f\n"				\
-	"	wfe\n"							\
+	ARM64_WFE_INSN "\n"						\
 	"1:"								\
 	: [tmp] "=&r" (tmp), [v] "+Q" (*(u##sz *)ptr)			\
 	: [val] "r" (val));						\
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f4aa6bd257c5..cc6b8f2270e1 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -72,6 +72,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030001);
 	case ARM64_WORKAROUND_FUJITSU_030002:
 		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030002);
+	case ARM64_WORKAROUND_FUJITSU_030004:
+		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030004);
 	case ARM64_MPAM:
 		/*
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 37bbe8268499..2a91292b6329 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -723,6 +723,15 @@ static const struct midr_range cnp_erratum_cpus[] = {
 };
 #endif
 
+#ifdef CONFIG_FUJITSU_ERRATUM_030004
+static bool
+has_fujitsu_monaka_erratum_030004(const struct arm64_cpu_capabilities *entry,
+				  int __unused)
+{
+	return is_midr_in_range(&entry->midr_range);
+}
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -1109,6 +1118,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_FUJITSU_030002,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
 	},
+#endif
+#ifdef CONFIG_FUJITSU_ERRATUM_030004
+	{
+		.desc = "FUJITSU-MONAKA Erratum E#030004",
+		.capability = ARM64_WORKAROUND_FUJITSU_030004,
+		.type = ARM64_CPUCAP_SCOPE_BOOT_CPU,
+		.matches = has_fujitsu_monaka_erratum_030004,
+		.midr_range = MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
+	},
 #endif
 	{
 		.desc = "Known broken GICv3 SEIS implementation",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 73a4aeb535a0..4d97f20aad07 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -136,3 +136,4 @@ WORKAROUND_BROKEN_AMU_CONSTCNT
 WORKAROUND_BROKEN_AMU_CORECNT
 WORKAROUND_FUJITSU_030001
 WORKAROUND_FUJITSU_030002
+WORKAROUND_FUJITSU_030004

-- 
2.43.0

