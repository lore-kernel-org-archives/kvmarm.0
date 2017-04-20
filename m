From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] ARM: KVM: Fix idmap stub entry when running Thumb-2 code
Date: Thu, 20 Apr 2017 16:02:21 +0100
Message-ID: <20170420150221.15796-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When entering the hyp stub implemented in the idmap, we try to
be mindful of the fact that we could be running a Thumb-2 kernel
by adding 1 to the address we compute. Unfortunately, the assembler
also knows about this trick, and has already generated an address
that has bit 0 set in the litteral pool.

Our superfluous correction ends up confusing the CPU entierely,
as we now branch to the stub in ARM mode instead of Thumb, and on
a possibly unaligned address for good measure. From that point,
nothing really good happens.

The obvious fix in to remove this stupid target PC correction.

Fixes: 6bebcecb6c5b ("ARM: KVM: Allow the main HYP code to use the init hyp stub implementation")
Reported-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp-entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index a35baa81fd23..95a2faefc070 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -144,7 +144,6 @@ hyp_hvc:
 	ldr	r1, [r1]
 	ldr	ip, =__kvm_handle_stub_hvc
 	sub	ip, ip, r1
-THUMB(	add	ip, ip, #1)
 	pop	{r1}
 
 	bx	ip
-- 
2.11.0
