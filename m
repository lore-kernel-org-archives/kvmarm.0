From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 08/18] arm/arm64: KVM: Add PSCI version selection API
Date: Mon, 5 Feb 2018 10:25:24 +0100
Message-ID: <20180205092524.apxjb63b5ymnsh44@hawk.localdomain>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-9-marc.zyngier@arm.com>
 <20180202201706.dj6jmff7lh7bleze@kamzik.brq.redhat.com>
 <20180203115932.24c4bcfb@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180203115932.24c4bcfb@why.wild-wind.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Feb 03, 2018 at 11:59:32AM +0000, Marc Zyngier wrote:
> On Fri, 2 Feb 2018 21:17:06 +0100
> Andrew Jones <drjones@redhat.com> wrote:
> 
> > On Thu, Feb 01, 2018 at 11:46:47AM +0000, Marc Zyngier wrote:
> > > Although we've implemented PSCI 1.0 and 1.1, nothing can select them
> > > Since all the new PSCI versions are backward compatible, we decide to
> > > default to the latest version of the PSCI implementation. This is no
> > > different from doing a firmware upgrade on KVM.
> > > 
> > > But in order to give a chance to hypothetical badly implemented guests
> > > that would have a fit by discovering something other than PSCI 0.2,
> > > let's provide a new API that allows userspace to pick one particular
> > > version of the API.
> > > 
> > > This is implemented as a new class of "firmware" registers, where
> > > we expose the PSCI version. This allows the PSCI version to be
> > > save/restored as part of a guest migration, and also set to
> > > any supported version if the guest requires it.
> > > 
> > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > ---
> > >  Documentation/virtual/kvm/api.txt      |  3 +-
> > >  Documentation/virtual/kvm/arm/psci.txt | 30 +++++++++++++++
> > >  arch/arm/include/asm/kvm_host.h        |  3 ++
> > >  arch/arm/include/uapi/asm/kvm.h        |  6 +++
> > >  arch/arm/kvm/guest.c                   | 13 +++++++
> > >  arch/arm64/include/asm/kvm_host.h      |  3 ++
> > >  arch/arm64/include/uapi/asm/kvm.h      |  6 +++
> > >  arch/arm64/kvm/guest.c                 | 14 ++++++-
> > >  include/kvm/arm_psci.h                 |  9 +++++
> > >  virt/kvm/arm/psci.c                    | 68 +++++++++++++++++++++++++++++++++-
> > >  10 files changed, 151 insertions(+), 4 deletions(-)
> > >  create mode 100644 Documentation/virtual/kvm/arm/psci.txt
> > > 
> > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > index 57d3ee9e4bde..334905202141 100644
> > > --- a/Documentation/virtual/kvm/api.txt
> > > +++ b/Documentation/virtual/kvm/api.txt
> > > @@ -2493,7 +2493,8 @@ Possible features:
> > >  	  and execute guest code when KVM_RUN is called.
> > >  	- KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
> > >  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
> > > -	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
> > > +	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
> > > +          backward compatible with v0.2) for the CPU.
> > >  	  Depends on KVM_CAP_ARM_PSCI_0_2.
> > >  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
> > >  	  Depends on KVM_CAP_ARM_PMU_V3.
> > > diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> > > new file mode 100644
> > > index 000000000000..aafdab887b04
> > > --- /dev/null
> > > +++ b/Documentation/virtual/kvm/arm/psci.txt
> > > @@ -0,0 +1,30 @@
> > > +KVM implements the PSCI (Power State Coordination Interface)
> > > +specification in order to provide services such as CPU on/off, reset
> > > +and power-off to the guest.
> > > +
> > > +The PSCI specification is regularly updated to provide new features,
> > > +and KVM implements these updates if they make sense from a virtualization
> > > +point of view.
> > > +
> > > +This means that a guest booted on two different versions of KVM can
> > > +observe two different "firmware" revisions. This could cause issues if
> > > +a given guest is tied to a particular PSCI revision (unlikely), or if
> > > +a migration causes a different PSCI version to be exposed out of the
> > > +blue to an unsuspecting guest.
> > > +
> > > +In order to remedy this situation, KVM exposes a set of "firmware
> > > +pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> > > +interface. These registers can be saved/restored by userspace, and set
> > > +to a convenient value if required.
> > > +
> > > +The following register is defined:
> > > +
> > > +* KVM_REG_ARM_PSCI_VERSION:
> > > +
> > > +  - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> > > +    (and thus has already been initialized)
> > > +  - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> > > +    highest PSCI version implemented by KVM and compatible with v0.2)
> > > +  - Allows any PSCI version implemented by KVM and compatible with
> > > +    v0.2 to be set with SET_ONE_REG
> > > +  - Affects the whole VM (even if the register view is per-vcpu)  
> > 
> 
> Hi Drew,
> 
> Thanks for looking into this, and for the exhaustive data.
> 
> > 
> > I've put some more thought and experimentation into this. I think we
> > should change to a vcpu feature bit. The feature bit would be used to
> > force compat mode, v0.2, so KVM would still enable the new PSCI
> > version by default. Below are two tables describing why I think we
> > should switch to something other than a new sysreg, and below those
> > tables are notes as to why I think we should use a vcpu feature. The
> > asterisks in the tables point out behaviors that aren't what we want.
> > While both tables have an asterisk, the sysreg approach's issue is
> > bug. The vcpu feature approach's issue is risk incurred from an
> > unsupported migration, albeit one that is hard to detect without a
> > new machine type.
> > 
> >  +-----------------------------------------------------------------------+
> >  |                          sysreg approach                              |
> >  +------------------+-----------+-------+--------------------------------+
> >  | migration        | userspace | works |             notes              |
> >  |                  |  change   |       |                                |
> >  +------------------+-----------+-------+--------------------------------+
> >  | new    -> new    |   NO      |  YES  | Expected                       |
> >  +------------------+-----------+-------+--------------------------------+
> >  | old    -> new    |   NO      |  YES  | PSCI 1.0 is backward compatible|
> >  +------------------+-----------+-------+--------------------------------+
> >  | new    -> old    |   NO      |  NO   | Migration fails due to the new |
> >  |                  |           |       | sysreg. Migration shouldn't    |
> >  |                  |           |       | have been attempted, but no    |
> >  |                  |           |       | way to know without a new      |
> >  |                  |           |       | machine type.                  |
> >  +------------------+-----------+-------+--------------------------------+
> >  | compat -> old    |   YES     |  NO*  | Even when setting PSCI version |
> >  |                  |           |       | to 0.2, we add a new sysreg,   |
> >  |                  |           |       | so migration will still fail.  |
> >  +------------------+-----------+-------+--------------------------------+
> >  | old    -> compat |   YES     |  YES  | It's OK for the destination to |
> >  |                  |           |       | support more sysregs than the  |
> >  |                  |           |       | source sends.                  |
> >  +------------------+-----------+-------+--------------------------------+
> >  
> >  
> >  +-----------------------------------------------------------------------+
> >  |                        vcpu feature approach                          |
> >  +------------------+-----------+-------+--------------------------------+
> >  | migration        | userspace | works |             notes              |
> >  |                  |  change   |       |                                |
> >  +------------------+-----------+-------+--------------------------------+
> >  | new    -> new    |   NO      |  YES  | Expected                       |
> >  +------------------+-----------+-------+--------------------------------+
> >  | old    -> new    |   NO      |  YES  | PSCI 1.0 is backward compatible|
> >  +------------------+-----------+-------+--------------------------------+
> >  | new    -> old    |   NO      |  YES* | Migrates, but it's not safe    |
> >  |                  |           |       | for the guest kernel, and no   |
> >  |                  |           |       | way to know without a new      |
> >  |                  |           |       | machine type.                  |
> >  +------------------+-----------+-------+--------------------------------+
> >  | compat -> old    |   YES     |  YES  | Expected                       |
> >  +------------------+-----------+-------+--------------------------------+
> >  | old    -> compat |   YES     |  YES  | Expected                       |
> >  +------------------+-----------+-------+--------------------------------+
> > 
> > 
> > Notes as to why the vcpu feature approach was selected:
> > 
> > 1) While this is VM state, and thus a VM control would be a more natural
> >    fit, a new vcpu feature bit would be much less new code. We also
> >    already have a PSCI vcpu feature bit, so a new one will actually fit
> >    quite well.
> > 
> > 2) No new state needs to be migrated, as we already migrate the feature
> >    bitmap. Unlike, KVM, QEMU doesn't track the max number of features,
> >    so bumping it one more in KVM doesn't require a QEMU change.
> > 
> > 
> > If we switch to a vcpu feature bit, then I think this patch can be
> > replaced with something like this
> 
> A couple of remarks:
> 
> - My worry with this feature bit  is that it is a point fix, and it
>   doesn't scale. Come PSCI 1.2 and WORKAROUND_2, what do we do? Add
>   another feature bit that says "force to 1.0"? I'd really like
>   something we can live with in the long run, and "KVM as firmware"
>   needs to be able to evolve without requiring a new userspace
>   interface each time we rev it.

