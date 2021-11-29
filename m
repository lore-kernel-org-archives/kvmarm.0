Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E505C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:05:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D6B4B120;
	Mon, 29 Nov 2021 15:05:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fjwWzdYieAlb; Mon, 29 Nov 2021 15:05:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7C84B128;
	Mon, 29 Nov 2021 15:05:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E97A4B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1CSb4hTEeu18 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:05:35 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DB494B0BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:05:35 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 22941B815D4;
 Mon, 29 Nov 2021 20:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DB2C53FC7;
 Mon, 29 Nov 2021 20:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216333;
 bh=yFzHvZHmLWVQ5Alroj3R7LTAUDXudcyHYsHt6+CZyUo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lCP49rAxfLBrtts+Cylj0RyWq0HatgNVC5Hh12QS8tk3y3uRDhwVThjGtBst0ZKYF
 1Vsilg9n0EQmZHsK10/OVXgfVGYUL3QqdTm6uwt1R1orBinPqacJAHZPpCAXyK1y6f
 Exn3iIRBrXUxDqxliXqLUr77wTZSEGGzzIhZpRoFyUJxW1LOOB3Z9dQ9d7DseyDlnq
 RIVltBKjxaQt4EGdym83x5Z9pxwIXmqokF93yM3/lv/azPzh2nmxe2a7Vou7R0NJ4f
 uwnp/hIye0t1Ys2HSF3x43hSf3ZtNjNENwoY7EdT4oSaSngvHJGh5WvEfLqJTJfT8y
 Q+d7dnArbdBBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqu-008gvR-Lr; Mon, 29 Nov 2021 20:02:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 23/69] KVM: arm64: nv: Trap EL1 VM register accesses in
 virtual EL2
Date: Mon, 29 Nov 2021 20:01:04 +0000
Message-Id: <20211129200150.351436-24-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

When running in virtual EL2 mode, we actually run the hardware in EL1
and therefore have to use the EL1 registers to ensure correct operation.

By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
doesn't shoot itself in the foot when setting up what it believes to be
a different mode's system register state (for example when preparing to
switch to a VM).

We can leverage the existing sysregs infrastructure to support trapped
accesses to these registers.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  7 ++++++-
 arch/arm64/kvm/sys_regs.c               | 19 ++++++++++++++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 96c5f3fb7838..0987abd4d57d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -111,10 +111,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmuserenr_el0);
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d13115a12434..b005eabcaddc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -39,7 +39,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9d5572ceb001..87a68496073a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -33,9 +33,14 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	u64 hcr = vcpu->arch.hcr_el2;
 	u64 val;
 
-	___activate_traps(vcpu);
+	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
+	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		hcr |= HCR_TVM | HCR_TRVM;
+
+	___activate_traps(vcpu, hcr);
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1408dff58fa..19f7e2260462 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -350,8 +350,15 @@ static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
 
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
- * is set. If the guest enables the MMU, we stop trapping the VM
- * sys_regs and leave it in complete control of the caches.
+ * is set.
+ *
+ * This is set in two cases: either (1) we're running at vEL2, or (2)
+ * we're running at EL1 and the guest has its MMU off.
+ *
+ * (1) TVM/TRVM is set, as we need to virtualise some of the VM
+ * registers for the guest hypervisor
+ * (2) Once the guest enables the MMU, we stop trapping the VM sys_regs
+ * and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -360,7 +367,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	BUG_ON(!p->is_write);
+	/* We don't expect TRVM on the host */
+	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
+
+	if (!p->is_write) {
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+		return true;
+	}
 
 	get_access_mask(r, &mask, &shift);
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
