From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 1/7] KVM: api: pass the devid in the msi routing entry
Date: Thu, 21 Jul 2016 18:01:25 +0200
Message-ID: <20160721160124.GB32739@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468848357-2331-2-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-18 13:25+0000, Eric Auger:
> On ARM, the MSI msg (address and data) comes along with
> out-of-band device ID information. The device ID encodes the
> device that writes the MSI msg. Let's convey the device id in
> kvm_irq_routing_msi and use KVM_MSI_VALID_DEVID flag value in
> kvm_irq_routing_entry to indicate the msi devid is populated.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
> ---
> 
> v6 -> v7:
> - Added Andre's R-b
> 
> v4 -> v5:
> - some rephrasing in api.txt according to Christoffer's comments
> v2 -> v3:
> - replace usage of KVM_IRQ_ROUTING_EXTENDED_MSI type by
>   usage of KVM_MSI_VALID_DEVID flag
> - add note about KVM_CAP_MSI_DEVID capability
> 
> v1 -> v2:
> - devid id passed in kvm_irq_routing_msi instead of in
>   kvm_irq_routing_entry
> 
> RFC -> PATCH
> - remove kvm_irq_routing_extended_msi and use union instead
> ---
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> @@ -1479,9 +1483,20 @@ struct kvm_irq_routing_msi {
>  	__u32 address_lo;
>  	__u32 address_hi;
>  	__u32 data;
> -	__u32 pad;
> +	union {
> +		__u32 pad;
> +		__u32 devid;
> +	};
>  };
>  
> +devid: If KVM_MSI_VALID_DEVID is set, contains a unique device identifier
> +       for the device that wrote the MSI message.
> +       For PCI, this is usually a BFD identifier in the lower 16 bits.
> +
> +The per-VM KVM_CAP_MSI_DEVID capability advertises the requirement to
> +provide the device ID. If this capability is not set, userland cannot
> +rely on the kernel to allow the KVM_MSI_VALID_DEVID flag being set.

It would be better to enforce this mentioned dependency on set
KVM_CAP_MSI_DEVID, but is the dependency even required?
It seems we were checking flags for zero, so KVM_MSI_VALID_DEVID
couldn't have been set by old userspaces, therefor it is ok to only make
it depend only on the presence of KVM_CAP_MSI_DEVID, like the patch does
now.  (I assume KVM_MSI_VALID_DEVID and KVM_CAP_MSI_DEVID are being
merged at the same time.)

Then there would be little point in having KVM_CAP_MSI_DEVID enableable,
so does enabling KVM_CAP_MSI_DEVID mean that every MSI must have a valid
devid?

Thanks.

---
I'm confused about the purpose behind two dynamic flags that seem to do
that same thing, but those are just nitpicks, the API looks good in
general.
