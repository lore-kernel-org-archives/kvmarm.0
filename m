From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 5/5] arm64: KVM: vgic-v2: Enable GICV access from HYP if
 access from guest is unsafe
Date: Fri, 19 Aug 2016 13:53:48 +0100
Message-ID: <CAFEAcA99RScdr+E39Q+03L5DyDLiQgQo9x1DeP1gE2-nJ1yUig@mail.gmail.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CF240F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 08:46:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mV72EHK7o3GQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2016 08:46:35 -0400 (EDT)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C2B640B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 08:46:35 -0400 (EDT)
Received: by mail-ua0-f170.google.com with SMTP id 74so78135274uau.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 05:54:09 -0700 (PDT)
In-Reply-To: <1471610295-1456-6-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 August 2016 at 13:38, Marc Zyngier <marc.zyngier@arm.com> wrote:
> So far, we've been disabling KVM on systems where the GICV region couldn't
> be safely given to a guest. Now that we're able to handle this access
> safely by emulating it in HYP, we can enable this feature when we detect
> an unsafe configuration.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 69 +++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 27 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index b8da901..d1dcfc76 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -278,12 +278,14 @@ int vgic_v2_map_resources(struct kvm *kvm)
>                 goto out;
>         }
>
> -       ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
> -                                   kvm_vgic_global_state.vcpu_base,
> -                                   KVM_VGIC_V2_CPU_SIZE, true);
> -       if (ret) {
> -               kvm_err("Unable to remap VGIC CPU to VCPU\n");
> -               goto out;
> +       if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
> +               ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
> +                                           kvm_vgic_global_state.vcpu_base,
> +                                           KVM_VGIC_V2_CPU_SIZE, true);
> +               if (ret) {
> +                       kvm_err("Unable to remap VGIC CPU to VCPU\n");
> +                       goto out;
> +               }
>         }
>
>         dist->ready = true;
> @@ -312,45 +314,51 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>                 return -ENXIO;
>         }
>
> -       if (!PAGE_ALIGNED(info->vcpu.start)) {
> -               kvm_err("GICV physical address 0x%llx not page aligned\n",
> -                       (unsigned long long)info->vcpu.start);
> -               return -ENXIO;
> -       }
> +       if (!PAGE_ALIGNED(info->vcpu.start) ||
> +           !PAGE_ALIGNED(resource_size(&info->vcpu))) {
> +               kvm_info("GICV region size/alignement is unsafe, using trapping\n");

"alignment".

Is it worth specifically saying "performance will be worse", or do we
expect this to only happen on systems where the h/w can't permit direct
access (as opposed to those with bad dt info) ?

thanks
-- PMM
