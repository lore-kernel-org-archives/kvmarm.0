Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF42CCA482
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CCB4C600;
	Thu, 14 Jul 2022 11:35:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YJIM+p222Opc; Thu, 14 Jul 2022 11:35:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08BAA4C5EF;
	Thu, 14 Jul 2022 11:35:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C984C590
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0OFGUadwFrS2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:29 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 237DF4C595
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:29 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0EDEE61F33;
 Thu, 14 Jul 2022 15:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25C0C34114;
 Thu, 14 Jul 2022 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812927;
 bh=a5fxg1hLUdYodaw2rlD+TJsGx9o54mh3SudXII6uJD8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WTloMO1ih35sC0DIKOjFMZiOGXUDtK9ilL/riTn6Dh7AVL1LD8FeJ2f0Im7R16tYb
 maLJatS5y34BUND+V3sSX1Laii3G6hYKuA0Uqe3WHO/b7iY7d8j24fqBCNEaO83TnU
 1vDxlJc5zS/6Yjho+cr2Nyg/YClCXTjX+1cjmqSmGMcnb4PrOlepKZdwhNmpwAB7du
 wcPFWW0XeD2+KhvtTV8EmKsSf9QCxpeZNNL/Gzrg2EZ85DObxBjrmh7iAk34W7tEY0
 NPFYLxbbssAaLFJLowh+5ERLtNdQirhh+SPlAVQF3cLDf3dHcC3tvnaZsDfPfWlV+c
 KGHVOUsR4yJQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dj-007UVL-Og;
 Thu, 14 Jul 2022 16:20:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 13/20] KVM: arm64: vgic-v2: Consolidate userspace access
 for MMIO registers
Date: Thu, 14 Jul 2022 16:20:17 +0100
Message-Id: <20220714152024.1673368-14-maz@kernel.org>
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

Align the GICv2 MMIO accesses from userspace with the way the GICv3
code is now structured.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 39 ++++++++++++---------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index e9db6795fb90..066b95d606fd 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -348,17 +348,18 @@ bool lock_all_vcpus(struct kvm *kvm)
  *
  * @dev:      kvm device handle
  * @attr:     kvm device attribute
- * @reg:      address the value is read or written
  * @is_write: true if userspace is writing a register
  */
 static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 				    struct kvm_device_attr *attr,
-				    u32 *reg, bool is_write)
+				    bool is_write)
 {
+	u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
 	int ret;
+	u32 val;
 
 	ret = vgic_v2_parse_attr(dev, attr, &reg_attr);
 	if (ret)
@@ -367,6 +368,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	vcpu = reg_attr.vcpu;
 	addr = reg_attr.addr;
 
+	if (is_write)
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
 	mutex_lock(&dev->kvm->lock);
 
 	ret = vgic_init(dev->kvm);
@@ -380,10 +385,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &val);
 		break;
 	default:
 		ret = -EINVAL;
@@ -393,6 +398,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && !is_write)
+		ret = put_user(val, uaddr);
+
 	return ret;
 }
 
@@ -407,15 +416,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg;
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		return vgic_v2_attr_regs_access(dev, attr, &reg, true);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_attr_regs_access(dev, attr, true);
 	}
 
 	return -ENXIO;
@@ -432,15 +434,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg = 0;
-
-		ret = vgic_v2_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		return put_user(reg, uaddr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_attr_regs_access(dev, attr, false);
 	}
 
 	return -ENXIO;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
