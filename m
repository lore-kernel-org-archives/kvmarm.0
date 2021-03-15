Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0292C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:56:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD6E664E99
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD6E664E99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E18B4B50B;
	Mon, 15 Mar 2021 05:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dK9uhEwHAivF; Mon, 15 Mar 2021 05:56:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 488B84B510;
	Mon, 15 Mar 2021 05:56:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D15D4B50B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:56:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dJV1lsRhs7hx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:56:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 538954B508
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:56:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615802187;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=s663/ZH1yFhPEvrM19sba3u1Bf1Jh6lElfvXAN6LRbo=;
 b=Ji1OXAupjzuMpLt+rf6w0TqLpRpQCt4GQ5CM1veuYrcLPJ2VMq2Ox2onMyjjGg2G/XQLqE
 uMHby+yK1oywmmeZz56xgIpTZCh2fRAVi+uGlAVggM/9RmxX+KY/amAYNqb4y64h30Ox89
 kGFCK+Fv3vYhY9Ex6BeKgoFiF5XDzIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-hK3KDtw3MVGNr9lOM4Ywsw-1; Mon, 15 Mar 2021 05:56:25 -0400
X-MC-Unique: hK3KDtw3MVGNr9lOM4Ywsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A57E802B45;
 Mon, 15 Mar 2021 09:56:23 +0000 (UTC)
Received: from [10.64.54.175] (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CDF1B100239A;
 Mon, 15 Mar 2021 09:56:20 +0000 (UTC)
Subject: Re: [PATCH 4/4] KVM: arm64: Don't retrieve memory slot again in page
 fault handler
To: Keqian Zhu <zhukeqian1@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-5-gshan@redhat.com>
 <30073114-339f-33dd-0168-b4d6bfbe88bc@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <7a29ac43-ef11-e990-e08c-c5e97ea7d78d@redhat.com>
Date: Mon, 15 Mar 2021 20:56:17 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <30073114-339f-33dd-0168-b4d6bfbe88bc@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

Hi Keqian,

On 3/15/21 7:25 PM, Keqian Zhu wrote:
> On 2021/3/15 12:18, Gavin Shan wrote:
>> We needn't retrieve the memory slot again in user_mem_abort() because
>> the corresponding memory slot has been passed from the caller. This
> I think you are right, though fault_ipa will be adjusted when we try to use block mapping,
> the fault_supports_stage2_huge_mapping() makes sure we're not trying to map anything
> not covered by the memslot, so the adjusted fault_ipa still belongs to the memslot.
> 

Yeah, it's correct. Besides, the @logging_active is determined
based on the passed memory slot. It means user_mem_abort() can't
support memory range which spans multiple memory slot.

>> would save some CPU cycles. For example, the time used to write 1GB
>> memory, which is backed by 2MB hugetlb pages and write-protected, is
>> dropped by 6.8% from 928ms to 864ms.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index a5a8ade9fde4..4a4abcccfafb 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -846,7 +846,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	 */
>>   	smp_rmb();
>>   
>> -	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>> +	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
>> +				   write_fault, &writable, NULL);
> It's better to update the code comments at same time.
> 

I guess you need some comments here? If so, I would add something
like below in v2:

	/*
	 * gfn_to_pfn_prot() can be used either with unnecessary overhead
	 * introduced to locate the memory slot because the memory slot is
	 * always fixed even @gfn is adjusted for huge pages.
	 */

>>   	if (pfn == KVM_PFN_ERR_HWPOISON) {
>>   		kvm_send_hwpoison_signal(hva, vma_shift);
>>   		return 0;
>> @@ -912,7 +913,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	/* Mark the page dirty only if the fault is handled successfully */
>>   	if (writable && !ret) {
>>   		kvm_set_pfn_dirty(pfn);
>> -		mark_page_dirty(kvm, gfn);
>> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
>>   	}
>>   
>>   out_unlock:
>>

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
