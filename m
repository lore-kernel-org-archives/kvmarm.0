From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [WRONG] KVM: arm/arm64: vgic: fix off-by-one bug in vgic_get_irq()
Date: Wed, 19 Dec 2018 09:11:49 -0600
Message-ID: <20181219151149.GA6524@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, stable@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

This is wrong: commit 6022fcc0e87a0eb5e9a72b15ed70dd29ebcb7343

The above is not my original patch and it should not be tagged for stable,
as it introduces the same kind of bug I intended to fix:

array_index_nospec() can now return kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS
and this is not what you want. So, in this case the following line of code
is just fine as it is:

intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); 


As the commit log says, my patch fixes:

commit 41b87599c74300027f305d7b34368ec558978ff2

not both:

commit 41b87599c74300027f305d7b34368ec558978ff2

and 

commit bea2ef803ade3359026d5d357348842bca9edcf1

If you want to apply the fix on top of bea2ef803ade3359026d5d357348842bca9edcf1
then you should apply this instead:

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index bb1a83345741..e607547c7bb0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -103,7 +103,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 {
        /* SGIs and PPIs */
        if (intid <= VGIC_MAX_PRIVATE) {
-               intid = array_index_nospec(intid, VGIC_MAX_PRIVATE);
+               intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
                return &vcpu->arch.vgic_cpu.private_irqs[intid];
        }
 

The commit log should remain the same.

Thanks
--
Gustavo
