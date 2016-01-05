From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v6 1/6] arm/arm64: KVM: Introduce armv7 fp/simd vcpu fields
 and helpers
Date: Tue, 05 Jan 2016 11:28:18 -0800
Message-ID: <568C1952.3050002@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
 <1451166900-3711-2-git-send-email-m.smarduch@samsung.com>
 <20160105150040.GF28354@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E51498C2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2016 14:24:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SWF3shTeCpBk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2016 14:24:44 -0500 (EST)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EF00498B8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2016 14:24:43 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0O0H007CQVF8WJ40@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 05 Jan 2016 14:28:20 -0500 (EST)
In-reply-to: <20160105150040.GF28354@cbox>
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



On 1/5/2016 7:00 AM, Christoffer Dall wrote:
> On Sat, Dec 26, 2015 at 01:54:55PM -0800, Mario Smarduch wrote:
>> Add helper functions to enable access to fp/smid on guest entry and save host
>> fpexc on vcpu put, check if fp/simd registers are dirty and add new vcpu
>> fields.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/include/asm/kvm_emulate.h   | 42 ++++++++++++++++++++++++++++++++++++
>>  arch/arm/include/asm/kvm_host.h      |  6 ++++++
>>  arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
>>  3 files changed, 56 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
>> index 3095df0..d4d9da1 100644
>> --- a/arch/arm/include/asm/kvm_emulate.h
>> +++ b/arch/arm/include/asm/kvm_emulate.h
>> @@ -24,6 +24,8 @@
>>  #include <asm/kvm_mmio.h>
>>  #include <asm/kvm_arm.h>
>>  #include <asm/cputype.h>
>> +#include <asm/vfp.h>
>> +#include "../vfp/vfpinstr.h"
> 
> this looks dodgy...
> 
> can you move vfpinstr.h instead?
Sure I'll fix it up, it's in couple other places in kernel and kvm
 - copied it.
> 
>>  
>>  unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
>>  unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
>> @@ -255,4 +257,44 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>  	}
>>  }
>>  
>> +#ifdef CONFIG_VFPv3
>> +/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
> 
> the comment is misleading, you're not enabling guest access to the
> fp/simd unit, you're just setting the enabled bit to ensure guest
> accesses trap.

That's more accurate.
> 
>> +static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 fpexc;
>> +
>> +	/* Save host fpexc, and enable guest access to fp unit */
>> +	fpexc = fmrx(FPEXC);
>> +	vcpu->arch.host_fpexc = fpexc;
>> +	fpexc |= FPEXC_EN;
>> +	fmxr(FPEXC, fpexc);
>> +
>> +	/* Configure HCPTR to trap on tracing and fp/simd access */
>> +	vcpu->arch.hcptr = HCPTR_TTA | HCPTR_TCP(10)  | HCPTR_TCP(11);
>> +}
>> +
>> +/* Called from vcpu_put - restore host fpexc */
> 
> I would probably get rid of the "Called from" stuff and just describe
> what these functions do locally.  Comments like this are likely to be
> out of date soon'ish.

Yeah true, will do.
> 
>> +static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu)
>> +{
>> +	fmxr(FPEXC, vcpu->arch.host_fpexc);
>> +}
>> +
>> +/* If trap bits are reset then fp/simd registers are dirty */
>> +static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return !(vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
>> +}
>> +#else
>> +static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.hcptr = HCPTR_TTA;
>> +}
>> +
>> +static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
>> +static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +#endif
> 
> this kind of feels like it belongs in its own C-file instead of a header
> file, perhaps arch/arm/kvm/vfp.C.
> 
> Marc, what do you think?
> 

That would be starting from vcpu_trap_vfp_enable()? The file is getting
little overloaded.

I'm also thinking that 3rd patch should have one function call for vcpu_put
like vcpu_load does instead of exposing arm32/arm64, arm32 only relevant logic.
When you have a chance to review that patch please keep that in mind.

>> +
>>  #endif /* __ARM_KVM_EMULATE_H__ */
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index f9f2779..d3ef58a 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -105,6 +105,12 @@ struct kvm_vcpu_arch {
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
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 3066328..ffe8ccf 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -299,4 +299,12 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>  	return data;		/* Leave LE untouched */
>>  }
>>  
>> +static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu) {}
>> +static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
>> +
>> +static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> -- 
>> 1.9.1
>>
> 
> Thanks,
> -Christoffer
> 
