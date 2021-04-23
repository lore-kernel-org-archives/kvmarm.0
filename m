Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8824EC433ED
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 01:06:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B760E61437
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 01:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B760E61437
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BBB34B434;
	Thu, 22 Apr 2021 21:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fuzZ+PRITYJj; Thu, 22 Apr 2021 21:06:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFCF94B38F;
	Thu, 22 Apr 2021 21:06:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79304B36F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 21:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5uOfBD++GLZf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 21:06:35 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 321AD4B36B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 21:06:35 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRGKF14mpzlZ7r;
 Fri, 23 Apr 2021 09:04:33 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 23 Apr 2021 09:06:21 +0800
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To: Santosh Shukla <santosh.shukla1982@gmail.com>, "Tarun Gupta (SW-GPU)"
 <targupta@nvidia.com>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
 <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com>
 <871rb3rgpl.wl-maz@kernel.org>
 <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com>
 <87v98eq0dh.wl-maz@kernel.org>
 <bf782ec1-71da-5a8e-f250-20ed88677b8c@nvidia.com>
 <CACpj22xhXHMgsZHrL_2AbEzy=zzz=jXz0s6pRb0=zpJUai1ufg@mail.gmail.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <c8b479d0-0766-ecb7-49fb-d94b715b0922@huawei.com>
Date: Fri, 23 Apr 2021 09:06:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CACpj22xhXHMgsZHrL_2AbEzy=zzz=jXz0s6pRb0=zpJUai1ufg@mail.gmail.com>
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Cc: cjia@nvidia.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2021/4/22 16:00, Santosh Shukla wrote:
> On Thu, Apr 22, 2021 at 1:07 PM Tarun Gupta (SW-GPU)
> <targupta@nvidia.com> wrote:
>>
>>
>>
>> On 4/22/2021 12:20 PM, Marc Zyngier wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Thu, 22 Apr 2021 03:02:00 +0100,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 4/21/21 9:59 PM, Marc Zyngier wrote:
>>>>> On Wed, 21 Apr 2021 07:17:44 +0100,
>>>>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>>>> On 2021/4/21 14:20, Gavin Shan wrote:
>>>>>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
>>>>>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
>>>>>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
>>>>>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
>>>>>>>>> in vma->flags and if set then marks force_pte to true such that
>>>>>>>>> if force_pte is true then ignore the THP function check
>>>>>>>>> (/transparent_hugepage_adjust()).
>>>>>>>>>
>>>>>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
>>>>>>>>> For example consider a case where the mdev vendor driver register's
>>>>>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
>>>>>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
>>>>>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>>>>>>>>> the VM_PFNMAP flag into vma->flags.
>>>>>>>> Could you give the name of the mdev vendor driver that triggers this issue?
>>>>>>>> I failed to find one according to your description. Thanks.
>>>>>>>>
>>>>>>>
>>>>>>> I think it would be fixed in driver side to set VM_PFNMAP in
>>>>>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
>>>>>>> It means it won't be delayed until page fault is issued and
>>>>>>> remap_pfn_range() is called. It's determined from the beginning
>>>>>>> that the vma associated the mdev vendor driver is serving as
>>>>>>> PFN remapping purpose. So the vma should be populated completely,
>>>>>>> including the VM_PFNMAP flag before it becomes visible to user
>>>>>>> space.
>>>>>
>>>>> Why should that be a requirement? Lazy populating of the VMA should be
>>>>> perfectly acceptable if the fault can only happen on the CPU side.
>>>>>
> 
> Right.
> Hi keqian,
> You can refer to case
> http://lkml.iu.edu/hypermail/linux/kernel/2010.3/00952.html
Hi Santosh,

Yeah, thanks for that.

BRs,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
