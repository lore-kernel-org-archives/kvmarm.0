From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Sun, 14 Oct 2018 10:16:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-68457485-1539505017=:1438"
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 973FF4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Oct 2018 04:17:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mVWrK5i2Ldqj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 14 Oct 2018 04:17:31 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D0BB4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Oct 2018 04:17:31 -0400 (EDT)
In-Reply-To: <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Liran Alon <liran.alon@oracle.com>
Cc: linux-mips@linux-mips.org, linux@armlinux.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, lantianyu1986@gmail.com, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, devel@linuxdriverproject.org, linux-arm-kernel@lists.infradead.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-68457485-1539505017=:1438
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 14 Oct 2018, Liran Alon wrote:
> > On 13 Oct 2018, at 17:53, lantianyu1986@gmail.com wrote:
> > 
> > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > 
> > This patch is to add wrapper functions for tlb_remote_flush_with_range
> > callback.
> > 
> > Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > ---
> > Change sicne V3:
> >       Remove code of updating "tlbs_dirty"
> > Change since V2:
> >       Fix comment in the kvm_flush_remote_tlbs_with_range()
> > ---
> > arch/x86/kvm/mmu.c | 40 ++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 40 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index c73d9f650de7..ff656d85903a 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -264,6 +264,46 @@ static void mmu_spte_set(u64 *sptep, u64 spte);
> > static union kvm_mmu_page_role
> > kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
> > 
> > +
> > +static inline bool kvm_available_flush_tlb_with_range(void)
> > +{
> > +	return kvm_x86_ops->tlb_remote_flush_with_range;
> > +}
> 
> Seems that kvm_available_flush_tlb_with_range() is not used in this patch…

What's wrong with that? 

It provides the implementation and later patches make use of it. It's a
sensible way to split patches into small, self contained entities.

Thanks,

	tglx
	
--8323329-68457485-1539505017=:1438
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--8323329-68457485-1539505017=:1438--
