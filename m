From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 7/11] KVM: Remove redundant check in the
 kvm_get_dirty_log_protect()
Date: Fri, 4 Jan 2019 13:27:02 -0800
Message-ID: <20190104212702.GD11288@linux.intel.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-8-Tianyu.Lan@microsoft.com>
 <20190104155036.GA11288@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190104155036.GA11288@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 04, 2019 at 07:50:36AM -0800, Sean Christopherson wrote:
> On Fri, Jan 04, 2019 at 04:54:01PM +0800, lantianyu1986@gmail.com wrote:
> > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > 
> > The dirty bits have already been checked in the previous check of
> > "dirty_bitmap" and mask must be non-zero value at this point.
> > 
> > Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
> > ---
> >  virt/kvm/kvm_main.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index cf7cc0554094..e75dbb15fd09 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1206,11 +1206,9 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
> >  			mask = xchg(&dirty_bitmap[i], 0);
> >  			dirty_bitmap_buffer[i] = mask;
> >  
> > -			if (mask) {
> > -				offset = i * BITS_PER_LONG;
> > -				kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> > -									offset, mask);
> > -			}
> > +			offset = i * BITS_PER_LONG;
> > +			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> > +								offset, mask);
> 
> Hmm, the check against mask was explicitly added by commit 58d2930f4ee3
> ("KVM: Eliminate extra function calls in kvm_get_dirty_log_protect()").
> AFAIK KVM only *sets* bits in dirty_bitmap without holding slots_lock
> and/or mmu_lock, so I agree that checking mask is redundant, but it'd be
> nice to elaborate a bit more in the changelog.
> 
> At the very least this needs a Fixes tag for the aforementioned commit.

Actually, this can be a straight revert of 58d2930f4ee3.
