From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v3 07/20] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Wed, 21 Oct 2015 14:32:42 +0800
Message-ID: <5627318A.8090905@huawei.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-8-git-send-email-shannon.zhao@linaro.org>
 <56209467.3010800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <56209467.3010800@redhat.com>
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



On 2015/10/16 14:08, Wei Huang wrote:
>> +/**
>> > + * kvm_pmu_get_counter_value - get PMU counter value
>> > + * @vcpu: The vcpu pointer
>> > + * @select_idx: The counter index
>> > + */
>> > +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>> > +{
>> > +	u64 enabled, running;
>> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> > +	u64 counter;
>> > +
>> > +	if (!vcpu_mode_is_32bit(vcpu))
>> > +		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);
> The select_idx is from PMSELR_EL0. According to PMUv3 spec, PMSELR_EL0
> is the register that "selects the current event counter PMEVCNTR<x> or
> the cycle counter, CCNT". The code here always reads the counter value
> from PMEVCNTR. It doesn't read the value from cycle counter when
> select_idx=0b11111. We might waste some perf counter resources here.
> 
No, it does read the value from the cycle counter. When
select_idx=0b11111, PMEVCNTR0_EL0 + select_idx = PMCCNTR_EL0( See patch
03/20).

-- 
Shannon
