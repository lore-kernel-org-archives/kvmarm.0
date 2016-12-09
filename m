From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Fri, 9 Dec 2016 18:17:40 +0100
Message-ID: <20161209171740.h2uozdug3bpbs5lx@hawk.localdomain>
References: <20161208170549.8793-1-drjones@redhat.com>
 <20161208170549.8793-3-drjones@redhat.com>
 <33dc3758-2d3f-c207-8df2-46785af7c47e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285744022C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:16:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdAMzLJVuP1V for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2016 12:16:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 554F740064
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:16:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <33dc3758-2d3f-c207-8df2-46785af7c47e@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 09, 2016 at 10:51:44AM -0600, Wei Huang wrote:
> 
> 
> On 12/08/2016 11:05 AM, Andrew Jones wrote:
> > The TCG PMU is barely implemented for ARM and not at all implemented
> > for AArch64. Let's not bother running the TCG-only tests yet. We'll
> > likely move them to a new TCG-only unittests.cfg at some point before
> > re-enabling them too.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> It is always safe to disable TCG tests, as proposed in this patch.
> However I don't think we need it because PMU will behave correctly after
> your PATCH 1:
> 
> 1. Under TCG AArch32 mode, get_pmu_version() returns 2. This is
> acceptable for pmu-tcg-icount-1 and pmu-tcg-icount-256. We should allow
> the tests to proceed.
> 2. Under TCG AArch64, get_pmu_version() returns 0. pmu-tcg-icount-1 and
> pmu-tcg-icount-256 will skip because pmu_probe() returns FALSE. As long
> as there isn't an error, most people will be OK to see SKIP message.

I find it a bit annoying to be running KVM tests and need to mentally
filter out results (skips or not) for TCG-only tests. I'd rather leave
them off for now. Once we get a tcg-only test running framework in place
we can uncomment them.

Thanks,
drew


> 
> Thanks,
> -Wei
> 
> > ---
> >  arm/unittests.cfg | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 044d97c9e73d..65f9c4c0b9eb 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -65,15 +65,15 @@ file = pmu.flat
> >  groups = pmu
> >  
> >  # Test PMU support (TCG) with -icount IPC=1
> > -[pmu-tcg-icount-1]
> > -file = pmu.flat
> > -extra_params = -icount 0 -append '1'
> > -groups = pmu
> > -accel = tcg
> > +#[pmu-tcg-icount-1]
> > +#file = pmu.flat
> > +#extra_params = -icount 0 -append '1'
> > +#groups = pmu
> > +#accel = tcg
> >  
> >  # Test PMU support (TCG) with -icount IPC=256
> > -[pmu-tcg-icount-256]
> > -file = pmu.flat
> > -extra_params = -icount 8 -append '256'
> > -groups = pmu
> > -accel = tcg
> > +#[pmu-tcg-icount-256]
> > +#file = pmu.flat
> > +#extra_params = -icount 8 -append '256'
> > +#groups = pmu
> > +#accel = tcg
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
