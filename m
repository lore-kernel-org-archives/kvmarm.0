Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7F1C2BA19
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 01:18:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3651C2076D
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 01:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3651C2076D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4D74B12E;
	Wed, 15 Apr 2020 21:18:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FLYZR94Mfde2; Wed, 15 Apr 2020 21:18:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E1C4B14D;
	Wed, 15 Apr 2020 21:18:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 484674B134
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 21:18:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J9E5KN97WS8c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 21:18:09 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D461C4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 21:18:08 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 35B945A0308DF2F16736;
 Thu, 16 Apr 2020 09:18:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Apr 2020
 09:17:55 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-its: Fix memory leak on the error
 path of vgic_add_lpi()
To: <kvmarm@lists.cs.columbia.edu>
References: <20200414030349.625-1-yuzenghui@huawei.com>
 <20200414030349.625-3-yuzenghui@huawei.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <610f2195-f85d-4beb-b711-47d63bb393d0@huawei.com>
Date: Thu, 16 Apr 2020 09:17:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200414030349.625-3-yuzenghui@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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

On 2020/4/14 11:03, Zenghui Yu wrote:
> If we're going to fail out the vgic_add_lpi(), let's make sure the
> allocated vgic_irq memory is also freed. Though it seems that both
> cases are unlikely to fail.
> 
> Cc: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>   virt/kvm/arm/vgic/vgic-its.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index d53d34a33e35..3c3b6a0f2dce 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -98,12 +98,16 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>   	 * the respective config data from memory here upon mapping the LPI.
>   	 */
>   	ret = update_lpi_config(kvm, irq, NULL, false);
> -	if (ret)
> +	if (ret) {
> +		kfree(irq);
>   		return ERR_PTR(ret);
> +	}
>   
>   	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
> -	if (ret)
> +	if (ret) {
> +		kfree(irq);
>   		return ERR_PTR(ret);
> +	}

Looking at it again, I realized that this error handling is still not
complete. Maybe we should use a vgic_put_irq() instead so that we can
also properly delete the vgic_irq from lpi_list.

Marc, what do you think? Could you please help to fix it, or I can
resend it.


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
