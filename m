From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v2 04/22] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Mon, 14 Sep 2015 11:14:15 +0800
Message-ID: <55F63B87.4020205@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
 <1441961715-11688-5-git-send-email-zhaoshenglong@huawei.com>
 <55F2A7F7.4010801@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF01740FB3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2015 23:15:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOfwQbYXZCQZ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Sep 2015 23:15:58 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59AC340C9D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2015 23:15:56 -0400 (EDT)
In-Reply-To: <55F2A7F7.4010801@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/11 18:07, Marc Zyngier wrote:
> On 11/09/15 09:54, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > Add reset handler which gets host value of PMCR_EL0 and make writable
>> > bits architecturally UNKNOWN. Add a common access handler for PMU
>> > registers which emulates writing and reading register and add emulation
>> > for PMCR.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 76 +++++++++++++++++++++++++++++++++++++++++++++--
>> >  1 file changed, 74 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index c370b40..db1be44 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -33,6 +33,7 @@
>> >  #include <asm/kvm_emulate.h>
>> >  #include <asm/kvm_host.h>
>> >  #include <asm/kvm_mmu.h>
>> > +#include <asm/pmu.h>
>> >  
>> >  #include <trace/events/kvm.h>
>> >  
>> > @@ -236,6 +237,48 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> >  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>> >  }
>> >  
>> > +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> > +{
>> > +	u32 pmcr;
>> > +
>> > +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
>> > +	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN*/
>> > +	if (!vcpu_mode_is_32bit(vcpu))
>> > +		vcpu_sys_reg(vcpu, r->reg) = (pmcr & ~ARMV8_PMCR_MASK)
>> > +					     | (ARMV8_PMCR_MASK & 0xdecafbad);
>> > +	else
>> > +		vcpu_cp15(vcpu, r->reg) = (pmcr & ~ARMV8_PMCR_MASK)
>> > +					  | (ARMV8_PMCR_MASK & 0xdecafbad);
> I have some concerns about blindly reusing the top bits of the host's
> PMCR_EL0 register, specially when it comes to the PMCR_EL0.N. Given that
> we're fully emulating the PMU, shouldn't we simply define how many
> counters we're emulating?
> 

But how many counters should we define? And what does this definition
based on? The only gist I think is the number of counters on host. And
what's the reason to define less or more than PMCR_EL0.N? I didn't find
one. So I choose to be consistent with host.

Thanks,
-- 
Shannon
