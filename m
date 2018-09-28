From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 08/23] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Fri, 28 Sep 2018 14:39:12 +0100
Message-ID: <1538141967-15375-9-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 500064A217
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5yVbY8fJ-jmd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29E1C49F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:31 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since SVE will be enabled or disabled on a per-vcpu basis, a flag
is needed in order to track which vcpus have it enabled.

This patch adds a suitable flag and a helper for checking it.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

Changes since RFCv1:

 * Convert vcpu_has_sve() to a macro so that it can operate on a vcpu
   without circular header dependency problems.

   This avoids the helper requiring a vcpu_arch argument, which was
   a little ugly.
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d4b65414..20baf4a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -307,6 +307,10 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
+#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
+
+#define vcpu_has_sve(vcpu) (system_supports_sve() && \
+			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
-- 
2.1.4
