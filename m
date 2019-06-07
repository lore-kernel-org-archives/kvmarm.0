Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AA7C468BD
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 14:29:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B44CC20657
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 14:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B44CC20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C0B4A4C0;
	Fri,  7 Jun 2019 10:29:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id svgCtCjA-wDN; Fri,  7 Jun 2019 10:29:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3558A4A4D5;
	Fri,  7 Jun 2019 10:29:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AFE74A380
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 10:29:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3xUfJbHt9DkK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 10:29:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A5034A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 10:29:40 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 7446C30BC582;
 Fri,  7 Jun 2019 14:29:34 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 072FC60634;
 Fri,  7 Jun 2019 14:29:30 +0000 (UTC)
Subject: Re: [PATCH 4/8] KVM: arm/arm64: vgic-its: Add kvm parameter to
 vgic_its_free_collection
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-5-marc.zyngier@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <42b2f7fe-60e1-90b2-bc8a-515dc17f9d9c@redhat.com>
Date: Fri, 7 Jun 2019 16:29:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606165455.162478-5-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.49]); Fri, 07 Jun 2019 14:29:34 +0000 (UTC)
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>
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
On 6/6/19 6:54 PM, Marc Zyngier wrote:
> As we are going to perform some VM-wide operations when freeing
> a collection, add the kvm pointer to vgic_its_free_collection.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Eventually do you use that commit in subsequent patches?

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index bc370b6c5afa..f637edd77e1f 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -885,7 +885,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  	return 0;
>  }
>  
> -static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
> +static void vgic_its_free_collection(struct kvm *kvm,
> +				     struct vgic_its *its, u32 coll_id)
>  {
>  	struct its_collection *collection;
>  	struct its_device *device;
> @@ -974,7 +975,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	ite = vgic_its_alloc_ite(device, collection, event_id);
>  	if (IS_ERR(ite)) {
>  		if (new_coll)
> -			vgic_its_free_collection(its, coll_id);
> +			vgic_its_free_collection(kvm, its, coll_id);
>  		return PTR_ERR(ite);
>  	}
>  
> @@ -984,7 +985,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
>  	if (IS_ERR(irq)) {
>  		if (new_coll)
> -			vgic_its_free_collection(its, coll_id);
> +			vgic_its_free_collection(kvm, its, coll_id);
>  		its_free_ite(kvm, ite);
>  		return PTR_ERR(irq);
>  	}
> @@ -1025,7 +1026,7 @@ static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
>  	struct its_collection *cur, *temp;
>  
>  	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
> -		vgic_its_free_collection(its, cur->collection_id);
> +		vgic_its_free_collection(kvm, its, cur->collection_id);
>  }
>  
>  /* Must be called with its_lock mutex held */
> @@ -1110,7 +1111,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>  		return E_ITS_MAPC_PROCNUM_OOR;
>  
>  	if (!valid) {
> -		vgic_its_free_collection(its, coll_id);
> +		vgic_its_free_collection(kvm, its, coll_id);
>  	} else {
>  		collection = find_collection(its, coll_id);
>  
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
