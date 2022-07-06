Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA13CCA481
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 16:43:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3763E4BEB5;
	Wed,  6 Jul 2022 12:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QmGq7Vr6xezY; Wed,  6 Jul 2022 12:43:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9A94BED3;
	Wed,  6 Jul 2022 12:43:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DC0D4BEA1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PdqITHiu2zwt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CDFE4BE99
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 96B8161DD6;
 Wed,  6 Jul 2022 16:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67576C341CE;
 Wed,  6 Jul 2022 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657125794;
 bh=C2LHKbJX9HtJY5cAtJJRir+r7abzOZhmmXdipxuYdEA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hWR3KqOLY7gbL8FWsqC9saSKQ/BxzLvs/jDHQLENFaX+BMPJU9yQZKGHZ+X7VrcPa
 /JIREkc4vlheR7FRZC5iT2xtjNycsxqpccsJM8LYAS289s86C9isj8f/ZqsNzlhsA3
 t3Sqj2mTP1aa8gChcwL4e/KjUcRqrbujE4KxM9pPCHgpWoQzFVEO0ca4yRUTdwm52D
 EX2dpkU0sEcqUCTCHzB/07pTItH12sHhm+w1xDxPxkeX8y2UU4h8rweDTZIxDPpBN0
 or170HhSrXiyZFrDX2loQzcqWQ5m3EEUWsFYHogZ6CN36pTQF9LcBo1n24sncv3lOA
 /IrdpyM/pHy0g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987M-005h9i-BI;
 Wed, 06 Jul 2022 17:43:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/19] KVM: arm64: vgic-v3: Push user access into
 vgic_v3_cpu_sysregs_uaccess()
Date: Wed,  6 Jul 2022 17:42:53 +0100
Message-Id: <20220706164304.1582687-9-maz@kernel.org>
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

In order to start making the vgic sysreg access from userspace
similar to all the other sysregs, push the userspace memory
access one level down into vgic_v3_cpu_sysregs_uaccess().

The next step will be to rely on the sysreg infrastructure
to perform this task.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c      | 22 +++++++++++++------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 31 ++++++---------------------
 arch/arm64/kvm/vgic/vgic.h            |  4 ++--
 3 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 85a5e1d15e9f..8c56e285fde9 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -278,15 +278,21 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
 	return -ENXIO;
 }
 
-int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-				u64 *reg)
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr,
+				bool is_write)
 {
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
-	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+	u64 sysreg;
 
-	if (is_write)
-		params.regval = *reg;
+	sysreg = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+
+	if (is_write) {
+		if (get_user(params.regval, uaddr))
+			return -EFAULT;
+	}
 	params.is_write = is_write;
 
 	r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
@@ -297,8 +303,10 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 	if (!r->access(vcpu, &params, r))
 		return -EINVAL;
 
-	if (!is_write)
-		*reg = params.regval;
+	if (!is_write) {
+		if (put_user(params.regval, uaddr))
+			return -EFAULT;
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c6d52a1fd9c8..d8269300632d 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -561,14 +561,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		if (!is_write)
 			*reg = tmp32;
 		break;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 regid;
-
-		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
-		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
-						  regid, reg);
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
-	}
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		unsigned int info, intid;
 
@@ -617,15 +612,8 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		reg = tmp32;
 		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 reg;
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v3_attr_regs_access(dev, attr, NULL, true);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u64 reg;
@@ -681,15 +669,8 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		tmp32 = reg;
 		return put_user(tmp32, uaddr);
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 reg;
-
-		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		return put_user(reg, uaddr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v3_attr_regs_access(dev, attr, NULL, false);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u64 reg;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ffc2d3c81b28..c23118467a35 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -245,8 +245,8 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
-int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-			 u64 id, u64 *val);
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr, bool is_write);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
