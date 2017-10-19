From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 20/21] KVM: arm64: Take any host SError before entering the
 guest
Date: Thu, 19 Oct 2017 15:58:06 +0100
Message-ID: <20171019145807.23251-21-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91CE0406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gJ2m4WbfYfbu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:59:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 443BE49D47
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:44 -0400 (EDT)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On VHE systems KVM masks SError before switching the VBAR value. Any
host RAS error that the CPU knew about before world-switch may become
pending as an SError during world-switch, and only be taken once we enter
the guest.

Until KVM can take RAS SErrors during world switch, add an ESB to
force any RAS errors to be synchronised and taken on the host before
we enter world switch.

RAS errors that become pending during world switch are still taken
once we enter the guest.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cf5d78ba14b5..5dc6f2877762 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -392,6 +392,7 @@ static inline void __cpu_init_stage2(void)
 
 static inline void kvm_arm_vhe_guest_enter(void)
 {
+	esb();
 	local_daif_mask();
 }
 
-- 
2.13.3
