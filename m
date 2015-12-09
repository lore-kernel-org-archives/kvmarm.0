From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v6 15/21] KVM: ARM64: Add reset and access handlers for
 PMUSERENR register
Date: Wed, 9 Dec 2015 17:18:02 +0800
Message-ID: <5667F1CA.6060407@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-16-git-send-email-zhaoshenglong@huawei.com>
 <56670D7C.9070902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6289E412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 04:19:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EiKKnEvudp5m for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2015 04:19:54 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6E8940C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 04:19:53 -0500 (EST)
In-Reply-To: <56670D7C.9070902@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/9 1:03, Marc Zyngier wrote:
> On 08/12/15 12:47, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > The reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 5 +++--
>> >  1 file changed, 3 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index c830fde..80b66c0 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -880,7 +880,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>> >  	  access_pmu_pmxevcntr },
>> >  	/* PMUSERENR_EL0 */
>> >  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
>> > -	  trap_raz_wi },
>> > +	  access_pmu_regs, reset_unknown, PMUSERENR_EL0 },
> So while the 64bit view of the register resets as unknown, a CPU
> resetting in 32bit mode resets as 0. I suggest you reset it as zero, and
> document that choice. You may have to revisit all the other registers
> that do reset as unknown for 64bit as well.
> 
Sure.

BTW, here I didn't handle the bits of PMUSERENR which are used to
permit/forbid accessing some PMU registers from EL0. Does it need to add
the handler? Is there any way to get the exceptional level of the
accessing in hypervisor?

Thanks,
-- 
Shannon
