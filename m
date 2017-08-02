From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: vgic: Use READ_ONCE fo cmpxchg
Date: Wed,  2 Aug 2017 16:28:42 +0200
Message-ID: <20170802142842.9494-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B58A649C3F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Aug 2017 10:27:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0e3RP1IHy7rM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Aug 2017 10:27:33 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEBEA49C33
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Aug 2017 10:27:33 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id t201so43313124wmt.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Aug 2017 07:28:51 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There is a small chance that the compiler could generate separate loads
for the dist->propbaser which could be modified from another CPU.  As we
want to make sure we atomically update the entire value, and don't race
with other updates, guarantee that the cmpxchg operation compares
against the original value.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 714fa39..408ef06 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -369,7 +369,7 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
 		return;
 
 	do {
-		old_propbaser = dist->propbaser;
+		old_propbaser = READ_ONCE(dist->propbaser);
 		propbaser = old_propbaser;
 		propbaser = update_64bit_reg(propbaser, addr & 4, len, val);
 		propbaser = vgic_sanitise_propbaser(propbaser);
@@ -397,7 +397,7 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		return;
 
 	do {
-		old_pendbaser = vgic_cpu->pendbaser;
+		old_pendbaser = READ_ONCE(vgic_cpu->pendbaser);
 		pendbaser = old_pendbaser;
 		pendbaser = update_64bit_reg(pendbaser, addr & 4, len, val);
 		pendbaser = vgic_sanitise_pendbaser(pendbaser);
-- 
2.9.0
