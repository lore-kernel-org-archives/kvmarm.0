From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Sun, 14 Oct 2018 10:35:41 +0100
Message-ID: <20181014093541.GW30658@n2100.armlinux.org.uk>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
 <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
 <20181014092734.GV30658@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181014092734.GV30658@n2100.armlinux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org, linux@armlinux.org, kvm@vger.kernel.org, rkrcmar@redhat.com, benh@kernel.crashing.org, will.deacon@arm.com, christoffer.dall@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, lantianyu1986@gmail.com, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, michael.h.kelley@microsoft.com, mingo@redhat.com, catalin.marinas@arm.com, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, Liran Alon <liran.alon@oracle.com>, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, devel@linuxdriverproject.org, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Oct 14, 2018 at 10:27:34AM +0100, Russell King - ARM Linux wrote:
> On Sun, Oct 14, 2018 at 10:16:56AM +0200, Thomas Gleixner wrote:
> > On Sun, 14 Oct 2018, Liran Alon wrote:
> > > > On 13 Oct 2018, at 17:53, lantianyu1986@gmail.com wrote:
> > > > 
> > > > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > > > 
> > > > This patch is to add wrapper functions for tlb_remote_flush_with_range
> > > > callback.
> > > > 
> > > > Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > > > ---
> > > > Change sicne V3:
> > > >       Remove code of updating "tlbs_dirty"
> > > > Change since V2:
> > > >       Fix comment in the kvm_flush_remote_tlbs_with_range()
> > > > ---
> > > > arch/x86/kvm/mmu.c | 40 ++++++++++++++++++++++++++++++++++++++++
> > > > 1 file changed, 40 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > > > index c73d9f650de7..ff656d85903a 100644
> > > > --- a/arch/x86/kvm/mmu.c
> > > > +++ b/arch/x86/kvm/mmu.c
> > > > @@ -264,6 +264,46 @@ static void mmu_spte_set(u64 *sptep, u64 spte);
> > > > static union kvm_mmu_page_role
> > > > kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
> > > > 
> > > > +
> > > > +static inline bool kvm_available_flush_tlb_with_range(void)
> > > > +{
> > > > +	return kvm_x86_ops->tlb_remote_flush_with_range;
> > > > +}
> > > 
> > > Seems that kvm_available_flush_tlb_with_range() is not used in this patch…
> > 
> > What's wrong with that? 
> > 
> > It provides the implementation and later patches make use of it. It's a
> > sensible way to split patches into small, self contained entities.
> 
> From what I can see of the patches that follow _this_ patch in the
> series, this function remains unused.  So, not only is it not used
> in this patch, it's not used in this series.

Note - I seem to have only received patches 1 through 4, so this is
based on the patches I've received.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
