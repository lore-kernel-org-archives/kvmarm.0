Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FE2C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 07:44:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C797520674
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 07:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C797520674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE944B30B;
	Mon, 13 Jul 2020 03:44:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aYSomaUf5bxl; Mon, 13 Jul 2020 03:44:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19C5B4B2F9;
	Mon, 13 Jul 2020 03:44:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA6D4B285
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Jul 2020 23:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L5whY5N6iYFG for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Jul 2020 23:07:29 -0400 (EDT)
Received: from out30-131.freemail.mail.aliyun.com
 (out30-131.freemail.mail.aliyun.com [115.124.30.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 993714B274
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Jul 2020 23:07:27 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01355;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0U2UhFSb_1594609639; 
Received: from 30.25.206.74(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0U2UhFSb_1594609639) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 13 Jul 2020 11:07:21 +0800
Subject: Re: [PATCH v4 5/7] KVM: PPC: clean up redundant kvm_run parameters in
 assembly
To: Paul Mackerras <paulus@ozlabs.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
 <20200526055924.GD282305@thinks.paulus.ozlabs.org>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <c3540a4b-a568-3428-0427-ae2a1f30dbe2@linux.alibaba.com>
Date: Mon, 13 Jul 2020 11:07:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200526055924.GD282305@thinks.paulus.ozlabs.org>
X-Mailman-Approved-At: Mon, 13 Jul 2020 03:44:07 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, hpa@zytor.com, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, frankja@linux.ibm.com, chenhuacai@gmail.com,
 maz@kernel.org, joro@8bytes.org, x86@kernel.org, borntraeger@de.ibm.com,
 mingo@redhat.com, thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org,
 bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
 jmattson@google.com, tsbogend@alpha.franken.de, cohuck@redhat.com,
 sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org,
 mpe@ellerman.id.au, pbonzini@redhat.com, vkuznets@redhat.com,
 linuxppc-dev@lists.ozlabs.org
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



On 2020/5/26 13:59, Paul Mackerras wrote:
> On Mon, Apr 27, 2020 at 12:35:12PM +0800, Tianjia Zhang wrote:
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
> 
> Some of these changes don't look completely correct to me, see below.
> If you're expecting these patches to go through my tree, I can fix up
> the patch and commit it (with you as author), noting the changes I
> made in the commit message.  Do you want me to do that?
> 

I am very glad for you to do so, although I have submitted a new version 
of patch, I still prefer you to fix up and commit it.

Thanks and best,
Tianjia

>> diff --git a/arch/powerpc/kvm/book3s_interrupts.S b/arch/powerpc/kvm/book3s_interrupts.S
>> index f7ad99d972ce..0eff749d8027 100644
>> --- a/arch/powerpc/kvm/book3s_interrupts.S
>> +++ b/arch/powerpc/kvm/book3s_interrupts.S
>> @@ -55,8 +55,7 @@
>>    ****************************************************************************/
>>   
>>   /* Registers:
>> - *  r3: kvm_run pointer
>> - *  r4: vcpu pointer
>> + *  r3: vcpu pointer
>>    */
>>   _GLOBAL(__kvmppc_vcpu_run)
>>   
>> @@ -68,8 +67,8 @@ kvm_start_entry:
>>   	/* Save host state to the stack */
>>   	PPC_STLU r1, -SWITCH_FRAME_SIZE(r1)
>>   
>> -	/* Save r3 (kvm_run) and r4 (vcpu) */
>> -	SAVE_2GPRS(3, r1)
>> +	/* Save r3 (vcpu) */
>> +	SAVE_GPR(3, r1)
>>   
>>   	/* Save non-volatile registers (r14 - r31) */
>>   	SAVE_NVGPRS(r1)
>> @@ -82,11 +81,11 @@ kvm_start_entry:
>>   	PPC_STL	r0, _LINK(r1)
>>   
>>   	/* Load non-volatile guest state from the vcpu */
>> -	VCPU_LOAD_NVGPRS(r4)
>> +	VCPU_LOAD_NVGPRS(r3)
>>   
>>   kvm_start_lightweight:
>>   	/* Copy registers into shadow vcpu so we can access them in real mode */
>> -	mr	r3, r4
>> +	mr	r4, r3
> 
> This mr doesn't seem necessary.
> 
>>   	bl	FUNC(kvmppc_copy_to_svcpu)
>>   	nop
>>   	REST_GPR(4, r1)
> 
> This should be loading r4 from GPR3(r1), not GPR4(r1) - which is what
> REST_GPR(4, r1) will do.
> 
> Then, in the file but not in the patch context, there is this line:
> 
> 	PPC_LL	r3, GPR4(r1)		/* vcpu pointer */
> 
> where once again GPR4 needs to be GPR3.
> 
>> @@ -191,10 +190,10 @@ after_sprg3_load:
>>   	PPC_STL	r31, VCPU_GPR(R31)(r7)
>>   
>>   	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */
> 
> The comment should be modified to say "2nd" instead of "3rd",
> otherwise it is confusing.
> 
> The rest of the patch looks OK.
> 
> Paul.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
