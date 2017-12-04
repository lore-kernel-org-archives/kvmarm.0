From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 15/19] KVM: arm/arm64: Avoid attempting to load timer vgic
 state without a vgic
Date: Mon,  4 Dec 2017 15:03:44 +0100
Message-ID: <20171204140348.21965-13-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 143F249D95
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dk9VS5S2-mlR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:01:07 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8596249D9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:01 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id 9so5994418wme.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:04:09 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The timer optimization patches inadvertendly changed the logic to always
load the timer state as if we have a vgic, even if we don't have a vgic.

Fix this by doing the usual irqchip_in_kernel() check and call the
appropriate load function.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 190c99ed1b73..f9555b1e7f15 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -835,7 +835,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 no_vgic:
 	preempt_disable();
 	timer->enabled = 1;
-	kvm_timer_vcpu_load_vgic(vcpu);
+	if (!irqchip_in_kernel(vcpu->kvm))
+		kvm_timer_vcpu_load_user(vcpu);
+	else
+		kvm_timer_vcpu_load_vgic(vcpu);
 	preempt_enable();
 
 	return 0;
-- 
2.14.2
