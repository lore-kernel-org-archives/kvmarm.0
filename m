From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v11 4/6] target-arm: kvm64: detect guest RAS EXTENSION feature
Date: Fri, 18 Aug 2017 22:23:45 +0800
Message-ID: <1503066227-18251-5-git-send-email-gengdongjiu@huawei.com>
References: <1503066227-18251-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D5F249CA8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 09:59:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aI+neFxb5AKq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Aug 2017 09:59:48 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED36949CA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 09:59:47 -0400 (EDT)
In-Reply-To: <1503066227-18251-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: mst@redhat.com, imammedo@redhat.com, zhaoshenglong@huawei.com, peter.maydell@linaro.org, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org, edk2-devel@lists.01.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, james.morse@arm.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolothum.thodi@huawei.com, huangdaode@hisilicon.com, wangzhou1@hisilicon.com
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

check if kvm supports guest RAS EXTENSION. if so, set
corresponding feature bit for vcpu.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 linux-headers/linux/kvm.h | 1 +
 target/arm/cpu.h          | 3 +++
 target/arm/kvm64.c        | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 7971a4f..2aa176e 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SMT_POSSIBLE 147
 #define KVM_CAP_HYPERV_SYNIC2 148
 #define KVM_CAP_HYPERV_VP_INDEX 149
+#define KVM_CAP_ARM_RAS_EXTENSION 150
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index b39d64a..6b0961b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -611,6 +611,8 @@ struct ARMCPU {
 
     /* CPU has memory protection unit */
     bool has_mpu;
+    /* CPU has ras extension unit */
+    bool has_ras_extension;
     /* PMSAv7 MPU number of supported regions */
     uint32_t pmsav7_dregion;
 
@@ -1229,6 +1231,7 @@ enum arm_features {
     ARM_FEATURE_THUMB_DSP, /* DSP insns supported in the Thumb encodings */
     ARM_FEATURE_PMU, /* has PMU support */
     ARM_FEATURE_VBAR, /* has cp15 VBAR */
+    ARM_FEATURE_RAS_EXTENSION, /*has RAS extension support */
 };
 
 static inline int arm_feature(CPUARMState *env, int feature)
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index a16abc8..0781367 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -518,6 +518,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         unset_feature(&env->features, ARM_FEATURE_PMU);
     }
 
+    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_RAS_EXTENSION)) {
+        cpu->has_ras_extension = true;
+        set_feature(&env->features, ARM_FEATURE_RAS_EXTENSION);
+    } else {
+        cpu->has_ras_extension = false;
+        unset_feature(&env->features, ARM_FEATURE_RAS_EXTENSION);
+    }
+
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cs);
     if (ret) {
-- 
1.8.3.1
