Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385BDC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 16:23:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68A5C49F21;
	Thu,  7 Apr 2022 12:23:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EXIgg3eAUnyV; Thu,  7 Apr 2022 12:23:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A86744A7FD;
	Thu,  7 Apr 2022 12:23:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915F549F21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cph22PVMaZEE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 12:23:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6767A49EEF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE47F139F;
 Thu,  7 Apr 2022 09:23:35 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F57D3F73B;
 Thu,  7 Apr 2022 09:23:34 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com
Subject: [PATCH 1/5] arm64: Make ESR_ELx_xVC_IMM_MASK compatible with assembly
Date: Thu,  7 Apr 2022 17:23:23 +0100
Message-Id: <20220407162327.396183-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407162327.396183-1-alexandru.elisei@arm.com>
References: <20220407162327.396183-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

ESR_ELx_xVC_IMM_MASK is used as a mask for the immediate value for the
HVC/SMC instructions. The header file is included by assembly files (like
entry.S) and ESR_ELx_xVC_IMM_MASK is not conditioned on __ASSEMBLY__ being
undefined. Use the UL() macro for defining the constant's size, as that is
compatible with both C code and assembly, whereas the UL suffix only works
for C code.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/esr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d52a0b269ee8..7356e2f05755 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -136,7 +136,7 @@
 #define ESR_ELx_WFx_ISS_TI	(UL(1) << 0)
 #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
-#define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
+#define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
