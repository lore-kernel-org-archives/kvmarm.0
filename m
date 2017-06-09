From: Hu Huajun <huhuajun@huawei.com>
Subject: [PATCH] KVM: ARM64: fix phy counter access failure in guest.
Date: Sat, 10 Jun 2017 00:22:20 +0800
Message-ID: <20170609162220.1460-1-huhuajun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, songwenjun@huawei.com, gengdongjiu@huawei.com, huhuajun@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

When reading the cntpct_el0 in guest with VHE (Virtual Host Extension)
enabled in host, the "Unsupported guest sys_reg access" error reported.
The reason is cnthctl_el2.EL1PCTEN is not enabled, which is expected
to be done in kvm_timer_init_vhe(). The problem is kvm_timer_init_vhe
is called by cpu_init_hyp_mode, and which is called when VHE is disabled.
This patch calls kvm_timer_init_vhe() to enable cnthctl_el2.EL1PCTEN
in cpu_hyp_reinit().

Signed-off-by: Hu Huajun <huhuajun@huawei.com>
---
 virt/kvm/arm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 3417e18..b703741 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1137,6 +1137,7 @@ static void cpu_hyp_reinit(void)
 		 * event was cancelled before the CPU was reset.
 		 */
 		__cpu_init_stage2();
+		kvm_timer_init_vhe();
 	} else {
 		cpu_init_hyp_mode(NULL);
 	}
-- 
2.10.1
