From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Increase GICV size to 64KB so !4KB page-size kernels are able to
 initialize KVM
Date: Wed, 22 Jun 2016 15:48:57 +0900
Message-ID: <8b9c3e26-97b1-307f-8227-5ca3a4966c84@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C716149B3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 02:44:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XqcZikERSQ9W for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 02:44:07 -0400 (EDT)
Received: from postman.riken.jp (postman1.riken.jp [134.160.33.83])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD2B49B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 02:44:06 -0400 (EDT)
Received: from postman.riken.jp (localhost.localdomain [127.0.0.1])
 by postman.riken.jp (Postfix) with SMTP id 0E33C6819C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 15:48:58 +0900 (JST)
Received: from MacBook-Pro.local (KD111105169138.ppp-bb.dion.ne.jp
 [111.105.169.138])
 by postman.riken.jp (Postfix) with ESMTPA id E361F6A02B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 15:48:57 +0900 (JST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Against the tag v4.7-rc2 in the kvmtree.

---
  drivers/irqchip/irq-gic.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index fbc4ae2..bd463a3 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1425,7 +1425,7 @@ static bool __init gic_validate_dist(struct 
acpi_subtable_header *header,
  #define ACPI_GICV2_DIST_MEM_SIZE       (SZ_4K)
  #define ACPI_GIC_CPU_IF_MEM_SIZE       (SZ_8K)
  #define ACPI_GICV2_VCTRL_MEM_SIZE      (SZ_4K)
-#define ACPI_GICV2_VCPU_MEM_SIZE       (SZ_8K)
+#define ACPI_GICV2_VCPU_MEM_SIZE       (SZ_64K)

  static void __init gic_acpi_setup_kvm_info(void)
  {
-- 
2.7.4
