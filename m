From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v13 01/20] ARM64: Move PMU register related defines to
 asm/perf_event.h
Date: Thu, 25 Feb 2016 10:48:18 +0000
Message-ID: <20160225104818.GB12784@arm.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
 <20160224175247.GE12471@arm.com>
 <56CE6098.8070001@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56CE6098.8070001@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 25, 2016 at 10:02:00AM +0800, Shannon Zhao wrote:
> On 2016/2/25 1:52, Will Deacon wrote:
> > On Wed, Feb 24, 2016 at 01:08:21PM +0800, Shannon Zhao wrote:
> >> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>
> >> To use the ARMv8 PMU related register defines from the KVM code, we move
> >> the relevant definitions to asm/perf_event.h header file and rename them
> >> with prefix ARMV8_PMU_.
> >>
> >> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> >> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Reviewed-by: Andrew Jones <drjones@redhat.com>
> >> ---
> >>  arch/arm64/include/asm/perf_event.h | 35 +++++++++++++++++++
> >>  arch/arm64/kernel/perf_event.c      | 68 ++++++++++---------------------------
> >>  2 files changed, 52 insertions(+), 51 deletions(-)
> > 
> > Looks fine to me, but we're going to get some truly horrible conflicts
> > in -next.
> > 
> > I'm open to suggestions on the best way to handle this, but one way
> > would be:
> > 
> >   1. Duplicate all the #defines privately in KVM (queue via kvm tree)
> This way seems not proper I think.
> 
> >   2. Rebase this patch onto my perf/updates branch [1] (queue via me)
> While to this series, it really relies on the perf_event.h to compile
> and test, so maybe for KVM-ARM and KVM maintainers it's not proper.
> 
> >   3. Patch at -rc1 dropping the #defines from (1) and moving to the new
> >      perf_event.h stuff
> > 
> I vote for this way. Since the patch in [1] is small and nothing else
> relies on them, I think it would be simple to rebase them onto this series.

That was supposed to be a sequence of actions... :/

> > Thoughts?
> > 
> Anyway, there are only 3 lines which have conflicts. I'm not sure
> whether we could handle this when we merge them.

I think we're looking at different conflicts. I resolved it (see below),
but I'd really rather this didn't happen at the point where perf/updates
hits kvm-arm (i.e. torvalds).

Will

--->8

diff --cc arch/arm64/kernel/perf_event.c
index 1cc61fc321d9,212c9fc44141..000000000000
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@@ -776,11 -684,8 +741,12 @@@ static void armv8pmu_reset(void *info
                armv8pmu_disable_intens(idx);
        }
  
 -      /* Initialize & Reset PMNC: C and P bits. */
 -      armv8pmu_pmcr_write(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 +      /*
 +       * Initialize & Reset PMNC. Request overflow interrupt for
 +       * 64 bit cycle counter but cheat in armv8pmu_write_counter().
 +       */
-       armv8pmu_pmcr_write(ARMV8_PMCR_P | ARMV8_PMCR_C | ARMV8_PMCR_LC);
++      armv8pmu_pmcr_write(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C |
++                          ARMV8_PMU_PMCR_LC);
  }
  
  static int armv8_pmuv3_map_event(struct perf_event *event)
@@@ -801,16 -706,9 +767,16 @@@ static int armv8_a57_map_event(struct p
  {
        return armpmu_map_event(event, &armv8_a57_perf_map,
                                &armv8_a57_perf_cache_map,
-                               ARMV8_EVTYPE_EVENT);
+                               ARMV8_PMU_EVTYPE_EVENT);
  }
  
 +static int armv8_thunder_map_event(struct perf_event *event)
 +{
 +      return armpmu_map_event(event, &armv8_thunder_perf_map,
 +                              &armv8_thunder_perf_cache_map,
-                               ARMV8_EVTYPE_EVENT);
++                              ARMV8_PMU_EVTYPE_EVENT);
 +}
 +
  static void armv8pmu_read_num_pmnc_events(void *info)
  {
        int *nb_cnt = info;
diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 5c77ef8bf5b5..152ad9cb9bb0 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -29,6 +29,7 @@
 #define ARMV8_PMU_PMCR_D       (1 << 3) /* CCNT counts every 64th cpu cycle */
 #define ARMV8_PMU_PMCR_X       (1 << 4) /* Export to ETM */
 #define ARMV8_PMU_PMCR_DP      (1 << 5) /* Disable CCNT if non-invasive debug*/
+#define ARMV8_PMU_PMCR_LC      (1 << 6) /* Overflow on 64 bit cycle counter */
 #define        ARMV8_PMU_PMCR_N_SHIFT  11       /* Number of counters supported */
 #define        ARMV8_PMU_PMCR_N_MASK   0x1f
 #define        ARMV8_PMU_PMCR_MASK     0x3f     /* Mask for writable bits */
@@ -42,8 +43,8 @@
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define        ARMV8_PMU_EVTYPE_MASK   0xc80003ff      /* Mask for writable bits */
-#define        ARMV8_PMU_EVTYPE_EVENT  0x3ff           /* Mask for EVENT bits */
+#define        ARMV8_PMU_EVTYPE_MASK   0xc800ffff      /* Mask for writable bits */
+#define        ARMV8_PMU_EVTYPE_EVENT  0xffff          /* Mask for EVENT bits */
 
 /*
  * Event filters for PMUv3

