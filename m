Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFE4C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 16:19:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E867F2075B
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 16:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qw60EwTz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E867F2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1ED4B17D;
	Fri,  5 Jun 2020 12:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJEW5nmpXAsZ; Fri,  5 Jun 2020 12:19:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 346D94B15C;
	Fri,  5 Jun 2020 12:19:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF494B15D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 12:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3+6yuH14Cn6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 12:18:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1DB84B07F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 12:18:58 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 985CB206DB;
 Fri,  5 Jun 2020 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591373937;
 bh=paJXf48AWQH6tw11YLkNIpuHunscwji3xlYKrNSY0oo=;
 h=From:To:Cc:Subject:Date:From;
 b=Qw60EwTzazbCTcePt+nm7ifIpHUNoIxiUj2mmFBkwGDmtc3RNXQuLeGnFhtfSD6H/
 KGeyiVDYs0Cmx/cIVyQ8nzbE4iWSn/EkqeGk3ePL3mTYMXlHdOzuFkkHX9+a8I1X7L
 WuIwLjVGJPwOvsP4HtcuxWjk8wBt3x9iZCO3h6ug=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jhF3Y-000YzD-2R; Fri, 05 Jun 2020 17:18:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Remove host_cpu_context member from vcpu structure
Date: Fri,  5 Jun 2020 17:18:47 +0100
Message-Id: <20200605161847.1316354-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 kernel-team@android.com, ascull@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

For very long, we have kept this pointer back to the per-cpu
host state, despite having working per-cpu accessors at EL2
for some time now.

Recent investigations have shown that this pointer is easy
to abuse in preemptible context, which is a sure sign that
it would better be gone. Not to mention that a per-cpu
pointer is faster to access at all times.

Reported-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
This patch goes on top of the PtrAuth rework that I have previously
posted, and make sures it is harder to fall into the same trap.

 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 3 ---
 arch/arm64/kvm/hyp/debug-sr.c     | 4 ++--
 arch/arm64/kvm/hyp/switch.c       | 6 +++---
 arch/arm64/kvm/hyp/sysreg-sr.c    | 6 ++++--
 arch/arm64/kvm/pmu.c              | 8 ++------
 6 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59029e90b557..ada1faa92211 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -284,9 +284,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	/* Pointer to host CPU context */
-	struct kvm_cpu_context *host_cpu_context;
-
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14b747266607..6ddaa23ef346 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,10 +340,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
-	kvm_host_data_t *cpu_data;
 
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
-	cpu_data = this_cpu_ptr(&kvm_host_data);
 
 	/*
 	 * We might get preempted before the vCPU actually runs, but
@@ -355,7 +353,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 0fc9872a1467..e95af204fec7 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -185,7 +185,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
@@ -207,7 +207,7 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index fc09c3dfa466..fc671426c14b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -544,7 +544,7 @@ static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
-	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	__ptrauth_save_key(ctxt->sys_regs, APIA);
 	__ptrauth_save_key(ctxt->sys_regs, APIB);
 	__ptrauth_save_key(ctxt->sys_regs, APDA);
@@ -715,7 +715,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
@@ -820,7 +820,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	vcpu = kern_hyp_va(vcpu);
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 6d2df9fe0b5d..143d7b7358f2 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -265,12 +265,13 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
 
 	if (!has_vhe())
 		return;
 
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
 
 	/*
@@ -301,12 +302,13 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
 
 	if (!has_vhe())
 		return;
 
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	deactivate_traps_vhe_put();
 
 	__sysreg_save_el1_state(guest_ctxt);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index e71d00bb5271..ebf8509b418b 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -163,15 +163,13 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
  */
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	host = __hyp_this_cpu_ptr(kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
@@ -184,15 +182,13 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
 	if (!has_vhe())
 		return;
 
-	host_ctxt = vcpu->arch.host_cpu_context;
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	host = __hyp_this_cpu_ptr(kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
