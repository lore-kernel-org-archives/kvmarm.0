From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 4/8] arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
Date: Fri, 2 Oct 2015 15:51:50 +0100
Message-ID: <560E9A06.3040404@arm.com>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-5-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05495412AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CvFzjkJn9sY6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 10:49:04 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B48BF410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:49:04 -0400 (EDT)
In-Reply-To: <1443538145-11990-5-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 29/09/15 15:49, Christoffer Dall wrote:
> The GICD_ICFGR allows the bits for the SGIs and PPIs to be read only.
> We currently simulate this behavior by writing a hardcoded value to the
> register for the SGIs and PPIs on every write of these bits to the
> register (ignoring what the guest actually wrote), and by writing the
> same value as the reset value to the register.
> 
> This is a bit counter-intuitive, as the register is RO for these bits,
> and we can just implement it that way, allowing us to control the value
> of the bits purely in the reset code.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index fe0e5db..e606f78 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -655,7 +655,7 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>  			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
>  	if (mmio->is_write) {
>  		if (offset < 8) {
> -			*reg = ~0U; /* Force PPIs/SGIs to 1 */
> +			/* Ignore writes to read-only SGI and PPI bits */
>  			return false;
>  		}

Nit: Isn't this now violating kernel coding style because of a single
statement not needing braces? Maybe move the comment in front of the
if-statement to make this more obvious?

Other than that:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.
