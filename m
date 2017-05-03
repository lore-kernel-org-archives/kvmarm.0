From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/31] KVM: arm64: Enable GICv3 Group-1 sysreg trapping via
 command-line
Date: Wed,  3 May 2017 11:45:53 +0100
Message-ID: <20170503104606.19342-19-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 216D040C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Zdl3oGp3pZN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3E940C92
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:38 -0400 (EDT)
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

Now that we're able to safely handle Group-1 sysreg access, let's
give the user the opportunity to enable it by passing a specific
command-line option (vgic_v3.group1_trap).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 547b8374fb64..71ecf448ca49 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -324,6 +324,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
 
+static int __init early_group1_trap_cfg(char *buf)
+{
+	return strtobool(buf, &group1_trap);
+}
+early_param("vgic_v3.group1_trap", early_group1_trap_cfg);
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -375,6 +381,11 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (kvm_vgic_global_state.vcpu_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
 
+	if (group1_trap) {
+		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
+		static_branch_enable(&vgic_v3_cpuif_trap);
+	}
+
 	kvm_vgic_global_state.vctrl_base = NULL;
 	kvm_vgic_global_state.type = VGIC_V3;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
-- 
2.11.0
