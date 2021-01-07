Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13448C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9711623341
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9711623341
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4312B4B3F5;
	Thu,  7 Jan 2021 06:50:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IEclYEjk5S79; Thu,  7 Jan 2021 06:50:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C154B3DA;
	Thu,  7 Jan 2021 06:50:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD4A4B3D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:50:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r6gkwklkLXe2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:50:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6D664B3C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:50:48 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EACB32333D;
 Thu,  7 Jan 2021 11:50:47 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM5-005p1o-Ab; Thu, 07 Jan 2021 11:21:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/18] KVM: arm64: Move double-checked lock to
 kvm_vgic_map_resources()
Date: Thu,  7 Jan 2021 11:20:54 +0000
Message-Id: <20210107112101.2297944-12-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

kvm_vgic_map_resources() is called when a VCPU if first run and it maps all
the VGIC MMIO regions. To prevent double-initialization, the VGIC uses the
ready variable to keep track of the state of resources and the global KVM
mutex to protect against concurrent accesses. After the lock is taken, the
variable is checked again in case another VCPU took the lock between the
current VCPU reading ready equals false and taking the lock.

The double-checked lock pattern is spread across four different functions:
in kvm_vcpu_first_run_init(), in kvm_vgic_map_resource() and in
vgic_{v2,v3}_map_resources(), which makes it hard to reason about and
introduces minor code duplication. Consolidate the checks in
kvm_vgic_map_resources(), where the lock is taken.

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201201150157.223625-4-alexandru.elisei@arm.com
---
 arch/arm64/kvm/arm.c            | 8 +++-----
 arch/arm64/kvm/vgic/vgic-init.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-v2.c   | 3 ---
 arch/arm64/kvm/vgic/vgic-v3.c   | 3 ---
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e207e4541f55..ab782c480e9a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -580,11 +580,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		 * Map the VGIC hardware resources before running a vcpu the
 		 * first time on this VM.
 		 */
-		if (unlikely(!vgic_ready(kvm))) {
-			ret = kvm_vgic_map_resources(kvm);
-			if (ret)
-				return ret;
-		}
+		ret = kvm_vgic_map_resources(kvm);
+		if (ret)
+			return ret;
 	} else {
 		/*
 		 * Tell the rest of the code that there are userspace irqchip
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 32e32d67a127..a2f4d1c85f00 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -428,7 +428,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
+	if (likely(vgic_ready(kvm)))
+		return 0;
+
 	mutex_lock(&kvm->lock);
+	if (vgic_ready(kvm))
+		goto out;
+
 	if (!irqchip_in_kernel(kvm))
 		goto out;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index ebf53a4e1296..7f38c1a93639 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -306,9 +306,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
-	if (vgic_ready(kvm))
-		goto out;
-
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
 		kvm_err("Need to set vgic cpu and dist addresses first\n");
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9cdf39a94a63..35029c5cb0f1 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -500,9 +500,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	int ret = 0;
 	int c;
 
-	if (vgic_ready(kvm))
-		goto out;
-
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
