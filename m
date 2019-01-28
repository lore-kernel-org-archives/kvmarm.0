From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 209/304] arm64: KVM: Skip MMIO insn after emulation
Date: Mon, 28 Jan 2019 10:42:06 -0500
Message-ID: <20190128154341.47195-209-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Sasha Levin <sashal@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 0d640732dbebed0f10f18526de21652931f0b2f2 ]

When we emulate an MMIO instruction, we advance the CPU state within
decode_hsr(), before emulating the instruction effects.

Having this logic in decode_hsr() is opaque, and advancing the state
before emulation is problematic. It gets in the way of applying
consistent single-step logic, and it prevents us from being able to fail
an MMIO instruction with a synchronous exception.

Clean this up by only advancing the CPU state *after* the effects of the
instruction are emulated.

Cc: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/mmio.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index dac7ceb1a677..08443a15e6be 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -117,6 +117,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
 	}
 
+	/*
+	 * The MMIO instruction is emulated and should not be re-executed
+	 * in the guest.
+	 */
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
 	return 0;
 }
 
@@ -144,11 +150,6 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
 	vcpu->arch.mmio_decode.sign_extend = sign_extend;
 	vcpu->arch.mmio_decode.rt = rt;
 
-	/*
-	 * The MMIO instruction is emulated and should not be re-executed
-	 * in the guest.
-	 */
-	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 	return 0;
 }
 
-- 
2.19.1
