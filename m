From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 15:57:49 +0100
Message-ID: <20170109145749.GI4348@cbox>
References: <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
 <20170103095149.GA14242@cbox>
 <20170109122639.GX14217@n2100.armlinux.org.uk>
 <20170109132636.GH4348@cbox>
 <20170109140500.GA14217@n2100.armlinux.org.uk>
 <20170109144235.GC14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C458A401A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:56:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2u761ycZmJy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 09:56:11 -0500 (EST)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EC0C40064
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:56:10 -0500 (EST)
Received: by mail-lf0-f54.google.com with SMTP id v186so41762602lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jan 2017 06:57:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170109144235.GC14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 02:42:35PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 09, 2017 at 02:05:00PM +0000, Russell King - ARM Linux wrote:
> > So, although Marc produced a patch which updates the KVM hypervisor for
> > the GET_VECTORS change, through reading the code today, it's become clear
> > that much more is needed, so I'm yet again banging on about documentation.
> > It's only become clear to me today that the KVM stub calling convention
> > for the host kernel is:
> > 
> > entry:
> > 	r0 = function pointer
> > 	r1 = 32-bit function argument 0
> > 	r2 = 32-bit function argument 1
> > 	r3 = 32-bit function argument 2
> > 	no further arguments are supported
> > 	--- or ---
> > 	r0 = -1 (or 0 post Marc's patch) for get_vectors
> > exit:
> > 	r0 = vectors (if get_vectors call was made)
> > 	otherwise, who knows...
> 
> Hang on, even this is nowhere near the full picture.
> 
> static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
>                                        unsigned long hyp_stack_ptr,
>                                        unsigned long vector_ptr)
> {
>         /*
>          * Call initialization code, and switch to the full blown HYP
>          * code. The init code doesn't need to preserve these
>          * registers as r0-r3 are already callee saved according to
>          * the AAPCS.
>          * Note that we slightly misuse the prototype by casting the
>          * stack pointer to a void *.
> 
>          * The PGDs are always passed as the third argument, in order
>          * to be passed into r2-r3 to the init code (yes, this is
>          * compliant with the PCS!).
>          */
> 
>         kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
> }
> 
> This results in a completely different calling convention -
> 
> 	r0 = hyp_stack_ptr
> 	r1 = vector_ptr
> 	r2,r3 = pgd_ptr
> 
> Which clearly doesn't fit the KVM hypervisor's calling requirements...
> and, looking deeper at this:
> 
>         /* Switch from the HYP stub to our own HYP init vector */
>         __hyp_set_vectors(kvm_get_idmap_vector());
> 
>         pgd_ptr = kvm_mmu_get_httbr();
>         stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
>         hyp_stack_ptr = stack_page + PAGE_SIZE;
>         vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
> 
>         __cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
> 
> So we actually have _another_ hypervisor stub to care about - should
> anything go wrong between __hyp_set_vectors() and __cpu_init_hyp_mode(),
> we will be hitting the __do_hyp_init assembly code with maybe a get
> vectors or soft reboot call, which, reading the code, would be bad
> news.
> 
> Since this code is run at several different times - CPU hotplug (when
> the system will be quiescent) and also cpuidle PM (when the system is
> not quiescent).  With kdump/kexec, I think this could be racy.
> Certainly if anything were to go wrong between the two with a kdump
> kernel in place, we'd be making HVC calls to the KVM init stub and
> expecting them to work.
> 
Indeed it looks like interrupts are enabled during cpu_init_hyp_mode,
and if it's possible to be preempted there or if kdump can be initiated
from interrupt context, this could go wrong, so you're probably right
that we need to support a common hyp-ABI for the kernel hyp stub, the
KVM stub (a.k.a. the trampoline code), and KVM's hyp layer itself.

Thanks,
-Christoffer
