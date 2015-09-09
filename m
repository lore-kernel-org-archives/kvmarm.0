From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 4/4] arm/arm64: kvm: Disable comparision of cpu and vcpu
 target
Date: Wed,  9 Sep 2015 14:08:34 +0530
Message-ID: <1441787914-3191-5-git-send-email-tushar.jagad@linaro.org>
References: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, patches@apm.com, qemu-devel@nongnu.org, tushar.jagad@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch disables comparison of physical cpu and vcpu for supporting
cross cpu guests.

Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 arch/arm/kvm/arm.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 8907d37..b3214b2 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -698,11 +698,6 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	unsigned int i;
 	u64 aa64dfr;
 
-	int phys_target = kvm_target_cpu();
-
-	if (init->target != phys_target)
-		return -EINVAL;
-
 	/*
 	 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
 	 * use the same target.
-- 
1.7.9.5
