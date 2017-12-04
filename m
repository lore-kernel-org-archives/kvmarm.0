From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v6 1/8] KVM: arm/arm64: Remove redundant preemptible checks
Date: Mon,  4 Dec 2017 21:04:59 +0100
Message-ID: <20171204200506.3224-2-cdall@kernel.org>
References: <20171204200506.3224-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E249440651
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lm5GM9yYOn3C for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 15:02:02 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10AA349D35
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:01 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id n138so8038945wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 12:05:10 -0800 (PST)
In-Reply-To: <20171204200506.3224-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The __this_cpu_read() and __this_cpu_write() functions already implement
checks for the required preemption levels when using
CONFIG_DEBUG_PREEMPT which gives you nice error messages and such.
Therefore there is no need to explicitly check this using a BUG_ON() in
the code (which we don't do for other uses of per cpu variables either).

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a6524ff27de4..859ff7e3a1eb 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -71,7 +71,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(preemptible());
 	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
 }
 
@@ -81,7 +80,6 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
  */
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
 {
-	BUG_ON(preemptible());
 	return __this_cpu_read(kvm_arm_running_vcpu);
 }
 
-- 
2.14.2
