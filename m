Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDD9C55194
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 12:02:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DD9520781
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 12:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DD9520781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBD9C4B18A;
	Thu, 23 Apr 2020 08:02:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j4++cROHAFlZ; Thu, 23 Apr 2020 08:02:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 793964B199;
	Thu, 23 Apr 2020 08:02:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F724B12F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 06:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tgiyI4Hs7l79 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 06:59:02 -0400 (EDT)
Received: from out30-131.freemail.mail.aliyun.com
 (out30-131.freemail.mail.aliyun.com [115.124.30.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B91C14B12E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 06:59:01 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R741e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01f04427;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=36; SR=0;
 TI=SMTPD_---0TwQ1hHs_1587639532; 
Received: from 30.27.118.66(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TwQ1hHs_1587639532) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 23 Apr 2020 18:58:54 +0800
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To: Cornelia Huck <cohuck@redhat.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
 <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
 <20200422180403.03f60b0c.cohuck@redhat.com>
 <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
 <20200423123901.72a4c6a4.cohuck@redhat.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <71344f73-c34f-a373-49d1-5d839c6be5f6@linux.alibaba.com>
Date: Thu, 23 Apr 2020 18:58:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423123901.72a4c6a4.cohuck@redhat.com>
X-Mailman-Approved-At: Thu, 23 Apr 2020 08:02:30 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, maz@kernel.org, joro@8bytes.org, x86@kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, mingo@redhat.com,
 thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, sean.j.christopherson@intel.com,
 linux-kernel@vger.kernel.org, mpe@ellerman.id.au, pbonzini@redhat.com,
 vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
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



On 2020/4/23 18:39, Cornelia Huck wrote:
> On Thu, 23 Apr 2020 11:01:43 +0800
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> 
>> On 2020/4/23 0:04, Cornelia Huck wrote:
>>> On Wed, 22 Apr 2020 17:58:04 +0200
>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>    
>>>> On 22.04.20 15:45, Cornelia Huck wrote:
>>>>> On Wed, 22 Apr 2020 20:58:04 +0800
>>>>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
>>>>>       
>>>>>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>>>>>> structure. Earlier than historical reasons, many kvm-related function
>>>>>
>>>>> s/Earlier than/For/ ?
>>>>>       
>>>>>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
>>>>>> This patch does a unified cleanup of these remaining redundant parameters.
>>>>>>
>>>>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>>>>> ---
>>>>>>    arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
>>>>>>    1 file changed, 22 insertions(+), 15 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>> index e335a7e5ead7..d7bb2e7a07ff 100644
>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>>>>    	return rc;
>>>>>>    }
>>>>>>    
>>>>>> -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>>>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>>>>>    {
>>>>>> +	struct kvm_run *kvm_run = vcpu->run;
>>>>>>    	struct runtime_instr_cb *riccb;
>>>>>>    	struct gs_cb *gscb;
>>>>>>    
>>>>>> @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>>>>    		}
>>>>>>    		if (vcpu->arch.gs_enabled) {
>>>>>>    			current->thread.gs_cb = (struct gs_cb *)
>>>>>> -						&vcpu->run->s.regs.gscb;
>>>>>> +						&kvm_run->s.regs.gscb;
>>>>>
>>>>> Not sure if these changes (vcpu->run-> => kvm_run->) are really worth
>>>>> it. (It seems they amount to at least as much as the changes advertised
>>>>> in the patch description.)
>>>>>
>>>>> Other opinions?
>>>>
>>>> Agreed. It feels kind of random. Maybe just do the first line (move kvm_run from the
>>>> function parameter list into the variable declaration)? Not sure if this is better.
>>>>   
>>>
>>> There's more in this patch that I cut... but I think just moving
>>> kvm_run from the parameter list would be much less disruptive.
>>>    
>>
>> I think there are two kinds of code(`vcpu->run->` and `kvm_run->`), but
>> there will be more disruptive, not less.
> 
> I just fail to see the benefit; sure, kvm_run-> is convenient, but the
> current code is just fine, and any rework should be balanced against
> the cost (e.g. cluttering git annotate).
> 

cluttering git annotate ? Does it mean Fix xxxx ("comment"). Is it 
possible to solve this problem by splitting this patch?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
