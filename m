From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/9] arm64: KVM: PMU: Refactor pmu_*_el0_disabled
Date: Tue, 28 Mar 2017 14:21:15 +0100
Message-ID: <0505d0e7-bfb6-903a-5c24-53b375e58332@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-2-marc.zyngier@arm.com> <20170328124623.GJ31156@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEBB940C17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:19:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qslOgddCJ5bu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 09:19:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE6B40960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:19:19 -0400 (EDT)
In-Reply-To: <20170328124623.GJ31156@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/03/17 13:46, Christoffer Dall wrote:
> On Mon, Mar 27, 2017 at 05:03:37PM +0100, Marc Zyngier wrote:
>> There is a lot of duplication in the pmu_*_el0_disabled helpers,
>> and as we're going to modify them shortly, let's move all the
>> common stuff in a single function.
>>
>> No functionnal change.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 25 +++++++++++--------------
>>  1 file changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 0e26f8c2b56f..7e1d673304d5 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -460,35 +460,32 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>  	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>>  }
>>  
>> -static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
>> +static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)
>>  {
>>  	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> +	bool cond = (reg & flags) || vcpu_mode_priv(vcpu);
> 
> nit: I would call this variable 'enabled' and then return !enabled to
> make it clear what's going on.
> 
> (If you agree, I can fix this up when applying along with the typo and
> rename pointed out by Suzuki).

Yup, that'd be absolutely fine.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
