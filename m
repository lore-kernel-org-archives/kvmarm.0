From: Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Qemu-devel] VCPU hotplug on KVM/ARM
Date: Thu, 1 Mar 2018 10:50:30 +0100
Message-ID: <20180301105030.2b716e68@redhat.com>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
 <20180227124604.GA2373@cbox>
 <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C6F49E00
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 04:44:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Huqq4Z1R6DbD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 04:43:42 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BA5642121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 04:43:41 -0500 (EST)
In-Reply-To: <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, qemu-devel@nongnu.org, Christoffer Dall <christofferdall@christofferdall.dk>, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 27 Feb 2018 14:21:31 +0100
Andrew Jones <drjones@redhat.com> wrote:

> On Tue, Feb 27, 2018 at 01:46:04PM +0100, Christoffer Dall wrote:
> > On Tue, Feb 27, 2018 at 05:34:28PM +0530, bthakur@codeaurora.org wrote:  
> > > Hi Christoffer,
> > > 
> > > Thanks for your reply.
> > > 
> > > On 2018-02-27 16:17, Christoffer Dall wrote:  
> > > >Hi Bhupinder,
> > > >
> > > >On Tue, Feb 27, 2018 at 03:01:17PM +0530, bthakur@codeaurora.org wrote:  
> > > >>I hope it is the right forum to post my query.
> > > >>
> > > >>
> > > >>
> > > >>I am currently looking at the possibility of adding a new VCPU to a
> > > >>running
> > > >>guest VM in KVM/ARM. I see that currently, it is not allowed to add a
> > > >>new
> > > >>VCPU to a guest VM, if it is already initialized. The first check in
> > > >>kvm_arch_vcpu_create() returns failure if it is already initialized.
> > > >>  
> > > >
> > > >This would require a major rework of a lot of logic surrounding the GIC
> > > >and other parts of KVM initialization.
> > > >  
> > > >>
> > > >>
> > > >>There was some work done in QEMU to add support for VCPU hotplug:
> > > >>https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html
> > > >>
> > > >>
> > > >>
> > > >>But I am looking at the KVM side for enabling adding a new VCPU. If you
> > > >>can
> > > >>point me to any relevant work/resources, which I can refer to then it
> > > >>will
> > > >>help me.
> > > >>  
> > > >
> > > >I don't have any specific pointers, but I was always told that the way
> > > >we were going to do CPU hotplug would be to instantiate a large number
> > > >of VCPUs, and hotplug would be equivalent to turning on a VCPU which was
> > > >previously powered off.
> > > >
> > > >Is this not still a feasible solution?  
> > > It should be a feasible solution provided the guest VM is not able to
> > > control the onlining/offlining of VCPUs. It should be controlled by the
> > > Host.
> > >   
> > 
> > KVM could simply refuse to turn on some of the CPUs unless given
> > permission from host userspace.
> >   
> > > >
> > > >How does VCPU hotplug work on x86?  
> > > On x86, you can add a vcpu through libvirt setvcpu command and it shows up
> > > in the guest VM as a new CPU if you do lscpu.
> > >   
> > 
> > Sure, but what is the mechanism, does x86 qemu actually call
> > KVM_CREATE_VCPU, or is this also a question of turning on already
> > created vcpus ?
In QEMU on x86 (and I think ppc, s390 as well), we create vCPUs on demand.

It would be nice if ARM would be able to do that too,
so that it could take advantage of the same code.

 
> CC'ing Igor and qemu-devel
> 
> drew
> 
