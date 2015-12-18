From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v5 1/3] KVM/arm: add hooks for armv7 fp/simd lazy switch
 support
Date: Fri, 18 Dec 2015 14:27:42 -0800
Message-ID: <5674885E.4080300@samsung.com>
References: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
 <1449450434-2929-2-git-send-email-m.smarduch@samsung.com>
 <20151218130741.GF32720@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 265C949444
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 17:25:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5C8CRfmZM5X for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2015 17:25:28 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C33441390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 17:25:27 -0500 (EST)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZK008Q4RQKDH80@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 18 Dec 2015 17:27:56 -0500 (EST)
In-reply-to: <20151218130741.GF32720@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/18/2015 5:07 AM, Christoffer Dall wrote:
> On Sun, Dec 06, 2015 at 05:07:12PM -0800, Mario Smarduch wrote:
>> This patch adds vcpu fields to configure hcptr trap register which is also used 
>> to determine if fp/simd registers are dirty. Adds a field to save host FPEXC, 
>> and offsets associated offsets.
> 
> offsets offsets?
Should be 'with vcpu fields'
> 
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h | 6 ++++++
>>  arch/arm/kernel/asm-offsets.c   | 2 ++
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 3df1e97..09bb1f2 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -104,6 +104,12 @@ struct kvm_vcpu_arch {
>>  	/* HYP trapping configuration */
>>  	u32 hcr;
>>  
>> +	/* HYP Co-processor fp/simd and trace trapping configuration */
>> +	u32 hcptr;
>> +
>> +	/* Save host FPEXC register to later restore on vcpu put */
>> +	u32 host_fpexc;
>> +
>>  	/* Interrupt related fields */
>>  	u32 irq_lines;		/* IRQ and FIQ levels */
>>  
>> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
>> index 871b826..28ebd4c 100644
>> --- a/arch/arm/kernel/asm-offsets.c
>> +++ b/arch/arm/kernel/asm-offsets.c
>> @@ -185,6 +185,8 @@ int main(void)
>>    DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_pc));
>>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
>>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>> +  DEFINE(VCPU_HCPTR,		offsetof(struct kvm_vcpu, arch.hcptr));
>> +  DEFINE(VCPU_VFP_HOST_FPEXC,	offsetof(struct kvm_vcpu, arch.host_fpexc));
> 
> this makes me think this needs a good rebase on world-switch in C, which
> is now in kvmarm/next...
Ok, definitely.
> 
>>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
>>    DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
> 
> this patch is hard to review on its own as I don't see how this is used,
> but ok...
Sure, I'll combine it.
> 
>> -- 
>> 1.9.1
>>
> 
