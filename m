From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC v2 REPOST] arm64: KVM: KVM API extensions for SVE
Date: Fri, 26 Jan 2018 17:28:49 +0000
Message-ID: <20180126172849.GX5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E6A49DB6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 12:23:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NeuzpjnEYmrs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jan 2018 12:23:25 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF6D49D36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 12:23:25 -0500 (EST)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, libvir-list@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

Reposting this to give people another chance to comment before I move
ahead...

---8<---

Here's a second, slightly more complete stab at the KVM API extensions
for SVE.

I haven't started implementing in earnest yet, so any comments at this
stage would be very helpful.


[libvir-list readers: this is a proposal for extending the KVM API on
AArch64 systems to support the Scalable Vector Extension [1], [2].
This has some interesting configuration and migration quirks -- see
"Vector length control" in particular, and feel free to throw questions
my way...]

Cheers
---Dave

[1] Overview
https://community.arm.com/processors/b/blog/posts/technology-update-the-scalable-vector-extension-sve-for-the-armv8-a-architecture

[2] Architecture spec
https://developer.arm.com/products/architecture/a-profile/docs/ddi0584/latest/arm-architecture-reference-manual-supplement-the-scalable-vector-extension-sve-for-armv8-a


---8<---

New feature KVM_ARM_VCPU_SVE:

 * enables exposure of SVE to the guest

 * enables visibility of / access to KVM_REG_ARM_SVE_*() via KVM reg
   ioctls.  The main purposes of this are a) is to allow userspace to hide
   weird-sized registers that it doesn't understand how to deal with,
   and b) allow SVE to be hidden from the VM so that it can migrate to
   nodes that don't support SVE.

   ZCR_EL1 is not specifically hidden, since it is "just a system register"
   and does not have a weird size or semantics etc.


Registers:

 * A new register size is defined KVM_REG_SIZE_U2048 (which can be
   encoded sensibly using the next unused value for the reg size field
   in the reg ID) (grep KVM_REG_SIZE_).

 * Reg IDs for the SVE regs will be defined as "coproc" 0x14
   (i.e., 0x14 << KVM_REG_ARM_COPROC_SHIFT)

   KVM_REG_ARM_SVE_Z(n, i) is slice i of Zn (each slice is 2048 bits)
   KVM_REG_ARM_SVE_P(n, i) is slice i of Pn (each slice is 256 bits)
   KVM_REG_ARM_FFR(i) is slice i of FFR (each slice is 256 bits)

   The slice sizes allow each register to be read/written in exactly
   one slice for SVE.

   Surplus bits (beyond the maximum VL supported by the vcpu) will
   be read-as-zero write-ignore.

   Reading/writing surplus slices will probably be forbidden, and the
   surplus slices would not be reported via KVM_GET_REG_LIST.
   (We could make these RAZ/WI too, but I'm not sure if it's worth it,
   or why it would be useful.)

   Future extensions to the architecture might grow the registers up
   to 32 slices: this may or may not actually happen, but SVE keeps the
   possibilty open.  I've tried to design for it.

 * KVM_REG_ARM_SVE_Z(n, 0) bits [127:0] alias Vn in
   KVM_REG_ARM_CORE(fp_regs.v[n]) .. KVM_REG_ARM_CORE(fp_regs.v[n])+3.

   It's simplest for userspace if the two views always appear to be
   in sync, but it's unclear whether this is really useful.  Perhaps
   this can be relaxed if it's a big deal for the KVM implementation;
   I don't know yet.


Vector length control:

Some means is needed to determine the set of vector lengths visible
to guest software running on a vcpu.

When a vcpu is created, the set would be defaulted to the maximal set
that can be supported while permitting each vcpu to run on any host
CPU.  SVE has some virtualisation quirks which mean that this set may
exclude some vector lengths that are available for host userspace
applications.  The common case should be that the sets are the same
however.

 * New ioctl KVM_ARM_VCPU_{SET,GET}_SVE_VLS to set or retrieve the set of
   vector lengths available to the guest.

   Adding random vcpu ioctls

   To configure a non-default set of vector lengths,
   KVM_ARM_VCPU_SET_SVE_VLS can be called: this would only be permitted
   before the vcpu is first run.

   This is primarily intended for supporting migration, by providing a
   robust check that the destination node will run the vcpu correctly.
   In a cluster with non-uniform SVE implementation across nodes, this
   also allows a specific set of VLs to be requested that the caller
   knows is usable across the whole cluster.

   For migration purposes, userspace would need to do
   KVM_ARM_VCPU_GET_SVE_VLS at the origin node and store the returned
   set as VM metadata: on the destination node,
   KVM_ARM_VCPU_SET_SVE_VLS should be used to request that exact set of
   VLs: if the destination node can't support that set of VLs, the call
   will fail.

   The interface would look something like:

   ioctl(vcpu_fd, KVM_ARM_SVE_SET_VLS, __u64 vqs[SVE_VQ_MAX / 64]);

   How to expose this to the user in an intelligible way would be a
   problem for userspace to solve.


   At present, other than initialising each vcpu to the maximum
   supportable set of VLs, I don't propose having a way to probe for
   what sets of VLs are supportable: the above call either succeeds or
   fails.


Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
