From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Fri, 17 Jul 2015 10:27:26 +0300
Message-ID: <01d401d0c062$086c2ee0$19448ca0$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A426758B98
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 03:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MwnPoL+oOnQs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 03:15:34 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59D4558B94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 03:15:33 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRM00DO8FDRWI10@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 17 Jul 2015 08:27:27 +0100 (BST)
In-reply-to: <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Eric Auger
> Sent: Thursday, July 09, 2015 11:22 AM
> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lists.infradead.org;
> marc.zyngier@arm.com; christoffer.dall@linaro.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org
> Cc: patches@linaro.org; andre.przywara@arm.com; p.fedin@samsung.com; pbonzini@redhat.com
> Subject: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
> 
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

 Did you mean "if (msg->flags)" here (inverted condition)?

> +
> +	/* historically the route.type was not set */
> +
>  	route.msi.address_lo = msi->address_lo;
>  	route.msi.address_hi = msi->address_hi;
>  	route.msi.data = msi->data;
> --
> 1.9.1

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
