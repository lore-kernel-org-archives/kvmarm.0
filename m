From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/26] arm64: KVM: Remove some extra semicolon in
 kvm_target_cpu
Date: Fri, 19 Oct 2018 13:58:56 +0100
Message-ID: <20181019125901.185478-22-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B08A4A2EE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wN5LfT7ho8Zz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4733A4A2FB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:20 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
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
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: zhong jiang <zhongjiang@huawei.com>

There are some extra semicolon in kvm_target_cpu, remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 07256b08226c..a74f84d09412 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -338,15 +338,15 @@ int __attribute_const__ kvm_target_cpu(void)
 			return KVM_ARM_TARGET_CORTEX_A53;
 		case ARM_CPU_PART_CORTEX_A57:
 			return KVM_ARM_TARGET_CORTEX_A57;
-		};
+		}
 		break;
 	case ARM_CPU_IMP_APM:
 		switch (part_number) {
 		case APM_CPU_PART_POTENZA:
 			return KVM_ARM_TARGET_XGENE_POTENZA;
-		};
+		}
 		break;
-	};
+	}
 
 	/* Return a default generic target */
 	return KVM_ARM_TARGET_GENERIC_V8;
-- 
2.19.1
