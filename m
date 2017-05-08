From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 5/8] KVM: arm/arm64: Slightly rework kvm_vgic_addr
Date: Mon,  8 May 2017 13:54:51 +0200
Message-ID: <20170508115454.5075-6-cdall@linaro.org>
References: <20170508115454.5075-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C66140C30
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 07:51:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zeujm0cBd5+j for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 May 2017 07:51:52 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E44E40C47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 07:51:52 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id u65so81766919wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 May 2017 04:55:05 -0700 (PDT)
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

As we are about to handle setting the address for the redistributor base
region separately from some of the other base addresses, let's rework
this function to leave a little more room for being flexible in what
each type of base address does.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index d48743c..69ccfd5 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -37,6 +37,14 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+static int vgic_check_type(struct kvm *kvm, int type_needed)
+{
+	if (kvm->arch.vgic.vgic_model != type_needed)
+		return -ENODEV;
+	else
+		return 0;
+}
+
 /**
  * kvm_vgic_addr - set or get vgic VM base addresses
  * @kvm:   pointer to the vm struct
@@ -57,40 +65,36 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 {
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
-	int type_needed;
 	phys_addr_t *addr_ptr, alignment;
 
 	mutex_lock(&kvm->lock);
 	switch (type) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_4K;
 		break;
 	case KVM_VGIC_V2_ADDR_TYPE_CPU:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_cpu_base;
 		alignment = SZ_4K;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_DIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_64K;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_redist_base;
 		alignment = SZ_64K;
 		break;
 	default:
 		r = -ENODEV;
-		goto out;
 	}
 
-	if (vgic->vgic_model != type_needed) {
-		r = -ENODEV;
+	if (r)
 		goto out;
-	}
 
 	if (write) {
 		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
-- 
2.9.0
