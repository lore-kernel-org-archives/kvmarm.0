From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 43/58] KVM: arm64: Enable GICv3 Group-0 sysreg trapping via
 command-line
Date: Fri, 30 Jun 2017 09:44:59 +0100
Message-ID: <20170630084514.6779-44-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5636340D4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id guJrzL9pS2Fh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 516C640D31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:22 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we're able to safely handle Group-0 sysreg access, let's
give the user the opportunity to enable it by passing a specific
command-line option (vgic_v3.group0_trap).

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 virt/kvm/arm/vgic/vgic-v3.c                     | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 42fe395be6c8..88bdc421351f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1829,6 +1829,10 @@
 			for all guests.
 			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
 
+	kvm-arm.vgic_v3_group0_trap=
+			[KVM,ARM] Trap guest accesses to GICv3 group-0
+			system registers
+
 	kvm-arm.vgic_v3_group1_trap=
 			[KVM,ARM] Trap guest accesses to GICv3 group-1
 			system registers
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 39046ee5be25..828ca7f9a060 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -438,6 +438,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
 
+static int __init early_group0_trap_cfg(char *buf)
+{
+	return strtobool(buf, &group0_trap);
+}
+early_param("kvm-arm.vgic_v3_group0_trap", early_group0_trap_cfg);
+
 static int __init early_group1_trap_cfg(char *buf)
 {
 	return strtobool(buf, &group1_trap);
-- 
2.11.0
