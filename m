Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA640C43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9854C5DC;
	Thu, 14 Jul 2022 11:35:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wu9UsRFjr4G6; Thu, 14 Jul 2022 11:35:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7EA4C5D3;
	Thu, 14 Jul 2022 11:35:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8F34C5B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NHMu2MHr-yIQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80A7A4C5C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DECE961F32;
 Thu, 14 Jul 2022 15:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472D9C34115;
 Thu, 14 Jul 2022 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812931;
 bh=8yV7Y9kOcNA1k+NqDqEyD5lcvHMCVqKOvW0jND4T+Go=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CBrfnRXyFVYu8qwT4xyL60uucw+2z3vlLokuLGUn73D7Wg0QR1al9xC52kKwWo0uw
 KtkTSFwpzmeweQzf/tIDNlRPNUmEIFIyq9H7Mcmbma65M8OGsf01glYC1URNVy9fF5
 iN+/V2z193SXkGYw02bcoIS0O0ND3yN1ftpRnMOEOQZ3TILgbR5+GUbwD1ae0l7pAe
 N1t9FqgHzao5XG5REf3FafopWOf7Vh8qajR4aWIMkBrDa3s313j/+ArAzgvYiCuvkN
 k7n6u+arJbx5RRa8J76AJ+wxbc2Xrx+egN9rq8gb0E38Ni+roP5JXet5Jr3kJj03rk
 PSJV0qFkbXy1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dk-007UVL-7H;
 Thu, 14 Jul 2022 16:20:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 15/20] KVM: arm64: vgic-v2: Add helper for legacy
 dist/cpuif base address setting
Date: Thu, 14 Jul 2022 16:20:19 +0100
Message-Id: <20220714152024.1673368-16-maz@kernel.org>
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

We carry a legacy interface to set the base addresses for GICv2.
As this is currently plumbed into the same handling code as
the modern interface, it limits the evolution we can make there.

Add a helper dedicated to this handling, with a view of maybe
removing this in the future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c                  | 11 ++-------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
 include/kvm/arm_vgic.h                |  1 +
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 83a7f61354d3..bf39570c0aef 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 					struct kvm_arm_device_addr *dev_addr)
 {
-	unsigned long dev_id, type;
-
-	dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
-		KVM_ARM_DEVICE_ID_SHIFT;
-	type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
-		KVM_ARM_DEVICE_TYPE_SHIFT;
-
-	switch (dev_id) {
+	switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
 	case KVM_ARM_DEVICE_VGIC_V2:
 		if (!vgic_present)
 			return -ENXIO;
-		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
+		return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
 	default:
 		return -ENODEV;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c17e5502c0b3..04175fd55da6 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
 		return 0;
 }
 
+int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
+{
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	int r;
+
+	mutex_lock(&kvm->lock);
+	switch (FIELD_GET(KVM_ARM_DEVICE_TYPE_MASK, dev_addr->id)) {
+	case KVM_VGIC_V2_ADDR_TYPE_DIST:
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		if (!r)
+			r = vgic_check_iorange(kvm, vgic->vgic_dist_base, dev_addr->addr,
+					       SZ_4K, KVM_VGIC_V2_DIST_SIZE);
+		if (!r)
+			vgic->vgic_dist_base = dev_addr->addr;
+		break;
+	case KVM_VGIC_V2_ADDR_TYPE_CPU:
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		if (!r)
+			r = vgic_check_iorange(kvm, vgic->vgic_cpu_base, dev_addr->addr,
+					       SZ_4K, KVM_VGIC_V2_CPU_SIZE);
+		if (!r)
+			vgic->vgic_cpu_base = dev_addr->addr;
+		break;
+	default:
+		r = -ENODEV;
+	}
+
+	mutex_unlock(&kvm->lock);
+
+	return r;
+}
+
 /**
  * kvm_vgic_addr - set or get vgic VM base addresses
  * @kvm:   pointer to the vm struct
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2d8f2e90edc2..f79cce67563e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -365,6 +365,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
