From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC 01/13] KVM: arm/arm64: Add vITS save/restore API documentation
Date: Fri, 3 Feb 2017 14:00:13 +0000
Message-ID: <CAFEAcA98mFM=iNs2n=F9d4suV7+mjPJRjZfiYagX5y7HiPgMnw@mail.gmail.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com> <1484236613-24633-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484236613-24633-2-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar, Vijaya" <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andrew Jones <drjones@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 January 2017 at 15:56, Eric Auger <eric.auger@redhat.com> wrote:
> Add description for how to access vITS registers and how to flush/restore
> vITS tables into/from memory
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 70 ++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> index 6081a5b..bd74613 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> @@ -36,3 +36,73 @@ Groups:
>      -ENXIO:  ITS not properly configured as required prior to setting
>               this attribute
>      -ENOMEM: Memory shortage when allocating ITS internal data
> +
> +  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> +  Attributes:
> +      The attr field of kvm_device_attr encodes the offset of the
> +      ITS register, relative to the ITS control frame base address
> +      (ITS_base).
> +
> +      kvm_device_attr.addr points to a __u64 value whatever the width
> +      of the addressed register (32/64 bits).
> +
> +      Writes to read-only registers are ignored by the kernel except
> +      for a single register, GITS_READR. Normally this register is RO
> +      but it needs to be restored otherwise commands in the queue will
> +      be re-executed after CWRITER setting.

Dumb question -- is it possible/sensible to process the command
queue rather than migrating a list of outstanding commands?

thanks
-- PMM
