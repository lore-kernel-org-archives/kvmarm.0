From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/5] KVM: arm/arm64: timer: Don't set irq as forwarded if no
 usable GIC
Date: Mon, 18 Dec 2017 11:00:55 +0100
Message-ID: <20171218100057.7839-4-christoffer.dall@linaro.org>
References: <20171218100057.7839-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C440249D8A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 04:57:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CEW81xM78fPA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 04:57:37 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D424740651
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 04:57:36 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id b199so28154679wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 02:01:21 -0800 (PST)
In-Reply-To: <20171218100057.7839-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If we don't have a usable GIC, do not try to set the vcpu affinity
as this is guaranteed to fail.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  2 +-
 virt/kvm/arm/arch_timer.c    | 13 ++++++++-----
 virt/kvm/arm/arm.c           |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6e45608b2399..9da6ce22803f 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -62,7 +62,7 @@ struct arch_timer_cpu {
 	bool			enabled;
 };
 
-int kvm_timer_hyp_init(void);
+int kvm_timer_hyp_init(bool);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f9555b1e7f15..aa9adfafe12b 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -720,7 +720,7 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
-int kvm_timer_hyp_init(void)
+int kvm_timer_hyp_init(bool has_gic)
 {
 	struct arch_timer_kvm_info *info;
 	int err;
@@ -756,10 +756,13 @@ int kvm_timer_hyp_init(void)
 		return err;
 	}
 
-	err = irq_set_vcpu_affinity(host_vtimer_irq, kvm_get_running_vcpus());
-	if (err) {
-		kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
-		goto out_free_irq;
+	if (has_gic) {
+		err = irq_set_vcpu_affinity(host_vtimer_irq,
+					    kvm_get_running_vcpus());
+		if (err) {
+			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
+			goto out_free_irq;
+		}
 	}
 
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6b60c98a6e22..2e43f9d42bd5 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1326,7 +1326,7 @@ static int init_subsystems(void)
 	/*
 	 * Init HYP architected timer support
 	 */
-	err = kvm_timer_hyp_init();
+	err = kvm_timer_hyp_init(vgic_present);
 	if (err)
 		goto out;
 
-- 
2.14.2
