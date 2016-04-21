From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH] arm64: KVM: Allow userspace to configure guest
 MPIDR_EL1
Date: Thu, 21 Apr 2016 11:56:03 +0200
Message-ID: <20160421095603.s7dhtwpy36nlbr2l@hawk.localdomain>
References: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
 <20160420183354.31f1bfbd@arm.com>
 <20160421070447.nwuqlxvpq7fj6h7m@hawk.localdomain>
 <57189C84.8080206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC7F49B49
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 05:54:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mvb1l9YglfUv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2016 05:54:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 957EA49B3D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 05:54:06 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <57189C84.8080206@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, shannon.zhao@linaro.org, Ashok Kumar <ashoks@broadcom.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 21, 2016 at 10:25:24AM +0100, Marc Zyngier wrote:
> Hey Andrew,
> 
> On 21/04/16 08:04, Andrew Jones wrote:
> > On Wed, Apr 20, 2016 at 06:33:54PM +0100, Marc Zyngier wrote:
> >> On Wed, 20 Apr 2016 07:08:39 -0700
> >> Ashok Kumar <ashoks@broadcom.com> wrote:
> >>
> >>> For guests with NUMA configuration, Node ID needs to
> >>> be recorded in the respective affinity byte of MPIDR_EL1.
> >>
> >> As others have said before, the mapping between the NUMA hierarchy and
> >> MPIDR_EL1 are completely arbitrary, and only the firmware description
> >> can help the kernel in interpreting the affinity levels.
> >>
> >> If you want any patch like this one to be considered, I'd like to see
> >> the corresponding userspace that:
> >>
> >> - programs the affinity into the vcpus,
> > 
> > I have a start on this for QEMU that I can dust off and send as an RFC
> > soon.
> > 
> >> - pins the vcpus to specific physical CPUs,
> > 
> > This wouldn't be part of the userspace directly interacting with KVM,
> > but rather a higher level (even higher than libvirt, e.g.
> > openstack/ovirt). I also don't think we should need to worry about
> > which/how the phyiscal cpus get chosen. Let's assume that entity
> > knows how to best map the guest's virtual topology to a physical one.
> 
> Surely the platform emulation userspace has to implement the pinning
> itself, because I can't see high level tools being involved in the
> creation of the vcpu threads themselves.

The pinning comes after the threads are created, but before they are
run. The virtual topology created for a guest may or may not map well
to the physical topology of a given host. That's not the problem of
the emulation though. That's a problem of a high level application
trying to fit it.

> 
> Also, I'd like to have a "simple" tool to test this without having to
> deploy openstack (the day this becomes mandatory for kernel development,
> I'll move my carrier to something more... agricultural).
> 
> So something in QEMU would be really good...
> 

To test the virtual topology only requires booting a guest, whether
the vcpus are pinned or not. To test that it was worth the effort to
create a virtual topology does require the pinning, and the perf
measuring. However we still don't need the pinning in QEMU. We can
start a guest paused, run a script that does a handful of tasksets,
and then resumes the guest. Or, just use libvirt, which allows one
to save vcpu affinities, and thus on guest launch it will automatically
do the affinity setting for you.

> > 
> >> - exposes the corresponding firmware description (either DT or ACPI) to
> >>   the kernel.
> > 
> > The QEMU patches I've started on already generate the DT (the cpu-map
> > node). I started looking into how to do it for ACPI too, but there
> > were some questions about whether or not the topology description
> > tables added to the 6.1 spec were sufficient. I can send the DT part
> > soon, and continue to look into the ACPI part later though.
> 
> That'd be great. Can you please sync with Ashok so that we have
> something consistent between the two of you?

Yup. I'm hoping Ashok will chime in to share any userspace status
they have.

Thanks,
drew
