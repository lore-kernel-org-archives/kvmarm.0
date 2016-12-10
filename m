From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 6/7] KVM: arm/arm64: Remove unnecessary timer BUG_ON
 operations
Date: Sat, 10 Dec 2016 21:47:11 +0100
Message-ID: <20161210204712.21830-7-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE6040598
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q1POML99noE7 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 928F2404E2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: by mail-lf0-f48.google.com with SMTP id b14so21783343lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:47:12 -0800 (PST)
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We don't need BUG_ON operations for the timer code here anymore as this
is not a likely case to get wrong and they are in the critical path so
may potentially add overhead.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index beede1b..242728a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -367,8 +367,6 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	BUG_ON(timer_is_armed(timer));
-
 	/*
 	 * If we entered the guest with the timer output asserted we have to
 	 * check if the guest has modified the timer so that we should lower
-- 
2.9.0
