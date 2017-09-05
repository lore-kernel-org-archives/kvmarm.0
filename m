From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 1/8] KVM: arm/arm64: Fix bug in advertising KVM_CAP_MSI_DEVID capability
Date: Tue,  5 Sep 2017 16:52:00 +0200
Message-ID: <20170905145207.18447-2-cdall@linaro.org>
References: <20170905145207.18447-1-cdall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Shanker Donthineni <shankerd@codeaurora.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shanker Donthineni <shankerd@codeaurora.org>

Commit 0e4e82f154e3 ("KVM: arm64: vgic-its: Enable ITS emulation as
a virtual MSI controller") tried to advertise KVM_CAP_MSI_DEVID, but
the code logic was not updating the dist->msis_require_devid field
correctly. If hypervisor tool creates the ITS device after VGIC
initialization then we don't advertise KVM_CAP_MSI_DEVID capability.

Update the field msis_require_devid to true inside vgic_its_create()
to fix the issue.

Cc: stable@vger.kernel.org
Fixes: 0e4e82f154e3 ("vgic-its: Enable ITS emulation as a virtual MSI controller")
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.9.0
