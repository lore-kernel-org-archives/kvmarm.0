From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2] KVM: arm/arm64: avoid using kvm_run for in-kernel emulation
Date: Fri, 10 Apr 2015 15:59:47 +0100
Message-ID: <1428677987-15494-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D1704C143
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 10:52:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SHDsZsnunS3G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 10:52:10 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBD64C13C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 10:52:10 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Our in-kernel VGIC emulation still uses struct kvm_run briefly before
writing back the emulation result into the guest register.
Although this particular case looks safe from an exploitation
perspective, we can save some unneeded copying at the end of the VGIC
emulation code.
Replace the usage of struct kvm_run in favour of passing separate
parameters in io_mem_abort(). Since the write back is now handled
for all kvm_io_bus users, we can get rid of it in the VGIC.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
This one applies on top of kvmarm/queue.

 arch/arm/kvm/mmio.c |   65 ++++++++++++++++++++++++++++-----------------------
 virt/kvm/arm/vgic.c |    7 ------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 974b1c6..42004cb 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -85,6 +85,30 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
 	return data;
 }
 
+static int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, unsigned int len,
+				   void *data_ptr, gpa_t phys_addr)
+{
+	unsigned long data;
+
+	if (len > sizeof(unsigned long))
+		return -EINVAL;
+
+	data = mmio_read_buf(data_ptr, len);
+
+	if (vcpu->arch.mmio_decode.sign_extend &&
+	    len < sizeof(unsigned long)) {
+		int mask = 1U << ((len * 8) - 1);
+
+		data = (data ^ mask) - mask;
+	}
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, phys_addr, data);
+	data = vcpu_data_host_to_guest(vcpu, data, len);
+	*vcpu_reg(vcpu, vcpu->arch.mmio_decode.rt) = data;
+
+	return 0;
+}
+
 /**
  * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
  * @vcpu: The VCPU pointer
@@ -95,28 +119,10 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
  */
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	unsigned long data;
-	unsigned int len;
-	int mask;
-
-	if (!run->mmio.is_write) {
-		len = run->mmio.len;
-		if (len > sizeof(unsigned long))
-			return -EINVAL;
-
-		data = mmio_read_buf(run->mmio.data, len);
-
-		if (vcpu->arch.mmio_decode.sign_extend &&
-		    len < sizeof(unsigned long)) {
-			mask = 1U << ((len * 8) - 1);
-			data = (data ^ mask) - mask;
-		}
-
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
-			       data);
-		data = vcpu_data_host_to_guest(vcpu, data, len);
-		*vcpu_reg(vcpu, vcpu->arch.mmio_decode.rt) = data;
-	}
+	if (!run->mmio.is_write)
+		return kvm_writeback_mmio_data(vcpu, run->mmio.len,
+					       run->mmio.data,
+					       run->mmio.phys_addr);
 
 	return 0;
 }
@@ -201,18 +207,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				      data_buf);
 	}
 
-	/* Now prepare kvm_run for the potential return to userland. */
-	run->mmio.is_write	= is_write;
-	run->mmio.phys_addr	= fault_ipa;
-	run->mmio.len		= len;
-	memcpy(run->mmio.data, data_buf, len);
-
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
-		kvm_handle_mmio_return(vcpu, run);
+		if (!is_write)
+			kvm_writeback_mmio_data(vcpu, len, data_buf, fault_ipa);
 		return 1;
 	}
 
+	/* Now prepare the kvm_run structure for the return to userland. */
+	run->mmio.is_write	= is_write;
+	run->mmio.phys_addr	= fault_ipa;
+	run->mmio.len		= len;
+	memcpy(run->mmio.data, data_buf, len);
 	run->exit_reason	= KVM_EXIT_MMIO;
+
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b70174e..e23f50d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -803,7 +803,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_io_device *iodev = container_of(this,
 						    struct vgic_io_device, dev);
-	struct kvm_run *run = vcpu->run;
 	const struct vgic_io_range *range;
 	struct kvm_exit_mmio mmio;
 	bool updated_state;
@@ -832,12 +831,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 		updated_state = false;
 	}
 	spin_unlock(&dist->lock);
-	run->mmio.is_write	= is_write;
-	run->mmio.len		= len;
-	run->mmio.phys_addr	= addr;
-	memcpy(run->mmio.data, val, len);
-
-	kvm_handle_mmio_return(vcpu, run);
 
 	if (updated_state)
 		vgic_kick_vcpus(vcpu->kvm);
-- 
1.7.9.5
