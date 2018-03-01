From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 15/23] arm64: Update the KVM memory map documentation
Date: Thu,  1 Mar 2018 15:55:30 +0000
Message-ID: <20180301155538.26860-16-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A8E49E7B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HYyQmfuROT2K for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:50:47 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA58A49E00
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:17 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Update the documentation to reflect the new tricks we play on the
EL2 mappings...

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/arm64/memory.txt | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 671bc0639262..c58cc5dbe667 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -86,9 +86,11 @@ Translation table lookup with 64KB pages:
  +-------------------------------------------------> [63] TTBR0/1
 
 
-When using KVM without the Virtualization Host Extensions, the hypervisor
-maps kernel pages in EL2 at a fixed offset from the kernel VA. See the
-kern_hyp_va macro for more details.
+When using KVM without the Virtualization Host Extensions, the
+hypervisor maps kernel pages in EL2 at a fixed (and potentially
+random) offset from the linear mapping. See the kern_hyp_va macro and
+kvm_update_va_mask function for more details. MMIO devices such as
+GICv2 gets mapped next to the HYP idmap page.
 
 When using KVM with the Virtualization Host Extensions, no additional
 mappings are created, since the host kernel runs directly in EL2.
-- 
2.14.2
