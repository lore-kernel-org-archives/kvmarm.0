Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED40C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 15:46:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 481514B0BE;
	Tue,  7 Dec 2021 10:46:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IM5YUkwvLZ2Q; Tue,  7 Dec 2021 10:46:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFCC34B0C3;
	Tue,  7 Dec 2021 10:46:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922B54064F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 10:46:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eucsLvqOXUk8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 10:46:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B82244B0B4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 10:46:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29BF911D4;
 Tue,  7 Dec 2021 07:46:54 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 679B53F5A1;
 Tue,  7 Dec 2021 07:46:53 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 0/4] arm: Timer fixes
Date: Tue,  7 Dec 2021 15:46:37 +0000
Message-Id: <20211207154641.87740-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This series intends to fix two bugs in the timer test. The first one is the
TVAL comparison to check that the timer has expired and was found by code
inspection.

The second one I found while playing with KVM, but it can manifest itself
on certain hardware configuration with an unmodified version of KVM
(details in the commit message for the last patch). Or on baremetal (not
tested). In short, WFI can complete for a variety of reason, not just
because an interrupt targetted at the VM was asserted. The fix I
implemented was to do WFI in a loop until we get the interrupt or TVAL
shows that the timer has expired.

All the patches in between are an attempt make the tests more robust and
slightly easier to understand. If these changes are considered unnecessary,
I would be more than happy to drop them; the main goal of the series is to
fix the two bugs.

Tested on a rockpro64 with KVM modifed to clear HCR_EL2.TWI, which means
that the WFI instruction is not trapped (WFI trapping is a performance
optimization, not a correctness requirement):

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f4871e47b2d0..9af13e01ffeb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -96,18 +96,12 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
-       vcpu->arch.hcr_el2 &= ~HCR_TWE;
-       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
-           vcpu->kvm->arch.vgic.nassgireq)
-               vcpu->arch.hcr_el2 &= ~HCR_TWI;
-       else
-               vcpu->arch.hcr_el2 |= HCR_TWI;
+       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 }
 
 static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 {
-       vcpu->arch.hcr_el2 |= HCR_TWE;
-       vcpu->arch.hcr_el2 |= HCR_TWI;
+       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 }
 
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)

Log when running ./run_test.sh timer (truncated for brevity) without the
fixes:

...
INFO: vtimer-busy-loop: waiting for interrupt...
FAIL: vtimer-busy-loop: interrupt received after TVAL/WFI
FAIL: vtimer-busy-loop: timer has expired
INFO: vtimer-busy-loop: TVAL is 144646 ticks
...
INFO: ptimer-busy-loop: waiting for interrupt...
FAIL: ptimer-busy-loop: interrupt received after TVAL/WFI
FAIL: ptimer-busy-loop: timer has expired
INFO: ptimer-busy-loop: TVAL is 50384 ticks
SUMMARY: 18 tests, 4 unexpected failures

Log when running the same command with the series applied:

...
INFO: vtimer-busy-loop: waiting for interrupt...
INFO: vtimer-busy-loop: waiting for interrupt...
INFO: vtimer-busy-loop: waiting for interrupt...
PASS: vtimer-busy-loop: interrupt received after TVAL/WFI
PASS: vtimer-busy-loop: timer has expired
INFO: vtimer-busy-loop: TVAL is -56982 ticks
...
INFO: ptimer-busy-loop: waiting for interrupt...
INFO: ptimer-busy-loop: waiting for interrupt...
PASS: ptimer-busy-loop: interrupt received after TVAL/WFI
PASS: ptimer-busy-loop: timer has expired
INFO: ptimer-busy-loop: TVAL is -22997 ticks
SUMMARY: 18 tests


Alexandru Elisei (4):
  arm: timer: Fix TVAL comparison for timer condition met
  arm: timer: Move the different tests into their own functions
  arm: timer: Test CVAL before interrupt pending state
  arm: timer: Take into account other wake-up events for the TVAL test

 arm/timer.c | 81 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 15 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
