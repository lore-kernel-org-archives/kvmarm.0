From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2] arm/arm64: gicv3: support up to 8
 redistributor regions regions
Date: Wed, 5 Sep 2018 12:31:29 +0200
Message-ID: <20180905103129.cu55eksh5a5dldz6@kamzik.brq.redhat.com>
References: <20180904081336.9625-1-drjones@redhat.com>
 <20180904132926.GP4029@e113682-lin.lund.arm.com>
 <20180904143012.lwllebwrvtzhwygd@kamzik.brq.redhat.com>
 <20180905101336.GS4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B22849FA8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 06:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRVYFvR4gdd9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Sep 2018 06:31:35 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05D4349F89
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 06:31:34 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180905101336.GS4029@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 05, 2018 at 12:13:36PM +0200, Christoffer Dall wrote:
> On Tue, Sep 04, 2018 at 04:30:12PM +0200, Andrew Jones wrote:
> > On Tue, Sep 04, 2018 at 03:29:26PM +0200, Christoffer Dall wrote:
> > > On Tue, Sep 04, 2018 at 10:13:36AM +0200, Andrew Jones wrote:
> > > > We need to support at least two redistributor regions in order to
> > > > support more than 123 vcpus (we select 8 because that should be
> > > > plenty). Also bump NR_CPUS to 512, since that's what KVM currently
> > > > supports.
> > > > 
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > ---
> > > > v2:
> > > >  - Peter asked if it would be neater to be more general. At first
> > > >    I interpreted that as better, i.e. more general, but immediately
> > > >    after starting the approach I saw how much _neater_ the code is.
> > > >    So this version is indeed neater code and better (more general).
> > > >    Thanks Peter!
> > > > 
> > > > 
> > > >  lib/arm/asm/gic-v3.h |  3 +++
> > > >  lib/arm/asm/setup.h  |  2 +-
> > > >  lib/arm/gic-v3.c     | 23 +++++++++++++----------
> > > >  lib/arm/gic.c        | 14 +++++++++-----
> > > >  4 files changed, 26 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> > > > index 1dceb9541f62..347be2f9da17 100644
> > > > --- a/lib/arm/asm/gic-v3.h
> > > > +++ b/lib/arm/asm/gic-v3.h
> > > > @@ -49,8 +49,11 @@
> > > >  #include <asm/smp.h>
> > > >  #include <asm/io.h>
> > > >  
> > > > +#define GICV3_NR_REDISTS 8
> > > > +
> > > >  struct gicv3_data {
> > > >  	void *dist_base;
> > > > +	void *redist_bases[GICV3_NR_REDISTS];
> > > >  	void *redist_base[NR_CPUS];
> > > >  	unsigned int irq_nr;
> > > >  };
> > > > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > > > index b57ea13b9dd2..3215814603e4 100644
> > > > --- a/lib/arm/asm/setup.h
> > > > +++ b/lib/arm/asm/setup.h
> > > > @@ -9,7 +9,7 @@
> > > >  #include <asm/page.h>
> > > >  #include <asm/pgtable-hwdef.h>
> > > >  
> > > > -#define NR_CPUS			255
> > > > +#define NR_CPUS			512
> > > >  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
> > > >  extern int nr_cpus;
> > > >  
> > > > diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> > > > index 9b3fa5730478..7f41e0a1da01 100644
> > > > --- a/lib/arm/gic-v3.c
> > > > +++ b/lib/arm/gic-v3.c
> > > > @@ -9,17 +9,20 @@
> > > >  void gicv3_set_redist_base(size_t stride)
> > > >  {
> > > >  	u32 aff = mpidr_compress(get_mpidr());
> > > > -	void *ptr = gicv3_data.redist_base[0];
> > > >  	u64 typer;
> > > > -
> > > > -	do {
> > > > -		typer = gicv3_read_typer(ptr + GICR_TYPER);
> > > > -		if ((typer >> 32) == aff) {
> > > > -			gicv3_redist_base() = ptr;
> > > > -			return;
> > > > -		}
> > > > -		ptr += stride; /* skip RD_base, SGI_base, etc. */
> > > > -	} while (!(typer & GICR_TYPER_LAST));
> > > > +	int i = 0;
> > > > +
> > > > +	while (gicv3_data.redist_bases[i]) {
> > > 
> > > I don't get this.  We never change I?
> > > 
> > > (conincidentally, my test of gicv3-ipi never completes, I wonder if
> > > these concepts are related...)
> > 
> > Darn it. I dropped the '++i' I had in v1. My regression testing naturally
> > only needs i=0 (I don't have anything with > 123 cpus to test on), so the
> > problem didn't show up for me.
> > 
> > Maybe you can add a ++i in and see if it works for you before I send v3?
> > If it's still busted I'll have to stop shotgunning code, and maybe even
> > find a way to test it myself.
> > 
> 
> Indeed, works perfectly.  With an added i++:
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>

Thanks for the additionally testing Christoffer. I'll send v3 after
lunch.

drew
