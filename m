From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] arm64: KVM: rename the capability to set guest SError syndrome
Date: Mon, 20 Aug 2018 14:37:31 -0400
Message-ID: <1534790251-15847-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

In the documentation description, this capability's name is
KVM_CAP_ARM_SET_SERROR_ESR, but in the header file this
capability's name is KVM_CAP_ARM_INJECT_SERROR_ESR, so it
is better to use a same name.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
In the Documentation/virtual/kvm/api.txt:

+8.19 KVM_CAP_ARM_SET_SERROR_ESR

In the include/uapi/linux/kvm.h:
+#define KVM_CAP_ARM_INJECT_SERROR_ESR 156

So in above two files, the capability's name is not same, it
is better to use a same name.
---
 arch/arm64/kvm/reset.c   | 2 +-
 include/uapi/linux/kvm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e37c78b..57dc6be 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -77,7 +77,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_arm_support_pmu_v3();
 		break;
-	case KVM_CAP_ARM_INJECT_SERROR_ESR:
+	case KVM_CAP_ARM_SET_SERROR_ESR:
 		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 07548de..fab7525 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -951,7 +951,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HYPERV_TLBFLUSH 155
 #define KVM_CAP_S390_HPAGE_1M 156
 #define KVM_CAP_NESTED_STATE 157
-#define KVM_CAP_ARM_INJECT_SERROR_ESR 158
+#define KVM_CAP_ARM_SET_SERROR_ESR 158
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
