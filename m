Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21443C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D234B370;
	Thu, 19 May 2022 09:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tD2IhRvj4Epr; Thu, 19 May 2022 09:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F784B3AA;
	Thu, 19 May 2022 09:45:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2E1400D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O3Q4a33nRyvs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:24 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF8DF4B3C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 65F2F6179F;
 Thu, 19 May 2022 13:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C8AC34119;
 Thu, 19 May 2022 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967923;
 bh=3CjY4Pec448XotcyN2iqZqW/AXk9FKiq5AorkwA5PIo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ah5dMC5WL11TdBzKBFW4Bm7Zf9QsydkXGKdBlSpTd3G5QGJbK85WTN2cy469QC4ob
 /Ke2PCNB091Ze8VKttP1KicuACFtsKPLDbf24CemZhY1WpCwsnIwK16Ry1BBmcRU4V
 V4Ooe8GEU+9EvDOonvoO5BlORgY7iMI/1dlajlgTk/j03cJwQ89WlP3IFCKa7osB2v
 BTGEs6Abq4Tr/F35/f96HSYeol7vZc0gf6QUbYifbzXQYgPWmkqEfNFND86Mxc1zRh
 VI+zByOsw5wmlxrriGPanviEM+V75OACVZrfev4deRza+qgONZSTQpWJ+cD6DUDWk1
 WemTltlhe7UrQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 45/89] KVM: arm64: Add the {flush,
 sync}_timer_state() primitives
Date: Thu, 19 May 2022 14:41:20 +0100
Message-Id: <20220519134204.5379-46-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

In preparation for save/restore of the timer state at EL2 for protected
VMs, introduce a couple of sync/flush primitives for the architected
timer, in much the same way as we have for the GIC.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 58515e5d24ec..32e7e1cad00f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -63,6 +63,38 @@ static void sync_vgic_state(struct kvm_vcpu *host_vcpu,
 		WRITE_ONCE(host_cpu_if->vgic_lr[i], shadow_cpu_if->vgic_lr[i]);
 }
 
+static void flush_timer_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	if (!shadow_state_is_protected(shadow_state))
+		return;
+
+	/*
+	 * A shadow vcpu has no offset, and sees vtime == ptime. The
+	 * ptimer is fully emulated by EL1 and cannot be trusted.
+	 */
+	write_sysreg(0, cntvoff_el2);
+	isb();
+	write_sysreg_el0(__vcpu_sys_reg(shadow_vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+	write_sysreg_el0(__vcpu_sys_reg(shadow_vcpu, CNTV_CTL_EL0), SYS_CNTV_CTL);
+}
+
+static void sync_timer_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	if (!shadow_state_is_protected(shadow_state))
+		return;
+
+	/*
+	 * Preserve the vtimer state so that it is always correct,
+	 * even if the host tries to make a mess.
+	 */
+	__vcpu_sys_reg(shadow_vcpu, CNTV_CVAL_EL0) = read_sysreg_el0(SYS_CNTV_CVAL);
+	__vcpu_sys_reg(shadow_vcpu, CNTV_CTL_EL0) = read_sysreg_el0(SYS_CNTV_CTL);
+}
+
 static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
@@ -85,6 +117,7 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	flush_vgic_state(host_vcpu, shadow_vcpu);
+	flush_timer_state(shadow_state);
 }
 
 static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
@@ -102,6 +135,7 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	host_vcpu->arch.flags		= shadow_vcpu->arch.flags;
 
 	sync_vgic_state(host_vcpu, shadow_vcpu);
+	sync_timer_state(shadow_state);
 }
 
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
