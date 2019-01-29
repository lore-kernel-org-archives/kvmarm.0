From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 2/4] KVM: arm/arm64: re-create event when setting counter
 value
Date: Tue, 29 Jan 2019 10:56:02 +0000
Message-ID: <4d05c50f-49c6-81fd-b41c-bf9460a5d9d6@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-3-git-send-email-andrew.murray@arm.com>
 <46fc9476-cff2-fd93-f5bb-237e26a2adc6@arm.com>
 <20190128114714.GA16627@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190128114714.GA16627@e119886-lin.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: andrew.murray@arm.com
Cc: marc.zyngier@arm.com, christoffer.dall@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 28/01/2019 11:47, Andrew Murray wrote:
> On Tue, Jan 22, 2019 at 02:18:17PM +0000, Suzuki K Poulose wrote:
>> Hi Andrew
>>
>> On 01/22/2019 10:49 AM, Andrew Murray wrote:
>>> The perf event sample_period is currently set based upon the current
>>> counter value, when PMXEVTYPER is written to and the perf event is created.
>>> However the user may choose to write the type before the counter value in
>>> which case sample_period will be set incorrectly. Let's instead decouple
>>> event creation from PMXEVTYPER and (re)create the event in either
>>> suitation.
>>>
>>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>>
>> The approach looks fine to me. However this patch seems to introduce a
>> memory leak, see below, which you may be addressing in a later patch in the
>> series. But this will affect bisecting issues.
> 
> See below, I don't think this is true.

You're right. Sorry for the noise.

> 
>>
>>> ---
>>>    virt/kvm/arm/pmu.c | 39 ++++++++++++++++++++++++++++++---------
>>>    1 file changed, 30 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>> index 531d27f..4464899 100644
>>> --- a/virt/kvm/arm/pmu.c
>>> +++ b/virt/kvm/arm/pmu.c
>>> @@ -24,6 +24,8 @@
>>>    #include <kvm/arm_pmu.h>
>>>    #include <kvm/arm_vgic.h>
>>> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
>>> +				      u64 select_idx);
>>
>> Could we just pass the counter index (i.e, select_idx) after updating
>> the event_type/counter value in the respective functions.
> 
> Unless I misunderstand we need the value of 'data' as it is used to
> populate the function local perf_event_attr structure.

Yes, we do program the "data" (which is the event code) in attr.config.
So, since this is now a helper routine, so the name "data" doesn't make any
sense.

> 
> However it is possible to instead read 'data' from __vcpu_sys_reg in
> kvm_pmu_create_perf_event instead of the call site. However
> kvm_pmu_set_counter_event_type would have to set the value of
> __vcpu_sys_reg from its data argument (as __vcpu_sys_reg normally gets
> set after kvm_pmu_set_counter_event_type returns). This is OK as we
> do this in the next patch in this series anyway - so perhaps I can
> bring that forward to this patch?

Yes, please.

Cheers
Suzuki
