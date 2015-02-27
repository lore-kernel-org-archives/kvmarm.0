From: weiyj_lk@163.com
Subject: [PATCH] arm/arm64: KVM: fix missing unlock on error in kvm_vgic_create()
Date: Fri, 27 Feb 2015 19:41:45 +0800
Message-ID: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function kvm_vgic_create()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 virt/kvm/arm/vgic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 0cc6ab6..4b2c2e7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1583,8 +1583,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * emulation. So check this here again. KVM_CREATE_DEVICE does
 	 * the proper checks already.
 	 */
-	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2)
-		return -ENODEV;
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	/*
 	 * Any time a vcpu is run, vcpu_load is called which tries to grab the

