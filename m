From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 04/13] KVM: arm/arm64: extend arch CAP checks to allow
 per-VM capabilities
Date: Fri,  3 Jun 2016 15:02:43 +0100
Message-ID: <1464962572-3925-5-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD6849AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6XmJSJic9p0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 09:58:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A158412C2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:31 -0400 (EDT)
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
index 893941e..a268c85 100644
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
index b1ad730..6ec9dfe 100644
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
2.8.2
