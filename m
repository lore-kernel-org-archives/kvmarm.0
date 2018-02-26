From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 30/52] arm64: KVM: Increment PC after handling an SMC trap
Date: Mon, 26 Feb 2018 16:20:04 +0800
Message-ID: <1519633227-29832-31-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, "moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 KVM/arm64" <kvmarm@lists.cs.columbia.edu>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

commit f5115e8869e1 upstream.

When handling an SMC trap, the "preferred return address" is set
to that of the SMC, and not the next PC (which is a departure from
the behaviour of an SMC that isn't trapped).

Increment PC in the handler, as the guest is otherwise forever
stuck...

Cc: stable@vger.kernel.org
Fixes: acfb3b883f6d ("arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls")
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 2e6e9e9..5b56b09 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -53,7 +53,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	/*
+	 * "If an SMC instruction executed at Non-secure EL1 is
+	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
+	 * Trap exception, not a Secure Monitor Call exception [...]"
+	 *
+	 * We need to advance the PC after the trap, as it would
+	 * otherwise return to the same address...
+	 */
 	vcpu_set_reg(vcpu, 0, ~0UL);
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 	return 1;
 }
 
-- 
2.7.4
