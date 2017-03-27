From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Mon, 27 Mar 2017 16:47:11 +0200
Message-ID: <20170327144711.GB21871@cbox>
References: <20170315160727.16465-1-james.morse@arm.com>
 <20170324183044.GK25903@cbox>
 <87y3vrezjb.fsf@e105922-lin.cambridge.arm.com>
 <58D8FEF8.9000205@arm.com> <20170327124459.GA21871@cbox>
 <87mvc6g81r.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 471A340A7F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 10:45:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aZoW9K8Swvio for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 10:45:16 -0400 (EDT)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FCAC40A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 10:45:16 -0400 (EDT)
Received: by mail-wr0-f178.google.com with SMTP id u1so60305805wra.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 07:47:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87mvc6g81r.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, gengdongjiu <gengdj.1984@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27, 2017 at 02:31:44PM +0100, Punit Agrawal wrote:
> Christoffer Dall <cdall@linaro.org> writes:
> 
> > On Mon, Mar 27, 2017 at 01:00:56PM +0100, James Morse wrote:
> >> Hi guys,
> >> 
> >> On 27/03/17 12:20, Punit Agrawal wrote:
> >> > Christoffer Dall <cdall@linaro.org> writes:
> >> >> On Wed, Mar 15, 2017 at 04:07:27PM +0000, James Morse wrote:
> >> >>> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64[0], notifications for
> >> >>> broken memory can call memory_failure() in mm/memory-failure.c to deliver
> >> >>> SIGBUS to any user space process using the page, and notify all the
> >> >>> in-kernel users.
> >> >>>
> >> >>> If the page corresponded with guest memory, KVM will unmap this page
> >> >>> from its stage2 page tables. The user space process that allocated
> >> >>> this memory may have never touched this page in which case it may not
> >> >>> be mapped meaning SIGBUS won't be delivered.
> >> >>>
> >> >>> When this happens KVM discovers pfn == KVM_PFN_ERR_HWPOISON when it
> >> >>> comes to process the stage2 fault.
> >> >>>
> >> >>> Do as x86 does, and deliver the SIGBUS when we discover
> >> >>> KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
> >> >>> as this matches the user space mapping size.
> >> 
> >> >>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> >> >>> index 962616fd4ddd..9d1aa294e88f 100644
> >> >>> --- a/arch/arm/kvm/mmu.c
> >> >>> +++ b/arch/arm/kvm/mmu.c
> >> >>> @@ -20,8 +20,10 @@
> >> >>>  #include <linux/kvm_host.h>
> >> >>>  #include <linux/io.h>
> >> >>>  #include <linux/hugetlb.h>
> >> >>> +#include <linux/sched/signal.h>
> >> >>>  #include <trace/events/kvm.h>
> >> >>>  #include <asm/pgalloc.h>
> >> >>> +#include <asm/siginfo.h>
> >> >>>  #include <asm/cacheflush.h>
> >> >>>  #include <asm/kvm_arm.h>
> >> >>>  #include <asm/kvm_mmu.h>
> >> >>> @@ -1237,6 +1239,23 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
> >> >>>  	__coherent_cache_guest_page(vcpu, pfn, size);
> >> >>>  }
> >> >>>  
> >> >>> +static void kvm_send_hwpoison_signal(unsigned long address, bool hugetlb)
> >> >>> +{
> >> >>> +	siginfo_t info;
> >> >>> +
> >> >>> +	info.si_signo   = SIGBUS;
> >> >>> +	info.si_errno   = 0;
> >> >>> +	info.si_code    = BUS_MCEERR_AR;
> >> >>> +	info.si_addr    = (void __user *)address;
> >> >>> +
> >> >>> +	if (hugetlb)
> >> >>> +		info.si_addr_lsb = PMD_SHIFT;
> >> >>> +	else
> >> >>> +		info.si_addr_lsb = PAGE_SHIFT;
> >> >>> +
> >> >>> +	send_sig_info(SIGBUS, &info, current);
> >> >>> +}
> >> >>> +
> >> >>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >> >>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> >> >>>  			  unsigned long fault_status)
> >> >>> @@ -1306,6 +1325,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >> >>>  	smp_rmb();
> >> >>>  
> >> >>>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
> >> >>> +	if (pfn == KVM_PFN_ERR_HWPOISON) {
> >> >>> +		kvm_send_hwpoison_signal(hva, hugetlb);
> >> >>
> >> >> The way this is called means that we'll only notify userspace of a huge
> >> >> mapping if userspace is mapping hugetlbfs, and not because the stage2
> >> >> mapping may or may not have used transparent huge pages when the error
> >> >> was discovered.  Is this the desired semantics?
> >> 
> >> No,
> >> 
> >> 
> >> > I think so.
> >> >
> >> > AFAIUI, transparent hugepages are split before being poisoned while all
> >> > the underlying pages of a hugepage are poisoned together, i.e., no
> >> > splitting.
> >> 
> >> In which case I need to look into this some more!
> >> 
> >> My thinking was we should report the size that was knocked out of the stage2 to
> >> avoid the guest repeatedly faulting until it has touched every guest-page-size
> >> in the stage2 hole.
> >
> > By signaling something at the fault path, I think it's going to be very
> > hard to backtrack how the stage 2 page tables looked like when faults
> > started happening, because I think these are completely decoupled events
> > (the mmu notifier and the later fault).
> >
> >> 
> >> Reading the code in that kvm/mmu.c it looked like the mapping sizes would always
> >> be the same as those used by userspace.
> >
> > I think the mapping sizes should be the same between userspace and KVM,
> > but the mapping size of a particular page (and associated pages) may
> > vary over time.
> 
> Stage 1 and Stage 2 support different hugepage sizes. A larger size
> stage 1 page maps to multiple stage 2 page table entries. For stage 1,
> we support PUD_SIZE, CONT_PMD_SIZE, PMD_SIZE and CONT_PTE_SIZE while
> only PMD_SIZE is supported for Stage 2.
> 
> >
> >> 
> >> If the page was split before KVM could have taken this fault I assumed it would
> >> fault on the page-size mapping and hugetlb would be false.
> >
> > I think you could have a huge page, which gets unmapped as a result on
> > it getting split (perhaps because there was a failure on one page) and
> > later as you fault, you can discover a range which can be a hugetlbfs or
> > transparent huge pages.
> >
> > The question that I don't know is how Linux behaves if a page is marked
> > with hwpoison, in that case, if Linux never supports THP and always
> > marks an entire huge page in a hugetlbfs with the poison, then I think
> > we're mostly good here.  If not, we should make sure we align with
> > whatever the rest of the kernel does.
> 
> AFAICT, a hugetlbfs page is poisoned as a whole while thp is split
> before poisoning. Quoting comment near the top of memory_failure() in
> mm/memory_failure.c.
> 
>     /*
>      * Currently errors on hugetlbfs pages are measured in hugepage units,
>      * so nr_pages should be 1 << compound_order.  OTOH when errors are on
>      * transparent hugepages, they are supposed to be split and error
>      * measurement is done in normal page units.  So nr_pages should be one
>      * in this case.
>      */
> 
> >
> >> (which is already
> >> wrong for another reason, looks like I grabbed the variable before
> >> transparent_hugepage_adjust() has had a go a it.).
> >> 
> >
> > yes, which is why I asked if you only care about hugetlbfs.
> >
> 
> Based on the comment above, we should never get a poisoned page that is
> part of a transparent hugepage.
> 
> >> 
> >> >> Also notice that the hva is not necessarily aligned to the beginning of
> >> >> the huge page, so can we be giving userspace wrong information by
> >> >> pointing in the middle of a huge page and telling it there was an
> >> >> address error in the size of the PMD ?
> >> >>
> >> > 
> >> > I could be reading it wrong but I think we are fine here - the address
> >> > (hva) is the location that faulted. And the lsb indicates the least
> >> > significant bit of the faulting address (See man sigaction(2)). The
> >> > receiver of the signal is expected to use the address and lsb to workout
> >> > the extent of corruption.
> >> 
> >> kill_proc() in mm/memory-failure.c does this too, but the address is set by
> >> page_address_in_vma() in add_to_kill() of the same file. (I'll chat with Punit
> >> off list.)
> >> 
> >> 
> >> > Though I missed a subtlety while reviewing the patch before. The
> >> > reported lsb should be for the userspace hugepage mapping (i.e., hva)
> >> > and not for the stage 2.
> >> 
> >> I thought these were always supposed to be the same, and using hugetlb was a bug
> >> because I didn't look closely enough at what is_vm_hugetlb_page() does.
> 
> See above.
> 
> >> 
> >> 
> >> > In light of this, I'd like to retract my Reviewed-by tag for this
> >> > version of the patch as I believe we'll need to change the lsb
> >> > reporting.
> >> 
> >> Sure, lets work out what this should be doing. I'm beginning to suspect x86's
> >> 'always page size' was correct to begin with!
> >> 
> >
> > I had a sense of that too, but it would be good to understand how you
> > mark and individual page within a hugetlbfs huge page with hwpoison...
> 
> I don't think it is possible to mark an individual page in a hugetlbfs
> page - it's all or nothing.
> 
> AFAICT, the SIGBUS report is for user mappings and doesn't have to care
> whether it's Stage 2 hugetlb page or thp. And the lsb determination should
> take the Stage 1 hugepage size into account - something along the lines
> of the snippet from previous email.
> 

I think the lsb should indicate the size of the memory region known to
be broken by the kernel - however that whole mechanism works.

-Christoffer
