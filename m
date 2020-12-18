Return-Path: <SRS0=w40L=FW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57B6C4361B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 08:22:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6ECC23A00
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 08:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6ECC23A00
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BCD04B10E;
	Fri, 18 Dec 2020 03:22:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ddr8-ZBQoHID; Fri, 18 Dec 2020 03:22:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7744B114;
	Fri, 18 Dec 2020 03:22:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 038074B104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 03:22:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xJ+-khKCAWgR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2020 03:22:14 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FA6E4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 03:22:14 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cy1zZ3NMpz7Gx1;
 Fri, 18 Dec 2020 16:21:30 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Fri, 18 Dec 2020 16:21:59 +0800
Subject: Re: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when
 promote pinned_scope
To: Alex Williamson <alex.williamson@redhat.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-5-zhukeqian1@huawei.com>
 <20201214170459.50cb8729@omen.home>
 <d2073c05-b6c9-04b4-782c-b89680834633@huawei.com>
 <20201215085359.053e73ed@x1.home>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <340a58c3-3781-db31-59fa-06b015d27a5e@huawei.com>
Date: Fri, 18 Dec 2020 16:21:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201215085359.053e73ed@x1.home>
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, Marc
 Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>
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


On 2020/12/15 23:53, Alex Williamson wrote:
> On Tue, 15 Dec 2020 17:37:11 +0800
> zhukeqian <zhukeqian1@huawei.com> wrote:
> 
>> Hi Alex,
>>
>> On 2020/12/15 8:04, Alex Williamson wrote:
[...]

>>>>  
>>>> +static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
>>>> +{
>>>> +	struct rb_node *n;
>>>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>>>> +
>>>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>>>> +		unsigned long nbits = dma->size >> pgshift;
>>>> +
>>>> +		if (dma->iommu_mapped)
>>>> +			bitmap_set(dma->bitmap, 0, nbits);
>>>> +	}
>>>> +}  
>>>
>>>
>>> If we detach a group which results in only non-IOMMU backed mdevs,
>>> don't we also clear dma->iommu_mapped as part of vfio_unmap_unpin()
>>> such that this test is invalid?  Thanks,  
>>
>> Good spot :-). The code will skip bitmap_set under this situation.
>>
>> We should set the bitmap unconditionally when vfio_iommu is promoted,
>> as we must have IOMMU backed domain before promoting the vfio_iommu.
>>
>> Besides, I think we should also mark dirty in vfio_remove_dma if dirty
>> tracking is active. Right?
> 
> There's no remaining bitmap to mark dirty if the vfio_dma is removed.
> In this case it's the user's responsibility to collect remaining dirty
> pages using the VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP support in the
> VFIO_IOMMU_UNMAP_DMA ioctl.  Thanks,
> 
Hi Alex,

Thanks for pointing it out. I also notice that vfio_iommu_type1_detach_group
will remove all dma_range (in vfio_iommu_unmap_unpin_all). If this happens
during dirty tracking, then we have no chance to report dirty log to userspace.

Besides, we will add more dirty log tracking ways to VFIO definitely, but
we has no framework to support this, thus makes it inconvenient to extend
and easy to lost dirty log.

Giving above, I plan to refactor our dirty tracking code. One core idea is
that we should distinguish Dirty Range Limit (such as pin, fully dirty) and
Real Dirty Track (such as iopf, smmu httu).

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
