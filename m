From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] KVM: arm: use GIC support unconditionally
Date: Mon, 12 Oct 2015 15:22:31 +0200
Message-ID: <6276915.O3N4ZN0iPv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA2B41390
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 09:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fyn5MKFP5NRH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 09:20:55 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E020841338
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 09:20:54 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

The vgic code on ARM is built for all configurations that enable KVM,
but the parent_data field that it references is only present when
CONFIG_IRQ_DOMAIN_HIERARCHY is set:

virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member named 'parent_data'

This flag is implied by the GIC driver, and indeed the VGIC code only
makes sense if a GIC is present. This changes the CONFIG_KVM symbol
to always select GIC, which avoids the issue.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 662d9715840 ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}")

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 210eccadb69a..356970f3b25e 100644
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
