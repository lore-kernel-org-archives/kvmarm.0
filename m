From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 REPOST] arm64: KVM: KVM API extensions for SVE
Date: Tue, 6 Feb 2018 14:17:57 +0100
Message-ID: <20180206131757.GA23160@cbox>
References: <20180126172849.GX5862@e103592.cambridge.arm.com>
 <20180205161308.GW21802@cbox>
 <20180206114313.GQ5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180206114313.GQ5862@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, libvir-list@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 06, 2018 at 11:43:16AM +0000, Dave Martin wrote:
> On Mon, Feb 05, 2018 at 05:13:08PM +0100, Christoffer Dall wrote:
> > Hi Dave,
> > 
> > On Fri, Jan 26, 2018 at 05:28:49PM +0000, Dave Martin wrote:
> > > New feature KVM_ARM_VCPU_SVE:
> > > 
> > >  * enables exposure of SVE to the guest
> > > 
> > >  * enables visibility of / access to KVM_REG_ARM_SVE_*() via KVM reg
> > >    ioctls.  The main purposes of this are a) is to allow userspace to hide
> > >    weird-sized registers that it doesn't understand how to deal with,
> > >    and b) allow SVE to be hidden from the VM so that it can migrate to
> > >    nodes that don't support SVE.
> > > 
> > >    ZCR_EL1 is not specifically hidden, since it is "just a system register"
> > >    and does not have a weird size or semantics etc.
> > 
> > I think you want to hide ZCR_EL1 if SVE is not enabled, since presenting
> > it to a legacy userspace will prevent migration onto a non-SVE enabled
> > kernel/machine.
> 
> On reflection, I think you're right here.  It makes no sense to half-
> expose SVE.
> 
> > > Registers:
> > > 
> > >  * A new register size is defined KVM_REG_SIZE_U2048 (which can be
> > >    encoded sensibly using the next unused value for the reg size field
> > >    in the reg ID) (grep KVM_REG_SIZE_).
> > > 
> > >  * Reg IDs for the SVE regs will be defined as "coproc" 0x14
> > >    (i.e., 0x14 << KVM_REG_ARM_COPROC_SHIFT)
> > > 
> > >    KVM_REG_ARM_SVE_Z(n, i) is slice i of Zn (each slice is 2048 bits)
> > >    KVM_REG_ARM_SVE_P(n, i) is slice i of Pn (each slice is 256 bits)
> > >    KVM_REG_ARM_FFR(i) is slice i of FFR (each slice is 256 bits)
> > > 
> > 
> > Just so I understand; slice 0 covers all the SVE state as the SVE spec
> > is today.  Additional slices is something we can use in the future in
> > case the SVE spec is expanded to allow even larger vector lengths?  In
> > which case, for a hypothetical 4096 bits register, slice 0 of Zn will be
> > the lower 2048 bits and slice 1 will be the upper 2048 bits?
> 
> Yes.  The architecture leaves the decision about future expansion open.
> It may never happen, but I'm aiming for a design that will accommodate
> it if it does happen.
> 
> Exposing variable-size regs directly through the ioctl interface,
> or growing the ioctl view of the regs much beyond 2048 bits seems
> impractical, so the sliced view seemed reasonable.  In practice, we
> might never need more than one slice anyway.
> 
> > >    The slice sizes allow each register to be read/written in exactly
> > >    one slice for SVE.
> > > 
> > >    Surplus bits (beyond the maximum VL supported by the vcpu) will
> > >    be read-as-zero write-ignore.
> > 
> > This implies that there are some ordering fun to be had between
> > accessing SVE registers and changing the maximum vector length for the
> > vcpu.  Why not loosen the API slightly and say that anything written to
> > the surplus bits is not guaranteed to be preserved when read back?  (In
> > other words, we make no guarantees).
> 
> I'm happy enough to say that, since it may remove some burden from the
> implementation; though only memzeroing so perhaps not too exciting.
> 
> > >    Reading/writing surplus slices will probably be forbidden, and the
> > >    surplus slices would not be reported via KVM_GET_REG_LIST.
> > >    (We could make these RAZ/WI too, but I'm not sure if it's worth it,
> > >    or why it would be useful.)
> > > 
> > >    Future extensions to the architecture might grow the registers up
> > >    to 32 slices: this may or may not actually happen, but SVE keeps the
> > >    possibilty open.  I've tried to design for it.
> > > 
> > >  * KVM_REG_ARM_SVE_Z(n, 0) bits [127:0] alias Vn in
> > >    KVM_REG_ARM_CORE(fp_regs.v[n]) .. KVM_REG_ARM_CORE(fp_regs.v[n])+3.
> > 
> > nit: KVM_REG_ARM_CORE_REG doesn't specify the size, so I think this
> > would be more clearly stated as
> > "aliases KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE(fp_regs.vregs[n])" or as
> > "aliases kvm_regs.regs.fp_regs.vregs[n]".
> 
> I thought the size was effectively hard-coded to be 64 bits for
> KVM_REG_ARM_CORE().  Or did I misunderstand?
> 

It's not.  KVM_REG_ARM_CORE only encodes the 'group' of registers.
Userspace then has to OR on the size.  So the 128 bits FP regs are
accessed with the following logic in QEMU:

  #define AARCH64_SIMD_CORE_REG(x)				\
		(KVM_REG_ARM64 | KVM_REG_SIZE_U128 |		\
                 KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))

  reg.id = AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);

