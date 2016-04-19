From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 26/45] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Tue, 19 Apr 2016 13:34:48 +0100
Message-ID: <CAFEAcA9Hy2cSVguOWrxBo6By24BjiE2rgoCPGbfo+OuuPMtSQg@mail.gmail.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-27-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C1749B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 08:33:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2BV5XNcuDhnl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2016 08:33:11 -0400 (EDT)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com
 [209.85.213.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2332C49B6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 08:33:10 -0400 (EDT)
Received: by mail-vk0-f52.google.com with SMTP id t129so16839871vkg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 05:35:08 -0700 (PDT)
In-Reply-To: <1460740316-8755-27-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 April 2016 at 18:11, Andre Przywara <andre.przywara@arm.com> wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 7d275a7..dafa235 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -784,6 +784,23 @@ static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
> +                                   struct kvm_io_device *dev,
> +                                   gpa_t addr, int len, void *val)
> +{
> +       u32 regnr = (addr & 0x3f) - (GICD_IDREGS & 0x3f);
> +       u32 reg = 0;
> +
> +       switch (regnr + GICD_IDREGS) {
> +       case GICD_PIDR2:
> +               /* report a GICv3 compliant implementation */
> +               reg = 0x3b;
> +               break;
> +       }

We claim to be an ARM implementation, so we should report the full
set of ARM ID registers, not just GICD_PIDR2:

        0x44, 0x00, 0x00, 0x00, 0x92, 0xB4, 0x3B, 0x00, 0x0D, 0xF0, 0x05, 0xB1

(starting at 0xFFD0 and going up to 0xFFFC.)

> +       write_mask32(reg , addr & 3, len, val);
> +       return 0;
> +}
>  #endif

thanks
-- PMM
