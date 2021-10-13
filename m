Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C03C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43CFB610D0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43CFB610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE534B126;
	Wed, 13 Oct 2021 08:04:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Eam5sWW1+Ck; Wed, 13 Oct 2021 08:04:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82294B152;
	Wed, 13 Oct 2021 08:04:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96FE84B121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pu3Zegpj1gUE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 08:04:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3524A4B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 821616109E;
 Wed, 13 Oct 2021 12:04:00 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1maczG-00GTgY-NZ; Wed, 13 Oct 2021 13:03:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers
 RAZ/WI
Date: Wed, 13 Oct 2021 13:03:38 +0100
Message-Id: <20211013120346.2926621-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

The ERR*/ERX* registers should be handled as RAZ/WI, and there
should be no need to involve EL1 for that.

Add a helper that handles such registers, and repaint the sysreg
table to declare these registers as RAZ/WI.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 33 ++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index f125d6a52880..042a1c0be7e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -248,6 +248,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
 }
 
+/* Handler to RAZ/WI sysregs */
+static bool pvm_access_raz_wi(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	if (!p->is_write)
+		p->regval = 0;
+
+	return true;
+}
+
 /*
  * Accessor for AArch32 feature id registers.
  *
@@ -270,9 +280,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
 		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_ELx_64BIT_ONLY);
 
-	/* Use 0 for architecturally "unknown" values. */
-	p->regval = 0;
-	return true;
+	return pvm_access_raz_wi(vcpu, p, r);
 }
 
 /*
@@ -301,6 +309,9 @@ static bool pvm_access_id_aarch64(struct kvm_vcpu *vcpu,
 /* Mark the specified system register as an AArch64 feature id register. */
 #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
 
+/* Mark the specified system register as Read-As-Zero/Write-Ignored */
+#define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
+
 /* Mark the specified system register as not being handled in hyp. */
 #define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
 
@@ -388,14 +399,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	HOST_HANDLED(SYS_AFSR1_EL1),
 	HOST_HANDLED(SYS_ESR_EL1),
 
-	HOST_HANDLED(SYS_ERRIDR_EL1),
-	HOST_HANDLED(SYS_ERRSELR_EL1),
-	HOST_HANDLED(SYS_ERXFR_EL1),
-	HOST_HANDLED(SYS_ERXCTLR_EL1),
-	HOST_HANDLED(SYS_ERXSTATUS_EL1),
-	HOST_HANDLED(SYS_ERXADDR_EL1),
-	HOST_HANDLED(SYS_ERXMISC0_EL1),
-	HOST_HANDLED(SYS_ERXMISC1_EL1),
+	RAZ_WI(SYS_ERRIDR_EL1),
+	RAZ_WI(SYS_ERRSELR_EL1),
+	RAZ_WI(SYS_ERXFR_EL1),
+	RAZ_WI(SYS_ERXCTLR_EL1),
+	RAZ_WI(SYS_ERXSTATUS_EL1),
+	RAZ_WI(SYS_ERXADDR_EL1),
+	RAZ_WI(SYS_ERXMISC0_EL1),
+	RAZ_WI(SYS_ERXMISC1_EL1),
 
 	HOST_HANDLED(SYS_TFSR_EL1),
 	HOST_HANDLED(SYS_TFSRE0_EL1),
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
