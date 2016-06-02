From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/8] KVM: arm/arm64: vgic-v3: Clear all dirty LRs
Date: Thu,  2 Jun 2016 12:20:54 +0200
Message-ID: <1464862860-1183-3-git-send-email-christoffer.dall@linaro.org>
References: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F2D411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJ1S8fRqBD1Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2016 06:17:12 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD41541145
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:12 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id a20so61035464wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2016 03:21:10 -0700 (PDT)
In-Reply-To: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When saving the state of the list registers, it is critical to
reset them zero, as we could otherwise leave unexpected EOI
interrupts pending for virtual level interrupts.

Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index fff7cd4..3129df9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -190,12 +190,11 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
 				continue;
 
-			if (cpu_if->vgic_elrsr & (1 << i)) {
+			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
-				continue;
-			}
+			else
+				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 
-			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 			__gic_v3_set_lr(0, i);
 		}
 
-- 
2.1.2.330.g565301e.dirty
