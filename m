Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA915366075
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776852135; cv=none; b=jeSGjjeqWEj5kShguB3HrkakfKBCRm7hapALIU9vuWxQeSl9GNL2KUtgyYlrZ5YngmnX0pwhvs6bd7I1e/Ae3FVaLxpfLTREBFDI6Vh5Ht1bwwKIeTouyW1t+qBb9phb0uoia0GjVBjgRjOIPUfLe+BatJUhhbCwmrK6CQrXq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776852135; c=relaxed/simple;
	bh=axFrI5UOMgvvCv5/3fhLhydt6PvPA2EyBTnm72OVc6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+ZHmftawSUn+okViPvzNoET7dLFLPMibWscZzJ08V8l1NligPnQQmmcAjd89h+pJnXvpiA3FKCXeAARMtCKz50efRoWU89CYdaf88xy981al+QuUUjcWTfdaq/h3DVEPleLBsk3dIxRgBaj2eQIQ5gDED2owtujIAtX6owExkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t44RbhoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t44RbhoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB6C2BCC6;
	Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776852135;
	bh=axFrI5UOMgvvCv5/3fhLhydt6PvPA2EyBTnm72OVc6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t44RbhoBeVqcgb3OoHzkP6j2LZFVWMmchvQvs/4Q1l5/hRcyoD832Qp/TT7Pk8Wfl
	 xLxTx5WI7/DNf8tm0OsAPAmYpMVM2230Wo9XmThh63G7eQ4/LctSI50D8LJpDkD9XN
	 EJciXINuAwQeo+H1nwS72l0AzPkeN46QS3VbTpraKvKs3hwkhV9gs5uNKydfgnq0l7
	 ZH1F0gtzybjPfECCtEKlAi91iiRDQCyMULhbWSEcPkoCAF9N/56oKyJdlCnZWvRoWB
	 ubfwoIEcd+ofNGdZKd40yx81fEZuSSvQQJgDsX4yNYxB1g5meLpRCn+5RSsGzsneRq
	 ecQXAbKR3T1ZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFUPN-0000000Dh6d-2D7T;
	Wed, 22 Apr 2026 10:02:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 3/4] KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
Date: Wed, 22 Apr 2026 11:02:09 +0100
Message-ID: <20260422100210.3008156-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422100210.3008156-1-maz@kernel.org>
References: <20260422100210.3008156-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make sure that any attempt to inject an interrupt from userspace
or an irqfd results in the GICv2 lazy init to take place.

This is not currently necessary as the init is also performed on
*any* interrupt injection. But as we're about to remove that,
let's introduce it here.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c             | 7 +++++++
 arch/arm64/kvm/vgic/vgic-irqfd.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad30..e856cf4099f42 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,6 +51,7 @@
 
 #include <linux/irqchip/arm-gic-v5.h>
 
+#include "vgic/vgic.h"
 #include "sys_regs.h"
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
@@ -1475,6 +1476,12 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 
 	trace_kvm_irq_line(irq_type, vcpu_id, irq_num, irq_level->level);
 
+	if (irqchip_in_kernel(kvm)) {
+		int ret = vgic_lazy_init(kvm);
+		if (ret)
+			return ret;
+	}
+
 	switch (irq_type) {
 	case KVM_ARM_IRQ_TYPE_CPU:
 		if (irqchip_in_kernel(kvm))
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

