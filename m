From: Wei Huang <wei@redhat.com>
Subject: [PATCH 2/2] KVM: ARM64: Fix the issues when guest PMCCFILTR is
 configured
Date: Wed,  9 Nov 2016 13:58:00 -0600
Message-ID: <1478721480-24852-2-git-send-email-wei@redhat.com>
References: <1478721480-24852-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A58C4401B9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 14:57:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9q3tcF9USj82 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2016 14:57:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C711440448
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 14:57:43 -0500 (EST)
In-Reply-To: <1478721480-24852-1-git-send-email-wei@redhat.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM calls kvm_pmu_set_counter_event_type() when PMCCFILTR is configured.
But this function can't deals with PMCCFILTR correctly because the evtCount
bit of PMCCFILTR, which is reserved 0, conflits with the SW_INCR event
type of other PMXEVTYPER<n> registers. To fix it, when eventsel == 0, this
function shouldn't return immediately; instead it needs to check further
if select_idx is ARMV8_PMU_CYCLE_IDX.

Another issue is that KVM shouldn't copy the eventsel bits of PMCCFILTER
blindly to attr.config. Instead it ought to convert the request to the
"cpu cycle" event type (i.e. 0x11).

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/pmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 6e9c40e..69ccce3 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -305,7 +305,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 		type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
 		       & ARMV8_PMU_EVTYPE_EVENT;
-		if ((type == ARMV8_PMU_EVTYPE_EVENT_SW_INCR)
+		if ((type == ARMV8_PMUV3_PERFCTR_SW_INCR)
 		    && (enable & BIT(i))) {
 			reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
 			reg = lower_32_bits(reg);
@@ -379,7 +379,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
 
 	/* Software increment event does't need to be backed by a perf event */
-	if (eventsel == ARMV8_PMU_EVTYPE_EVENT_SW_INCR)
+	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
+	    select_idx != ARMV8_PMU_CYCLE_IDX)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
@@ -391,7 +392,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
-	attr.config = eventsel;
+	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
+		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
 
 	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
 	/* The initial sample period (overflow count) of an event. */
-- 
2.7.4
