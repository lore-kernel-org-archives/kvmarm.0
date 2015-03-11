From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 3/3] hw/intc/arm_gic: Initialize the vgic in the
 realize function
Date: Wed, 11 Mar 2015 14:56:22 +0000
Message-ID: <CAFEAcA-eg4ox+wH9ca7q6CCoyf4DskDWehz5G7Z5YyOgqE7oDw@mail.gmail.com>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
 <1425478577-32556-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E535148769
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:50:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZcG8LrAbD3HP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 10:50:24 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 172494867C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:50:23 -0400 (EDT)
Received: by lbiw7 with SMTP id w7so9438166lbi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 07:56:43 -0700 (PDT)
In-Reply-To: <1425478577-32556-4-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, "Michael S. Tsirkin" <mst@redhat.com>, Patch Tracking <patches@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 March 2015 at 14:16, Eric Auger <eric.auger@linaro.org> wrote:
> This patch forces vgic initialization in the vgic realize function.
> It uses a new group/attribute that allows such operation:
> KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_CTRL_INIT
>
> This earlier initialization allows, for example, to setup VFIO
> signaling and irqfd after vgic initialization, on a reset notifier.
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  hw/intc/arm_gic_kvm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
> index 1ad3eb0..1395c9e 100644
> --- a/hw/intc/arm_gic_kvm.c
> +++ b/hw/intc/arm_gic_kvm.c
> @@ -573,6 +573,12 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
>          kvm_gic_access(s, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, 0, &numirqs, 1);
>      }
>
> +    if (kvm_gic_supports_attr(s, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +                              KVM_DEV_ARM_VGIC_CTRL_INIT)) {
> +        kvm_gic_access(s, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +                          KVM_DEV_ARM_VGIC_CTRL_INIT, 0, 0, 1);
> +    }

This is opaque enough that I think a comment in front of it
would be nice; something like
    /* Tell the kernel to complete initialization of the VGIC now */

Otherwise
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
