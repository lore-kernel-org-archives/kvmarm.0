From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v13 01/20] ARM64: Move PMU register related defines to
 asm/perf_event.h
Date: Mon, 29 Feb 2016 15:41:24 +0000
Message-ID: <20160229154124.GC14848@arm.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
 <20160224175247.GE12471@arm.com>
 <56CE6098.8070001@huawei.com>
 <56D4428B.5000505@arm.com>
 <56D44ED5.8070606@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D44ED5.8070606@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 29, 2016 at 01:59:49PM +0000, Marc Zyngier wrote:
> On 29/02/16 13:07, Marc Zyngier wrote:
> > On 25/02/16 02:02, Shannon Zhao wrote:
> >> On 2016/2/25 1:52, Will Deacon wrote:
> >>> On Wed, Feb 24, 2016 at 01:08:21PM +0800, Shannon Zhao wrote:
> >>>> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>>>
> >>>> To use the ARMv8 PMU related register defines from the KVM code, we move
> >>>> the relevant definitions to asm/perf_event.h header file and rename them
> >>>> with prefix ARMV8_PMU_.
> >>>>
> >>>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> >>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >>>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
> >>>> ---
> >>>>  arch/arm64/include/asm/perf_event.h | 35 +++++++++++++++++++
> >>>>  arch/arm64/kernel/perf_event.c      | 68 ++++++++++---------------------------
> >>>>  2 files changed, 52 insertions(+), 51 deletions(-)
> >>>
> >>> Looks fine to me, but we're going to get some truly horrible conflicts
> >>> in -next.
> >>>
> >>> I'm open to suggestions on the best way to handle this, but one way
> >>> would be:
> >>>
> >>>   1. Duplicate all the #defines privately in KVM (queue via kvm tree)
> >> This way seems not proper I think.
> >>
> >>>   2. Rebase this patch onto my perf/updates branch [1] (queue via me)
> >> While to this series, it really relies on the perf_event.h to compile
> >> and test, so maybe for KVM-ARM and KVM maintainers it's not proper.
> >>
> >>>   3. Patch at -rc1 dropping the #defines from (1) and moving to the new
> >>>      perf_event.h stuff
> >>>
> >> I vote for this way. Since the patch in [1] is small and nothing else
> >> relies on them, I think it would be simple to rebase them onto this series.
> >>
> >>> Thoughts?
> >>>
> >> Anyway, there are only 3 lines which have conflicts. I'm not sure
> >> whether we could handle this when we merge them.
> > 
> > I think you're missing the point:
> > 
> > - We want both the arm64 perf and KVM trees to be easy to merge
> > - The conflicts are not that simple to resolve
> > - We want these conflicts to be solved before it hits Linus' tree
> > 
> > With that in mind, here's what I'm suggesting we merge as a first patch:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=2029b4b02691ec6ebba3d281068e783353d7e108
> > 
> > Once this and the perf/updates branch are merged, we can add one last
> > patch reverting this hack and actually doing the renaming work (Will has
> > posted a resolution for most of the new things).
> 
> For the record, here's the patch I propose we merge once everything gets
> into mainline:
> 
> https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=ba1e09b2f2cd2d5cc5cfdb76e96460aee1bd9482

I just spotted a bug in my perf/updates branch, so this might need to
change ever so slightly. Easiest thing is probably to cook something
against -next once we're nearer the merge window and things have settled
down.

Will
