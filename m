From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v4 2/2] arm/arm64: KVM: enable 32 bits kvm vcpu events support
Date: Sat, 13 Oct 2018 00:12:49 +0800
Message-ID: <20181012161249.9236-3-gengdongjiu@huawei.com>
References: <20181012161249.9236-1-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012161249.9236-1-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, peter.maydell@linaro.org, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

The commit 539aee0edb9f ("KVM: arm64: Share the parts of
get/set events useful to 32bit") shares the get/set events
helper for arm64 and arm32, but forgot to share the cap
extension code.

User space will check whether KVM supports vcpu events by
checking the KVM_CAP_VCPU_EVENTS extension

Cc: James Morse <james.morse@arm.com>
Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Acked-by: James Morse <james.morse@arm.com>
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
