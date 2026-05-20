Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731213AD515
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271330; cv=none; b=ompgnXeNmDIuvN9o+ttAn/zBJ2xHHpwS4sOvHqtGhovxz1fdWO8fZ35QiUXk3Uh3T8pp0Fb3/25Xo+uuEtY4fFkpReFXheHJvHKsx4Xc1evDM1MpXcbHcZaEwvmceONOLHfCbRxkPvghESNTh3B1nyEJGIqs6iZh/tcoyF1yMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271330; c=relaxed/simple;
	bh=Oo0HFa7VNKhuT2pfUnEyb+aph9czAy2eK1wH3BZ+a1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXfJhSOETFsvM9YK7k8AlDM1Q5nilwtq9m6RvcxhC9kwZ7Gsf0eo0RB6SzVAXakggd6kgQrkNzm3RV3gwq/izetmstEewpHQVoNemTLgGlWWUnP2c+1EKhiaFl4PlOryjlAGsG7KRG7PqcFgnQS+yJwESKVkvizeNOzgEwxt5dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yr8IV7BI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yr8IV7BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DDA1F00896;
	Wed, 20 May 2026 10:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271328;
	bh=tB774sdEjGOsUuihk5n6/aTLO5S2y/yue2pNnYlb8Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr8IV7BIV0VSWdKaAC9t7xpdAB1Ht5L6qejJHwV+Pth6oVq0xpa+7QFREyHNT35Pa
	 wLnEulZtONP1oKmxv7QOfuorXajsnVzxOF8YESO52M0PUm/5KpHM4SEc9VT0ChcdVs
	 FoEy/eUahOD1YWP2iybcQqQtNGD+Azjc+BkCyWZpgzl7OPxBHtAg5UgNbgnhtVrkIr
	 PoB/f/VnhBFK8hkgirdUymxBWEqKw16nxsejAPCKj9dLIuF/a5LsWSEiBlTm58hz9y
	 tN2+A1NvZTlBB8wH4GovDcFsMWFcaESFoWP4wY5uDedTZDh1Zehe0Nh8/nYG3KzMti
	 FdWERqpA26tNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkc-00000004Jio-212F;
	Wed, 20 May 2026 10:02:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 5/6] KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
Date: Wed, 20 May 2026 11:01:59 +0100
Message-ID: <20260520100200.543845-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make sure that any attempt to inject an interrupt from userspace
or an irqfd results in the GICv2 lazy init to take place.

This is not currently necessary as the init is also performed on
*any* interrupt injection. But as we're about to remove that,
let's introduce it here.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c             | 15 +++++++++++++--
 arch/arm64/kvm/vgic/vgic-irqfd.c |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6e6dc17f8b606..cfb7921fc7d75 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,6 +51,7 @@
 
 #include <linux/irqchip/arm-gic-v5.h>
 
+#include "vgic/vgic.h"
 #include "sys_regs.h"
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
@@ -1497,8 +1498,13 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 
 		return vcpu_interrupt_line(vcpu, irq_num, level);
 	case KVM_ARM_IRQ_TYPE_PPI:
-		if (!irqchip_in_kernel(kvm))
+		if (irqchip_in_kernel(kvm)) {
+			int ret = vgic_lazy_init(kvm);
+			if (ret)
+				return ret;
+		} else {
 			return -ENXIO;
+		}
 
 		vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
 		if (!vcpu)
@@ -1525,8 +1531,13 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
-		if (!irqchip_in_kernel(kvm))
+		if (irqchip_in_kernel(kvm)) {
+			int ret = vgic_lazy_init(kvm);
+			if (ret)
+				return ret;
+		} else {
 			return -ENXIO;
+		}
 
 		if (vgic_is_v5(kvm)) {
 			/* Build a GICv5-style IntID here */
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index b9b86e3a6c862..19a1094536e6a 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -20,9 +20,15 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
 			int level, bool line_status)
 {
 	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	int ret;
 
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
+
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
+
 	return kvm_vgic_inject_irq(kvm, NULL, spi_id, level, NULL);
 }
 
-- 
2.47.3

