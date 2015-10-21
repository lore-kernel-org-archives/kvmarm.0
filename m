From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v3 04/20] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Wed, 21 Oct 2015 14:27:11 +0800
Message-ID: <5627303F.4030006@huawei.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-5-git-send-email-shannon.zhao@linaro.org>
 <56208CB6.1050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <56208CB6.1050508@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Wei Huang <wei@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/10/16 13:35, Wei Huang wrote:
> 
> On 09/24/2015 05:31 PM, Shannon Zhao wrote:
>> > Add reset handler which gets host value of PMCR_EL0 and make writable
>> > bits architecturally UNKNOWN. Add a common access handler for PMU
>> > registers which emulates writing and reading register and add emulation
>> > for PMCR.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 81 +++++++++++++++++++++++++++++++++++++++++++++--
>> >  1 file changed, 79 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index b41607d..60c0842 100644
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
>> > @@ -446,6 +447,53 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> >  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>> >  }
>> >  
>> > +static void vcpu_sysreg_write(struct kvm_vcpu *vcpu,
>> > +			      const struct sys_reg_desc *r, u64 val)
>> > +{
>> > +	if (!vcpu_mode_is_32bit(vcpu))
>> > +		vcpu_sys_reg(vcpu, r->reg) = val;
>> > +	else
>> > +		vcpu_cp15(vcpu, r->reg) = lower_32_bits(val);
>> > +}
>> > +
>> > +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> > +{
>> > +	u64 pmcr, val;
>> > +
>> > +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
>> > +	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN*/
>> > +	val = (pmcr & ~ARMV8_PMCR_MASK) | (ARMV8_PMCR_MASK & 0xdecafbad);
> Two comments:
> (1) In Patch 1, ARMV8_PMCR_MASK is defined as 0x3f. According to ARMv8
> spec, PMCR_EL0.LC (bit 6) is also writable. Should ARMV8_PMCR_MASK be 0x7f?
According to the spec, it should be 0x7f.

> (2) According to spec the PMCR_EL0.E bit reset to 0, not UNKNOWN.
> 
Yeah, will fix this.

Thanks,
-- 
Shannon
