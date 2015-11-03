From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 08/21] KVM: ARM64: Add reset and access handlers for
 PMXEVTYPER register
Date: Tue, 3 Nov 2015 10:41:45 +0800
Message-ID: <56381EE9.3050003@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
 <5637CD74.2010609@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1297E49852
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 21:43:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqJGLbr5XJ79 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 21:43:36 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32A584905A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 21:43:33 -0500 (EST)
In-Reply-To: <5637CD74.2010609@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/11/3 4:54, Christopher Covington wrote:
> Hi Shannon,
> 
> On 10/30/2015 02:21 AM, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> Since the reset value of PMXEVTYPER is UNKNOWN, use reset_unknown or
>> reset_unknown_cp15 for its reset handler. Add access handler which
>> emulates writing and reading PMXEVTYPER register. When writing to
>> PMXEVTYPER, call kvm_pmu_set_counter_event_type to create a perf_event
>> for the selected event type.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
>>  1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index cb82b15..4e606ea 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -491,6 +491,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>>  
>>  	if (p->is_write) {
>>  		switch (r->reg) {
>> +		case PMXEVTYPER_EL0: {
>> +			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
>> +			kvm_pmu_set_counter_event_type(vcpu,
>> +						       *vcpu_reg(vcpu, p->Rt),
>> +						       val);
>> +			vcpu_sys_reg(vcpu, PMXEVTYPER_EL0) =
>> +							 *vcpu_reg(vcpu, p->Rt);
> 
> Why does PMXEVTYPER get set directly? It seems like it could have an accessor
> that redirected to PMEVTYPER<n>.
> 
Yeah, that's what this patch does. It gets the counter index from
PMSELR_EL0 register, then set the event type, create perf_event, store
event type to PMEVTYPER<n>, etc.

>> +			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + val) =
>> +							 *vcpu_reg(vcpu, p->Rt);
> 
> I tried to look around briefly but couldn't find counter number range checking
> in the PMSELR handler or here. Should there be some here and in PMXEVCNTR?
> 
Ok, will fix this. Thanks.

-- 
Shannon
