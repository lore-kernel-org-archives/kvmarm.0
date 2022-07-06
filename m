Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40467C43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 17:05:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7FA4BE5B;
	Wed,  6 Jul 2022 13:05:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-zMVjwPqHeF; Wed,  6 Jul 2022 13:05:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE484BEAC;
	Wed,  6 Jul 2022 13:05:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CBA4BEAB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i0nu-KUoXFPd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 13:05:25 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E0794BEB7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:25 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D994561E42;
 Wed,  6 Jul 2022 17:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AACDC341CE;
 Wed,  6 Jul 2022 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657127124;
 bh=SzPjuICUXJCvp7Vyuk4xgoPaa1J68WeSY55X5c3s7E4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mNmdlYOPGWqMPt6F0RNswucx/WjxxHsiS7b6Vrmn7juUr+L1KYydfabS7maWs72TH
 ShptmKAtYryxigs0+2TE2+SqHz3I5QYtpOo2Vc4oO6lylpkYgCAH2+lDXubdkk8ssA
 CUWa0M1BxY21VES/03yqMbTEQyReLBKU/slhFZDml9kVnJY86qoThEYWULoCkwdRUy
 TSFrRrEWcppu1sx6n0bf+AXTy8riBDvz6oIyKgSRw0RydO19w+QpmSHHYYIF6l4uDe
 NX9Addy1mDAxSpo8ho9Gki0VjHwfX51LPTi/YTBKsSo64K8O1QQnw4laDpf+TPOfxY
 iLwRDlMMP2XKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987N-005h9i-G0;
 Wed, 06 Jul 2022 17:43:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/19] KVM: arm64: vgic-v2: Consolidate userspace access for
 MMIO registers
Date: Wed,  6 Jul 2022 17:42:58 +0100
Message-Id: <20220706164304.1582687-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 schspa@gmail.com, kernel-team@android.com
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 40 ++++++++++++---------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 925875722027..ddead333c232 100644
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
@@ -393,6 +398,11 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && !is_write)
+		if (put_user(val, uaddr))
+			ret = -EFAULT;
+
 	return ret;
 }
 
@@ -407,15 +417,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 
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
@@ -432,15 +435,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 
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
