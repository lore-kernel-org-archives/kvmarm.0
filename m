From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Kick VCPUs when queueing already pending
 IRQs
Date: Fri, 28 Oct 2016 10:35:00 +0200
Message-ID: <20161028083500.GA12739@cbox>
References: <1477580893-3479-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67420405B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2016 04:35:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c8DWDPSuplBD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2016 04:35:00 -0400 (EDT)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB7574055B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2016 04:34:59 -0400 (EDT)
Received: by mail-lf0-f46.google.com with SMTP id b75so51038003lfg.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2016 01:35:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1477580893-3479-1-git-send-email-shihwei@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 27, 2016 at 03:08:13PM +0000, Shih-Wei Li wrote:
> In cases like IPI, we could be queueing an interrupt for a VCPU
> that is already running and is not about to exit, because the
> VCPU has entered the VM with the interrupt pending and would
> not trap on EOI'ing that interrupt. This could result to delays
> in interrupt deliveries or even loss of interrupts.
> To guarantee prompt interrupt injection, here we have to try to
> kick the VCPU.
> 
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> ---
> 
> I've tested the code with an IPI test built on kvm-unit-test, which
> measures the cycles spent between one VCPU sending IPI to a target
> VCPU that busy loops in the VM, until the target VCPU ACKs and EOIs
> the IPI. The patch here can improve the performance in such case by
> more than 5000 cycles.
> 
>  virt/kvm/arm/vgic/vgic.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index b419a11..07cf239 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -273,6 +273,17 @@ retry:
>  		 * no more work for us to do.
>  		 */
>  		spin_unlock(&irq->irq_lock);
> +
> +		/*
> +		 * If the VCPU is not NULL, we could be queueing an
> +		 * edge-triggered interrupt for a VCPU which is already
> +		 * running and is not about to exit, because the VCPU has
> +		 * entered the VM with the interrupt pending and it wouldn't
> +		 * trap on EOI. To ensure prompt delivery of that interrupt,
> +		 * we have to try to kick the VCPU.
> +		 */

Perhaps the following comment is a better description:

		/*
		 * We have to kick the VCPU here, because we could be queueing
		 * an edge-triggered interrupt for which we get no EOI
		 * maintenance interrupt.  In that case, while the IRQ is
		 * already on the VCPU's AP list, the VCPU could have EOI'ed the
		 * original interrupt and won't see this one until it exits for
		 * some other reason.
		 */

> +		if (vcpu)
> +			kvm_vcpu_kick(vcpu);
>  		return false;
>  	}
>  

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
