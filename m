From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Check GICV address is placed at a 4Kb boundary
Date: Wed, 29 Jun 2016 14:43:42 +0200
Message-ID: <20160629124342.GV26498@cbox>
References: <cb18ab2d-12d9-bdd2-8432-801af488e340@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1467249B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 08:37:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQ0zgbhlHdPV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 08:37:40 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 505D449AF5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 08:37:40 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id 187so33309270wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 05:42:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cb18ab2d-12d9-bdd2-8432-801af488e340@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Itaru,

On Wed, Jun 29, 2016 at 03:22:45PM +0900, Itaru Kitayama wrote:
> Make sure GICV physical address is placed at a 4Kb boundary as spec
> says, not host kernel's page boundary. This prevents !4Kb kernels
> from returning an ENXIO prematurely during the KVM init phase at
> boot.
> Tested on Overdrive 3000 with 64Kb page-size kernel with ACPI.
> 
> Signed-off-by: Itaru Kitayama <itaru.kitayama@riken.jp>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index e31405e..0123e5d 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -309,17 +309,15 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>                 return -ENXIO;
>         }
> 
> -       if (!PAGE_ALIGNED(info->vcpu.start)) {
> -               kvm_err("GICV physical address 0x%llx not page aligned\n",
> +       if (!IS_ALIGNED(info->vcpu.start, SZ_4K)) {
> +               kvm_err("GICV physical address 0x%llx not 4Kb aligned\n",
>                         (unsigned long long)info->vcpu.start);
>                 return -ENXIO;
>         }
> 
> -       if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> -               kvm_err("GICV size 0x%llx not a multiple of page
> size 0x%lx\n",
> -                       (unsigned long long)resource_size(&info->vcpu),
> +       if (!PAGE_ALIGNED(resource_size(&info->vcpu)))
> +               kvm_warn("GICV size 0x%llx not a multiple of page
> size 0x%lx, system may be unsafe\n", (unsigned long
> long)resource_size(&info->vcpu),
>                         PAGE_SIZE);
> -               return -ENXIO;
>         }
> 
>         kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,

Doesn't this change carry the risk of KVM mapping a page (larger than
4K) containing other things than the GICV interface into the guest,
potentially breaking isolation of the VM from host hardware resources?

-Christoffer
