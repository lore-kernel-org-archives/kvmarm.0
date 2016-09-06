From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 5/7] ARM: move system register accessors to asm/cp15.h
Date: Tue, 6 Sep 2016 14:05:30 +0100
Message-ID: <57CEBF1A.60506@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-6-git-send-email-vladimir.murzin@arm.com>
 <20160905112916.GJ26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ECFF49B4C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:57:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 98pGKcc7v9zV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:57:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBCA540B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:57:08 -0400 (EDT)
In-Reply-To: <20160905112916.GJ26366@cbox>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/16 12:29, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 11:46:56AM +0100, Vladimir Murzin wrote:
>> Macro __ACCESS_CP15{_64} is defined in two headers (arch_gicv3.h and
>> kvm_hyp.h) which are going to be requested by vgic-v3 altogether.
>> GCC would not like it because it'd see that macro is redefined and (hey!)
>> they are different.  So, let's put only single macro version under common
>> place and use it everywhere.
> 
> I'm sorry, but I don't understand this commit text.
> 

Sorry for that :(

The issue the patch is trying to solve happens because
virt/kvm/arm/hyp/vgic-v3-sr.c has

#include <linux/irqchip/arm-gic-v3.h>
...
#include <asm/kvm_hyp.h>

each of these headers defines it's own __ACCESS_CP15 macro:

asm/kvm_hyp.h

#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32

and linux/irqchip/arm-gic-v3.h via asm/arch_gicv3.h

#define __ACCESS_CP15(CRn, Op1, CRm, Op2) p15, Op1, %0, CRn, CRm, Op2

When these headers are used together conflict happens. The same applies
to __ACCESS_CP15_64 macro.

To address that only single set of macros is used and call sites updated.

>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  arch/arm/include/asm/arch_gicv3.h |   27 +++++++++++----------------
>>  arch/arm/include/asm/cp15.h       |   15 +++++++++++++++
>>  arch/arm/include/asm/kvm_hyp.h    |   15 +--------------
>>  3 files changed, 27 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
>> index e08d151..af25c32 100644
>> --- a/arch/arm/include/asm/arch_gicv3.h
>> +++ b/arch/arm/include/asm/arch_gicv3.h
>> @@ -22,9 +22,7 @@
>>  
>>  #include <linux/io.h>
>>  #include <asm/barrier.h>
>> -
>> -#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
>> -#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
>> +#include <asm/cp15.h>
>>  
>>  #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
>>  #define ICC_DIR				__ACCESS_CP15(c12, 0, c11, 1)
>> @@ -102,58 +100,55 @@
>>  
>>  static inline void gic_write_eoir(u32 irq)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
>> +	write_sysreg(irq, ICC_EOIR1);
>>  	isb();
>>  }
>>  
>>  static inline void gic_write_dir(u32 val)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_DIR) : : "r" (val));
>> +	write_sysreg(val, ICC_DIR);
>>  	isb();
>>  }
>>  
>>  static inline u32 gic_read_iar(void)
>>  {
>> -	u32 irqstat;
>> +	u32 irqstat = read_sysreg(ICC_IAR1);
>>  
>> -	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
>>  	dsb(sy);
>> +
>>  	return irqstat;
>>  }
>>  
>>  static inline void gic_write_pmr(u32 val)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
>> +	write_sysreg(val, ICC_PMR);
>>  }
>>  
>>  static inline void gic_write_ctlr(u32 val)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_CTLR) : : "r" (val));
>> +	write_sysreg(val, ICC_CTLR);
>>  	isb();
>>  }
>>  
>>  static inline void gic_write_grpen1(u32 val)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_IGRPEN1) : : "r" (val));
>> +	write_sysreg(val, ICC_IGRPEN1);
>>  	isb();
>>  }
>>  
>>  static inline void gic_write_sgi1r(u64 val)
>>  {
>> -	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
>> +	write_sysreg(val, ICC_SGI1R);
>>  }
>>  
>>  static inline u32 gic_read_sre(void)
>>  {
>> -	u32 val;
>> -
>> -	asm volatile("mrc " __stringify(ICC_SRE) : "=r" (val));
>> -	return val;
>> +	return read_sysreg(ICC_SRE);
>>  }
>>  
>>  static inline void gic_write_sre(u32 val)
>>  {
>> -	asm volatile("mcr " __stringify(ICC_SRE) : : "r" (val));
>> +	write_sysreg(val, ICC_SRE);
>>  	isb();
>>  }
>>  
>> diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
>> index c3f1152..f661732 100644
>> --- a/arch/arm/include/asm/cp15.h
>> +++ b/arch/arm/include/asm/cp15.h
>> @@ -47,6 +47,21 @@
>>  #define vectors_high()	(0)
>>  #endif
>>  
>> +#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
>> +	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
>> +#define __ACCESS_CP15_64(Op1, CRm)		\
>> +	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
>> +
>> +#define __read_sysreg(r, w, c, t) ({				\
>> +	t __val;						\
>> +	asm volatile(r " " c : "=r" (__val));			\
>> +	__val;							\
>> +})
>> +#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
>> +
>> +#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
>> +#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
>> +
> 
> I feel a bit strange about adding this sort of stuff in a
> non-kvm-non-gic-specific ARM header file, without it being used (or
> planned to be used) in a broader sense.
> 
> Is there not a way to keep the required changes local to KVM and the
> gic?
> 

We could add prefixes to KVM and GIC version of macros so they won't
clash, but it'd introduce code duplication.
We could keep macro in, say, GIC header and include it in KVM one (or
vice versa), but such dependency would not look nicer, IMO.

The way arm64 handles this is via sysreg.h and the closest counterpart
under arch/arm is cp15.h

I'm open to suggestions.

Thanks
Vladimir
