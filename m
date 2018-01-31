From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Fix userspace_irqchip_in_use counting
Date: Wed, 31 Jan 2018 09:00:04 +0000
Message-ID: <87739826-dea6-1946-4bb4-afd21f238fbf@arm.com>
References: <20180130124206.12262-1-christoffer.dall@linaro.org>
 <20180130124206.12262-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180130124206.12262-3-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/18 12:42, Christoffer Dall wrote:
> We were not decrementing the static key count in the right location.
> kvm_arch_vcpu_destroy() is only called to clean up after a failed
> VCPU create attempt, whereas kvm_arch_vcpu_free() is called on teardown
> of the VM as well.  Move the static key decrement call to
> kvm_arch_vcpu_free().
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	N,
-- 
Jazz is not dead. It just smells funny...