You're right. The flag wouldn't be a good pattern for the long term.
I was thinking typically we wouldn't enable new features by default
in KVM, so this choice was geared towards getting mitigations and
compat support done quickly. Christoffer is probably right that we
could just backburn the compat stuff for now though.

> 
> - The "compat->old" entry in your sysreg table is not quite fair. In
>   the feature table, you teach userspace about the new feature bit. You
>   could just as well teach userspace about the new sysreg. Yes, things
>   may be different in QEMU, but that's not what we're talking about
>   here.

Indeed, I should have elaborated on the fact that this is a how QEMU
does it now type of thing. While it would be possible to filter new
registers from the migration stream for the compat version, I guess
that would require much more work, and I was thinking of getting a
userspace solution out quickly after KVM gets these patches merged.
But, again, maybe that's not necessary.

> 
> - Allowing a guest to migrate in an unsafe way seems worse than failing
>   a migration unexpectedly. Or at least not any better.

We could protect the guest by adding kernel support to handle the
exception that old KVM would inject, I think. But, that would be
quite nasty.

> 
> To be clear: I'm not dismissing the idea at all, but I want to make sure
> we're not cornering ourselves into an uncomfortable place.
> 
> Christoffer, Peter, what are your thoughts on this?
>

Thanks,
drew
