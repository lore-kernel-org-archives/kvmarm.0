From: Wei Huang <wei@redhat.com>
Subject: [PATCH 1/1] KVM: arm/arm64: arch_timer: Fix TimerValue TVAL calculation in KVM
Date: Fri, 29 Mar 2019 15:12:53 -0500
Message-ID: <20190329201253.29164-1-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Recently the generic timer test of kvm-unit-tests failed to complete
(stalled) when a physical timer is being used. This issue is caused
by incorrect update of CNT_CVAL when TimerValue is being accessed,
introduced by 'Commit 84135d3d18da ("KVM: arm/arm64: consolidate arch
timer trap handlers")'. According to Arm ARM, the read/write behavior
of accesses to TimeValue registers is expected to be:

  * READ: TimerValue = (CompareValue – (Counter - Offset)
  * WRITE: CompareValue = ((Counter - Offset) + Sign(TimerValue)

This patch fixes the TVAL read/write code path according to the
specification.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3417f2dbc366..d43308dc3617 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -812,7 +812,7 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		val = kvm_phys_timer_read() - timer->cntvoff - timer->cnt_cval;
+		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
 		break;
 
 	case TIMER_REG_CTL:
@@ -858,7 +858,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 {
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		timer->cnt_cval = val - kvm_phys_timer_read() - timer->cntvoff;
+		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + val;
 		break;
 
 	case TIMER_REG_CTL:
-- 
2.14.5
