From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
Date: Tue, 20 Oct 2015 18:19:04 +0200
Message-ID: <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F38DD41CC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Px-o-x9LMW9f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 12:16:08 -0400 (EDT)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B074F48A2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:08 -0400 (EDT)
Received: by lfaz124 with SMTP id z124so8434773lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 09:18:40 -0700 (PDT)
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: kvmarm@lists.cs.columbia.edu

From: Arnd Bergmann <arnd@arndb.de>

The vgic code on ARM is built for all configurations that enable KVM,
but the parent_data field that it references is only present when
CONFIG_IRQ_DOMAIN_HIERARCHY is set:

virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member named 'parent_data'

This flag is implied by the GIC driver, and indeed the VGIC code only
makes sense if a GIC is present. This changes the CONFIG_KVM symbol
to always select GIC, which avoids the issue.

Fixes: 662d9715840 ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 210ecca..356970f 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	depends on MMU && OF
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	select ARM_GIC
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
-- 
2.1.2.330.g565301e.dirty
