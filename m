From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC 21/55] KVM: arm64: Forward HVC instruction to the guest
 hypervisor
Date: Mon, 3 Jul 2017 13:03:51 +0100
Message-ID: <20170703120350.GC1573@arm.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
 <20170222114758.GM26976@cbox>
 <CAHyh4xjG8_dOOe-eqQmAogDHDnQPCUQ-2Kccz9=6NmL0_+9TAA@mail.gmail.com>
 <20170703090850.GG4066@cbox>
 <20170703093156.m3ds2orbjcyooaag@kamzik.brq.redhat.com>
 <20170703095126.GH4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B86940D29
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 08:03:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LgwZ+OqssbJw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 08:03:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D655F40960
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 08:03:34 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170703095126.GH4066@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 03, 2017 at 11:51:26AM +0200, Christoffer Dall wrote:
> On Mon, Jul 03, 2017 at 11:31:56AM +0200, Andrew Jones wrote:
> > On Mon, Jul 03, 2017 at 11:08:50AM +0200, Christoffer Dall wrote:
> > > On Mon, Jun 26, 2017 at 11:21:25AM -0400, Jintack Lim wrote:
> > > > On Wed, Feb 22, 2017 at 6:47 AM, Christoffer Dall <cdall@linaro.org> wrote:
> > > > > On Mon, Jan 09, 2017 at 01:24:17AM -0500, Jintack Lim wrote:
> > > > >> +/* We forward all hvc instruction to the guest hypervisor. */
> > > > >> +int handle_hvc_nested(struct kvm_vcpu *vcpu)
> > > > >> +{
> > > > >> +     return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> > > > >> +}
> > > > >
> > > > > I don't understand the logic here or in the caller above.  Do we really
> > > > > forward *all" hvc calls to the guest hypervisor now, so that we no
> > > > > longer support any hypercalls from the VM?  That seems a little rough
> > > > > and probably requires some more discussions.
> > > > 
> > > > So I think if we run a VM with the EL2 support, then all hvc calls
> > > > from the VM should be forwarded to the virtual EL2.
> > > 
> > > But do we actually check if the guest has EL2 here?  It seems you cann
> > > handle_hvc_nested unconditionally when you have
> > > OCNFIG_KVM_ARM_NESTED_HYP.  I think that's what threw me off when first
> > > reading your patch.
> > > 
> > > > 
> > > > I may miss something obvious, so can you (or anyone) come up with some
> > > > cases that the host hypervisor needs to directly handle hvc from the
> > > > VM with the EL2 support?
> > > > 
> > > 
> > > So I'm a little unsure what to say here.  On one hand you are absolutely
> > > correct, that architecturally if we emulated virtual EL2, then all
> > > hypercalls are handled by the virtual EL2 (even hypercalls from virtual
> > > EL2 which should become self-hypercalls).
> > > 
> > > On the other hand, an enlightened guest may want to use hypercalls to
> > > the hypervisor for some reason, but that would require some numbering
> > > scheme to separate the two concepts.
> > 
> > Yes, I've been thinking that a KVM generic vcpu needs to be enlightened,
> > and to use a hypercall to get the host cpu's errata. If we head down that
> > road, then even a vcpu emulating EL2 would need to be able to this.
> > 
> 
> We could use SMC calls here a well, as the "conduit" as I believe the
> ARM folks are calling it.  We just need to agree somewhere (across
> hypervisors preferably), that when you have virtual EL2, everything is
> via SMC (even upcalls to a host hypervisor), and otherwise it's via HVC.

Does that mean you require the CPU to implement EL3 if you want to use
nested virtualisation?

Will
