From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH kvm-unit-tests] scripts: Speedup MAX_SMP check
Date: Mon, 3 Sep 2018 15:13:02 +0200
Message-ID: <20180903131302.GK4029@e113682-lin.lund.arm.com>
References: <20180903105845.13942-1-christoffer.dall@arm.com>
 <20180903122550.7js3albkzcmej6i4@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E184A1E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:13:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6t8MVbvgwg5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 09:13:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C804A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:13:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180903122550.7js3albkzcmej6i4@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 02:25:50PM +0200, Andrew Jones wrote:
> On Mon, Sep 03, 2018 at 12:58:45PM +0200, Christoffer Dall wrote:
> > The current MAX_SMP check launches QEMU for every value of the SMP
> > parameter to check if the SMP parameter based on the native is higher
> > than the QEMU maximum supported configuration.
> > 
> > On something like a TX2, which has 224 threads, this takes a very long
> > time where the test script just sits there with no output.
> > 
> > Reduce the wait time by taking the log2 of MAX_SMP in each iteration of
> > the loop instead.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  scripts/runtime.bash | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index a31ae91..1e2c288 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -140,5 +140,5 @@ function run()
> >  # just remove it...
> >  while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> >  		|& grep -qi 'exceeds max CPUs'; do
> > -	((--MAX_SMP))
> > +	MAX_SMP=$((MAX_SMP >> 1))
> >  done
> > -- 
> > 2.7.4
> >
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> 
> Someday I should move this into arch-specific code and replace
> it with something like:
> 
> if gic-v3
>   MAX_SMP = MIN(_SC_NPROCESSORS_ONLN, 255)

Not quite, becasue QEMU can't seem to support more than 123 CPUs with it
current default set of parameters used by kvmtool at least.  But perhaps
that's being fixed with some changes to QEMU/KVM (I lost track).

Thanks for the reviews.

    Christoffer



> else
>   MAX_SMP = MIN(_SC_NPROCESSORS_ONLN, 8)
> 
> If other archs ever care about it (they currently don't), then
> they can implement their own thing.
> 
