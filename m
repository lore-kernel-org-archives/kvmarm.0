From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Sat, 11 Jul 2015 00:15:40 +0100
Message-ID: <55A0521C.1040605@arm.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB05A585A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 19:07:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ASXdRGWR6uIr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 19:07:48 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C96758589
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 19:07:48 -0400 (EDT)
In-Reply-To: <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/15 09:22, Eric Auger wrote:
> on ARM, a devid field is populated in kvm_msi struct in case the
> flag is set to KVM_MSI_VALID_DEVID. Let's populate the corresponding
> kvm_kernel_irq_routing_entry devid field and set the msi type to
> KVM_IRQ_ROUTING_EXTENDED_MSI.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  virt/kvm/irqchip.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 21c1424..e678f8a 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -72,9 +72,17 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
>  {
>  	struct kvm_kernel_irq_routing_entry route;
>  
> -	if (!irqchip_in_kernel(kvm) || msi->flags != 0)
> +	if (!irqchip_in_kernel(kvm))
>  		return -EINVAL;
>  
> +	if (msi->flags & KVM_MSI_VALID_DEVID) {
> +		route.devid = msi->devid;
> +		route.type = KVM_IRQ_ROUTING_EXTENDED_MSI;
> +	} else if (!msi->flags)
> +		return -EINVAL;

I think we get away without using the extended type on the kernel side.
Within the kernel we don't have an ABI that we have to stick to forever,
so we can simplify things by re-using the existing type (no need to
check for both MSI types later).
So we always set the device ID, the only code that looks at it later is
the ITS emulation anyway, any other code path simply ignores that.

To be honest I am not 100% sure that is actually better, but I had
hacked it in a way where I didn't need it.
Also have a look at the other comments in the following patches for
clarification.

Cheers,
Andre.


> +
> +	/* historically the route.type was not set */
> +
>  	route.msi.address_lo = msi->address_lo;
>  	route.msi.address_hi = msi->address_hi;
>  	route.msi.data = msi->data;
> 
