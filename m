From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [libvirt] [RFC v2 REPOST] arm64: KVM: KVM API extensions for SVE
Date: Wed, 7 Feb 2018 11:33:28 +0000
Message-ID: <20180207113327.GN5862@e103592.cambridge.arm.com>
References: <20180126172849.GX5862@e103592.cambridge.arm.com>
	<20180205161308.GW21802@cbox>
	<20180206114313.GQ5862@e103592.cambridge.arm.com>
	<20180206131757.GA23160@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <libvir-list-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180206131757.GA23160@cbox>
List-Unsubscribe: <https://www.redhat.com/mailman/options/libvir-list>,
	<mailto:libvir-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/libvir-list>
List-Post: <mailto:libvir-list@redhat.com>
List-Help: <mailto:libvir-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/libvir-list>,
	<mailto:libvir-list-request@redhat.com?subject=subscribe>
Sender: libvir-list-bounces@redhat.com
Errors-To: libvir-list-bounces@redhat.com
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, libvir-list@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 06, 2018 at 02:17:57PM +0100, Christoffer Dall wrote:
> On Tue, Feb 06, 2018 at 11:43:16AM +0000, Dave Martin wrote:
> > On Mon, Feb 05, 2018 at 05:13:08PM +0100, Christoffer Dall wrote:
> > > Hi Dave,
> > > 
> > > On Fri, Jan 26, 2018 at 05:28:49PM +0000, Dave Martin wrote:

[...]

> > Exposing variable-size regs directly through the ioctl interface,
> > or growing the ioctl view of the regs much beyond 2048 bits seems
> > impractical, so the sliced view seemed reasonable.  In practice, we
> > might never need more than one slice anyway.
> > 
> > > >    The slice sizes allow each register to be read/written in exactly
> > > >    one slice for SVE.
> > > > 
> > > >    Surplus bits (beyond the maximum VL supported by the vcpu) will
> > > >    be read-as-zero write-ignore.
> > > 
> > > This implies that there are some ordering fun to be had between
> > > accessing SVE registers and changing the maximum vector length for the
> > > vcpu.  Why not loosen the API slightly and say that anything written to
> > > the surplus bits is not guaranteed to be preserved when read back?  (In
> > > other words, we make no guarantees).
> > 
> > I'm happy enough to say that, since it may remove some burden from the
> > implementation; though only memzeroing so perhaps not too exciting.

[...]

> > > >  * KVM_REG_ARM_SVE_Z(n, 0) bits [127:0] alias Vn in
> > > >    KVM_REG_ARM_CORE(fp_regs.v[n]) .. KVM_REG_ARM_CORE(fp_regs.v[n])+3.
> > > 
> > > nit: KVM_REG_ARM_CORE_REG doesn't specify the size, so I think this
> > > would be more clearly stated as
> > > "aliases KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE(fp_regs.vregs[n])" or as
> > > "aliases kvm_regs.regs.fp_regs.vregs[n]".
> > 
> > I thought the size was effectively hard-coded to be 64 bits for
> > KVM_REG_ARM_CORE().  Or did I misunderstand?
> > 
> 
> It's not.  KVM_REG_ARM_CORE only encodes the 'group' of registers.
> Userspace then has to OR on the size.  So the 128 bits FP regs are
> accessed with the following logic in QEMU:
> 
>   #define AARCH64_SIMD_CORE_REG(x)				\
> 		(KVM_REG_ARM64 | KVM_REG_SIZE_U128 |		\
>                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
> 
>   reg.id = AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
> 
> Looking back, the macros in kvm.h are potentially a bit silly, and
> should rather have a full AARCH64_SIMD_CORE_REG() definition (maybe we
> should add that), but the idea is to use the offset into the kvm
> structure as an indication for *which* register to retrieve, and then
> encode the size of the register at the same time, and provide a pointer
> to a value of the same size, which should avoid any endianness problems
> etc.

After another look at arch/arm64/kvm/guest.c:get_core_reg(), I get
this now.

> > > >    It's simplest for userspace if the two views always appear to be
> > > >    in sync, but it's unclear whether this is really useful.  Perhaps
> > > >    this can be relaxed if it's a big deal for the KVM implementation;
> > > >    I don't know yet.
> > > 
> > > It's not going to be a big deal, and it's the only sensible thing to do;
> > > otherwise we'll have no clear semantics of where the values are.  If KVM
> > > chooses to duplicate the 128 bits of state in memory, then it must also
> > > know how to syncrhonize that duplicated state when running the guest,
> > > and therefore can also do this in software on SET/GET.
> > 
> > I tried to remember my full rationale and describe what the rules
> > would be if the two views are allowed to be incoherent ... and
> > concluded that you are probably correct.  This also matches the
> > architectural view of the registers, which is what users would
> > naturally expect.
> 
> Some early experiences taught us that anything we expose to user space
> should really be as close to the architectural concepts as possible,
> otherwise we quickly venture into land of ambiguity, which is a terrible
> place to be for a kernel<->userspace ABI.

Agreed!

> > Software intentionally modifying the registers would need to know
> > about this aliasing, but since software is explicitly required to
> > enable the KVM_ARM_VCPU_SVE feature, this shouldn't pose problems
> > for backwards compatibility.
> > 
> 
> Agreed.
> 
> > > > Vector length control:

[...]

> > > >    ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, __u64 vqs[SVE_VQ_MAX / 64]);
> > > 
> > > I don't understand the proposed semantics here.  What is the vqs array
> > > and how should the values be set?
> > 
> > vqs is a bitmap, where bit (n - 1) indicates support for VL = 128n bits.
> > 
> > Since the hardware is not required to support all possible vector
> > lengths up to the maximum, a bitmap seemed the most straightforward way
> > of representing the possibly sparse set of supported VLs.
> > 
> > Calling it vq_bitmap[] would make this clearer.
> 
> Either way, I just think the details need to be spelled out.

