From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC 02/12] KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri, 23 Mar 2018 14:01:33 +0000
Message-ID: <CAFEAcA-CY5Q=JRAc1+bqoGJ3WgdHgGGz0=13LW9SK7KpZK866w@mail.gmail.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com> <1521451220-27754-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521451220-27754-3-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: Eric Auger <eric.auger.pro@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 March 2018 at 09:20, Eric Auger <eric.auger@redhat.com> wrote:
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
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index 9293b45..2c0bedf 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -27,6 +27,18 @@ Groups:
>        VCPU and all of the redistributor pages are contiguous.
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
> +
> +    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
> +      The attr field of kvm_device_attr encodes 3 values:
> +      bits:     | 63   ....  52  |  51   ....   12 |11 - 0
> +      values:   |     pfns       |       base      | index
> +      - index encodes the unique redistibutor region index

"redistributor"

> +      - base field encodes bits [51:12] the guest physical base address

"of the guest"

> +        of the first redistributor in the region. There are two 64K pages
> +        for each VCPU and all of the redistributor pages are contiguous
> +        within the redistributor region.
> +      - pfns encodes the size of the region in 64kB pages.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.

You should say something here about what happens if userspace
tries to use both KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION and
KVM_VGIC_V3_ADDR_TYPE_REDIST. I think this should be an error
(reported by whichever of the two you try to set second).

>    Errors:
>      -E2BIG:  Address outside of addressable IPA range
>      -EINVAL: Incorrectly aligned address

Marc wrote:
> Why does base have to include bits [15:12] of the IPA? If it is 64kB
> aligned (as it should), these bits are guaranteed to be 0. This also
> avoid having to return -EINVAL in case of alignment problems.

If you're not using the bits for anything else you want to
check they're 0 anyway. Otherwise we can't guarantee to safely
use them for something else in future, because userspace might
be handing us garbage in those bits without noticing.

thanks
-- PMM
