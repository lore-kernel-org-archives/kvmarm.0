From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 13/13] KVM: arm/arm64: Hold slots_lock when unregistering kvm
 io bus devices
Date: Thu, 18 May 2017 11:47:22 +0200
Message-ID: <20170518094722.9926-14-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B2140C41
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l4yqIIlhHiJL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:20 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A463B40C8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:19 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id b84so195123078wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:50 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We were not holding the kvm->slots_lock as required when calling
kvm_io_bus_unregister_dev() as required.

This only affects the error path, but still, let's do our due
diligence.

Reported by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 9b0f681..201d5e2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -614,15 +614,16 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
 				      SZ_64K, &sgi_dev->dev);
-	mutex_unlock(&kvm->slots_lock);
 	if (ret) {
 		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
 					  &rd_dev->dev);
-		return ret;
+		goto out;
 	}
 
 	vgic->vgic_redist_free_offset += 2 * SZ_64K;
-	return 0;
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
 }
 
 static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
@@ -647,10 +648,12 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 
 	if (ret) {
 		/* The current c failed, so we start with the previous one. */
+		mutex_lock(&kvm->slots_lock);
 		for (c--; c >= 0; c--) {
 			vcpu = kvm_get_vcpu(kvm, c);
 			vgic_unregister_redist_iodev(vcpu);
 		}
+		mutex_unlock(&kvm->slots_lock);
 	}
 
 	return ret;
-- 
2.9.0
