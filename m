From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/85] KVM: arm/arm64: Reduce verbosity of KVM init log
Date: Wed, 28 Mar 2018 13:51:40 +0100
Message-ID: <20180328125254.31380-12-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 431724A08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04cOV9QluGxJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:47:26 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E6D74A020
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:45:40 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

On my GICv3 system, the following is printed to the kernel log at boot:

   kvm [1]: 8-bit VMID
   kvm [1]: IDMAP page: d20e35000
   kvm [1]: HYP VA range: 800000000000:ffffffffffff
   kvm [1]: vgic-v2@2c020000
   kvm [1]: GIC system register CPU interface enabled
   kvm [1]: vgic interrupt IRQ1
   kvm [1]: virtual timer IRQ4
   kvm [1]: Hyp mode initialized successfully

The KVM IDMAP is a mapping of a statically allocated kernel structure,
and so printing its physical address leaks the physical placement of
the kernel when physical KASLR in effect. So change the kvm_info() to
kvm_debug() to remove it from the log output.

While at it, trim the output a bit more: IRQ numbers can be found in
/proc/interrupts, and the HYP VA and vgic-v2 lines are not highly
informational either.

Cc: <stable@vger.kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c   | 2 +-
 virt/kvm/arm/mmu.c          | 6 +++---
 virt/kvm/arm/vgic/vgic-v2.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3945021510a9..282389eb204f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -771,7 +771,7 @@ int kvm_timer_hyp_init(bool has_gic)
 		static_branch_enable(&has_gic_active_state);
 	}
 
-	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
+	kvm_debug("virtual timer IRQ%d\n", host_vtimer_irq);
 
 	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
 			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ec62d1cccab7..b960acdd0c05 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1810,9 +1810,9 @@ int kvm_mmu_init(void)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
-	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
-	kvm_info("HYP VA range: %lx:%lx\n",
-		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
+	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
+	kvm_debug("HYP VA range: %lx:%lx\n",
+		  kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
 	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index c32d7b93ffd1..e9d840a75e7b 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -410,7 +410,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.type = VGIC_V2;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
 
-	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
+	kvm_debug("vgic-v2@%llx\n", info->vctrl.start);
 
 	return 0;
 out:
-- 
2.14.2
