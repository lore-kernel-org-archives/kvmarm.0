From: Julien Thierry <julien.thierry@arm.com>
Subject: [RESEND PATCH 1/2] arm/arm64: kvm: Move initialization completion
 message
Date: Fri, 20 Oct 2017 12:34:16 +0100
Message-ID: <1508499257-10014-2-git-send-email-julien.thierry@arm.com>
References: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B40349D29
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Uscfl73Svi0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:33:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE23406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:22 -0400 (EDT)
In-Reply-To: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM is being a bit too optimistic, Hyp mode is said to be initialized
when Hyp segments have only been mapped.

Notify KVM's successful initialization only once it is really fully
initialized.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4..95cba07 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1326,21 +1326,12 @@ static void teardown_hyp_mode(void)
 {
 	int cpu;

-	if (is_kernel_in_hyp_mode())
-		return;
-
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
 	hyp_cpu_pm_exit();
 }

-static int init_vhe_mode(void)
-{
-	kvm_info("VHE mode initialized successfully\n");
-	return 0;
-}
-
 /**
  * Inits Hyp-mode on all online CPUs
  */
@@ -1421,8 +1412,6 @@ static int init_hyp_mode(void)
 		}
 	}

-	kvm_info("Hyp mode initialized successfully\n");
-
 	return 0;

 out_err:
@@ -1456,6 +1445,7 @@ int kvm_arch_init(void *opaque)
 {
 	int err;
 	int ret, cpu;
+	bool in_hyp_mode;

 	if (!is_hyp_mode_available()) {
 		kvm_err("HYP mode not available\n");
@@ -1474,21 +1464,28 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;

-	if (is_kernel_in_hyp_mode())
-		err = init_vhe_mode();
-	else
+	in_hyp_mode = is_kernel_in_hyp_mode();
+
+	if (!in_hyp_mode) {
 		err = init_hyp_mode();
-	if (err)
-		goto out_err;
+		if (err)
+			goto out_err;
+	}

 	err = init_subsystems();
 	if (err)
 		goto out_hyp;

+	if (in_hyp_mode)
+		kvm_info("VHE mode initialized successfully\n");
+	else
+		kvm_info("Hyp mode initialized successfully\n");
+
 	return 0;

 out_hyp:
-	teardown_hyp_mode();
+	if (!in_hyp_mode)
+		teardown_hyp_mode();
 out_err:
 	teardown_common_resources();
 	return err;
--
1.9.1
