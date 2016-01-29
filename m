From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v10 06/21] KVM: ARM64: Add access handler for PMCEID0
 and PMCEID1 register
Date: Fri, 29 Jan 2016 11:47:27 +0800
Message-ID: <56AAE0CF.3050009@huawei.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-7-git-send-email-zhaoshenglong@huawei.com>
 <20160128203406.GI16453@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07648407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 22:46:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sqGlvIFl5KFN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2016 22:45:58 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC21440402
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 22:45:57 -0500 (EST)
In-Reply-To: <20160128203406.GI16453@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/29 4:34, Andrew Jones wrote:
> On Wed, Jan 27, 2016 at 11:51:34AM +0800, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > Add access handler which gets host value of PMCEID0 or PMCEID1 when
>> > guest access these registers. Writing action to PMCEID0 or PMCEID1 is
>> > UNDEFINED.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>> >  1 file changed, 25 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index fc60041..06257e2 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -492,6 +492,27 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >  	return true;
>> >  }
>> >  
>> > +static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> > +			  const struct sys_reg_desc *r)
>> > +{
>> > +	u64 pmceid;
>> > +
>> > +	if (!kvm_arm_pmu_v3_ready(vcpu))
>> > +		return trap_raz_wi(vcpu, p, r);
>> > +
>> > +	if (p->is_write)
>> > +		return false;
>> > +
>> > +	if (!(p->Op2 & 1))
>> > +		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
>> > +	else
>> > +		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
> For migratibility concerns we may want to filter some of these events.
> With that in mind the answer to my question in 4/21 is 'no'. Instead we
> should pick an IMP,IDCODE,N,PMCEID0_EL0,PMCEID1_EL0 that we expect to
> represent the least common denominator of all the platforms available
> now, and then only expose that view to the guest. If we want to support
> more events, and userspace requests it for the guest, then we can relax
> the filtering (at the expense of migratibility), when the host has the
> support.
> 
As replied at patch 4, I think this could be done by the cross-cpu type
support patches.

Thanks,
-- 
Shannon
