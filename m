From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v3 1/3] arm64: kvm: support kvmtool to detect RAS extension
 feature
Date: Sun, 30 Apr 2017 13:37:55 +0800
Message-ID: <1493530677-4919-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF8440F8A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 01:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zOB633T6zY1J for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Apr 2017 01:25:04 -0400 (EDT)
Received: from dggrg02-dlp.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1A4340F7D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 01:25:03 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: james.morse@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, linux@armlinux.org.uk, tbaicar@codeaurora.org, imammedo@redhat.com, zhaoshenglong@huawei.com, peter.maydell@linaro.org, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, lersek@redhat.com, ard.biesheuvel@linaro.org, mtsirkin@redhat.com, drjones@redhat.com, ben@skyportsystems.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: songwenjun@huawei.com, wuquanming@huawei.com, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Handle kvmtool's detection for RAS extension, because sometimes
the APP needs to know the CPU's capacity

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/kvm/reset.c   | 11 +++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d9e9697..1004039 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -64,6 +64,14 @@ static bool cpu_has_32bit_el1(void)
 	return !!(pfr0 & 0x20);
 }
 
+static bool kvm_arm_support_ras_extension(void)
+{
+	u64 pfr0;
+
+	pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
+	return !!(pfr0 & 0x10000000);
+}
+
 /**
  * kvm_arch_dev_ioctl_check_extension
  *
@@ -87,6 +95,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_arm_support_pmu_v3();
 		break;
+	case KVM_CAP_ARM_RAS_EXTENSION:
+		r = kvm_arm_support_ras_extension();
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f51d508..27fe556 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -883,6 +883,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_MMU_RADIX 134
 #define KVM_CAP_PPC_MMU_HASH_V3 135
 #define KVM_CAP_IMMEDIATE_EXIT 136
+#define KVM_CAP_ARM_RAS_EXTENSION 137
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.10.1
