From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 06/21] KVM: ARM64: Add reset and access handlers for
 PMCEID0 and PMCEID1 register
Date: Mon, 30 Nov 2015 19:59:53 +0800
Message-ID: <565C3A39.5020600@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-7-git-send-email-zhaoshenglong@huawei.com>
 <20151130114230.136abc6f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20151130114230.136abc6f@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: wei@redhat.com, kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, peter.huangpeng@huawei.com, linux-arm-kernel@lists.infradead.org, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, cov@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/11/30 19:42, Marc Zyngier wrote:
>> +static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> > +{
>> > +	u64 pmceid;
>> > +
>> > +	if (r->reg == PMCEID0_EL0 || r->reg == c9_PMCEID0)
> That feels wrong. We should only reset the 64bit view of the sysregs,
> as the 32bit view is directly mapped to it.
> 
Just to confirm, if guest access c9_PMCEID0, KVM will trap this register
with the register index as PMCEID0_EL0? Or still as c9_PMCEID0?

-- 
Shannon
