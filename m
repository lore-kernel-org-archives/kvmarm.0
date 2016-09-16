From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v3 1/2] KVM: arm/arm64: Add vcpu ENABLE_CAP functionality
Date: Fri, 16 Sep 2016 08:26:26 +0200
Message-ID: <1474007187-18673-2-git-send-email-agraf@suse.de>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0276412A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 02:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nF17SX9gYwHk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 02:18:32 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C563140B40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 02:18:31 -0400 (EDT)
In-Reply-To: <1474007187-18673-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
2.6.6
