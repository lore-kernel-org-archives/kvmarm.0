From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 03/17] arm64/kvm: hide ptrauth from guests
Date: Fri,  5 Oct 2018 09:47:40 +0100
Message-ID: <20181005084754.20950-4-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

In subsequent patches we're going to expose ptrauth to the host kernel
and userspace, but things are a bit trickier for guest kernels. For the
time being, let's hide ptrauth from KVM guests.

Regardless of how well-behaved the guest kernel is, guest userspace
could attempt to use ptrauth instructions, triggering a trap to EL2,
resulting in noise from kvm_handle_unknown_ec(). So let's write up a
handler for the PAC trap, which silently injects an UNDEF into the
guest, as if the feature were really missing.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[kristina: fix comment]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/handle_exit.c | 18 ++++++++++++++++++
 arch/arm64/kvm/sys_regs.c    |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e5e741bfffe1..53759b3c165d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -173,6 +173,23 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+/*
+ * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
+ * a NOP).
+ */
+static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/*
+	 * We don't currently support ptrauth in a guest, and we mask the ID
+	 * registers to prevent well-behaved guests from trying to make use of
+	 * it.
+	 *
+	 * Inject an UNDEF, as if the feature really isn't present.
+	 */
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -195,6 +212,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
+	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22fbbdbece3c..1ca592d38c3c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1040,6 +1040,14 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 			kvm_debug("SVE unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
+	} else if (id == SYS_ID_AA64ISAR1_EL1) {
+		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
+		if (val & ptrauth_mask)
+			kvm_debug("ptrauth unsupported for guests, suppressing\n");
+		val &= ~ptrauth_mask;
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
-- 
2.11.0
