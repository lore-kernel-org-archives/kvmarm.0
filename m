From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Stop injecting the MSI occurrence
 twice
Date: Fri, 3 Feb 2017 14:53:25 +0100
Message-ID: <20170203135325.GL27852@cbox>
References: <1486089003-413-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F013140838
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 08:53:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 46n53-qT9QSb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 08:53:03 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D692740284
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 08:53:03 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id c85so30020244wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 05:53:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1486089003-413-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

[please cc the kvmarm list for kvm/arm patches, thanks]

On Thu, Feb 02, 2017 at 08:30:03PM -0600, Shanker Donthineni wrote:
> The IRQFD framework calls the architecture dependent function
> twice if the corresponding GSI type is edge triggered. For ARM,
> the function kvm_set_msi() is getting called twice whenever the
> IRQFD receives the event signal. The rest of the code path is
> trying to inject the MSI without any validation checks. No need
> to call the function vgic_its_inject_msi() second time to avoid
> an unnecessary overhead in IRQ queue logic. It also avoids the
> possibility of VM seeing the MSI twice.
> 
> Simple fix, return -1 if the argument 'level' value is zero.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index d918dcf..f138ed2 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -99,6 +99,9 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	if (!vgic_has_its(kvm))
>  		return -ENODEV;
>  
> +	if (!level)
> +		return -1;
> +
>  	return vgic_its_inject_msi(kvm, &msi);
>  }
>  
> -- 

Reviewed-by: Christoffer Dall <cdall@linaro.org>
