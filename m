From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/5] arm64: kvm: Prevent restoring stale PMSCR_EL1 for vcpu
Date: Mon, 18 Dec 2017 11:00:53 +0100
Message-ID: <20171218100057.7839-2-christoffer.dall@linaro.org>
References: <20171218100057.7839-1-christoffer.dall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171218100057.7839-1-christoffer.dall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Thierry <julien.thierry@arm.com>

When VHE is not present, KVM needs to save and restores PMSCR_EL1 when
possible. If SPE is used by the host, value of PMSCR_EL1 cannot be saved
for the guest.
If the host starts using SPE between two save+restore on the same vcpu,
restore will write the value of PMSCR_EL1 read during the first save.

Make sure __debug_save_spe_nvhe clears the value of the saved PMSCR_EL1
when the guest cannot use SPE.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/debug-sr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 321c9c05dd9e..f4363d40e2cd 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -74,6 +74,9 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 {
 	u64 reg;
 
+	/* Clear pmscr in case of early return */
+	*pmscr_el1 = 0;
+
 	/* SPE present on this CPU? */
 	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
 						  ID_AA64DFR0_PMSVER_SHIFT))
-- 
2.14.2
