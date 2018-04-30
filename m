From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 05/12] KVM: arm/arm64: Revisit Redistributor TYPER last bit computation
Date: Mon, 30 Apr 2018 13:48:31 +0200
Message-ID: <1525088918-8600-6-git-send-email-eric.auger@redhat.com>
References: <1525088918-8600-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525088918-8600-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The TYPER of an redistributor reflects whether the rdist is
the last one of the redistributor region. Let's compare the TYPER
GPA against the address of the last occupied slot within the
redistributor region.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

---

v3 -> v4:
- added Christoffer's R-b
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 49ca176..ce5c927 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -184,12 +184,17 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 					      gpa_t addr, unsigned int len)
 {
 	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
 	int target_vcpu_id = vcpu->vcpu_id;
+	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
+			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
 	u64 value;
 
 	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
 	value |= ((target_vcpu_id & 0xffff) << 8);
-	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
+
+	if (addr == last_rdist_typer)
 		value |= GICR_TYPER_LAST;
 	if (vgic_has_its(vcpu->kvm))
 		value |= GICR_TYPER_PLPIS;
-- 
2.5.5
