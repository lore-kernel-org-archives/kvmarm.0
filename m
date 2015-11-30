From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/21] KVM: ARM64: Add reset and access handlers for
 PMCEID0 and PMCEID1 register
Date: Mon, 30 Nov 2015 13:19:22 +0000
Message-ID: <20151130131922.0e8789b7@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
	<1446186123-11548-7-git-send-email-zhaoshenglong@huawei.com>
	<20151130114230.136abc6f@arm.com>
	<565C3A39.5020600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <565C3A39.5020600@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 30 Nov 2015 19:59:53 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> Hi Marc,
> 
> On 2015/11/30 19:42, Marc Zyngier wrote:
> >> +static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >> > +{
> >> > +	u64 pmceid;
> >> > +
> >> > +	if (r->reg == PMCEID0_EL0 || r->reg == c9_PMCEID0)
> > That feels wrong. We should only reset the 64bit view of the sysregs,
> > as the 32bit view is directly mapped to it.
> > 
> Just to confirm, if guest access c9_PMCEID0, KVM will trap this register
> with the register index as PMCEID0_EL0? Or still as c9_PMCEID0?

The traps are per execution mode (you'll get c9_PMCEID0 with a 32bit
guest). But the reset function is only concerned with the 64bit view.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
