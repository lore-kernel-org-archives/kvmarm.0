From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/4] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Sun, 13 Sep 2015 11:56:36 +0100
Message-ID: <1442141798-19191-3-git-send-email-marc.zyngier@arm.com>
References: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5F041145
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2015 06:56:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e9PBG3y07HDL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Sep 2015 06:56:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16171412F3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2015 06:56:02 -0400 (EDT)
In-Reply-To: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Provide a better quality of implementation and be architecture compliant
on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
reset of the timer.

This change alone fixes the UEFI reset issue reported by Laszlo back in
February.

Cc: Laszlo Ersek <lersek@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Drew Jones <drjones@redhat.com>
Cc: Wei Huang <wei@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 76e38d2..48c6e1a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -200,6 +200,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	timer->irq = irq;
 
 	/*
+	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
+	 * and to 0 for ARMv7.  We provide an implementation that always
+	 * resets the timer to be disabled and unmasked and is compliant with
+	 * the ARMv7 architecture.
+	 */
+	timer->cntv_ctl = 0;
+
+	/*
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-- 
2.1.4
