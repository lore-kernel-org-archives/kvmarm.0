From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 15/17] arm64: KVM: vgic-v3: Do not save an LR known to be
 empty
Date: Wed, 17 Feb 2016 16:40:47 +0000
Message-ID: <1455727249-24752-16-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE0D499DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:35:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1nbB+gySU9Oz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 11:35:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB93B499F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:35:00 -0500 (EST)
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On exit, any empty LR will be signaled in ICH_ELRSR_EL2. Which
means that we do not have to save it, and we can just clear
its state in the in-memory copy.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3463c0a..ff67296 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -190,8 +190,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		save_maint_int_state(vcpu, max_lr_idx + 1);
 
 		for (i = 0; i <= max_lr_idx; i++) {
-			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
-				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
+				continue;
+
+			if (cpu_if->vgic_elrsr & (1 << i)) {
+				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
+				continue;
+			}
+
+			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 		}
 
 		switch (nr_pri_bits) {
-- 
2.1.4
