From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 10/14] KVM: arm64/sve: Explain validity checks in
 set_sve_vls()
Date: Thu, 18 Apr 2019 17:07:07 +0100
Message-ID: <1555603631-8107-11-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 920BF4A530
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A7FAjH96kZ1D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80104A51B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:21 -0400 (EDT)
In-Reply-To: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Correct virtualization of SVE relies for correctness on code in
set_sve_vls() that verifies consistency between the set of vector
lengths requested by userspace and the set of vector lengths
available on the host.

However, the purpose of this code is not obvious, and not likely to
be apparent at all to people who do not have detailed knowledge of
the SVE system-level architecture.

This patch adds a suitable comment to explain what these checks are
for.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/guest.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5bb909c..3ae2f82 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -264,6 +264,13 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
 		return -EINVAL;
 
+	/*
+	 * Vector lengths supported by the host can't currently be
+	 * hidden from the guest individually: instead we can only set a
+	 * maxmium via ZCR_EL2.LEN.  So, make sure the available vector
+	 * lengths match the set requested exactly up to the requested
+	 * maximum:
+	 */
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
 		if (vq_present(&vqs, vq) != sve_vq_available(vq))
 			return -EINVAL;
-- 
2.1.4
