From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 70/85] arm64: Update the KVM memory map documentation
Date: Wed, 28 Mar 2018 13:52:39 +0100
Message-ID: <20180328125254.31380-71-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B04B34A099
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:59:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NII2L8CZfm27 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:59:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 959554A054
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:45 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Update the documentation to reflect the new tricks we play on the
EL2 mappings...

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
