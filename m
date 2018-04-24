From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 02/12] KVM: arm/arm64: Document
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Tue, 24 Apr 2018 18:46:49 +0200
Message-ID: <20180424164649.GA4533@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523607658-9166-3-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 13, 2018 at 10:20:48AM +0200, Eric Auger wrote:
> We introduce a new KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute in
> KVM_DEV_ARM_VGIC_GRP_ADDR group. It allows userspace to provide the
> base address and size of a redistributor region
> 
> Compared to KVM_VGIC_V3_ADDR_TYPE_REDIST, this new attribute allows
> to declare several separate redistributor regions.
> 
> So the whole redist space does not need to be contiguous anymore.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 25 ++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index 9293b45..cbc4328 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -27,9 +27,32 @@ Groups:
>        VCPU and all of the redistributor pages are contiguous.
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
> +
> +    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
> +      The attr field of kvm_device_attr encodes 3 values:
> +      bits:     | 63   ....  52  |  51   ....   16 | 15 - 12  |11 - 0
> +      values:   |     count      |       base      |  flags   | index
> +      - index encodes the unique redistributor region index

I'm not entirely sure I understand the purpose of the index field.
Isn't a redistributor region identified uniquely by its base address?

Otherwise this looks good.

Thanks,
-Christoffer


> +      - flags: reserved for future use, currently 0
> +      - base field encodes bits [51:16] of the guest physical base address
> +        of the first redistributor in the region.
> +      - count encodes the number of redistributors in the region. Must be
> +        greater than 0.
> +      There are two 64K pages for each redistributor in the region and
> +      redistributors are laid out contiguously within the region. Regions
> +      are filled with redistributors in the index order. The sum of all
> +      region count fields must be greater than or equal to the number of
> +      VCPUs. Redistributor regions must be registered in the incremental
> +      index order, starting from index 0.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> +
> +  It is invalid to mix calls with KVM_VGIC_V3_ADDR_TYPE_REDIST and
> +  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attributes.
> +
>    Errors:
>      -E2BIG:  Address outside of addressable IPA range
> -    -EINVAL: Incorrectly aligned address
> +    -EINVAL: Incorrectly aligned address, bad redistributor region
> +             count/index, mixed redistributor region attribute usage
>      -EEXIST: Address already configured
>      -ENXIO:  The group or attribute is unknown/unsupported for this device
>               or hardware support is missing.
> -- 
> 2.5.5
> 
