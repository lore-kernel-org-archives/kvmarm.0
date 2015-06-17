From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 04/10] KVM: arm/arm64: vgic: Allow HW irq to be encoded
 in LR
Date: Wed, 17 Jun 2015 14:34:33 +0100
Message-ID: <55817769.60909@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-5-git-send-email-marc.zyngier@arm.com> <55815FA5.4010203@linaro.org> <CAFEAcA8idJehTx75G1OzcPpg5ewx_6X15srx7iV6sszmiqHNFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8idJehTx75G1OzcPpg5ewx_6X15srx7iV6sszmiqHNFw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/06/15 14:21, Peter Maydell wrote:
> On 17 June 2015 at 12:53, Eric Auger <eric.auger@linaro.org> wrote:
>> shouldn't we test somewhere that the hwirq is between 16 and 1019.
> 
> Not directly related, but that reminds me that I noticed the
> other day that we have VGIC_MAX_IRQS = 1024 (and use that as a
> guard on how many irqs we let userspace configure and ask us
> to deliver), but that doesn't account for the couple of magic
> numbers at the top of the range. I think that lets userspace
> cause us to do UNPREDICTABLE things to the GIC...

Good point. How about the following:

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 78fb820..950064a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1561,7 +1561,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			goto out;
 	}
 
-	if (irq_num >= kvm->arch.vgic.nr_irqs)
+	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
 		return -EINVAL;
 
 	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
@@ -2161,10 +2161,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 
 	BUG_ON(!vgic_initialized(kvm));
 
-	if (spi > kvm->arch.vgic.nr_irqs)
-		return -EINVAL;
 	return kvm_vgic_inject_irq(kvm, 0, spi, level);
-
 }
 
 /* MSI not implemented yet */

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
