From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 27/27] KVM: arm64/sve: Document KVM API extensions for
 SVE
Date: Fri, 5 Apr 2019 12:39:37 +0200
Message-ID: <20190405103937.quhaxxwkjjdxab6z@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-28-git-send-email-Dave.Martin@arm.com>
 <20190404210921.7xz6o56wietd77li@kamzik.brq.redhat.com>
 <20190405093617.GO3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7B94A420
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 06:39:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIQdqaNOuRUw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 06:39:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA2494A320
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 06:39:44 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190405093617.GO3567@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 10:36:17AM +0100, Dave Martin wrote:
> On Thu, Apr 04, 2019 at 11:09:21PM +0200, Andrew Jones wrote:
> > On Fri, Mar 29, 2019 at 01:00:52PM +0000, Dave Martin wrote:
> > > This patch adds sections to the KVM API documentation describing
> > > the extensions for supporting the Scalable Vector Extension (SVE)
> > > in guests.
> > > =

> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > =

> > > ---
> > > =

> > > Changes since v5:
> > > =

> > >  * Document KVM_ARM_VCPU_FINALIZE and its interactions with SVE.
> > > ---
> > >  Documentation/virtual/kvm/api.txt | 132 ++++++++++++++++++++++++++++=
+++++++++-
> > >  1 file changed, 129 insertions(+), 3 deletions(-)
> > > =

> > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> > > index cd920dd..68509de 100644
> > > --- a/Documentation/virtual/kvm/api.txt
> > > +++ b/Documentation/virtual/kvm/api.txt
> > > @@ -1873,6 +1873,7 @@ Parameters: struct kvm_one_reg (in)
> > >  Returns: 0 on success, negative value on failure
> > >  Errors:
> > >   =A0ENOENT: =A0=A0no such register
> > > + =A0EPERM: =A0=A0=A0register access forbidden for architecture-depen=
dent reasons
> > >   =A0EINVAL: =A0=A0other errors, such as bad size encoding for a know=
n register
> > >  =

> > >  struct kvm_one_reg {
> > > @@ -2127,13 +2128,20 @@ Specifically:
> > >    0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
> > >    0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
> > >    0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
> > > -  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
> > > -  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
> > > +  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    (*)
> > > +  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    (*)
> > >      ...
> > > -  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
> > > +  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]   (*)
> > >    0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
> > >    0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
> > >  =

> > > +(*) These encodings are not accepted for SVE-enabled vcpus.  See
> > > +    KVM_ARM_VCPU_INIT.
> > > +
> > > +    The equivalent register content can be accessed via bits [127:0]=
 of
> > > +    the corresponding SVE Zn registers instead for vcpus that have S=
VE
> > > +    enabled (see below).
> > > +
> > >  arm64 CCSIDR registers are demultiplexed by CSSELR value:
> > >    0x6020 0000 0011 00 <csselr:8>
> > >  =

> > > @@ -2143,6 +2151,61 @@ arm64 system registers have the following id b=
it patterns:
> > >  arm64 firmware pseudo-registers have the following bit pattern:
> > >    0x6030 0000 0014 <regno:16>
> > >  =

> > > +arm64 SVE registers have the following bit patterns:
> > > +  0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : =
2048*slice]
> > > +  0x6050 0000 0015 04 <n:4> <slice:5>   Pn bits[256*slice + 255 : 25=
6*slice]
> > > +  0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 2=
56*slice]
> > > +  0x6060 0000 0015 ffff                 KVM_REG_ARM64_SVE_VLS pseudo=
-register
> > > +
> > > +Access to slices beyond the maximum vector length configured for the
> > > +vcpu (i.e., where 16 * slice >=3D max_vq (**)) will fail with ENOENT.
> > =

> > I've been doing pretty well keeping track of the 16's, 128's, VL's and
> > VQ's, but this example lost me. Also, should it be >=3D or just > ?
> =

> It should be >=3D.  It's analogous to not being allowed to derefence an
> array index that is >=3D the size of the array.
> =

> Also, the 16 here is not the number of bytes per quadword (as it often
> does with all things SVE), but the number of quadwords per 2048-bit
> KVM register slice.
> =

> To make matters worse (**) resembles some weird C syntax.
> =

> Maybe this would be less confusing written as
> =

>     Access to register IDs where 2048 * slice >=3D 128 * max_vq will fail
>     with ENOENT.  max_vq is the vcpu's maximum supported vector length
>     in 128-bit quadwords: see (**) below.
> =

