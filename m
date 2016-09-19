From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v4 1/2] KVM: arm/arm64: Add vcpu ENABLE_CAP functionality
Date: Mon, 19 Sep 2016 13:14:54 +0200
Message-ID: <1474283695-212421-2-git-send-email-agraf@suse.de>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1474283695-212421-1-git-send-email-agraf@suse.de>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, drjones@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In a follow-up patch we will need to enable capabilities on demand for
backwards compatibility. This patch adds the generic framework to handle
vcpu cap enablement to the arm code base.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 Documentation/virtual/kvm/api.txt |  4 +++-
 arch/arm/kvm/arm.c                | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 739db9a..23937e0 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -997,7 +997,9 @@ documentation when it pops into existence).
 
 Capability: KVM_CAP_ENABLE_CAP, KVM_CAP_ENABLE_CAP_VM
 Architectures: x86 (only KVM_CAP_ENABLE_CAP_VM),
-	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390
+	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390,
+	       arm (only KVM_CAP_ENABLE_CAP),
+	       arm64 (only KVM_CAP_ENABLE_CAP)
 Type: vcpu ioctl, vm ioctl (with KVM_CAP_ENABLE_CAP_VM)
 Parameters: struct kvm_enable_cap (in)
 Returns: 0 on success; -1 on error
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75f130e..c84b6ad 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -878,6 +878,23 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
+				     struct kvm_enable_cap *cap)
+{
+	int r;
+
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -941,6 +958,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_ENABLE_CAP:
+	{
+		struct kvm_enable_cap cap;
+
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			return -EFAULT;
+		return kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
1.8.5.6

