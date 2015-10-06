From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH] KVM: arm/arm64: Fix memory leak if timer initialization fails
Date: Tue, 06 Oct 2015 11:14:35 +0300
Message-ID: <1444119275-8972-1-git-send-email-p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Jump to correct label and free kvm_host_cpu_state

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dc017ad..78b2869 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1080,7 +1080,7 @@ static int init_hyp_mode(void)
 	 */
 	err = kvm_timer_hyp_init();
 	if (err)
-		goto out_free_mappings;
+		goto out_free_context;
 
 #ifndef CONFIG_HOTPLUG_CPU
 	free_boot_hyp_pgd();
-- 
2.4.4

