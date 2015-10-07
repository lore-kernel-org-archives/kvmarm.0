From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 05/16] KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
Date: Wed,  7 Oct 2015 15:55:15 +0100
Message-ID: <1444229726-31559-6-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM capabilities can be a per-VM property, though ARM/ARM64 currently
does not pass on the VM pointer to the architecture specific
capability handlers.
Add a "struct kvm*" parameter to those function to later allow proper
per-VM capability reporting.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v2..v3:
- none

 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm/kvm/arm.c                | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3df1e97..88e84db 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -210,7 +210,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 	kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
 }
 
-static inline int kvm_arch_dev_ioctl_check_extension(long ext)
+static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
 }
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6c7f4520..bdbefcd 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -197,7 +197,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	default:
-		r = kvm_arch_dev_ioctl_check_extension(ext);
+		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
 		break;
 	}
 	return r;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4562459..c41e613 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -43,7 +43,7 @@
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
-int kvm_arch_dev_ioctl_check_extension(long ext);
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 
 struct kvm_arch {
 	/* The VMID generation used for the virt. memory system */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 91cf535..4d7f78b4 100644
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
2.5.1

