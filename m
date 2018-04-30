From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 02/12] KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Mon, 30 Apr 2018 10:43:07 +0100
Message-ID: <CAFEAcA9yC_UUDTt58rnMicUKjeMOcKUky3oK_Xp--a9PjZSfhw@mail.gmail.com>
References: <1525079264-25533-1-git-send-email-eric.auger@redhat.com> <1525079264-25533-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525079264-25533-3-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: Eric Auger <eric.auger.pro@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 April 2018 at 10:07, Eric Auger <eric.auger@redhat.com> wrote:
> We introduce a new KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute in
> KVM_DEV_ARM_VGIC_GRP_ADDR group.

Hi; one minor grammar nit in the docs below, otherwise
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

> It allows userspace to provide the
> base address and size of a redistributor region
>
> Compared to KVM_VGIC_V3_ADDR_TYPE_REDIST, this new attribute allows
> to declare several separate redistributor regions.
>
> So the whole redist space does not need to be contiguous anymore.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v4 -> v5:
> - Document read access
> - removed Peter's R-b
>
> v3 -> v4:
> - Added Peter's R-b
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 30 +++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index 9293b45..dcb7504 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -27,16 +27,42 @@ Groups:
>        VCPU and all of the redistributor pages are contiguous.
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
> +
> +    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
> +      The attribute data pointed by kvm_device_attr.addr is a __u64 value:

"pointed to by"

> +      bits:     | 63   ....  52  |  51   ....   16 | 15 - 12  |11 - 0
> +      values:   |     count      |       base      |  flags   | index
> +      - index encodes the unique redistributor region index
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
> +      The characteristics of a specific redistributor region can be read
> +      by presetting the index field in the attr data.
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
> +    -ENOENT: Attempt to read the characteristics of a non existing
> +             redistributor region
>      -ENXIO:  The group or attribute is unknown/unsupported for this device
>               or hardware support is missing.
>      -EFAULT: Invalid user pointer for attr->addr.
>
>
> -
>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
>    Attributes:
> --
> 2.5.5

thanks
-- PMM
