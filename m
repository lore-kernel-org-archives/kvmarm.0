From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH] KVM: arm/arm64: Fix bug in advertising KVM_CAP_MSI_DEVID capability
Date: Sat,  8 Jul 2017 08:48:30 -0500
Message-ID: <1499521710-27494-1-git-send-email-shankerd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>, Vikram Sethi <vikrams@codeaurora.org>, Andre Przywara <andre.przywara@arm.com>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Commit 0e4e82f154e3 ("KVM: arm64: vgic-its: Enable ITS emulation as
a virtual MSI controller") tried to advertise KVM_CAP_MSI_DEVID, but
the code logic was not updating the dist->msis_require_devid field
correctly. If hypervisor tool creates the ITS device after VGIC
initialization then we don't advertise KVM_CAP_MSI_DEVID capability.

Update the field msis_require_devid to true inside vgic_its_create()
to fix the issue.

Fixes: 0e4e82f154e3 ("vgic-its: Enable ITS emulation as a virtual MSI controller")
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 3 ---
 virt/kvm/arm/vgic/vgic-its.c  | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 3a0b899..5801261 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,9 +285,6 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	if (vgic_has_its(kvm))
-		dist->msis_require_devid = true;
-
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2dff288..aa6b68d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1598,6 +1598,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
 
+	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
 	its->enabled = false;
 	its->dev = dev;
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
