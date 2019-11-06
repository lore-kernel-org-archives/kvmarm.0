Return-Path: <SRS0=zKS9=Y6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F46C5DF63
	for <kvmarm@archiver.kernel.org>; Wed,  6 Nov 2019 15:20:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3E492166E
	for <kvmarm@archiver.kernel.org>; Wed,  6 Nov 2019 15:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3E492166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 525AC4A65C;
	Wed,  6 Nov 2019 10:20:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6dxoktn-+-tZ; Wed,  6 Nov 2019 10:20:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E501F4AC7A;
	Wed,  6 Nov 2019 10:20:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3D14A65C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Nov 2019 10:20:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wGxB+jwlO4Lr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Nov 2019 10:20:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACD044A650
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Nov 2019 10:20:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24FB646A;
 Wed,  6 Nov 2019 07:20:40 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB1603F71A;
 Wed,  6 Nov 2019 07:20:39 -0800 (PST)
Date: Wed, 6 Nov 2019 16:20:38 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't set HCR_EL2.TVM when S2FWB is
 supported
Message-ID: <20191106152038.GA30659@e113682-lin.lund.arm.com>
References: <20191028130541.30536-1-christoffer.dall@arm.com>
 <7d3a2fe0-1bf3-0fee-deb6-fa6e0940586a@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7d3a2fe0-1bf3-0fee-deb6-fa6e0940586a@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Alexandru,

On Wed, Nov 06, 2019 at 01:02:21PM +0000, Alexandru Elisei wrote:
> 
> On 10/28/19 1:05 PM, Christoffer Dall wrote:
> > On CPUs that support S2FWB (Armv8.4+), KVM configures the stage 2 page
> > tables to override the memory attributes of memory accesses, regardless
> > of the stage 1 page table configurations, and also when the stage 1 MMU
> > is turned off.  This results in all memory accesses to RAM being
> > cacheable, including during early boot of the guest.
> >
> > On CPUs without this feature, memory accesses were non-cacheable during
> > boot until the guest turned on the stage 1 MMU, and we had to detect
> > when the guest turned on the MMU, such that we could invalidate all cache
> > entries and ensure a consistent view of memory with the MMU turned on.
> > When the guest turned on the caches, we would call stage2_flush_vm()
> > from kvm_toggle_cache().
> >
> > However, stage2_flush_vm() walks all the stage 2 tables, and calls
> > __kvm_flush-dcache_pte, which on a system with S2FWD does ... absolutely
> > nothing.
> >
> > We can avoid that whole song and dance, and simply not set TVM when
> > creating a VM on a system that has S2FWB.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> > I was only able to test this on the model with cache modeling enabled,
> > but even removing TVM from HCR_EL2 without having FWB also worked with
> > that setup, so the testing of this has been light.  It seems like it
> > should obviously work, but it would be good if someone with access to
> > appropriate hardware could give this a spin.
> >
> >  arch/arm64/include/asm/kvm_arm.h     |  3 +--
> >  arch/arm64/include/asm/kvm_emulate.h | 12 +++++++++++-
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index ddf9d762ac62..6e5d839f42b5 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -61,7 +61,6 @@
> >   * RW:		64bit by default, can be overridden for 32bit VMs
> >   * TAC:		Trap ACTLR
> >   * TSC:		Trap SMC
> > - * TVM:		Trap VM ops (until M+C set in SCTLR_EL1)
> >   * TSW:		Trap cache operations by set/way
> >   * TWE:		Trap WFE
> >   * TWI:		Trap WFI
> > @@ -74,7 +73,7 @@
> >   * SWIO:	Turn set/way invalidates into set/way clean+invalidate
> >   */
> >  #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
> > -			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
> > +			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
> >  			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
> >  			 HCR_FMO | HCR_IMO)
> >  #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index d69c1efc63e7..70509799a2a9 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -53,8 +53,18 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> >  		/* trap error record accesses */
> >  		vcpu->arch.hcr_el2 |= HCR_TERR;
> >  	}
> > -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> > +
> > +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> >  		vcpu->arch.hcr_el2 |= HCR_FWB;
> > +	} else {
> > +		/*
> > +		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
> > +		 * get set in SCTLR_EL1 such that we can detect when the guest
> > +		 * MMU gets turned off and do the necessary cache maintenance
> > +		 * then.
> > +		 */
> > +		vcpu->arch.hcr_el2 &= ~HCR_TVM;
> > +	}
> >  
> >  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
> >  		vcpu->arch.hcr_el2 &= ~HCR_RW;
> 
> This patch makes sense to me: when FWB is available, the guest memory is cacheable
> even when the stage 1 MMU is disabled, which means it's now impossible to have a
> situation where the data in memory is newer than the data in the cache.
> 
> I tested the patch with the fix suggested by Marc by doing a linux boot and then a
> 'ls -R /', and by running kvm-unit-tests in a loop a couple dozen times. For what
> it's worth:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> I do need to point out that I haven't been able to make a guest misbehave when FWB
> is not enabled *and* KVM doesn't do a stage2_flush_vm when the stage 1 MMU is
> enabled. I tried to write two different tests in kvm-unit-tests:
> 
> 1. With the MMU never enabled, the test tells the host to read a value from memory
> (so a cache line is allocated), writes another value to the same memory location,
> and then enables the MMU and reads the memory back. I always got the latest value
> that was written while the MMU was off.
> 
> 2. One thread tells the host to read the memory location in a loop (to make sure
> that the cache line doesn't get evicted), while the other thread writes a value
> with the MMU off, enables the MMU and reads the memory back. I still got the
> latest value written with the MMU off.
> 
> I can share the source code for the tests, if anyone is interested; I'm also open
> to other suggestions.
> 

Thanks for the thoroughness here.  I also wasn't able to produce an
error on the model, so I think we can conclude that it's at least no
worse than the original code, and since we all agree that this should be
correct, then I think it's fair that Marc has merged the patch.

It can't hurt to post the code you wrote for the test; someone might
pick that up in the future to test something similar.


Thanks,

    Christoffer

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
