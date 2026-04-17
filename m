Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDE439D6F2
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776429979; cv=none; b=kAOZDBlSS4og7kZagjPy+KOmubbESN611oYBajdCuK8KSNcnBZOvW5SRgHoYiyfHcChsJMN9xxa/TOZbAvUl9qKwwj4HBc1+lOGjpvh6R/i1kiIFy+DWHCJcgt9NaLIWuUs3hkcaRs/T9TujZfnpib9QqBuOpyb/432u2SjWX+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776429979; c=relaxed/simple;
	bh=kFA288NlmP/ThIs4VFFDZrv24ox81bH/b4T77Zp7qXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkMQ6zH3emsFriMFFwCfXg/TOLOzfgjkv/xlcdQGRHTTxSj/iA54AKSCWHbb2UMrQm8PNrlLltzmlZh7jhkdG+uLhkveblq+NWQSofdDBZYDj3h8eXjyfKz4B3QVr+woymhvgoSFqtWXr+bI/DIse4d93gr9v318vPJr4JghnGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skf+N3/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skf+N3/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4CAC2BCB7;
	Fri, 17 Apr 2026 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429979;
	bh=kFA288NlmP/ThIs4VFFDZrv24ox81bH/b4T77Zp7qXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skf+N3/oUH0YiiHAyALoeglRGUqaIxJGAf3QgpuWMb+P0ekAz93xdB3+Pc9eSKlRS
	 cWQv2j/I1Ad2q/RPc1E+b2SzieS4pIb4OTp63uXZHxr9xCk6Wz89kZERDxjW8uzjzt
	 rSJPXMjaH4b5+/WgeorZrq2owgOEQwkaGk28tsxZHYEGpYOxgigabTPDsqhlqzuI1p
	 /TGkHNCjNKOpBYsxe8pGgyQbwEEgsuTaPFYUjCVEmCtin6Bu+3bymewGiu+aFKfMV6
	 vhwh8PQQf9EutmdTM5HjMvxTZAKtnMR3panSM/gpTiyqgXkJXczoi5neYuDQKfqPQD
	 djSsQwkvMOs9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wDiaP-0000000CRo5-0aal;
	Fri, 17 Apr 2026 12:46:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/4] KVM: arm64: vgic-v2: Force vgic init on injection from userspace
Date: Fri, 17 Apr 2026 13:46:11 +0100
Message-ID: <20260417124612.2770268-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417124612.2770268-1-maz@kernel.org>
References: <20260417124612.2770268-1-maz@kernel.org>
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
results in the GICv2 lazy init to take place. This is not currently
necessary as the init is also performed on *any* interrupt injection.

But as we're about to remove that, let's introduce it here.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

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
-- 
2.47.3

