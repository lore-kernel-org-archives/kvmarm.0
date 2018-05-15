From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v12 1/4] arm64: KVM: export the capability to set guest SError
 syndrome
Date: Wed, 16 May 2018 04:58:04 +0800
Message-ID: <1526417887-25843-2-git-send-email-gengdongjiu@huawei.com>
References: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 501674A0DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 May 2018 08:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g+ZJwC8Cyia7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 May 2018 08:42:33 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617F74065F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 May 2018 08:42:33 -0400 (EDT)
In-Reply-To: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: huangshaoyu@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For the arm64 RAS Extension, user space can inject a virtual-SError
with specified ESR. So user space needs to know whether KVM support
to inject such SError, this interface adds this query for this capability.

KVM will check whether system support RAS Extension, if supported, KVM
returns true to user space, otherwise returns false.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Reviewed-by: James Morse <james.morse@arm.com>

Change from V11:
1. Change the commit message
2. Update the Documentation/virtual/kvm/api.tx
---
 Documentation/virtual/kvm/api.txt | 11 +++++++++++
 arch/arm64/kvm/reset.c            |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index fc3ae95..66494a5 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4415,3 +4415,14 @@ Parameters: none
 This capability indicates if the flic device will be able to get/set the
 AIS states for migration via the KVM_DEV_FLIC_AISM_ALL attribute and allows
 to discover this without having to create a flic device.
+
+8.14 KVM_CAP_ARM_SET_SERROR_ESR
+
+Architectures: arm, arm64
+
+This capability indicates that userspace can specify the syndrome value reported
+to the guest OS when guest takes a virtual SError interrupt exception.
+If KVM has this capability, userspace can only specify the ISS field for the ESR
+syndrome, it can not specify the EC field which is not under control by KVM.
+If this virtual SError is taken to EL1 using AArch64, this value will be reported
+in ISS filed of ESR_EL1.
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3256b92..38c8a64 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_arm_support_pmu_v3();
 		break;
+	case KVM_CAP_ARM_INJECT_SERROR_ESR:
+		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8fb90a0..3587b33 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -934,6 +934,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_AIS_MIGRATION 150
 #define KVM_CAP_PPC_GET_CPU_CHAR 151
 #define KVM_CAP_S390_BPB 152
+#define KVM_CAP_ARM_INJECT_SERROR_ESR 153
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.9.1
