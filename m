Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB10C2D0DB
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41EF121734
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXFrzdsl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41EF121734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F01CF4AE96;
	Thu, 30 Jan 2020 08:26:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1c+-336rKq5p; Thu, 30 Jan 2020 08:26:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8994AEE1;
	Thu, 30 Jan 2020 08:26:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852FC4ACBA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pvETONXao8YB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:26:20 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9B5F4AE94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E8A48214DB;
 Thu, 30 Jan 2020 13:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390779;
 bh=W9gFNlv6iUiNAF9jDYhSjNdMJajTXegSm257W4W3s9c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aXFrzdslusRbZ0nSrnLu87onEFlqgQ/DWbcmafPPm8MhxTAnwHI+HYAK1KOWO5Ftb
 KWgJYYb91TsuRZLgUGbJX+JmV7PXq4QP+hrGFStU3KT3T/ztlxIYyI/wkw2aECBpiP
 KAFjqYcnYWJb7qpKpTxWz4aSQpajkpR5BtRO2WBw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9po-002BmW-WE; Thu, 30 Jan 2020 13:26:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/23] KVM: arm/arm64: Correct CPSR on exception entry
Date: Thu, 30 Jan 2020 13:25:44 +0000
Message-Id: <20200130132558.10201-10-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 Andrew Murray <andrew.murray@arm.com>
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

From: Mark Rutland <mark.rutland@arm.com>

When KVM injects an exception into a guest, it generates the CPSR value
from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
bits to zero.

This isn't correct, as the architecture specifies that some CPSR bits
are (conditionally) cleared or set upon an exception, and others are
unchanged from the original context.

This patch adds logic to match the architectural behaviour. To make this
simple to follow/audit/extend, documentation references are provided,
and bits are configured in order of their layout in SPSR_EL2. This
layout can be seen in the diagram on ARM DDI 0487E.a page C5-426.

Note that this code is used by both arm and arm64, and is intended to
fuction with the SPSR_EL2 and SPSR_HYP layouts.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200108134324.46500-3-mark.rutland@arm.com
---
 arch/arm/include/asm/kvm_emulate.h |  12 ++++
 arch/arm64/include/asm/ptrace.h    |   1 +
 virt/kvm/arm/aarch32.c             | 111 ++++++++++++++++++++++++++---
 3 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index fe55d8737a11..c488c629e6c8 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -14,13 +14,25 @@
 #include <asm/cputype.h>
 
 /* arm64 compatibility macros */
+#define PSR_AA32_MODE_FIQ	FIQ_MODE
+#define PSR_AA32_MODE_SVC	SVC_MODE
 #define PSR_AA32_MODE_ABT	ABT_MODE
 #define PSR_AA32_MODE_UND	UND_MODE
 #define PSR_AA32_T_BIT		PSR_T_BIT
+#define PSR_AA32_F_BIT		PSR_F_BIT
 #define PSR_AA32_I_BIT		PSR_I_BIT
 #define PSR_AA32_A_BIT		PSR_A_BIT
 #define PSR_AA32_E_BIT		PSR_E_BIT
 #define PSR_AA32_IT_MASK	PSR_IT_MASK
+#define PSR_AA32_GE_MASK	0x000f0000
+#define PSR_AA32_DIT_BIT	0x00200000
+#define PSR_AA32_PAN_BIT	0x00400000
+#define PSR_AA32_SSBS_BIT	0x00800000
+#define PSR_AA32_Q_BIT		PSR_Q_BIT
+#define PSR_AA32_V_BIT		PSR_V_BIT
+#define PSR_AA32_C_BIT		PSR_C_BIT
+#define PSR_AA32_Z_BIT		PSR_Z_BIT
+#define PSR_AA32_N_BIT		PSR_N_BIT
 
 unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index fbebb411ae20..bf57308fcd63 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -62,6 +62,7 @@
 #define PSR_AA32_I_BIT		0x00000080
 #define PSR_AA32_A_BIT		0x00000100
 #define PSR_AA32_E_BIT		0x00000200
