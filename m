From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 04/17] arm64: Don't trap host pointer auth use to EL2
Date: Fri,  5 Oct 2018 09:47:41 +0100
Message-ID: <20181005084754.20950-5-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

To allow EL0 (and/or EL1) to use pointer authentication functionality,
we must ensure that pointer authentication instructions and accesses to
pointer authentication keys are not trapped to EL2.

This patch ensures that HCR_EL2 is configured appropriately when the
kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
ensuring that EL1 can access keys and permit EL0 use of instructions.
For VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
and it doesn't matter how we configure HCR_EL2.{API,APK}, so we don't
bother setting them.

This does not enable support for KVM guests, since KVM manages HCR_EL2
itself when running VMs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_arm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index f885f4e96002..1405bb24acac 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -24,6 +24,8 @@
 
 /* Hyp Configuration Register (HCR) bits */
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_API		(UL(1) << 41)
+#define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
 #define HCR_TERR	(UL(1) << 36)
 #define HCR_TLOR	(UL(1) << 35)
@@ -87,7 +89,7 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-#define HCR_HOST_NVHE_FLAGS (HCR_RW)
+#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
-- 
2.11.0
