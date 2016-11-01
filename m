From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic: Prevent access to invalid SPIs
Date: Tue, 01 Nov 2016 00:02:38 +0000
Message-ID: <864m3sm5i9.fsf@arm.com>
References: <20161031172137.30807-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00DAC402EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2016 20:02:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIVWnEvwLkDR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2016 20:02:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBDEB402EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2016 20:02:30 -0400 (EDT)
In-Reply-To: <20161031172137.30807-1-andre.przywara@arm.com> (Andre Przywara's
 message of "Mon, 31 Oct 2016 17:21:37 +0000")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Mon, Oct 31 2016 at 05:21:37 PM, Andre Przywara <andre.przywara@arm.com> wrote:
> In our VGIC implementation we limit the number of SPIs to a number
> that the userland application told us. Accordingly we limit the
> allocation of memory for virtual IRQs to that number.
> However in our MMIO dispatcher we didn't check if we ever access an
> IRQ beyond that limit, leading to out-of-bound accesses.
> Add a test against the number of allocated SPIs in check_region().
> Adjust the VGIC_ADDR_TO_INTID macro to avoid an actual division, which
> is not implemented on ARM(32).
>
> [maz: cleaned-up original patch]
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> Hi Marc,
>
> does the last hunk fix the GCC issue that your recent fix addresses
> as well? ilog2 seems to be pretty cheap on ARM and ARM64, so I wonder
> if this version of the fix is better, since smaller?

Thanks for looking into this. That seems to solve it for me (with GCC
6.1.1).

[...]

> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 4c34d39..dacd1155 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -58,7 +58,7 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
>   * numerator and denominator with 8 to support at most 64 bits per IRQ:
>   */
>  #define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
> -					64 / (bits) / 8)
> +					64 >> (ilog2(bits) + 3))

Given that it's taken me the best of 10 minutes to convince myself that
this was correct, can you please save everybody some time by updating
the comment above the #define?

Please respin this as soon as you can.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
