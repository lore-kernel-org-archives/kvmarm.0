From: James Morse <james.morse@arm.com>
Subject: [PATCH] KVM: arm64: stop propagating DAIF flags between kernel and
 VHE's world switch
Date: Thu, 10 Aug 2017 12:30:21 +0100
Message-ID: <20170810113021.1110-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DCAD49C2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 07:30:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p+yzWtgaX2ER for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Aug 2017 07:30:10 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62BE440A86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 07:30:10 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM calls __kvm_vcpu_run() in a loop with interrupts masked for the
duration of the call. On a non-vhe system we HVC to EL2 and the
host DAIF flags are save/restored via the SPSR.

On a system with vhe, we branch to the EL2 code because the kernel
also runs at EL2. This means the other kernel DAIF flags propagate into
KVMs EL2 code.

The same happens in reverse, we take an exception to exit the guest
and all the flags are masked. __guest_exit() unmasks SError, and we
return with these flags through world switch and back into the host
kernel. KVM unmasks interrupts as part of its __kvm_vcpu_run(), but
debug exceptions remain disabled due to the guest exit exception,
(as does SError: today this is the only time SError is unmasked in the
kernel). The flags stay in this state until we return to userspace.

We have a __vhe_hyp_call() function that does the isb that we implicitly
have on non-vhe systems, add the DAIF save/restore here, instead of in
__sysreg_{save,restore}_host_state() which would require an extra isb()
between the hosts VBAR_EL1 being restored and DAIF being restored.

Signed-off-by: James Morse <james.morse@arm.com>

---
I don't like the host DAIF context being stored on the stack instead of
kvm_host_cpu_state, but this should only be a problem for returns that
don't go through __vhe_hyp_call(). That should just be hyp_panic() where we
want to change DAIF anyway.

If you want a fixes tag for this, I think its:
Fixes: b81125c791a2 ("arm64: KVM: VHE: Patch out use of HVC")


While this won't conflict with v3 of the RAS+IESB series, it will depend on
this patches behaviour: Without this patch you will have SError unmasked
on host->guest world switch, a v8.2 RAS error arriving during this window
will HYP panic, but this is already the case today for guest->host.


 arch/arm64/kvm/hyp/hyp-entry.S | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5170ce1021da..5eaa336e5dd9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -42,6 +42,11 @@
 .endm
 
 ENTRY(__vhe_hyp_call)
+	/* HVC->ERET implicitly save/restore DAIF, we do it manually here. */
+	mrs	x9, daif
+	str	x9, [sp, #-16]!
+	msr	daifset, #0xf
+
 	do_el2_call
 	/*
 	 * We used to rely on having an exception return to get
@@ -50,6 +55,14 @@ ENTRY(__vhe_hyp_call)
 	 * before returning to the rest of the kernel.
 	 */
 	isb
+
+	/*
+	 * World-switch changes VBAR_EL1, we can only restore DAIF after
+	 * the hosts value has been synchronised by the above isb.
+	 */
+	ldr	x9, [sp], #16
+	msr	daif, x9
+
 	ret
 ENDPROC(__vhe_hyp_call)
 
-- 
2.13.3
