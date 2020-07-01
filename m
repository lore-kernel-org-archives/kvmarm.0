Return-Path: <SRS0=y90B=AM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1109EC433DF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 21:53:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C41B52078A
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 21:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C41B52078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDF74B4B1;
	Wed,  1 Jul 2020 17:53:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OPF+NWXWriH0; Wed,  1 Jul 2020 17:53:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2504B4AB;
	Wed,  1 Jul 2020 17:53:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B0E4B4AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 17:53:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R6zPaM4-nDat for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 17:53:14 -0400 (EDT)
Received: from mail-io1-f65.google.com (mail-io1-f65.google.com
 [209.85.166.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C4974B4AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 17:53:14 -0400 (EDT)
Received: by mail-io1-f65.google.com with SMTP id k23so26654386iom.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jul 2020 14:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZqIbZ9bdtQvN+SAlqhhhaMkh6uvP1BMdEcYi5f2/l/c=;
 b=HOxshogZRZFMsAGY22w8vef6FuKzslX56tS5nl1pGF6ln3w+LOhTJFKtmQ35qs+BY/
 0FanKXDJlgueyffd0598G3oddLt7kheYetcIIIFHTw9fy3OLaI0w0Pz6g+It58fNpUGB
 6eAe6vUofCY+Rpf4q01gN+uaN9Kc6YY4NJJqUBEmFJ5IE0rOuzPnCqV75D+vfJfBoQ2i
 nJGkhcPiGqepJUi9KWq5XzexMUSsWUZJ93Rdnxip4BQodPGVGruFM3o5lIY+aqS0Nj0N
 fGWPYPOkP2fyCTL+63BdP2E7LwGWMucdC5TV9VHsbzNQijrn2jHNmnNzW4BUJU8xm4/w
 IlWg==
X-Gm-Message-State: AOAM5338x5jIf8dBYivdAUzz1cdowmojWYE0vBHIDNCg4VRCS32Qco5V
 KU5aBHZh2YOy9kKCjID7qA==
X-Google-Smtp-Source: ABdhPJzWTiDnUiIv26X9j5w4awC+xSByLtq0R0eFBqinQrLigYwYZ3OSPdwwt422qAlaVR4J0+A/TA==
X-Received: by 2002:a02:6a26:: with SMTP id l38mr30663296jac.60.1593640394177; 
 Wed, 01 Jul 2020 14:53:14 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.253])
 by smtp.googlemail.com with ESMTPSA id g1sm3784707ilk.51.2020.07.01.14.53.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Jul 2020 14:53:13 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Date: Wed,  1 Jul 2020 15:53:08 -0600
Message-Id: <20200701215308.3715856-4-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200701215308.3715856-1-robh@kernel.org>
References: <20200701215308.3715856-1-robh@kernel.org>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
and a store exclusive or PAR_EL1 read can cause a deadlock.

The workaround requires a DMB SY before and after a PAR_EL1 register read
and the disabling of KVM. KVM must be disabled to prevent the problematic
sequence in guests' EL1. This workaround also depends on a firmware
counterpart to enable the h/w to insert DMB SY after load and store
exclusive instructions. See the errata document SDEN-1152370 v10 [1] for
more information.

All the other PAR_EL1 reads besides the one in
is_spurious_el1_translation_fault() are in KVM code, so the work-around is
not needed for them.

[1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
- Don't disable KVM, just print warning
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 19 +++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 10 ++++++++++
 arch/arm64/kvm/arm.c                   |  3 ++-
 arch/arm64/mm/fault.c                  | 10 ++++++++++
 6 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 936cf2a59ca4..716b279e3b33 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -90,6 +90,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a4a094bedcb2..28993ad4c649 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -626,6 +626,25 @@ config ARM64_ERRATUM_1542419
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1508412
+	bool "Cortex-A77: 1508412: workaround deadlock on sequence of NC/Device load and store exclusive or PAR read"
+	default y
+	help
+	  This option adds a workaround for Arm Cortex-A77 erratum 1508412.
+
+	  Affected Cortex-A77 cores (r0p0, r1p0) could deadlock on a sequence
+	  of a store-exclusive or read of PAR_EL1 and a load with device or
+	  non-cacheable memory attributes. The workaround depends on a firmware
+	  counterpart.
+
+	  KVM guests must also have the work-around implemented or they can
+	  deadlock the system.
+
+	  Workaround the issue by inserting DMB SY barriers around PAR_EL1
+	  register reads and warning KVM users.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index d7b3bb0cb180..2a2cdb4ced8b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -62,7 +62,8 @@
 #define ARM64_HAS_GENERIC_AUTH			52
 #define ARM64_HAS_32BIT_EL1			53
 #define ARM64_BTI				54
+#define ARM64_WORKAROUND_1508412		55
 
-#define ARM64_NCAPS				55
+#define ARM64_NCAPS				56
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ad06d6802d2e..5eee8a75540c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -938,6 +938,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_neoverse_n1_erratum_1542419,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1508412
+	{
+		/* we depend on the firmware portion for correctness */
+		.desc = "ARM erratum 1508412 (kernel portion)",
+		.capability = ARM64_WORKAROUND_1508412,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A77,
+				  0, 0,
+				  1, 0),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e2f50fa4d825..9f50e01eea00 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1653,7 +1653,8 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
-	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
+	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
+	    cpus_have_const_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum work-arounds can deadlock system!\n" \
 			 "Only trusted guests should be used on this system.\n");
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 8afb238ff335..d599d60f06fd 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -260,7 +260,17 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
+	/*
+	 * Arm Errata 1508412 requires dmb(sy) before and after reads of
+	 * PAR_EL1.
+	 * As this location is not a hot path, just condition it on the config
+	 * option.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
+		dmb(sy);
 	par = read_sysreg(par_el1);
+	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
+		dmb(sy);
 	local_irq_restore(flags);
 
 	/*
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
