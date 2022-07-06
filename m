Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFC8C43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 17:05:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7AB4BECC;
	Wed,  6 Jul 2022 13:05:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mDhR7a2ipge8; Wed,  6 Jul 2022 13:05:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE854BECB;
	Wed,  6 Jul 2022 13:05:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 545F34BE4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sgg8eUGk2Du7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 13:05:34 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A73914BCCC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id C35FFCE2018;
 Wed,  6 Jul 2022 17:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E9BC341CA;
 Wed,  6 Jul 2022 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657127128;
 bh=cAGDdMafS96wyO8t0APfVo42s5sH9E1PNKcQhcywh9o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ETUdP8MmWLSUngYkXd6YnUzRYpnTa7YsN9A5guSSXY8VLWmkb7nFARl5QrVhd1vO1
 OgwR1xcAsgKNCVjEIYnqUSuz7MZPVdv8Ex0JWtQvSg0WW1ZZgbgIgwXDxQRD9Ckl/p
 oR9lS6Epazg24il2PDNBlJw7cnN43iWDhxtP1wSP2ZIKmkdbaidXB1RVike5KvOCBg
 Iop8btiY4f4DF1aHiomZBQ5zWZRUR3YrQfIrrVwVK85t6wcM8z7K9VCN+eEE3or9kE
 eg+jJzsnIlJH0ztMDO9nHNhO62XIMOH7EhL3c3N74y6YpXi9b/WT03j1wkPt/6Je7q
 vKbvJousjCMZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987M-005h9i-WE;
 Wed, 06 Jul 2022 17:43:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/19] KVM: arm64: vgic-v3: Use u32 to manage the line level
 from userspace
Date: Wed,  6 Jul 2022 17:42:56 +0100
Message-Id: <20220706164304.1582687-12-maz@kernel.org>
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

Despite the userspace ABI clearly defining the bits dealt with by
KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO as a __u32, the kernel uses a u64.

Use a u32 to match the userspace ABI, which will subsequently lead
to some simplifications.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 6 +++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 6 +++---
 arch/arm64/kvm/vgic/vgic-mmio.h       | 4 ++--
 arch/arm64/kvm/vgic/vgic.h            | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index d8269300632d..01285ee5cdf0 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -570,10 +570,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
 			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
 		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
+			if (is_write)
+				tmp32 = *reg;
 			intid = attr->attr &
 				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
 			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
-							      intid, reg);
+							      intid, &tmp32);
+			if (!is_write)
+				*reg = tmp32;
 		} else {
 			ret = -EINVAL;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a2ff73899976..91201f743033 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1154,7 +1154,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 }
 
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-				    u32 intid, u64 *val)
+				    u32 intid, u32 *val)
 {
 	if (intid % 32)
 		return -EINVAL;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 997d0fce2088..b32d434c1d4a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -775,10 +775,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 	}
 }
 
-u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
+u32 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
 {
 	int i;
-	u64 val = 0;
+	u32 val = 0;
 	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
 
 	for (i = 0; i < 32; i++) {
@@ -798,7 +798,7 @@ u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
 }
 
 void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
-				    const u64 val)
+				    const u32 val)
 {
 	int i;
 	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 6082d4b66d39..5b490a4dfa5e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -207,10 +207,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 		 bool is_write, int offset, u32 *val);
 
-u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
+u32 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
 
 void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
-				    const u64 val);
+				    const u32 val);
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c23118467a35..0c8da72953f0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -249,7 +249,7 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-				    u32 intid, u64 *val);
+				    u32 intid, u32 *val);
 int kvm_register_vgic_device(unsigned long type);
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
