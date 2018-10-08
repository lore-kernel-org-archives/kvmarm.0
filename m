From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v2 2/2] arm/arm64: KVM: enable 32 bits kvm vcpu events support
Date: Mon, 8 Oct 2018 08:34:48 -0400
Message-ID: <1539002088-21215-3-git-send-email-gengdongjiu@huawei.com>
References: <1539002088-21215-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3E24A2A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Oct 2018 00:27:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dPTTHc3mLKkB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Oct 2018 00:27:20 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F10464A2E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Oct 2018 00:27:19 -0400 (EDT)
In-Reply-To: <1539002088-21215-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com, marc.zyngier@arm.com, peter.maydell@linaro.org, drjones@redhat.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

The commit 539aee0edb9f ("KVM: arm64: Share the parts of
get/set events useful to 32bit") shares the get/set events
helper for arm64 and arm32, it is better also share the check
for vcpu events capability to enable 32 bit kvm vcpu events
support.

User space will check whether KVM supports vcpu events through
KVM_CAP_VCPU_EVENTS IOCTL.

Cc: James Morse <james.morse@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
For the 32 bits kvm migration, it needs to enable the vcpu events,
this patch will enable it. The user space QEMU patch is here:
https://patchwork.ozlabs.org/patch/975615/
---
 arch/arm64/kvm/reset.c | 1 -
 virt/kvm/arm/arm.c     | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index fd37c53..e50245e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -82,7 +82,6 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
-	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
 	default:
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 40e79ea..64e5d97 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -212,6 +212,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
1.9.1