Sure.  This won't be the final documentation, but I'll bear it in
mind.  The vq bitmap concept is the same as used to track the supported
vector lengths in fpsimd.c, but sane people are probably not aware of
that.

> > Describing only the maximum supported vl turns out to be insufficient.
> > 
> > [...]
> > 
> > > >    At present, other than initialising each vcpu to the maximum
> > > >    supportable set of VLs, I don't propose having a way to probe for
> > > >    what sets of VLs are supportable: the above call either succeeds or
> > > >    fails.
> > > > 
> > > 
> > > I think we should have such a way.  Libvirt can do things like figure
> > > out compatible features across nodes, and trying to set all possible
> > > vector lengths doesn't seem like a great approach.
> > > 
> > > How about creating the interface based on a bitmap of all the possible
> > > lengths, and setting the bits for all lengths, and reading back the
> > > value returns the actual supported lengths?
> > 
> > Would it be sufficient for an initial call to KVM_ARM_VCPU_GET_SVE_VLS
> > to return the default (i.e., maximum supported) set?
> > 
> > This would mean that once KVM_ARM_VCPU_SET_SVE_VLS has been called to
> > set a different set, it would no longer be possible to find out the
> > maximum set.  I'm not sure this would matter, though.
> > 
> 
> I don't particularly like this, because the init sequence in QEMU can be
> pretty complicated, and I think it can become pretty nasty to have to
> remember if we 'once upon a time' called some ioctl, because then
> calling it now will mean something else.
> 
> In case my suggestion wasn't clear, this is what I meant:
> 
>     #define NR_VQS ((32 * 2048 / 128) / 64)
> 
>     __u64 vqs[NR_VQS] = { [0 ... NR_VQS - 1] = ~0 };
> 
>     ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, vqs);
>     ioctl(vcpu_fd, KVM_ARM_SVE_GET_VLS, vqs);
> 
>     for (i = 0; i < 16; i++)
>         if (vqs[0] & BIT(i))
>             printf("vector length %d supported by KVM\n", (i+1) * 128);

This does mean that if the caller doesn't get the set they asked for
in KVM_ARM_SVE_SET_VLS this is not treated as an error by the kernel.  I
was concerned this would encourage userspace to silently miss this
error.

What if KVM_ARM_SVE_SET_VLS() were to yield 0 if the exact requested set
of VLs was configured, -ERANGE if some subset was configured successfully
(but not exactly the set requested), and the usual -EINVAL/-EIO/whatever
if the set of VLs couldn't be configured at all?

Then the probe would go like this:

	__u64 vqs[SVE_VQ_MAX / 64] = { [0 ... SVE_VQ_MAX / 64 - 1] = ~(u64)0 };
	if (ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, vqs) && errno != ERANGE))
		goto error;

	ioctl(vcpu_fd, KVM_ARM_SVE_GET_VLS, vqs);

	/* ... */

Another option would be for SVE_ARM_SVE_SET_VLS to write the resulting
set back to its argument, possibly with the same 0/ERANGE/EINVAL semantics.


Alternatively, userspace would be require to do a KVM_ARM_SVE_GET_VLS,
and check the resulting set:

	/* ... */
	
	__u64 newvqs[SVE_VQ_MAX / 64];
	ioctl(vcpu_fd, KVM_ARM_SVE_GET_VLS, newvqs);

	if (memcmp(vqs, newvqs, sizeof vqs))
		goto mismatch;

vcpu restore would need to treat any mismatch as an error:
the exact requested set but be configurable, or the VM may go wrong.


Any opinion on which approach is best?

I was fighting with this in December, trying to come up with a way
for userspace to specify which VLs it requires/permits/forbids and
letting the kernel come up with something matching these constraints.
But this seemed too expressive and complex, so I had dropped the idea
in favour of something simpler.

Cheers
---Dave
