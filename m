Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA44C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6658610A2
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A6658610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB6A4B1AC;
	Mon, 18 Oct 2021 17:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kDAs2dGXEBRp; Mon, 18 Oct 2021 17:12:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6066E4B1D4;
	Mon, 18 Oct 2021 17:12:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 205C34B0BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x7mm2tLxq5K8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 17:12:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D5094B192
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 51656610A2;
 Mon, 18 Oct 2021 21:12:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcZvW-0004Sc-Ik; Mon, 18 Oct 2021 22:12:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 4/5] KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
 kvm_vcpu_first_run_init()
Date: Mon, 18 Oct 2021 22:11:57 +0100
Message-Id: <20211018211158.3050779-5-maz@kernel.org>
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

The kvm_arch_vcpu_run_pid_change() helper gets called on each PID
change. The kvm_vcpu_first_run_init() helper gets run on the...
first run(!) of a vcpu.

As it turns out, the first run of a vcpu also triggers a PID change
event (vcpu->pid is initially NULL).

Use this property to merge these two helpers and get rid of another
arm64-specific oddity.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 42efca9853fb..a52f6a76485d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,22 +583,34 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
-int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_vcpu_run_map_fp(vcpu);
+	return vcpu->arch.target >= 0;
 }
 
-static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+/*
+ * Handle both the initialisation that is being done when the vcpu is
+ * run for the first time, as well as the updates that must be
+ * performed each time we get a new thread dealing with this vcpu.
+ */
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int ret = 0;
+	int ret;
 
-	if (likely(vcpu->arch.has_run_once))
-		return 0;
+	if (!kvm_vcpu_initialized(vcpu))
+		return -ENOEXEC;
 
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	ret = kvm_arch_vcpu_run_map_fp(vcpu);
+	if (ret)
+		return ret;
+
+	if (likely(vcpu->arch.has_run_once))
+		return 0;
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -679,11 +691,6 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
-static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.target >= 0;
-}
-
 static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
@@ -779,13 +786,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	int ret;
 
-	if (unlikely(!kvm_vcpu_initialized(vcpu)))
-		return -ENOEXEC;
-
-	ret = kvm_vcpu_first_run_init(vcpu);
-	if (ret)
-		return ret;
-
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
 		if (ret)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
