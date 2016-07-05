From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 04/17] KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
Date: Tue,  5 Jul 2016 12:22:56 +0100
Message-ID: <20160705112309.28877-5-andre.przywara@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705112309.28877-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM capabilities can be a per-VM property, though ARM/ARM64 currently
does not pass on the VM pointer to the architecture specific
capability handlers.
Add a "struct kvm*" parameter to those function to later allow proper
per-VM capability reporting.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm/kvm/arm.c                | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 96387d4..3c40facd 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -281,7 +281,7 @@ static inline void __cpu_reset_hyp_mode(phys_addr_t boot_pgd_ptr,
 	 */
 }
 
-static inline int kvm_arch_dev_ioctl_check_extension(long ext)
+static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
 }
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c74483f..557e390 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -201,7 +201,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	default:
-		r = kvm_arch_dev_ioctl_check_extension(ext);
+		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
 		break;
 	}
 	return r;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 49095fc..ebe8904 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -47,7 +47,7 @@
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
-int kvm_arch_dev_ioctl_check_extension(long ext);
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 unsigned long kvm_hyp_reset_entry(void);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7be24f2..3989833 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -65,7 +65,7 @@ static bool cpu_has_32bit_el1(void)
  * We currently assume that the number of HW registers is uniform
  * across all CPUs (see cpuinfo_sanity_check).
  */
-int kvm_arch_dev_ioctl_check_extension(long ext)
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-- 
2.9.0

