Return-Path: <SRS0=WgPl=5B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEBDC0044D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 17:25:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E70FE20674
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 17:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBJcopzT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E70FE20674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 900EC4A2E5;
	Mon, 16 Mar 2020 13:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wsW1f-TrJegN; Mon, 16 Mar 2020 13:25:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7423A4A4C0;
	Mon, 16 Mar 2020 13:25:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B834A32E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 13:25:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pPcHFfv02Vz6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 13:25:54 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A09A340456
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 13:25:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584379554;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=14nagzG00kW25fpr2NHXBqWB0Eexn4LV6EB16qmcCL8=;
 b=UBJcopzT3PLAq1v9VhTzCwhIbCaWLBwYg0yhFMTg31pM58yu7TUgAvXif8gKz5AmlRUCV4
 yZb+sG4CdKGPATJxn8ECx3MuOMV2rqq130kKAU3r/Xi6Ru2F93Co0NBHDPcdjbm5pkICW6
 XjL/yKZs565fwGiaKSnXt1wQxeeGfZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-EMPcXmZHMUiXheWWQm3ZJg-1; Mon, 16 Mar 2020 13:25:52 -0400
X-MC-Unique: EMPcXmZHMUiXheWWQm3ZJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D116126CBE7;
 Mon, 16 Mar 2020 17:10:28 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C032560BFB;
 Mon, 16 Mar 2020 17:10:23 +0000 (UTC)
Subject: Re: [PATCH v5 07/23] irqchip/gic-v4.1: Map the ITS SGIR register page
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-8-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <0f0b3613-0306-a43c-b935-c842c1025b6b@redhat.com>
Date: Mon, 16 Mar 2020 18:10:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-8-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> One of the new features of GICv4.1 is to allow virtual SGIs to be
> directly signaled to a VPE. For that, the ITS has grown a new
> 64kB page containing only a single register that is used to
> signal a SGI to a given VPE.
> 
> Add a second mapping covering this new 64kB range, and take this
> opportunity to limit the original mapping to 64kB, which is enough
> to cover the span of the ITS registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index bcc1a0957cda..54d6fdf7a28e 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -96,6 +96,7 @@ struct its_node {
>  	struct mutex		dev_alloc_lock;
>  	struct list_head	entry;
>  	void __iomem		*base;
> +	void __iomem		*sgir_base;
>  	phys_addr_t		phys_base;
>  	struct its_cmd_block	*cmd_base;
>  	struct its_cmd_block	*cmd_write;
> @@ -4456,7 +4457,7 @@ static int __init its_probe_one(struct resource *res,
>  	struct page *page;
>  	int err;
>  
> -	its_base = ioremap(res->start, resource_size(res));
> +	its_base = ioremap(res->start, SZ_64K);
>  	if (!its_base) {
>  		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
>  		return -ENOMEM;
> @@ -4507,6 +4508,13 @@ static int __init its_probe_one(struct resource *res,
>  
>  		if (is_v4_1(its)) {
>  			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, typer);
> +
> +			its->sgir_base = ioremap(res->start + SZ_128K, SZ_64K);
> +			if (!its->sgir_base) {
> +				err = -ENOMEM;
> +				goto out_free_its;
> +			}
> +
>  			its->mpidr = readl_relaxed(its_base + GITS_MPIDR);
>  
>  			pr_info("ITS@%pa: Using GICv4.1 mode %08x %08x\n",
> @@ -4520,7 +4528,7 @@ static int __init its_probe_one(struct resource *res,
>  				get_order(ITS_CMD_QUEUE_SZ));
>  	if (!page) {
>  		err = -ENOMEM;
> -		goto out_free_its;
> +		goto out_unmap_sgir;
>  	}
>  	its->cmd_base = (void *)page_address(page);
>  	its->cmd_write = its->cmd_base;
> @@ -4587,6 +4595,9 @@ static int __init its_probe_one(struct resource *res,
>  	its_free_tables(its);
>  out_free_cmd:
>  	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
> +out_unmap_sgir:
> +	if (its->sgir_base)
> +		iounmap(its->sgir_base);
>  out_free_its:
>  	kfree(its);
>  out_unmap:
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
