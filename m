Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB70FC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77E5760FC3
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77E5760FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245014B1BA;
	Mon, 18 Oct 2021 17:12:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NEu21hVDoURG; Mon, 18 Oct 2021 17:12:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FC34B1ED;
	Mon, 18 Oct 2021 17:12:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B31844B1A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UDzMUjW+qYyx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 17:12:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85E504B1C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9206A6112D;
 Mon, 18 Oct 2021 21:12:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcZvW-0004Sc-RY; Mon, 18 Oct 2021 22:12:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 5/5] KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
Date: Mon, 18 Oct 2021 22:11:58 +0100
Message-Id: <20211018211158.3050779-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018211158.3050779-1-maz@kernel.org>
References: <20211018211158.3050779-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, drjones@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

With the transition to kvm_arch_vcpu_run_pid_change() to handle
the "run once" activities, it becomes obvious that has_run_once
is now an exact shadow of vcpu->pid.

Replace vcpu->arch.has_run_once with a new vcpu_has_run_once()
helper that directly checks for vcpu->pid, and get rid of the
now unused field.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 5 ++---
 arch/arm64/kvm/arm.c              | 8 +++-----
 arch/arm64/kvm/vgic/vgic-init.c   | 2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d7107d627c54..e0de761ecbf2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -366,9 +366,6 @@ struct kvm_vcpu_arch {
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
-	/* Detect first run of a vcpu */
-	bool has_run_once;
-
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
@@ -605,6 +602,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a52f6a76485d..222aabd57147 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -350,7 +350,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
+	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
@@ -608,7 +608,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	if (likely(vcpu->arch.has_run_once))
+	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
 	kvm_arm_vcpu_init_debug(vcpu);
@@ -639,8 +639,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
-	vcpu->arch.has_run_once = true;
-
 	return ret;
 }
 
@@ -1123,7 +1121,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * need to invalidate the I-cache though, as FWB does *not*
 	 * imply CTR_EL0.DIC.
 	 */
-	if (vcpu->arch.has_run_once) {
+	if (vcpu_has_run_once(vcpu)) {
 		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 			stage2_unmap_vm(vcpu->kvm);
 		else
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 340c51d87677..8d89ca15f613 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -91,7 +91,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->arch.has_run_once)
+		if (vcpu_has_run_once(vcpu))
 			goto out_unlock;
 	}
 	ret = 0;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
