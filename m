From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/27] KVM: arm/arm64: Remove unused timer variable
Date: Fri, 22 Feb 2019 16:26:04 +0000
Message-ID: <20190222162605.5054-27-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0D54A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zL2yRjyfb50k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:29:13 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 239194A42D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:11 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

The 'timer' local variable became unused after commit bee038a67487
("KVM: arm/arm64: Rework the timer code to use a timer_map").
Remove it to avoid [-Wunused-but-set-variable] warning.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index af8f2f1d01cc..3417f2dbc366 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -236,14 +236,12 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
 
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
-	struct arch_timer_cpu *timer;
 	enum kvm_arch_timers index;
 	u64 cval, now;
 
 	if (!timer_ctx)
 		return false;
 
-	timer = vcpu_timer(timer_ctx->vcpu);
 	index = arch_timer_ctx_index(timer_ctx);
 
 	if (timer_ctx->loaded) {
-- 
2.20.1
