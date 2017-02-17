From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/20] arm64: KVM: Implement HVC_GET_VECTORS in the init code
Date: Fri, 17 Feb 2017 15:44:12 +0000
Message-ID: <20170217154429.5000-4-marc.zyngier@arm.com>
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
 arch/arm64/kvm/hyp-init.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 948f331c7f32..2c7b86bb5483 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -124,7 +124,12 @@ __do_hyp_init:
 ENDPROC(__kvm_hyp_init)
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	x0, #HVC_RESET_VECTORS
+	cmp	x0, #HVC_GET_VECTORS
+	b.ne	1f
+	mrs	x0, vbar_el2
+	b	exit
+
+1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
 	/*
 	 * Reset kvm back to the hyp stub.
-- 
2.11.0
