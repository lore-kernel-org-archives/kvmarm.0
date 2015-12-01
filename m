From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 08/21] KVM: ARM64: Add reset and access handlers for
 PMXEVTYPER register
Date: Tue, 1 Dec 2015 10:42:30 +0800
Message-ID: <565D0916.5030300@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
 <20151130181247.55649fc7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11CE6498A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 21:45:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kRHqkSA80D3l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 21:45:41 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF5BF496EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 21:45:40 -0500 (EST)
In-Reply-To: <20151130181247.55649fc7@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/1 2:12, Marc Zyngier wrote:
> On Fri, 30 Oct 2015 14:21:50 +0800
> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> 
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > Since the reset value of PMXEVTYPER is UNKNOWN, use reset_unknown or
>> > reset_unknown_cp15 for its reset handler. Add access handler which
>> > emulates writing and reading PMXEVTYPER register. When writing to
>> > PMXEVTYPER, call kvm_pmu_set_counter_event_type to create a perf_event
>> > for the selected event type.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
>> >  1 file changed, 24 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index cb82b15..4e606ea 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -491,6 +491,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>> >  
>> >  	if (p->is_write) {
>> >  		switch (r->reg) {
>> > +		case PMXEVTYPER_EL0: {
>> > +			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
>> > +			kvm_pmu_set_counter_event_type(vcpu,
>> > +						       *vcpu_reg(vcpu, p->Rt),
>> > +						       val);
> You are blindingly truncating 64bit values to u32. Is that intentional?
> 
Yeah, the register PMXEVTYPER_EL0 and PMSELR_EL0 are all 32bit.

-- 
Shannon
