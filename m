From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/8] KVM: arm/arm64: Drop resource size check for GICV window
Date: Fri, 22 Jun 2018 13:49:46 +0100
Message-ID: <20180622124953.12355-2-marc.zyngier@arm.com>
References: <20180622124953.12355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180622124953.12355-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, jia.he@hxt-semitech.com, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

When booting a 64 KB pages kernel on a ACPI GICv3 system that
implements support for v2 emulation, the following warning is
produced

  GICV size 0x2000 not a multiple of page size 0x10000

and support for v2 emulation is disabled, preventing GICv2 VMs
from being able to run on such hosts.

The reason is that vgic_v3_probe() performs a sanity check on the
size of the window (it should be a multiple of the page size),
while the ACPI MADT parsing code hardcodes the size of the window
to 8 KB. This makes sense, considering that ACPI does not bother
to describe the size in the first place, under the assumption that
platforms implementing ACPI will follow the architecture and not
put anything else in the same 64 KB window.

So let's just drop the sanity check altogether, and assume that
the window is at least 64 KB in size.

Fixes: 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init: implement kvm_vgic_hyp_init")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index ff7dc890941a..cdce653e3c47 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -617,11 +617,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)info->vcpu.start);
 		kvm_vgic_global_state.vcpu_base = 0;
-	} else if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
-		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&info->vcpu),
-			PAGE_SIZE);
-		kvm_vgic_global_state.vcpu_base = 0;
 	} else {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
-- 
2.17.1
