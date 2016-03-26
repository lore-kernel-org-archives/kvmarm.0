From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 02/12] KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
Date: Sat, 26 Mar 2016 02:14:00 +0000
Message-ID: <1458958450-19662-3-git-send-email-andre.przywara@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM capabilities can be a per-VM property, though ARM/ARM64 currently
does not pass on the VM pointer to the architecture specific
capability handlers.
Add a "struct kvm*" parameter to those function to later allow proper
per-VM capability reporting.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm/kvm/arm.c                | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3850701..494b004 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -265,7 +265,7 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline int kvm_arch_dev_ioctl_check_extension(long ext)
+static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
 }
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5b9d9e3..e2e9be2 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -205,7 +205,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	default:
-		r = kvm_arch_dev_ioctl_check_extension(ext);
+		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
 		break;
 	}
 	return r;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 71fa6fe..2cdd7ae 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,7 +46,7 @@
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
-int kvm_arch_dev_ioctl_check_extension(long ext);
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 
 struct kvm_arch {
 	/* The VMID generation used for the virt. memory system */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 9677bf0..2ba7c8d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -63,7 +63,7 @@ static bool cpu_has_32bit_el1(void)
  * We currently assume that the number of HW registers is uniform
  * across all CPUs (see cpuinfo_sanity_check).
  */
-int kvm_arch_dev_ioctl_check_extension(long ext)
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-- 
2.7.3

