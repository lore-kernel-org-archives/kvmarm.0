From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 27/28] ARM: KVM: Remove handling of
 ARM_EXCEPTION_DATA/PREF_ABORT
Date: Thu,  4 Feb 2016 11:00:44 +0000
Message-ID: <1454583645-10144-28-git-send-email-marc.zyngier@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FD14130A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VNjmuH9vKWoI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 05:55:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A043749790
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:50 -0500 (EST)
In-Reply-To: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

These are now handled as a panic, so there is little point in
keeping them around.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/handle_exit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 5377d753..3f1ef0d 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -147,8 +147,6 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
 		return 1;
-	case ARM_EXCEPTION_DATA_ABORT:
-	case ARM_EXCEPTION_PREF_ABORT:
 	case ARM_EXCEPTION_HVC:
 		/*
 		 * See ARM ARM B1.14.1: "Hyp traps on instructions
-- 
2.1.4
