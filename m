Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4371C47096
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A862613D7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A862613D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7044B10E;
	Thu,  3 Jun 2021 14:34:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e4vdK8gUWE3N; Thu,  3 Jun 2021 14:34:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E182B4B10C;
	Thu,  3 Jun 2021 14:34:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E56A4B110
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6vTz14YONqvK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 14:34:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8343D4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:06 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F0D2613B1;
 Thu,  3 Jun 2021 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622745245;
 bh=aoxTolk8dCsad1y8K8HR18m0JTWcLPqsOTFqONlive0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=N+fw/PVVPGRXMhC3TkqOpBuQgwJeHdfZr1v4uMmj+INdOrG/Rc2e8I+n2gO+kVOAM
 W3Bz9jK+g+A1y6utCu9QY+iI5vEtqMqFX3d4t3RicZ7tHp5ujp2iURHRLSRfPHFEdu
 hFhwHAlia7zxZ4ez9Skwa219IlitvrpqG9CDvrhk2kiRz31z0/GkXTmw19iFAVedPw
 bov/6bSX1dx1JQ2B5LPyUMmC0xG+lU3DvFEL2k2RyPgY/lAvlCYalCl+bpL6vv0Cjo
 0c7C/43WkPYg2w4mvktVhA2MI3vr3PWTrsdZ2ytpP4C5xGEpkzpC5sMTNXZ7FHiOOF
 aV/49OEId7zsw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/4] KVM: arm64: Parse reserved-memory node for pkvm guest
 firmware region
Date: Thu,  3 Jun 2021 19:33:46 +0100
Message-Id: <20210603183347.1695-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
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

Add support for a "linux,pkvm-guest-firmware-memory" reserved memory
region, which can be used to identify a firmware image for protected
VMs.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/Makefile |  2 +-
 arch/arm64/kvm/pkvm.c   | 52 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/pkvm.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 589921392cb1..61e054411831 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o \
+	 guest.o debug.o pkvm.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 arch_timer.o trng.o\
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
new file mode 100644
index 000000000000..7af5d03a3941
--- /dev/null
+++ b/arch/arm64/kvm/pkvm.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM host (EL1) interface to Protected KVM (pkvm) code at EL2.
+ *
+ * Copyright (C) 2021 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+static struct reserved_mem *pkvm_firmware_mem;
+
+static int __init pkvm_firmware_rmem_err(struct reserved_mem *rmem,
+					 const char *reason)
+{
+	phys_addr_t end = rmem->base + rmem->size;
+
+	kvm_err("Ignoring pkvm guest firmware memory reservation [%pa - %pa]: %s\n",
+		&rmem->base, &end, reason);
+	return -EINVAL;
+}
+
+static int __init pkvm_firmware_rmem_init(struct reserved_mem *rmem)
+{
+	unsigned long node = rmem->fdt_node;
+
+	if (kvm_get_mode() != KVM_MODE_PROTECTED)
+		return pkvm_firmware_rmem_err(rmem, "protected mode not enabled");
+
+	if (pkvm_firmware_mem)
+		return pkvm_firmware_rmem_err(rmem, "duplicate reservation");
+
+	if (!of_get_flat_dt_prop(node, "no-map", NULL))
+		return pkvm_firmware_rmem_err(rmem, "missing \"no-map\" property");
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return pkvm_firmware_rmem_err(rmem, "\"reusable\" property unsupported");
+
+	if (!PAGE_ALIGNED(rmem->base))
+		return pkvm_firmware_rmem_err(rmem, "base is not page-aligned");
+
+	if (!PAGE_ALIGNED(rmem->size))
+		return pkvm_firmware_rmem_err(rmem, "size is not page-aligned");
+
+	pkvm_firmware_mem = rmem;
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(pkvm_firmware, "linux,pkvm-guest-firmware-memory",
+		       pkvm_firmware_rmem_init);
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
