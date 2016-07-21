From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Thu, 21 Jul 2016 18:33:42 +0200
Message-ID: <20160721163341.GE32739@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E99B749B44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 12:27:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LxCBZu8jrh7B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 12:27:33 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6591549B32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 12:27:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1468848357-2331-8-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-18 13:25+0000, Eric Auger:
> If the ITS modality is not available, let's simply support MSI
> injection by transforming the MSI.data into an SPI ID.
> 
> This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
> routing for arm too.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v6 -> v7:
> - move vgic_v2m_inject_msi into vgic-irqfd
> 
> v4 -> v5:
> - on vgic_v2m_inject_msi check the msi->data is within the SPI range
> - move KVM_HAVE_MSI in the KVM section (to be symetrical with ARM64)
> 
> v2 -> v3:
> - reword the commit message
> - add sanity check about devid provision
> 
> v1 -> v2:
> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>   advice
> ---
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> +static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	if (msi->flags & KVM_MSI_VALID_DEVID)
> +		return -EINVAL;
> +	if (!vgic_valid_spi(kvm, msi->data))
> +		return -EINVAL;
> +
> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);

Hm, this isn't very MSI related ...

arm already has KVM_IRQ_LINE/kvm_vm_ioctl_irq_line with
KVM_ARM_IRQ_TYPE_SPI that does
  kvm_vgic_inject_irq(kvm, 0, irq_num, level)

Is that interface lacking?

Thanks.

> +}
> +
> +/**
>   * kvm_set_msi: inject the MSI corresponding to the
>   * MSI routing entry
>   *
> @@ -96,7 +113,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	msi.devid = e->msi_devid;
>  
>  	if (!vgic_has_its(kvm))
> -		return -ENODEV;
> +		return vgic_v2m_inject_msi(kvm, &msi);
>  
>  	return vgic_its_inject_msi(kvm, &msi);
>  }
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