> Does that help at all?

Yes. Thanks.

> =

> > =

> > > +
> > > +These registers are only accessible on vcpus for which SVE is enable=
d.
> > > +See KVM_ARM_VCPU_INIT for details.
> > > +
> > > +In addition, except for KVM_REG_ARM64_SVE_VLS, these registers are n=
ot
> > > +accessible until the vcpu's SVE configuration has been finalized
> > > +using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).  See KVM_ARM_VCPU_INIT
> > > +and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
> > > +
> > > +KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of ve=
ctor
> > > +lengths supported by the vcpu to be discovered and configured by
> > > +userspace.  When transferred to or from user memory via KVM_GET_ONE_=
REG
> > > +or KVM_SET_ONE_REG, the value of this register is of type __u64[8], =
and
> > > +encodes the set of vector lengths as follows:
> > > +
> > > +__u64 vector_lengths[8];
> > > +
> > > +if (vq >=3D SVE_VQ_MIN && vq <=3D SVE_VQ_MAX &&
> > > +    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
> > > +	/* Vector length vq * 16 bytes supported */
> > > +else
> > > +	/* Vector length vq * 16 bytes not supported */
> > > +
> > > +(**) The maximum value vq for which the above condition is true is
> > > +max_vq.  This is the maximum vector length available to the guest on
> > > +this vcpu, and determines which register slices are visible through
> > > +this ioctl interface.
> > > +
> > > +(See Documentation/arm64/sve.txt for an explanation of the "vq"
> > > +nomenclature.)
> > > +
> > > +KVM_REG_ARM64_SVE_VLS is only accessible after KVM_ARM_VCPU_INIT.
> > > +KVM_ARM_VCPU_INIT initialises it to the best set of vector lengths t=
hat
> > > +the host supports.
> > > +
> > > +Userspace may subsequently modify it if desired until the vcpu's SVE
> > > +configuration is finalized using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_=
SVE).
> > > +
> > > +Apart from simply removing all vector lengths from the host set that
> > > +exceed some value, support for arbitrarily chosen sets of vector len=
gths
> > > +is hardware-dependent and may not be available.  Attempting to confi=
gure
> > > +an invalid set of vector lengths via KVM_SET_ONE_REG will fail with
> > > +EINVAL.
> > > +
> > > +After the vcpu's SVE configuration is finalized, further attempts to
> > > +write this register will fail with EPERM.
> > > +
> > >  =

> > >  MIPS registers are mapped using the lower 32 bits.  The upper 16 of =
that is
> > >  the register group type:
> > > @@ -2197,6 +2260,7 @@ Parameters: struct kvm_one_reg (in and out)
> > >  Returns: 0 on success, negative value on failure
> > >  Errors:
> > >   =A0ENOENT: =A0=A0no such register
> > > + =A0EPERM: =A0=A0=A0register access forbidden for architecture-depen=
dent reasons
> > >   =A0EINVAL: =A0=A0other errors, such as bad size encoding for a know=
n register
> > >  =

> > >  This ioctl allows to receive the value of a single register implemen=
ted
> > > @@ -2690,6 +2754,33 @@ Possible features:
> > >  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
> > >  	  Depends on KVM_CAP_ARM_PMU_V3.
> > >  =

> > > +	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
> > > +	  Depends on KVM_CAP_ARM_SVE.
> > > +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> > > +
> > > +	   * After KVM_ARM_VCPU_INIT:
> > > +
> > > +	      - KVM_REG_ARM64_SVE_VLS may be read using KVM_GET_ONE_REG: the
> > > +	        initial value of this pseudo-register indicates the best se=
t of
> > > +	        vector lengths possible for a vcpu on this host.
> > > +
> > > +	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> > > +
> > > +	      - KVM_RUN and KVM_GET_REG_LIST are not available;
> > > +
> > > +	      - KVM_GET_ONE_REG and KVM_SET_ONE_REG cannot be used to access
> > > +	        the scalable archietctural SVE registers
> > > +	        KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() or
> > > +	        KVM_REG_ARM64_SVE_FFR;
> > > +
> > > +	      - KVM_REG_ARM64_SVE_VLS may optionally be written using
> > > +	        KVM_SET_ONE_REG, to modify the set of vector lengths availa=
ble
> > > +	        for the vcpu.
> > > +
> > > +	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> > > +
> > > +	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and=
 can
