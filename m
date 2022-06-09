Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22791C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE12E4B3A9;
	Thu,  9 Jun 2022 08:12:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3JfbXJ6o5oB; Thu,  9 Jun 2022 08:12:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A95D4B3BB;
	Thu,  9 Jun 2022 08:12:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DDD4B3B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vkhlU61CsH+x for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:35 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B5304B3B8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:35 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 57CC1B82D50;
 Thu,  9 Jun 2022 12:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE36C34114;
 Thu,  9 Jun 2022 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776753;
 bh=C0btZ9R2wYnDdcYBRBHXCX9ZxoBZ12YtxECxE3n++BM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T3mT0t2TMQUekhNLaEmuAHsMuJ4u5kdZwfkTXTgWvYR3R4ZLGaXFun7lEdgRPm+Vn
 FVdy/pjuCe+Ce/J5StBAlAkwpCuydNWUu2pWME4NkMklX9SOfi8KhY3bW3UhZ+piCe
 z6li3FEXz483a892552FODAv7vA06c3lCvf5CIumJKnmtY9dYsRVOI5roP4Va4lItH
 niF4sUbleOTI/LEWzKu/T0AavzMc0B6jdokbOsUvVYxkWgzwYSeiNjamSR/jhweIfs
 5iVF2jyhR3ZJhNBiimFbFdpUix8t5uglZYpuYG3FH5M1GhPiLpgRbU34AJ0F+4k7Js
 grdhoaeniK9dw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/6] KVM: arm64: Handle all ID registers trapped for a
 protected VM
Date: Thu,  9 Jun 2022 13:12:19 +0100
Message-Id: <20220609121223.2551-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

From: Marc Zyngier <maz@kernel.org>

A protected VM accessing ID_AA64ISAR2_EL1 gets punished with an UNDEF,
while it really should only get a zero back if the register is not
handled by the hypervisor emulation (as mandated by the architecture).

Introduce all the missing ID registers (including the unallocated ones),
and have them to return 0.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 42 ++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index b6d86e423319..35a4331ba5f3 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -243,15 +243,9 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64MMFR2_EL1:
 		return get_pvm_id_aa64mmfr2(vcpu);
 	default:
-		/*
-		 * Should never happen because all cases are covered in
-		 * pvm_sys_reg_descs[].
-		 */
-		WARN_ON(1);
-		break;
+		/* Unhandled ID register, RAZ */
+		return 0;
 	}
-
-	return 0;
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
@@ -332,6 +326,16 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
 /* Mark the specified system register as an AArch64 feature id register. */
 #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
 
+/*
+ * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
+ * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
+ * (1 <= crm < 8, 0 <= Op2 < 8).
+ */
+#define ID_UNALLOCATED(crm, op2) {			\
+	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+	.access = pvm_access_id_aarch64,		\
+}
+
 /* Mark the specified system register as Read-As-Zero/Write-Ignored */
 #define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
 
@@ -375,24 +379,46 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH32(SYS_MVFR0_EL1),
 	AARCH32(SYS_MVFR1_EL1),
 	AARCH32(SYS_MVFR2_EL1),
+	ID_UNALLOCATED(3,3),
 	AARCH32(SYS_ID_PFR2_EL1),
 	AARCH32(SYS_ID_DFR1_EL1),
 	AARCH32(SYS_ID_MMFR5_EL1),
+	ID_UNALLOCATED(3,7),
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
 	AARCH64(SYS_ID_AA64PFR0_EL1),
 	AARCH64(SYS_ID_AA64PFR1_EL1),
+	ID_UNALLOCATED(4,2),
+	ID_UNALLOCATED(4,3),
 	AARCH64(SYS_ID_AA64ZFR0_EL1),
+	ID_UNALLOCATED(4,5),
+	ID_UNALLOCATED(4,6),
+	ID_UNALLOCATED(4,7),
 	AARCH64(SYS_ID_AA64DFR0_EL1),
 	AARCH64(SYS_ID_AA64DFR1_EL1),
+	ID_UNALLOCATED(5,2),
+	ID_UNALLOCATED(5,3),
 	AARCH64(SYS_ID_AA64AFR0_EL1),
 	AARCH64(SYS_ID_AA64AFR1_EL1),
+	ID_UNALLOCATED(5,6),
+	ID_UNALLOCATED(5,7),
 	AARCH64(SYS_ID_AA64ISAR0_EL1),
 	AARCH64(SYS_ID_AA64ISAR1_EL1),
+	AARCH64(SYS_ID_AA64ISAR2_EL1),
+	ID_UNALLOCATED(6,3),
+	ID_UNALLOCATED(6,4),
+	ID_UNALLOCATED(6,5),
+	ID_UNALLOCATED(6,6),
+	ID_UNALLOCATED(6,7),
 	AARCH64(SYS_ID_AA64MMFR0_EL1),
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
+	ID_UNALLOCATED(7,3),
+	ID_UNALLOCATED(7,4),
+	ID_UNALLOCATED(7,5),
+	ID_UNALLOCATED(7,6),
+	ID_UNALLOCATED(7,7),
 
 	/* Scalable Vector Registers are restricted. */
 
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
