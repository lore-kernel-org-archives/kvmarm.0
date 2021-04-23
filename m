Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D63C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 23:38:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BFCB61059
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 23:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BFCB61059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF564B22E;
	Thu, 22 Apr 2021 19:38:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1kpjXGlC76ym; Thu, 22 Apr 2021 19:38:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED914B288;
	Thu, 22 Apr 2021 19:38:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4FC74B22E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 19:38:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Or5nw3ev4P5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 19:38:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D74F4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 19:38:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619134731;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bcDE3sqsWHuqQL+B9smTf1hp8AVzLqNa56QsRBV4nHA=;
 b=iUzae5zrJzthNyPJLLvcdG3bUJYcYx68ToFCUKG3K5c6DJ2ra0ks/Jkaj7aePihboBTNR9
 J+LuIA7DsVymlrkngEXBdoI4pxjepdm3jboZ8E9ECYcIj9sX8tJQLCikots4qqVD0X5Lgz
 AAaviBDxfvnIO9hxFfnl1xBvPuLXmBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-9G7cYNIXOj-Tj_QQxtYAhg-1; Thu, 22 Apr 2021 19:38:50 -0400
X-MC-Unique: 9G7cYNIXOj-Tj_QQxtYAhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F25B91104;
 Thu, 22 Apr 2021 23:38:31 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B228759479;
 Thu, 22 Apr 2021 23:38:28 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To: Marc Zyngier <maz@kernel.org>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
 <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com>
 <871rb3rgpl.wl-maz@kernel.org>
 <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com>
 <87v98eq0dh.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <33eb4850-2476-01ae-e3db-5bd20c1a2c23@redhat.com>
Date: Fri, 23 Apr 2021 11:38:38 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87v98eq0dh.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: cjia@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 4/22/21 4:50 PM, Marc Zyngier wrote:
> On Thu, 22 Apr 2021 03:02:00 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>> On 4/21/21 9:59 PM, Marc Zyngier wrote:
>>> On Wed, 21 Apr 2021 07:17:44 +0100,
>>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>> On 2021/4/21 14:20, Gavin Shan wrote:
>>>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
>>>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
>>>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
>>>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
>>>>>>> in vma->flags and if set then marks force_pte to true such that
>>>>>>> if force_pte is true then ignore the THP function check
>>>>>>> (/transparent_hugepage_adjust()).
>>>>>>>
>>>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
>>>>>>> For example consider a case where the mdev vendor driver register's
>>>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
>>>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
>>>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>>>>>>> the VM_PFNMAP flag into vma->flags.
>>>>>> Could you give the name of the mdev vendor driver that triggers this issue?
>>>>>> I failed to find one according to your description. Thanks.
>>>>>>
>>>>>
>>>>> I think it would be fixed in driver side to set VM_PFNMAP in
>>>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
>>>>> It means it won't be delayed until page fault is issued and
>>>>> remap_pfn_range() is called. It's determined from the beginning
>>>>> that the vma associated the mdev vendor driver is serving as
>>>>> PFN remapping purpose. So the vma should be populated completely,
>>>>> including the VM_PFNMAP flag before it becomes visible to user
>>>>> space.
>>>
>>> Why should that be a requirement? Lazy populating of the VMA should be
>>> perfectly acceptable if the fault can only happen on the CPU side.
>>>
>>
>> It isn't a requirement and the drivers needn't follow strictly. I checked
>> several drivers before looking into the patch and found almost all the
>> drivers have VM_PFNMAP set at mmap() time. In drivers/vfio/vfio-pci.c,
>> there is a comment as below, but it doesn't reveal too much about why
>> we can't set VM_PFNMAP at fault time.
>>
>> static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>> {
>>        :
>>          /*
>>           * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>>           * change vm_flags within the fault handler.  Set them now.
>>           */
>>          vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
>>          vma->vm_ops = &vfio_pci_mmap_ops;
>>
>>          return 0;
>> }
>>
>> To set these flags in advance does have advantages. For example,
>> VM_DONTEXPAND prevents the vma to be merged with another
>> one. VM_DONTDUMP make this vma isn't eligible for
>> coredump. Otherwise, the address space, which is associated with the
>> vma is accessed and unnecessary page faults are triggered on
>> coredump.  VM_IO and VM_PFNMAP avoids to walk the page frames
>> associated with the vma since we don't have valid PFN in the
>> mapping.
> 
> But PCI clearly isn't the case we are dealing with here, and not
> everything is VFIO either. I can *today* create a driver that
> implements a mmap+fault handler, call mmap() on it, pass the result to
> a memslot, and get to the exact same result Santosh describes.
> 
> No PCI, no VFIO, just a random driver. We are *required* to handle
> that.
> 

hmm, ok. I was thinking it's related to VFIO mdev driver when Santosh was
talking about "mdev driver". Anyway, it's always nice to support the case :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
