From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 30/95] arm/arm64: KVM: Handle out-of-RAM cache maintenance as a NOP
Date: Wed,  9 Mar 2016 07:30:24 +0000
Message-ID: <1457508689-19672-31-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   |  5 +++++
 arch/arm/kvm/mmu.c                   | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 8a8c6de..ee5328f 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -138,6 +138,11 @@ static inline bool kvm_vcpu_dabt_iss1tw(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_S1PTW;
 }
 
+static inline bool kvm_vcpu_dabt_is_cm(struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & HSR_DABT_CM);
+}
+
 /* Get Access Size from a data abort */
 static inline int kvm_vcpu_dabt_get_as(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index aba61fd..c3eb10e 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1431,6 +1431,22 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 
 		/*
+		 * Check for a cache maintenance operation. Since we
+		 * ended-up here, we know it is outside of any memory
+		 * slot. But we can't find out if that is for a device,
+		 * or if the guest is just being stupid. The only thing
+		 * we know for sure is that this range cannot be cached.
+		 *
+		 * So let's assume that the guest is just being
+		 * cautious, and skip the instruction.
+		 */
+		if (kvm_vcpu_dabt_is_cm(vcpu)) {
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
index 779a587..4df8e7a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -189,6 +189,11 @@ static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
 }
 
+static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_CM);
+}
+
 static inline int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
 	return 1 << ((kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
-- 
2.1.4

