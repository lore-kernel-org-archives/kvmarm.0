From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v9 2/8] KVM: arm/arm64: Re-factor setting the Stage 2
 entry to exec on fault
Date: Mon, 10 Dec 2018 09:59:04 +0100
Message-ID: <20181210085904.GC30263@e113682-lin.lund.arm.com>
References: <20181031175745.18650-1-punit.agrawal@arm.com>
 <20181031175745.18650-3-punit.agrawal@arm.com>
 <12212830-ffc6-a0e0-5de6-3e6a15ed7141@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12212830-ffc6-a0e0-5de6-3e6a15ed7141@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, punitagrawal@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 07:02:23PM +0530, Anshuman Khandual wrote:
> 
> 
> On 10/31/2018 11:27 PM, Punit Agrawal wrote:
> > Stage 2 fault handler marks a page as executable if it is handling an
> > execution fault or if it was a permission fault in which case the
> > executable bit needs to be preserved.
> > 
> > The logic to decide if the page should be marked executable is
> > duplicated for PMD and PTE entries. To avoid creating another copy
> > when support for PUD hugepages is introduced refactor the code to
> > share the checks needed to mark a page table entry as executable.
> > 
> > Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  virt/kvm/arm/mmu.c | 28 +++++++++++++++-------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index 59595207c5e1..6912529946fb 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -1475,7 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  			  unsigned long fault_status)
> >  {
> >  	int ret;
> > -	bool write_fault, exec_fault, writable, force_pte = false;
> > +	bool write_fault, writable, force_pte = false;
> > +	bool exec_fault, needs_exec;
> 
> New line not required, still within 80 characters.
> 

He's trying to logically group the two variables.  I don't see a problem
with that.


Thanks,

    Christoffer
