From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/28] KVM: arm/arm64: arch_timer: Simplify
 kvm_timer_vcpu_terminate
Date: Wed, 19 Dec 2018 18:03:42 +0000
Message-ID: <20181219180349.242681-22-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D014A348
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IETEp30-Y589 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30EAA49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:08 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

kvm_timer_vcpu_terminate can only be called in two scenarios:

 1. As part of cleanup during a failed VCPU create
 2. As part of freeing the whole VM (struct kvm refcount == 0)

In the first case, we cannot have programmed any timers or mapped any
IRQs, and therefore we do not have to cancel anything or unmap anything.

In the second case, the VCPU will have gone through kvm_timer_vcpu_put,
which will have canceled the emulated physical timer's hrtimer, and we
do not need to that here as well.  We also do not care if the irq is
recorded as mapped or not in the VGIC data structure, because the whole
VM is going away.  That leaves us only with having to ensure that we
cancel the bg_timer if we were blocking the last time we called
kvm_timer_vcpu_put().

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index da261f5e2a91..b07ac4614e1c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -772,11 +772,8 @@ int kvm_timer_hyp_init(bool has_gic)
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	soft_timer_cancel(&timer->bg_timer);
-	soft_timer_cancel(&timer->phys_timer);
-	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
-- 
2.19.2
