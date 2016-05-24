From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 48/59] KVM: arm/arm64: vgic-new: Add userland access to VGIC
 dist registers
Date: Tue, 24 May 2016 11:09:42 +0200
Message-ID: <1464080993-10884-49-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D41F349B7C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RK7Dz91jvQw2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:18 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 082BA49BDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:11 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id a136so62272220wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:44 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Userland may want to save and restore the state of the in-kernel VGIC,
so we provide the code which takes a userland request and translate
that into calls to our MMIO framework.

>From Christoffer:
When accessing the VGIC state from userspace we really don't want a VCPU
to be messing with the state at the same time, and the API specifies
that we should return -EBUSY if any VCPUs are running.
Check and prevent VCPUs from running by grabbing their mutexes, one by
one, and error out if we fail.
(Note: This could potentially be simplified to just do a simple check
and see if any VCPUs are running, and return -EBUSY then, without
enforcing the locking throughout the duration of the uaccess, if we
think that taking/releasing all these mutexes for every single GIC
register access is too heavyweight.)

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 55 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 78621283..9ee27cb 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -238,7 +238,60 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u32 *reg, bool is_write)
 {
-	return -ENXIO;
+	gpa_t addr;
+	int cpuid, ret, c;
+	struct kvm_vcpu *vcpu, *tmp_vcpu;
+	int vcpu_lock_idx = -1;
+
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	mutex_lock(&dev->kvm->lock);
+
+	ret = vgic_init(dev->kvm);
+	if (ret)
+		goto out;
+
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
+	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
+	 * that no other VCPUs are run and fiddle with the vgic state while we
+	 * access it.
+	 */
+	ret = -EBUSY;
+	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
+		if (!mutex_trylock(&tmp_vcpu->mutex))
+			goto out;
+		vcpu_lock_idx = c;
+	}
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		ret = -EINVAL;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		tmp_vcpu = kvm_get_vcpu(dev->kvm, vcpu_lock_idx);
+		mutex_unlock(&tmp_vcpu->mutex);
+	}
+
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
 }
 
 /* V2 ops */
-- 
2.1.2.330.g565301e.dirty