Looking back, the macros in kvm.h are potentially a bit silly, and
should rather have a full AARCH64_SIMD_CORE_REG() definition (maybe we
should add that), but the idea is to use the offset into the kvm
structure as an indication for *which* register to retrieve, and then
encode the size of the register at the same time, and provide a pointer
to a value of the same size, which should avoid any endianness problems
etc.

> > >    It's simplest for userspace if the two views always appear to be
> > >    in sync, but it's unclear whether this is really useful.  Perhaps
> > >    this can be relaxed if it's a big deal for the KVM implementation;
> > >    I don't know yet.
> > 
> > It's not going to be a big deal, and it's the only sensible thing to do;
> > otherwise we'll have no clear semantics of where the values are.  If KVM
> > chooses to duplicate the 128 bits of state in memory, then it must also
> > know how to syncrhonize that duplicated state when running the guest,
> > and therefore can also do this in software on SET/GET.
> 
> I tried to remember my full rationale and describe what the rules
> would be if the two views are allowed to be incoherent ... and
> concluded that you are probably correct.  This also matches the
> architectural view of the registers, which is what users would
> naturally expect.

Some early experiences taught us that anything we expose to user space
should really be as close to the architectural concepts as possible,
otherwise we quickly venture into land of ambiguity, which is a terrible
place to be for a kernel<->userspace ABI.

> 
> Software intentionally modifying the registers would need to know
> about this aliasing, but since software is explicitly required to
> enable the KVM_ARM_VCPU_SVE feature, this shouldn't pose problems
> for backwards compatibility.
> 

Agreed.

> > > Vector length control:
> > > 
> > > Some means is needed to determine the set of vector lengths visible
> > > to guest software running on a vcpu.
> > > 
> > > When a vcpu is created, the set would be defaulted to the maximal set
> > > that can be supported while permitting each vcpu to run on any host
> > > CPU.  SVE has some virtualisation quirks which mean that this set may
> > > exclude some vector lengths that are available for host userspace
> > > applications.  The common case should be that the sets are the same
> > > however.
> > > 
> > >  * New ioctl KVM_ARM_VCPU_{SET,GET}_SVE_VLS to set or retrieve the set of
> > >    vector lengths available to the guest.
> > > 
> > >    Adding random vcpu ioctls
> > > 
> > >    To configure a non-default set of vector lengths,
> > >    KVM_ARM_VCPU_SET_SVE_VLS can be called: this would only be permitted
> > >    before the vcpu is first run.
> > > 
> > >    This is primarily intended for supporting migration, by providing a
> > >    robust check that the destination node will run the vcpu correctly.
> > >    In a cluster with non-uniform SVE implementation across nodes, this
> > >    also allows a specific set of VLs to be requested that the caller
> > >    knows is usable across the whole cluster.
> > > 
> > >    For migration purposes, userspace would need to do
> > >    KVM_ARM_VCPU_GET_SVE_VLS at the origin node and store the returned
> > >    set as VM metadata: on the destination node,
> > >    KVM_ARM_VCPU_SET_SVE_VLS should be used to request that exact set of
> > >    VLs: if the destination node can't support that set of VLs, the call
> > >    will fail.
> > > 
> > >    The interface would look something like:
> > > 
> > >    ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, __u64 vqs[SVE_VQ_MAX / 64]);
> > 
> > I don't understand the proposed semantics here.  What is the vqs array
> > and how should the values be set?
> 
> vqs is a bitmap, where bit (n - 1) indicates support for VL = 128n bits.
> 
> Since the hardware is not required to support all possible vector
> lengths up to the maximum, a bitmap seemed the most straightforward way
> of representing the possibly sparse set of supported VLs.
> 
> Calling it vq_bitmap[] would make this clearer.

Either way, I just think the details need to be spelled out.

> 
> Describing only the maximum supported vl turns out to be insufficient.
> 
> [...]
> 
> > >    At present, other than initialising each vcpu to the maximum
> > >    supportable set of VLs, I don't propose having a way to probe for
> > >    what sets of VLs are supportable: the above call either succeeds or
> > >    fails.
> > > 
> > 
> > I think we should have such a way.  Libvirt can do things like figure
> > out compatible features across nodes, and trying to set all possible
> > vector lengths doesn't seem like a great approach.
> > 
> > How about creating the interface based on a bitmap of all the possible
> > lengths, and setting the bits for all lengths, and reading back the
> > value returns the actual supported lengths?
> 
> Would it be sufficient for an initial call to KVM_ARM_VCPU_GET_SVE_VLS
> to return the default (i.e., maximum supported) set?
> 
> This would mean that once KVM_ARM_VCPU_SET_SVE_VLS has been called to
> set a different set, it would no longer be possible to find out the
> maximum set.  I'm not sure this would matter, though.
> 

I don't particularly like this, because the init sequence in QEMU can be
pretty complicated, and I think it can become pretty nasty to have to
remember if we 'once upon a time' called some ioctl, because then
calling it now will mean something else.

In case my suggestion wasn't clear, this is what I meant:

    #define NR_VQS ((32 * 2048 / 128) / 64)

    __u64 vqs[NR_VQS] = { [0 ... NR_VQS - 1] = ~0 };

    ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, vqs);
    ioctl(vcpu_fd, KVM_ARM_SVE_GET_VLS, vqs);

    for (i = 0; i < 16; i++)
        if (vqs[0] & BIT(i))
            printf("vector length %d supported by KVM\n", (i+1) * 128);


Thanks,
-Christoffer
