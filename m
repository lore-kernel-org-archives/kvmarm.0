From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] kvm: arm/arm64: vgic-v3: Tighten synchronization for
 guests using v2 on v3
Date: Wed,  7 Mar 2018 12:40:55 +0000
Message-ID: <20180307124055.13800-3-marc.zyngier@arm.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC49401AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:34:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jgHF0mz1QxBu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 07:33:59 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC70403FE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:33:59 -0500 (EST)
In-Reply-To: <20180307124055.13800-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On guest exit, and when using GICv2 on GICv3, we use a dsb(st) to
force synchronization between the memory-mapped guest view and
the system-register view that the hypervisor uses.

This is incorrect, as the spec calls out the need for "a DSB whose
required access type is both loads and stores with any Shareability
attribute", while we're only synchronizing stores.

We also lack an isb after the dsb to ensure that the latter has
actually been executed before we start reading stuff from the sysregs.

The fix is pretty easy: turn dsb(st) into dsb(sy), and slap an isb()
just after.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index f5c3d6d7019e..b89ce5432214 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -215,7 +215,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	 * are now visible to the system register interface.
 	 */
 	if (!cpu_if->vgic_sre) {
-		dsb(st);
+		dsb(sy);
+		isb();
 		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
 	}
 
-- 
2.14.2
