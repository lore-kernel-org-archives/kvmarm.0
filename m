Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F28AC43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5610C4B405;
	Fri, 10 Jun 2022 05:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fe3wMl7V+mio; Fri, 10 Jun 2022 05:35:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 257F74B324;
	Fri, 10 Jun 2022 05:35:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16B504B3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bHe7glP1e45y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09BE04B3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 34BCFB83325;
 Fri, 10 Jun 2022 09:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D11C341C4;
 Fri, 10 Jun 2022 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853739;
 bh=jY7capbQWpRL/mfEd8bo/OvFLW5YsGuOxg2agadD9ak=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kbl1paOmICAL96GE9BWZvOXF+lp5QEZ1t9vpI5nWbr188BtFce2dg0l63ZpF6evBp
 /wNVsHtAntiLkr/T+AYIoGpnpM7yoRR87VIvb+V6z0e2N0L5q1yV6pLAVadehW075X
 1p3yaEsJfYMVQmt6qkT61j+QANQejNOdB1obnmCNTlFVaSM77RqRWzxOgHZ37ii7vo
 Oc4nPHR5nGDSyD95Mn8yZa3+tSwmHBKNxQ0sx/7G08PkIFUd8Z2oHiMzXvysm0kxXR
 hVlzTMm7pSA10JsVTGfCcusXoFCCQS6tFsvLaz/Ul7CJ2nMLsFk4yS+clmzXl+OwK/
 duwdbUyoTwdTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawr-00H6Dt-7L; Fri, 10 Jun 2022 10:28:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 14/19] KVM: arm64: Convert vcpu sysregs_loaded_on_cpu to a
 state flag
Date: Fri, 10 Jun 2022 10:28:33 +0100
Message-Id: <20220610092838.1205755-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

The aptly named boolean 'sysregs_loaded_on_cpu' tracks whether
some of the vcpu system registers are resident on the physical
CPU when running in VHE mode.

This is obviously a flag in hidding, so let's convert it to
a state flag, since this is solely a host concern (the hypervisor
itself always knows which state we're in).

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  | 6 ++----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 4 ++--
 arch/arm64/kvm/sys_regs.c          | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 39da28f85045..ffbeb5f5692e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -410,10 +410,6 @@ struct kvm_vcpu_arch {
 	/* Additional reset state */
 	struct vcpu_reset_state	reset_state;
 
-	/* True when deferrable sysregs are loaded on the physical CPU,
-	 * see kvm_vcpu_load_sysregs_vhe and kvm_vcpu_put_sysregs_vhe. */
-	bool sysregs_loaded_on_cpu;
-
 	/* Guest PV state */
 	struct {
 		u64 last_steal;
@@ -520,6 +516,8 @@ struct kvm_vcpu_arch {
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
 #define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
+/* vcpu system registers loaded on physical CPU */
+#define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 007a12dd4351..7b44f6b3b547 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -79,7 +79,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_user_state(guest_ctxt);
 	__sysreg_restore_el1_state(guest_ctxt);
 
-	vcpu->arch.sysregs_loaded_on_cpu = true;
+	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
 
 	activate_traps_vhe_load(vcpu);
 }
@@ -110,5 +110,5 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
-	vcpu->arch.sysregs_loaded_on_cpu = false;
+	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f24797c57df8..1c562bcfeccf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -72,7 +72,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
 
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
+	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
 	    __vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
@@ -81,7 +81,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
+	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
 	    __vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
