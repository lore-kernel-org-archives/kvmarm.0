From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 08/22] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Fri, 11 Sep 2015 15:14:27 +0100
Message-ID: <55F2E1C3.1060807@arm.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com> <1441961715-11688-9-git-send-email-zhaoshenglong@huawei.com> <55F2B52F.8000300@arm.com> <55F2D89A.5060907@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55F2D89A.5060907@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/09/15 14:35, Shannon Zhao wrote:
> 
> 
> On 2015/9/11 19:04, Marc Zyngier wrote:

[...]

>> Having had a chat with Will, it appears that a much better solution
>> would be to ask perf to use raw events instead of trying to map things
>> to perf events (which the guest has already done).
>>
>> See drivers/oprofile/oprofile_perf.c::op_perf_setup().
>>
>> Thoughts?
>>
> 
> Yeah, directly using PERF_TYPE_RAW event looks simpler. But should we 
> check whether the value of event number written to PMXEVTYPER_EL0 is 
> valid? Or That is guaranteed by guest?

I don't think we need to check for anything. Userspace is allowed to
request any event and the PMU will count it if this event exists, or
won't if it doesn't.

We shouldn't be doing more validation than that, if only because most
events are microarchitectural, and they are mostly undocumented.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
