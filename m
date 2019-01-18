From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 11/12] arm64: [HACK] FPSIMD/SVE register dumping for lkvm
 debug
Date: Fri, 18 Jan 2019 16:14:20 +0000
Message-ID: <1547828061-20462-12-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF3C4A3C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ClYtXTa+e8Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3892B4A3C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:39 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

To assist with debugging, and to exercise the KVM_{GET,SET}_ONE_REG
interface extensions for SVE, this patch adds code to dump the full
contents of the SVE and/or FPSIMD registers when triggered using
lkvm debug -d.

This is a giant ugly hack and also slow (even with hacks to reduce
the number of dprintf() calls).

Due to a lack of buffering on one or both ends of the guest socket
connection, dumping the vcpu that's running on the same CPU as lkvm
debug seems to cause a lot of context switch thrashing also, but no
attempt has been made to address this here, since this patch is
in any case rather abusing the guest socket.  If we want to do
something like this for real, some more careful thought about how
to optimise the protocol is needed.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/kvm-cpu.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 186 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 0aaefaf..28c5010 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -2,6 +2,10 @@
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
+#include <assert.h>
+#include <errno.h>
+#include <stdarg.h>
+#include <string.h>
 #include <asm/ptrace.h>
 
 #define COMPAT_PSR_F_BIT	0x00000040
@@ -197,11 +201,128 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
 }
 
+static void sappendf(char **p, size_t *size, char const *format, ...)
+{
+	va_list vl;
+	int n;
+
+	va_start(vl, format);
+	n = vsnprintf(*p, *size, format, vl);
+	va_end(vl);
+
+	if (n < 0 || (unsigned)n >= *size)
+		die("sappendf buffer too small");
+
+	*p += n;
+	*size -= n;
+}
+
+static void sappend_bytes(char **p, size_t *size,
+			   void const *bytes, size_t nbytes)
+{
+	unsigned char const *b = bytes;
+
+	while (nbytes--)
+		sappendf(p, size, "%.2x", *b++);
+}
+
+static void show_sve_zn_slice(int debug_fd, struct kvm_cpu const *vcpu,
+			      unsigned int n, unsigned int i)
+{
+	struct kvm_one_reg reg;
+	char bytes[256];
+	char str[2 * sizeof bytes + 9], *strp;
+	size_t strsz;
+
+	reg.id = KVM_REG_ARM64_SVE_ZREG(n, i);
+
+	assert((size_t)1 << ((reg.id & KVM_REG_SIZE_MASK) >>
+			     KVM_REG_SIZE_SHIFT) ==
+	       sizeof bytes);
+	reg.addr = (__u64)bytes;
+
+	strp = str;
+	strsz = sizeof str;
+
+	sappendf(&strp, &strsz, " Z%.2u/%.2u:", n, i);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		dprintf(debug_fd, "%s(%s)\n", str, strerror(errno));
+		if (vcpu->kvm->cfg.arch.has_sve)
+			die("Z-reg unexpectedly absent on SVE vcpu");
+
+		return;
+	}
+
+	if (!vcpu->kvm->cfg.arch.has_sve)
+		die("Z-reg unexpectedly present on non-SVE vcpu");
+
+	sappend_bytes(&strp, &strsz, bytes, sizeof bytes);
+	dprintf(debug_fd, "%s\n", str);
+}
+
+static void show_sve_zn(int debug_fd, struct kvm_cpu const *vcpu,
+			unsigned int n)
+{
+	show_sve_zn_slice(debug_fd, vcpu, n, 0);
+	show_sve_zn_slice(debug_fd, vcpu, n, 1);
+}
+
+static void show_sve_pn_slice(int debug_fd, struct kvm_cpu const *vcpu,
+			      unsigned int n, unsigned int i)
+{
+	struct kvm_one_reg reg;
+	char bytes[32];
+	char str[2 * sizeof bytes + 9], *strp;
+	size_t strsz;
+
+	reg.id = KVM_REG_ARM64_SVE_PREG(n, i);
+
+	assert((size_t)1 << ((reg.id & KVM_REG_SIZE_MASK) >>
+			     KVM_REG_SIZE_SHIFT) ==
+	       sizeof bytes);
+	reg.addr = (__u64)bytes;
+
+	strp = str;
+	strsz = sizeof str;
+
+	if (reg.id == KVM_REG_ARM64_SVE_FFR(i))
+		sappendf(&strp, &strsz, " FFR/%.2u:", i);
+	else
+		sappendf(&strp, &strsz, " P%.2u/%.2u:", n, i);
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		dprintf(debug_fd, "%s(%s)\n", str, strerror(errno));
+		if (vcpu->kvm->cfg.arch.has_sve)
+			die("P-reg unexpectedly absent on SVE vcpu");
+
+		return;
+	}
+
+	if (!vcpu->kvm->cfg.arch.has_sve)
+		die("P-reg unexpectedly present on non-SVE vcpu");
+
+	sappend_bytes(&strp, &strsz, bytes, sizeof bytes);
+	dprintf(debug_fd, "%s\n", str);
+}
+
+static void show_sve_pn(int debug_fd, struct kvm_cpu const *vcpu,
+			unsigned int n)
+{
+	show_sve_pn_slice(debug_fd, vcpu, n, 0);
+	show_sve_pn_slice(debug_fd, vcpu, n, 1);
+}
+
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
 	unsigned long data;
