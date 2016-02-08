From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: Handle out-of-RAM cache maintenance as a NOP
Date: Mon,  8 Feb 2016 14:37:25 +0000
Message-ID: <1454942245-18452-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, our handling of cache maintenance by VA has been pretty
simple: Either the access is in the guest RAM and generates a S2
fault, which results in the page being mapped RW, or we go down
the io_mem_abort() path, and nuke the guest.

The first one is fine, but the second one is extremely weird.
Treating the CM as an I/O is wrong, and nothing in the ARM ARM
indicates that we should generate a fault for something that
cannot end-up in the cache anyway (even if the guest maps it,
it will keep on faulting at stage-2 for emulation).

So let's just skip this instruction, and let the guest get away
with it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   |  5 +++++
 arch/arm/kvm/mmu.c                   | 17 +++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3095df0..f768797 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -143,6 +143,11 @@ static inline bool kvm_vcpu_dabt_iss1tw(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_S1PTW;
 }
 
+static inline bool kvm_vcpu_dabt_iscm(struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & HSR_DABT_CM);
+}
+
 /* Get Access Size from a data abort */
 static inline int kvm_vcpu_dabt_get_as(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index aba61fd..1a5f2ea 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1431,6 +1431,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 
 		/*
+		 * Check for a cache maintenance operation. Since we
+		 * ended-up here, we know it is outside of any memory
+		 * slot. But we can't find out if that is for a device,
+		 * or if the guest is just being stupid (going all the
+		 * way to userspace is not an option - what would you
+		 * write?).
+		 *
+		 * So let's assume that the guest is just being
+		 * cautious, and skip the instruction.
+		 */
+		if (kvm_vcpu_dabt_iscm(vcpu)) {
+			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			ret = 1;
+			goto out_unlock;
+		}
+
+		/*
 		 * The IPA is reported as [MAX:12], so we need to
 		 * complement it with the bottom 12 bits from the
 		 * faulting VA. This is always 12 bits, irrespective
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3066328..01cdf5f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -185,6 +185,11 @@ static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
 }
 
+static inline bool kvm_vcpu_dabt_iscm(const struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_CM);
+}
+
 static inline int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
 	return 1 << ((kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
-- 
2.1.4

