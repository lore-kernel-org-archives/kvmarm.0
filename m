Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13C3C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B4D323340
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B4D323340
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43E74B3E0;
	Thu,  7 Jan 2021 06:50:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W5-iY1uk54YC; Thu,  7 Jan 2021 06:50:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6044B3E6;
	Thu,  7 Jan 2021 06:50:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 240CF4B3D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:50:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uejneowci5PP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:50:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 001BE4B3DE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:49:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3178C2333E;
 Thu,  7 Jan 2021 11:49:59 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM8-005p1o-9V; Thu, 07 Jan 2021 11:21:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 14/18] KVM: arm64: Consolidate dist->ready setting into
 kvm_vgic_map_resources()
Date: Thu,  7 Jan 2021 11:20:57 +0000
Message-Id: <20210107112101.2297944-15-maz@kernel.org>
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

dist->ready setting is pointlessly spread across the two vgic
backends, while it could be consolidated in kvm_vgic_map_resources().

Move it there, and slightly simplify the flows in both backends.

Suggested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |  2 ++
 arch/arm64/kvm/vgic/vgic-v2.c   | 17 ++++++-----------
 arch/arm64/kvm/vgic/vgic-v3.c   | 18 ++++++------------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 5b54787a9ad5..052917deb149 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -446,6 +446,8 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 
 	if (ret)
 		__kvm_vgic_destroy(kvm);
+	else
+		dist->ready = true;
 
 out:
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 7f38c1a93639..11934c2af2f4 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -309,14 +309,12 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
 		kvm_err("Need to set vgic cpu and dist addresses first\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (!vgic_v2_check_base(dist->vgic_dist_base, dist->vgic_cpu_base)) {
 		kvm_err("VGIC CPU and dist frames overlap\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -326,13 +324,13 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	ret = vgic_init(kvm);
 	if (ret) {
 		kvm_err("Unable to initialize VGIC dynamic data structures\n");
-		goto out;
+		return ret;
 	}
 
 	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V2);
 	if (ret) {
 		kvm_err("Unable to register VGIC MMIO regions\n");
-		goto out;
+		return ret;
 	}
 
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
@@ -341,14 +339,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
 					    KVM_VGIC_V2_CPU_SIZE, true);
 		if (ret) {
 			kvm_err("Unable to remap VGIC CPU to VCPU\n");
-			goto out;
+			return ret;
 		}
 	}
 
-	dist->ready = true;
-
-out:
-	return ret;
+	return 0;
 }
 
 DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 35029c5cb0f1..52915b342351 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -505,21 +505,18 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 		if (IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr)) {
 			kvm_debug("vcpu %d redistributor base not set\n", c);
-			ret = -ENXIO;
-			goto out;
+			return -ENXIO;
 		}
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
 		kvm_err("Need to set vgic distributor addresses first\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (!vgic_v3_check_base(kvm)) {
 		kvm_err("VGIC redist and dist frames overlap\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -527,22 +524,19 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	 * the VGIC before we need to use it.
 	 */
 	if (!vgic_initialized(kvm)) {
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V3);
 	if (ret) {
 		kvm_err("Unable to register VGICv3 dist MMIO regions\n");
-		goto out;
+		return ret;
 	}
 
 	if (kvm_vgic_global_state.has_gicv4_1)
 		vgic_v4_configure_vsgis(kvm);
-	dist->ready = true;
 
-out:
-	return ret;
+	return 0;
 }
 
 DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
