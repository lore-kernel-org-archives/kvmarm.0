From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/26] arm/arm64: KVM: Enable 32 bits kvm vcpu events support
Date: Fri, 19 Oct 2018 13:59:00 +0100
Message-ID: <20181019125901.185478-26-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1104A2F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s9JaBBCsoxsY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D14264A2BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:31 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
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
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Dongjiu Geng <gengdongjiu@huawei.com>

The commit 539aee0edb9f ("KVM: arm64: Share the parts of
get/set events useful to 32bit") shares the get/set events
helper for arm64 and arm32, but forgot to share the cap
extension code.

User space will check whether KVM supports vcpu events by
checking the KVM_CAP_VCPU_EVENTS extension

Acked-by: James Morse <james.morse@arm.com>
Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/reset.c | 1 -
 virt/kvm/arm/arm.c     | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 337d2fbc2f06..b72a3dd56204 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -86,7 +86,6 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
-	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_VM_IPA_SIZE:
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7c9d7b51ce89..11b98b2b0486 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -213,6 +213,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
2.19.1
