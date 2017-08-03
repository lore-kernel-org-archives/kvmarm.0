From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/4] KVM: arm/arm64: vgic: Use READ_ONCE fo cmpxchg
Date: Thu,  3 Aug 2017 16:28:57 +0100
Message-ID: <20170803152857.32055-5-marc.zyngier@arm.com>
References: <20170803152857.32055-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170803152857.32055-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alex Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

There is a small chance that the compiler could generate separate loads
for the dist->propbaser which could be modified from another CPU.  As we
want to make sure we atomically update the entire value, and don't race
with other updates, guarantee that the cmpxchg operation compares
against the original value.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 714fa3933546..408ef06638fc 100644
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
2.11.0
