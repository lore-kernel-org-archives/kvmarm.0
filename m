Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDC3C48BE3
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E04DB20673
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E04DB20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966224A332;
	Fri, 21 Jun 2019 05:39:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Racei4hwRzc3; Fri, 21 Jun 2019 05:39:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C684A4E9;
	Fri, 21 Jun 2019 05:39:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56E864A4EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:39:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eeT-j9s0hgHi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:39:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13AB94A4FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:39:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D126E142F;
 Fri, 21 Jun 2019 02:39:54 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D6AC3F246;
 Fri, 21 Jun 2019 02:39:53 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 27/59] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM
 settings
Date: Fri, 21 Jun 2019 10:38:11 +0100
Message-Id: <20190621093843.220980-28-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

From: Jintack Lim <jintack.lim@linaro.org>

Forward the EL1 virtual memory register traps to the virtual EL2 if they
are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 582d62aa48b7..0f74b9277a86 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -436,6 +436,27 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* This function is to support the recursive nested virtualization */
+static bool forward_vm_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	/* If a trap comes from the virtual EL2, the host hypervisor handles. */
+	if (vcpu_mode_el2(vcpu))
+		return false;
+
+	/*
+	 * If the virtual HCR_EL2.TVM or TRVM bit is set, we need to foward
+	 * this trap to the virtual EL2.
+	 */
+	if ((hcr_el2 & HCR_TVM) && p->is_write)
+		return true;
+	else if ((hcr_el2 & HCR_TRVM) && !p->is_write)
+		return true;
+
+	return false;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
@@ -452,6 +473,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
 
 	if (!p->is_write) {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
