From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Fri, 30 Mar 2018 17:13:39 +0100
Message-ID: <20180330171339.20f2de9d@why.wild-wind.fr.eu.org>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
 <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
 <861sg2su98.wl-marc.zyngier@arm.com> <5ABD993A.8030100@huawei.com>
 <20180330100104.0a49c051@why.wild-wind.fr.eu.org>
 <5ABE08C7.3070105@huawei.com>
 <20180330114837.6ec9db36@why.wild-wind.fr.eu.org>
 <5ABE3EAC.3010602@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5698D401AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 12:05:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z6SelFoJHCAZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Mar 2018 12:05:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30EE64028A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 12:05:29 -0400 (EDT)
In-Reply-To: <5ABE3EAC.3010602@huawei.com>
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

On Fri, 30 Mar 2018 21:42:04 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> On 2018/3/30 18:48, Marc Zyngier wrote:
> > On Fri, 30 Mar 2018 17:52:07 +0800
> > Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> >   
> >>
> >>
> >> On 2018/3/30 17:01, Marc Zyngier wrote:  
> >>> On Fri, 30 Mar 2018 09:56:10 +0800
> >>> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> >>>  
> >>>> On 2018/3/30 0:48, Marc Zyngier wrote:  
> >>>>> On Thu, 29 Mar 2018 16:27:58 +0100,
> >>>>> Mark Rutland wrote:    
> >>>>>>
> >>>>>> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:    
> >>>>>>> From: zhaoshenglong <zhaoshenglong@huawei.com>
> >>>>>>>
> >>>>>>> Currently the VMID for some VM is allocated during VCPU entry/exit
> >>>>>>> context and will be updated when kvm_next_vmid inversion. So this will
> >>>>>>> cause the existing VMs exiting from guest and flush the tlb and icache.
> >>>>>>>
> >>>>>>> Also, while a platform with 8 bit VMID supports 255 VMs, it can create
> >>>>>>> more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
> >>>>>>> page fault since at some moment two VMs have same VMID.    
> >>>>>>
> >>>>>> Have you seen this happen?
> >>>>>>    
> >>>> Yes, we've started 256 VMs on D05. We saw kernel page fault in some guests.  
> >>>
> >>> What kind of fault? Kernel configuration? Can you please share some
> >>> traces with us? What is the workload? What happens if all the guests are
> >>> running on the same NUMA node?
> >>>
> >>> We need all the information we can get.
> >>>  
> >> All 256 VMs run without special workload. The testcase is just starting
> >> 256 VMs and then shutting down them. We found several VMs will not
> >> shutdown since the guest kernel crash. While if we only start 255 VMs,
> >> it works well.
> >>
> >> We didn't run the testcase that pins all VMs to the same NUMA node. I'll
> >> try.
> >>
> >> The fault is
> >> [ 2204.633871] Unable to handle kernel NULL pointer dereference at
> >> virtual address 00000008
> >> [ 2204.633875] Unable to handle kernel paging request at virtual address
> >> a57f4a9095032
> >>
> >> Please see the attachment for the detailed log.  
> > 
> > Thanks. It looks pretty ugly indeed.
> > 
> > Can you please share your host kernel config (and version number -- I
> > really hope the host is something more recent than the 4.1.44 stuff you
> > run as a guest...)?
> >   
> We do run a 4.1.44 host kernel but with more recently KVM module(at
> least 4.14) since we backport upstream KVM ARM patches to our kernel tree.

Can you please reproduce it with a mainline kernel? I'm not going to
even try to reproduce this issue on a kernel that has been that heavily
hacked.

> See the attachment for the kernel config.
> 
> > For the record, I'm currently running 5 concurrent Debian installs,
> > each with 2 vcpus, on a 4 CPU system artificially configured to have
> > only 2 bits of VMID (and thus at most 3 running VMs at any given time),
> > a setup that is quite similar to what you're doing, only on a smaller
> > scale.
> > 
> > It is pretty slow (as you'd expect), but so far I haven't seen any
> > issue.
> >   
> Could you try to shutdown all VMs at the same time? The issue we
> encounter happened at the shutdown step.

Halted the VMs just fine, no issue.

	M.
-- 
Without deviation from the norm, progress is not possible.
