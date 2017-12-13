From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC v2] arm64: KVM: KVM API extensions for SVE
Date: Wed, 13 Dec 2017 17:11:01 +0000
Message-ID: <20171213171101.GP22781@e103592.cambridge.arm.com>
References: <20171213165543.GO22781@e103592.cambridge.arm.com>
 <CAFEAcA-Rogf9m7GMPD3PKs7miEpx-bMMn72Y+2=eF4oiCdLqqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E87BA406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 12:07:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yO5IrrVuoql4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 12:07:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE6B40651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 12:07:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-Rogf9m7GMPD3PKs7miEpx-bMMn72Y+2=eF4oiCdLqqw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Libvirt <libvir-list@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 13, 2017 at 04:58:16PM +0000, Peter Maydell wrote:
> On 13 December 2017 at 16:55, Dave Martin <Dave.Martin@arm.com> wrote:
> > Vector length control:
> >
> > Some means is needed to determine the set of vector lengths visible
> > to guest software running on a vcpu.
> >
> > When a vcpu is created, the set would be defaulted to the maximal set
> > that can be supported while permitting each vcpu to run on any host
> > CPU.  SVE has some virtualisation quirks which mean that this set may
> > exclude some vector lengths that are available for host userspace
> > applications.  The common case should be that the sets are the same
> > however.
> >
> >  * New ioctl KVM_ARM_VCPU_{SET,GET}_SVE_VLS to set or retrieve the set of
> >    vector lengths available to the guest.
> >
> >    Adding random vcpu ioctls
> >
> >    To configure a non-default set of vector lengths,
> >    KVM_ARM_VCPU_SET_SVE_VLS can be called: this would only be permitted
> >    before the vcpu is first run.
> >
> >    This is primarily intended for supporting migration, by providing a
> >    robust check that the destination node will run the vcpu correctly.
> >    In a cluster with non-uniform SVE implementation across nodes, this
> >    also allows a specific set of VLs to be requested that the caller
> >    knows is usable across the whole cluster.
> >
> >    For migration purposes, userspace would need to do
> >    KVM_ARM_VCPU_GET_SVE_VLS at the origin node and store the returned
> >    set as VM metadata: on the destination node,
> >    KVM_ARM_VCPU_SET_SVE_VLS should be used to request that exact set of
> >    VLs: if the destination node can't support that set of VLs, the call
> >    will fail.
> 
> Can we just do this with the existing ONE_REG APIs? If you
> expose this via those, then QEMU doesn't need to do anything
> for migration at all. This is the same way we (intend to)
> check any optional-feature compatibility at each end, for
> instance features exposed in guest-visible ID registers.
> It's just that the "register" for the SVE vector-lengths case
> is one that's not visible to the guest.

Probably, but there are some things that are a bit nasty.
For now, I suggested an ioctl as being minimally invasive on the
kernel side, but I'm not committed to it.


The set of vector lengths is a not guest register in the usual sense,
and modifying it at runtime makes no sense, so I would rather forbid
it.  Do we have precedent for that?  I was getting pushback from
Marc and/or Christoffer on exposing "ZCR_EL2" via the reg interface for
similar reasons -- that turned out to be too simplistic for other
reasons anyway.

Also, arranging things so that it doesn't matter which order the
SVE regs and VL set are written with respect to one another may
add significant complexity to KVM which I'd rather avoid.

Cheers
---Dave
