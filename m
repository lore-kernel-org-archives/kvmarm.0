Return-Path: <SRS0=TbXc=V7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F382C433FF
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 10:11:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B744A206A2
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 10:11:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B744A206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00F7B4A550;
	Sat,  3 Aug 2019 06:11:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3e4daaj1g-1y; Sat,  3 Aug 2019 06:11:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5F294A53B;
	Sat,  3 Aug 2019 06:11:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B81FA4A53B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 06:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Xr8H23si20F for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Aug 2019 06:11:09 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F0104A4C1
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 06:11:09 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1htr0B-0006eH-Tl; Sat, 03 Aug 2019 12:11:04 +0200
Date: Sat, 3 Aug 2019 11:10:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: kvm-unit-tests: psci_cpu_on_test FAILed
Message-ID: <20190803111047.11493907@why>
In-Reply-To: <f58de1d7-a6ca-bd6d-8423-01d27326e078@huawei.com>
References: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
 <48a18685-ee81-83a7-9eea-63fe26690903@kernel.org>
 <f58de1d7-a6ca-bd6d-8423-01d27326e078@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, drjones@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Sat, 3 Aug 2019 17:27:41 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi Marc,
> 
> On 2019/8/2 23:56, Marc Zyngier wrote:
> > On 02/08/2019 11:56, Zenghui Yu wrote:  
> >> Hi folks,
> >>
> >> Running kvm-unit-tests with Linux 5.3.0-rc2 on Kunpeng 920, we will get
> >> the following fail info:
> >>
> >> 	[...]
> >> 	FAIL psci (4 tests, 1 unexpected failures)
> >> 	[...]
> >> and
> >> 	[...]
> >> 	INFO: unexpected cpu_on return value: caller=CPU9, ret=-2
> >> 	FAIL: cpu-on
> >> 	SUMMARY: 4 tests, 1 unexpected failures
> >>
> >>
> >> I think this is an issue had been fixed once by commit 6c7a5dce22b3
> >> ("KVM: arm/arm64: fix races in kvm_psci_vcpu_on"), which makes use of
> >> kvm->lock mutex to fix the race between two PSCI_CPU_ON calls - one
> >> does reset on the MPIDR register whilst another reads it.
> >>
> >> But commit 358b28f09f0 ("arm/arm64: KVM: Allow a VCPU to fully reset
> >> itself") later moves the reset work into check_vcpu_requests(), by
> >> making a KVM_REQ_VCPU_RESET request in PSCI code. Thus the reset work
> >> has not been protected by kvm->lock mutex anymore, and the race shows up
> >> again...
> >>
> >> Do we need a fix for this issue? At least achieve a mutex execution
> >> between the reset of MPIDR and kvm_mpidr_to_vcpu()?  
> > 
> > The thing is that the way we reset registers is marginally insane.
> > Yes, it catches most reset bugs. It also introduces many more in
> > the rest of the paths.
> > 
> > The fun part is that there is hardly a need for resetting MPIDR.
> > It has already been set when we've created the vcpu. It is the  
> 
> (That means we can let reset_mpidr() do nothing?)

It should ever be only written once, as MPIDR is a constant from the
guest perspective. So it is not that it can do nothing. It is just that
there should never be any other value written to it.

> 
> > poisoning of the sysreg array that creates a situation where
> > the MPIDR is temporarily invalid.
> > 
> > So instead of poisoning the array, how about we just keep
> > track of the registers for which we've called a reset function?
> > It should be enough to track the most obvious bugs... I've  
> 
> The reset of DBG{BCR,BVR,WVR,WCR}n_EL1 registers will also be tracked.
> It may affect our judgment?

How so?

> 
> > cobbled the following patch together, which seems to fix the
> > issue on my TX2 with 64 vcpus.
> > 
> > Thoughts?
> > 
> > 	M.
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index f26e181d881c..17f46ee7dc83 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2254,13 +2254,17 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
> >   }  
> >   >   static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,  
> > -			      const struct sys_reg_desc *table, size_t num)
> > +				const struct sys_reg_desc *table, size_t num,
> > +				unsigned long *bmap)
> >   {
> >   	unsigned long i;  
> >   >   	for (i = 0; i < num; i++)  
> > -		if (table[i].reset)
> > +		if (table[i].reset) {
> >   			table[i].reset(vcpu, &table[i]);
> > +			if (bmap)
> > +				set_bit(i, bmap);  
> 
> I think this should be:
> 	set_bit(table[i].reg, bmap);
> 
> Am I wrong?

No, you're absolutely right.

> 
> > +		}
> >   }  
> >   >   /**  
> > @@ -2772,21 +2776,23 @@ void kvm_sys_reg_table_init(void)
> >    */
> >   void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
> >   {
> > +	unsigned long *bmap;
> >   	size_t num;
> >   	const struct sys_reg_desc *table;  
> >   > -	/* Catch someone adding a register without putting in reset entry. */  
> > -	memset(&vcpu->arch.ctxt.sys_regs, 0x42, sizeof(vcpu->arch.ctxt.sys_regs));
> > +	bmap = bitmap_alloc(NR_SYS_REGS, GFP_KERNEL);  
> 
> LOCKDEP kernel will be not happy with this bitmap_alloc:
> 
> " BUG: sleeping function called from invalid context at mm/slab.h:501
>    in_atomic(): 1, irqs_disabled(): 0, pid: 8710, name: qemu-system-aar "

Well spotted. I guess GFP_ATOMIC is in order.

> 
> >   >   	/* Generic chip reset first (so target could override). */  
> > -	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > +	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);  
> >   >   	table = get_target_table(vcpu->arch.target, true, &num);  
> > -	reset_sys_reg_descs(vcpu, table, num);
> > +	reset_sys_reg_descs(vcpu, table, num, bmap);  
> >   >   	for (num = 1; num < NR_SYS_REGS; num++) {  
> > -		if (WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
> > +		if (WARN(bmap && !test_bit(num, bmap),
> >   			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
> >   			break;
> >   	}
> > +
> > +	kfree(bmap);
> >   }
> > 
> >   
> 
> Some other minor questions about the sys reg resetting:
> 1. Pointer Authentication Registers haven't have reset entry yet,
>     do they need? The same for ACTLR_EL1.

Pointer auth registers definitely have a reset function, set to
reset_unknown. So does ACTLR_EL1, which resets to the host's value.

> 2. Why does PMCR_EL0 register have no "reg" field, in sys_reg_descs[]?

This looks like a (very minor) bug. reset_pmcr writes directly to the
PMCR_EL0 shadow register without using r->reg as the register number.
But in the light of the reset tracking we want to add, this needs
fixing.

> I will test this patch with kvm-unit-tests next week!

Well, wait until I repost something a bit less buggy...

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
