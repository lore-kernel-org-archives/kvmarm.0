From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 29/55] KVM: arm/arm64: Extend arch CAP checks to allow per-VM capabilities
Date: Fri, 22 Jul 2016 18:28:46 +0100
Message-ID: <1469208552-4155-30-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

KVM capabilities can be a per-VM property, though ARM/ARM64 currently
does not pass on the VM pointer to the architecture specific
capability handlers.
Add a "struct kvm*" parameter to those function to later allow proper
per-VM capability reporting.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm/kvm/arm.c                | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 58d0b69..de338d9 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -272,7 +272,7 @@ static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
 	kvm_call_hyp((void *)virt_to_idmap(__kvm_hyp_reset), vector_ptr);
 }
 
-static inline int kvm_arch_dev_ioctl_check_extension(long ext)
+static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
 }
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 7cf266c..972075c 100644
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
index 69d5cc2d..3eda975 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -47,7 +47,7 @@
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
-int kvm_arch_dev_ioctl_check_extension(long ext);
+int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 79f3248..e95d4f6 100644
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
2.8.1

