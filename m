From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 6/8] KVM: arm/arm64: timer: Add active state caching
Date: Wed, 10 Feb 2016 13:44:59 +0100
Message-ID: <20160210124459.GM5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454931622-14902-7-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 11:40:20AM +0000, Marc Zyngier wrote:
> Programming the active state in the (re)distributor can be an
> expensive operation so it makes some sense to try and reduce
> the number of accesses as much as possible. So far, we
> program the active state on each VM entry, but there is some
> opportunity to do less.
> 
> An obvious solution is to cache the active state in memory,
> and only program it in the HW when conditions change. But
> because the HW can also change things under our feet (the active
> state can transition from 1 to 0 when the guest does an EOI),
> some precautions have to be taken, which amount to only caching
> an "inactive" state, and always programing it otherwise.
> 
> With this in place, we observe a reduction of around 700 cycles
> on a 2GHz GICv2 platform for a NULL hypercall.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
