Return-Path: <SRS0=xsle=VW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405FFC7618B
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 16:38:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0100A218F0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 16:38:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0100A218F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 834854A5B4;
	Thu, 25 Jul 2019 12:38:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XhxicbtuZQNm; Thu, 25 Jul 2019 12:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A4C4A5F5;
	Thu, 25 Jul 2019 12:38:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01DF4A5B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 12:38:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XW3SySG4+WQW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jul 2019 12:38:20 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C80F64A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 12:38:20 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 343C930860C7;
 Thu, 25 Jul 2019 16:38:20 +0000 (UTC)
Received: from [10.36.116.102] (ovpn-116-102.ams2.redhat.com [10.36.116.102])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4148819C7F;
 Thu, 25 Jul 2019 16:38:17 +0000 (UTC)
Subject: Re: [PATCH v3 05/10] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on disabling LPIs
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190725153543.24386-1-maz@kernel.org>
 <20190725153543.24386-6-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <976a00ae-8aa7-dde2-1ae6-3940f1370632@redhat.com>
Date: Thu, 25 Jul 2019 18:38:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190725153543.24386-6-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.44]); Thu, 25 Jul 2019 16:38:20 +0000 (UTC)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <Andre.Przywara@arm.com>, "Raslan,
 KarimAllah" <karahmed@amazon.de>, "Saidi, Ali" <alisaidi@amazon.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 7/25/19 5:35 PM, Marc Zyngier wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> If a vcpu disables LPIs at its redistributor level, we need to make sure
> we won't pend more interrupts. For this, we need to invalidate the LPI
> translation cache.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 936962abc38d..cb60da48810d 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -192,8 +192,10 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>  
>  	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
>  
> -	if (was_enabled && !vgic_cpu->lpis_enabled)
> +	if (was_enabled && !vgic_cpu->lpis_enabled) {
>  		vgic_flush_pending_lpis(vcpu);
> +		vgic_its_invalidate_cache(vcpu->kvm);
> +	}
>  
>  	if (!was_enabled && vgic_cpu->lpis_enabled)
>  		vgic_enable_lpis(vcpu);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
