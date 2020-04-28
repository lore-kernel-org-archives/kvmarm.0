Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF07C83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 08:57:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1267C206B9
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 08:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1267C206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 753AE4B213;
	Tue, 28 Apr 2020 04:57:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l0KJHcQvMV2I; Tue, 28 Apr 2020 04:57:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5C9A4B266;
	Tue, 28 Apr 2020 04:57:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D4C4B1D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 21:34:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yd-hvBUgKKtF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2020 21:34:38 -0400 (EDT)
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19F984B1C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 21:34:38 -0400 (EDT)
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
 by Forcepoint Email with ESMTP id 050A225275FAC370E7B4;
 Tue, 28 Apr 2020 09:34:34 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.234]) by
 DGGEMM402-HUB.china.huawei.com ([10.3.20.210]) with mapi id 14.03.0487.000;
 Tue, 28 Apr 2020 09:34:24 +0800
From: "Zengtao (B)" <prime.zeng@hisilicon.com>
To: Marc Zyngier <maz@kernel.org>, yuzenghui <yuzenghui@huawei.com>
Subject: RE: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU
 reset state
Thread-Topic: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU
 reset state
Thread-Index: AQHWGKCGXKlP0CoY30iMrQFdxO97gqiHJHkAgAA8s4CABmeP4A==
Date: Tue, 28 Apr 2020 01:34:24 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A5634AE@dggemm526-mbx.china.huawei.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-19-maz@kernel.org>
 <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
 <20200424084505.6b0afc94@why>
In-Reply-To: <20200424084505.6b0afc94@why>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 28 Apr 2020 04:57:28 -0400
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Andre Przywara <andre.przywara@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 George Cherian <gcherian@marvell.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Marc Zyngier
> Sent: Friday, April 24, 2020 3:45 PM
> To: yuzenghui
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Will Deacon; Andre Przywara; Dave Martin;
> George Cherian; Zengtao (B); Catalin Marinas
> Subject: Re: [PATCH 18/26] KVM: arm64: Don't use empty structures as
> CPU reset state
> 
> Hi Zenghui,
> 
> On Fri, 24 Apr 2020 12:07:50 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > Hi Marc,
> >
> > On 2020/4/22 20:00, Marc Zyngier wrote:
> > > Keeping empty structure as the vcpu state initializer is slightly
> > > wasteful: we only want to set pstate, and zero everything else.
> > > Just do that.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >   arch/arm64/kvm/reset.c | 20 +++++++++-----------
> > >   1 file changed, 9 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > index 241db35a7ef4f..895d7d9ad1866 100644
> > > --- a/arch/arm64/kvm/reset.c
> > > +++ b/arch/arm64/kvm/reset.c
> > > @@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
> > >   /*
> > >    * ARMv8 Reset Values
> > >    */
> > > -static const struct kvm_regs default_regs_reset = {
> > > -	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
> > > -			PSR_F_BIT | PSR_D_BIT),
> > > -};
> > > +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h |
> PSR_A_BIT | PSR_I_BIT | \
> > > +				 PSR_F_BIT | PSR_D_BIT)
> > >   > -static const struct kvm_regs default_regs_reset32 = {
> > > -	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
> > > -			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> > > -};
> > > +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC |
> PSR_AA32_A_BIT | \
> > > +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> > >   >   static bool cpu_has_32bit_el1(void)
> > >   {
> > > @@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > >   	const struct kvm_regs *cpu_reset;
> > >   	int ret = -EINVAL;
> > >   	bool loaded;
> > > +	u32 pstate;
> > >   >   	/* Reset PMU outside of the non-preemptible section */
> > >   	kvm_pmu_vcpu_reset(vcpu);
> > > @@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu
> *vcpu)
> > >   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT,
> vcpu->arch.features)) {
> > >   			if (!cpu_has_32bit_el1())
> > >   				goto out;
> > > -			cpu_reset = &default_regs_reset32;
> > > +			pstate = VCPU_RESET_PSTATE_SVC;
> > >   		} else {
> > > -			cpu_reset = &default_regs_reset;
> > > +			pstate = VCPU_RESET_PSTATE_EL1;
> > >   		}
> > >   >   		break;
> > >   	}
> > >   >   	/* Reset core registers */
> > > -	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
> > > +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));
> >
> > Be careful that we can *not* use 'sizeof(*cpu_reset)' here anymore.
> As
> > you're going to refactor the layout of the core registers whilst keeping
> > the kvm_regs API unchanged.  Resetting the whole kvm_regs will go
> > corrupting some affected registers and make them temporarily invalid.
> > The bad thing will show up after you start moving ELR_EL1 around,
> > specifically in patch #20...
> 
> Ah, awesome find! Yes, it is pretty obvious now that you point it out.
> If I had removed this now useless cpu_reset variable, I'd have spotted
> it!
> 
> > And the first victim is ... MPIDR_EL1 (the first one in sys_regs array).
> > Now you know how this was spotted ;-)  I think this should be the
> root
> > cause of what Zengtao had previously reported [*].
> 
> It'd be good if Zengtao could confirm that changing this line to
> 
> 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> 
> fixes his problem.

I tried this change, and it did fix my problem, thanks :). 

> 
> > If these registers are all expected to be reset to architecturally
> > UNKNOWN values, I think we can just drop this memset(), though
> haven't
> > check with the ARM ARM carefully.
> 
> D1.9.1 ("PE state on reset to AArch64 state"):
> 
> "All general-purpose, and SIMD and floating-point registers are
> UNKNOWN."
> 
> There is a vaguely similar wording for AArch32 (G1.17.1), although it
> is only described by omission:
> 
> "Immediately after a reset, much of the PE state is UNKNOWN. However,
> some of the PE state is defined."
> 
> and the GPRs are not part of the list of defined states.
> 
> Still, I'm worried to change KVM's behaviour after so long... I'll have
> a try with a handful of non-Linux guests and see if anything breaks.
> 
> Thanks again,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
