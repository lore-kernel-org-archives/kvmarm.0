Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7E0C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1058320661
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+vgQctM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1058320661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B87924A4AA;
	Tue, 11 Feb 2020 12:51:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DaH154yPxssD; Tue, 11 Feb 2020 12:51:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7936A4A946;
	Tue, 11 Feb 2020 12:51:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FAF14AEA5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUW37ZXhVR6J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:51:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B1594AECF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:23 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5F54E20870;
 Tue, 11 Feb 2020 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443482;
 bh=ZVZYEbQ3L/ZhoKR/Tpg2cujpRiPoqAF6wbwuNvpBz5o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=t+vgQctMWbpQKaRhXVd3mCvkKfXcMYMwJc0ULkPZWwrqbddICINbhfDZlZF/5IwOi
 18Hrp7e7wfBHUBx4xE4N9Dn1FUpx4S6zkouJCbb8XfwqQoqRwm+NFpt8bXxpXDIqRH
 t1Xtvgx3Ut/D43gPbyPpf2C2FBVTD0vbCLH7lmtk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1ZgM-004O7k-KG; Tue, 11 Feb 2020 17:50:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 90/94] KVM: arm64: nv: Sync nested timer state with ARMv8.4
Date: Tue, 11 Feb 2020 17:49:34 +0000
Message-Id: <20200211174938.27809-91-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

From: Christoffer Dall <christoffer.dall@arm.com>

Emulating the ARMv8.4-NV timers is a bit odd, as the timers can
be reconfigured behind our back without the hypervisor even
noticing. In the VHE case, that's an actual regression in the
architecture...

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_arch_timer.h |  3 ++-
 virt/kvm/arm/arch_timer.c    | 41 +++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/arm.c           |  7 ++++--
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 3389606f3029..2442de2c4a6e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -75,7 +75,8 @@ int kvm_timer_hyp_init(bool);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f9ef86752630..b95798f81764 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -710,6 +710,45 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	set_cntvoff(0);
 }
 
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_ARM64
+	if (!is_hyp_ctxt(vcpu))
+		return;
+
+	/*
+	 * Guest hypervisors using ARMv8.4 enhanced nested virt support have
+	 * their EL1 timer register accesses redirected to the VNCR page.
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		/*
+		 * For a non-VHE guest hypervisor, we update the hardware
+		 * timer registers with the latest value written by the guest
+		 * to the VNCR page and let the hardware take care of the
+		 * rest.
+		 */
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
+	} else {
+		/*
+		 * For a VHE guest hypervisor, the emulated state (which
+		 * is stored in the VNCR page) could have been updated behind
+		 * our back, and we must reset the emulation of the timers.
+		 */
+
+		struct timer_map map;
+		get_timer_map(vcpu, &map);
+
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
+		soft_timer_cancel(&map.emul_ptimer->hrtimer);
+		timer_emulate(map.emul_vtimer);
+		timer_emulate(map.emul_ptimer);
+	}
+#endif
+}
+
 /*
  * With a userspace irqchip we have to check if the guest de-asserted the
  * timer and if so, unmask the timer irq signal on the host interrupt
@@ -728,7 +767,7 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
+void kvm_timer_sync_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index fa73b7a464f1..e8fedbfacc2c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -730,7 +730,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
-				kvm_timer_sync_hwstate(vcpu);
+				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			local_irq_enable();
 			preempt_enable();
@@ -781,7 +781,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * timer virtual interrupt state.
 		 */
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
-			kvm_timer_sync_hwstate(vcpu);
+			kvm_timer_sync_user(vcpu);
+
+		if (enhanced_nested_virt_in_use(vcpu))
+			kvm_timer_sync_nested(vcpu);
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
