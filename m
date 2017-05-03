From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 31/31] KVM: arm64: vgic-v3: Log which GICv3 system registers
 are trapped
Date: Wed,  3 May 2017 11:46:06 +0100
Message-ID: <20170503104606.19342-32-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E4DF40D1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:44:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFvjNcBfY9w4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:44:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D959840C4F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:58 -0400 (EDT)
In-Reply-To: <20170503104606.19342-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to facilitate debug, let's log which class of GICv3 system
registers are trapped.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 717219ab58a2..9110657b502c 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -407,7 +407,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 #endif
 
 	if (group0_trap || group1_trap || common_trap) {
-		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
+		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
+			 group0_trap ? "G0" : "",
+			 group1_trap ? "G1" : "",
+			 common_trap ? "C"  : "");
 		static_branch_enable(&vgic_v3_cpuif_trap);
 	}
 
-- 
2.11.0
