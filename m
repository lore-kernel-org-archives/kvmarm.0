Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9618C43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:54:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4AA102073D
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AA102073D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E764A4F6;
	Fri, 13 Dec 2019 05:54:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JvvjDP6Eqc3H; Fri, 13 Dec 2019 05:54:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABDFB4A54B;
	Fri, 13 Dec 2019 05:54:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 851F14A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:54:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZbKSnmtlOPNi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 05:54:07 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F414F4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:54:06 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 2A6E91B35A79113B855B;
 Fri, 13 Dec 2019 18:54:01 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 13 Dec 2019
 18:53:55 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <linux-kernel@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>
References: <20191213094237.19627-1-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
Date: Fri, 13 Dec 2019 18:53:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191213094237.19627-1-eric.auger@redhat.com>
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

Hi Eric,

On 2019/12/13 17:42, Eric Auger wrote:
> Saving/restoring an unmapped collection is a valid scenario. For
> example this happens if a MAPTI command was sent, featuring an
> unmapped collection. At the moment the CTE fails to be restored.
> Only compare against the number of online vcpus if the rdist
> base is set.

Have you actually seen a problem and this patch fixed it? To be honest,
I'm surprised to find that we can map a LPI to an unmapped collection ;)
(and prevent it to be delivered to vcpu with an INT_UNMAPPED_INTERRUPT
error, until someone had actually mapped the collection).
After a quick glance of spec (MAPTI), just as you said, this is valid.

If Marc has no objection to this fix, please add

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks,
Zenghui

> 
> Cc: stable@vger.kernel.org # v4.11+
> Fixes: ea1ad53e1e31a ("KVM: arm64: vgic-its: Collection table save/restore")
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>   virt/kvm/arm/vgic/vgic-its.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 98c7360d9fb7..17920d1b350a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2475,7 +2475,8 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>   	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
>   	coll_id = val & KVM_ITS_CTE_ICID_MASK;
>   
> -	if (target_addr >= atomic_read(&kvm->online_vcpus))
> +	if (target_addr != COLLECTION_NOT_MAPPED &&
> +	    target_addr >= atomic_read(&kvm->online_vcpus))
>   		return -EINVAL;
>   
>   	collection = find_collection(its, coll_id);
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
