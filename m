From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/59] KVM: arm/arm64: Fix MMIO emulation data handling
Date: Tue, 24 May 2016 11:09:05 +0200
Message-ID: <1464080993-10884-12-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97EE149B8E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1taf96yIN+b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:35 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B88649BA1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:33 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id z87so11868872wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:06 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel was handling a guest MMIO read access internally, we
need to copy the emulation result into the run->mmio structure in order
for the kvm_handle_mmio_return() function to pick it up and inject the
	result back into the guest.

Currently the only user of kvm_io_bus for ARM is the VGIC, which did
this copying itself, so this was not causing issues so far.

But with the upcoming new vgic implementation we need this done
properly.

Update the kvm_handle_mmio_return description and cleanup the code to
only perform a single copying when needed.

Code and commit message inspired by Andre Przywara.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/kvm/mmio.c | 14 +++++++-------
 virt/kvm/arm/vgic.c |  7 -------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 0f6600f..0158e9e 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -87,11 +87,10 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
 
 /**
  * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
+ *			     or in-kernel IO emulation
+ *
  * @vcpu: The VCPU pointer
  * @run:  The VCPU run struct containing the mmio data
- *
- * This should only be called after returning from userspace for MMIO load
- * emulation.
  */
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
@@ -206,18 +205,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
-	if (is_write)
-		memcpy(run->mmio.data, data_buf, len);
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
+		if (!is_write)
+			memcpy(run->mmio.data, data_buf, len);
 		vcpu->stat.mmio_exit_kernel++;
 		kvm_handle_mmio_return(vcpu, run);
 		return 1;
-	} else {
-		vcpu->stat.mmio_exit_user++;
 	}
 
+	if (is_write)
+		memcpy(run->mmio.data, data_buf, len);
+	vcpu->stat.mmio_exit_user++;
 	run->exit_reason	= KVM_EXIT_MMIO;
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f76bb64..c3bfbb9 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -819,7 +819,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_io_device *iodev = container_of(this,
 						    struct vgic_io_device, dev);
-	struct kvm_run *run = vcpu->run;
 	const struct vgic_io_range *range;
 	struct kvm_exit_mmio mmio;
 	bool updated_state;
@@ -848,12 +847,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
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
2.1.2.330.g565301e.dirty