+#define PSR_AA32_PAN_BIT	0x00400000
 #define PSR_AA32_SSBS_BIT	0x00800000
 #define PSR_AA32_DIT_BIT	0x01000000
 #define PSR_AA32_Q_BIT		0x08000000
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index c4c57ba99e90..773cf1439081 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -10,6 +10,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bits.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
@@ -28,22 +29,112 @@ static const u8 return_offsets[8][2] = {
 	[7] = { 4, 4 },		/* FIQ, unused */
 };
 
+/*
+ * When an exception is taken, most CPSR fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]).
+ *
+ * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
+ * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
+ * obsoleted by the ARMv7 virtualization extensions and is RES0.
+ *
+ * For the SPSR layout seen from AArch32, see:
+ * - ARM DDI 0406C.d, page B1-1148
+ * - ARM DDI 0487E.a, page G8-6264
+ *
+ * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
+ * - ARM DDI 0487E.a, page C5-426
+ *
+ * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
+{
+	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
+	unsigned long old, new;
+
+	old = *vcpu_cpsr(vcpu);
+	new = 0;
+
+	new |= (old & PSR_AA32_N_BIT);
+	new |= (old & PSR_AA32_Z_BIT);
+	new |= (old & PSR_AA32_C_BIT);
+	new |= (old & PSR_AA32_V_BIT);
+	new |= (old & PSR_AA32_Q_BIT);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See ARM DDI 0487E.a, section G1.12.3
+	// See ARM DDI 0406C.d, section B1.8.3
+
+	new |= (old & PSR_AA32_DIT_BIT);
+
+	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
+	// See ARM DDI 0487E.a, page G8-6244
+	if (sctlr & BIT(31))
+		new |= PSR_AA32_SSBS_BIT;
+
+	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
+	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
+	// See ARM DDI 0487E.a, page G8-6246
+	new |= (old & PSR_AA32_PAN_BIT);
+	if (!(sctlr & BIT(23)))
+		new |= PSR_AA32_PAN_BIT;
+
+	// SS does not exist in AArch32, so ignore
+
+	// CPSR.IL is set to zero upon any exception
+	// See ARM DDI 0487E.a, page G1-5527
+
+	new |= (old & PSR_AA32_GE_MASK);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See prior comment above
+
+	// CPSR.E is set to SCTLR.EE upon any exception
+	// See ARM DDI 0487E.a, page G8-6245
+	// See ARM DDI 0406C.d, page B4-1701
+	if (sctlr & BIT(25))
+		new |= PSR_AA32_E_BIT;
+
+	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
+	// CPSR.A is set upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_A_BIT);
+	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
+		new |= PSR_AA32_A_BIT;
+
+	// CPSR.I is set upon any exception
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= PSR_AA32_I_BIT;
+
+	// CPSR.F is set upon an exception to FIQ
+	// CPSR.F is unchanged upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_F_BIT);
+	if (mode == PSR_AA32_MODE_FIQ)
+		new |= PSR_AA32_F_BIT;
+
+	// CPSR.T is set to SCTLR.TE upon any exception
+	// See ARM DDI 0487E.a, page G8-5514
+	// See ARM DDI 0406C.d, page B1-1181
+	if (sctlr & BIT(30))
+		new |= PSR_AA32_T_BIT;
+
+	new |= mode;
+
+	return new;
+}
+
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
-	unsigned long cpsr;
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
 	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
 	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
-	cpsr = mode | PSR_AA32_I_BIT;
-
-	if (sctlr & (1 << 30))
-		cpsr |= PSR_AA32_T_BIT;
-	if (sctlr & (1 << 25))
-		cpsr |= PSR_AA32_E_BIT;
-
-	*vcpu_cpsr(vcpu) = cpsr;
+	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
 
 	/* Note: These now point to the banked copies */
 	vcpu_write_spsr(vcpu, new_spsr_value);
@@ -84,7 +175,7 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		fsr = &vcpu_cp15(vcpu, c5_DFSR);
 	}
 
-	prepare_fault32(vcpu, PSR_AA32_MODE_ABT | PSR_AA32_A_BIT, vect_offset);
+	prepare_fault32(vcpu, PSR_AA32_MODE_ABT, vect_offset);
 
 	*far = addr;
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
