From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/27] ARM: KVM: Remove handling of ARM_EXCEPTION_DATA/PREF_ABORT
Date: Mon, 25 Jan 2016 16:38:42 +0000
Message-ID: <1453739923-17846-27-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

