From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v7 15/19] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Tue, 15 Dec 2015 23:59:08 +0800
Message-ID: <567038CC.8030504@linaro.org>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-16-git-send-email-zhaoshenglong@huawei.com> <56702A9B.6000802@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56702A9B.6000802@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/15 22:58, Marc Zyngier wrote:
> On 15/12/15 08:49, Shannon Zhao wrote:
>> >From: Shannon Zhao<shannon.zhao@linaro.org>
>> >
>> >The reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown.
>> >
>> >PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
>> >accessed from EL0. Add some check helpers to handle the access from EL0.
>> >
>> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>> >---
>> >  arch/arm64/kvm/sys_regs.c | 124 ++++++++++++++++++++++++++++++++++++++++++++--
>> >  1 file changed, 119 insertions(+), 5 deletions(-)
>> >
>> >diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> >index b2ccc25..bad3dfd 100644
>> >--- a/arch/arm64/kvm/sys_regs.c
>> >+++ b/arch/arm64/kvm/sys_regs.c
>> >@@ -452,12 +452,44 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> >  	vcpu_sys_reg(vcpu, r->reg) = val;
>> >  }
>> >
>> >+static inline bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
>> >+{
>> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> >+
>> >+	return !((reg & 0x1) || vcpu_mode_priv(vcpu));
>> >+}
>> >+
>> >+static inline bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
>> >+{
>> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> >+
>> >+	return !((reg & 0x3) || vcpu_mode_priv(vcpu));
>> >+}
>> >+
>> >+static inline bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
>> >+{
>> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> >+
>> >+	return !((reg & 0x5) || vcpu_mode_priv(vcpu));
>> >+}
>> >+
>> >+static inline bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
>> >+{
>> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> >+
>> >+	return !((reg & 0x9) || vcpu_mode_priv(vcpu));
>> >+}
> Please add #defines for the PMUSERNR_EL0 bits.
>
>> >+
>> >  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >  			const struct sys_reg_desc *r)
>> >  {
>> >  	u64 val;
>> >+	bool unaccessible = pmu_access_el0_disabled(vcpu);
>> >
>> >  	if (p->is_write) {
>> >+		if (unaccessible)
>> >+			return ignore_write(vcpu, p);
>> >+
> This is not how this is supposed to work. If EL0 is denied access to the
> PMU, you must inject an exception into EL1 for it to handle the fault.
> The code should reflect the flow described at D5.11.2 in the ARM ARM.
>
Does it need to add a helper to inject an exception into EL1 or is there 
a existing one?

Thanks,
-- 
Shannon
