From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Remove kvm_vgic_inject_mapped_irq
Date: Wed, 1 Feb 2017 10:28:42 +0000
Message-ID: <02d671fd-0573-d311-7bbf-6f73ec4b9054@arm.com>
References: <20170201102240.29985-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170201102240.29985-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Jintack Lim <jintack@cs.columbia.edu>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/17 10:22, Christoffer Dall wrote:
> The only benefit of having kvm_vgic_inject_mapped_irq separate from
> kvm_vgic_inject_irq is that we pass a boolean that we use for error
> checking on the injection path.
> 
> While this could potentially help in some aspect of robustness, it's
> also a little bit of a defensive move, and arguably callers into the
> vgic should have make sure they have marked their virtual IRQs as mapped
> if required.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>


Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.

-- 
Jazz is not dead. It just smells funny...
