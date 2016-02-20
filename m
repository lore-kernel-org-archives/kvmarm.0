From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v11 06/21] KVM: ARM64: Add access handler for PMCEID0
 and PMCEID1 register
Date: Sat, 20 Feb 2016 21:15:23 +0800
Message-ID: <56C866EB.9060105@linaro.org>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-7-git-send-email-zhaoshenglong@huawei.com>
 <20160208120950.GC620@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EC2749692
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:09:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EL4KtXKJYYSF for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Feb 2016 08:09:01 -0500 (EST)
Received: from mail-pf0-f178.google.com (mail-pf0-f178.google.com
 [209.85.192.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FED54968B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:09:01 -0500 (EST)
Received: by mail-pf0-f178.google.com with SMTP id q63so66664490pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 05:15:30 -0800 (PST)
In-Reply-To: <20160208120950.GC620@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/8 20:09, Christoffer Dall wrote:
> On Fri, Feb 05, 2016 at 03:14:01PM +0800, Shannon Zhao wrote:
>> >From: Shannon Zhao<shannon.zhao@linaro.org>
>> >
>> >Add access handler which gets host value of PMCEID0 or PMCEID1 when
>> >guest access these registers. Writing action to PMCEID0 or PMCEID1 is
>> >UNDEFINED.
>> >
>> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>> >---
>> >  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>> >  1 file changed, 25 insertions(+), 4 deletions(-)
>> >
>> >diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> >index fc60041..06257e2 100644
>> >--- a/arch/arm64/kvm/sys_regs.c
>> >+++ b/arch/arm64/kvm/sys_regs.c
>> >@@ -492,6 +492,27 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >  	return true;
>> >  }
>> >
>> >+static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >+			  const struct sys_reg_desc *r)
>> >+{
>> >+	u64 pmceid;
>> >+
>> >+	if (!kvm_arm_pmu_v3_ready(vcpu))
>> >+		return trap_raz_wi(vcpu, p, r);
>> >+
>> >+	if (p->is_write)
>> >+		return false;
> Isn't it really a BUG_ON(p->is_write) ?
>
> Presumably a guest write to these registers will raise an undefined
> exception in EL0/1 and we don't get here by any other path than the trap
> handler, do we?
Yeah, for EL1, it shouldn't get here. But for EL0, to support the 
function of PMUSERENR, we firstly trap the access to EL2, then according 
to the real value of PMUSERENR to decide whether inject an UND to EL1.


Thanks,
-- 
Shannon
