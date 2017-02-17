From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/20] ARM: KVM: Implement HVC_GET_VECTORS in the init code
Date: Fri, 17 Feb 2017 15:44:23 +0000
Message-ID: <20170217154429.5000-15-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have an infrastructure to handle hypercalls in the KVM
init code, let's implement HVC_GET_VECTORS there.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/init.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index b0138118fac4..438b148d47fd 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -122,7 +122,12 @@ __do_hyp_init:
 	eret
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	r0, #HVC_RESET_VECTORS
+	cmp	r0, #HVC_GET_VECTORS
+	bne	1f
+	mrc	p15, 4, r0, c12, c0, 0	@ get HVBAR
+	b	exit
+
+1:	cmp	r0, #HVC_RESET_VECTORS
 	bne	1f
 ENTRY(__kvm_hyp_reset)
 	/* We're now in idmap, disable MMU */
-- 
2.11.0
