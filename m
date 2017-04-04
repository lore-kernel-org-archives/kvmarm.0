From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [kvmarm:master 1/3] arch/arm/kvm/mmu.c:302:14: error:
 'S2_PUD_SIZE' undeclared
Date: Tue, 4 Apr 2017 12:36:31 +0200
Message-ID: <20170404103631.GG11752@cbox>
References: <201704040547.iQuSbIzK%fengguang.wu@intel.com>
 <cf4974ea-6cfd-331c-6a77-cf4c9f07812b@arm.com>
 <2eb71228-7199-4f92-f9f7-3bb7c62bf485@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 555D640A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:34:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcGErxsDQIXm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 06:34:18 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33DE040992
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:34:18 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id w11so206843237wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 03:36:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <2eb71228-7199-4f92-f9f7-3bb7c62bf485@arm.com>
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
Cc: kbuild test robot <fengguang.wu@intel.com>, kvmarm@lists.cs.columbia.edu, kbuild-all@01.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 11:28:09AM +0100, Marc Zyngier wrote:
> On 04/04/17 11:14, Suzuki K Poulose wrote:
> > On 03/04/17 22:15, kbuild test robot wrote:
> >> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git master
> >> head:   1f1c45c6f66a586ca420ca02cbd93a35690394f9
> >> commit: f9d9eb7f7a2c7e388861fe1cdb253f63e63555fe [1/3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
> >> config: arm-axm55xx_defconfig (attached as .config)
> >> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> >> reproduce:
> >>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >>         chmod +x ~/bin/make.cross
> >>         git checkout f9d9eb7f7a2c7e388861fe1cdb253f63e63555fe
> >>         # save the attached .config to linux build tree
> >>         make.cross ARCH=arm
> >>
> >> All errors (new ones prefixed by >>):
> >>
> >>    arch/arm/kvm/mmu.c: In function 'unmap_stage2_range':
> >>>> arch/arm/kvm/mmu.c:302:14: error: 'S2_PUD_SIZE' undeclared (first use in this function)
> >>       if (size > S2_PUD_SIZE)
> >>                  ^~~~~~~~~~~
> > 
> > Thanks kbuild for catching this one !
> > 
> >>    arch/arm/kvm/mmu.c:302:14: note: each undeclared identifier is reported only once for each function it appears in
> >>
> >> vim +/S2_PUD_SIZE +302 arch/arm/kvm/mmu.c
> >>
> >>    296		pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> >>    297		do {
> >>    298			/*
> >>    299			 * If the range is too large, release the kvm->mmu_lock
> >>    300			 * to prevent starvation and lockup detector warnings.
> >>    301			 */
> >>  > 302			if (size > S2_PUD_SIZE)
> >>    303				cond_resched_lock(&kvm->mmu_lock);
> >>    304			next = stage2_pgd_addr_end(addr, end);
> >>    305			if (!stage2_pgd_none(*pgd))
> >>
> > 
> > 
> > Marc, Christoffer,
> > 
> > Ah! I didn't test this on arm32. We have two options :
> > 
> > 1) Define S2_P{U,M}_SIZE for arm32 in asm/stage2_pgtable.h
> > 
> > or,
> > 
> > 2)  use the following hunk on top of the patch, which changes the lock
> > release after we process one PGDIR entry. As for the first time we enter
> > the loop we haven't done much with the lock held, hence it may make
> > sense to do it after the first round and we have more work to do.
> > 
> > Let me know what you think
> > 
> > 
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index db94f3a..582a972 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -295,15 +295,15 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
> >          assert_spin_locked(&kvm->mmu_lock);
> >          pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> >          do {
> > +               next = stage2_pgd_addr_end(addr, end);
> > +               if (!stage2_pgd_none(*pgd))
> > +                       unmap_stage2_puds(kvm, pgd, addr, next);
> >                  /*
> >                   * If the range is too large, release the kvm->mmu_lock
> >                   * to prevent starvation and lockup detector warnings.
> >                   */
> > -               if (size > S2_PUD_SIZE)
> > +               if (next != end)
> >                          cond_resched_lock(&kvm->mmu_lock);
> > -               next = stage2_pgd_addr_end(addr, end);
> > -               if (!stage2_pgd_none(*pgd))
> > -                       unmap_stage2_puds(kvm, pgd, addr, next);
> >          } while (pgd++, addr = next, addr != end);
> >   }
> 
> Yup, I quite like this last option, as it doesn't rely on a particular
> size (or just implicitly that of the PGD). Can you respin this?
> 

Agreed, I prefer this over my suggestion (sent as a reply to the
original patch).

Thanks,
-Christoffer
