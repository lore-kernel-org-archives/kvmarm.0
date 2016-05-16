From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 10/56] KVM: arm/arm64: Export mmio_read/write_bus
Date: Mon, 16 May 2016 10:52:58 +0100
Message-ID: <1463392481-26583-11-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Rename mmio_{read,write}_bus to kvm_mmio_{read,write}_bus and export
them out of mmio.c.
This will be needed later for the new VGIC implementation.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.8.2

