From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/25] KVM: arm/arm64: Add the EL1 physical timer context
Date: Thu,  9 Feb 2017 14:59:17 +0000
Message-ID: <1486652363-7696-20-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D0F40C33
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x6SmHp8-Oh59 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93DA740B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:39 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

Add the EL1 physical timer context.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f46fa3b..6445a3d 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -40,6 +40,7 @@ struct arch_timer_context {
 
 struct arch_timer_cpu {
 	struct arch_timer_context	vtimer;
+	struct arch_timer_context	ptimer;
 
 	/* Background timer used when the guest is not running */
 	struct hrtimer			timer;
@@ -75,4 +76,5 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 void kvm_timer_init_vhe(void);
 
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
+#define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
 #endif
-- 
2.1.4
