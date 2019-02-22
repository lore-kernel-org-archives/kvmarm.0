From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH -next] KVM: arm/arm64: Remove unused timer variable
Date: Fri, 22 Feb 2019 14:34:29 +0800
Message-ID: <1550817269-57405-1-git-send-email-zhangshaokun@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Shaokun Zhang <zhangshaokun@hisilicon.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The 'timer' local variable became unused after commit bee038a67487
("KVM: arm/arm64: Rework the timer code to use a timer_map").
Remove it to avoid [-Wunused-but-set-variable] warning.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry@arm.com>
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 virt/kvm/arm/arch_timer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index af8f2f1d01cc..3417f2dbc366 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -236,14 +236,12 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
 
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
-	struct arch_timer_cpu *timer;
 	enum kvm_arch_timers index;
 	u64 cval, now;
 
 	if (!timer_ctx)
 		return false;
 
-	timer = vcpu_timer(timer_ctx->vcpu);
 	index = arch_timer_ctx_index(timer_ctx);
 
 	if (timer_ctx->loaded) {
-- 
2.7.4
