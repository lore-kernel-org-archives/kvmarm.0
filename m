From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 12/59] KVM: arm/arm64: Export mmio_read/write_bus
Date: Tue, 24 May 2016 11:09:06 +0200
Message-ID: <1464080993-10884-13-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AE249B8A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qCIzW7AqA+W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:37 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2076F49BB9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:34 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n129so15334133wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:07 -0700 (PDT)
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

Rename mmio_{read,write}_bus to kvm_mmio_{read,write}_bus and export
them out of mmio.c.
This will be needed later for the new VGIC implementation.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_mmio.h   |  3 +++
 arch/arm/kvm/mmio.c               | 10 +++++-----
 arch/arm64/include/asm/kvm_mmio.h |  3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
index d8e90c8..f3a7de7 100644
--- a/arch/arm/include/asm/kvm_mmio.h
+++ b/arch/arm/include/asm/kvm_mmio.h
@@ -28,6 +28,9 @@ struct kvm_decode {
 	bool sign_extend;
 };
 
+void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
+unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
+
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa);
diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 0158e9e..10f80a6 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -23,7 +23,7 @@
 
 #include "trace.h"
 
-static void mmio_write_buf(char *buf, unsigned int len, unsigned long data)
+void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data)
 {
 	void *datap = NULL;
 	union {
@@ -55,7 +55,7 @@ static void mmio_write_buf(char *buf, unsigned int len, unsigned long data)
 	memcpy(buf, datap, len);
 }
 
-static unsigned long mmio_read_buf(char *buf, unsigned int len)
+unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
 {
 	unsigned long data = 0;
 	union {
@@ -66,7 +66,7 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
 
 	switch (len) {
 	case 1:
-		data = buf[0];
+		data = *(u8 *)buf;
 		break;
 	case 2:
 		memcpy(&tmp.hword, buf, len);
@@ -103,7 +103,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (len > sizeof(unsigned long))
 			return -EINVAL;
 
-		data = mmio_read_buf(run->mmio.data, len);
+		data = kvm_mmio_read_buf(run->mmio.data, len);
 
 		if (vcpu->arch.mmio_decode.sign_extend &&
 		    len < sizeof(unsigned long)) {
@@ -189,7 +189,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 					       len);
 
 		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, fault_ipa, data);
-		mmio_write_buf(data_buf, len, data);
+		kvm_mmio_write_buf(data_buf, len, data);
 
 		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_ipa, len,
 				       data_buf);
diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
index fe612a9..75ea420 100644
--- a/arch/arm64/include/asm/kvm_mmio.h
+++ b/arch/arm64/include/asm/kvm_mmio.h
@@ -30,6 +30,9 @@ struct kvm_decode {
 	bool sign_extend;
 };
 
+void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
+unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
+
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa);
-- 
2.1.2.330.g565301e.dirty
