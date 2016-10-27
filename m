From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [PATCH] KVM: arm/arm64: Kick VCPUs when queueing already pending IRQs
Date: Thu, 27 Oct 2016 15:08:13 +0000
Message-ID: <1477580893-3479-1-git-send-email-shihwei@cs.columbia.edu>
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
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, Shih-Wei Li <shihwei@cs.columbia.edu>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In cases like IPI, we could be queueing an interrupt for a VCPU
that is already running and is not about to exit, because the
VCPU has entered the VM with the interrupt pending and would
not trap on EOI'ing that interrupt. This could result to delays
in interrupt deliveries or even loss of interrupts.
To guarantee prompt interrupt injection, here we have to try to
kick the VCPU.

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
---

I've tested the code with an IPI test built on kvm-unit-test, which
measures the cycles spent between one VCPU sending IPI to a target
VCPU that busy loops in the VM, until the target VCPU ACKs and EOIs
the IPI. The patch here can improve the performance in such case by
more than 5000 cycles.

 virt/kvm/arm/vgic/vgic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index b419a11..07cf239 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -273,6 +273,17 @@ retry:
 		 * no more work for us to do.
 		 */
 		spin_unlock(&irq->irq_lock);
+
+		/*
+		 * If the VCPU is not NULL, we could be queueing an
+		 * edge-triggered interrupt for a VCPU which is already
+		 * running and is not about to exit, because the VCPU has
+		 * entered the VM with the interrupt pending and it wouldn't
+		 * trap on EOI. To ensure prompt delivery of that interrupt,
+		 * we have to try to kick the VCPU.
+		 */
+		if (vcpu)
+			kvm_vcpu_kick(vcpu);
 		return false;
 	}
 
-- 
1.9.1
