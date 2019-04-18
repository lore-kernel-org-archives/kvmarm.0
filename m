From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 08/14] KVM: arm64/sve: WARN when avoiding divide-by-zero in
 sve_reg_to_region()
Date: Thu, 18 Apr 2019 17:07:05 +0100
Message-ID: <1555603631-8107-9-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3484A511
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fAZDrYNUZQZW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F2F4A51B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:17 -0400 (EDT)
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

sve_reg_to_region() currently passes the result of
vcpu_sve_state_size() to array_index_nospec(), effectively
leading to a divide / modulo operation.

Currently the code bails out and returns -EINVAL if
vcpu_sve_state_size() turns out to be zero, in order to avoid going
ahead and attempting to divide by zero.  This is reasonable, but it
should only happen if the kernel contains some other bug that
allowed this code to be reached without the vcpu having been
properly initialised.

To make it clear that this is a defence against bugs rather than
something that the user should be able to trigger, this patch marks
the check with WARN_ON().

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e45a042..73044e3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -371,7 +371,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	}
 
 	sve_state_size = vcpu_sve_state_size(vcpu);
-	if (!sve_state_size)
+	if (WARN_ON(!sve_state_size))
 		return -EINVAL;
 
 	region->koffset = array_index_nospec(reqoffset, sve_state_size);
-- 
2.1.4
