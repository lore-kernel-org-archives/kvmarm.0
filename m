From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 13/16] KVM: Allow 2048-bit register access via KVM_{GET,
 SET}_ONE_REG
Date: Thu, 21 Jun 2018 15:57:37 +0100
Message-ID: <1529593060-542-14-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEBFE4A0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4bUKUBceG7r for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:47:14 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC0D4A0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:03 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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

The Arm SVE architecture defines registers that are up to 2048 bits
in size (with some possibility of further future expansion).

In order to avoid the need for an excessively large number of
ioctls when saving and restoring a vcpu's registers, this patch
adds a #define to make support for individual 2048-bit registers
through the KVM_{GET,SET}_ONE_REG ioctl interface official.  This
will allow each SVE register to be accessed in a single call.

There are sufficient spare bits in the register id size field for
this change, so there is no ABI impact providing that
KVM_GET_REG_LIST does not enumerate any 2048-bit register unless
userspace explicitly opts in to the relevant architecture-specific
features.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6270a3..345be88 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1106,6 +1106,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_SIZE_U256	0x0050000000000000ULL
 #define KVM_REG_SIZE_U512	0x0060000000000000ULL
 #define KVM_REG_SIZE_U1024	0x0070000000000000ULL
+#define KVM_REG_SIZE_U2048	0x0080000000000000ULL
 
 struct kvm_reg_list {
 	__u64 n; /* number of regs */
-- 
2.1.4
