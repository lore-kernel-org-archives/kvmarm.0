Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84033C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 15:00:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D21092084C
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 15:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D21092084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E5B4C282;
	Tue,  1 Dec 2020 10:00:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vvJtpwZl0TbJ; Tue,  1 Dec 2020 10:00:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F2E4C287;
	Tue,  1 Dec 2020 10:00:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD974C270
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 10:00:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gP6GL2e1fB7P for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 10:00:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 446C24C26F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 10:00:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0E9D30E;
 Tue,  1 Dec 2020 07:00:44 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E33A63F575;
 Tue,  1 Dec 2020 07:00:43 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
Subject: [PATCH 3/5] KVM: arm64: Move double-checked lock to
 kvm_vgic_map_resources()
Date: Tue,  1 Dec 2020 15:01:55 +0000
Message-Id: <20201201150157.223625-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201150157.223625-1-alexandru.elisei@arm.com>
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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
---
 arch/arm64/kvm/arm.c            | 8 +++-----
 arch/arm64/kvm/vgic/vgic-init.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-v2.c   | 3 ---
 arch/arm64/kvm/vgic/vgic-v3.c   | 3 ---
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9d69d2bf6943..65a5e89f5133 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -530,11 +530,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
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
