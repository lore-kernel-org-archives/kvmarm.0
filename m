Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971ACC43461
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 04:20:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 074506141C
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 04:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 074506141C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 628BA4B410;
	Wed, 21 Apr 2021 00:20:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ER1R2PDypvP9; Wed, 21 Apr 2021 00:20:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 255C74B442;
	Wed, 21 Apr 2021 00:20:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15A194B417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 00:20:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id doZRXb84hSW0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 00:20:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7BB4B410
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 00:20:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618978815;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cjSZHEWY3U288wOLcJF8bqxNww9jB3gUcMdbQn87aho=;
 b=WPiD4a6+QSu+w6WoVHUjkApWkiuD4MjEn2TpyOGXTM/ZyqODGW8s/dLfUL3yzSpMV6vX4C
 aBYHNV5/hIYpKI+jd8z3Gdf4kw7BlJMDVUvSbqVo6fN4p17QkpS2wbRGY1mX6cBNjpF0mL
 bXM8n+KX+j9rplvSmIioFq+gv4SrTdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-2MP_mfYzO3GgSUEupOd9pg-1; Wed, 21 Apr 2021 00:20:08 -0400
X-MC-Unique: 2MP_mfYzO3GgSUEupOd9pg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A42ED100806B;
 Wed, 21 Apr 2021 04:20:06 +0000 (UTC)
Received: from [10.64.54.47] (vpn2-54-47.bne.redhat.com [10.64.54.47])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 846416061F;
 Wed, 21 Apr 2021 04:20:03 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To: Keqian Zhu <zhukeqian1@huawei.com>, Santosh Shukla <sashukla@nvidia.com>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
Date: Wed, 21 Apr 2021 16:20:12 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: cjia@nvidia.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Keqian and Santosh,

On 4/21/21 12:59 PM, Keqian Zhu wrote:
> On 2020/10/22 0:16, Santosh Shukla wrote:
>> The Commit:6d674e28 introduces a notion to detect and handle the
>> device mapping. The commit checks for the VM_PFNMAP flag is set
>> in vma->flags and if set then marks force_pte to true such that
>> if force_pte is true then ignore the THP function check
>> (/transparent_hugepage_adjust()).
>>
>> There could be an issue with the VM_PFNMAP flag setting and checking.
>> For example consider a case where the mdev vendor driver register's
>> the vma_fault handler named vma_mmio_fault(), which maps the
>> host MMIO region in-turn calls remap_pfn_range() and maps
>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>> the VM_PFNMAP flag into vma->flags.
> Could you give the name of the mdev vendor driver that triggers this issue?
> I failed to find one according to your description. Thanks.
> 

I think it would be fixed in driver side to set VM_PFNMAP in
its mmap() callback (call_mmap()), like vfio PCI driver does.
It means it won't be delayed until page fault is issued and
remap_pfn_range() is called. It's determined from the beginning
that the vma associated the mdev vendor driver is serving as
PFN remapping purpose. So the vma should be populated completely,
including the VM_PFNMAP flag before it becomes visible to user
space.

The example can be found from vfio driver in drivers/vfio/pci/vfio_pci.c:
     vfio_pci_mmap:       VM_PFNMAP is set for the vma
     vfio_pci_mmap_fault: remap_pfn_range() is called

Thanks,
Gavin

>>
>> Now lets assume a mmio fault handing flow where guest first access
>> the MMIO region whose 2nd stage translation is not present.
>> So that results to arm64-kvm hypervisor executing guest abort handler,
>> like below:
>>
>> kvm_handle_guest_abort() -->
>>   user_mem_abort()--> {
>>
>>      ...
>>      0. checks the vma->flags for the VM_PFNMAP.
>>      1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
>>      2. gfn_to_pfn_prot() -->
>>          __gfn_to_pfn_memslot() -->
>>              fixup_user_fault() -->
>>                  handle_mm_fault()-->
>>                      __do_fault() -->
>>                         vma_mmio_fault() --> // vendor's mdev fault handler
>>                          remap_pfn_range()--> // Here sets the VM_PFNMAP
>> 						flag into vma->flags.
>>      3. Now that force_pte is set to false in step-2),
>>         will execute transparent_hugepage_adjust() func and
>>         that lead to Oops [4].
>>   }
>>
>> The proposition is to check is_iomap flag before executing the THP
>> function transparent_hugepage_adjust().
>>
>> [4] THP Oops:
>>> pc: kvm_is_transparent_hugepage+0x18/0xb0
>>> ...
>>> ...
>>> user_mem_abort+0x340/0x9b8
>>> kvm_handle_guest_abort+0x248/0x468
>>> handle_exit+0x150/0x1b0
>>> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
>>> kvm_vcpu_ioctl+0x3c0/0x858
>>> ksys_ioctl+0x84/0xb8
>>> __arm64_sys_ioctl+0x28/0x38
>>
>> Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev device.
>> Linux tip: 583090b1
>>
>> Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
>> Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 3d26b47..ff15357 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1947,7 +1947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	 * If we are not forced to use page mapping, check if we are
>>   	 * backed by a THP and thus use block mapping if possible.
>>   	 */
>> -	if (vma_pagesize == PAGE_SIZE && !force_pte)
>> +	if (vma_pagesize == PAGE_SIZE && !force_pte && !is_iomap(flags))
>>   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>   							   &pfn, &fault_ipa);
>>   	if (writable)
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
