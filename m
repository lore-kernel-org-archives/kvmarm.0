From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] KVM: arm/arm64: Fix vgic init race
Date: Tue,  3 Jul 2018 23:26:15 +0200
Message-ID: <1530653175-11999-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The vgic_init function can race with kvm_arch_vcpu_create() which does
not hold kvm_lock() and we therefore have no synchronization primitives
to ensure we're doing the right thing.

As the user is trying to initialize or run the VM while at the same time
creating more VCPUs, we just have to refuse to initialize the VGIC in
this case rather than silently failing with a broken VCPU.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 9406eaf..c0c0b88 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -286,6 +286,10 @@ int vgic_init(struct kvm *kvm)
        if (vgic_initialized(kvm))
                return 0;

+       /* Are we also in the middle of creating a VCPU? */
+       if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
+               return -EBUSY;
+
        /* freeze the number of spis */
        if (!dist->nr_spis)
                dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
