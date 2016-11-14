From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 07/11] arm/arm64: gicv2:
 add an IPI test
Date: Mon, 14 Nov 2016 15:12:00 +0100
Message-ID: <20161114141200.26dgydd6xwsr3p7z@kamzik.brq.redhat.com>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-8-git-send-email-drjones@redhat.com>
 <53d2bd86-61c6-5717-7bfd-1c6594e3dd43@arm.com>
 <20161111131331.hndvzivzej2mzxiq@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C5840430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2016 09:11:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gb9H0XNEDiUU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2016 09:11:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1141C402EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2016 09:11:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161111131331.hndvzivzej2mzxiq@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 11, 2016 at 02:13:31PM +0100, Andrew Jones wrote:
> On Fri, Nov 11, 2016 at 11:13:46AM +0000, Andre Przywara wrote:
> > Hi,
> > 
> > more a comment loosely related to this patch ...
> > 
> > > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > > index 3f6fa45c587e..68bf5cd6008f 100644
> > > --- a/arm/unittests.cfg
> > > +++ b/arm/unittests.cfg
> > > @@ -54,3 +54,10 @@ file = selftest.flat
> > >  smp = $MAX_SMP
> > >  extra_params = -append 'smp'
> > >  groups = selftest
> > > +
> > > +# Test GIC emulation
> > > +[gicv2-ipi]
> > > +file = gic.flat
> > > +smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> > 
> > So here we always go with the maximum number of VCPUs in the guest.
> > However (as you also noted in your cover-letter) running with a
> > different number of CPUs might be interesting, for instance with less
> > than 8 CPUs on a GICv2 (the ITARGETSR register must be masked) or in
> > general with an odd number (both literally and in the broader sense). I
> > have a test case with passes with 8 VCPUs but fails with less.
> > 
> > Is there any good way to run some tests multiple times with different
> > numbers of VCPUS?
> > Shall we add some "set" functionality to the smp parameter, so that we
> > can specify a list of desired test points?
> >
> 
> We can just add multiple entries, e.g.
> 
> [gicv2-ipi]
> file = gic.flat
> smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> [gicv2-ipi-3]
> file = gic.flat
> smp = $((($MAX_SMP > 3)?3:$MAX_SMP))
> 
> or whatever. But we need to always consider MAX_SMP, since some
> machines may less than 8.
>

Hmm, thinking about this some more, the unit test needs to know how
many processors the test wants, in order to ensure it's testing
correctly. We should provide the number to both -smp and -append,
like we do for selftest-setup.

So, we can have one test that doesn't care, just uses MAX_SMP or 8,
like this patch introduces, but then for each test that does care we
need, e.g.

 smp = 3
 extra_params = '... smp=3 ...'

Then the unit test will start exactly 2 secondaries (or abort if
they're not available)

Anyway, I don't think this is something we should extend the framework
for, but rather address it with unittests.cfg and unit test input
validation.

Thanks,
drew
