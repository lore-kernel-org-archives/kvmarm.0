Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B819C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 13:14:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89B9E613B4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 13:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89B9E613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 084904B081;
	Fri, 18 Jun 2021 09:14:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id se8ezNLAj5J8; Fri, 18 Jun 2021 09:14:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6924A418;
	Fri, 18 Jun 2021 09:14:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7A04A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 09:14:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c0sHDmDj6Opc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 09:14:16 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA4834A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 09:14:15 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5zns4TKSzZgHJ;
 Fri, 18 Jun 2021 21:11:13 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 21:14:10 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 21:14:09 +0800
Subject: Re: [PATCH v7 3/4] KVM: arm64: Tweak parameters of guest cache
 maintenance functions
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-4-wangyanan55@huawei.com>
 <87czsjcsv8.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <83887c42-4dbe-b25b-6f5f-cf1766198bdf@huawei.com>
Date: Fri, 18 Jun 2021 21:14:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87czsjcsv8.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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



On 2021/6/18 19:30, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 11:58:23 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> Adjust the parameter "kvm_pfn_t pfn" of __clean_dcache_guest_page
>> and __invalidate_icache_guest_page to "void *va", which paves the
>> way for converting these two guest CMO functions into callbacks in
>> structure kvm_pgtable_mm_ops. No functional change.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_mmu.h |  9 ++-------
>>   arch/arm64/kvm/mmu.c             | 28 +++++++++++++++-------------
>>   2 files changed, 17 insertions(+), 20 deletions(-)
>>
> [...]
>
>> @@ -1219,7 +1221,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>   	 * We've moved a page around, probably through CoW, so let's treat it
>>   	 * just like a translation fault and clean the cache to the PoC.
>>   	 */
>> -	clean_dcache_guest_page(pfn, PAGE_SIZE);
>> +	clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
> This obviously doesn't compile. I have fixed it locally, but in the
> future please make sure that patch series can be bisected correctly.
Ah, yes, I figure out what I have missed by mistake now, and this should
have never happened... Much thanks for the local fixes for this series.
Also thank Fuad for the naming reference and review.

Regards,
Yanan
.
> Thanks,
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
