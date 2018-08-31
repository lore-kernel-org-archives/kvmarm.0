From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH] KVM: arm64: remove the unnecessary function check
Date: Fri, 31 Aug 2018 17:42:59 +0800
Message-ID: <1535708579-12233-1-git-send-email-zhangshaokun@hisilicon.com>
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
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

init_common_resources always return 0 and it is redundant to check the
return value, let's make it void to simplify the code.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 virt/kvm/arm/arm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c92053b..66a29c9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1406,13 +1406,11 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
-static int init_common_resources(void)
+static void init_common_resources(void)
 {
 	/* set size of VMID supported by CPU */
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
-
-	return 0;
 }
 
 static int init_subsystems(void)
@@ -1655,9 +1653,7 @@ int kvm_arch_init(void *opaque)
 		}
 	}
 
-	err = init_common_resources();
-	if (err)
-		return err;
+	init_common_resources();
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
-- 
2.7.4
