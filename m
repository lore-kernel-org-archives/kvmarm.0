Return-Path: <SRS0=jV2N=TX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C88C282DD
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8D19217F9
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8D19217F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A557F4A3A3;
	Thu, 23 May 2019 06:35:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ju0ge4ng5QCt; Thu, 23 May 2019 06:35:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485E74A4C3;
	Thu, 23 May 2019 06:35:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC754A319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GDJyOamALwLK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 May 2019 06:35:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC534A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4102DA78;
 Thu, 23 May 2019 03:35:23 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2CDA03F718;
 Thu, 23 May 2019 03:35:21 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 01/15] KVM: arm64: add {read,
 write}_sysreg_elx_s versions for new registers
Date: Thu, 23 May 2019 11:34:48 +0100
Message-Id: <20190523103502.25925-2-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM provides {read,write}_sysreg_el1() to write to ${REG}_EL1 when we
really want to read/write to the EL1 register without any VHE register
redirection.

SPE registers are not supported by many versions of GAS. For this reason
we mostly use mrs_s macro which takes sys_reg() representation.

However these SPE registers using sys_reg representation doesn't work
well with existing {read,write}_sysreg_el1 macros. We need to add
{read,write}_sysreg_el1_s versions so cope up with them.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 09fe8bd15f6e..f61378b77c9f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -35,6 +35,15 @@
 			     : "=r" (reg));				\
 		reg;							\
 	})
+#define read_sysreg_elx_s(r,nvh,vh)					\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),		\
+					 __mrs_s("%0", r##vh),		\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
 
 #define write_sysreg_elx(v,r,nvh,vh)					\
 	do {								\
@@ -44,6 +53,14 @@
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 					 : : "rZ" (__val));		\
 	} while (0)
+#define write_sysreg_elx_s(v,r,nvh,vh)					\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
+					 __msr_s(r##vh, "%x0"),		\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
 
 /*
  * Unified accessors for registers that have a different encoding
@@ -72,7 +89,9 @@
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
+#define read_sysreg_el1_s(r)	read_sysreg_elx_s(r, _EL1, _EL12)
 #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
+#define write_sysreg_el1_s(v,r)	write_sysreg_elx_s(v, r, _EL1, _EL12)
 
 /* The VHE specific system registers and their encoding */
 #define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
