From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v6 1/6] arm/arm64: KVM: Introduce armv7 fp/simd vcpu fields
 and helpers
Date: Mon, 11 Jan 2016 15:39:21 -0800
Message-ID: <56943D29.3000002@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
 <1451166900-3711-2-git-send-email-m.smarduch@samsung.com>
 <20160110163204.GD30867@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE3E49ADB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2016 18:35:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P07M9zJIUFx2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2016 18:35:23 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6136049A9E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2016 18:35:22 -0500 (EST)
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0O0T00FJKB1MNV30@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 11 Jan 2016 18:39:22 -0500 (EST)
In-reply-to: <20160110163204.GD30867@cbox>
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



On 1/10/2016 8:32 AM, Christoffer Dall wrote:
> Hi Mario,
> 
> I spotted one more potential issue...
> 
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
>>  
>>  unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
>>  unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
>> @@ -255,4 +257,44 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>  	}
>>  }
>>  
>> +#ifdef CONFIG_VFPv3
>> +/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
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
> 
> Is it correct not to trap VFP registers when the host kernel does not
> have CONFIG_VFPv3?  I think this is a change in functionality compared
> to the current kernels is it not?

With CPU_V7 VFPv3 gets selected, without it fp should be emulated,
with exceptions taken in guest kernel. I don't see a reason why
fp hcptr access should be enabled in that case.

> 
> Thanks,
> -Christoffer
> 
