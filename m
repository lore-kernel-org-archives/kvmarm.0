From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: fix MMIO handling on userland induced accesses
Date: Tue, 24 Mar 2015 16:03:16 +0000
Message-ID: <1427212996-16844-1-git-send-email-andre.przywara@arm.com>
References: <1427126309-11223-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0AF49936
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2015 11:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 92ACPz2aAmAV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Mar 2015 11:56:25 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC3A49935
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2015 11:56:24 -0400 (EDT)
In-Reply-To: <1427126309-11223-12-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The guest is not the only user of the MMIO handling routines, userland
can also read and write to those handlers. Since we don't use the
KVM iobus framework in this case, we have to set the data pointer to
some actual memory before executing the handler routines.
This allows to use QEMU as the userland control tool.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

just embarrassingly realised that I haven't tested the latest version of this
series with QEMU, so this bug slipped me. Sorry for that! I will merge this
patch in the next revision of this series (or just send a new version of
11/12).

Cheers,
Andre.

 virt/kvm/arm/vgic-v2-emul.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 12cb1361..a715054 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -666,6 +666,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	struct vgic_dist *vgic;
 	struct kvm_exit_mmio mmio;
+	u32 data;
 
 	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
@@ -687,6 +688,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	mmio.len = 4;
 	mmio.is_write = is_write;
+	mmio.data = &data;
 	if (is_write)
 		mmio_data_write(&mmio, ~0, *reg);
 	switch (attr->group) {
-- 
1.7.9.5
