From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Fri, 30 Mar 2018 10:01:04 +0100
Message-ID: <20180330100104.0a49c051@why.wild-wind.fr.eu.org>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
 <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
 <861sg2su98.wl-marc.zyngier@arm.com> <5ABD993A.8030100@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3C3402C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 04:53:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DKKJ+zF3HCIH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Mar 2018 04:52:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 914FE401CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 04:52:55 -0400 (EDT)
In-Reply-To: <5ABD993A.8030100@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 30 Mar 2018 09:56:10 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> On 2018/3/30 0:48, Marc Zyngier wrote:
> > On Thu, 29 Mar 2018 16:27:58 +0100,
> > Mark Rutland wrote:  
> >>
> >> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:  
> >>> From: zhaoshenglong <zhaoshenglong@huawei.com>
> >>>
> >>> Currently the VMID for some VM is allocated during VCPU entry/exit
> >>> context and will be updated when kvm_next_vmid inversion. So this will
> >>> cause the existing VMs exiting from guest and flush the tlb and icache.
> >>>
> >>> Also, while a platform with 8 bit VMID supports 255 VMs, it can create
> >>> more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
> >>> page fault since at some moment two VMs have same VMID.  
> >>
> >> Have you seen this happen?
> >>  
> Yes, we've started 256 VMs on D05. We saw kernel page fault in some guests.

What kind of fault? Kernel configuration? Can you please share some
traces with us? What is the workload? What happens if all the guests are
running on the same NUMA node?

We need all the information we can get.

> 
> >> I beleive that update_vttbr() should prevent this. We intialize
> >> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
> >> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
> >> and by construction we shouldn't be able to allocate the same VMID to
> >> multiple active VMs, regardless of whether we overflow several
> >> times.  
> > 
> > I remember testing that exact scenario when we implemented the VMID
> > rollover a (long) while back. Maybe we've introduced a regression, but
> > we're supposed to support 255 VMs running at the same time (which is
> > not the same as having 255 VMs in total).
> > 
> > Shannon: if you have observed such regression, please let us know.
> >   
> Current approach could allow more than 255 VMs running at the same time.

How??? By definition, it can't.

> It doesn't prevent the extra VMs creating. So at some moment, this will
> be a race that two VMs have same VMID when there are more than 255 VMs.

Creating additional VMs is not an issue as long as we properly:

1) Get a new generation number
2) Stop all the guests
3) invalidate all TLBs

The above should prevent the reuse of a VMID, because all the running
guests have a different generation number, and thus will grab a new one.

If you see two guests with the same VMID, then we have a bug in that
logic somewhere.

> >>  
> >>> This patch uses the bitmap to record which VMID used and available.
> >>> Initialize the VMID and vttbr during creating the VM instead of VCPU
> >>> entry/exit context. Also it will return error to user space if it wants
> >>> to create VMs more than the supporting number.  
> >>
> >> This creates a functional regression for anyone creating a large number
> >> of VMs.  
> > 
> > Indeed, and I'm not buys that approach at all. As I said above, the
> > intent is that we can have up to 2^VMID_SIZE-1 VMs running at the same
> > time, and *any* number of VMs in the system.
> >   
> I think it should not allow more than 255 VMs to create since if there
> are 256 VMs, the VMs will not running properly and will fall in the loop
> to update VMID.

I think you're wrong.

You're trying to paper over a bug. The VMID allocation is designed to
deal with an *infinite* number of VMs, with at most 255 of them running
at any given time. Are you also planning to limit the number of
processes to the ASID capacity? Because that's the exact same problem.

Let's get down to the bottom of the problem instead.

> 
> >> If VMID overflow is a real bottleneck, it would be vastly better to
> >> improve the VMID allocator along the lines of the arm64 ASID allocator,
> >> so that upon overflow we reserve the set of active VMIDs (and therefore
> >> avoid expensive TLB + icache maintenance). That does not require a
> >> global limit on the number of VMs.  
> > 
> > +1.
> >   
> I'll look at the ASID allocator approach.

That's not a useful thing to do right now. The immediate need is to
understand where the current algorithm fails, and to fix it. If the
fixed version proves to be a bottleneck, then we'll investigate it.

In the meantime, fixing this issue should be the number one priority.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
