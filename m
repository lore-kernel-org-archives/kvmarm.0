From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [RFC] [PATCH] kvm: arm: Introduce error code
 KVM_EINVARIANT
Date: Mon, 12 Nov 2018 11:09:39 +0100
Message-ID: <20181112100939.vro42goghcv7v6l2@kamzik.brq.redhat.com>
References: <1540290099-146109-1-git-send-email-mjaggi@caviumnetworks.com>
 <4bbb4e76-b714-eafe-f95b-aca1a258e9fe@caviumnetworks.com>
 <86o9avetgz.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA004A328
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Nov 2018 05:09:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6MpH6JXQMPo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Nov 2018 05:09:47 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E29FE4A310
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Nov 2018 05:09:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <86o9avetgz.wl-marc.zyngier@arm.com>
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
Cc: "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>, "quintela@redhat.com" <quintela@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Manish Jaggi <mjaggi@caviumnetworks.com>, Will Deacon <will.deacon@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Jaggi, Manish" <Manish.Jaggi@cavium.com>, "Nowicki,
 Tomasz" <Tomasz.Nowicki@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "dgilbert@redhat.com" <dgilbert@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Nov 11, 2018 at 11:36:44AM +0000, Marc Zyngier wrote:
> On Sat, 10 Nov 2018 22:18:47 +0000,
> Manish Jaggi <mjaggi@caviumnetworks.com> wrote:
> > 
> > 
> > CCing a larger audience.
> > Please review.
> > 
> > On 10/23/2018 03:51 PM, Jaggi, Manish wrote:
> > > From: Manish Jaggi <manish.jaggi@cavium.com>
> > >
> > > This patch introduces an error code KVM_EINVARIANT which is returned
> > > by KVM when userland tries to set an invariant register.
> > >
> > > The need for this error code is in VM Migration for arm64.
> > > ARM64 systems use mainly -machine virt -cpu host as parameter to qemu.
> > > Migration requires both Source and destination machines to have same
> > > physical cpu. There are cases where the overall architecture of CPU is
> > > same but the next version of the chip with some bug fixes which have no
> > > effect on qemu operation. In such cases invariant registers like MIDR
> > > have a different value.
> > > Currently Migration fails in such cases.
> > >
> > > Rather than sending a EINVAL, a specifc error code will help
> > > userland program the guest invariant register by querying the migrated
> > > host machines invariant registers.
> 
> But failing migration is a good thing, right? How do you expect that
> the guest will be happy to see a new CPU revision right in the middle
> of its execution? Do you also propose that QEMU starts doing that for
> big-little systems? After all, if ignoring the differences in some
> registers is harmless for migration, surely that should be the case in
> a single system, right?
> 
> > >
> > > Qemu will have a parameter -hostinvariant along with checking of this
> > > error code. So it can be safely assumed that the feature is opt-in
> 
> You're changing the ABI without any buy in from userspace, which is
> not acceptable.
> 
> As it stands, this patch creates a number of issues without solving
> any. Things to think about:
> 
> - How does errata management works when migrating to a different
>   system?
> - big-little, as mentioned above
> - Are all invariant registers equal? A different MIDR has the same
>   effect as a different MMFR0?
> 
> Instead of papering over architectural constants i a system, how about
> allowing the relevant ID registers to be overloaded when not
> incompatible?
> 

In QEMU, I think we need nail down how we define '-cpu host' for kvmarm.
IMO, '-cpu host' is what libvirt calls "host-passthrough"[*], and indeed
migrating a guest using host-passthrough is super risky. You need to
know what you're doing, and likely what you'll want to do is migrate to
an _identical_ host. We should start looking at building cpu models to
better support migration, but errata complicates that. However, for the
sake of argument, let's assume we solved those problems and completed the
implementation of cpu models - so we would no longer be using '-cpu host'
for a "typical" config. So what would '-cpu host' mean? It appears the
current semantics are "source host passthrough", similar to
"host-model"[*]. Rather than "whatever host I'm running on host
passthrough", which is what I think we want and what this patch and the
QEMU counterpart changes seem to be aiming at implementing. Anyway,
whichever of those two semantics we choose for '-cpu host', the user will
still need to know what they're doing and to assume the risks. Without
cpu models, I'm not even sure discussing migration safety makes sense.

(Yeah, I know I ignored big-little. IMO, big-little is an upper layer
problem, as it should just be a vcpu thread to cpu set affinity
assignment issue.)

Thanks,
drew

[*] https://wiki.openstack.org/wiki/LibvirtXMLCPUModel
