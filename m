Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DDEC8300B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 11:25:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29C1620774
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 11:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29C1620774
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C8C4B3A3;
	Thu, 30 Apr 2020 07:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUCpXASsPTAy; Thu, 30 Apr 2020 07:25:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2864B3A4;
	Thu, 30 Apr 2020 07:25:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CEB4B373
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:25:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0ZJ+F7ZA3EJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 07:25:07 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8C7E4B30E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:25:06 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id B6CDFD5C09F13723E425;
 Thu, 30 Apr 2020 19:25:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 19:24:55 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Initialize GICv4.1 even in the
 absence of a virtual ITS
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20200425094426.162962-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5b23b938-f71f-5523-6d7e-027bcca98dd4@huawei.com>
Date: Thu, 30 Apr 2020 19:24:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200425094426.162962-1-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/4/25 17:44, Marc Zyngier wrote:
> KVM now expects to be able to use HW-accelerated delivery of vSGIs
> as soon as the guest has enabled thm. Unfortunately, we only
them
> initialize the GICv4 context if we have a virtual ITS exposed to
> the guest.
> 
> Fix it by always initializing the GICv4.1 context if it is
> available on the host.
> 
> Fixes: 2291ff2f2a56 ("KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   virt/kvm/arm/vgic/vgic-init.c    | 9 ++++++++-
>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 ++-
>   2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index a963b9d766b73..8e6f350c3bcd1 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -294,8 +294,15 @@ int vgic_init(struct kvm *kvm)
>   		}
>   	}
>   
> -	if (vgic_has_its(kvm)) {
> +	if (vgic_has_its(kvm))
>   		vgic_lpi_translation_cache_init(kvm);
> +
> +	/*
> +	 * If we have GICv4.1 enabled, unconditionnaly request enable the
> +	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
> +	 * enable it if we present a virtual ITS to the guest.
> +	 */
> +	if (vgic_supports_direct_msis(kvm)) {
>   		ret = vgic_v4_init(kvm);
>   		if (ret)
>   			goto out;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index e72dcc4542475..26b11dcd45524 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -50,7 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
>   
>   bool vgic_supports_direct_msis(struct kvm *kvm)
>   {
> -	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +	return (kvm_vgic_global_state.has_gicv4_1 ||
> +		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
>   }

Not related to this patch, but I think that the function name can be
improved a bit after this change. It now indicates whether the vGIC
supports direct MSIs injection *or* direct SGIs injection, not just
MSIs. And if vgic_has_its() is false, we don't even support MSIs.

The fix itself looks correct to me,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
