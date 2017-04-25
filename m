From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save API documentation
Date: Tue, 25 Apr 2017 11:43:32 +0100
Message-ID: <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-3-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar, Vijaya" <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 April 2017 at 11:15, Eric Auger <eric.auger@redhat.com> wrote:
> Add description for how to save GICV3 LPI pending bit into
> guest RAM pending tables.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v5: creation
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index c1a2461..9293b45 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -167,11 +167,17 @@ Groups:
>      KVM_DEV_ARM_VGIC_CTRL_INIT
>        request the initialization of the VGIC, no additional parameter in
>        kvm_device_attr.addr.
> +    KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
> +      save all LPI pending bits into guest RAM pending tables.
> +
> +      The first kB of the pending table is not altered by this operation.
>    Errors:
>      -ENXIO: VGIC not properly configured as required prior to calling
>       this attribute
>      -ENODEV: no online VCPU
>      -ENOMEM: memory shortage when allocating vgic internal data
> +    -EFAULT: Invalid guest ram access
> +    -EBUSY:  One or more VCPUS are running
>
>
>    KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> --
> 2.5.5

When does the -EFAULT return happen? (if the guest points GITS_BASER<n>
etc at invalid memory, presumably?) How does the QEMU migration code
handle this case? Failing migration because the guest has done something
silly doesn't seem too palatable, but trying to avoid that could be
more effort than an obscure corner case really merits.

thanks
-- PMM
