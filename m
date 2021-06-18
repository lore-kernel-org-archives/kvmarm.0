Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6FCC2B9F4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 01:52:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 719BC613AA
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 01:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 719BC613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A704B11C;
	Thu, 17 Jun 2021 21:52:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F9pOyZBSQu7U; Thu, 17 Jun 2021 21:52:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA214B0F6;
	Thu, 17 Jun 2021 21:52:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7E84B0F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 21:52:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3583XKXu0cg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 21:52:43 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DE114B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 21:52:42 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5hd256cNzXh6G;
 Fri, 18 Jun 2021 09:47:34 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:52:38 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:52:37 +0800
Subject: Re: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance
 callbacks
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-2-wangyanan55@huawei.com>
 <20210617123837.GA24457@willie-the-truck> <87eed0d13p.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2c1b9376-3997-aa7b-d5f3-b04da985c260@huawei.com>
Date: Fri, 18 Jun 2021 09:52:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87eed0d13p.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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



On 2021/6/17 22:20, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 13:38:37 +0100,
> Will Deacon <will@kernel.org> wrote:
>> On Thu, Jun 17, 2021 at 06:58:21PM +0800, Yanan Wang wrote:
>>> To prepare for performing CMOs for guest stage-2 in the fault handlers
>>> in pgtable.c, here introduce two cache maintenance callbacks in struct
>>> kvm_pgtable_mm_ops. We also adjust the comment alignment for the
>>> existing part but make no real content change at all.
>>>
>>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>>> ---
>>>   arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
>>>   1 file changed, 25 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>>> index c3674c47d48c..b6ce34aa44bb 100644
>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>> @@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
>>>   
>>>   /**
>>>    * struct kvm_pgtable_mm_ops - Memory management callbacks.
>>> - * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
>>> - *			can be used by the walker to pass a memcache. The
>>> - *			initial refcount of the page is 1.
>>> - * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
>>> - *			@size parameter is in bytes, and is rounded-up to the
>>> - *			next page boundary. The resulting allocation is
>>> - *			physically contiguous.
>>> - * @free_pages_exact:	Free an exact number of memory pages previously
>>> - *			allocated by zalloc_pages_exact.
>>> - * @get_page:		Increment the refcount on a page.
>>> - * @put_page:		Decrement the refcount on a page. When the refcount
>>> - *			reaches 0 the page is automatically freed.
>>> - * @page_count:		Return the refcount of a page.
>>> - * @phys_to_virt:	Convert a physical address into a virtual address mapped
>>> - *			in the current context.
>>> - * @virt_to_phys:	Convert a virtual address mapped in the current context
>>> - *			into a physical address.
>>> + * @zalloc_page:		Allocate a single zeroed memory page.
>>> + *				The @arg parameter can be used by the walker
>>> + *				to pass a memcache. The initial refcount of
>>> + *				the page is 1.
>>> + * @zalloc_pages_exact:		Allocate an exact number of zeroed memory pages.
>>> + *				The @size parameter is in bytes, and is rounded
>>> + *				up to the next page boundary. The resulting
>>> + *				allocation is physically contiguous.
>>> + * @free_pages_exact:		Free an exact number of memory pages previously
>>> + *				allocated by zalloc_pages_exact.
>>> + * @get_page:			Increment the refcount on a page.
>>> + * @put_page:			Decrement the refcount on a page. When the
>>> + *				refcount reaches 0 the page is automatically
>>> + *				freed.
>>> + * @page_count:			Return the refcount of a page.
>>> + * @phys_to_virt:		Convert a physical address into a virtual address
>>> + *				mapped in the current context.
>>> + * @virt_to_phys:		Convert a virtual address mapped in the current
>>> + *				context into a physical address.
>>> + * @clean_invalidate_dcache:	Clean and invalidate the data cache for the
>>> + *				specified memory address range.
>> This should probably be explicit about whether this to the PoU/PoC/PoP.
> Indeed. I can fix that locally if there is nothing else that requires
> adjusting.
Will be grateful !

Thanks,
Yanan
.
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
