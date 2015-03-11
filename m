From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}
Date: Wed, 11 Mar 2015 15:07:21 +0000
Message-ID: <55005A29.9060202@arm.com>
References: <1426083780-27588-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426083780-27588-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/03/15 14:23, Christoffer Dall wrote:
> We can definitely decide at run-time whether to use the GIC and timers
> or not, and the extra code and data structures that we allocate space
> for is really negligable with this config option, so I don't think it's
> worth the extra complexity of always having to define stub static
> inlines.  The !CONFIG_KVM_ARM_VGIC/TIMER case is pretty much an untested
> code path anyway, so we're better off just getting rid of it.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks for putting this together.

	M.
-- 
Jazz is not dead. It just smells funny...
