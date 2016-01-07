From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 07/20] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Thu, 7 Jan 2016 22:00:11 +0800
Message-ID: <568E6F6B.3060500@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>	<1450771695-11948-8-git-send-email-zhaoshenglong@huawei.com> <20160107134857.2c18d752@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160107134857.2c18d752@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/7 21:48, Marc Zyngier wrote:
>> +	if (pmc->perf_event) {
>> > +		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>> > +		reg = (pmc->idx == ARMV8_CYCLE_IDX)
>> > +		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
>> > +		vcpu_sys_reg(vcpu, reg) = counter;
>> > +		perf_event_release_kernel(pmc->perf_event);
> I'm having second thoughts about this one. Don't you need to first
> disable the event? You seem to be doing it on the destroy path, and it
> worries me that we're not doing the same thing on both paths.

I didn't find the limitation to use perf_event_release_kernel, but it's
better to disable it before release. Will add.

Thanks,
-- 
Shannon

