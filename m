Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7544DC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:22:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A0A1208E4
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A0A1208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A6A4B4D7;
	Fri, 31 Jul 2020 04:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2j0VHAtbL1qK; Fri, 31 Jul 2020 04:21:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C6264B4CF;
	Fri, 31 Jul 2020 04:21:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7364B3F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W9QsLqskpc+1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 04:21:56 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B003A4B3E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:21:53 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id C5B815532107EB983132;
 Fri, 31 Jul 2020 16:21:48 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0;
 Fri, 31 Jul 2020 16:21:41 +0800
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To: Paolo Bonzini <pbonzini@redhat.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
 <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
 <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
From: Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <18baa777-7f28-8f57-e815-11175bf4c59a@huawei.com>
Date: Fri, 31 Jul 2020 16:21:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Cc: gleb@redhat.com, kvm@vger.kernel.org, "S. Tsirkin,
 Michael" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020/7/31 14:44, Paolo Bonzini wrote:
> On 31/07/20 08:39, Zhenyu Ye wrote:
>> On 2020/7/31 2:03, Paolo Bonzini wrote:
>>> Yes, I think it's not needed. Probably the deassign check can be turned into an assertion?
>>>
>>> Paolo
>>>
>>
>> I think we can do this in the same function, and turnt he check of
>> p->eventfd into assertion in kvm_deassign_ioeventfd_idx(). Just like:
>>
>> ---8<---
>> static inline struct _ioeventfd *
>> get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
>>               struct kvm_ioeventfd *args)
>> {
>>         static struct _ioeventfd *_p;
>>         bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
>>
>>         list_for_each_entry(_p, &kvm->ioeventfds, list)
>>                 if (_p->bus_idx == bus_idx &&
>>                     _p->addr == args->addr &&
>>                     (!_p->length || !args->len ||
>>                      (_p->length == args->len &&
>>                       (_p->wildcard || wildcard ||
>>                        _p->datamatch == args->datamatch))))
>>                         return _p;
>>
>>         return NULL;
>> }
>>
>> kvm_deassign_ioeventfd_idx() {
>> 	...
>> 	p = get_ioeventfd(kvm, bus_idx, args);
>> 	if (p) {
>> 		assert(p->eventfd == eventfd);
>> 		...
>> 	}
>>
>> ---8<----
>>
>> This may be easier to understand (keep the same logic in assign/deassign).
> 
> I think you should also warn if:
> 
> 1) p->length != args->len
>
> 2) p->wildcard != args->wildcard if p->length
>
> 3) p->datamatch != args->datamatch if p->length && !p->wildcard
> 
> but yeah it sounds like a plan.
> 

I will try to do this. :)

Zhenyu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
