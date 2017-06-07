From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 5/6] arm64: KVM: Allow unaligned accesses at EL2
Date: Wed,  7 Jun 2017 19:11:51 +0200
Message-ID: <20170607171152.21874-6-cdall@linaro.org>
References: <20170607171152.21874-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170607171152.21874-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We currently have the SCTLR_EL2.A bit set, trapping unaligned accesses
at EL2, but we're not really prepared to deal with it. So far, this
has been unnoticed, until GCC 7 started emitting those (in particular
64bit writes on a 32bit boundary).

Since the rest of the kernel is pretty happy about that, let's follow
its example and set SCTLR_EL2.A to zero. Modern CPUs don't really
care.

Cc: stable@vger.kernel.org
Reported-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/hyp-init.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 4072d40..3f96155 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -108,9 +108,10 @@ __do_hyp_init:
 
 	/*
 	 * Preserve all the RES1 bits while setting the default flags,
-	 * as well as the EE bit on BE.
+	 * as well as the EE bit on BE. Drop the A flag since the compiler
+	 * is allowed to generate unaligned accesses.
 	 */
-	ldr	x4, =(SCTLR_EL2_RES1 | SCTLR_ELx_FLAGS)
+	ldr	x4, =(SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	msr	sctlr_el2, x4
 	isb
-- 
2.9.0
