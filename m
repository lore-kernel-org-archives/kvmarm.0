From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 03/10] KVM: arm/arm64: vgic: Convert struct vgic_lr to
 use bitfields
Date: Sat, 18 Jul 2015 00:15:34 +0200
Message-ID: <20150717221534.GJ14024@cbox>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD3B58DD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FxBGVB5z5nJU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 18:03:20 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3AAA58DE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:19 -0400 (EDT)
Received: by lbbpo10 with SMTP id po10so68018109lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 15:15:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436378202-20224-4-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 06:56:35PM +0100, Marc Zyngier wrote:
> As we're about to cram more information in the vgic_lr structure
> (HW interrupt number and additional state information), we switch
> to a layout similar to the HW's:
> =

> - use bitfields to save space (we don't need more than 10 bits
>   to represent the irq numbers)
> - source CPU and HW interrupt can share the same field, as
>   a SGI doesn't have a physical line.
> =

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  include/kvm/arm_vgic.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> =

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 133ea00..4f9fa1d 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -95,11 +95,15 @@ enum vgic_type {
>  #define LR_STATE_ACTIVE		(1 << 1)
>  #define LR_STATE_MASK		(3 << 0)
>  #define LR_EOI_INT		(1 << 2)
> +#define LR_HW			(1 << 3)
>  =

>  struct vgic_lr {
> -	u16	irq;
> -	u8	source;
> -	u8	state;
> +	unsigned irq:10;
> +	union {
> +		unsigned hwirq:10;
> +		unsigned source:8;

why 8?  why not 3?

> +	};
> +	unsigned state:4;
>  };
>  =

>  struct vgic_vmcr {
> -- =

> 2.1.4
> =


otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
