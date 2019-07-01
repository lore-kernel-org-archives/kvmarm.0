Return-Path: <SRS0=uL1D=U6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBAAC06510
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 12:38:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7AC4214AE
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 12:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7AC4214AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC3A4A4C0;
	Mon,  1 Jul 2019 08:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XoeGeMQc4Gm1; Mon,  1 Jul 2019 08:38:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5CE4A4CA;
	Mon,  1 Jul 2019 08:38:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2604A4A4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 08:38:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIdRXjfishuD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jul 2019 08:38:34 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDAEC4A32E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 08:38:34 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id EC77836887;
 Mon,  1 Jul 2019 12:38:25 +0000 (UTC)
Received: from [10.36.116.89] (ovpn-116-89.ams2.redhat.com [10.36.116.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 372891B4B0;
 Mon,  1 Jul 2019 12:38:17 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-5-marc.zyngier@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
Date: Mon, 1 Jul 2019 14:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-5-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.30]); Mon, 01 Jul 2019 12:38:26 +0000 (UTC)
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>
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

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> The LPI translation cache needs to be discarded when an ITS command
> may affect the translation of an LPI (DISCARD and MAPD with V=0) or
> the routing of an LPI to a redistributor with disabled LPIs (MOVI,
> MOVALL).
> 
> We decide to perform a full invalidation of the cache, irrespective
> of the LPI that is affected. Commands are supposed to be rare enough
> that it doesn't matter.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9b6b66204b97..5254bb762e1b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -733,6 +733,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>  		 * don't bother here since we clear the ITTE anyway and the
>  		 * pending state is a property of the ITTE struct.
>  		 */
> +		vgic_its_invalidate_cache(kvm);
> +
>  		its_free_ite(kvm, ite);
>  		return 0;
>  	}
> @@ -768,6 +770,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>  	ite->collection = collection;
>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
> +	vgic_its_invalidate_cache(kvm);
> +
>  	return update_affinity(ite->irq, vcpu);
>  }
>  
> @@ -996,6 +1000,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
>  	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
>  		its_free_ite(kvm, ite);
>  
> +	vgic_its_invalidate_cache(kvm);
> +
>  	list_del(&device->dev_list);
>  	kfree(device);
>  }
> @@ -1249,6 +1255,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>  		vgic_put_irq(kvm, irq);
>  	}
>  
> +	vgic_its_invalidate_cache(kvm);
All the commands are executed with the its_lock held. Now we don't take
it anymore on the fast cache injection path. Don't we have a window
where the move has been applied at table level and the cache is not yet
invalidated? Same question for vgic_its_free_device().

Thanks

Eric


> +
>  	kfree(intids);
>  	return 0;
>  }
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
