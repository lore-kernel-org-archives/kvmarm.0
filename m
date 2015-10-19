From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v2 1/2] KVM/arm: add hooks for armv7 fp/simd lazy switch
 support
Date: Mon, 19 Oct 2015 16:16:53 -0700
Message-ID: <562579E5.6040008@samsung.com>
References: <1443311009-4811-1-git-send-email-m.smarduch@samsung.com>
 <1443311009-4811-2-git-send-email-m.smarduch@samsung.com>
 <20151019085332.GA24104@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D06412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 19:14:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7XwCVdq83oB1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2015 19:14:24 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B544A40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 19:14:24 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWH00KVLQ06VY40@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 19 Oct 2015 19:16:54 -0400 (EDT)
In-reply-to: <20151019085332.GA24104@cbox>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/19/2015 1:53 AM, Christoffer Dall wrote:
> On Sat, Sep 26, 2015 at 04:43:28PM -0700, Mario Smarduch wrote:
>> This patch adds vcpu fields to track lazy state, save host FPEXC, and 
>> offsets to fields.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h | 6 ++++++
>>  arch/arm/kernel/asm-offsets.c   | 2 ++
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index dcba0fa..194a8ef 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -111,6 +111,12 @@ struct kvm_vcpu_arch {
>>  	/* Interrupt related fields */
>>  	u32 irq_lines;		/* IRQ and FIQ levels */
>>  
>> +	/* Track fp/simd lazy switch state */
>> +	u32 vfp_lazy;
> 
> so is this a flags field or basically a boolean?  If the latter, what is
> does it mean when the field is true vs. false?
Yes it's a bool will update, and clarify comments.
> 
>> +
>> +	/* Save host FPEXC register to restore on vcpu put */
>> +	u32 saved_fpexc;
> 
> is this only the host's state?  If so, why not name it host_fpexc?
That's right itis host state, will change.
> 
> Thanks,
> -Christoffer
> 
>> +
>>  	/* Exception Information */
>>  	struct kvm_vcpu_fault_info fault;
>>  
>> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
>> index 871b826..e1c3a41 100644
>> --- a/arch/arm/kernel/asm-offsets.c
>> +++ b/arch/arm/kernel/asm-offsets.c
>> @@ -186,6 +186,8 @@ int main(void)
>>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
>>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>> +  DEFINE(VCPU_VFP_LAZY,		offsetof(struct kvm_vcpu, arch.vfp_lazy));
>> +  DEFINE(VCPU_VFP_FPEXC,	offsetof(struct kvm_vcpu, arch.saved_fpexc));
>>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
>>    DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
>>    DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
>> -- 
>> 1.9.1
>>