> > > +	        no longer be written using KVM_SET_ONE_REG.
> > >  =

> > >  4.83 KVM_ARM_PREFERRED_TARGET
> > >  =

> > > @@ -3904,6 +3995,41 @@ number of valid entries in the 'entries' array=
, which is then filled.
> > >  'index' and 'flags' fields in 'struct kvm_cpuid_entry2' are currentl=
y reserved,
> > >  userspace should not expect to get any particular value there.
> > >  =

> > > +4.119 KVM_ARM_VCPU_FINALIZE
> > > +
> > > +Capability: KVM_CAP_ARM_SVE
> > =

> > The KVM_ARM_VCPU_FINALIZE vcpu ioctl isn't SVE specific, so it shouldn't
> > depend on the SVE cap. It should have it's own cap, or maybe it should
> > just be an KVM_ARM_VCPU_SVE_FINALIZE ioctl instead, i.e. not general.
> =

> This one's a bit annoying.  This would ideally read
> =

> Capability: KVM_CAP_ARM_SVE, or any other capability that advertises the
> availability of a feature that requires KVM_ARM_VCPU_FINALIZE to be used.
> =

> (which sounds vague).
> =

> We could add a specific cap for KVM_ARM_VCPU_FINALIZE, but that seemed
> overkill.  Or document KVM_ARM_VCPU_FINALIZE as unconditionally
> supported, but make the individual feature values cap-dependent.  This
> works because the symptom of missing support is the same (EINVAL)
> ragardless of whether it is the specific feature or
> KVM_ARM_VCPU_FINALIZE that is unsupported.
> =

> Thoughts?
> =


I like that unconditionally supported idea.

> > > +Architectures: arm, arm64
> > > +Type: vcpu ioctl
> > > +Parameters: int feature (in)
> > =

> > This was called 'what' in the code.
> =

> Indeed it is.  I wanted to avoid the implication that this paramter
> exactly maps onto the KVM_ARM_VCPU_INIT features.  But "what" seemed
> a bit too vague for the documentation.
> =

> Mind you, if lseek() can have a "whence" parameter, perhaps "what" is
> also acceptable.
> =

> OTOH I don't mind changing the name in the code to "feature" if you
> think that's preferable.
> =

> Thoughts?

I prefer them to be the same, and I think both are fine.

> =

> > =

> > > +Returns: 0 on success, -1 on error
> > > +Errors:
> > > +  EPERM:     feature not enabled, needs configuration, or already fi=
nalized
> > > +  EINVAL:    unknown feature
> > > +
> > > +Recognised values for feature:
> > > +  arm64      KVM_ARM_VCPU_SVE
> > > +
> > > +Finalizes the configuration of the specified vcpu feature.
> > > +
> > > +The vcpu must already have been initialised, enabling the affected f=
eature, by
> > > +means of a successful KVM_ARM_VCPU_INIT call with the appropriate fl=
ag set in
> > > +features[].
> > > +
> > > +For affected vcpu features, this is a mandatory step that must be pe=
rformed
> > > +before the vcpu is fully usable.
> > > +
> > > +Between KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE, the feature may=
 be
> > > +configured by use of ioctls such as KVM_SET_ONE_REG.  The exact conf=
iguration
> > > +that should be performaned and how to do it are feature-dependent.
> > > +
> > > +Other calls that depend on a particular feature being finalized, suc=
h as
> > > +KVM_RUN, KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will=
 fail with
> > > +-EPERM unless the feature has already been finalized by means of a
> > > +KVM_ARM_VCPU_FINALIZE call.
> > > +
> > > +See KVM_ARM_VCPU_INIT for details of vcpu features that require fina=
lization
> > > +using this ioctl.
> > > +
> > >  5. The kvm_run structure
> > >  ------------------------
> > >
> > =

> > I'm still not sure about EPERM vs. ENOEXEC.
> =

> There is no need to distinguish the two: this is just a generic "vcpu in
> wrong state for this to work" error.  I can't think of another subsystem
> that uses ENOEXEC for this meaning, but it's established in KVM.
> =

> If you can't see a reason why we would need these to be distinct
> errors (?) then I'm happy for this to be ENOEXEC for all cases.
> =


I do see some value in keeping them distinct. I think it's just the use
of EPERM specifically that bothers me, but I don't have that strong of
an opinion against its use either. So I'll just shut up :)

Thanks,
drew
