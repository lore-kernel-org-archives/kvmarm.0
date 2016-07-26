From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Tue, 26 Jul 2016 12:03:46 +0100
Message-ID: <CAFEAcA_W4xkihrAUTsQ1k2Upw20+WpUK6KmrkQysQrpFGxJDQg@mail.gmail.com>
References: <20160726103940.26243-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAABD49B67
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 06:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IP979cXZU7gq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2016 06:57:39 -0400 (EDT)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com
 [209.85.161.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 584CA49B66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 06:57:39 -0400 (EDT)
Received: by mail-yw0-f181.google.com with SMTP id j12so5822375ywb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 04:04:06 -0700 (PDT)
In-Reply-To: <20160726103940.26243-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 July 2016 at 11:39, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Factor out the GICv3 and ITS-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file,
> and add a group for accessing level triggered IRQ information for GICv3
> as well.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v4:
>  - Clarify register reads as per Peter's comments on v4
>  - Factored out ITS documenation into separate file
>  - Clarified error conditions on all GRP_ADDR groups
>  - Renamed KVM_VGIC_V3_ADDR_TYPE_ITS to KVM_VGIC_ITS_ADDR_TYPE in the
>    documentation to be in line with the code.
>  - Did not apply Peter's reviewed-by due to the conflicts and updates
>    related to the ITS.
>
> Changes since v3:
>  - Fix typos
>  - Clarified level register containing 32 IRQs
>  - Removed limitations about priority support which are no longer true
>  - Special-case the SPENDR register accesses to access the latch state
>    and the CPENDR register accesses to be RAZ/WI.
>
> Changes since v2:
>  - Changed distributor access to be 32-bits in size
>  - Clearly specified data type pointed to by addr field
>  - Specified exception behavior for STATUSR registers
>  - Added group for level-triggered IRQ status info
>  - Removed acks from Marc/Peter as content has changed
>
>
>  Documentation/virtual/kvm/devices/arm-vgic-its.txt |  38 ++++
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt  | 207 +++++++++++++++++++++
>  Documentation/virtual/kvm/devices/arm-vgic.txt     |  52 ++----
>  3 files changed, 262 insertions(+), 35 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-its.txt
>  create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> new file mode 100644
> index 0000000..ffae1cd
> --- /dev/null
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> @@ -0,0 +1,38 @@
> +ARM Virtual Interrupt Translation Service (ITS)
> +===============================================
> +
> +Device types supported:
> +  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
> +
> +Creating a virtual ITS controller also requires a host GICv3 (see
> +arm-vgic-v3.txt), but does not depend on having physical ITS controllers.
> +
> +There can be multiple ITS controllers per guest, each of them has to have
> +a separate, non-overlapping MMIO region.
> +
> +
> +Groups:
> +  KVM_DEV_ARM_VGIC_GRP_ADDR
> +  Attributes:
> +    KVM_VGIC_ITS_ADDR_TYPE (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3 ITS
> +      control register frame. The ITS allows MSI(-X) interrupts to be
> +      injected into guests. This extension is optional.

Shouldn't "The ITS allows MSI(-X) interrupts to be injected into guests.
This extension is optional." be in the introductory text above, not
the description of this attribute?

> +      This address needs to be 64K aligned and the region covers 128K.
> +  Errors:
> +    -E2BIG:  Address outside of addressable IPA range
> +    -EINVAL: Incorrectly aligned address
> +    -EEXIST: Address already configured
> +    -EFAULT: Invalid user pointer for attr->addr.
> +    -ENODEV: Incrorect attribute or the ITS is not supported.

"Incorrect"

> +
> +
> +  KVM_DEV_ARM_VGIC_GRP_CTRL
> +  Attributes:
> +    KVM_DEV_ARM_VGIC_CTRL_INIT
> +      request the initialization of the ITS, no additional parameter in
> +      kvm_device_attr.addr.
> +  Errors:
> +    -ENXIO:  ITS not properly configured as required prior to calling
> +             this attribute

"setting this attribute".

> +    -ENOMEM: Memory shortage when allocating ITS internal data

Otherwise
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

-- PMM
