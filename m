From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 29/58] KVM: arm64: Make kvm_condition_valid32() accessible
 from EL2
Date: Fri, 30 Jun 2017 09:44:45 +0100
Message-ID: <20170630084514.6779-30-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2691440EF9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8LXov-KUIK4D for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 470E540EB8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:47 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to trap CP15 accesses and handle them at EL2, we
need to evaluate whether or not the condition flags are valid,
as an implementation is allowed to trap despite the condition
not being met.

Tagging the function as __hyp_text allows this. We still rely on
the cc_map array to be mapped at EL2 by virtue of being "const",
and the linker to only emit relative references.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/aarch32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 528af4b2d09e..79c7c357804b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -60,7 +60,7 @@ static const unsigned short cc_map[16] = {
 /*
  * Check if a trapped instruction should have been executed or not.
  */
-bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 {
 	unsigned long cpsr;
 	u32 cpsr_cond;
-- 
2.11.0
