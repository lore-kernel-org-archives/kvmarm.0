Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367A2C2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8ADC420784
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ADC420784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210864B1E2;
	Wed, 15 Apr 2020 05:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BWGze0-mDuEM; Wed, 15 Apr 2020 05:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2297B4B211;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA9F4B16B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 22:19:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P-Qs2s7+MShc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 22:19:16 -0400 (EDT)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0444F4B165
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 22:19:15 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=19; SR=0;
 TI=SMTPD_---0TvZsw-x_1586917144; 
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TvZsw-x_1586917144) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 15 Apr 2020 10:19:05 +0800
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To: Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
Date: Wed, 15 Apr 2020 10:19:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <875ze2ywhy.fsf@vitty.brq.redhat.com>
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, maz@kernel.org, joro@8bytes.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 mingo@redhat.com, bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
 tglx@linutronix.de, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com
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



On 2020/4/14 22:26, Vitaly Kuznetsov wrote:
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
> 
>> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
>> where vcpu->run is the kvm_run parameter, so it has been replaced.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++++----
>>   virt/kvm/arm/arm.c | 2 +-
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3bf2ecafd027..70e3f4abbd4d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   		r = -EAGAIN;
>>   		if (signal_pending(current)) {
>>   			r = -EINTR;
>> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +			kvm_run->exit_reason = KVM_EXIT_INTR;
> 
> I have a more generic question: why do we need to pass 'kvm_run' to
> kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
> The only call site looks like
> 
> virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
> 

In the earlier version, kvm_run is used to pass parameters with user 
mode and is not included in the vcpu structure, so it has been retained 
until now.

Thanks,
Tianjia

>>   			++vcpu->stat.signal_exits;
>>   		}
>>   		goto out;
>>   	}
>>   
>> -	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>>   		r = -EINVAL;
>>   		goto out;
>>   	}
>>   
>> -	if (vcpu->run->kvm_dirty_regs) {
>> +	if (kvm_run->kvm_dirty_regs) {
>>   		r = sync_regs(vcpu);
>>   		if (r != 0)
>>   			goto out;
>> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   
>>   out:
>>   	kvm_put_guest_fpu(vcpu);
>> -	if (vcpu->run->kvm_valid_regs)
>> +	if (kvm_run->kvm_valid_regs)
>>   		store_regs(vcpu);
>>   	post_kvm_run_save(vcpu);
>>   	kvm_sigset_deactivate(vcpu);
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 48d0ec44ad77..ab9d7966a4c8 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		return ret;
>>   
>>   	if (run->exit_reason == KVM_EXIT_MMIO) {
>> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>> +		ret = kvm_handle_mmio_return(vcpu, run);
>>   		if (ret)
>>   			return ret;
>>   	}
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
