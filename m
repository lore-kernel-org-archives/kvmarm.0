From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [RESEND PATCH] KVM: arm/arm64: vgic: Stop injecting the MSI occurrence twice
Date: Fri,  3 Feb 2017 08:39:49 -0600
Message-ID: <1486132790-20890-1-git-send-email-shankerd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Vikram Sethi <vikrams@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

The IRQFD framework calls the architecture dependent function
twice if the corresponding GSI type is edge triggered. For ARM,
the function kvm_set_msi() is getting called twice whenever the
IRQFD receives the event signal. The rest of the code path is
trying to inject the MSI without any validation checks. No need
to call the function vgic_its_inject_msi() second time to avoid
an unnecessary overhead in IRQ queue logic. It also avoids the
possibility of VM seeing the MSI twice.

Simple fix, return -1 if the argument 'level' value is zero.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
Forgot to CC the kvmarm list earlier, including now.

 virt/kvm/arm/vgic/vgic-irqfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index d918dcf..f138ed2 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -99,6 +99,9 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	if (!vgic_has_its(kvm))
 		return -ENODEV;
 
+	if (!level)
+		return -1;
+
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
