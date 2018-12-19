From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/28] KVM: arm/arm64: vgic: Fix off-by-one bug in
 vgic_get_irq()
Date: Wed, 19 Dec 2018 18:03:38 +0000
Message-ID: <20181219180349.242681-18-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8F54A382
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3XZltatqZtH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E7BC4A39B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:57 -0500 (EST)
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

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

When using the nospec API, it should be taken into account that:

"...if the CPU speculates past the bounds check then
 * array_index_nospec() will clamp the index within the range of [0,
 * size)."

The above is part of the header for macro array_index_nospec() in
linux/nospec.h

Now, in this particular case, if intid evaluates to exactly VGIC_MAX_SPI
or to exaclty VGIC_MAX_PRIVATE, the array_index_nospec() macro ends up
returning VGIC_MAX_SPI - 1 or VGIC_MAX_PRIVATE - 1 respectively, instead
of VGIC_MAX_SPI or VGIC_MAX_PRIVATE, which, based on the original logic:

	/* SGIs and PPIs */
	if (intid <= VGIC_MAX_PRIVATE)
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];

 	/* SPIs */
	if (intid <= VGIC_MAX_SPI)
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];

are valid values for intid.

Fix this by calling array_index_nospec() macro with VGIC_MAX_PRIVATE + 1
and VGIC_MAX_SPI + 1 as arguments for its parameter size.

Fixes: 41b87599c743 ("KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_get_irq()")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
[dropped the SPI part which was fixed separately]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 8ab0491bcc94..f884a54b2601 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -103,7 +103,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 {
 	/* SGIs and PPIs */
 	if (intid <= VGIC_MAX_PRIVATE) {
-		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE);
+		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
 	}
 
-- 
2.19.2
