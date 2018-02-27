From: Christoffer Dall <cdall@kernel.org>
Subject: Re: VCPU hotplug on KVM/ARM
Date: Tue, 27 Feb 2018 13:46:04 +0100
Message-ID: <20180227124604.GA2373@cbox>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6DB4059B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 07:39:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rn3Yfxk+rJ2a for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 07:39:14 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC05140387
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 07:39:13 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id t3so23807933wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 04:46:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: bthakur@codeaurora.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christofferdall@christofferdall.dk>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 27, 2018 at 05:34:28PM +0530, bthakur@codeaurora.org wrote:
> Hi Christoffer,
> 
> Thanks for your reply.
> 
> On 2018-02-27 16:17, Christoffer Dall wrote:
> >Hi Bhupinder,
> >
> >On Tue, Feb 27, 2018 at 03:01:17PM +0530, bthakur@codeaurora.org wrote:
> >>I hope it is the right forum to post my query.
> >>
> >>
> >>
> >>I am currently looking at the possibility of adding a new VCPU to a
> >>running
> >>guest VM in KVM/ARM. I see that currently, it is not allowed to add a
> >>new
> >>VCPU to a guest VM, if it is already initialized. The first check in
> >>kvm_arch_vcpu_create() returns failure if it is already initialized.
> >>
> >
> >This would require a major rework of a lot of logic surrounding the GIC
> >and other parts of KVM initialization.
> >
> >>
> >>
> >>There was some work done in QEMU to add support for VCPU hotplug:
> >>https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html
> >>
> >>
> >>
> >>But I am looking at the KVM side for enabling adding a new VCPU. If you
> >>can
> >>point me to any relevant work/resources, which I can refer to then it
> >>will
> >>help me.
> >>
> >
> >I don't have any specific pointers, but I was always told that the way
> >we were going to do CPU hotplug would be to instantiate a large number
> >of VCPUs, and hotplug would be equivalent to turning on a VCPU which was
> >previously powered off.
> >
> >Is this not still a feasible solution?
> It should be a feasible solution provided the guest VM is not able to
> control the onlining/offlining of VCPUs. It should be controlled by the
> Host.
> 

KVM could simply refuse to turn on some of the CPUs unless given
permission from host userspace.

> >
> >How does VCPU hotplug work on x86?
> On x86, you can add a vcpu through libvirt setvcpu command and it shows up
> in the guest VM as a new CPU if you do lscpu.
> 

Sure, but what is the mechanism, does x86 qemu actually call
KVM_CREATE_VCPU, or is this also a question of turning on already
created vcpus ?

Thanks,
-Christoffer
