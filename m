From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/8] arm64: KVM: Don't skip an instruction if an exception is pending
Date: Wed, 22 Feb 2017 11:47:21 +0000
Message-ID: <20170222114728.2472-2-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When a trapping instruction has been successfully emulated, we
skip it in order to start executing the following one. Any change
in the PC made while handling the trap (such as injecting an
exception) is going to completely wreck the execution of the
guest by skiping an instruction that hasn't been executed yet.

In order to avoid this, we introduce an "exception_pending" flag,
kept together with the description of the sys_reg that is being
emulated. If that flag gets set, we avoid the skip, making sure we
execute correctly the first instruction of the handler.

Given that nothing sets the flag to true, this patch doesn't change
the existing behaviour yet.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++--
 arch/arm64/kvm/sys_regs.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e26f8c2b56f..7ac7fb021dde 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1590,7 +1590,8 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			if (!params->exception_pending)
+				kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 			/* Handled */
 			return 0;
 		}
@@ -1645,6 +1646,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	params.is_32bit = false;
 	params.CRm = (hsr >> 1) & 0xf;
 	params.is_write = ((hsr & 1) == 0);
+	params.exception_pending = false;
 
 	params.Op0 = 0;
 	params.Op1 = (hsr >> 16) & 0xf;
@@ -1697,6 +1699,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.CRm = (hsr >> 1) & 0xf;
 	params.regval = vcpu_get_reg(vcpu, Rt);
 	params.is_write = ((hsr & 1) == 0);
+	params.exception_pending = false;
 	params.CRn = (hsr >> 10) & 0xf;
 	params.Op0 = 0;
 	params.Op1 = (hsr >> 14) & 0x7;
@@ -1773,7 +1776,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			if (!params->exception_pending)
+				kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 			return 1;
 		}
 		/* If access function fails, it should complain. */
@@ -1819,6 +1823,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.Op2 = (esr >> 17) & 0x7;
 	params.regval = vcpu_get_reg(vcpu, Rt);
 	params.is_write = !(esr & 1);
+	params.exception_pending = false;
 
 	ret = emulate_sys_reg(vcpu, &params);
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9c6ffd0f0196..c7f790277119 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -32,6 +32,7 @@ struct sys_reg_params {
 	bool	is_write;
 	bool	is_aarch32;
 	bool	is_32bit;	/* Only valid if is_aarch32 is true */
+	bool	exception_pending;
 };
 
 struct sys_reg_desc {
-- 
2.11.0
