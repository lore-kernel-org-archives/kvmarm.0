From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Tue, 10 Jul 2018 08:27:27 -0700
Message-ID: <20180710152727.GA8890@u002843.usa.arm.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
 <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
 <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
 <20180709224836.GA26579@u002843.usa.arm.com>
 <f07199bf-9e31-25ad-72d9-27192c27fccd@redhat.com>
 <20180710103223.GE2656@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F794A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 11:14:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rCX2u+cmBX0x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 11:14:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4CF408AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 11:14:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180710103223.GE2656@work-vm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 10, 2018 at 11:32:24AM +0100, Dr. David Alan Gilbert wrote:
> * Auger Eric (eric.auger@redhat.com) wrote:
> > Hi,
> > 
> > On 07/10/2018 12:48 AM, Christoffer Dall wrote:
> > > On Mon, Jul 09, 2018 at 09:42:40AM +0100, Marc Zyngier wrote:
> > >> On 04/07/18 10:38, Christoffer Dall wrote:
> > >>> Implement the required MMIO accessors for GICv2 and GICv3 for the
> > >>> IGROUPR distributor and redistributor registers.
> > >>>
> > >>> This can allow guests to change behavior compared to running on previous
> > >>> versions of KVM, but only to align with the architecture and hardware
> > >>> implementations.
> > >>>
> > >>> This also allows userspace to configure the groups for interrupts.  Note
> > >>> that this potentially results in GICv2 guests not receiving interrupts
> > >>> after migration if migrating from an older kernel that exposes GICv2
> > >>> interrupts as group 1.
> > >>>
> > >>> Cc: Andrew Jones <drjones@redhat.com>
> > >>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > >>> ---
> > >>> I implemented (but stashed) a version of this which predicated the
> > >>> behavior based on the value of GICD_IIDR revision field, falling back to
> > >>> ignoring writes and resetting GICv2 groups to 0 if the guest wrote a
> > >>> revision less than 2.  However, current QEMU implementations simply
> > >>> don't write the GICD_IIDR, so this doesn't help at all without changing
> > >>> QEMU anyhow.
> > >>>
> > >>> The only actual fix I can see here to work around the problem in the
> > >>> kernel is to require an opt-in to allow restoring groups from userspace,
> > >>> but that's a lot of logic to support cross-kernel version migration.
> > >>>
> > >>> Question: Do we expect that cross-kernel version migration is a critical
> > >>> feature that people really expect to work, and do we actually have
> > >>> examples of catering to this in the kernel elsewhere?  (Also, how would
> > >>> then that relate to the whole 'adding a new sysreg breaks migration'
> > >>> situation?)
> > >>
> > >> I don't really get why QEMU doesn't try to restore GICD_IIDR, while it
> > >> is definitely trying to restore RO sysregs (and that's how we detect
> > >> incompatibilities).
> > >>
> > >> I think we should at least give userspace a chance to do the right
> > >> thing. If it doesn't, well, too bad.
> > > 
> > > This series should give userspace an option to adjust its behavior.
> > > 
> > > My main concern is that this version of the series results in the worst
> > > kind of migration failures, where the guest simply doesn't run on the
> > > destination side with no warnings or error messages returned to the
> > > user..
> > 
> > Adding Dave in the loop to comment about general user perspective.
> 
> Without understanding the details of the GIC, but I have to agree that
> a failure without error where the guest is hung is one of the worst
> cases - when a user comes to you saying that their VM hangs after
> migration with no diagnostics, then you know you're in for some nasty
> debug!
> 
> On other architectures we definitely provide this level of compatibility
> between kernels, libraries, qemu and everything in between - it's not
> easy, and we do screwup from time to time; but it's still what we try
> and get right.

That's good to know.

> 
> So ideally you'd make this switchable and wire it into a versioned
> machine type in QEMU, so that only virt-3.0 VMs would use this (and
> they'd somehow know they needed the new kernel to do it).
> 
> If that's not possible then you could add a subsection to the GIC migration
> data if you can detect at migration time that this feature is being
> used, and make the destination check for the feature/kernel.
> Migrating to an older qemu would fail since it wouldn't know about the
> new subsection.  This should at least get a clear failure.
> 
> For a user, this still gets messy if they do something like start
> upgrading some of the hosts in an openstack cluster, which they often
> do incrementally; so you'll suddenly get the situation of a VM that
> was started on a host with a newer kernel being migrated to an older one
> and stuff breaks.
> 

I think we should ask userspace to opt-in to the new behavior and fix
userspace to save/restore the IIDR while we're at it.

Unless someone objects, I'll try to come up with a v3 that asks
userspace to confirm it wants writable groups.  Ideally I'd like for
this to happen automatically if userspace writes an IIDR with revision 2
and above, but that may result in either

  (1) imposing ordering on the restore sequence from userspace;
      userspace must write IIDR before IGROUPR if it wants non-default
      groups,
  (2) terrible sequence of locking and resetting everything if IIDR
      hasn't been written before time of first executing a VCPU, or
  (3) an additional bookkeeping flag in the critical path for GICv2
      which ignores the group unless userspace wrote IIDR.

Out of the three, I think (3) is the least desirable because it
precludes the guest from programming its own groups.  I'll have a look
at how (2) looks, because it hides everything, and finally we can fall
back to (1) and document it clearly.

Thanks,
Christoffer
