From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Fri, 4 Sep 2015 16:47:19 +0200
Message-ID: <20150904144719.GJ5171@cbox>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
 <1441376679-8341-3-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA508412EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 10:45:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ObWm8ksk7x+D for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 10:45:26 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB6E9412D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 10:45:25 -0400 (EDT)
Received: by lbbmp1 with SMTP id mp1so12633353lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Sep 2015 07:45:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1441376679-8341-3-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 04, 2015 at 04:24:39PM +0200, Christoffer Dall wrote:
> Provide a better quality of implementation and be architecture compliant
> on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
> reset of the timer, and call kvm_timer_update_state(vcpu) at the same
> time, ensuring the timer output is not asserted after, for example, a
> PSCI system reset.

forgot to remove the bit about kvm_timer_update_state(vcpu) which is no
longer valid when these patches are merged before the rework series.

Marc, if you're otherwise happy with this patch, can you fix this up at
commit time?

Thanks,
-Christoffer

> 
> This change alone fixes the UEFI reset issue reported by Laszlo back in
> February.
> 
> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Drew Jones <drjones@redhat.com>
> Cc: Wei Huang <wei@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 76e38d2..48c6e1a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -200,6 +200,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	timer->irq = irq;
>  
>  	/*
> +	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
> +	 * and to 0 for ARMv7.  We provide an implementation that always
> +	 * resets the timer to be disabled and unmasked and is compliant with
> +	 * the ARMv7 architecture.
> +	 */
> +	timer->cntv_ctl = 0;
> +
> +	/*
>  	 * Tell the VGIC that the virtual interrupt is tied to a
>  	 * physical interrupt. We do that once per VCPU.
>  	 */
> -- 
> 2.1.2.330.g565301e.dirty
> 