+	unsigned int data32;
 	int debug_fd = kvm_cpu__get_debug_fd();
+	unsigned int i;
+	char bytes[16];
+	unsigned long vqs[8];
+	char str[2 * sizeof vqs + 1], *strp;
+	size_t strsz;
 
 	reg.addr = (u64)&data;
 	dprintf(debug_fd, "\n Registers:\n");
@@ -225,4 +346,69 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
 		die("KVM_GET_ONE_REG failed (lr)");
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
+
+	reg.addr = (__u64)bytes;
+	for (i = 0; i < 32; ++i) {
+		reg.id = ARM64_CORE_REG(fp_regs.vregs[i]);
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+			dprintf(debug_fd, " V%.2u:   (%s)\n",
+				i, strerror(errno));
+		else {
+			strp = str;
+			strsz = sizeof str;
+			sappend_bytes(&strp, &strsz, bytes, 16);
+			dprintf(debug_fd, " V%.2u:   %s\n", i, str);
+		}
+	}
+
+	reg.addr = (__u64)&data32;
+
+	reg.id		= ARM64_CORE_REG(fp_regs.fpsr);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (fpsr)");
+	dprintf(debug_fd, " FPSR:  0x%x\n", data32);
+
+	reg.id		= ARM64_CORE_REG(fp_regs.fpcr);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (fpcr)");
+	dprintf(debug_fd, " FPCR:  0x%x\n", data32);
+
+	reg.id		= KVM_REG_ARM64_SVE_VLS;
+	assert((size_t)1 << ((reg.id & KVM_REG_SIZE_MASK) >>
+			     KVM_REG_SIZE_SHIFT) ==
+	       sizeof vqs);
+	reg.addr = (u64)&vqs;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		dprintf(debug_fd, " SVE_VLS:(%s)\n", strerror(errno));
+		if (vcpu->kvm->cfg.arch.has_sve)
+			die("SVE vcpu doesn't have KVM_REG_ARM64_SVE_VLS!");
+	} else {
+		if (!vcpu->kvm->cfg.arch.has_sve)
+			die("KVM_REG_ARM64_SVE_VLS present on non-SVE vcpu!");
+
+		strp = str;
+		strsz = sizeof str;
+		sappend_bytes(&strp, &strsz, vqs, sizeof vqs);
+		dprintf(debug_fd, " SVE_VLS:%s\n", str);
+	}
+
+	reg.addr = (__u64)&data;
+	reg.id = ARM64_SYS_REG(3, 0, 1, 2, 0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		dprintf(debug_fd, " ZCR_EL1:(%s)\n", strerror(errno));
+		if (vcpu->kvm->cfg.arch.has_sve)
+			die("ZCR_EL1 unexpectedly absent on SVE vcpu");
+	} else {
+		if (!vcpu->kvm->cfg.arch.has_sve)
+			die("ZCR_EL1 unexpectedly present on non-SVE vcpu");
+
+		dprintf(debug_fd, " ZCR_EL1:0x%lx\n", data);
+	}
+
+	for (i = 0; i < 32; ++i)
+		show_sve_zn(debug_fd, vcpu, i);
+
+	for (i = 0; i < 16 + 1 /*FFR*/; ++i)
+		show_sve_pn(debug_fd, vcpu, i);
 }
-- 
2.1.4
