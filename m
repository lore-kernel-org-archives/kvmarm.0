From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/58] KVM: arm: Handle VCPU device attributes in guest.c
Date: Fri, 30 Jun 2017 09:44:35 +0100
Message-ID: <20170630084514.6779-20-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACD540D29
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EPieWQkGIc5M for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4345440D8B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:22 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

As we are about to support VCPU attributes to set the timer IRQ numbers
in guest.c, move the static inlines for the VCPU attributes handlers
from the header file to guest.c.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h | 22 +++++++--------------
 arch/arm/kvm/guest.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 00ad56ee6455..127e2dd2e21c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -291,20 +291,12 @@ static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
-static inline int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
-static inline int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
-static inline int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
+
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
 
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index fa6182a40941..acea05e9db4e 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -301,3 +301,45 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 {
 	return -EINVAL;
 }
+
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
-- 
2.11.0
