Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D22CCA482
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:20:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7761D4C56F;
	Thu, 14 Jul 2022 11:20:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1QW2fSGkJsm4; Thu, 14 Jul 2022 11:20:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E71414C582;
	Thu, 14 Jul 2022 11:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC0E4C523
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9h6k5cNP6YEQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:20:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E6E84C591
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B8419B8271B;
 Thu, 14 Jul 2022 15:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFB7C341D0;
 Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812031;
 bh=aiG8Qo8PK+WaeP+Vh//T6vOxpzY6+j8+fH98hVRy9JU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jr7IDODsRN4BJ2HBYWjaTV6dMRKVfS/ORqqh3eYHaQ+iQarlp+DjJ4W0GD9GZzD3K
 eeiZ3Ep2J5GAxd1gcmzzCWCsFGNSSmv59USPc8gXcrfIJsASHOnMpbwyMUzKD5+Pqt
 aSNkQW6+IZkFzhbbYUkUUft9EajxS3VM2UB+V/As4JrehJYFjGJnw0sAyeDWAk3Gg8
 Ak8twjBk+ToBUqvlsiQUYq2YqfN+p5N964/U4K15syB5S9vkKoVUnSV6BGRYXI0JpO
 uceTrkJRdz3PIDSrnkDlv4InJM3Gj1jJOaWrZWMlvECVyyyXZuf1TDDFxquVVtXVCK
 tZscTnBePasQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dh-007UVL-68;
 Thu, 14 Jul 2022 16:20:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 07/20] KVM: arm64: vgic-v3: Simplify
 vgic_v3_has_cpu_sysregs_attr()
Date: Thu, 14 Jul 2022 16:20:11 +0100
Message-Id: <20220714152024.1673368-8-maz@kernel.org>
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

Finding out whether a sysreg exists has little to do with that
register being accessed, so drop the is_write parameter.

Also, the reg pointer is completely unused, and we're better off
just passing the attr pointer to the function.

This result in a small cleanup of the calling site, with a new
helper converting the vGIC view of a sysreg into the canonical
one (this is purely cosmetic, as the encoding is the same).

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c   | 14 ++++++++++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  8 ++------
 arch/arm64/kvm/vgic/vgic.h         |  3 +--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 644acda33c7c..85a5e1d15e9f 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -260,12 +260,18 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), access_gic_grpen1 },
 };
 
-int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-				u64 *reg)
+static u64 attr_to_id(u64 attr)
 {
-	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
+}
 
-	if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	if (get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
 			  ARRAY_SIZE(gic_v3_icc_reg_descs)))
 		return 0;
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index f15e29cc63ce..a2ff73899976 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -986,12 +986,8 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		iodev.base_addr = 0;
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 reg, id;
-
-		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
-		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v3_has_cpu_sysregs_attr(vcpu, attr);
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4c6bdd321faa..ffc2d3c81b28 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -247,8 +247,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 u64 id, u64 *val);
-int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-				u64 *reg);
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
