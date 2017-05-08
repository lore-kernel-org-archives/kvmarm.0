From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 2/8] KVM: arm/arm64: vgic: Rename kvm_vgic_vcpu_init to
 kvm_vgic_vcpu_enable
Date: Mon,  8 May 2017 13:54:48 +0200
Message-ID: <20170508115454.5075-3-cdall@linaro.org>
References: <20170508115454.5075-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F43040C2E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 07:51:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B-XUHjJj6Kj4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 May 2017 07:51:50 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11E4940BD2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 07:51:49 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id 142so62136805wma.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 May 2017 04:55:03 -0700 (PDT)
In-Reply-To: <20170508115454.5075-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This function really doesn't init anything, it enables the CPU
interface, so name it as such, which gives us the name to use for actual
init work later on.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 87de048..0ea64a1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -226,11 +226,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
-/**
- * kvm_vgic_vcpu_init() - Enable the VCPU interface
- * @vcpu: the VCPU which's VGIC should be enabled
- */
-static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_enable(vcpu);
@@ -269,7 +265,7 @@ int vgic_init(struct kvm *kvm)
 		dist->msis_require_devid = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vgic_vcpu_init(vcpu);
+		kvm_vgic_vcpu_enable(vcpu);
 
 	ret = kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-- 
2.9.0
