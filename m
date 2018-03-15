From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 6/6] kvm: arm/arm64: vgic-v3: Tighten synchronization for
 guests using v2 on v3
Date: Thu, 15 Mar 2018 17:16:48 +0000
Message-ID: <20180315171648.19501-7-marc.zyngier@arm.com>
References: <20180315171648.19501-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CEAC49F88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:10:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s+Hfr+tndKO1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 13:09:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F0F349FB2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:09:43 -0400 (EDT)
In-Reply-To: <20180315171648.19501-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Cc: stable@vger.kernel.org
Fixes: f68d2b1b73cc ("arm64: KVM: Implement vgic-v3 save/restore")
Acked-by: Christoffer Dall <cdall@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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
