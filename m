Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B7FC2BAEE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 01:45:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2887520739
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 01:45:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2887520739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 125644A576;
	Wed, 11 Mar 2020 21:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G8O89TXSYlQ7; Wed, 11 Mar 2020 21:45:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36014A50F;
	Wed, 11 Mar 2020 21:45:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5521F4A389
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 21:45:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YCrUxT4WB0GC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 21:45:39 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9850B40456
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 21:45:39 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 9DD712E01B64EC9C1957;
 Thu, 12 Mar 2020 09:45:36 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0;
 Thu, 12 Mar 2020 09:45:26 +0800
Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
To: "Zhoujian (jay)" <jianjay.zhou@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
 <4b85699ec1d354cc73f5302560231f86@misterjones.org>
 <64925c8b-af3d-beb5-bc9b-66ef1e47f92d@huawei.com>
 <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
 <9ddefc54-dd5b-0555-0aaa-00a3a23febcf@huawei.com>
 <B2D15215269B544CADD246097EACE7474BB64495@DGGEMM528-MBX.china.huawei.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <3238d495-8c13-4fbb-8e3d-c34e560ec9af@huawei.com>
Date: Thu, 12 Mar 2020 09:45:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB64495@DGGEMM528-MBX.china.huawei.com>
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: "Huangweidong \(C\)" <weidong.huang@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "wangxin \(U\)" <wangxinxin.wang@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Hi Jay,

On 2020/3/11 15:34, Zhoujian (jay) wrote:
> 
> 
>> -----Original Message-----
>> From: zhukeqian
>> Sent: Wednesday, March 11, 2020 3:20 PM
>> To: Marc Zyngier <maz@kernel.org>
>> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Zhoujian (jay)
>> <jianjay.zhou@huawei.com>; Sean Christopherson
>> <sean.j.christopherson@intel.com>; Paolo Bonzini <pbonzini@redhat.com>;
>> James Morse <james.morse@arm.com>; Julien Thierry
>> <julien.thierry.kdev@gmail.com>; Suzuki K Poulose <suzuki.poulose@arm.com>
>> Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small chunks
>>
>> Hi Marc,
>>
>> On 2020/3/10 21:16, Marc Zyngier wrote:
>>> On 2020-03-10 08:26, zhukeqian wrote:
>>>> Hi Marc,
>>>>
>>>> On 2020/3/9 19:45, Marc Zyngier wrote:
>>>>> Kegian,
>>>
>>> [...]
>>>
>>>>> Is there a userspace counterpart to it?
>>>>>
>>>> As this KVM/x86 related changes have not been merged to mainline
>>>> kernel, some little modification is needed on mainline Qemu.
>>>
>>> Could you please point me to these changes?
>> I made some changes locally listed below.
>>
>> However, Qemu can choose to enable KVM_DIRTY_LOG_INITIALLY_SET or not.
>> Here I made no judgement on dirty_log_manual_caps because I just want to
>> verify the optimization of this patch.
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
>> 439a4efe52..1611f644a4 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2007,14 +2007,16 @@ static int kvm_init(MachineState *ms)
>>      s->coalesced_pio = s->coalesced_mmio &&
>>                         kvm_check_extension(s,
>> KVM_CAP_COALESCED_PIO);
>>
>> -    s->manual_dirty_log_protect =
>> +    uint64_t dirty_log_manual_caps =
>>          kvm_check_extension(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
>> -    if (s->manual_dirty_log_protect) {
>> -        ret = kvm_vm_enable_cap(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
>> +    if (dirty_log_manual_caps) {
>> +        ret = kvm_vm_enable_cap(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
>> +                                dirty_log_manual_caps);
>>          if (ret) {
>>              warn_report("Trying to enable
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
>>                          "but failed.  Falling back to the legacy mode. ");
>> -            s->manual_dirty_log_protect = false;
>> +        } else {
>> +            s->manual_dirty_log_protect = true;
>>          }
>>      }
> 
> FYI: I had submitted a patch to the Qemu community some days ago:
> https://patchwork.kernel.org/patch/11419191/
This is very helpful, thanks.
> 
>>>
>>>> As I tested this patch on a 128GB RAM Linux VM with no huge pages,
>>>> the time of enabling dirty log will decrease obviously.
>>>
>>> I'm not sure how realistic that is. Not having huge pages tends to
>>> lead to pretty bad performance in general...
>> Sure, this has no effect on guests which are all of huge pages.
>>
>> For my understanding, once a guest has normal pages (maybe are initialized at
>> beginning or dissloved from huge pages), it can benefit from this patch.
> 
> Yes, I agree.
> 
I will send PATCH v1 soon.
> 
> 
> Regards,
> Jay Zhou
> 
> .
>
Thanks,
Keqian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
