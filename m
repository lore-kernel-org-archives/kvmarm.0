From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 2/9] KVM: arm/arm64: vgic-its: Fix
 vgic_its_restore_collection_table returned value
Date: Thu, 2 Nov 2017 06:50:01 +0100
Message-ID: <CAMJs5B8_zfmb0kwHy0To0P3MqucS08QyW2yVzaOdEZS7+k9PiA@mail.gmail.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1BB749D21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 01:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qHCcuJZXSdp4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 01:48:22 -0400 (EDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
 [209.85.192.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7E3F406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 01:48:22 -0400 (EDT)
Received: by mail-pf0-f194.google.com with SMTP id i5so3792091pfe.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Nov 2017 22:50:03 -0700 (PDT)
In-Reply-To: <1509031391-4407-3-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26, 2017 at 05:23:04PM +0200, Eric Auger wrote:
> vgic_its_restore_cte returns +1 if the collection table entry
> is valid and properly decoded. As a consequence, if the
> collection table is fully filled with valid data that are
> decoded without error, vgic_its_restore_collection_table()
> returns +1. This is wrong.
>
> Let's return 0 in that case.
>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> Fixes: ea1ad53e1e31a3 (KVM: arm64: vgic-its: Collection table save/restore)
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
>
> v5 -> v6:
> - use the same trick as vgic_its_restore_itt and
>   vgic_its_restore_device_tables
>
> v4 -> v5:
> - added Christoffer R-b
>
> v2 -> v3: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index d27a301..8230ffe 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2268,6 +2268,10 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>   gpa += cte_esz;
>   read += cte_esz;
>   }
> +
> + if (ret > 0)
> + return 0;
> +
>   return ret;
>  }
>
> --
> 2.5.5
>
