Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FED8C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:07:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E69044B217;
	Mon, 29 Nov 2021 15:07:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nW+WX-bmaXfL; Mon, 29 Nov 2021 15:07:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0134B23B;
	Mon, 29 Nov 2021 15:07:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4AC4B241
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WGi+ffmAJUs8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:45 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F11674B210
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9C1C4B815DA;
 Mon, 29 Nov 2021 20:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DABEC53FAD;
 Mon, 29 Nov 2021 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216460;
 bh=1V+tSJ47CQKMJjjBnFGrwulS3BEp8dzYBPSx5F6d1xg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ivh9zUktPPU5JLepP58QrEPSQHNPFkllJpR6WUNviJEwg/vwcV15zNcby65cM9Tqx
 P5UQ8ODxxU0vGPm2voN00Wj9rPPRQOy0Lq55AZ+ORo0rkWhXEfBNLCqkmP+iSeQ4nM
 t3F+uOI9QiXCxEzEACpOHF2HErFj+1dH+85sm6TmTzi/CAg1UG5yM2dl4h286fnsoo
 6SpGptL/FPrJJdDM9AVoHpNxjKipzpppkr9jDOpSSqdeQvIYuvz45Ohke7JxwUkWB/
 OiBEwKv9A6sQoz8Du7smT1KwlcUNFCy6xhVMLAZOS2IyNTz1WuAvAn0T5TKa32El7v
 lfsuySoyD225g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqx-008gvR-9J; Mon, 29 Nov 2021 20:02:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 31/69] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit
 setting
Date: Mon, 29 Nov 2021 20:01:12 +0000
Message-Id: <20211129200150.351436-32-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

From: Jintack Lim <jintack@cs.columbia.edu>

Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
virtual HCR_EL2.NV bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 28 +++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 9759bc893a51..68af5509e4b0 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -20,6 +20,7 @@
 #define HCR_AMVOFFEN	(UL(1) << 51)
 #define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV1		(UL(1) << 43)
 #define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e96877fc3b2a..511e06b6f603 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -288,6 +288,22 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* This function is to support the recursive nested virtualization */
+static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	return forward_traps(vcpu, HCR_NV1);
+}
+
+static bool access_vbar_el1(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (forward_nv1_traps(vcpu, p))
+		return false;
+
+	return access_rw(vcpu, p, r);
+}
+
 static bool access_sctlr_el2(struct kvm_vcpu *vcpu,
 			     struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
@@ -1682,6 +1698,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+
 static bool access_elr(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
@@ -1689,6 +1706,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
 	else
@@ -1704,6 +1724,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return false;
+
 	if (p->is_write)
 		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
 	else
@@ -1719,6 +1742,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
 	else
@@ -1927,7 +1953,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
 
-	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_VBAR_EL1), access_vbar_el1, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
 	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
