Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C92CCA47B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B7C4C5F2;
	Thu, 14 Jul 2022 11:35:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aexZ44RApi0j; Thu, 14 Jul 2022 11:35:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE56B4C5E5;
	Thu, 14 Jul 2022 11:35:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3691C4C5E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THpPQEtwPNN9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:27 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 101374C592
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3737AB82372;
 Thu, 14 Jul 2022 15:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC62C3411C;
 Thu, 14 Jul 2022 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812923;
 bh=ewFZDRbbTUSr1/RjHEhxuF5bx6bfhbtmusxOWTcVpCI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SsGdmmQxlag22n9+IC2c7Vq7/1EoxwUJ1bOrfTn1a7X5UfCaZlnu2y/H10lLUInnX
 YnIOt/dwIH9eHngc9UzTfmczDy7SFq2/hq14uC8syglUevYXLUeMKigSlfAKnwIZoU
 vWgVbKsc0saFqR4wWSgOkPcVolefTHP7of2+WDI75tP8e+wseBBDHz628QP9ockhDd
 kBSTMAyP5nJhLnxkZJrzmLpvG6Zi3vVjv7c/WnqOnhP7pxbTD/a/K20kFSUitECXUc
 NcryuXUnlX4I34KoiP4LH72quXV0pqZvRhNMqOfjJZ4domzY1Mp4VcQcfza6nvVf2G
 Xw4ixWVe+Y/HA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dk-007UVL-LK;
 Thu, 14 Jul 2022 16:20:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 17/20] KVM: arm64: vgic: Tidy-up calls to vgic_{get,
 set}_common_attr()
Date: Thu, 14 Jul 2022 16:20:21 +0100
Message-Id: <20220714152024.1673368-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

The userspace accessors have an early call to vgic_{get,set}_common_attr()
that makes the code hard to follow. Move it to the default: clause of
the decoding switch statement, which results in a nice cleanup.

This requires us to move the handling of the pending table into the
common handling, even if it is strictly a GICv3 feature (it has the
benefit of keeping the whole control group handling in the same
function).

Also cleanup vgic_v3_{get,set}_attr() while we're at it, deduplicating
the calls to vgic_v3_attr_regs_access().

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 78 +++++++++------------------
 1 file changed, 26 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 011171dc41c5..edeac2380591 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -246,6 +246,24 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			r = vgic_init(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
+			/*
+			 * OK, this one isn't common at all, but we
+			 * want to handle all control group attributes
+			 * in a single place.
+			 */
+			if (vgic_check_type(dev->kvm, KVM_DEV_TYPE_ARM_VGIC_V3))
+				return -ENXIO;
+			mutex_lock(&dev->kvm->lock);
+
+			if (!lock_all_vcpus(dev->kvm)) {
+				mutex_unlock(&dev->kvm->lock);
+				return -EBUSY;
+			}
+			r = vgic_v3_save_pending_tables(dev->kvm);
+			unlock_all_vcpus(dev->kvm);
+			mutex_unlock(&dev->kvm->lock);
+			return r;
 		}
 		break;
 	}
@@ -427,37 +445,25 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 static int vgic_v2_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_set_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		return vgic_v2_attr_regs_access(dev, attr, true);
+	default:
+		return vgic_set_common_attr(dev, attr);
 	}
-
-	return -ENXIO;
 }
 
 static int vgic_v2_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_get_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		return vgic_v2_attr_regs_access(dev, attr, false);
+	default:
+		return vgic_get_common_attr(dev, attr);
 	}
-
-	return -ENXIO;
 }
 
 static int vgic_v2_has_attr(struct kvm_device *dev,
@@ -618,61 +624,29 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_set_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
-		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
 		return vgic_v3_attr_regs_access(dev, attr, true);
-	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
-		int ret;
-
-		switch (attr->attr) {
-		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
-			mutex_lock(&dev->kvm->lock);
-
-			if (!lock_all_vcpus(dev->kvm)) {
-				mutex_unlock(&dev->kvm->lock);
-				return -EBUSY;
-			}
-			ret = vgic_v3_save_pending_tables(dev->kvm);
-			unlock_all_vcpus(dev->kvm);
-			mutex_unlock(&dev->kvm->lock);
-			return ret;
-		}
-		break;
-	}
+	default:
+		return vgic_set_common_attr(dev, attr);
 	}
-	return -ENXIO;
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_get_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
-		return vgic_v3_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
 		return vgic_v3_attr_regs_access(dev, attr, false);
+	default:
+		return vgic_get_common_attr(dev, attr);
 	}
-	return -ENXIO;
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
