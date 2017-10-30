From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/8] arm/arm64: kvm: Move initialization completion message
Date: Mon, 30 Oct 2017 03:55:58 +0100
Message-ID: <20171030025603.23550-4-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3957849D2B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zz2+Ulpf8lD5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:41 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48A9149D13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:41 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id b189so12863980wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:13 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Thierry <julien.thierry@arm.com>

KVM is being a bit too optimistic, Hyp mode is said to be initialized
when Hyp segments have only been mapped.

Notify KVM's successful initialization only once it is really fully
initialized.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..95cba0799828 100644
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
2.14.2
